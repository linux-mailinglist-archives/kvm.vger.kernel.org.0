Return-Path: <kvm+bounces-22811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF64943692
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD3371C21CC2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EFD16C6BA;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAAoSd4r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EE91607B2;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454856; cv=none; b=nMFRNV5XSBVNd9EE4kC/Jrxeh6+5RPwHfaIjIwdiXD+TICP2GGSTZsdLxUuJrPt8wdVoIWfa+ORECxO0/4NH/aqBV5j7sNeacvor50mKncp869XpGSI3rC/huCByDXLZF6LNfd2z6SeDa7UUCLfah5jgTEudXjPbQofppApSBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454856; c=relaxed/simple;
	bh=CLZA50OD7a8RVEkLw3E/T9lHdYyHkSWFVa78GUBkp5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R7lTJDgUi/EXz48pD7vkbbOGOElNvESApAXwJP6s/Junll8pANKUiD20CTdyPUVyh13f7Uh24rlRMmySwYZ80zgaXm3tdvHdMBiyKvdMozmUMkVje4gFmoC/EJpeAJUvmTSMTnBBhnPDhw/BA2snoyyS2KfvyfBHJg1KMEa+aMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAAoSd4r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368C8C4AF0C;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454856;
	bh=CLZA50OD7a8RVEkLw3E/T9lHdYyHkSWFVa78GUBkp5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAAoSd4rCsZqGLJ9k4Gekifzt5PmAVAhLXJ0zUKi8t7h0/Tb9uT/r+V2W+Us5SFoC
	 pPA5YhQzLt6lwPLJqPnUrpYgWdiY7Nju+PNiPMv4gFBIDPL8eQpc82C1fN2FbbcJM2
	 zArY+rHdjbou3cpCgq6w76fCrS24eBXEbgypLa0Vq5NnEMFnhBVuVVAmz2r/HYf1A1
	 kuOUuzT8PUCJZ2K6H6qMkSbw+1U8kYNLsu/4bLM50s6TlMRm4qqmCXiT3H0Lxx36fH
	 5k5HgZxsiSIdfPbG6J1fT/A9qhwIDaTPuAmfe9JVOEEznioAg1RbI1AccD3wD30haN
	 xfIBiOqrbBGjw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBu-00H6Gh-8a;
	Wed, 31 Jul 2024 20:40:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 06/17] KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
Date: Wed, 31 Jul 2024 20:40:19 +0100
Message-Id: <20240731194030.1991237-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The upper_attr attribute has been badly named, as it most of the
time carries the full "last walked descriptor".

Rename it to "desc" and make ti contain the full 64bit descriptor.
This will be used by the S1 PTW.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  4 ++--
 arch/arm64/kvm/nested.c             | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5b06c31035a2..b2fe759964d8 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -85,7 +85,7 @@ struct kvm_s2_trans {
 	bool readable;
 	int level;
 	u32 esr;
-	u64 upper_attr;
+	u64 desc;
 };
 
 static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
@@ -115,7 +115,7 @@ static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
 
 static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
 {
-	return !(trans->upper_attr & BIT(54));
+	return !(trans->desc & BIT(54));
 }
 
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index de789e0f1ae9..3259f4fccdcd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -256,7 +256,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		/* Check for valid descriptor at this point */
 		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-			out->upper_attr = desc;
+			out->desc = desc;
 			return 1;
 		}
 
@@ -266,7 +266,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 
 		if (check_output_size(wi, desc)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
-			out->upper_attr = desc;
+			out->desc = desc;
 			return 1;
 		}
 
@@ -278,7 +278,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 
 	if (level < first_block_level) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-		out->upper_attr = desc;
+		out->desc = desc;
 		return 1;
 	}
 
@@ -289,13 +289,13 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 
 	if (check_output_size(wi, desc)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
-		out->upper_attr = desc;
+		out->desc = desc;
 		return 1;
 	}
 
 	if (!(desc & BIT(10))) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
-		out->upper_attr = desc;
+		out->desc = desc;
 		return 1;
 	}
 
@@ -307,7 +307,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	out->readable = desc & (0b01 << 6);
 	out->writable = desc & (0b10 << 6);
 	out->level = level;
-	out->upper_attr = desc & GENMASK_ULL(63, 52);
+	out->desc = desc;
 	return 0;
 }
 
-- 
2.39.2


