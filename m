Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D1201159
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393986AbgFSPka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:40:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39473 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393976AbgFSPkS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K6lFoPOHJ7Pu1UtwVIoxA6fqrmd3aVIVY37LXOcNqqc=;
        b=fL3853pHpjVMn2vYczavy8JYpHrKBFSjzIcbNt2y5mCSY29IwzsOVdJCkMPR0YusclBMCB
        oFDxZIYBtqLQbZl/OlkBOQX3vCgjnD94eF/W/5gHduBOKvimeThZKdXRnBOP8krJ5EDiPb
        0lXR1Cj1xAEa7gsrkDQaYw+N1PnJsv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-Jd7MFNOkP-edmSFQ4kiXmQ-1; Fri, 19 Jun 2020 11:40:15 -0400
X-MC-Unique: Jd7MFNOkP-edmSFQ4kiXmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41E74108BD10;
        Fri, 19 Jun 2020 15:40:14 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CA8660BF4;
        Fri, 19 Jun 2020 15:40:09 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 10/11] KVM: SVM: Add guest physical address check in NPF/PF interception
Date:   Fri, 19 Jun 2020 17:39:24 +0200
Message-Id: <20200619153925.79106-11-mgamal@redhat.com>
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

Similar ot VMX, this has to be done both in the NPF and page fault interceptions,
as there are complications in both cases with respect to the computation
of the correct error code.

For NPF interceptions, unfortunately the only possibility is to emulate,
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

CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Babu Moger <babu.moger@amd.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05412818027d..ec3224a2e7c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1702,6 +1702,12 @@ static int pf_interception(struct vcpu_svm *svm)
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	if (npt_enabled && !svm->vcpu.arch.apf.host_apf_flags) {
+		kvm_fixup_and_inject_pf_error(&svm->vcpu,
+					fault_address, error_code);
+		return 1;
+	}
+
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
@@ -1714,6 +1720,11 @@ static int npf_interception(struct vcpu_svm *svm)
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);
+
+	/* Check if guest gpa doesn't exceed physical memory limits */
+	if (unlikely(kvm_mmu_is_illegal_gpa(&svm->vcpu, fault_address)))
+		return kvm_emulate_instruction(&svm->vcpu, 0);
+
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2b7469f3db0e..12b502e36dbd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,7 +348,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 static inline bool svm_need_pf_intercept(struct vcpu_svm *svm)
 {
-        return !npt_enabled;
+        return !npt_enabled || cpuid_maxphyaddr(&svm->vcpu) < boot_cpu_data.x86_phys_bits;
 }
 
 /* svm.c */
-- 
2.26.2

