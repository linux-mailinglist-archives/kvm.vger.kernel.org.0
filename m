Return-Path: <kvm+bounces-22920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C5094482F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 262271F22A30
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD1E1A2C26;
	Thu,  1 Aug 2024 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PI3gWqzy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57D170A37;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504155; cv=none; b=aU5ZJDND5dW/HaYUhbP21J2oFOS3Y60x0OGQ+OwkKbaVtN50Ej4DkxShpjFshkwr2/w7jR4fVT+zwihYKZ4dfYCBMoPYydA7yhysVVkI0n2i9GElwTVco9nsbwoW7/ZRuJuFmBHn/F8hSotqNyO/Vdeejfk+3F8S307xQuyYIXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504155; c=relaxed/simple;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bi590dvTHwgi1a4ZpzYXkydrXUz2wqRvaWTNRdNScuaYHeuipTB/9iC+17WB6OVvSzauoWRc/WA3b3xbvWezdtclkkZq2lod0EOOn2ozjiH8UC/1B3QyOdLES2czpM7nNMen0n0hC2uwGT6bL8TyJqLcq8DTF1G/CA3EWun8K2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PI3gWqzy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4AFC4AF09;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504155;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI3gWqzy2BGL03Ejz9cEGUwgi2U2UVX8F2WcF7EHhB9/QJaoZlQXwMBqSNdkYtqdp
	 tyGcfcf9Nlpdl9IpM+orzB89Pk8WUgZD/gmosIqjy5PttGP3LwcqdzlqId5Uzj6Hvr
	 X6eVNqsQKSBxgf1zweXGdUX4BHepcN95LyAhk0dzGDxAGAMtS95AjSVnPUi+pnLTTR
	 9Db9btI9SWLQzPXaSA0M3It71C2TpaDp8YJmGPcJ/JsCAS2ZH5iA0bxQ8evhhrPq0n
	 GcgoErM+3P9y6kwjIVN9U+5lkZcyFZkqymuvh79WQvqZudT8P3kd5eH/6bSG/6DSIh
	 MTAtj6o6/aUCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRya-00HKNZ-06;
	Thu, 01 Aug 2024 10:20:00 +0100
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
Subject: [PATCH v2 2/8] KVM: arm64: Add predicate for FPMR support in a VM
Date: Thu,  1 Aug 2024 10:19:49 +0100
Message-Id: <20240801091955.2066364-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
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


