Return-Path: <kvm+bounces-57550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BECB578CC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD7D1898C0F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EAB23002A8;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmotDdEt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842012FE07D;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936697; cv=none; b=YcX5kmBe4/Z0OcQO3jYCwPbMUfskKbSusaCuyf/DBdCxWjRehavBEyCykdTA70FYYVD9TJhT+PxIz02YidV9OuuIf0SskIEyODgShCHsp+WjJ4STgbeZCu0LJagqyop9QVIbtkRzPUHyJew7IPHlY1BnjolevW32elfto7e7NVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936697; c=relaxed/simple;
	bh=QoWf3Hz1oVVZPWlTAUphYRlyMtJu/P8QeR87ZvAxATI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvyMlG8Qlf0a10+LAI3DGa/YCI11X5FzdplXHOU6WbGtA+pBjRC0ygOWjQu7eO+9KS/HcJX9K3QW6ItfVsXdXFbslt15ioB0nGHXcokL9THQ1K9x9mIC1nCnJccUPvdhIX3y5ZC5d7hjwc5k0NcB+pm1uEIGY3mUHAVggBAgLMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmotDdEt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A98CC4CEF5;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=QoWf3Hz1oVVZPWlTAUphYRlyMtJu/P8QeR87ZvAxATI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmotDdEtmPgy341cUWBhaW9COs0ksZ/KnCnD9xpA+NRsK8lMA4YtY69Vi2Sdq0EKs
	 rEvGCjNpIBDEwKzqEYT1+X5CtRlLUEmAQHI5Caqz1VmGD+0uDXvJzX8Y9tGwLbjzR3
	 dRONzDT61cTzR3wT39m9WNFYgrvc37Dc5tWO95Es2PrMRDF3jWUQMgXttB/yKv2mIz
	 Kh0qyUs96UUqgrHmVojNZ7g0aOnwiMPqRxxfstj5XTDPR/1eQLrxVXrB1DKOA4xHFM
	 nPX28CiSYWbwKW/6TiWxx4QcIX9eLvE1lggeM6D7HRNAABuElHlEB5jb8ZN3qOv1Wd
	 Ine0GH2jLvMGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7df-00000006MDw-1Iy4;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 02/16] KVM: arm64: Account for 52bit when computing maximum OA
Date: Mon, 15 Sep 2025 12:44:37 +0100
Message-Id: <20250915114451.660351-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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

Adjust the computation of the max OA to account for 52bit PAs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 7 +++++--
 arch/arm64/kvm/at.c                 | 2 +-
 arch/arm64/kvm/nested.c             | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 038e35430bb2c..1a03095b03c5b 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -265,7 +265,7 @@ static inline u64 decode_range_tlbi(u64 val, u64 *range, u16 *asid)
 	return base;
 }
 
-static inline unsigned int ps_to_output_size(unsigned int ps)
+static inline unsigned int ps_to_output_size(unsigned int ps, bool pa52bit)
 {
 	switch (ps) {
 	case 0: return 32;
@@ -273,7 +273,10 @@ static inline unsigned int ps_to_output_size(unsigned int ps)
 	case 2: return 40;
 	case 3: return 42;
 	case 4: return 44;
-	case 5:
+	case 5: return 48;
+	case 6: if (pa52bit)
+			return 52;
+		fallthrough;
 	default:
 		return 48;
 	}
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8e275ea68cfa8..96452fdc90e2b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -295,7 +295,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	ps = (wi->regime == TR_EL2 ?
 	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
 
-	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps));
+	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps, wi->pa52bit));
 
 	/* Compute minimal alignment */
 	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f9..cb36974e010af 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -349,7 +349,7 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
-			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr)));
+			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
-- 
2.39.2


