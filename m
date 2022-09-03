Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E564E5ABBC1
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiICAXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiICAXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88802F63E2
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k16-20020a635a50000000b0042986056df6so1873240pgm.2
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=GyZtyI6NBhU9EVA9XTEoU4+oyphkKSWqV6hEaozHlgk=;
        b=UmNeraoCzh/j9hAdWsAfDCHvbHAQK1rT1jW5eabzEAwj+oR90RJlvvK+ZDXFqqVPWN
         oimywkE1zOhR7IPXZe5ZUFs4BkFanFJJMgwJSXRda1cLhi8dnnPajRSb6YpezNR+LAtO
         S/yzF5RaX37/3httan0Pt5Y0WYzA/Gpmz1agA9CZvQNnDL4z+SmR7vvJ3nnby8MiD1/Y
         7Gi2pCuVN8aeypmBYiuzfONgO+mPS38yJDNYDqbe4QBbsqT/FmmKd9tID+/4L6X53LBD
         TkBvmU0QOyPS2LQczV4iFdSowKkCG5zQDggkESnEN372M56OKD+57PsfRvkWWKdiCj4B
         TpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=GyZtyI6NBhU9EVA9XTEoU4+oyphkKSWqV6hEaozHlgk=;
        b=ilcpWvNoRDcA5ldijwH3ys7chLAwZCgkwRi393RCYbQc+DjMRRaCrN6v4j53EIzp1x
         AqlLMhBnuUuu19OeQ8r7S+RJCNjJHBS1meRItC06iIhzifDlTqo/NfBWfpl4axktzJO5
         qIzUY0V9FkUMe+kR7ITtmggniXFckNdAFXu/NfI1zed7QhLvDsACCIk5DfQ/GV9RNiWR
         6UieX5iAFh2Xva8QwFKcP5fRoJhDFypdhLqE0NZ3G/M6f/kAv+jMDhYDSriSjtk+qgWT
         1vYLdcH+Q95s6WNpabXRGro8YYnNj684Y4dj/D57WE5EhxgwB3dhmQx8LhjRLJKhCFdl
         zhiA==
X-Gm-Message-State: ACgBeo2W4BM3faxdrUJ7kKsMv3LJ8XMegnHFc20BqqRBrjiBmJSr/Imu
        98Dln5hTiALJEx03qPmMhlhYtKUEuwE=
X-Google-Smtp-Source: AA6agR5HTMQ+UJMYjax5XO7UY8goDWmKzBzn3wDTAL//6tTCShEzqrb3FKi6aSPtEOwUXN7Rqu4FsGnP+8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c8:b0:174:a871:152d with SMTP id
 o8-20020a170902d4c800b00174a871152dmr28136076plg.4.1662164586136; Fri, 02 Sep
 2022 17:23:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:35 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-5-seanjc@google.com>
Subject: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU enables x2APIC
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

Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
to fix a bug where the APIC access page is visible to vCPUs that have
x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.

On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
enabled even without x2AVIC support, the bug occurs any time AVIC is
enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
that the guest is operating in x2APIC mode.

Opportunistically drop the "can" while updating avic_activate_vmcb()'s
comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
the "Note:" down a line to conform to preferred kernel/KVM multi-line
comment style.

