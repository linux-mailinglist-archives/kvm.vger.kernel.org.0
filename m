Return-Path: <kvm+bounces-69819-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFnPNP5mgGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69819-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB10C9D66
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C95A3301450C
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAFC335555;
	Mon,  2 Feb 2026 08:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hTsSgort"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C022BF00B
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022647; cv=none; b=flypyknR96iKV76X++WT15Vesz0u4WPqZHdXlFUWq1Pw2A8RuMARj0Ef4darnrRLQHBXvY6JAnOYkovaowbyvxo/D4nsTdTwQuLp8ecSnuWoXFvbS+htzqsy91hTaHse9dETMxEv8BFNx7+ppMiwn6D9W8juy+0WkE55H5kaN7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022647; c=relaxed/simple;
	bh=U1bqRjqLDXm7+Kp/Ls7yUhMWX5A1fXxHSERSBzh3KnM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bCjXd4+BX0xhvqQG8EbtaSnGO/k7zgOsHgjbcdybnwfZj1XIRCMILXXeuDobi3xNoPlIpDcU8pd0FXiySGA2s4PaapX9+WEuMawRCYvybXntId/ASFyD8948GiIuGNRNeDLJd+26wdm1/busq3xfllmS94CPpAtfORnRQi/iXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hTsSgort; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4802bb29400so54998725e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 00:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022644; x=1770627444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLZMuDSaLum3lZeNGFbi2PdhCi3/HMn1WnF6o814fEI=;
        b=hTsSgortdze9ujpcouLImN/W4oAc7YZNEuT31VHI7On1y/Y6mwe7DZv8KLHrgcqfvJ
         axaDsIn/iZvhV/5N4OjKW1nB0T5xQahyj8o/k/o+SRzyI2laQnXPipM0nkJjz3ZQh92r
         PGpKoghyuPEi26D5pVvAyCDGfoVCOQAKQUmGLCDuaCpE9Wb/LO2MRSUYmZWk81kGwBqj
         xPBWgJJ9QnO9hV2imGbLxhXF9p0fyNFt07zCoBgPIJh8Y9JEqWgWeeotbjKsBCZMW4jQ
         bJr/ywf68VB13q7TphTJ0k68LhDO/kJmmxqtZQVFvt+YQikjYDVCEFKgEV2FC0i7f2+H
         PeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022644; x=1770627444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLZMuDSaLum3lZeNGFbi2PdhCi3/HMn1WnF6o814fEI=;
        b=mf8yTVJqZsijG3fWJ9/nmmP5LKiMShEy0ByeAFXkWA8qPtRGsMaAw0ODm/8gxaMf0D
         NSG+aA4sjjdHsZ0e/EL4mlBSJ6yMpHAEPOpXXo3hL+w0NNbXUuC1NhfyNwo7TUjs+V8Q
         J3oMCVnwyaLkGu5HHgefcdUrtyHW/v+Q1ZsfAdkQ7G09//Q/WXCSURYKR2k2uTMFuJSS
         3h6F2vkXIDgPL6Ss7utZwTn76Hg45tOVTp+JZ2X2WmcrR9t5732eIuWUo8t/UDG4SGy6
         708CMdGcnM0pYKvld5gBDdpyNTRKWktW/0mZXmB3rvCt3AbtLRjkUkaPm/Zl5b6rD8a1
         b81A==
X-Gm-Message-State: AOJu0YxkH+LSdht7TvE56Q8D4xPD4HfvXKnpXh63Y5w59RfEWPuO0Al2
	UEbW8ogUG4NUptJlnSuWCrBdb188m8/2VMbVxWFQh5XtOkldvaHfE207jVgHDnFmuP1fcFlYFDO
	NDNCbuMOKkc30//s8OEIGOna4dsUQ4wtfftJ/mxAxwdx1rq2KaujuLtQk2uDB+kZ+VR092JqEiO
	QovZCIYGXt5CLkUFZ8ZKYrjJ42QNw=
X-Received: from wmi9.prod.google.com ([2002:a05:600c:209:b0:480:4a03:7b77])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8716:b0:47e:d943:ec08
 with SMTP id 5b1f17b1804b1-482db4919a6mr128609935e9.28.1770022644456; Mon, 02
 Feb 2026 00:57:24 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:20 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-3-tabba@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Reimplement vgic-debug XArray iteration
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-69819-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 3AB10C9D66
X-Rspamd-Action: no action

The vgic-debug interface implementation uses XArray marks
(`LPI_XA_MARK_DEBUG_ITER`) to "snapshot" LPIs at the start of iteration.
This modifies global state for a read-only operation and complicates
reference counting, leading to leaks if iteration is aborted or fails.

Reimplement the iterator to use dynamic iteration logic:

