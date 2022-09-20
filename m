Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15245BF124
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiITXcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiITXcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23760785B3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m131-20020a252689000000b006b2bf1dd88cso3557058ybm.19
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=wOK1dV4BxutQZkI1CAEnMvxBp2rHNValag/vPnSM224=;
        b=oywBzOfXG4T/q5tSWB026gI+PUcT8WGunFspJ0GfPCZ37ekwojWgGKj3t8cANpK6M2
         Irpozhmk7IebqY6T7jS0d2SZ+cihG6P/YZK0DqnNthQM1bL2PRTfApG+MvAuh/5fDrjC
         zhZ7kI+5a+SIO6585LLfNOgQOOSoe4C9agdyFvoQ0fQiK6hH1sKLrld0vTA3DBKoNcux
         tIM7mnbuaRZsqs/kPUPVvV9CCwZrlMtf+DVqN08YlzkwYvx9Y3R2E+6P36LGYu02tlLc
         KDalgOglp/hZ1fWS8Kg4tKVLK6cTcBjXJ3PD0qv91B5BF/klbmHg7koP4tf6Nq6VUj1G
         ic1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=wOK1dV4BxutQZkI1CAEnMvxBp2rHNValag/vPnSM224=;
        b=QzW+6bB5axlFFVCLXjoftuWLZ6s4lyvOj2ZI8unZDAVK8e6asiLPd6PWt4PPHX6OK0
         OSRJV88qocMuylTjocLeUMXil8je4+gxTTwIaI1dzOSdmDLJ/M+mVLBpxwnSfDg1A0vJ
         cwV6uffn+72TsjB08hMG+vErwP+kwMpp4bPWZzdoN/FW9eWSv8k64HcBAyc6JUSiGXGi
         N4RcQxDN2aqoSRind55/rqaQVbfLELADZqtu9p7ZnDNDU9qqgaVPeZJOFXj/rK1htG8T
         wqdf832UUWlLEPN6ivTUB7f9T13udRfTNBcxdsufrMuMijVIEtcONecF7FBDXfIBMG/L
         Outw==
X-Gm-Message-State: ACrzQf1CVKdn63Me7Uk6J7ecJukmMDHoaPfn01J9SVd9cOEiOUbejNJ2
        uIn1gXsjE+UV8/H8+TN4lN9xq2/yO2Q=
X-Google-Smtp-Source: AMsMyM7pQ9k+3HOSGUAj7YGWwY4pwBtf/NqzJ+ZJR2MI+jHpu6MKWobBy75VSgV3AjqkwLDXln0MtXBJU0c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef4f:0:b0:6ae:f5ce:91e8 with SMTP id
 w15-20020a25ef4f000000b006aef5ce91e8mr21952346ybm.280.1663716709400; Tue, 20
 Sep 2022 16:31:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:13 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-8-seanjc@google.com>
Subject: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and AVIC
 are enabled
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

Free the APIC access page memslot if any vCPU enables x2APIC and SVM's
AVIC is enabled to prevent accesses to the virtual APIC on vCPUs with
x2APIC enabled.   On AMD, due to its "hybrid" mode where AVIC is enabled
when x2APIC is enabled even without x2AVIC support, keeping the APIC
access page memslot results in the guest being able to access the virtual
APIC page as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
that the guest is operating in x2APIC mode.

Intel doesn't suffer from the same issue as APICv has fully independent
VMCS controls for xAPIC vs. x2APIC virtualization.  Technically, KVM
should provide bus error semantics and not memory semantics for the APIC
page when x2APIC is enabled, but KVM already provides memory semantics in
other scenarios, e.g. if APICv/AVIC is enabled and the APIC is hardware
disabled (via APIC_BASE MSR).

Reserve an inhibit bit so that common code can detect whether or not the
"x2APIC inhibit" applies, but use a dedicated flag to track the inhibit
so that it doesn't need to be stripped from apicv_inhibit_reasons (since
it's not a "full" inhibit).

Note, setting apic_access_memslot_inhibited without taking locks relies
on it being sticky, and also relies on apic_access_memslot_enabled being
set during vCPU creation (before kvm_vcpu_reset()).  vCPUs can race to
set the inhibit and delete the memslot, i.e. can get false positives, but
can't false negatives as apic_access_memslot_enabled can't be toggle "on"
once any vCPU reaches kvm_lapic_set_base().

