Return-Path: <kvm+bounces-15563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729738AD586
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DC9C283EF5
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4FE156883;
	Mon, 22 Apr 2024 20:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dHm7sECa"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96186156862
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816151; cv=none; b=j4P+UcdyCwB/MEtJwkYY4XJHRnK64aa+ziMMvP+ru9pWRfUC+21VvrBnRkehrnEBQGH0exWSFt+4rrW0WlLteb2fA5alYdHhGbeh/tJpevA+a68F9dqbkAB9qYI8TaL9EWRL45YjsP1+02IByFwJRN6SX2+L7/PtsJ3Z6D6UVKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816151; c=relaxed/simple;
	bh=itnfuxJ6+rE6BiAHmDFHZm/1xEx8lmseJ9IXHRrfrts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8Of8oJ3HhIlHvlha5zetQ1IvePPs7/xB6dsLAW6kQzySkMbUB/bLQa7he/KmMDnSyfSKW10Og4kt9vE5Cs65rTGA6X4/VoPH//U6SXu8eeLB5jBO8yqAy6BGH5M02rDKz3BZDJ46lvAMtE7scLbPqIEZ4ystkZF13I3OF5IQBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dHm7sECa; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usZ21hBIEurq53tziYoF2qW5yO8+NMKdWd+TT+5MVfU=;
	b=dHm7sECaS+PH1UztzGnYlrno2KmepshOV2cpGZk7HJi8fhd0wB3MQt0Ng3SQGl31TxfacQ
	epI3ZRFKXzE7LtPZBxe9t3yCrkMXIhjNFB9JlO0OywBqjqhf6TJI444gZUtzWRY4x0N1n9
	lvTlMBEe3X9JuNzezzKOqbNKfL5qD+E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 09/19] KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
Date: Mon, 22 Apr 2024 20:01:48 +0000
Message-ID: <20240422200158.2606761-10-oliver.upton@linux.dev>
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

The fast path will soon need to find an ITS by doorbell address, as the
translation caches will become local to an ITS. Spin off a helper to do
just that.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 35 ++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1cea0d78025b..237e92016c1b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -511,9 +511,29 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static struct vgic_its *__vgic_doorbell_to_its(struct kvm *kvm, gpa_t db)
+{
+	struct kvm_io_device *kvm_io_dev;
+	struct vgic_io_device *iodev;
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, db);
+	if (!kvm_io_dev)
+		return ERR_PTR(-EINVAL);
+
+	if (kvm_io_dev->ops != &kvm_io_gic_ops)
+		return ERR_PTR(-EINVAL);
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+	if (iodev->iodev_type != IODEV_ITS)
+		return ERR_PTR(-EINVAL);
+
+	return iodev->its;
+}
+
 static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
 {
 	return (((unsigned long)devid) << VITS_TYPER_IDBITS) | eventid;
+
 }
 
 static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
@@ -721,8 +741,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 {
 	u64 address;
-	struct kvm_io_device *kvm_io_dev;
-	struct vgic_io_device *iodev;
 
 	if (!vgic_has_its(kvm))
 		return ERR_PTR(-ENODEV);
@@ -732,18 +750,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 
 	address = (u64)msi->address_hi << 32 | msi->address_lo;
 
-	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
-	if (!kvm_io_dev)
-		return ERR_PTR(-EINVAL);
-
-	if (kvm_io_dev->ops != &kvm_io_gic_ops)
-		return ERR_PTR(-EINVAL);
-
-	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
-	if (iodev->iodev_type != IODEV_ITS)
-		return ERR_PTR(-EINVAL);
-
-	return iodev->its;
+	return __vgic_doorbell_to_its(kvm, address);
 }
 
 /*
-- 
2.44.0.769.g3c40516874-goog


