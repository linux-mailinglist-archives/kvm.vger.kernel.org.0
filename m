Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50993598DF6
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346017AbiHRU11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 16:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345985AbiHRU1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 16:27:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514902DEE
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:22 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id o2so3585598lfb.1
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ASl2Alm6G/p4WXqXOKAwDnhEEPOCMebcB3nYtYsCEe0=;
        b=ti/E06ot4v0aaK0rJmBJ6lQ6U8KMEqaUVK5U2lxO+845BoDCVBrx79NijqZ2dqmHIA
         mSh65zNLwTKMBHgoUJU7OuJqCHVeqtb0/04Ozg5fukr9M8RUrViZBfFr4S4L/Y/k8fJD
         SdmMwHvRkJ10/+tSgtJes8qw28aBv0vfk9Ao8VH4m2/dEPRrbne8/+kEzmFQMCAzdw+P
         lLRJKy6QUbkE5xAUhTSQPkI1XJSZIUqUxKwnp5a0Rw2+4YUR033//btpEgKKFhi5Hmhz
         mtPsVTMY1pT5NZZhQW8nqETUeApvW8oKNGldrYw8dChMCFJTVzZwpT/ujAQvjiReuSQm
         1KYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ASl2Alm6G/p4WXqXOKAwDnhEEPOCMebcB3nYtYsCEe0=;
        b=qw19tZDbWMd7/eAJfNVqj2J+Mmevvu9vqsAXfKCZxIQ85oW3hMi0l55awrFJCWkjv+
         HSXznfiEFjuVHsjAA5HQ0Fn3mteN7mlGIOfG9A93nCuF/qE25P5i9v299/XdkowlAvgS
         3JkVQbCG+uaKPIq/bnZQGah3h+aV4egKfrWlAzVIn48LMNDSBjLQG9Oz3Q+oMjYmzi89
         SCQNeM6PnHg6PZt+/X9/3PC2QGkIvWi4MkC4ts6wGTH1TCBYmFx3D6vL/YQBm2K3H57N
         +XLes+sv80CC9j9cXqS3dsaO9Q3WjIr83reLIqKccfFORpf2mWjSe3Ych6jQvKJBHw8s
         W4ww==
X-Gm-Message-State: ACgBeo2VKkmo8nLNoTXKfPnOlzvu0ln2txvgMbsjmjAObeqUxeZ8fO4X
        Xpmi0aZIVAMpEzl/GVogKrzEmw==
X-Google-Smtp-Source: AA6agR4sb/uYqsLDYYpsjKRDSP/YMY4ZbPvQ4TjGdCDnc+dW6dGZZNmS7nXiRmUzuInuTAHp9fRcAQ==
X-Received: by 2002:a05:6512:3f29:b0:48a:5ede:9aef with SMTP id y41-20020a0565123f2900b0048a5ede9aefmr1338592lfa.688.1660854440275;
        Thu, 18 Aug 2022 13:27:20 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id b5-20020a056512070500b0048b0c59ed9asm341400lfs.227.2022.08.18.13.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:27:19 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v3 2/2] KVM: x86/ioapic: Resample the pending state of an IRQ when unmasking
Date:   Thu, 18 Aug 2022 22:27:01 +0200
Message-Id: <20220818202701.3314045-3-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220818202701.3314045-1-dmy@semihalf.com>
References: <20220818202701.3314045-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM irqfd based emulation of level-triggered interrupts doesn't work
quite correctly in some cases, particularly in the case of interrupts
that are handled in a Linux guest as oneshot interrupts (IRQF_ONESHOT).
Such an interrupt is acked to the device in its threaded irq handler,
i.e. later than it is acked to the interrupt controller (EOI at the end
of hardirq), not earlier.

Linux keeps such interrupt masked until its threaded handler finishes,
to prevent the EOI from re-asserting an unacknowledged interrupt.
However, with KVM + vfio (or whatever is listening on the resamplefd)
we always notify resamplefd at the EOI, so vfio prematurely unmasks the
host physical IRQ, thus a new physical interrupt is fired in the host.
This extra interrupt in the host is not a problem per se. The problem is
that it is unconditionally queued for injection into the guest, so the
guest sees an extra bogus interrupt. [*]

There are observed at least 2 user-visible issues caused by those
extra erroneous interrupts for a oneshot irq in the guest:

1. System suspend aborted due to a pending wakeup interrupt from
   ChromeOS EC (drivers/platform/chrome/cros_ec.c).