Opportunistically drop the "can" while updating avic_activate_vmcb()'s
comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
the "Note:" down a line to conform to preferred kernel/KVM multi-line
comment style.

Opportunistically update the apicv_update_lock comment, as it isn't
actually used to protect apic_access_memslot_enabled (it's protected by
slots_lock).

Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 18 ++++++++++++++---
 arch/x86/kvm/lapic.c            | 34 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/svm/avic.c         | 15 ++++++++-------
 arch/x86/kvm/x86.c              |  7 +++++++
 5 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..6475c882b359 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1132,6 +1132,17 @@ enum kvm_apicv_inhibit {
 	 * AVIC is disabled because SEV doesn't support it.
 	 */
 	APICV_INHIBIT_REASON_SEV,
+
+	/*
+	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
+	 * deleted if any vCPU has x2APIC enabled as SVM doesn't provide fully
+	 * independent controls for AVIC vs. x2AVIC, and also because SVM
+	 * supports a "hybrid" AVIC mode for CPUs that support AVIC but not
+	 * x2AVIC.  Note, this isn't a "full" inhibit and is tracked separately.
+	 * AVIC can still be activated, but KVM must not create SPTEs for the
+	 * APIC base.  For simplicity, this is sticky.
+	 */
+	APICV_INHIBIT_REASON_X2APIC,
 };
 
 struct kvm_arch {
@@ -1169,10 +1180,11 @@ struct kvm_arch {
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
 
-	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
-	struct rw_semaphore apicv_update_lock;
-
 	bool apic_access_memslot_enabled;
+	bool apic_access_memslot_inhibited;
+
+	/* Protects apicv_inhibit_reasons */
+	struct rw_semaphore apicv_update_lock;
 	unsigned long apicv_inhibit_reasons;
 
 	gpa_t wall_clock;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 99994d2470a2..70f00eda75b2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2394,9 +2394,26 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		}
 	}
 
-	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
+	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
+		/*
+		 * Mark the APIC memslot as inhibited if x2APIC is enabled and
+		 * the x2APIC inhibit is required.  The actual deletion of the
+		 * memslot is handled by vcpu_run() as SRCU may or may not be
+		 * held at this time, i.e. updating memslots isn't safe.  Don't
+		 * check apic_access_memslot_inhibited, this vCPU needs to
+		 * ensure the memslot is deleted before re-entering the guest,
+		 * i.e. needs to make the request even if the inhibit flag was
+		 * already set by a different vCPU.
+		 */
+		if (vcpu->kvm->arch.apic_access_memslot_enabled &&
+		    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC)) {
+			vcpu->kvm->arch.apic_access_memslot_inhibited = true;
+			kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+		}
+	}
+
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
 		kvm_vcpu_update_apicv(vcpu);
 		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
@@ -2440,7 +2457,8 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_memslot_enabled)
+	if (kvm->arch.apic_access_memslot_enabled ||
+	    kvm->arch.apic_access_memslot_inhibited)
 		goto out;
 
 	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
@@ -2468,6 +2486,18 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
 
+void kvm_free_apic_access_page(struct kvm *kvm)
+{
+	mutex_lock(&kvm->slots_lock);
+
+	if (kvm->arch.apic_access_memslot_enabled) {
+		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
+		kvm->arch.apic_access_memslot_enabled = false;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+}
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6d06397683d0..e2271ffa7ac0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -112,6 +112,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 int kvm_alloc_apic_access_page(struct kvm *kvm);
+void kvm_free_apic_access_page(struct kvm *kvm);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0424a5e664bb..8f9426f21bbf 100644
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
+	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
+	 * AVIC in hybrid mode activates only the doorbell mechanism.
 	 */
 	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
 	    avic_mode == AVIC_MODE_X2) {
@@ -987,7 +987,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..aa5ab0c620de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10705,6 +10705,13 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		if (vcpu->kvm->arch.apic_access_memslot_inhibited &&
+		    vcpu->kvm->arch.apic_access_memslot_enabled) {
+			kvm_vcpu_srcu_read_unlock(vcpu);
+			kvm_free_apic_access_page(vcpu->kvm);
+			kvm_vcpu_srcu_read_lock(vcpu);
+		}
+
 		if (__xfer_to_guest_mode_work_pending()) {
 			kvm_vcpu_srcu_read_unlock(vcpu);
 			r = xfer_to_guest_mode_handle_work(vcpu);
-- 
2.37.3.968.ga6b4b080e4-goog

