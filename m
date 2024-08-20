Return-Path: <kvm+bounces-24630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07CCA9587B5
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 971F6B2177E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4F819068E;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfpoMD4I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2C918E75F;
	Tue, 20 Aug 2024 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159888; cv=none; b=Ghn8mKWIph88vWqZfWK2ASoPuU3ZUP4vS+TbJi3P8npyXUlbCLZpCoWQ6IgGzaXkKDh62ujVcTA+RWKTX/TBD7uIkBOA1ndz/aUK0ZlbyVSRmsAqRk6xCy7yDKjlSq0HazJRziAowNV45cy5GuALuNBMLx36qrHEQA4vxbxVkfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159888; c=relaxed/simple;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OQhCbDdzAtvwoG1CYl0itj56zf/DJGg0gKFK2mF68GsklFY9xYiRVSl0WwvGuduw+hUnFF6/gJFx7LJeaF5LGKY6Jzl17O0whGMlZ5UWIQSl1SDE5a2hPijhWrdNc/KF3mzA7dYn4cdO3pBUbIeQisPZ+Hh/6rJzQbLco2/XEB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfpoMD4I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739CBC4AF14;
	Tue, 20 Aug 2024 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159888;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfpoMD4IvHwDCCwvQP4WPbXBj5Ul5qCXw2U8leQEjkH6rtOL0ihxR01VNcTIlUzjM
	 jqTEnts5YBGNx+4ieNA2JShKzjDQyKf7y08a1M45DgAJe85oFpeUkgHRUxbT1jqDdq
	 pFVXEUv+xNi4hx/hGp6NYkUUZjNsmtEEREaC8q6O1ZmijckoTlRDR+BqIOaWFZ6sJf
	 9d3c1mDQC3pDwd1LtjlaFXZPnjIv1QODN1t2oUwat6N4ONFXqbcz7uRbuRutmBVr5b
	 u9yWJD/Zb4bIPhbBBwryFJSiJWqnylFLiqfy/1uHVYvc/SjxkShWyx7OvcJ+ooCrO6
	 SwBszhzJg/7Ew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkQ-005HMQ-A1;
	Tue, 20 Aug 2024 14:18:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 2/8] KVM: arm64: Add predicate for FPMR support in a VM
Date: Tue, 20 Aug 2024 14:17:56 +0100
Message-Id: <20240820131802.3547589-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to check for the advertisement of FPMR support to
a guest in a number of places, add a predicate that will gate most
of the support code for FPMR.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e244e3176b56..e5cf8af54dd6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1475,4 +1475,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#define kvm_has_fpmr(k)					\
+	(system_supports_fpmr() &&			\
+	 kvm_has_feat((k), ID_AA64PFR2_EL1, FPMR, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.39.2


