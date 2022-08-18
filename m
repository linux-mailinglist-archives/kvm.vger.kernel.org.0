Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1097A598DF8
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 22:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346013AbiHRU1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 16:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345992AbiHRU1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 16:27:22 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A6C1147C
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:19 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l21so2762840ljj.2
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=PO69c6RyGBcqTa1QLOjy5UbFRBMVx29/kX2gw2zcX8g=;
        b=X6a9uqkPmTe/wiCR1F38Ndh2Gwppbk9WjVhKPuOYlH4ZGj6ghp2Bj/2r0Dds1seKDr
         xHRx8m4ki7t9RlNMYFChLGewzCqVHYTLkPMT+JUlyDJAY09aikUzhwAuvQC79KA2rxbz
         QWicjFPaFpn05bcCGTyShBC5kRe7+4B86RQipHJflytE8flMV2f6BRhtlQXNd2Z/B94Y
         fAv3hFsfp5uY3eg43E6vIaxMCX84fyJWCJVzBNS0RO8uIUMXpFgIIbPprS5gew+z8it+
         ho36Cga/ewrW0N85PBfGjeUiICLVK5TE2sTOkW0dAHbPhWslzv6mWFWHCirH1KClRVEH
         hv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=PO69c6RyGBcqTa1QLOjy5UbFRBMVx29/kX2gw2zcX8g=;
        b=0cq9ivzYHyoIB45+v23agvnN8W2Tyw0440pBK06Jz2qWowtoiKIjCqCxJFMUGPfZNI
         I//c1/GejKCVieRWJ3P8SR/3tdarTcZvI3z6hQFd/2fiHDyxEexHkQMtgXBVQkonNSSs
         X/zbgBeOfy3iqNWOkFYPAykz9jIvhDYaU1M9QkXKNxWRj0V2Nkq/DMy3wlCD59dVJURk
         iVrgCGuvy+76wp5jr7SN2RIk2ODnm9d8qK4C45S2WnIuXmuOGCYCjFSfS91vchVkeMaY
         gIddhQhUz0F/m07kbfbZJgCbfioV88l+0+AuFTKnVtPtM4/GaKl6gYlUPlC9vJ0I1DpI
         Z/3Q==
X-Gm-Message-State: ACgBeo2s/uFGugd9jksvQTu8yOAafZmU5EPcF7Mr3MRP5hetw5uK7k7r
        T8FcybSGh3GucFLanJAE+7lBww==
X-Google-Smtp-Source: AA6agR5R6e55r656TctCSSz9S6PxazaSZ8nY2INMKQ6fXjoaaI1F1+1r4pswmS+Oq14jjr8tGB0pXQ==
X-Received: by 2002:a2e:90c8:0:b0:25e:74a3:db96 with SMTP id o8-20020a2e90c8000000b0025e74a3db96mr1232727ljg.18.1660854437876;
        Thu, 18 Aug 2022 13:27:17 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id b5-20020a056512070500b0048b0c59ed9asm341400lfs.227.2022.08.18.13.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:27:17 -0700 (PDT)
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
Subject: [PATCH v3 1/2] KVM: irqfd: Make resampler_list an RCU list
Date:   Thu, 18 Aug 2022 22:27:00 +0200
Message-Id: <20220818202701.3314045-2-dmy@semihalf.com>
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
index 1c480b1821e1..ee6d906e0138 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -738,6 +738,7 @@ struct kvm {
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
2.37.1.595.g718a3a8f04-goog

