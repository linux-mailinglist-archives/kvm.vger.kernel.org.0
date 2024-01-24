Return-Path: <kvm+bounces-6872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B05083B341
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E32421F2346C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209A2135414;
	Wed, 24 Jan 2024 20:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SqbU3ANK"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCC1350E8
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129381; cv=none; b=m4RigZE1KmxXUZ95yc68vQxD58L6DSK0Tafn7WiQOiefzyJ2s7F8qa+/bL0e8I5pAf4nbRV32uhsg0igaG5C+9OkZoX6AXaskD/G5jAU065nbY9lNGuhyatx1WbIX4f0i+fEI/QuDhxm6Y/lhwxC9F4zGvhY2UXw3trPxg40L7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129381; c=relaxed/simple;
	bh=DAkL2Y9gxAm/I7me//FA38b8lKO9PwoCRKLKU4/roWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyE5DH+YIn7DSn4au5tJfslNGOxWd8An3s0Gg9EdfagTMGwH9VGu2+a9zvumzE50fWL4jieV/eHv0kc+HbiWOpPVOMaSj04fclmEM68RbVLx1SaVlRCvHQ1sMcVXmD7+KuoevbqWc4x2kVOzUQ2s1nsjrDZdXR6QO/k+NjDVy3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SqbU3ANK; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+qjGFCXzXN4Bwc8iaYXwhCvz8/RNxUojqqBTdUJ0KM=;
	b=SqbU3ANKSAqHlEzCx0w6jK0PtznQH31HZOLK8yjb43D0hZl042x2NxiiTABADbuelBSBCv
	EW3i/orakJzSy5v1io8w5tQ+XghZRna9t02DIuJ8caJDLUbylgSUrD4voVXCBMdxBm8dBA
	pmlNRtkmpdXaHvrR99MoTP10smAyWZA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/15] KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
Date: Wed, 24 Jan 2024 20:49:02 +0000
Message-ID: <20240124204909.105952-9-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Stop acquiring the lpi_list_lock in favor of RCU for protecting
the read-side critical section in vgic_get_lpi(). In order for this to
be safe, we also need to be careful not to take a reference on an irq
with a refcount of 0, as it is about to be freed.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c |  9 ++++-----
 arch/arm64/kvm/vgic/vgic.h | 11 ++++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index be3ed4c5e1fa..949af87bb599 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -62,15 +62,14 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq = NULL;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	irq = xa_load(&dist->lpi_xa, intid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (irq && !vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	rcu_read_unlock();
 
 	return irq;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8d134569d0a1..20886f57416a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -220,12 +220,17 @@ void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+static inline bool vgic_try_get_irq_kref(struct vgic_irq *irq)
 {
 	if (irq->intid < VGIC_MIN_LPI)
-		return;
+		return true;
+
+	return kref_get_unless_zero(&irq->refcount);
+}
 
-	kref_get(&irq->refcount);
+static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+{
+	WARN_ON_ONCE(!vgic_try_get_irq_kref(irq));
 }
 
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
-- 
2.43.0.429.g432eaa2c6b-goog


