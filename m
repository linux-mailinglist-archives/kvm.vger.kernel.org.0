Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D92E6C580F
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 21:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjCVUsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjCVUsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 16:48:06 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB13A8A
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 13:44:50 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id g18so20332827ljl.3
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 13:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679517884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0r1ORabpmArqDez6N34oSAN828iltiC/hvE9Af42N8=;
        b=dwCBuJYHTDMmwJCnMESPvDIka7XHiyOW153yfgcvwa6h1ii6yv1OT/blRhzIHl5AeJ
         4K7C2RDz2pKiGhwUdc7bsNfi9zmeFQfLAR99AAe5fXFUvVahrloSrO5+nMcw5QxAWv5G
         QuJ7eUkCxcOFnq8FEOK1DE9tu3nH0A/B36J03f3M6jeI/bBvxBOrypPu6ktMR4tRxMFk
         9w/iRQI/IlKdCphQlVUT11xrZsdunl4kn8G3FA+mWiRWxBx+76Cq0KCwMyKICKqfH4Ab
         c9LZDuKo5BBDK/FH0XBI14zn5d3nx1sqANiS3n4U+xGjXo3n+ins5kegxByGDAv1wr6e
         UrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679517884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0r1ORabpmArqDez6N34oSAN828iltiC/hvE9Af42N8=;
        b=Z4B2eHn17h0u9JMT4GiivojXrP/LSmZrk44zTwc48aSaqpxOMyOzjG3QN190/KtCOd
         t2B8kJtA0ERcn58Aegvwh8U175wdmdGAP4FKT7PVgu4Fgx1+U1tDOoaPytNe2/Tw3zP3
         Zu7GBThV8KQYOJMz0diTJIFPDu0vgdL697NITwSqmj/GEkEi8epJB5/ET6nlaOkfI8Vl
         d1nCDq8gNbHn4/rmumLU+Me0xT8cp1pmYXvpfWeOJn9h2ZLJGcWenFhwZ5fo3TYXODSl
         tsaY+OCaPmhl3ii/fwC1Chpa+/w6JIAEjJbW3atVOgAaq2U/pwlao8ePPkLKVBDGHsrx
         F4Zg==
X-Gm-Message-State: AO0yUKXJfxtPoPnTpmiSzw3IXxp0qsj6wzl1ScHEzF9GgIqamKEALFJ6
        nIqgXm8tADrq/kohGnb6CwVumw==
X-Google-Smtp-Source: AK7set+xXicwL37jaTlrfb/shiaGamOWbry8o6PnaQeVzRKFxYnx12Lv7Sx0WzQdOibYTGu0C+FZjw==
X-Received: by 2002:a2e:8809:0:b0:29e:8a51:35d4 with SMTP id x9-20020a2e8809000000b0029e8a5135d4mr2614840ljh.12.1679517884481;
        Wed, 22 Mar 2023 13:44:44 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id d16-20020a2eb050000000b0029aa0b6b41asm2585686ljl.115.2023.03.22.13.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 13:44:43 -0700 (PDT)
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
Subject: [PATCH v4 1/2] KVM: irqfd: Make resampler_list an RCU list
Date:   Wed, 22 Mar 2023 21:43:43 +0100
Message-Id: <20230322204344.50138-2-dmy@semihalf.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230322204344.50138-1-dmy@semihalf.com>
References: <20230322204344.50138-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is useful to be able to do read-only traversal of the list of all the
registered irqfd resamplers without locking the resampler_lock mutex.
In particular, we are going to traverse it to search for a resampler
registered for the given irq of an irqchip, and that will be done with
an irqchip spinlock (ioapic->lock) held, so it is undesirable to lock a
mutex in this context. So turn this list into an RCU list.

For protecting the read side, reuse kvm->irq_srcu which is already used
for protecting a number of irq related things (kvm->irq_routing,
irqfd->resampler->list, kvm->irq_ack_notifier_list,
kvm->arch.mask_notifier_list).

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 include/linux/kvm_host.h  | 1 +
 include/linux/kvm_irqfd.h | 2 +-
 virt/kvm/eventfd.c        | 8 ++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..9f508c8e66e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -755,6 +755,7 @@ struct kvm {
 	struct {
 		spinlock_t        lock;
 		struct list_head  items;
+		/* resampler_list update side is protected by resampler_lock. */
 		struct list_head  resampler_list;
 		struct mutex      resampler_lock;
 	} irqfds;
diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index dac047abdba7..8ad43692e3bb 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -31,7 +31,7 @@ struct kvm_kernel_irqfd_resampler {
 	/*
 	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
 	 * resamplers among irqfds on the same gsi.
-	 * Accessed and modified under kvm->irqfds.resampler_lock
+	 * RCU list modified under kvm->irqfds.resampler_lock
 	 */
 	struct list_head link;
 };
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..61aea70dd888 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -96,8 +96,12 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
 	synchronize_srcu(&kvm->irq_srcu);
 
 	if (list_empty(&resampler->list)) {
-		list_del(&resampler->link);
+		list_del_rcu(&resampler->link);
 		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
+		/*
+		 * synchronize_srcu(&kvm->irq_srcu) already called
+		 * in kvm_unregister_irq_ack_notifier().
+		 */
 		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
 			    resampler->notifier.gsi, 0, false);
 		kfree(resampler);
@@ -369,7 +373,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			resampler->notifier.irq_acked = irqfd_resampler_ack;
 			INIT_LIST_HEAD(&resampler->link);
 
-			list_add(&resampler->link, &kvm->irqfds.resampler_list);
+			list_add_rcu(&resampler->link, &kvm->irqfds.resampler_list);
 			kvm_register_irq_ack_notifier(kvm,
 						      &resampler->notifier);
 			irqfd->resampler = resampler;
-- 
2.40.0.348.gf938b09366-goog

