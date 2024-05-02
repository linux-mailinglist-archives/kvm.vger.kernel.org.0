Return-Path: <kvm+bounces-16452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57088BA40E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7619B20F23
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C05C1CF8B;
	Thu,  2 May 2024 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fPfi1x1w"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B65820322
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692945; cv=none; b=lo+9w2RIQx5PtD2elYkOCychjowhghnLeA2+UFnRDqmm0DNfM8GA/IXBN+p8xG5Adksu5Ez+WQ9fbPsUB9FLEg2+M90RcLnlK+d+vRq0E0Y6FMvq5QrAEPqdQ4J+vGR9IP6Mzec3y7aFJXOz0KEhopx+VtrrdvkyDZPjWCATUC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692945; c=relaxed/simple;
	bh=T+6MlZGnDmwBDkq3wh4AZ8NMw06AuWs7p2fcTdOe4Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqZpmVS8gbcNkPeqnQgQ8MhfeSz5bOCUNlUBi1pyxELd6NmZFUSR11EHOz9Fl2iXMa1Uvk1eJjbocttzDEAKAtlsvtjkY8Fvu8o+w6vxOupPNwLdRaXrZvXlEHNnTAIDvUQudfivXcfuQ2w4leZMs8k26Tng6kxZ00LQEWdsT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fPfi1x1w; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veB75kwdO0YqjwsRSUtLUzCAlTO5aFutVh+SLpMe890=;
	b=fPfi1x1wuZWJ1TRG8LbKJPG+ivq3sW0rKHlk/A5Gej8+EYkM28aqunmp6DLvDo7afx7zBa
	fQyLcEZSx3IVJMOl6gaGftTHx2puuC5faq6/s11QCobxZhfQD400EyRoKMJjAww2MoHBSD
	VywBAWL0Iluq+z28cArMSidCKEbXMas=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/7] KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
Date: Thu,  2 May 2024 23:35:24 +0000
Message-ID: <20240502233529.1958459-3-oliver.upton@linux.dev>
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change to KVM will expand the range of feature ID registers
that get special treatment at reset. Fold the existing ones back in to
kvm_reset_sys_regs() to avoid the need for an additional table walk.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51a6f91607e5..bb09ce4bce45 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3510,26 +3510,16 @@ void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 			    &idregs_debug_fops);
 }
 
-static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
+static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *reg)
 {
-	const struct sys_reg_desc *idreg = first_idreg;
-	u32 id = reg_to_encoding(idreg);
+	u32 id = reg_to_encoding(reg);
 	struct kvm *kvm = vcpu->kvm;
 
 	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
 		return;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
-
-	/* Initialize all idregs */
-	while (is_vm_ftr_id_reg(id)) {
-		IDREG(kvm, id) = idreg->reset(vcpu, idreg);
-
-		idreg++;
-		id = reg_to_encoding(idreg);
-	}
-
-	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+	IDREG(kvm, id) = reg->reset(vcpu, reg);
 }
 
 /**
@@ -3541,19 +3531,22 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
  */
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	unsigned long i;
 
-	kvm_reset_id_regs(vcpu);
-
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
 		const struct sys_reg_desc *r = &sys_reg_descs[i];
 
-		if (is_vm_ftr_id_reg(reg_to_encoding(r)))
+		if (!r->reset)
 			continue;
 
-		if (r->reset)
+		if (is_vm_ftr_id_reg(reg_to_encoding(r)))
+			reset_vm_ftr_id_reg(vcpu, r);
+		else
 			r->reset(vcpu, r);
 	}
+
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
 }
 
 /**
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


