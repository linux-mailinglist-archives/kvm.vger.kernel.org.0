Return-Path: <kvm+bounces-15558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 621398AD580
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17A891F2143E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAC81553B0;
	Mon, 22 Apr 2024 20:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vFk4muW5"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91AC156232
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816142; cv=none; b=TqBV3jHqPaEO80qMGY9coXrLfSrFSkJUiL86IZbe5mHRPmu1zK1VZiFtKphS+db5/JJ0VYIMMuMSdUs40SpnrSFmqbzkB8//3O8J7EPQco/S/SduiNjP/oZRqz2zW8KxIs3EASJM6nBaVFBBUmkkkL3Nc1nitEQSOiZr6DxXwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816142; c=relaxed/simple;
	bh=sCysN5H+IjGiCJLkDeIpe0lHif6Nd2hYWAXWQ00rj3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/WhgIveqav04yFgGwwAsrRzPCtJm/SJsg2QkVCrzOlEVSx7WItPYwkbUV3aP42a8Ctv0NkgmPyA9FHgN4Ly+xi3pkUdkmi6BKbbI0nq0eCs2hihDVfg5vaVz+2U+Zw9nn7jyesThaJqztgMeXRsqmcEhiosKdbxLhvvtzIS/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vFk4muW5; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HYmeC0MP3tvp0vfvkVCbJAmJdwZVt+xQb8QlgbKVB4Y=;
	b=vFk4muW5+89KQgaMPE9cb5AaDDunZrsR5ECS1ZQsZA9yApULJeVwiN6obCGGO2TCKbFiSH
	yf3+9Gqc2CIjD84GQpImDu3FEuC/gNZzbdiHl4UVwu7pIgi6GQkHXSUW8Sw7E9GclB4r5k
	Z+dJWDYLVd8ATqBuDEjFACTRHUu8Els=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 04/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
Date: Mon, 22 Apr 2024 20:01:43 +0000
Message-ID: <20240422200158.2606761-5-oliver.upton@linux.dev>
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

The new LPI xarray makes it possible to walk the VM's LPIs without
holding a lock, meaning that vgic_copy_lpi_list() is no longer
necessary. Prepare for the deletion by walking the LPI xarray directly
in vgic_its_cmd_handle_movall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 07706c5e996b..420a71597b78 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1420,10 +1420,10 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
-	u32 *intids;
-	int irq_count, i;
+	unsigned long intid;
 
 	/* We advertise GITS_TYPER.PTA==0, making the address the vcpu ID */
 	vcpu1 = kvm_get_vcpu_by_id(kvm, its_cmd_get_target_addr(its_cmd));
@@ -1435,12 +1435,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (vcpu1 == vcpu2)
 		return 0;
 
-	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
-	if (irq_count < 0)
-		return irq_count;
-
-	for (i = 0; i < irq_count; i++) {
-		irq = vgic_get_irq(kvm, NULL, intids[i]);
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(kvm, NULL, intid);
 		if (!irq)
 			continue;
 
@@ -1451,7 +1447,6 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	vgic_its_invalidate_cache(kvm);
 
-	kfree(intids);
 	return 0;
 }
 
-- 
2.44.0.769.g3c40516874-goog


