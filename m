Return-Path: <kvm+bounces-66665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A512CDB2FB
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 03:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAEB83035A71
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9961B2882D6;
	Wed, 24 Dec 2025 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="VfvKjo6S"
X-Original-To: kvm@vger.kernel.org
Received: from lf-1-130.ptr.blmpb.com (lf-1-130.ptr.blmpb.com [103.149.242.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAD523EAB9
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543626; cv=none; b=Vk2VER3E9/J7kYNOHfYKd+YyrM7ZUFjp4FvyL/VBJ4KRmZNwuqr7Tcj/wZfOs+5nVnQjQaKWKbpbAdb7tL2uH39cFVzGAG3N7iLHGrNGj3BxI9Z/msJ3eIsVB4zBbQ5BlZprPIuNFi6Z+2QZRlvWopiWwl3r7hfTfmVCWq6XirQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543626; c=relaxed/simple;
	bh=t/JA5vUFCPEiXWesqZIq1fvupVsswIDNwiD5qG1vHHM=;
	h=Content-Type:From:Subject:Date:Mime-Version:To:Cc:Message-Id; b=LYciXeDXc86KsPDIFD+CXkc1k+AGwQ3+jUGXpRaIgqQJUGrRvnKfTyTuFNGJ114LC497GvhNkMZerzXeXiQWftVEo4tLvOTZMUSpJl5qcozfbnu7R18dcbm028/b5J1ZNTyvicGJjvdbHDGZ/e4MisZ2N7VNN/oMlx30AkxhkmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=VfvKjo6S; arc=none smtp.client-ip=103.149.242.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766543535; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7JaJuvGN6SpkcwcpExZleHtDkOBMMcDKhKcJ7fR+CCY=;
 b=VfvKjo6SSckNlyRh+pLVq1KXjbb4uFrGaVQv48AZcpQJXUYcVVaYQpuS1IN2YdfIktK119
 4eR7M4flmT7dLUT/dzWGGBT1D0mS1SORulXJbd0vFkCMBM+PPhXWMcsjLaOfp2ol4eecAc
 Q52nZ6x89++AzHypvxJVwb2gSyprbLGYfLIVKV9jN2pzYgtwnU9IkU1IzFFOfuC45YkiqO
 aEaUcMHpDCJopg7M6hN9xc19HRnLZmOhFOET6lH11MYNe0fmwVnfsFEDdZvcP7drUG+0FG
 xW2uvo29XfjM1pUNSP1PSGeWeMy0qTzAsM0tQWcmDaBI6Pz7OW6ycyGGQLT8AQ==
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Yanfei Xu" <yanfei.xu@bytedance.com>
Subject: [PATCH] KVM: irqchip: KVM: Reduce allocation overhead in kvm_set_irq_routing()
Date: Wed, 24 Dec 2025 10:32:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2694b50ad+600725+vger.kernel.org+yanfei.xu@bytedance.com>
X-Original-From: Yanfei Xu <yanfei.xu@bytedance.com>
To: <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>, <caixiangfeng@bytedance.com>, 
	<fangying.tommy@bytedance.com>, <yanfei.xu@bytedance.com>
Message-Id: <20251224023201.381586-1-yanfei.xu@bytedance.com>

In guests with many VFIO devices and MSI-X vectors, kvm_set_irq_routing()
becomes a high-overhead operation. Each invocation walks the entire IRQ
routing table and reallocates/frees every routing entry.

As the routing table grows on each call, entry allocation and freeing
dominate the execution time of this function. In scenarios such as VM
live migration or live upgrade, this behavior can introduce unnecessary
downtime.

Allocate memory for all routing entries in one shot using kcalloc(),
allowing them to be freed together with a single kfree() call.

Example: On a VM with 120 vCPUs and 15 VFIO devices (virtio-net), the
total number of calls to kzalloc and kfree is over 20000. With this
change, it is reduced to around 30.

Reported-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
Signed-off-by: Yanfei Xu <yanfei.xu@bytedance.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 21 +++++++++------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..aae6ea9940a0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -690,6 +690,7 @@ struct kvm_kernel_irq_routing_entry {
 struct kvm_irq_routing_table {
 	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
 	u32 nr_rt_entries;
+	struct kvm_kernel_irq_routing_entry *entries_addr;
 	/*
 	 * Array indexed by gsi. Each entry contains list of irq chips
 	 * the gsi is connected to.
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 6ccabfd32287..0eac1c634fa5 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -109,10 +109,10 @@ static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
 
 		hlist_for_each_entry_safe(e, n, &rt->map[i], link) {
 			hlist_del(&e->link);
-			kfree(e);
 		}
 	}
 
+	kfree(rt->entries_addr);
 	kfree(rt);
 }
 
@@ -186,6 +186,10 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return -ENOMEM;
+	e = kcalloc(nr, sizeof(*e), GFP_KERNEL_ACCOUNT);
+	if (!e)
+		goto out;
+	new->entries_addr = e;
 
 	new->nr_rt_entries = nr_rt_entries;
 	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
@@ -193,25 +197,20 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			new->chip[i][j] = -1;
 
 	for (i = 0; i < nr; ++i) {
-		r = -ENOMEM;
-		e = kzalloc(sizeof(*e), GFP_KERNEL_ACCOUNT);
-		if (!e)
-			goto out;
-
 		r = -EINVAL;
 		switch (ue->type) {
 		case KVM_IRQ_ROUTING_MSI:
 			if (ue->flags & ~KVM_MSI_VALID_DEVID)
-				goto free_entry;
+				goto out;
 			break;
 		default:
 			if (ue->flags)
-				goto free_entry;
+				goto out;
 			break;
 		}
-		r = setup_routing_entry(kvm, new, e, ue);
+		r = setup_routing_entry(kvm, new, e + i, ue);
 		if (r)
-			goto free_entry;
+			goto out;
 		++ue;
 	}
 
@@ -228,8 +227,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	r = 0;
 	goto out;
 
-free_entry:
-	kfree(e);
 out:
 	free_irq_routing_table(new);
 
-- 
2.20.1