Leave Intel as-is for now to avoid a subtle performance regression, even
though Intel likely suffers from the same bug.  On Intel, in theory the
bug rears its head only when vCPUs share host page tables (extremely
likely) and x2APIC enabling is not consistent within the guest, i.e. if
some vCPUs have x2APIC enabled and other does do not (unlikely to occur
except in certain situations, e.g. bringing up APs).

Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
Cc: stable@vger.kernel.org
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/lapic.c            |  4 +++-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm/avic.c         | 15 +++++++-------
 arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++----
 5 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..1fd1b66ceeb6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1132,6 +1132,15 @@ enum kvm_apicv_inhibit {
 	 * AVIC is disabled because SEV doesn't support it.
 	 */
 	APICV_INHIBIT_REASON_SEV,
+
+	/*
+	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
+	 * inhibited if any vCPU has x2APIC enabled.  Note, this is a "partial"
+	 * inhibit; APICv can still be activated, but KVM mustn't retain/create
+	 * SPTEs for the APIC access page.  Like the APIC ID and APIC base
+	 * inhibits, this is sticky for simplicity.
+	 */
+	APICV_INHIBIT_REASON_X2APIC,
 };
 
 struct kvm_arch {
@@ -1903,6 +1912,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
+bool kvm_apicv_memslot_activated(struct kvm *kvm);
 bool kvm_apicv_activated(struct kvm *kvm);
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 38e9b8e5278c..d956cd37908e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2394,8 +2394,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		}
 	}
 
-	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
+	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
+	}
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
 		kvm_vcpu_update_apicv(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..cea25552869f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4150,7 +4150,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * when the AVIC is re-enabled.
 		 */
 		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
+		    !kvm_apicv_memslot_activated(vcpu->kvm))
 			return RET_PF_EMULATE;
 	}
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6a3d225eb02c..19be5f1afaac 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -72,12 +72,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
-	/* Note:
-	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
-	 * MSR accesses, while interrupt injection to a running vCPU
-	 * can be achieved using AVIC doorbell. The AVIC hardware still
-	 * accelerate MMIO accesses, but this does not cause any harm
-	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
+	/*
+	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
+	 * accesses, while interrupt injection to a running vCPU can be
+	 * achieved using AVIC doorbell.  KVM disables the APIC access page
+	 * (prevents mapping it into the guest) if any vCPU has x2APIC enabled,
+	 * thus enabling AVIC activates only the doorbell mechanism.
 	 */
 	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
 	    avic_mode == AVIC_MODE_X2) {
@@ -1014,7 +1014,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..6ab9088c2531 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9379,15 +9379,29 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-bool kvm_apicv_activated(struct kvm *kvm)
+bool kvm_apicv_memslot_activated(struct kvm *kvm)
 {
 	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
 }
+
+static unsigned long kvm_apicv_get_inhibit_reasons(struct kvm *kvm)
+{
+	/*
+	 * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
+	 * APICv can continue to be utilized.
+	 */
+	return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~APICV_INHIBIT_REASON_X2APIC;
+}
+
+bool kvm_apicv_activated(struct kvm *kvm)
+{
+	return !kvm_apicv_get_inhibit_reasons(kvm);
+}
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
 {
-	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
+	ulong vm_reasons = kvm_apicv_get_inhibit_reasons(vcpu->kvm);
 	ulong vcpu_reasons = static_call(kvm_x86_vcpu_get_apicv_inhibit_reasons)(vcpu);
 
 	return (vm_reasons | vcpu_reasons) == 0;
@@ -10122,7 +10136,15 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	set_or_clear_apicv_inhibit(&new, reason, set);
 
-	if (!!old != !!new) {
+	/*
+	 * If the overall "is APICv activated" status is unchanged, simply add
+	 * or remove the inihbit from the pile.  x2APIC is an exception, as it
+	 * is a partial inhibit (only blocks SPTEs for the APIC access page).
+	 * If x2APIC is the only inhibit in either the old or the new set, then
+	 * vCPUs need to be kicked to transition between partially-inhibited
+	 * and fully-inhibited.
+	 */
+	if ((!!old != !!new) || old == X2APIC_ENABLE || new == X2APIC_ENABLE) {
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in svm_vcpu_run().
@@ -10137,7 +10159,12 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		 */
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 		kvm->arch.apicv_inhibit_reasons = new;
-		if (new) {
+
+		/*
+		 * Zap SPTEs for the APIC access page if APICv is newly
+		 * inhibited (partially or fully).
+		 */
+		if (new && !old) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
 		}
-- 
2.37.2.789.g6183377224-goog

