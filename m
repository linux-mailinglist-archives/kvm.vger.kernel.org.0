Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1545764EC
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiGOQBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiGOQA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:00:58 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBD86D9F0
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:52 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id q7so6148749lji.12
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RtXdad8bI5IetWDi9IC5OTbVeT+2bjoYNO4DTxrHCg=;
        b=BEqZKxOg8Dh/1FkqEpVfdQXyIfT29i9dbmybPJhgSA98masA3HJ+LxGE6dY1PwF6UN
         WLV2uqD34to5ai6Bwcj3G01rIcheVIMuzBkRYpsFU0gjR6fXDvhog3hXZEqh1el+DYDN
         4H7SgY6kn7FyWFRj4QN8fr9l+1bf9yL5jywpjE6qbOQwGOGqnN1cwHNJrnVGcVnq++ab
         06dWi7g/3tHFb1UEk34ekcUx2SVgQeqz0O9UP9pgNWA43ZNOJ/nLNG9EqU8V6uwIJowN
         5ekK8nI4g3nNrNY1a0JnAadJAc0jzAtiGHytaq6X0KjfNTQpylLIIzsleCilYhdFV/Qq
         HqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RtXdad8bI5IetWDi9IC5OTbVeT+2bjoYNO4DTxrHCg=;
        b=sf6WwXDCaw+wUuHrTqSNqNyl8b+BCUdz86lbUnTSlQS5B46xqMPEWBTMRwHBjlozvY
         /m1k7tmfnRXlYR+2EPcBAUStyowPwp2BixDR7o6JpfWlEmcP4jEC+o9d0Lb6lPP8d2JT
         VvifW622U6Jev4Sg+abYr/cjpxloD0O5OZJDbqqKLEliZucpkmLSbPLYmae2xiwokQKD
         qGxhAt46Y6vEx8mvSzBjG2P0rMy2FBkVuivphlBVkdUddwZ1RBY5flS6qF+sQnxDRT+O
         YbF01NriIwD0cmyeNAe59XBxT4I82bF5aQbBjyihJm9C6I5qCipTVXlpEKfgJIiTumDd
         QfVg==
X-Gm-Message-State: AJIora/XnsEZLHbiMH8uhUK2vWv3aQGpUFL2MSFBFE7slot2Nuv2ufkC
        29jlbMg0zO6BT7afnfe2Xjsg/g==
X-Google-Smtp-Source: AGRyM1soE7e6xBdX8jq4oPod+4oeZbKokXbi6NZnEMJnsmzcHaYRwqhZvvu5K6duNxNWOrjvT2IpdA==
X-Received: by 2002:a2e:b6d2:0:b0:25d:6849:f7f9 with SMTP id m18-20020a2eb6d2000000b0025d6849f7f9mr7397974ljo.41.1657900850188;
        Fri, 15 Jul 2022 09:00:50 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id c12-20020a056512238c00b0047968606114sm959772lfv.111.2022.07.15.09.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:00:48 -0700 (PDT)
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
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH 2/3] KVM: x86: Add kvm_irq_is_masked()
Date:   Fri, 15 Jul 2022 17:59:27 +0200
Message-Id: <20220715155928.26362-3-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715155928.26362-1-dmy@semihalf.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to implement postponing resamplefd event until an interrupt is
unmasked, we need not only to track changes of the interrupt mask state
(which is made possible by the previous patch "KVM: x86: Move
kvm_(un)register_irq_mask_notifier() to generic KVM") but also to know
its initial mask state at the time of registering a resamplefd
listener. So implement kvm_irq_is_masked() for that.

Actually, for now it's implemented for x86 only (see below).

The implementation is trickier than I'd like it to be, for 2 reasons:

1. Interrupt (GSI) to irqchip pin mapping is not a 1:1 mapping: an IRQ
   may map to multiple pins on different irqchips. I guess the only
   reason for that is to support x86 interrupts 0-15 for which we don't
   know if the guest uses PIC or IOAPIC. For this reason kvm_set_irq()
   delivers interrupt to both, assuming the guest will ignore the
   unused one. For the same reason, in kvm_irq_is_masked() we should
   also take into account the mask state of both irqchips. We consider
   an interrupt unmasked if and only if it is unmasked in at least one
   of PIC or IOAPIC, assuming that in the unused one all the interrupts
   should be masked.

2. For now ->is_masked() implemented for x86 only, so need to handle
   the case when ->is_masked() is not provided by the irqchip. In such
   case kvm_irq_is_masked() returns failure, and its caller may fall
   back to an assumption that an interrupt is always unmasked.

Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/i8259.c            | 11 +++++++++++
 arch/x86/kvm/ioapic.c           | 11 +++++++++++
 arch/x86/kvm/ioapic.h           |  1 +
 arch/x86/kvm/irq_comm.c         | 16 ++++++++++++++++
 include/linux/kvm_host.h        |  3 +++
 virt/kvm/irqchip.c              | 34 +++++++++++++++++++++++++++++++++
 7 files changed, 77 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39a867d68721..64618b890700 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1840,6 +1840,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
+bool kvm_pic_irq_is_masked(struct kvm_pic *pic, int irq);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index e1bb6218bb96..2d1ed3bc7cc5 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -211,6 +211,17 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
 	pic_unlock(s);
 }
 
+bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
+{
+	bool ret;
+
+	pic_lock(s);
+	ret = !!(s->pics[irq >> 3].imr & (1 << irq));
+	pic_unlock(s);
+
+	return ret;
+}
+
 /*
  * acknowledge interrupt 'irq'
  */
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 765943d7cfa5..874f68a65c87 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -478,6 +478,17 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
 	spin_unlock(&ioapic->lock);
 }
 
+bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
+{
+	bool ret;
+
+	spin_lock(&ioapic->lock);
+	ret = !!ioapic->redirtbl[irq].fields.mask;
+	spin_unlock(&ioapic->lock);
+
+	return ret;
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
index 43e13892ed34..5bff6d6ac54f 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -34,6 +34,13 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
 }
 
+static bool kvm_is_masked_pic_irq(struct kvm_kernel_irq_routing_entry *e,
+				     struct kvm *kvm)
+{
+	struct kvm_pic *pic = kvm->arch.vpic;
+	return kvm_pic_irq_is_masked(pic, e->irqchip.pin);
+}
+
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
@@ -43,6 +50,13 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 				line_status);
 }
 
+static bool kvm_is_masked_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
+				     struct kvm *kvm)
+{
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	return kvm_ioapic_irq_is_masked(ioapic, e->irqchip.pin);
+}
+
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
 {
@@ -275,11 +289,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
 				return -EINVAL;
 			e->set = kvm_set_pic_irq;
+			e->is_masked = kvm_is_masked_pic_irq;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
 			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
 				return -EINVAL;
 			e->set = kvm_set_ioapic_irq;
+			e->is_masked = kvm_is_masked_ioapic_irq;
 			break;
 		default:
 			return -EINVAL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9e12ef503157..e8bfb3b0d4d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -625,6 +625,8 @@ struct kvm_kernel_irq_routing_entry {
 	int (*set)(struct kvm_kernel_irq_routing_entry *e,
 		   struct kvm *kvm, int irq_source_id, int level,
 		   bool line_status);
+	bool (*is_masked)(struct kvm_kernel_irq_routing_entry *e,
+			  struct kvm *kvm);
 	union {
 		struct {
 			unsigned irqchip;
@@ -1598,6 +1600,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			       struct kvm *kvm, int irq_source_id,
 			       int level, bool line_status);
+int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked);
 bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_notify_acked_gsi(struct kvm *kvm, int gsi);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 58e4f88b2b9f..9252ebedba55 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -97,6 +97,40 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 	return ret;
 }
 
+/*
+ * Return value:
+ *  = 0   Interrupt mask state successfully written to `masked`
+ *  < 0   Failed to read interrupt mask state
+ */
+int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked)
+{
+	struct kvm_kernel_irq_routing_entry irq_set[KVM_NR_IRQCHIPS];
+	int ret = -1, i, idx;
+
+	/* Not possible to detect if the guest uses the PIC or the
+	 * IOAPIC. So assume the interrupt to be unmasked iff it is
+	 * unmasked in at least one of both.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	i = kvm_irq_map_gsi(kvm, irq_set, irq);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+
+	while (i--) {
+		if (!irq_set[i].is_masked)
+			continue;
+
+		if (!irq_set[i].is_masked(&irq_set[i], kvm)) {
+			*masked = false;
+			return 0;
+		}
+		ret = 0;
+	}
+	if (!ret)
+		*masked = true;
+
+	return ret;
+}
+
 static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
 {
 	int i;
-- 
2.37.0.170.g444d1eabd0-goog

