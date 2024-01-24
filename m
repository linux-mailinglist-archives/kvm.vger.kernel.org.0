Return-Path: <kvm+bounces-6865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA7083B339
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAB53284311
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CA71350F6;
	Wed, 24 Jan 2024 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cB7dMMs0"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7661339B9
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129370; cv=none; b=Z9lVcUJdm4HP8O/qRkAYRZjwdlHmNDao3Upduu+MxO9rT5GbE6l+JBWPru7KFECTjzxOCB79CSVg4A1zJKnleJCWr4x1QwVe9p9+6J2QBc6WodungVVdXnLbClpaLvHeOyxaNbahBITJPeoNWb30Ym2FoIZxtbIFDBXTcv0SGWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129370; c=relaxed/simple;
	bh=GMgH9J5hFBKgsWvx97GgZsEcvW0lAaU3NZWwr1EKK64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyrEfvrMD/Q8wFMXU+6ELKtwTcdeEuF1MEmPT5KSENWopm+ncY+TbxistHhtZNIKsdvr7WethKWChTpk6hV3eMzhEH9OLUkToULV2bhbCo3SpMhApsfm1FYe5O1Q5eftpS2XtZvfp/JTb4Rup/VNoQm0DkYC1+5aXtgFvKp5DBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cB7dMMs0; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLZEdrKWhCuJ5JOctfy+1PuB2n+NWvfNuRcYY3F4nLM=;
	b=cB7dMMs07aU4BoOiS0SKvW5LqHgKDTGC/xJRVCTHk2g4nANCfNh3++/bvRvClHEJ2OANlO
	La/GV0DUT1iNY6SszC+9hLfb66yct+5+0+rWYUfc4QVaL7k4w/aP8ySHReJ0uGUyZnaSks
	7WAhiv8cxN+CaB9+iq14Zs+4aXV3geU=
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
Subject: [PATCH 03/15] KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
Date: Wed, 24 Jan 2024 20:48:57 +0000
Message-ID: <20240124204909.105952-4-oliver.upton@linux.dev>
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

Start walking the LPI xarray to find pending LPIs in preparation for
the removal of the LPI linked-list. Note that the 'basic' iterator
is chosen here as each iteration needs to drop the xarray read lock
(RCU) as reads/writes to guest memory can potentially block.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9465d3706ab9..4ea3340786b9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -380,6 +380,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	struct vgic_irq *irq;
 	gpa_t last_ptr = ~(gpa_t)0;
 	bool vlpi_avail = false;
+	unsigned long index;
 	int ret = 0;
 	u8 val;
 
@@ -396,7 +397,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		vlpi_avail = true;
 	}
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+	xa_for_each(&dist->lpi_xa, index, irq) {
 		int byte_offset, bit_nr;
 		struct kvm_vcpu *vcpu;
 		gpa_t pendbase, ptr;
-- 
2.43.0.429.g432eaa2c6b-goog


