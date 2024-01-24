Return-Path: <kvm+bounces-6878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A9283B347
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:51:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BAA61C222E2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A14135A7C;
	Wed, 24 Jan 2024 20:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UCFzyySB"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C0C135A57
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129391; cv=none; b=DPhKtC3WYF1+2SvDdBvb1yBhkFE0ZOv/sMJYq9gWL048zx/U1y5V9CbALuFYZbWGZPu8UFU7+VUU0XKBnn4cbkGECRwAjfNb80JTVsNfp7pYwKDTN/QUAyyahlt5Ma6xbJrwlY81MKa/9HyEEedpe4QuOTAo1qgz0Vy8Po2Nte0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129391; c=relaxed/simple;
	bh=zLh5rirk9xIasi9yvIQwcfwIRUE75kHp5mBYXmy5RQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZpZSsMvhzpNkIt0XGUBcjej43vYHGQcVvE4sHcfSwNOHqripCv146C8XRJYfcvUkEtx/SFtf0B+/FLkQDEaNBqk6lOjcZp5bEJYCBXXdjzvFzy7hOgXv9r+T0cUzSAUSn2wkde9Sgf9hfis0bVXbKdkzHe6bECX8ctRcbt7+Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UCFzyySB; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5NDypmTFyIFRVIwUeZ2Km9VEABncd2W2wdVuF/Yz7UI=;
	b=UCFzyySBUeZTb9dKijn5GnBl22cCNrJ0pFPnbyHC/LUe3+t7CrTeN62wS+ZFf7knalSfxU
	TMf1EdjRnt0pJeIxaMY4NpgDT1dtU00/jPmLsP5Be8a5HvpsakbFVGlZtiWT+YYEQnNn9r
	83NyZLxRTkCj9nzJVy6rgRX/2lY4qc0=
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
Subject: [PATCH 14/15] KVM: arm64: vgic-its: Treat the LPI translation cache as an rculist
Date: Wed, 24 Jan 2024 20:49:08 +0000
Message-ID: <20240124204909.105952-15-oliver.upton@linux.dev>
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

Convert the LPI translation cache to an rculist such that readers can
walk it while only holding the RCU read lock.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 79b35fdaa1cd..1670b452c682 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -566,7 +566,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 {
 	struct vgic_translation_cache_entry *cte;
 
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+	list_for_each_entry_rcu(cte, &dist->lpi_translation_cache, entry) {
 		/*
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
@@ -671,7 +671,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 			goto out;
 		}
 
-		list_del(&victim->entry);
+		list_del_rcu(&victim->entry);
 		dist->lpi_cache_count--;
 	} else {
 		victim = NULL;
@@ -690,7 +690,8 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	rcu_assign_pointer(new->irq, irq);
 
 	/* Move the new translation to the head of the list */
-	list_add(&new->entry, &dist->lpi_translation_cache);
+	list_add_rcu(&new->entry, &dist->lpi_translation_cache);
+	dist->lpi_cache_count++;
 
 out:
 	rcu_read_unlock();
@@ -704,6 +705,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (victim && victim->irq)
 		vgic_put_irq(kvm, victim->irq);
 
+	synchronize_rcu();
 	kfree(victim);
 }
 
-- 
2.43.0.429.g432eaa2c6b-goog


