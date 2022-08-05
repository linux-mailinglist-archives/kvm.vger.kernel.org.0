Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DFD58B078
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbiHETlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241522AbiHETlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:41:06 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74DA12637
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:41:02 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h12so4049270ljg.7
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=fJt+8ihDsvIqc3+fCTYKstbstOdW0KiHTWXF75LAIsc=;
        b=LwND4vNWX5iBHrLIpe8UPID7KoTe+AGnxN9IU0iE3UvNUsAAgXJOu+KcUIzZ0whOm9
         MZUNqD8fDTdAo60iPWNNaZyzj+vXPwy8Mkz/ewUOfecAIJd5XVgaLk/rF0wVEY8nFtzX
         CJaKdVUBF0P2HoeoFFVq2tex2aZtQ1b+2mjSnP13bGPHhKSZOqyF9IdQhbAExAie8F+m
         AR23t1DeeYSHSqus3bgD6MgrKtMiCNEtpdlCUfBZyEjEuAkS/Rd06BabXuWAAG2QZd5T
         61zTI5xXk5GWFPvVqydP/d+pdw562Ducic0q5xO0Z9ytEI6f2TXWNkLWqj8G73HAdnFI
         ODoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=fJt+8ihDsvIqc3+fCTYKstbstOdW0KiHTWXF75LAIsc=;
        b=1xeMiWg/nGMwIaDK8YwcZHlh430uLiZ0qRTv9vb/Kxxm/kCkfgh404oCCGHU5qUaj5
         EaYyELwRs8zsHd7x7RZph07DNP4tLgx53EdIWPubLrnAwa4yLRiSEbdO4HHhMB11F+0e
         Vu2op66emPaGb9jGvSkw4+IDa5g+mnq4FjN1lfv42wXiVJ5CC+ToqWagRWVOWTqPkPA+
         MKq7nOqHCPflGEwvYZA6GYFgGMGspX6kMURrNV8dQ1AWGqR4FTvrNWnoZU71UX1WZZnw
         r2Sd7fzx02ujrkQzgBB4tWpMSO1zSBKG5d4xAjVpOkyDDG0GlWy/50uYJeAmcHcLnQeU
         BhjQ==
X-Gm-Message-State: ACgBeo39Oq5po/hf5QnqMhyc5IBbcOPOeSDfZ7iUC8N6p0vT4CGdLHtR
        PlHvTzp8ofuDRvBcas+kQCTCNQ==
X-Google-Smtp-Source: AA6agR4D/lxlr4L+0FdtafVudGsXVZxfDnLZ5pKhbtzeGxYhZI79kjSKtslKXyeRzb7fqdDc9U/nVg==
X-Received: by 2002:a2e:b88b:0:b0:25d:a15a:bba9 with SMTP id r11-20020a2eb88b000000b0025da15abba9mr2626624ljp.357.1659728460550;
        Fri, 05 Aug 2022 12:41:00 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512230400b0048a407f41bbsm560079lfu.238.2022.08.05.12.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:41:00 -0700 (PDT)
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
Subject: [PATCH v2 4/5] KVM: irqfd: Rename resampler->notifier
Date:   Fri,  5 Aug 2022 21:39:18 +0200
Message-Id: <20220805193919.1470653-5-dmy@semihalf.com>
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

Since resampler irqfd is now using a mask notifier along with an ack
notifier, rename resampler->notifier to resampler->ack_notifier for
clarity.

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 include/linux/kvm_irqfd.h |  2 +-
 virt/kvm/eventfd.c        | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index 01754a1abb9e..4df9e6bbd7db 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -37,7 +37,7 @@ struct kvm_kernel_irqfd_resampler {
 	 * RCU list modified under kvm->irqfds.resampler_lock
 	 */
 	struct list_head list;
-	struct kvm_irq_ack_notifier notifier;
+	struct kvm_irq_ack_notifier ack_notifier;
 	struct kvm_irq_mask_notifier mask_notifier;
 	bool masked;
 	bool pending;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f98dcce3959c..72de942dbb9c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -70,11 +70,11 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 	bool notify = true;
 
 	resampler = container_of(kian,
-			struct kvm_kernel_irqfd_resampler, notifier);
+			struct kvm_kernel_irqfd_resampler, ack_notifier);
 	kvm = resampler->kvm;
 
 	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
-		    resampler->notifier.gsi, 0, false);
+		    resampler->ack_notifier.gsi, 0, false);
 
 	spin_lock(&resampler->lock);
 	if (resampler->masked) {
@@ -137,11 +137,11 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
 
 	if (list_empty(&resampler->list)) {
 		list_del(&resampler->link);
-		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
+		kvm_unregister_irq_ack_notifier(kvm, &resampler->ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, resampler->mask_notifier.irq,
 						 &resampler->mask_notifier);
 		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
-			    resampler->notifier.gsi, 0, false);
+			    resampler->ack_notifier.gsi, 0, false);
 		kfree(resampler);
 	}
 
@@ -390,7 +390,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 		list_for_each_entry(resampler,
 				    &kvm->irqfds.resampler_list, link) {
-			if (resampler->notifier.gsi == irqfd->gsi) {
+			if (resampler->ack_notifier.gsi == irqfd->gsi) {
 				irqfd->resampler = resampler;
 				break;
 			}
@@ -407,8 +407,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 			resampler->kvm = kvm;
 			INIT_LIST_HEAD(&resampler->list);
-			resampler->notifier.gsi = irqfd->gsi;
-			resampler->notifier.irq_acked = irqfd_resampler_ack;
+			resampler->ack_notifier.gsi = irqfd->gsi;
+			resampler->ack_notifier.irq_acked = irqfd_resampler_ack;
 			resampler->mask_notifier.func = irqfd_resampler_mask_notify;
 			spin_lock_init(&resampler->lock);
 			INIT_LIST_HEAD(&resampler->link);
@@ -417,7 +417,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			kvm_register_and_fire_irq_mask_notifier(kvm, irqfd->gsi,
 								&resampler->mask_notifier);
 			kvm_register_irq_ack_notifier(kvm,
-						      &resampler->notifier);
+						      &resampler->ack_notifier);
 			irqfd->resampler = resampler;
 		}
 
-- 
2.37.1.559.g78731f0fdb-goog