2. Annoying "invalid report id data" errors from ELAN0000 touchpad
   (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
   every time the touchpad is touched.

The core issue here is that by the time when the guest unmasks the IRQ,
the physical IRQ line is no longer asserted (since the guest has
acked the interrupt to the device in the meantime), yet we
unconditionally inject the interrupt queued into the guest by the
previous resampling. So to fix the issue, we need a way to detect that
the IRQ is no longer pending, and cancel the queued interrupt in this
case.

With IOAPIC we are not able to probe the physical IRQ line state
directly (at least not if the underlying physical interrupt controller
is an IOAPIC too), so in this patch we use irqfd resampler for that.
Namely, instead of injecting the queued interrupt, we just notify the
resampler that this interrupt is done. If the IRQ line is actually
already deasserted, we are done. If it is still asserted, a new
interrupt will be shortly triggered through irqfd and injected into the
guest.

In the case if there is no irqfd resampler registered for this IRQ, we
cannot fix the issue, so we keep the existing behavior: immediately
unconditionally inject the queued interrupt.

This patch fixes the issue for x86 IOAPIC only. In the long run, we can
fix it for other irqchips and other architectures too, possibly taking
advantage of reading the physical state of the IRQ line, which is
possible with some other irqchips (e.g. with arm64 GIC, maybe even with
the legacy x86 PIC).

[*] In this description we assume that the interrupt is a physical host
    interrupt forwarded to the guest e.g. by vfio. Potentially the same
    issue may occur also with a purely virtual interrupt from an
    emulated device, e.g. if the guest handles this interrupt, again, as
    a oneshot interrupt.

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
Link: https://lore.kernel.org/lkml/87o7wrug0w.wl-maz@kernel.org/
---
 arch/x86/kvm/ioapic.c    | 36 ++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h |  8 ++++++++
 virt/kvm/eventfd.c       | 39 +++++++++++++++++++++++++++++++++------
 3 files changed, 75 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 765943d7cfa5..da7074d9b04e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -368,8 +368,40 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 		if (mask_before != mask_after)
 			kvm_fire_mask_notifiers(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index, mask_after);
 		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
-		    && ioapic->irr & (1 << index))
-			ioapic_service(ioapic, index, false);
+		    && ioapic->irr & (1 << index)
+		    && !e->fields.mask
+		    && !e->fields.remote_irr) {
+			/*
+			 * Pending status in irr may be outdated: the IRQ line may have
+			 * already been deasserted by a device while the IRQ was masked.
+			 * This occurs, for instance, if the interrupt is handled in a
+			 * Linux guest as a oneshot interrupt (IRQF_ONESHOT). In this
+			 * case the guest acknowledges the interrupt to the device in
+			 * its threaded irq handler, i.e. after the EOI but before
+			 * unmasking, so at the time of unmasking the IRQ line is
+			 * already down but our pending irr bit is still set. In such
+			 * cases, injecting this pending interrupt to the guest is
+			 * buggy: the guest will receive an extra unwanted interrupt.
+			 *
+			 * So we need to check here if the IRQ is actually still pending.
+			 * As we are generally not able to probe the IRQ line status
+			 * directly, we do it through irqfd resampler. Namely, we clear
+			 * the pending status and notify the resampler that this interrupt
+			 * is done, without actually injecting it into the guest. If the
+			 * IRQ line is actually already deasserted, we are done. If it is
+			 * still asserted, a new interrupt will be shortly triggered
+			 * through irqfd and injected into the guest.
+			 *
+			 * If, however, it's not possible to resample (no irqfd resampler
+			 * registered for this irq), then unconditionally inject this
+			 * pending interrupt into the guest, so the guest will not miss
+			 * an interrupt, although may get an extra unwanted interrupt.
+			 */
+			if (kvm_notify_irqfd_resampler(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index))
+				ioapic->irr &= ~(1 << index);
+			else
+				ioapic_service(ioapic, index, false);
+		}
 		if (e->fields.delivery_mode == APIC_DM_FIXED) {
 			struct kvm_lapic_irq irq;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ee6d906e0138..b3ca17c74b44 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1979,6 +1979,7 @@ int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 #ifdef CONFIG_HAVE_KVM_IRQFD
 int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
+bool kvm_notify_irqfd_resampler(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_irq_routing_update(struct kvm *);
 #else
 static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
@@ -1987,6 +1988,13 @@ static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 }
 
 static inline void kvm_irqfd_release(struct kvm *kvm) {}
+
+static inline bool kvm_notify_irqfd_resampler(struct kvm *kvm,
+					      unsigned irqchip,
+					      unsigned pin)
+{
+	return false;
+}
 #endif
 
 #else
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 61aea70dd888..71f327019f1e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -55,6 +55,16 @@ irqfd_inject(struct work_struct *work)
 			    irqfd->gsi, 1, false);
 }
 
+/* Called within kvm->irq_srcu read side. */
+static void __irqfd_resampler_notify(struct kvm_kernel_irqfd_resampler *resampler)
+{
+	struct kvm_kernel_irqfd *irqfd;
+
+	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
+	    srcu_read_lock_held(&resampler->kvm->irq_srcu))
+		eventfd_signal(irqfd->resamplefd, 1);
+}
+
 /*
  * Since resampler irqfds share an IRQ source ID, we de-assert once
  * then notify all of the resampler irqfds using this GSI.  We can't
@@ -65,7 +75,6 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 {
 	struct kvm_kernel_irqfd_resampler *resampler;
 	struct kvm *kvm;
-	struct kvm_kernel_irqfd *irqfd;
 	int idx;
 
 	resampler = container_of(kian,
@@ -76,11 +85,7 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 		    resampler->notifier.gsi, 0, false);
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
-
-	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
-	    srcu_read_lock_held(&kvm->irq_srcu))
-		eventfd_signal(irqfd->resamplefd, 1);
-
+	__irqfd_resampler_notify(resampler);
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 }
 
@@ -648,6 +653,28 @@ void kvm_irq_routing_update(struct kvm *kvm)
 	spin_unlock_irq(&kvm->irqfds.lock);
 }
 
+bool kvm_notify_irqfd_resampler(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	struct kvm_kernel_irqfd_resampler *resampler;
+	int gsi, idx;
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
+	if (gsi != -1)
+		list_for_each_entry_srcu(resampler,
+					 &kvm->irqfds.resampler_list, link,
+					 srcu_read_lock_held(&kvm->irq_srcu)) {
+			if (resampler->notifier.gsi == gsi) {
+				__irqfd_resampler_notify(resampler);
+				srcu_read_unlock(&kvm->irq_srcu, idx);
+				return true;
+			}
+		}
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+
+	return false;
+}
+
 /*
  * create a host-wide workqueue for issuing deferred shutdown requests
  * aggregated from all vm* instances. We need our own isolated
-- 
2.37.1.595.g718a3a8f04-goog

