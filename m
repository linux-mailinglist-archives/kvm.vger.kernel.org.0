Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3693B5A72B1
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiHaAhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiHaAgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:47 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B176642E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:33 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 14-20020a056a00072e00b0053689e4d0e5so5206298pfm.5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=mX7gyqny3Tfi3l5wYUlNtjVwLiCm3GoN1j+pJxyWtuI=;
        b=aOIR+bnOBR/m2wjECFEj/WCR6Iex06DA6bl6u0ay9A3rH0yaiB3Gwrw0c0JdUAg4pk
         a5Zsf8lm7I5opc/Fe3Ch4FIhUdzGmApI5POeo/awiCPP+3c1CDeYCz5cVHiCA+1XR8SN
         6zUtraj3lDDLRZg47Qt+Mocy8EOhj1WcrJnztogOCLT2ikJjI+LBAPZTFF/K7a01zxO3
         tTaHyifeS/YrDdYSTzsvKcek2bAM3k2OxS18qQLZbgwKiU3WVssXUyRN4WvU8mZd4JVX
         037n3XcFQtEzkHW99gt6+1a9tYIBe2xv9fdJ3vuPvSLUxgebsTugWcJGmQajg0Xd28rh
         zAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=mX7gyqny3Tfi3l5wYUlNtjVwLiCm3GoN1j+pJxyWtuI=;
        b=oGZRei7xBxSM8YgpNPAqJRBxQBUksaNVMGfKA3D3EomO3A0WYheEnCc8FVoLVl2ZBu
         fUZO4sF2t3qSyfKbGOI1nYnTwk6Dn7KWEwqHjmk+RuBfUfMRZeN6y083rEMzmkYP1fq2
         uoaVyWNtOttNqjqg/nx4qteO+JpCds+9572Y9o5UoRjFLcOdrqoyZ2o0Sv7+p+eNx0PC
         twBAOg3QNjU7C51orBHMHhJ1zfNh9WwoaglR05x1LgeoLdfH2/m65xSlbTx4SqCsaBjZ
         wixgHrNfNvawPwD6b2ccFxD4U7hnCIUptDuTsv7WoE33/T/vnEcUwebVsmyHk0bzYThN
         fnOA==
X-Gm-Message-State: ACgBeo1dyaOwgAEwdpsCxqdSFRbJx/c2yfrfqbl8GKaCk70IS/oVs2Be
        DhMPN1rak1K2BcnQo4Bhyiye+SmwLzQ=
X-Google-Smtp-Source: AA6agR621EBsP9klM5mRGg0nudFLN7q4PGXuQMjyAE/iNkBpVhHcd2OyCcViTcGilbEelZDISSKI0nrGQFY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f782:b0:173:1206:cee0 with SMTP id
 q2-20020a170902f78200b001731206cee0mr23385654pln.130.1661906116336; Tue, 30
 Aug 2022 17:35:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:51 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-5-seanjc@google.com>
Subject: [PATCH 04/19] KVM: SVM: Replace "avic_mode" enum with
 "x2avic_enabled" boolean
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/svm/avic.c | 45 +++++++++++++++++++----------------------
 arch/x86/kvm/svm/svm.c  |  2 +-
 arch/x86/kvm/svm/svm.h  |  9 +--------
 3 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1d516d658f9a..b59f8ee2671f 100644
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
@@ -231,8 +231,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
+	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -279,8 +279,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
+	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
@@ -532,7 +532,7 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 	 * AVIC must be disabled if x2AVIC isn't supported and the guest has
 	 * x2APIC enabled.
 	 */
-	if (avic_mode != AVIC_MODE_X2 && apic_x2apic_mode(vcpu->arch.apic))
+	if (!x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
 		return APICV_INHIBIT_REASON_X2APIC;
 
 	return 0;
@@ -1086,10 +1086,7 @@ void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
-		return;
-
-	if (!enable_apicv)
+	if (!lapic_in_kernel(vcpu) || !enable_apicv)
 		return;
 
 	if (kvm_vcpu_apicv_active(vcpu)) {
@@ -1165,32 +1162,32 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index f3813dbacb9f..b25c89069128 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -821,7 +821,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (intercept == svm->x2avic_msrs_intercepted)
 		return;
 
-	if (avic_mode != AVIC_MODE_X2 ||
+	if (!x2avic_enabled ||
 	    !apic_x2apic_mode(svm->vcpu.arch.apic))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..cee79ade400a 100644
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
2.37.2.672.g94769d06f0-goog

