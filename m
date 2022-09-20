Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A505BF129
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiITXcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiITXcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E83786C5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u10-20020a056a00098a00b00543b3eb6416so2499683pfg.15
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=daNRJzX/JREQUCEW9Tnrc/vjVXi3u+32XbOCyfukabI=;
        b=oZoEOxrIg2Cb/LQyEFrcgWA8UjifAjhxgo/JuUqh5AqJRObHF7f071IDrG2cSLRG4d
         EIObmX5+dsHiCeuFs5e5VU5wSk8lBxjJg8fF8x+PROuHjQME1t8fnAQR0i9jSNuo07T3
         PjED3cuKruJPVnuDtjeky1jmJA8IilhP+4M0P1St+n7tlYp+q4PIGHgAbFf4NwBGMFxW
         LSdekTOigaVyvmbpmMDyRYmDugjOdiC2LpsRauwX5k/zS9R2h7VFNdlPaOqlOxOSbqDt
         AwqtLdKpiJ48t3UkbiN9akK6B91tjKhHCnJJzQjC0BWlKNUz2EUMOiQvrfgjd94jSuBL
         XMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=daNRJzX/JREQUCEW9Tnrc/vjVXi3u+32XbOCyfukabI=;
        b=qCLZouwBl7fVoqwW5/KrPjt6bwIb7/7Y/6BLCOiVmRHLc/aInFc/VQID8uo79Or7F5
         A8kTS77Vutrqs3yABj4sp7X0SMUgLm0ZKQRZ+Hc+OGZYJz6NeYOorOre0GjZhg4+sN/f
         V2nzXnZ/890Ox4nhq8wl+WDQJb4MqNYm3htuFD0if9xYTbnJ6aiXDI6X2HWnO7JFzQ+H
         4zKhcXQPv6yFg0IzdEGSkEpn7bZEVznXVjgoF7cxj2Em39m678cNG6ni1Yn4To7tr6Z3
         AgQoU2pQjRH9wsaRnRUIgsSdp77+5F7I4awXP9QZ3rjm3ATtFHIApvD1aPYTSXeliFBK
         thJg==
X-Gm-Message-State: ACrzQf1hlFczDfl5GfMQvjnIeZcH22y1ntHm4D9TXNLGNHv39BsBXuvE
        HYLLqNByAHSVH01yocSYKMy6hvBg+74=
X-Google-Smtp-Source: AMsMyM6uWCl4kNoV3CoPtI7HFSlEXJs2HKKzM+pubhPlFVaK5M1s7N3uS9+WCbm7x8fXXICu+ekQN1Mugns=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b8b:b0:178:7cf5:ad62 with SMTP id
 p11-20020a1709026b8b00b001787cf5ad62mr1939492plk.13.1663716713144; Tue, 20
 Sep 2022 16:31:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:15 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-10-seanjc@google.com>
Subject: [PATCH v3 09/28] KVM: SVM: Replace "avic_mode" enum with
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index 2aa5069bafb2..709f0b3e7a48 100644
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
2.37.3.968.ga6b4b080e4-goog

