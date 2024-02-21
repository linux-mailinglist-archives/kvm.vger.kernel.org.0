Return-Path: <kvm+bounces-9259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0697185CFF3
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 378E61C22E4B
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 05:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004F63B29A;
	Wed, 21 Feb 2024 05:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mbz+iDp+"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8F73A8E3
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 05:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494205; cv=none; b=pCbp/4N7g9b3tFG4duFhnNhNk1kctSxlTCauRWr3cjwoYITIX741TfDnQWb7KaJXY0fYniM10Yc9eM7q3YyjV+3hS1Q8OLKKX8cOt1X6L2u88NEUAI0g1fRZfvVww6DoUdPW/VrgcNxfdbG8aSzhRig/G4Q783jirMRmCQKcJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494205; c=relaxed/simple;
	bh=PdEyg5rDXT1t31oqeD150AOaybowNPAh6qErSbtdqXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2eIgXgj0pew8GYGXYsi+0DSSjpSK83x/ZFm9tH3GAnt0TSbqtTd0C3YVKRBXoRWVk3cMpV6TcgFIba+mj+AbI9z5CiWouuvvQAUi/COdU+8bis85RA1SIGYF2bHM9ahvdBcerkI1+dPS2ZYZ874bqHBp2i/quz7nvKDso8Vj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mbz+iDp+; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708494202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mj321azO2g3V6z75I7i/wkEQoxgT4KRGdjlI33lsjxQ=;
	b=mbz+iDp+sw32XYqQJv3DxB3aud7oUieMyg8J1rhMwXBs5ROt8iTNNC8UxSHnazQzP+3+B0
	twdyKRXR7PasSyIRSD+4uYe2Gx9jg4AdcRBXUONHgEXY4DGuz5EnLw/Za+daWMM7sKgN9V
	KaOcci7KlpsTEBdUrUkbceIT/gbzOPE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 02/10] KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
Date: Wed, 21 Feb 2024 05:42:45 +0000
Message-ID: <20240221054253.3848076-3-oliver.upton@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Iterating over the LPI linked-list is less than ideal when the desired
index is already known. Use the INTID to index the LPI xarray instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 92e4d2fea365..7d17dbc8f5dc 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -55,8 +55,9 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  */
 
 /*
- * Iterate over the VM's list of mapped LPIs to find the one with a
- * matching interrupt ID and return a reference to the IRQ structure.
+ * Index the VM's xarray of mapped LPIs and return a reference to the IRQ
+ * structure. The caller is expected to call vgic_put_irq() later once it's
+ * finished with the IRQ.
  */
 static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
@@ -66,20 +67,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
-		if (irq->intid != intid)
-			continue;
-
-		/*
-		 * This increases the refcount, the caller is expected to
-		 * call vgic_put_irq() later once it's finished with the IRQ.
-		 */
+	irq = xa_load(&dist->lpi_xa, intid);
+	if (irq)
 		vgic_get_irq_kref(irq);
-		goto out_unlock;
-	}
-	irq = NULL;
 
-out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
-- 
2.44.0.rc0.258.g7320e95886-goog


