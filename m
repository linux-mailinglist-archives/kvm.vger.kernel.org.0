Return-Path: <kvm+bounces-15562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A5B8AD585
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5B301F2131D
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AF2156863;
	Mon, 22 Apr 2024 20:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rPV3fhOb"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF47156677
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816149; cv=none; b=PFJB4iF+9VLh8THJARa6+tcEeBIohsAoOzDxo30nnMyLRB3k0F/ezavuCL36c92FbJtz7lVb2jDammS2gtunZ5ha6KrwYmn6QxueUGnBiwK/Tx1eoKBVSM40DWPCv6K6+PbBdpwc9Du8LMuKecOG5+3VX+Cl0KF9GFh2WN10Z/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816149; c=relaxed/simple;
	bh=RmdMS+sIid5yrctiw8/krFqPZXM8wl8DA6R1nJjTSns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POrw964uGC49HUPlTfI4ESnDPEg/OyULbdzw9zni1PswiQmaAzNZOD9rwfdIc5kBdQLHDkwo2PGS7p48zK1E0iwn2sr2C6tVQOhfMy7g/g1VG5X8UK8hZedVq3o+eaXCIlexYY0Cg4f56ko4aKjLtn/6qn2gITlIRpl8fiabaCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rPV3fhOb; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Xo45VnyP5WiZLRvoro1+6VksntUTupRoJw5sX+LPo=;
	b=rPV3fhObEXAbI+qw8bTgHnE/cNdZUv1UQlGr1C2ClZhjLTvpGf4ZnmYJkE24fc/CRtDpUs
	5xHrgalYmz/Hr/aE8yh6qjMZ/fFcv8ViZZHuG6wSWWrsEy7QQLgFgTr1kran59sH5hQf4A
	EDCfdH+zWZZ6Ts7/UEHrGyjK5Z7dj8A=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 08/19] KVM: arm64: vgic-its: Maintain a translation cache per ITS
Date: Mon, 22 Apr 2024 20:01:47 +0000
Message-ID: <20240422200158.2606761-9-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Within the context of a single ITS, it is possible to use an xarray to
cache the device ID & event ID translation to a particular irq
descriptor. Take advantage of this to build a translation cache capable
of fitting all valid translations for a given ITS.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 37 +++++++++++++++++++++++++++++++++-
 include/kvm/arm_vgic.h         |  6 ++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2caa30bf20c7..1cea0d78025b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -511,6 +511,11 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
+{
+	return (((unsigned long)devid) << VITS_TYPER_IDBITS) | eventid;
+}
+
 static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 					       phys_addr_t db,
 					       u32 devid, u32 eventid)
@@ -564,8 +569,10 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
 {
+	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
+	struct vgic_irq *old;
 	unsigned long flags;
 	phys_addr_t db;
 
@@ -604,6 +611,15 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
 	 */
 	lockdep_assert_held(&its->its_lock);
+
+	/*
+	 * Yes, two references are necessary at the moment:
+	 *  - One for the global LPI translation cache
+	 *  - Another for the translation cache belonging to @its
+	 *
+	 * This will soon disappear.
+	 */
+	vgic_get_irq_kref(irq);
 	vgic_get_irq_kref(irq);
 
 	cte->db		= db;
@@ -613,6 +629,16 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 
 	/* Move the new translation to the head of the list */
 	list_move(&cte->entry, &dist->lpi_translation_cache);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	/*
+	 * The per-ITS cache is a perfect cache, so it may already have an
+	 * identical translation even if it were missing from the global
+	 * cache. Ensure we don't leak a reference if that is the case.
+	 */
+	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
+	if (old)
+		vgic_put_irq(kvm, old);
 
 out:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
@@ -623,7 +649,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	struct kvm *kvm = its->dev->kvm;
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
-	unsigned long flags;
+	unsigned long flags, idx;
+	struct vgic_irq *irq;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
@@ -640,6 +667,11 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	}
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	xa_for_each(&its->translation_cache, idx, irq) {
+		xa_erase(&its->translation_cache, idx);
+		vgic_put_irq(kvm, irq);
+	}
 }
 
 void vgic_its_invalidate_all_caches(struct kvm *kvm)
@@ -1962,6 +1994,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
+	xa_init(&its->translation_cache);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
@@ -1992,6 +2025,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 
 	vgic_its_free_device_list(kvm, its);
 	vgic_its_free_collection_list(kvm, its);
+	vgic_its_invalidate_cache(its);
+	xa_destroy(&its->translation_cache);
 
 	mutex_unlock(&its->its_lock);
 	kfree(its);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ac7f15ec1586..c15e7fcccb86 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -210,6 +210,12 @@ struct vgic_its {
 	struct mutex		its_lock;
 	struct list_head	device_list;
 	struct list_head	collection_list;
+
+	/*
+	 * Caches the (device_id, event_id) -> vgic_irq translation for
+	 * LPIs that are mapped and enabled.
+	 */
+	struct xarray		translation_cache;
 };
 
 struct vgic_state_iter;
-- 
2.44.0.769.g3c40516874-goog


