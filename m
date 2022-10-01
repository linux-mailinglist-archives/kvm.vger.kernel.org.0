Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA4C5F17C6
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiJABAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiJABAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190122BDA
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p24-20020a63f458000000b0043cd718c49dso3721198pgk.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=KWLmCZe0E9amLO3V8z3dW9zAc7CP2PoiNP0Ya6C73iE=;
        b=N9CoZyf9np8UYS12KknKpY4ycEV97bcEoj0KkFWQOaJDx4N9yetfKRz4IFo5o5d2DD
         Nl1f8CWYPggFLcNyKYRbxfP9oCW4+lGDNE2i0hMZt0NHaPYX9WE1ZeMNiitlpyNklHVP
         JzDGAkWBvDmIU6fyFsQWuuQ7ZE7/81W3HV4lJuSaKlvSCmYqckZ7rJPSc06CXsoRvhTl
         cau1iWbpSS56U+ZL57IOldQma2a9yF78usCGFoqJvZSEGXo8gXJHgFwlqgUxk4ndY+Sc
         N7O72tWwIJ8HyVT69ejg+4vB1lt+jhg3sXk7hrM7aMpsWiznlGTBlKcJPMhkaYBIb026
         Rt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=KWLmCZe0E9amLO3V8z3dW9zAc7CP2PoiNP0Ya6C73iE=;
        b=03kMgbKBgaDRfo41yVeHsk5zRNcbZaxUzlv8P24ZHRlyyMwgQBTgqI6zK5f9NIOBW/
         tbHi0zy9EyRtZEiKXGWJHU+udVnojnemn2uknXnOy57X8JtTshezJxaiPgsjzQwI9RcJ
         85IIgZkCxxHq5l/jEAkVGi/PKL7ty4MIjgbfZSP/WCFKIV47EOubP0Zry6X/h2QDhf3H
         qC+rc8t5qEAVe47bwzCrWozkWnKNKaJEH5VffapmymuB6CajEfUXEDU1ooZrBlRvQdZv
         db7BVNmrsVtjDJHbD3mt/0YPWe32Rnd5+essvGcr3+w9lkWMJrBGkxyBnJzl0MkCtBwM
         IdXQ==
X-Gm-Message-State: ACrzQf2DPx30+cpRdnQ8NQzeVzGP6ck41umNrTgZrngL2A/9UT9VG/oi
        rwozG5iNUgejjAVRNy0XeFO4dPj5rTY=
X-Google-Smtp-Source: AMsMyM7arAVRnDSlz6LLklDRSIN9YSFTUcXVRuLXNnz+RJBNDR3+Iu7wHn6ZGOqqKJ2OSXEFxxnLRipRHhc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr517145pjt.1.1664585977244; Fri, 30 Sep
 2022 17:59:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:54 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-12-seanjc@google.com>
Subject: [PATCH v4 11/32] KVM: x86: Inhibit APIC memslot if x2APIC and AVIC
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free the APIC access page memslot if any vCPU enables x2APIC and SVM's
AVIC is enabled to prevent accesses to the virtual APIC on vCPUs with
x2APIC enabled.  On AMD, due to its "hybrid" mode where AVIC is enabled
when x2APIC is enabled even without x2AVIC support, keeping the APIC
access page memslot results in the guest being able to access the virtual
APIC page as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
that the guest is operating in x2APIC mode.

Exempt nested SVM's update of APICv state from new logic as x2APIC can't
be toggled on VM-Exit.  In practice, invoking the x2APIC logic should be
harmless precisely because it should be a glorified nop, but play it
safe to avoid latent bugs, e.g. with dropping the vCPU's SRCU lock.

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

Note, checking apic_access_memslot_enabled without taking locks relies
it being set during vCPU creation (before kvm_vcpu_reset()).  vCPUs can
race to set the inhibit and delete the memslot, i.e. can get false
positives, but can't get false negatives as apic_access_memslot_enabled
can't be toggled "on" once any vCPU reaches KVM_RUN.

Opportunistically drop the "can" while updating avic_activate_vmcb()'s
comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
the "Note:" down a line to conform to preferred kernel/KVM multi-line
comment style.

Opportunistically update the apicv_update_lock comment, as it isn't
actually used to protect apic_access_memslot_enabled (it's protected by
slots_lock).

Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 20 +++++++++++++----
 arch/x86/kvm/lapic.c            | 38 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/svm/avic.c         | 15 +++++++------
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 16 ++++++++++++--
 6 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d40206b16d6c..062758135c86 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1139,6 +1139,17 @@ enum kvm_apicv_inhibit {
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
@@ -1176,10 +1187,11 @@ struct kvm_arch {
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
@@ -1912,7 +1924,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 
 bool kvm_apicv_activated(struct kvm *kvm);
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
-void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
+void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				      enum kvm_apicv_inhibit reason, bool set);
 void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 80e8b1cc6dc2..42b61469674d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2443,7 +2443,8 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_memslot_enabled)
+	if (kvm->arch.apic_access_memslot_enabled ||
+	    kvm->arch.apic_access_memslot_inhibited)
 		goto out;
 
 	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
@@ -2471,6 +2472,41 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
 
+void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm->arch.apic_access_memslot_enabled)
+		return;
+
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
+	mutex_lock(&kvm->slots_lock);
+
+	if (kvm->arch.apic_access_memslot_enabled) {
+		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
+		/*
+		 * Clear "enabled" after the memslot is deleted so that a
+		 * different vCPU doesn't get a false negative when checking
+		 * the flag out of slots_lock.  No additional memory barrier is
+		 * needed as modifying memslots requires waiting other vCPUs to
+		 * drop SRCU (see above), and false positives are ok as the
+		 * flag is rechecked after acquiring slots_lock.
+		 */
+		kvm->arch.apic_access_memslot_enabled = false;
+
+		/*
+		 * Mark the memslot as inhibited to prevent reallocating the
+		 * memslot during vCPU creation, e.g. if a vCPU is hotplugged.
+		 */
+		kvm->arch.apic_access_memslot_inhibited = true;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	kvm_vcpu_srcu_read_lock(vcpu);
+}
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0587a8282cb3..a318609bb050 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -113,6 +113,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 int kvm_alloc_apic_access_page(struct kvm *kvm);
+void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ec28ba4c5f1b..535e35edce1d 100644
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
@@ -975,7 +975,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
 
 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..8d5e00a7ef84 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1084,7 +1084,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * to benefit from it right away.
 	 */
 	if (kvm_apicv_activated(vcpu->kvm))
-		kvm_vcpu_update_apicv(vcpu);
+		__kvm_vcpu_update_apicv(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..a20002924eb4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10251,7 +10251,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
-void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
+void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	bool activate;
@@ -10286,7 +10286,19 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	preempt_enable();
 	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
+EXPORT_SYMBOL_GPL(__kvm_vcpu_update_apicv);
+
+static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	if (apic_x2apic_mode(vcpu->arch.apic) &&
+	    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC))
+		kvm_inhibit_apic_access_page(vcpu);
+
+	__kvm_vcpu_update_apicv(vcpu);
+}
 
 void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				      enum kvm_apicv_inhibit reason, bool set)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

