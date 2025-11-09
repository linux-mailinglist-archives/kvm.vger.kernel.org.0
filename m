Return-Path: <kvm+bounces-62458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 364BAC44413
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 31E104E70BB
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D3A310631;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUG/fFqk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092130F953;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708598; cv=none; b=fPEy1a9L6+3hAnJgrV15WPySqR59hZf/nvwh29S0wS4cWEvAXhlkHu7qu2koXZO66kxGo9aMWNweSXnOJxm2Db/ObUnwtKWgSY6Xu+jJb+0OMDbT2graDqftH8AtFAxwVuyDiuzBmNxiPnneYEZSb04tdVUfvb5cRZCeB0R7rVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708598; c=relaxed/simple;
	bh=0hvmCeKhsMVd086Kod+NAOedYomhrKNdTjlyOXnTXNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOWX0zndVuKC7+5UM+ymr37b2fWMpqRcojfvo2BF5F2+rlOMpOFNDV9Uz2hLdCdui3/xCOo81KyhDEiIUEvTHNWRGVPkumRADYFXjYd8DbNRouHeUE/ov9v8yHv84hthh1CcAC5hnPZjBfOIM9b786BPa1eCe3ZiiPL+ECqHCdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUG/fFqk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982D7C2BCB3;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708598;
	bh=0hvmCeKhsMVd086Kod+NAOedYomhrKNdTjlyOXnTXNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUG/fFqkVUnn10o82PM9xlLa5OIoumWh7+iedJkEppvSZHi2qfC+FY2BeXKiw4beE
	 phCNB8RvmVRXYBoD2DTSmWkg3mFLdnmj1U79TDAQC30SWS8EGmqAPiNpTwsq6mpL2b
	 2gfmI5MtfemafhWuSzwcIoLWk0Lrr7qhiZ1ushtLt0WD40/opcF1rIICT9qwPNr5dk
	 KBo5aGZDbZMoRuVSbVKax/B7CUzrloSqtYPSCSvMXNBwX9ggsMdZ9caP4EFFP4/JDo
	 QsAF2Wi8V/6xALLvLQtZegX1nwQX826q08DgMAaGh8W187VyEuSNU7d6qfIu3wkatY
	 PfEzHH+ZF41RQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91o-00000003exw-3fkP;
	Sun, 09 Nov 2025 17:16:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 36/45] KVM: arm64: selftests: gic_v3: Add irq group setting helper
Date: Sun,  9 Nov 2025 17:16:10 +0000
Message-ID: <20251109171619.1507205-37-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Being able to set the group of an interrupt is pretty useful.
Add such a helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/include/arm64/gic.h   |  1 +
 tools/testing/selftests/kvm/lib/arm64/gic.c       |  6 ++++++
 .../testing/selftests/kvm/lib/arm64/gic_private.h |  1 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3.c    | 15 +++++++++++++++
 4 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index baeb3c859389d..cc7a7f34ed377 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -57,6 +57,7 @@ void gic_irq_set_pending(unsigned int intid);
 void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
+void gic_irq_set_group(unsigned int intid, bool group);
 
 void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
 			   vm_paddr_t pend_table);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic.c b/tools/testing/selftests/kvm/lib/arm64/gic.c
index 7abbf8866512a..b023868fe0b82 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic.c
@@ -155,3 +155,9 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_irq_set_config(intid, is_edge);
 }
+
+void gic_irq_set_group(unsigned int intid, bool group)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_set_group(intid, group);
+}
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_private.h b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
index d24e9ecc96c6d..b6a7e30c3eb1f 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_private.h
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
@@ -25,6 +25,7 @@ struct gic_common_ops {
 	void (*gic_irq_clear_pending)(uint32_t intid);
 	bool (*gic_irq_get_pending)(uint32_t intid);
 	void (*gic_irq_set_config)(uint32_t intid, bool is_edge);
+	void (*gic_irq_set_group)(uint32_t intid, bool group);
 };
 
 extern const struct gic_common_ops gicv3_ops;
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 66d05506f78b1..3e4e1a6a4f7c3 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -293,6 +293,20 @@ static void gicv3_enable_redist(volatile void *redist_base)
 	}
 }
 
+static void gicv3_set_group(uint32_t intid, bool grp)
+{
+	uint32_t cpu_or_dist;
+	uint32_t val;
+
+	cpu_or_dist = (get_intid_range(intid) == SPI_RANGE) ? DIST_BIT : guest_get_vcpuid();
+	val = gicv3_reg_readl(cpu_or_dist, GICD_IGROUPR + (intid / 32) * 4);
+	if (grp)
+		val |= BIT(intid % 32);
+	else
+		val &= ~BIT(intid % 32);
+	gicv3_reg_writel(cpu_or_dist, GICD_IGROUPR + (intid / 32) * 4, val);
+}
+
 static void gicv3_cpu_init(unsigned int cpu)
 {
 	volatile void *sgi_base;
@@ -400,6 +414,7 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_clear_pending = gicv3_irq_clear_pending,
 	.gic_irq_get_pending = gicv3_irq_get_pending,
 	.gic_irq_set_config = gicv3_irq_set_config,
+	.gic_irq_set_group = gicv3_set_group,
 };
 
 void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-- 
2.47.3


