Return-Path: <kvm+bounces-23961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5974595021B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4DC2B26024
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D9619ADB9;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKwE0i3M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEDB19A298;
	Tue, 13 Aug 2024 10:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543582; cv=none; b=mjJEdsIiX5c3igN1/P+YgZfgAc4c69foutkbu03Fpr/uYEB2GrFdu9MNEsaR8sKPz76qJUhMkluoG3Voadvhh4+M/wPbtM0vEaWNpuFY0pLxcPpXVkuee7bdlMkXQV87AFnWC0EN5JGlfIzQl/sAY1L6FfrA0mIsBpNv2mEZ9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543582; c=relaxed/simple;
	bh=4M+6R0blA0WD6c7fnSXPicThPz3VPlxktp+D33pw61U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pu6O8UQr/k+A06G6ZJBQ36GlfbaqMocrNrJWNv8Eluiyfmb1tQd3qQKYY1nk6WA8Y0kG4PtSGw2XcnERU9aCiuxplHVS6Q7XPabiBv+3mp1/2OiIT6lE8zXKTLfU5UCp6Y+lcSjs6OTKm3oLctb1MsKLKDS21e9eqUwcX2MD2fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKwE0i3M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8C7C4AF0B;
	Tue, 13 Aug 2024 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543582;
	bh=4M+6R0blA0WD6c7fnSXPicThPz3VPlxktp+D33pw61U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKwE0i3MWC1X5ZfaK4WC7FK7fCGFJM5TUiD1CThUcYU4hxClLkDWBRQ8VlYbmwj0B
	 ibOf73u9Klr64Igze05Ip/nfXEpXwH5zlmLsp9cPhsa3I3Fdc9sVt4qsTMVQIiv4ZK
	 +7Ecmstq/ypiItruTngVI3CeqeB46YCDlJV8YCnoqFa2W9tGi6hpnFP9MrLgSmXlHr
	 I9mtD/od9OFYUVrTS7HdUjxmOSxWxodK8TXswfUh5Yb8/6nlWP8GsTeJq7JwIILMLK
	 Xv6XQMG+wRp2V5S3AABz6dwqeDqAFhlzHGz6O9uChPTMv105NLW3JmbQzK3p7YiVry
	 cmm9exbO+h8sg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ0-003INM-76;
	Tue, 13 Aug 2024 11:06:20 +0100
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
Subject: [PATCH v3 06/18] KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
Date: Tue, 13 Aug 2024 11:05:28 +0100
Message-Id: <20240813100540.1955263-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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

Despite KVM not using the contiguous bit for anything related to
TLBs, the spec does require that the alignment defined by the
contiguous bit for a the page size and the level is enforced.

Add the required checks to offset the point where PA and VA merge.

Fixes: 61e30b9eef7f ("KVM: arm64: nv: Implement nested Stage-2 page table walk logic")
Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 22 ++++++++++++++++++++++
 arch/arm64/kvm/nested.c             |  7 ++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5b06c31035a2..6e163501f13e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -205,4 +205,26 @@ static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
 	return FIELD_PREP(KVM_NV_GUEST_MAP_SZ, trans->level);
 }
 
+/* Adjust alignment for the contiguous bit as per StageOA() */
+#define contiguous_bit_shift(d, wi, l)					\
+	({								\
+		u8 shift = 0;						\
+									\
+		if ((d) & PTE_CONT) {					\
+			switch (BIT((wi)->pgshift)) {			\
+			case SZ_4K:					\
+				shift = 4;				\
+				break;					\
+			case SZ_16K:					\
+				shift = (l) == 2 ? 5 : 7;		\
+				break;					\
+			case SZ_64K:					\
+				shift = 5;				\
+				break;					\
+			}						\
+		}							\
+									\
+		shift;							\
+	})
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index de789e0f1ae9..49a7832a3fb1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -282,11 +282,6 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		return 1;
 	}
 
-	/*
-	 * We don't use the contiguous bit in the stage-2 ptes, so skip check
-	 * for misprogramming of the contiguous bit.
-	 */
-
 	if (check_output_size(wi, desc)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
 		out->upper_attr = desc;
@@ -299,6 +294,8 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		return 1;
 	}
 
+	addr_bottom += contiguous_bit_shift(desc, wi, level);
+
 	/* Calculate and return the result */
 	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
 		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
-- 
2.39.2


