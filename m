Return-Path: <kvm+bounces-66702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B76CDE615
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 07:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 28F68300C0F9
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B460C2E8B8B;
	Fri, 26 Dec 2025 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="e2PkI+0v"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6151494A8
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766730512; cv=none; b=ozVEhmjutjfCUDS5l7S0hi1dhIAxvWNMRS7k9Nk2YSgPTwjYy8yNmQrz9B3YT6QmYUU5XOQX+dTpl0VB8/wf4KXcKOtxo7fqejSBzuaFqd+JNJCGbuVxpfH5C60TtqMGqXOTyJZzjKb739SORqg5iVALnSGG9YCduxA32dGzJZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766730512; c=relaxed/simple;
	bh=edm2/HYqCeNmJFtpiI6VAtZFNJ0rJj/5moqdpCJ+cSw=;
	h=From:Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject; b=RlIc2OyiadfNBxH7ydR40OUExQhJR6onvq/KrnrD7+rYXaPgI5RNMj+L6WqzdnE0tPTDqswG9bM3qdjyYZ9PGhf1CCd5f1g4QdG7EZ+tPHIrhJLo1/GXlUW5sqBae8mdyWtiOSn6bRUfugxMyQZTm7he+m9wSowbz00Qxe/SHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=e2PkI+0v; arc=none smtp.client-ip=118.26.132.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766730502; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4wr7rT70vMYf0PM3jTnFDynCeSDhYZrEbsI5JoXonfU=;
 b=e2PkI+0vywcnYVj8dxtC4Kv7VPZeDbf02dsjUBblyUwoaQfJAUZIj2LRPMgMZ1YUTzWPnt
 sFBX1ymuZIOJvovdvIOc3O+1UDefl2ogqjs085mlp9LyEIexpjwd7pH/rVJqGZa8wiz82U
 S9aY2fk2QYxXRk2lspkXmomq/2DJTMFbZ+hleKq8F6RCNygc9yFEoHCxVA44uAHMCeh3tl
 k346KeypEnckCE09NbpCE1+9wANolNBYUnZYyo7QDKRGeH2qnJPwriYhlDpOoleebbBQwV
 2lQeajcDeGy+xA/CEBO4aKuyRJNqaKslAOjSeML2e/n/XXqd4HRG40TUSG318w==
From: "Yanfei Xu" <yanfei.xu@bytedance.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Dec 2025 14:27:41 +0800
Message-Id: <20251226062741.4014391-1-yanfei.xu@bytedance.com>
X-Original-From: Yanfei Xu <yanfei.xu@bytedance.com>
To: <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>, <caixiangfeng@bytedance.com>, 
	<fangying.tommy@bytedance.com>, <yanfei.xu@bytedance.com>
Subject: [PATCH v2] KVM: irqchip: KVM: Reduce allocation overhead in kvm_set_irq_routing()
X-Lms-Return-Path: <lba+2694e2b04+1544bc+vger.kernel.org+yanfei.xu@bytedance.com>

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
v1->v2:
1. fix variable 'r' is used uninitialized when a 'if' condition is true 
2. simplified free_irq_routing_table() by removing the iteration over the
   entries and the hlist cleanup.

 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 34 +++++++++++-----------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..cc27490bef4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -692,6 +692,7 @@ struct kvm_kernel_irq_routing_entry {
 struct kvm_irq_routing_table {
 	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
 	u32 nr_rt_entries;
+	struct kvm_kernel_irq_routing_entry *entries_addr;
 	/*
 	 * Array indexed by gsi. Each entry contains list of irq chips
 	 * the gsi is connected to.
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 6ccabfd32287..56779394033d 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -98,21 +98,10 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 
 static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
 {
-	int i;
-
 	if (!rt)
 		return;
 
-	for (i = 0; i < rt->nr_rt_entries; ++i) {
-		struct kvm_kernel_irq_routing_entry *e;
-		struct hlist_node *n;
-
-		hlist_for_each_entry_safe(e, n, &rt->map[i], link) {
-			hlist_del(&e->link);
-			kfree(e);
-		}
-	}
-
+	kfree(rt->entries_addr);
 	kfree(rt);
 }
 
@@ -186,6 +175,12 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return -ENOMEM;
+	e = kcalloc(nr, sizeof(*e), GFP_KERNEL_ACCOUNT);
+	if (!e) {
+		r = -ENOMEM;
+		goto out;
+	}
+	new->entries_addr = e;
 
 	new->nr_rt_entries = nr_rt_entries;
 	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
@@ -193,25 +188,20 @@ int kvm_set_irq_routing(struct kvm *kvm,
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
 
@@ -228,8 +218,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	r = 0;
 	goto out;
 
-free_entry:
-	kfree(e);
 out:
 	free_irq_routing_table(new);
 
-- 
2.20.1

