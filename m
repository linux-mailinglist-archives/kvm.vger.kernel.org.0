Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC215764E2
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiGOQBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiGOQA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:00:59 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8FF6EEB5
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:54 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id t1so8507140lft.8
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6PvTZQ45Z0LZ1z1mI3Km4s/20uCm/f1rKAHjk57ZZk8=;
        b=X5YO4csQqPan1hqJ4ywB5/7ABfqBnMBowXP4ayNMlBt4V+h/PIZmINY/jCxDJDQGAm
         /8SOHrHLa/sVo5ZQPSnK9diHS0b2GeeZbRrRgnYp68jI5GXiNmoCfgvb6sqvoda4yLPt
         j+5mqOBSkDYknzg/7l5iLcSqBg9WRX4+OvstF732nLI7pTgA0rSPpfWaxF9Lam1wdSig
         Q+tGkEqka1o0EbJlKP4iypS8s+4kk+va5bura3M2iitnQBm6PrXyr6oLo6s7ulbJRNei
         1NllHMhQBtpkc+Uzbu05HdCxQf8GnEmw8zvCz7CwhB67lKDyW+u0fGT3SwGURVrSH3AI
         VTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6PvTZQ45Z0LZ1z1mI3Km4s/20uCm/f1rKAHjk57ZZk8=;
        b=tv4Faw7zBy/JIQFNj5HnxrIIv3ViBCHcv2aASb2o886J+D9UF7uSSx58j7j8jv6uxw
         ei4QV8HwnlZ7+RFqyuFLzfoLO+kZYIruqA7d/AQwn0XeAXQgKUK4bbbCeXUo5VZVt5CE
         OYO1vHT6WF38yn0J8OD9T6mhPIwflxF3Wtrtqlz61yq9aV12LEHSoqCYa1qNmZplI54u
         XoPz96cQ1pW//P4DJuZP5PAm1oqWZ6pB/lmqW7BFq5uQAs0O8/OVNj+JJU8FtNZt/eIl
         MogGCQMaqhsEb9buCG1lXHHeL29apEHegnBfoeoDJkmqCqAW1LNYGMGNw/avFBugx/eI
         4AIg==
X-Gm-Message-State: AJIora/ID8r2w1djDKcgKJlT5fiHl03AdVblmw89xjp/XxPeNHHMP9mE
        rFMbkD2nr++WwocwGvqGgqnSCQ==
X-Google-Smtp-Source: AGRyM1uTpv9co3mlZ+OhXk00VcEkV9xpnVsHMD0Bsl48TyFRViM/iA5Ha3jUNDd0xu0Ybg21ZkkOlQ==
X-Received: by 2002:a05:6512:3d15:b0:489:d97d:8927 with SMTP id d21-20020a0565123d1500b00489d97d8927mr8657272lfv.80.1657900852352;
        Fri, 15 Jul 2022 09:00:52 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id c12-20020a056512238c00b0047968606114sm959772lfv.111.2022.07.15.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:00:51 -0700 (PDT)
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
Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot interrupts
Date:   Fri, 15 Jul 2022 17:59:28 +0200
Message-Id: <20220715155928.26362-4-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715155928.26362-1-dmy@semihalf.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing KVM mechanism for forwarding of level-triggered interrupts
using resample eventfd doesn't work quite correctly in the case of
interrupts that are handled in a Linux guest as oneshot interrupts
(IRQF_ONESHOT). Such an interrupt is acked to the device in its
threaded irq handler, i.e. later than it is acked to the interrupt
controller (EOI at the end of hardirq), not earlier.

Linux keeps such interrupt masked until its threaded handler finishes,
to prevent the EOI from re-asserting an unacknowledged interrupt.
However, with KVM + vfio (or whatever is listening on the resamplefd)
we don't check that the interrupt is still masked in the guest at the
moment of EOI. Resamplefd is notified regardless, so vfio prematurely
unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
is generated in the host and queued for injection to the guest.

The fact that the virtual IRQ is still masked doesn't prevent this new
physical IRQ from being propagated to the guest, because:

1. It is not guaranteed that the vIRQ will remain masked by the time
   when vfio signals the trigger eventfd.
2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
   IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
   new pending interrupt is injected by KVM to the guest anyway.

There are observed at least 2 user-visible issues caused by those
extra erroneous pending interrupts for oneshot irq in the guest:

1. System suspend aborted due to a pending wakeup interrupt from
   ChromeOS EC (drivers/platform/chrome/cros_ec.c).
