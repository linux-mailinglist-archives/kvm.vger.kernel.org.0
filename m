Return-Path: <kvm+bounces-20480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0BD91690C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08C9428A8DD
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7234F16D9B1;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwhPIru+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC43167D80;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322524; cv=none; b=JnflOt9jMCo6zuOiHWKe8IsdjYAjr//8oQlEVNnZ56+Dudym6Z4B+RZMDuiX4eUJTe7auh6IxL+09+Q+ZxSX0BxmQONgmVtw1q0TxNV8/MbFIFxs9crXlT70LVqzgOW5IovKS5y0DZWdvQ43+C5fPcBM/nh0pKne5NwLWplKczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322524; c=relaxed/simple;
	bh=d9HZ26PlskN9lywxTEIiCLlDZUf4MEeqnxDDEB1Fjxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EK724/WWcq3hpRAGhfLmhYsNSLTffGfEHteIIJH7oH8EFfyYlLhnsxHb1ULc8fCAsNCibOm/PWnn4yLAE+VNvwuVdhP3v6XMauYKA3zsrycwQ3EDozmpDUntNDvACcbHmvc7CTxewwTasXZYR47zb6ibDA2q0ubrq4YKtQxXzQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwhPIru+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346D9C4AF07;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=d9HZ26PlskN9lywxTEIiCLlDZUf4MEeqnxDDEB1Fjxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwhPIru+70FySj9FRvmCmZ3rHVSASk0mD5JlZ7mRZq3Rzw2wTEWk8gzI0uSX5bk45
	 3dneBWgh4rcQguvcZgaORlI4SkRUUmZIOS0jVcpHpo5H926noc6C7oOl232KDiNSZJ
	 QhuRZv7inOCB4+v0uPHB2oGKb7ucJY3E9z0Olg8+awEAM7kqbnXiJDRZRpE+434jSV
	 TLDHPd3f+BCaLLp/tSfBX87mfehjETGKjaiAG7FeVoel0+vHMYc/bdTry+bMYGn0T7
	 GSYPVcEEFuh+UM4H6xKgsrVOKz6zKe8BSsg6DSc6NQI7aiXdWTkpzBOKipsY0GaBLk
	 QzM0XezzeF73g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-CU;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 03/12] KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
Date: Tue, 25 Jun 2024 14:35:02 +0100
Message-Id: <20240625133508.259829-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
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
index 5b06c31035a24..b2fe759964d83 100644
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
index 96029a95d1062..73544e0e64dcb 100644
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