- Remove `lpi_idx` from `struct vgic_state_iter`.
- Replace the XArray marking mechanism with dynamic iteration using
  `xa_find_after(..., XA_PRESENT)`.
- Wrap XArray traversals in `rcu_read_lock()`/`rcu_read_unlock()` to
  ensure safety against concurrent modifications (e.g., LPI unmapping).
- Handle potential races where an LPI is removed during iteration by
  gracefully skipping it in `show()`, rather than warning.
- Remove the unused `LPI_XA_MARK_DEBUG_ITER` definition.

This simplifies the lifecycle management of the iterator and prevents
resource leaks associated with the marking mechanism, and paves the way
for using a standard seq_file iterator.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 68 ++++++++++----------------------
 include/kvm/arm_vgic.h           |  1 -
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index bb92853d1fd3..ec3d0c1fe703 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -25,11 +25,9 @@
 struct vgic_state_iter {
 	int nr_cpus;
 	int nr_spis;
-	int nr_lpis;
 	int dist_id;
 	int vcpu_id;
 	unsigned long intid;
-	int lpi_idx;
 };
 
 static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
@@ -45,13 +43,15 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 	 * Let the xarray drive the iterator after the last SPI, as the iterator
 	 * has exhausted the sequentially-allocated INTID space.
 	 */
-	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1) &&
-	    iter->nr_lpis) {
-		if (iter->lpi_idx < iter->nr_lpis)
-			xa_find_after(&dist->lpi_xa, &iter->intid,
-				      VGIC_LPI_MAX_INTID,
-				      LPI_XA_MARK_DEBUG_ITER);
-		iter->lpi_idx++;
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
+		if (iter->intid == VGIC_LPI_MAX_INTID + 1)
+			return;
+
+		rcu_read_lock();
+		if (!xa_find_after(&dist->lpi_xa, &iter->intid,
+				   VGIC_LPI_MAX_INTID, XA_PRESENT))
+			iter->intid = VGIC_LPI_MAX_INTID + 1;
+		rcu_read_unlock();
 		return;
 	}
 
@@ -61,44 +61,21 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 		iter->intid = 0;
 }
 
-static int iter_mark_lpis(struct kvm *kvm)
+static int vgic_count_lpis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long intid, flags;
 	struct vgic_irq *irq;
+	unsigned long intid;
 	int nr_lpis = 0;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
-
-	xa_for_each(&dist->lpi_xa, intid, irq) {
-		if (!vgic_try_get_irq_ref(irq))
-			continue;
-
-		__xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+	rcu_read_lock();
+	xa_for_each(&dist->lpi_xa, intid, irq)
 		nr_lpis++;
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	rcu_read_unlock();
 
 	return nr_lpis;
 }
 
-static void iter_unmark_lpis(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long intid, flags;
-	struct vgic_irq *irq;
-
-	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
-		xa_lock_irqsave(&dist->lpi_xa, flags);
-		__xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
-		xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
-		/* vgic_put_irq() expects to be called outside of the xa_lock */
-		vgic_put_irq(kvm, irq);
-	}
-}
-
 static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 		      loff_t pos)
 {
@@ -108,8 +85,6 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		iter->nr_lpis = iter_mark_lpis(kvm);
 
 	/* Fast forward to the right position if needed */
 	while (pos--)
@@ -121,7 +96,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
 		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
-		(!iter->nr_lpis || iter->lpi_idx > iter->nr_lpis);
+		iter->intid > VGIC_LPI_MAX_INTID;
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
@@ -178,7 +153,6 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
-	iter_unmark_lpis(kvm);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->arch.config_lock);
@@ -188,13 +162,14 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist,
 			     struct vgic_state_iter *iter)
 {
 	bool v3 = dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3;
+	struct kvm *kvm = s->private;
 
 	seq_printf(s, "Distributor\n");
 	seq_printf(s, "===========\n");
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", iter->nr_lpis);
+		seq_printf(s, "nr_lpis:\t%d\n", vgic_count_lpis(kvm));
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
@@ -291,16 +266,13 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (iter->vcpu_id < iter->nr_cpus)
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
 
-	/*
-	 * Expect this to succeed, as iter_mark_lpis() takes a reference on
-	 * every LPI to be visited.
-	 */
 	if (iter->intid < VGIC_NR_PRIVATE_IRQS)
 		irq = vgic_get_vcpu_irq(vcpu, iter->intid);
 	else
 		irq = vgic_get_irq(kvm, iter->intid);
-	if (WARN_ON_ONCE(!irq))
-		return -EINVAL;
+
+	if (!irq)
+		return 0;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d0..d32fafbd2907 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -300,7 +300,6 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-#define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
 	/* used by vgic-debug */
-- 
2.53.0.rc1.225.gd81095ad13-goog


