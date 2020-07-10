Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AA821B9E6
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgGJPss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728188AbgGJPsq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 11:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0rffyJd31ccusntTysy3wmiDQXTPQoxGgMle8w2Tcs=;
        b=bWliAGI5zNMVKW2awoDIlgnACsMwLTaluG6b8EsPsrLhRaOFWJ/RgpSVCO4d4WbwrNG3oH
        StNIV0W5UoSzUEem4lfQ6HwH9SHRuaLLEWUYKP9aC2QdGD1F/MN+rPdihECvcZIL7CsHRG
        Yru17aR4XbSetwxaKWsxhxs3Hk/TpUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-6UElIXvtOq-tcNBt4903wA-1; Fri, 10 Jul 2020 11:48:43 -0400
X-MC-Unique: 6UElIXvtOq-tcNBt4903wA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C70A21083;
        Fri, 10 Jul 2020 15:48:41 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD3995BAC3;
        Fri, 10 Jul 2020 15:48:36 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT violation and misconfig
Date:   Fri, 10 Jul 2020 17:48:09 +0200
Message-Id: <20200710154811.418214-8-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check guest physical address against it's maximum physical memory. If
the guest's physical address exceeds the maximum (i.e. has reserved bits
set), inject a guest page fault with PFERR_RSVD_MASK set.

This has to be done both in the EPT violation and page fault paths, as
there are complications in both cases with respect to the computation
of the correct error code.

For EPT violations, unfortunately the only possibility is to emulate,
because the access type in the exit qualification might refer to an
access to a paging structure, rather than to the access performed by
the program.

Trapping page faults instead is needed in order to correct the error code,
but the access type can be obtained from the original error code and
passed to gva_to_gpa.  The corrections required in the error code are
subtle. For example, imagine that a PTE for a supervisor page has a reserved
bit set.  On a supervisor-mode access, the EPT violation path would trigger.
However, on a user-mode access, the processor will not notice the reserved
bit and not include PFERR_RSVD_MASK in the error code.

Co-developed-by: Mohammed Gamal <mgamal@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h |  3 ++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 770b090969fb..de3f436b2d32 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4790,9 +4790,15 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 	if (is_page_fault(intr_info)) {
 		cr2 = vmx_get_exit_qual(vcpu);
-		/* EPT won't cause page fault directly */
-		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_flags && enable_ept);
-		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
+		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
+			/*
+			 * EPT will cause page fault only if we need to
+			 * detect illegal GPAs.
+			 */
+			kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
+			return 1;
+		} else
+			return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
 	}
 
 	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
@@ -5308,6 +5314,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+
+	/*
+	 * Check that the GPA doesn't exceed physical memory limits, as that is
+	 * a guest page fault.  We have to emulate the instruction here, because
+	 * if the illegal address is that of a paging structure, then
+	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
+	 * would also use advanced VM-exit information for EPT violations to
+	 * reconstruct the page fault error code.
+	 */
+	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
+		return kvm_emulate_instruction(vcpu, 0);
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b0e5e210f1c1..0d06951e607c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 #include "kvm_cache_regs.h"
 #include "ops.h"
 #include "vmcs.h"
+#include "cpuid.h"
 
 extern const u32 vmx_msr_index[];
 
@@ -552,7 +553,7 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 
 static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 {
-	return !enable_ept;
+	return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
 }
 
 void dump_vmcs(void);
-- 
2.26.2

