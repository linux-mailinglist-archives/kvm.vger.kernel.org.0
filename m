Return-Path: <kvm+bounces-8602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E881D852C5C
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89B40B26044
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FC83BB3A;
	Tue, 13 Feb 2024 09:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JxeGbdEa"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E037710
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816810; cv=none; b=jsF0WByXSXW12oSJajGAteMfVebNzoBBEGVSsB3TFnHNooGYX/8g1/HJkjm9e7maTpiSEETf352BL9//q4Db3900SiIoyV91nYtWldYGjuCbgYwvdnZ509dcQv+DLYXCSqm2MHm6/q4NpxRSeQVncPo6HH0HHnstH6A/hJpXeq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816810; c=relaxed/simple;
	bh=Xl8MN8nPeESY7C6rMo2OigN0MetDVjtmFaMrPpaUx6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrTjiOhLiP2Btp+WzDlYKDVuOucDWdkKafEqDbPJs5rP5jTYVMM6zzg6LpoO99GDwOLvKu5GkQjCS1p0fCKMdTz1QiK3XklNKA0FPrwBr6CqvI4bj0z5q1Rhu9kPmER3gnSrPaOCEGCwzYkgs56K25/99JKrmH4QyQVJ432r398=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JxeGbdEa; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtUC9LwCBXa/InKHa3MSglqgjCcySjFJ8GApzq67bXk=;
	b=JxeGbdEawMgFP4lolaW83sT6rOVtn3Jr5awIE+IJufW0O6N7HRGIYnCCAdSYU1n3+2eSFJ
	4Lal0qXRYPH/zdJ9lHg+ZsUA6r4ZMDf3+VNDIH4rnpGq1vpnwRkOQFCGELItFtMp80Tt9B
	QEiMbQvQ+M6qEBCO8OHFpR4xtsc+py4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 08/23] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
Date: Tue, 13 Feb 2024 09:32:45 +0000
Message-ID: <20240213093250.3960069-9-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
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
index 71e9d719533b..47035946648e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -117,6 +117,7 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
+	struct rcu_head rcu;
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
-- 
2.43.0.687.g38aa6559b0-goog


