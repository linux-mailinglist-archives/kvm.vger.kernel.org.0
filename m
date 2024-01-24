Return-Path: <kvm+bounces-6871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 475DA83B340
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3CCE285747
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DEC135A41;
	Wed, 24 Jan 2024 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uq7HGbrw"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE32D1350C2
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129378; cv=none; b=SkOzYgYTsvwLYv8oxUZiV9GT7jW7S3iVsCWAVic6bjXmIx+cjuEnWPsn7dmNTo/NQ3ZQnLkrhKdxDIyOBfYNEsuPeJB0TJfUgGRlYRrNojW7jnVCKe/E7WD+JmIkQyjIm5kD43i+wOpBrEoIvMJLNPiPAy1K4MiruWSm0Irgwk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129378; c=relaxed/simple;
	bh=qY4V4V8zZDoaf3u8iSxofhASVbe4oRXpUzZDgzVWLOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVog6CM4sqk15DYpUFnbqhDIGcJ5wnJzkYBxJiH67QRGi84qDP7g7nOj2jtNuSBZRf9zcAkkGdhppv91NQ8pn4qUcXPNdNyA4LIeY641NJ0mePrmB7+laQpSQA2ms8hfOJzPWw8rv2e3lCFKq++fLeJTHfVpgmUfIp22rC1DQNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uq7HGbrw; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJV18VS+eQbuqvjOmYfLuHXF00F9ZRH1HOLRMBo/vo0=;
	b=uq7HGbrwbZDoDVYt6UeY5TwwNhOF9A0NTJQ/FkIx2MBncZWJU44UbMD36SUD9uJG2dvLYE
	Up0RemD5n/PvVlvHFuDO8LA8qfo2qCe3lMJXnT4IB7m1tsPueOYSbU9YQ6c6vzKTdtpeUT
	o1/SB2w8sLkWvcCjDaeN7ITpuHi5X08=
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
Subject: [PATCH 07/15] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
Date: Wed, 24 Jan 2024 20:49:01 +0000
Message-ID: <20240124204909.105952-8-oliver.upton@linux.dev>
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

Free the vgic_irq structs in an RCU-safe manner to allow reads of the
LPI configuration data to happen in parallel with the release of LPIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 include/kvm/arm_vgic.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5988d162b765..be3ed4c5e1fa 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -124,7 +124,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	xa_erase(&dist->lpi_xa, irq->intid);
 	atomic_dec(&dist->lpi_count);
 
-	kfree(irq);
+	kfree_rcu(irq, rcu);
 }
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e944536feee8..a6f6c1583662 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -117,6 +117,7 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
+	struct rcu_head rcu;
 	struct list_head lpi_list;	/* Used to link all LPIs together */
 	struct list_head ap_list;
 
-- 
2.43.0.429.g432eaa2c6b-goog


