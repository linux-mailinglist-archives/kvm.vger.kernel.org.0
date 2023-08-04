Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA477073B
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjHDRe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjHDRez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:34:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF354C1F
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691170442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+5iGrXN/5qdcupU2kFFOdWOZ5R3AF1zigPe0QKATHc=;
        b=W/HgdlqAHEQJUmPZnY1h4RaqueXeUU7EHcD4mkT6QzWsVcfR6zvGipf27PHqMtS/BTc0MO
        NX1+RGmhlmS0LXAUsJWQUBrb1aVBYclH+iQJL7zUy5PUDtDfW//zb5llO5WbyAabEjE1KK
        CLRrDtD4fM3DkSH95hr5qG+K7DTqWqM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-Heo_cFpkPs-QlfcK7Lud1Q-1; Fri, 04 Aug 2023 13:33:57 -0400
X-MC-Unique: Heo_cFpkPs-QlfcK7Lud1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF46B8DC663;
        Fri,  4 Aug 2023 17:33:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86600C5796B;
        Fri,  4 Aug 2023 17:33:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: SEV: snapshot the GHCB before accessing it
Date:   Fri,  4 Aug 2023 13:33:53 -0400
Message-Id: <20230804173355.51753-2-pbonzini@redhat.com>
In-Reply-To: <20230804173355.51753-1-pbonzini@redhat.com>
References: <20230804173355.51753-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Validation of the GHCB is susceptible to time-of-check/time-of-use vulnerabilities.
To avoid them, we would like to always snapshot the fields that are read in
sev_es_validate_vmgexit(), and not use the GHCB anymore after it returns.

This means:

- invoking sev_es_sync_from_ghcb() before any GHCB access, including before
  sev_es_validate_vmgexit()

- snapshotting all fields including the valid bitmap and the sw_scratch field,
  which are currently not caching anywhere.

The valid bitmap is the first thing to be copied out of the GHCB; then,
further accesses will use the copy in svm->sev_es.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 69 +++++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++
 2 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07756b7348ae..e898f0b2b0ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2417,15 +2417,18 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	 */
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
 
-	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RBX] = ghcb_get_rbx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RCX] = ghcb_get_rcx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RSI] = ghcb_get_rsi_if_valid(ghcb);
+	BUILD_BUG_ON(sizeof(svm->sev_es.valid_bitmap) != sizeof(ghcb->save.valid_bitmap));
+	memcpy(&svm->sev_es.valid_bitmap, &ghcb->save.valid_bitmap, sizeof(ghcb->save.valid_bitmap));
 
-	svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RAX] = kvm_ghcb_get_rax_if_valid(svm, ghcb);
+	vcpu->arch.regs[VCPU_REGS_RBX] = kvm_ghcb_get_rbx_if_valid(svm, ghcb);
+	vcpu->arch.regs[VCPU_REGS_RCX] = kvm_ghcb_get_rcx_if_valid(svm, ghcb);
+	vcpu->arch.regs[VCPU_REGS_RDX] = kvm_ghcb_get_rdx_if_valid(svm, ghcb);
+	vcpu->arch.regs[VCPU_REGS_RSI] = kvm_ghcb_get_rsi_if_valid(svm, ghcb);
 
-	if (ghcb_xcr0_is_valid(ghcb)) {
+	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
+
+	if (kvm_ghcb_xcr0_is_valid(svm)) {
 		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
 		kvm_update_cpuid_runtime(vcpu);
 	}
@@ -2436,6 +2439,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	control->exit_code_hi = upper_32_bits(exit_code);
 	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
 	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
+	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm, ghcb);
 
 	/* Clear the valid entries fields */
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
@@ -2464,56 +2468,56 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 	reason = GHCB_ERR_MISSING_INPUT;
 
