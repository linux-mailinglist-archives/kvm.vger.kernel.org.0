Return-Path: <kvm+bounces-8899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C243858585
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDFB8284C0E
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABDC1468EE;
	Fri, 16 Feb 2024 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sptWkG5D"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B15145FF6
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108940; cv=none; b=Mn34znNWGHQeOiLxveVqOA6RExzex9tplXa6/BXpr37licTmAol0eJuqSPzBy8HRs0X+fuQ0AAPzsnb680ElkrVRSKG7M3AZsQbjBqo3u0SyM17ALvpSUytf8FgkziX+hqVQL3siqCD+GiD9oGl8zfRKIwQFkTN+/z0uIn7zRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108940; c=relaxed/simple;
	bh=YQt7HllDOIOc6JmEVYjsohh1WJr5UrgxtFnKA5+RyhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8JLl31ENZu0YWnen/vMmovUA1VKDpMM7lApfsTStLIJ4tpZYdPSAdddK4qRMkQnR95eJHx+mxZwW7rXNZSShWaaZKiRxIHpmMObzpd69Sy+G7jzirMj1mct2THOLyjZhoiYkWYRYHz2Yd3IprWn7xJxdXoPQVgWPwdtDYXs3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sptWkG5D; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ovim50P2MGl2zeU/Tv+W8v3zNQiqHM6FYpVR4brBrho=;
	b=sptWkG5DobDUHQ1ct3NjhArOg4jO4ZffFqJZudlIxMmKLdK/yO+1qIuMtOYePl1Qz6o37c
	NQNa9lydPyh5r9aTznErWkktC6Is36TB1b1beKShaSLIRjeJOt6+lDVTyfddnPKNPTBQM6
	fYnKx6JZmOA7Q9c8uYNyrVev/uSypt4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 06/10] KVM: arm64: vgic: Use atomics to count LPIs
Date: Fri, 16 Feb 2024 18:41:49 +0000
Message-ID: <20240216184153.2714504-7-oliver.upton@linux.dev>
In-Reply-To: <20240216184153.2714504-1-oliver.upton@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Switch to using atomics for LPI accounting, allowing vgic_irq references
to be dropped in parallel.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
 arch/arm64/kvm/vgic/vgic-its.c   | 4 ++--
 arch/arm64/kvm/vgic/vgic.c       | 2 +-
 include/kvm/arm_vgic.h           | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 85606a531dc3..389025ce7749 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -149,7 +149,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", dist->lpi_list_count);
+		seq_printf(s, "nr_lpis:\t%d\n", atomic_read(&dist->lpi_count));
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 0d1cfc776f47..27a7451ad8b9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -96,7 +96,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	dist->lpi_list_count++;
+	atomic_inc(&dist->lpi_count);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
@@ -344,7 +344,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	 * command). If coming from another path (such as enabling LPIs),
 	 * we must be careful not to overrun the array.
 	 */
-	irq_count = READ_ONCE(dist->lpi_list_count);
+	irq_count = atomic_read(&dist->lpi_count);
 	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
 	if (!intids)
 		return -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e58ce68e325c..5988d162b765 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -122,7 +122,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 		return;
 
 	xa_erase(&dist->lpi_xa, irq->intid);
-	dist->lpi_list_count--;
+	atomic_dec(&dist->lpi_count);
 
 	kfree(irq);
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index aeff363e3ba6..71e9d719533b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -273,10 +273,10 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-	/* Protects the lpi_list and the count value below. */
+	/* Protects the lpi_list. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	int			lpi_list_count;
+	atomic_t		lpi_count;
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
-- 
2.44.0.rc0.258.g7320e95886-goog


