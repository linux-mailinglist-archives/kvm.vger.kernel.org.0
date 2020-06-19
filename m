Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C2201152
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393909AbgFSPkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:40:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393881AbgFSPkI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:40:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fB1uk4/fHg1pONPIZUs3iELz0bFztaTBbXpdlq2I9I=;
        b=ZUyKtxJeAxssXlZX2Ra/RfhY2BAZ2uHRo13PzoT035jjjkKqFA+VE3T15s3ecNk99PMexe
        EksZdfoIOBot8fNSt3BV9vzi0NtO3p9xTgf0RB3B/Ijwv7oP08QMzvChUqz8SdDC7qfvbM
        QVsfYHxhp/5h6cJPc3f1IIPxBoVd/hU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-6wMsuaVxO6mDlnE-bTNTFQ-1; Fri, 19 Jun 2020 11:40:05 -0400
X-MC-Unique: 6wMsuaVxO6mDlnE-bTNTFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5E4F18A822E;
        Fri, 19 Jun 2020 15:40:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CF2660BF4;
        Fri, 19 Jun 2020 15:39:57 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 07/11] KVM: VMX: Add guest physical address check in EPT violation and misconfig
Date:   Fri, 19 Jun 2020 17:39:21 +0200
Message-Id: <20200619153925.79106-8-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 46d522ee5cb1..f38cbadcb3a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4793,9 +4793,15 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
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
@@ -5311,6 +5317,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
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
index 5e2da15fe94f..950ecf237558 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 #include "kvm_cache_regs.h"
 #include "ops.h"
 #include "vmcs.h"
+#include "cpuid.h"
 
 extern const u32 vmx_msr_index[];
 
@@ -554,7 +555,7 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 
 static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 {
-	return !enable_ept;
+	return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
 }
 
 void dump_vmcs(void);
-- 
2.26.2