-	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
-	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
-	    !ghcb_sw_exit_info_2_is_valid(ghcb))
+	if (!kvm_ghcb_sw_exit_code_is_valid(svm) ||
+	    !kvm_ghcb_sw_exit_info_1_is_valid(svm) ||
+	    !kvm_ghcb_sw_exit_info_2_is_valid(svm))
 		goto vmgexit_err;
 
 	switch (ghcb_get_sw_exit_code(ghcb)) {
 	case SVM_EXIT_READ_DR7:
 		break;
 	case SVM_EXIT_WRITE_DR7:
-		if (!ghcb_rax_is_valid(ghcb))
+		if (!kvm_ghcb_rax_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_EXIT_RDTSC:
 		break;
 	case SVM_EXIT_RDPMC:
-		if (!ghcb_rcx_is_valid(ghcb))
+		if (!kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_EXIT_CPUID:
-		if (!ghcb_rax_is_valid(ghcb) ||
-		    !ghcb_rcx_is_valid(ghcb))
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		if (ghcb_get_rax(ghcb) == 0xd)
-			if (!ghcb_xcr0_is_valid(ghcb))
+			if (!kvm_ghcb_xcr0_is_valid(svm))
 				goto vmgexit_err;
 		break;
 	case SVM_EXIT_INVD:
 		break;
 	case SVM_EXIT_IOIO:
 		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK) {
-			if (!ghcb_sw_scratch_is_valid(ghcb))
+			if (!kvm_ghcb_sw_scratch_is_valid(svm))
 				goto vmgexit_err;
 		} else {
 			if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
-				if (!ghcb_rax_is_valid(ghcb))
+				if (!kvm_ghcb_rax_is_valid(svm))
 					goto vmgexit_err;
 		}
 		break;
 	case SVM_EXIT_MSR:
-		if (!ghcb_rcx_is_valid(ghcb))
+		if (!kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		if (ghcb_get_sw_exit_info_1(ghcb)) {
-			if (!ghcb_rax_is_valid(ghcb) ||
-			    !ghcb_rdx_is_valid(ghcb))
+			if (!kvm_ghcb_rax_is_valid(svm) ||
+			    !kvm_ghcb_rdx_is_valid(svm))
 				goto vmgexit_err;
 		}
 		break;
 	case SVM_EXIT_VMMCALL:
-		if (!ghcb_rax_is_valid(ghcb) ||
-		    !ghcb_cpl_is_valid(ghcb))
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_cpl_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_EXIT_RDTSCP:
@@ -2521,19 +2525,19 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_EXIT_WBINVD:
 		break;
 	case SVM_EXIT_MONITOR:
-		if (!ghcb_rax_is_valid(ghcb) ||
-		    !ghcb_rcx_is_valid(ghcb) ||
-		    !ghcb_rdx_is_valid(ghcb))
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rcx_is_valid(svm) ||
+		    !kvm_ghcb_rdx_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_EXIT_MWAIT:
-		if (!ghcb_rax_is_valid(ghcb) ||
-		    !ghcb_rcx_is_valid(ghcb))
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_MMIO_READ:
 	case SVM_VMGEXIT_MMIO_WRITE:
-		if (!ghcb_sw_scratch_is_valid(ghcb))
+		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
@@ -2563,9 +2567,6 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	/* Clear the valid entries fields */
-	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
-
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, reason);
 
@@ -2586,7 +2587,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 		 */
 		if (svm->sev_es.ghcb_sa_sync) {
 			kvm_write_guest(svm->vcpu.kvm,
-					ghcb_get_sw_scratch(svm->sev_es.ghcb),
+					svm->sev_es.sw_scratch,
 					svm->sev_es.ghcb_sa,
 					svm->sev_es.ghcb_sa_len);
 			svm->sev_es.ghcb_sa_sync = false;
@@ -2637,7 +2638,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
 
-	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
+	scratch_gpa_beg = svm->sev_es.sw_scratch;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
 		goto e_scratch;
@@ -2853,11 +2854,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
+	sev_es_sync_from_ghcb(svm);
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
 
-	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 18af7e712a5a..8239c8de45ac 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -190,10 +190,12 @@ struct vcpu_sev_es_state {
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
 	struct ghcb *ghcb;
+	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
 
 	/* SEV-ES scratch area support */
+	u64 sw_scratch;
 	void *ghcb_sa;
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
@@ -744,4 +746,28 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 
+#define DEFINE_KVM_GHCB_ACCESSORS(field)						\
+	static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm) \
+	{									\
+		return test_bit(GHCB_BITMAP_IDX(field),				\
+				(unsigned long *)&svm->sev_es.valid_bitmap);	\
+	}									\
+										\
+	static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm, struct ghcb *ghcb) \
+	{									\
+		return kvm_ghcb_##field##_is_valid(svm) ? ghcb->save.field : 0;	\
+	}									\
+
+DEFINE_KVM_GHCB_ACCESSORS(cpl)
+DEFINE_KVM_GHCB_ACCESSORS(rax)
+DEFINE_KVM_GHCB_ACCESSORS(rcx)
+DEFINE_KVM_GHCB_ACCESSORS(rdx)
+DEFINE_KVM_GHCB_ACCESSORS(rbx)
+DEFINE_KVM_GHCB_ACCESSORS(rsi)
+DEFINE_KVM_GHCB_ACCESSORS(sw_exit_code)
+DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
+DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
+DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
+DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+
 #endif
-- 
2.39.0


