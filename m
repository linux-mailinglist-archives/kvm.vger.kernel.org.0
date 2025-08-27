Return-Path: <kvm+bounces-55894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B68CDB3877C
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E49A41728B7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74282352089;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpDO21ew"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B8A340DB0;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311049; cv=none; b=qpGk1BQeYB1RA+3evGY5Q9RfR4DbKTn/6yMHZWYnwWMQfntF7Xj87fAz7ojhpLLXF+96MdtlsYr6GkBq7rPzvRhmbPKwUP6OazB6MRQr7/yz3Xw0LbKr20yjq7E6NxutxjflIS45Tr9GhzmEHlnkJeIYkZKNcsRxnUqYEb0E/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311049; c=relaxed/simple;
	bh=xV/l/kQzWax0F16OB/PKIyWWct24uzmjuIqhelTe0Q4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HB+79V2Eu+pRpoW6ApGXjMH4nVIIE2O0BF8cskLWkgjiGJnM5zPOQlYgIxaOObJrYU8pH+zazHI9PG1sA9PqKfPXEp1NuWZokEeJexCF5f1zYJZkJTfyFaHhtNxQigQXsxdryAWUXYaQqZQVMTmbHmCazSXKC5/U5k16v8XbdGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpDO21ew; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BEC4CEF6;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311049;
	bh=xV/l/kQzWax0F16OB/PKIyWWct24uzmjuIqhelTe0Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpDO21ewKU6WpvDlxN0onPfie99L0qYlfi0WMsXcoNUkHvpTs8RqJzJmGgJ8e4WjC
	 N8VxozyLxnvpOKH0Fpt8eVNhI/7Xb/t81IyL/WXjS8u7iUAGvR+C7IRTA5I42YlsbA
	 GYlmtrXDzMGpayKVUXD8wP/vrsy4oGBLoDvg29FyyqRanosKeE6E7dq1ppQDjDn2mh
	 Lx3EKxeXY7+h9r2pdfxfgpH92nU+WM+FPwsEDc9p6c18Z/iK2xNMYmGIQdqSJ8Vq6Y
	 GNVAgDPS0b4Sg6P/obbk3bKKV4xSQy65RdHWcPUCnqLBBMN34qYCzbEgx4hW4qnjB/
	 R2hXl0HHlWuTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjX-00000000yGc-2CpQ;
	Wed, 27 Aug 2025 16:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 05/16] KVM: arm64: Pass the walk_info structure to compute_par_s1()
Date: Wed, 27 Aug 2025 17:10:27 +0100
Message-Id: <20250827161039.938958-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of just passing the translation regime, pass the full
walk_info structure to compute_par_s1(). This will help further
chamges that will require it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 4013d52e308bf..ea94710335652 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -807,8 +807,8 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 	return par;
 }
 
-static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
-			  enum trans_regime regime)
+static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+			  struct s1_walk_result *wr)
 {
 	u64 par;
 
@@ -823,7 +823,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 		par  = SYS_PAR_EL1_NSE;
 		par |= wr->pa & GENMASK_ULL(47, 12);
 
-		if (regime == TR_EL10 &&
+		if (wi->regime == TR_EL10 &&
 		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
 			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
 					  MEMATTR(WbRaWa, WbRaWa));
@@ -838,14 +838,14 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 
 		par  = SYS_PAR_EL1_NSE;
 
-		mair = (regime == TR_EL10 ?
+		mair = (wi->regime == TR_EL10 ?
 			vcpu_read_sys_reg(vcpu, MAIR_EL1) :
 			vcpu_read_sys_reg(vcpu, MAIR_EL2));
 
 		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
 		mair &= 0xff;
 
-		sctlr = (regime == TR_EL10 ?
+		sctlr = (wi->regime == TR_EL10 ?
 			 vcpu_read_sys_reg(vcpu, SCTLR_EL1) :
 			 vcpu_read_sys_reg(vcpu, SCTLR_EL2));
 
@@ -1243,7 +1243,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false);
 
 compute_par:
-	return compute_par_s1(vcpu, &wr, wi.regime);
+	return compute_par_s1(vcpu, &wi, &wr);
 }
 
 /*
-- 
2.39.2


