Return-Path: <kvm+bounces-15556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4E08AD57E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A2911F2124A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D870155754;
	Mon, 22 Apr 2024 20:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ApDN2pWG"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84BC1553B2
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816137; cv=none; b=CBhPCgQocoqjvYhcd5WawbKX7AScvr/o5jJk+oUiLlWOSrj0LRr4DKVxgydzNs3iCvkXs0BJpZi/AALppkLxUH5b4DKj+n7Rr9cjNkvW9GixFMF12bFVS7rBVyDPor5Ho5N87BqVoMAKNSIsFYiEoVesMNqeQTMkLUQ7evZ0oko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816137; c=relaxed/simple;
	bh=RK/yM6qsOPw3n0OH0gCLys55qhO8zYpWnFFNNWH/wDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj074FjpSiMolcx/kGouv+hS1joa4rw0PBujIzqdWbYZIuVrc2pivep4qy2FJwDRyIICy7+N7TINaa8aExflqQxnfRC1YzBGZZhwu4D+Quql9PBvLOms2P/GvTA2VTB8QyTvWPfSVT6xigDPWf7EcBXnO7wXJCAngrxp6qoNiB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ApDN2pWG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQTl/Amd80cS3RGpOqQqk/wdPqY6PhjicfoJOM1VxG4=;
	b=ApDN2pWGW8vmGi+uCNyev+N1fHs/YaFPNGvJxAR5Py3bIpDzgf4J+5KHc2lCcXIeuNZO9U
	A4G7d0A+59Dwb5DQ4iM7yDwlcRBeZGE4n47fnP4CubuE7Dt2pK+wvYuMm6KfB3s2N46Qhr
	HRwJLw04ocSmYUpRmMS2JUEBgzSvVnk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 02/19] KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
Date: Mon, 22 Apr 2024 20:01:41 +0000
Message-ID: <20240422200158.2606761-3-oliver.upton@linux.dev>
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
in its_sync_lpi_pending_table().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e85a495ada9c..bdb7718b923a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -446,23 +446,18 @@ static u32 max_lpis_propbaser(u64 propbaser)
 static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 {
 	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	unsigned long intid, flags;
 	struct vgic_irq *irq;
 	int last_byte_offset = -1;
 	int ret = 0;
-	u32 *intids;
-	int nr_irqs, i;
-	unsigned long flags;
 	u8 pendmask;
 
-	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, vcpu, &intids);
-	if (nr_irqs < 0)
-		return nr_irqs;
-
-	for (i = 0; i < nr_irqs; i++) {
+	xa_for_each(&dist->lpi_xa, intid, irq) {
 		int byte_offset, bit_nr;
 
-		byte_offset = intids[i] / BITS_PER_BYTE;
-		bit_nr = intids[i] % BITS_PER_BYTE;
+		byte_offset = intid / BITS_PER_BYTE;
+		bit_nr = intid % BITS_PER_BYTE;
 
 		/*
 		 * For contiguously allocated LPIs chances are we just read
@@ -472,25 +467,23 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 			ret = kvm_read_guest_lock(vcpu->kvm,
 						  pendbase + byte_offset,
 						  &pendmask, 1);
-			if (ret) {
-				kfree(intids);
+			if (ret)
 				return ret;
-			}
+
 			last_byte_offset = byte_offset;
 		}
 
-		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		irq = vgic_get_irq(vcpu->kvm, NULL, intid);
 		if (!irq)
 			continue;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = pendmask & (1U << bit_nr);
+		if (irq->target_vcpu == vcpu)
+			irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	kfree(intids);
-
 	return ret;
 }
 
-- 
2.44.0.769.g3c40516874-goog


