Return-Path: <kvm+bounces-65665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A61E7CB3A54
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0900A30FF41E
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8380329397;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCy3VTgG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C832936C;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387833; cv=none; b=BzoNblYRdI8c5BMzZVQEql+tOSy3HEK2043lqoGrBaslrQgDsF5CUxNN168v05wZoNRcPFvt9eTQBG2AT5ffkR5IfDnr9TV557+qonp/xgiEnyzZ9IY4bzKrZlbu9AnFu8gJHfo1dOsa2VNZZoCqkBqEcJxpYPC23MHMp8GaN7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387833; c=relaxed/simple;
	bh=RsP+jKzQ4ppzzi0DdCDKDraJ6gU5DPtIntpZyn+upb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtN5iDhzrXS8EauIIm2/tPtHGGjaYtrGijMVygsINjPD7I27wVDW0rjg0X4cmRPM52gWQ1oXNXVuSkETIGzbDhR48zSpa8Aw8PCTnagOjGcLgGNhRfzv2UZw3IMjr+IkomJs4xEgpb+NOj5M9lVD/Lb6lkGNG1GV+GLF33u5Ljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCy3VTgG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886ABC4CEF1;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765387832;
	bh=RsP+jKzQ4ppzzi0DdCDKDraJ6gU5DPtIntpZyn+upb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCy3VTgGwt/xQ5FAGr2m7cteORdx7PJk2HfyylKEPjeYiFqZ9iKmPN9lchTNQSBVt
	 qtsaXGOx3MhWNrkc3/h06/o22vp8CfjAEBEFRGuSOmamKnLfvGnO9/M+qABP/9Ei6h
	 bCTQwmAvTswaDqu4Dxw23ClAGPdF/nDmlA5cVZ9efJkvcxCFxHtVqfQ833GXH87X1u
	 qWKdpaSTt1P6H/0LbX5LSK/1KnsepLehc8XvCJdpnzbTL58wRMxh3oqDNMz5CMEGyO
	 oPc2Cxr9823HbA0T9C1FmwMZ2Yoni0UKwC0c5IPnYBQCjmq5Ud1XF/v9NQAV8JMXEd
	 8nY3CY2zuUCnw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vTO1G-0000000BnnB-21e6;
	Wed, 10 Dec 2025 17:30:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: [PATCH v2 1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
Date: Wed, 10 Dec 2025 17:30:19 +0000
Message-ID: <20251210173024.561160-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The current XN implementation is tied to the EL2 translation regime,
and fall flat on its face with the EL2&0 one that is used for hVHE,
as the permission bit for privileged execution is a different one.

Fixes: 6537565fd9b7f ("KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index fc02de43c68dd..be68b89692065 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -87,7 +87,15 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
 
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+#define __KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
+#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN					\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ?			\
+			(__KVM_PTE_LEAF_ATTR_HI_S1_UXN |		\
+			 __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :		\
+			__KVM_PTE_LEAF_ATTR_HI_S1_XN; })
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
-- 
2.47.3