2. Annoying "invalid report id data" errors from ELAN0000 touchpad
   (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
   every time the touchpad is touched.

This patch fixes the issue on x86 by checking if the interrupt is
unmasked when we receive irq ack (EOI) and, in case if it's masked,
postponing resamplefd notify until the guest unmasks it.

Important notes:

1. It doesn't fix the issue for other archs yet, due to some missing
   KVM functionality needed by this patch:
     - calling mask notifiers is implemented for x86 only
     - irqchip ->is_masked() is implemented for x86 only

2. It introduces an additional spinlock locking in the resample notify
   path, since we are no longer just traversing an RCU list of irqfds
   but also updating the resampler state. Hopefully this locking won't
   noticeably slow down anything for anyone.

Regarding #2, there may be an alternative solution worth considering:
extend KVM irqfd (userspace) API to send mask and unmask notifications
directly to vfio/whatever, in addition to resample notifications, to
let vfio check the irq state on its own. There is already locking on
vfio side (see e.g. vfio_platform_unmask()), so this way we would avoid
introducing any additional locking. Also such mask/unmask notifications
could be useful for other cases.

Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 include/linux/kvm_irqfd.h | 14 ++++++++++++
 virt/kvm/eventfd.c        | 45 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index dac047abdba7..01754a1abb9e 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -19,6 +19,16 @@
  * resamplefd.  All resamplers on the same gsi are de-asserted
  * together, so we don't need to track the state of each individual
  * user.  We can also therefore share the same irq source ID.
+ *
+ * A special case is when the interrupt is still masked at the moment
+ * an irq ack is received. That likely means that the interrupt has
+ * been acknowledged to the interrupt controller but not acknowledged
+ * to the device yet, e.g. it might be a Linux guest's threaded
+ * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
+ * resamplefd is postponed until the guest unmasks the interrupt,
+ * which is detected through the irq mask notifier. This prevents
+ * erroneous extra interrupts caused by premature re-assert of an
+ * unacknowledged interrupt by the resamplefd listener.
  */
 struct kvm_kernel_irqfd_resampler {
 	struct kvm *kvm;
@@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
 	 */
 	struct list_head list;
 	struct kvm_irq_ack_notifier notifier;
+	struct kvm_irq_mask_notifier mask_notifier;
+	bool masked;
+	bool pending;
+	spinlock_t lock;
 	/*
 	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
 	 * resamplers among irqfds on the same gsi.
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 50ddb1d1a7f0..9ff47ac33790 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -75,6 +75,44 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
 		    resampler->notifier.gsi, 0, false);
 
+	spin_lock(&resampler->lock);
+	if (resampler->masked) {
+		resampler->pending = true;
+		spin_unlock(&resampler->lock);
+		return;
+	}
+	spin_unlock(&resampler->lock);
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
+	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
+	    srcu_read_lock_held(&kvm->irq_srcu))
+		eventfd_signal(irqfd->resamplefd, 1);
+
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+}
+
+static void
+irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool masked)
+{
+	struct kvm_kernel_irqfd_resampler *resampler;
+	struct kvm *kvm;
+	struct kvm_kernel_irqfd *irqfd;
+	int idx;
+
+	resampler = container_of(kimn,
+			struct kvm_kernel_irqfd_resampler, mask_notifier);
+	kvm = resampler->kvm;
+
+	spin_lock(&resampler->lock);
+	resampler->masked = masked;
+	if (masked || !resampler->pending) {
+		spin_unlock(&resampler->lock);
+		return;
+	}
+	resampler->pending = false;
+	spin_unlock(&resampler->lock);
+
 	idx = srcu_read_lock(&kvm->irq_srcu);
 
 	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
@@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
 	if (list_empty(&resampler->list)) {
 		list_del(&resampler->link);
 		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
+		kvm_unregister_irq_mask_notifier(kvm, resampler->mask_notifier.irq,
+						 &resampler->mask_notifier);
 		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
 			    resampler->notifier.gsi, 0, false);
 		kfree(resampler);
@@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			INIT_LIST_HEAD(&resampler->list);
 			resampler->notifier.gsi = irqfd->gsi;
 			resampler->notifier.irq_acked = irqfd_resampler_ack;
+			resampler->mask_notifier.func = irqfd_resampler_mask;
+			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler->masked);
+			spin_lock_init(&resampler->lock);
 			INIT_LIST_HEAD(&resampler->link);
 
 			list_add(&resampler->link, &kvm->irqfds.resampler_list);
 			kvm_register_irq_ack_notifier(kvm,
 						      &resampler->notifier);
+			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
+						       &resampler->mask_notifier);
 			irqfd->resampler = resampler;
 		}
 
-- 
2.37.0.170.g444d1eabd0-goog

