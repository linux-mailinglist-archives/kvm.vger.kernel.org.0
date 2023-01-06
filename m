Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC02E65F8C8
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbjAFBNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbjAFBNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:34 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67771FC2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:33 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b002260d01b221so2088582pjp.8
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yz9E2DnzGU1LH62FYK53IVWLc/c5snlTFiIPiIg7gYk=;
        b=JgI8xYDcfH+1NRbV5JPQ/HsQ5Ob4bKUgvDUh7lrOmgE0/necFRjH5QYPhFaFmhgGMu
         OeU03FLmBpTYjyxCsPwWOd+H0+/nd+6aCbBGp+kM7XdoO2veu07K0u4DRTQxL3YoEUjj
         I/vg1qyC80S7VHKDBPcofn7cDZDkQd7Naam2HEj9c0pbitjBMUu/jOYZ6O/nt9996cvK
         XKfrs3+t4peZfihZtHDFI16/d/5TarxwGnwlSwg+fKowIWwi5FsSXShTDLj+IyWqsJaK
         UcscAhxeyQXWw2h8dHy2GwwYAG2whLIVwLsrUlv3j7pj3Juohy5MFxU+TSwuptAVGCr4
         mBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yz9E2DnzGU1LH62FYK53IVWLc/c5snlTFiIPiIg7gYk=;
        b=B09Y1VTs3AsE//7WwHMiYCv5pjZ1JqG58YnIe5X8XDvyCywIIleYUATJgOSFYwihAq
         dIsCnFHz4TDhRQfijlXXmdqAMSzX9LMMyEwy0Nfm5GB3uhg+iS8BF/07t0SfsUNL1ita
         utMK2QRW3K4emnO++f6CntOvvx+go49N94aGXEzPMJZEJG2yen69taLCnzkx98V102Rn
         oo+1CWpi4XIHpJqeOthccaPLepjCEM+/p2ZhCL5SaoSUMzs697OwIO8wZkf1HaJKGFML
         vHBiWIU63JWMkcUvOkJS7fcvIP2V7B0wX0d13fm/hNtytLACSISpgpV3HrikNsndJtMI
         QSuQ==
X-Gm-Message-State: AFqh2koYURmr5OenWFFiSqzVmpw5ZNXGZJy0346LOyySO/wsY9Sh9n2Q
        QUpo88j1VxxoLKkhzD3xoX7WpNFvjoM=
X-Google-Smtp-Source: AMrXdXuHIxc6PnZAKmk2gR51ZGTv0l6j0GP029d2lQWQ1BQcRYdeD6OI/qIctUPgNI4DYKgskKo57+QPfa8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5582:0:b0:481:b930:78dc with SMTP id
 j2-20020a655582000000b00481b93078dcmr2897762pgs.272.1672967613224; Thu, 05
 Jan 2023 17:13:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:44 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-12-seanjc@google.com>
Subject: [PATCH v5 11/33] KVM: SVM: Replace "avic_mode" enum with
 "x2avic_enabled" boolean
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the "avic_mode" enum with a single bool to track whether or not
x2AVIC is enabled.  KVM already has "apicv_enabled" that tracks if any
flavor of AVIC is enabled, i.e. AVIC_MODE_NONE and AVIC_MODE_X1 are
redundant and unnecessary noise.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 46 +++++++++++++++++++----------------------
 arch/x86/kvm/svm/svm.c  |  4 ++--
 arch/x86/kvm/svm/svm.h  |  9 +-------
 3 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0a75993afed6..10b0e996e2e3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -53,7 +53,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
-enum avic_modes avic_mode;
+bool x2avic_enabled;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -79,8 +79,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
 	 * AVIC in hybrid mode activates only the doorbell mechanism.
 	 */
-	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
-	    avic_mode == AVIC_MODE_X2) {
+	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
@@ -247,8 +246,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
+	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -262,8 +261,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
+	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
@@ -1066,10 +1065,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
-		return;
-
-	if (!enable_apicv)
+	if (!lapic_in_kernel(vcpu) || !enable_apicv)
 		return;
 
 	if (kvm_vcpu_apicv_active(vcpu)) {
@@ -1145,32 +1141,32 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
 	if (!npt_enabled)
 		return false;
 
+	/* AVIC is a prerequisite for x2AVIC. */
+	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
+		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
+			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
+		}
+		return false;
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AVIC)) {
-		avic_mode = AVIC_MODE_X1;
 		pr_info("AVIC enabled\n");
 	} else if (force_avic) {
 		/*
 		 * Some older systems does not advertise AVIC support.
 		 * See Revision Guide for specific AMD processor for more detail.
 		 */
-		avic_mode = AVIC_MODE_X1;
 		pr_warn("AVIC is not supported in CPUID but force enabled");
 		pr_warn("Your system might crash and burn");
 	}
 
 	/* AVIC is a prerequisite for x2AVIC. */
-	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
-		if (avic_mode == AVIC_MODE_X1) {
-			avic_mode = AVIC_MODE_X2;
-			pr_info("x2AVIC enabled\n");
-		} else {
-			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
-			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
-		}
-	}
+	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
+	if (x2avic_enabled)
+		pr_info("x2AVIC enabled\n");
 
-	if (avic_mode != AVIC_MODE_NONE)
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
-	return !!avic_mode;
+	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7651d665723e..9f172f2de195 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -813,7 +813,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (intercept == svm->x2avic_msrs_intercepted)
 		return;
 
-	if (avic_mode != AVIC_MODE_X2 ||
+	if (!x2avic_enabled ||
 	    !apic_x2apic_mode(svm->vcpu.arch.apic))
 		return;
 
@@ -5028,7 +5028,7 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
-	} else if (avic_mode == AVIC_MODE_X1) {
+	} else if (!x2avic_enabled) {
 		svm_x86_ops.allow_apicv_in_x2apic_without_x2apic_virtualization = true;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d0ed3f595229..546825c82490 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -35,14 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
-
-enum avic_modes {
-	AVIC_MODE_NONE = 0,
-	AVIC_MODE_X1,
-	AVIC_MODE_X2,
-};
-
-extern enum avic_modes avic_mode;
+extern bool x2avic_enabled;
 
 /*
  * Clean bits in VMCB.
-- 
2.39.0.314.g84b9a713c41-goog

