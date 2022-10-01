Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239D35F17C9
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbiJABAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiJABAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D444D12AEC
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:40 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u10-20020a056a00098a00b00543b3eb6416so3628891pfg.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=gG4JQbu2ViZJSn6XOJHk3K+AtrYE4frOHCXu3F3JspI=;
        b=S0qjejtKw0HK2e+AB+To4s2tvxXU5eNChD9TYG2Ljm1vwTblAWSbJnuewazormj+pb
         ig8PJnzi04D0ykNJNIDmRz5DX9gQsdB3KUxDXSaWY7kor7KmXMt/P3S2LNKA75vSx4TN
         JFLa4t9LI/gvHr/+c9x7kCXLNkNzkYngX47S6nzmTgoywrleBIArCIJHbS6qa1bjGV9R
         n6FvofnNhqCpWeYCirfply+3sMSrJA5Mp9olNfgtmHBne38e2/MhdUEJoduqbpOi2md2
         Nfi3RyjxzchlveBapqT+f2eMkaJE6f4P4BFBOcnxmM80sL3SZo/Hdr/UoosUpK79Aow/
         kIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=gG4JQbu2ViZJSn6XOJHk3K+AtrYE4frOHCXu3F3JspI=;
        b=qpvFqtfJX7w2dWQALNRqBuGsdMbtsYoLAlzz5v976rvazOZQQIS2wBYPf5wdWJpgD4
         53p79rm215bnJ93oZ8QDFRx7ya+MNlvpiAJS28JzIZS9VEgf3DJmAHuXIWjbcXWxNPvo
         Q/JzWkq9A0PMkLBKK8i5lA/HeAvTG+QlOnsfVKOJ49MuYeyZ9uIE0F9lKGvrQDRHfp/F
         x3vLo2K5hc2Lx9I5b6JeEsyqhtg0MPTsbha7x1iJ80enP4zlCpjmFd8HFfqSE7orQ2E8
         N1QMK0zgDedsDgejrP8p03jqA7F696HcavrWOQ0LaPJ4YuTtUeSxY2yM2N3F/AV1KT47
         TdQw==
X-Gm-Message-State: ACrzQf37aBE/k1A9l7/dIPdWEclYk2U4c9YLRwLUX4SCVd2AQD1KMTEh
        Jr70BZFf+8h/1V1MkDlMP2yO3sNFh0E=
X-Google-Smtp-Source: AMsMyM7t1ljaJWmMRhqt5l5lnvlzonOLlepWoWn5KB7qTUB3ENH79KZ9q6fjv44yAx5MIQ5Fvo9qaV7RJiY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3912:b0:203:c0a0:f582 with SMTP id
 ob18-20020a17090b391200b00203c0a0f582mr971876pjb.141.1664585978962; Fri, 30
 Sep 2022 17:59:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:55 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-13-seanjc@google.com>
Subject: [PATCH v4 12/32] KVM: SVM: Replace "avic_mode" enum with
 "x2avic_enabled" boolean
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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
 arch/x86/kvm/svm/svm.c  |  2 +-
 arch/x86/kvm/svm/svm.h  |  9 +-------
 3 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 535e35edce1d..84beef0edae3 100644
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
@@ -1067,10 +1066,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
-		return;
-
-	if (!enable_apicv)
+	if (!lapic_in_kernel(vcpu) || !enable_apicv)
 		return;
 
 	if (kvm_vcpu_apicv_active(vcpu)) {
@@ -1146,32 +1142,32 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index afae97ea9a06..37fe7bcf8496 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -819,7 +819,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (intercept == svm->x2avic_msrs_intercepted)
 		return;
 
-	if (avic_mode != AVIC_MODE_X2 ||
+	if (!x2avic_enabled ||
 	    !apic_x2apic_mode(svm->vcpu.arch.apic))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7a95f50e80e7..29c334a932c3 100644
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
2.38.0.rc1.362.ged0d419d3c-goog

