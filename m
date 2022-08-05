Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4763C58B074
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiHETlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiHETlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:41:00 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C205811815
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:40:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a9so4717558lfm.12
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=nWaiwEI17OMw/TfJNVGmv/dCiVpBuOpVxD5/Elxo9ZY=;
        b=bcIJTvqBYZIXumQuAeUKwNbrukb240x21rG74i0uII/e0CV/muhEriUE8e5APdlcu1
         a5GwEXC3HxXKvTZm+GRT8f6DKoTA+0zEVWr/sTKB5STRoWIDFkWsTIXa76dLIayHjypN
         V7WA5ZUitV9Saigaa1ydSERvON1rw9+cRswhUR/cs3rH5NhlZpi5pyuTa9KjpTu8jlM5
         YOCgqjv6Refivmq3GCE9OjPmS/aZRbCOArL+x6lvV3dViP2R3C1hflaHR27z9aWgH/Y3
         Qa5oZYo2DbIOhK3U9ENvtceZ6qmV3VENG0f1L305xD7BjTkzxWq5hri+xu4M7FuUiMNm
         iJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=nWaiwEI17OMw/TfJNVGmv/dCiVpBuOpVxD5/Elxo9ZY=;
        b=dq2toHyk3ns9OwnvFk9qnBYmfAdp3fgUgpxN4aqA+VC5JJEJJTJsdZchhQRYZkvAPp
         Yyh/0MBrJIkLlq11+wUX72z5nXkeCwwXyEZBIbeyr8XHOChXQFdhQqWzIW4njPNlgZNz
         te27xqWayNnu+vljZXiQy4/bs6aHXf6wbrM9u331rm+h3v2ewyU/snMDfwC2Covlb/em
         pW9DFL3SOYn1cZPfNLv1mQiQV6hcQH0YV5Z8BJMDbW2HHBpvnVaZYS7yUq6E5VRhMC4c
         FEECY/5ofmgyIOY3t7uqfff83yiXlUD4ctcqdp6ccrLaOpR56J03wqXasKyjrnAC2uKF
         nHpg==
X-Gm-Message-State: ACgBeo0YNTvFMT+vEuSj3AzuSk7AuoSZVMXBDb645RSW9ARebY+px1mZ
        J30kyVgtw8zMMrflvm8Qhmks8A==
X-Google-Smtp-Source: AA6agR5gx7Y1iJApwmxSXkrH2vMRjDQXL4qFLv5d1ot2fsQCeod87KU3DUrlSYADuz7ysT+9I3odYA==
X-Received: by 2002:a05:6512:1c5:b0:48b:192:a29e with SMTP id f5-20020a05651201c500b0048b0192a29emr2564462lfp.250.1659728456050;
        Fri, 05 Aug 2022 12:40:56 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512230400b0048a407f41bbsm560079lfu.238.2022.08.05.12.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:40:55 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v2 2/5] KVM: x86: Add kvm_register_and_fire_irq_mask_notifier()
Date:   Fri,  5 Aug 2022 21:39:16 +0200
Message-Id: <20220805193919.1470653-3-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
In-Reply-To: <20220805193919.1470653-1-dmy@semihalf.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to implement postponing resamplefd notification until an
interrupt is unmasked, we need not only to track changes of the
interrupt mask state (which is already possible with
kvm_register_irq_mask_notifier()) but also to know its initial
mask state before any mask notifier has fired.

Moreover, we need to do this initial check of the IRQ mask state in a
race-free way, to ensure that we will not miss any further mask or
unmask events after we check the initial mask state.

So implement kvm_register_and_fire_irq_mask_notifier() which atomically
registers an IRQ mask notifier and calls it with the current mask value
of the IRQ. It does that using the same locking order as when calling
notifier normally via kvm_fire_mask_notifiers(), to prevent deadlocks.

Its implementation needs to be arch-specific since it relies on
arch-specific synchronization (e.g. ioapic->lock and pic->lock on x86,
or a per-IRQ lock on ARM vGIC) for serializing our initial reading of
the IRQ mask state with a pending change of this mask state.

For now implement it for x86 only, and for other archs add a weak dummy
implementation which doesn't really call the notifier (as other archs
don't currently implement calling notifiers normally via
kvm_fire_mask_notifiers() either, i.e. registering mask notifiers has no
effect on those archs anyway).

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
Link: https://lore.kernel.org/lkml/c7b7860e-ae3a-7b98-e97e-28a62470c470@semihalf.com/
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/i8259.c            |  6 ++++
 arch/x86/kvm/ioapic.c           |  6 ++++
 arch/x86/kvm/ioapic.h           |  1 +
 arch/x86/kvm/irq_comm.c         | 57 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  4 +++
 virt/kvm/eventfd.c              | 31 ++++++++++++++++--
 7 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc76617f11c1..cf0571ed2968 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1834,6 +1834,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
+bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index e1bb6218bb96..1eb3127f6047 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -211,6 +211,12 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
 	pic_unlock(s);
 }
 
+/* Called with s->lock held. */
+bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
+{
+	return !!(s->pics[irq >> 3].imr & (1 << irq));
+}
+
 /*
  * acknowledge interrupt 'irq'
  */
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 765943d7cfa5..fab11de1f885 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -478,6 +478,12 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
 	spin_unlock(&ioapic->lock);
 }
 
+/* Called with ioapic->lock held. */
+bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
+{
+	return !!ioapic->redirtbl[irq].fields.mask;
+}
+
 static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
 {
 	int i;
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 539333ac4b38..fe1f51319992 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -114,6 +114,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
 		       int level, bool line_status);
 void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
+bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq);
 void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index f27e4c9c403e..4bd4218821a2 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -234,6 +234,63 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 	mutex_unlock(&kvm->irq_lock);
 }
 
+void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
+					     struct kvm_irq_mask_notifier *kimn)
+{
+	struct kvm_pic *pic = kvm->arch.vpic;
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	struct kvm_kernel_irq_routing_entry entries[KVM_NR_IRQCHIPS];
+	struct kvm_kernel_irq_routing_entry *pic_e = NULL, *ioapic_e = NULL;
+	int idx, i, n;
+	bool masked;
+
+	mutex_lock(&kvm->irq_lock);
+
+	/*
+	 * Not possible to detect if the guest uses the PIC or the
+	 * IOAPIC. So assume the interrupt to be unmasked iff it is
+	 * unmasked in at least one of both.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	n = kvm_irq_map_gsi(kvm, entries, irq);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+
+	for (i = 0; i < n; i++) {
+		if (entries[i].type != KVM_IRQ_ROUTING_IRQCHIP)
+			continue;
+
+		switch (entries[i].irqchip.irqchip) {
+		case KVM_IRQCHIP_PIC_MASTER:
+		case KVM_IRQCHIP_PIC_SLAVE:
+			pic_e = &entries[i];
+			break;
+		case KVM_IRQCHIP_IOAPIC:
+			ioapic_e = &entries[i];
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (pic_e)
+		spin_lock(&pic->lock);
+	if (ioapic_e)
+		spin_lock(&ioapic->lock);
+
+	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
+
+	masked = (!pic_e || kvm_pic_irq_is_masked(pic, pic_e->irqchip.pin)) &&
+		 (!ioapic_e || kvm_ioapic_irq_is_masked(ioapic, ioapic_e->irqchip.pin));
+	kimn->func(kimn, masked);
+
+	if (ioapic_e)
+		spin_unlock(&ioapic->lock);
+	if (pic_e)
+		spin_unlock(&pic->lock);
+
+	mutex_unlock(&kvm->irq_lock);
+}
+
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dd5f14e31996..55233eb18eb4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1608,8 +1608,12 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
+void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
 void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
 				    struct kvm_irq_mask_notifier *kimn);
+void kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
+					     struct kvm_irq_mask_notifier *kimn);
 void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn);
 void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 39403d9fbdcc..3007d956b626 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -519,15 +519,42 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 	kvm_arch_post_irq_ack_notifier_list_update(kvm);
 }
 
+void __kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn)
+{
+	kimn->irq = irq;
+	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
+}
+
 void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
 				    struct kvm_irq_mask_notifier *kimn)
 {
 	mutex_lock(&kvm->irq_lock);
-	kimn->irq = irq;
-	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
+	__kvm_register_irq_mask_notifier(kvm, irq, kimn);
 	mutex_unlock(&kvm->irq_lock);
 }
 
+/*
+ * kvm_register_and_fire_irq_mask_notifier() registers the notifier and
+ * immediately calls it with the current mask value of the IRQ. It does
+ * that atomically, so that we will find out the initial mask state of
+ * the IRQ and will not miss any further mask or unmask events. It does
+ * that using the same locking order as when calling notifier normally
+ * via kvm_fire_mask_notifiers(), to prevent deadlocks.
+ *
+ * Implementation is arch-specific since it relies on arch-specific
+ * (irqchip-specific) synchronization. Below is a weak dummy
+ * implementation for archs not implementing it yet, as those archs
+ * don't implement calling notifiers normally via
+ * kvm_fire_mask_notifiers() either, i.e. registering mask notifiers
+ * has no effect on those archs anyway.
+ */
+void __weak kvm_register_and_fire_irq_mask_notifier(struct kvm *kvm, int irq,
+						    struct kvm_irq_mask_notifier *kimn)
+{
+	kvm_register_irq_mask_notifier(kvm, irq, kimn);
+}
+
 void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn)
 {
-- 
2.37.1.559.g78731f0fdb-goog

