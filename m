Return-Path: <kvm+bounces-21407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3415592E804
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 14:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E7F282B98
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 12:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E440A15B12C;
	Thu, 11 Jul 2024 12:11:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4C9155332
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720699909; cv=none; b=XzMPMGCmQeAQihF51ShNAMZqSrv0T2LQmUfUXxyr+2uqidq8urwQz53DPAgGaiQlPyUPYwAZCBJGWiF0DM9qLyjFOqe+7907MQz4On7JffhhOpbjC1BvOvrWqxb8tml5mS0hjG8iUyBjFTV1gRqhQhseRNhfcOkPEw0ANd21DXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720699909; c=relaxed/simple;
	bh=KayHDYb7PquBzsiI+AffVl397WNFlaPAleKft7uPLjY=;
	h=From:To:Cc:Subject:Date:Message-Id; b=CzWxaqNpR5Adz7v3JVlCdF4WwhiQ8kbMUvcQbeHoHYxbJQM+6JmLC6tymDY8sHzowJufH/+kc278nHQ/tQhF9RgDj69mC2Lp3x9+xLvifEuKKNhpBZE8jyGpfc/dwyvCCfecvvjCu3kta8J8cEXONZRDnSZyqekri1k8drCZ/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 4DBC37F00045;
	Thu, 11 Jul 2024 20:11:35 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: kvm@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: eventfd: Use synchronize_srcu_expedited()
Date: Thu, 11 Jul 2024 20:11:30 +0800
Message-Id: <20240711121130.38917-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

When hot-unplug a device which has many queues, and guest CPU will has
huge jitter, and unplugging is very slow.

It turns out synchronize_srcu() in irqfd_shutdown() caused the guest
jitter and unplugging latency, so replace synchronize_srcu() with
synchronize_srcu_expedited(), to accelerate the unplugging, and reduce
the guest OS jitter, this accelerates the VM reboot too.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 virt/kvm/eventfd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2295700..e9e1fa2 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -97,13 +97,13 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
 	mutex_lock(&kvm->irqfds.resampler_lock);
 
 	list_del_rcu(&irqfd->resampler_link);
-	synchronize_srcu(&kvm->irq_srcu);
+	synchronize_srcu_expedited(&kvm->irq_srcu);
 
 	if (list_empty(&resampler->list)) {
 		list_del_rcu(&resampler->link);
 		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
 		/*
-		 * synchronize_srcu(&kvm->irq_srcu) already called
+		 * synchronize_srcu_expedited(&kvm->irq_srcu) already called
 		 * in kvm_unregister_irq_ack_notifier().
 		 */
 		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
@@ -126,7 +126,7 @@ irqfd_shutdown(struct work_struct *work)
 	u64 cnt;
 
 	/* Make sure irqfd has been initialized in assign path. */
-	synchronize_srcu(&kvm->irq_srcu);
+	synchronize_srcu_expedited(&kvm->irq_srcu);
 
 	/*
 	 * Synchronize with the wait-queue and unhook ourselves to prevent
@@ -384,7 +384,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		}
 
 		list_add_rcu(&irqfd->resampler_link, &irqfd->resampler->list);
-		synchronize_srcu(&kvm->irq_srcu);
+		synchronize_srcu_expedited(&kvm->irq_srcu);
 
 		mutex_unlock(&kvm->irqfds.resampler_lock);
 	}
@@ -523,7 +523,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 	mutex_lock(&kvm->irq_lock);
 	hlist_del_init_rcu(&kian->link);
 	mutex_unlock(&kvm->irq_lock);
-	synchronize_srcu(&kvm->irq_srcu);
+	synchronize_srcu_expedited(&kvm->irq_srcu);
 	kvm_arch_post_irq_ack_notifier_list_update(kvm);
 }
 
@@ -608,7 +608,7 @@ kvm_irqfd_release(struct kvm *kvm)
 
 /*
  * Take note of a change in irq routing.
- * Caller must invoke synchronize_srcu(&kvm->irq_srcu) afterwards.
+ * Caller must invoke synchronize_srcu_expedited(&kvm->irq_srcu) afterwards.
  */
 void kvm_irq_routing_update(struct kvm *kvm)
 {
-- 
2.9.4


