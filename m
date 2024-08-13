Return-Path: <kvm+bounces-23968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBE795020D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B4AC28607B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25AA19CD0C;
	Tue, 13 Aug 2024 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZU+7P1Cn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284CF19CCE7;
	Tue, 13 Aug 2024 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543586; cv=none; b=LmyOshUQvQfHRv5eyf2ZWMCH2gpsSWHMbQTffXxjpmqyaAx28Uss75k/1kh44WSXdkZso0yRnRCSOK9relqeFrU1w3tgk2FF+vLb3c2E+htmP2ltr7T0iLP2kv4kvixJDMY2H2N9gi+FbSvVLAugNpE0gcOLT49tJj5RdbbeOJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543586; c=relaxed/simple;
	bh=E87ipciofJL2UyAF6VGkVfcmpMKDKZbHt0/aVGe54KU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K9mIIAza3780rhZ8v0Tapz2IE+T/qdDIFU7e5NMN8p3YcngT+s5HdmlCMKCfmBfWexABvPDcS7dEnd5xoGIfXvOhbphrFqwb58tq4SXrBr+6N3dZ/5qvYDF/Z336HRM48IzDh2awoOOG85t2ZWS0iFjed42EMaSGSr93gf5FlRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZU+7P1Cn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99110C4AF09;
	Tue, 13 Aug 2024 10:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543585;
	bh=E87ipciofJL2UyAF6VGkVfcmpMKDKZbHt0/aVGe54KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZU+7P1CnIiVGXzGvSx28MtVxh6YOeXTgzYIRnbHefLN1JKk64AwY0JWltpHIykZz3
	 PL4EanCo/LVe8CoYUn1ZOM3n1rJZeJa3q67UPbYFeXvcx/04Gj/8KL6PxD3FQe4G+r
	 Yk0Dl+PMH9Y9Sx71jHv3ElmpOcXvEzZdTgoXaJx4PS1p3KA4w6CL4hEIUyKpWkBsZY
	 1KS7uoqDyMV5tF3pwMY/aJr0DpSwMDSRvP2ji8Q2yDEavsddnYoMVuUb+A7t2XJ1aE
	 UJVRqQqipBoFApDRur4aTceECExB0/tuW1GJFxi2OpPfVP64wdA54fQC//x3HdD7ry
	 iQIKXz9Zfy4Jg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ3-003INM-Ke;
	Tue, 13 Aug 2024 11:06:23 +0100
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
Subject: [PATCH v3 13/18] KVM: arm64: nv: Make ps_to_output_size() generally available
Date: Tue, 13 Aug 2024 11:05:35 +0100
Message-Id: <20240813100540.1955263-14-maz@kernel.org>
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

Make this helper visible to at.c, we are going to need it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/kvm/nested.c             | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 43e531c67311..e8bc6d67aba2 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -227,4 +227,18 @@ static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
 		shift;							\
 	})
 
+static inline unsigned int ps_to_output_size(unsigned int ps)
+{
+	switch (ps) {
+	case 0: return 32;
+	case 1: return 36;
+	case 2: return 40;
+	case 3: return 42;
+	case 4: return 44;
+	case 5:
+	default:
+		return 48;
+	}
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 234d0f6006c6..9c8573493d80 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -103,20 +103,6 @@ struct s2_walk_info {
 	bool	     be;
 };
 
-static unsigned int ps_to_output_size(unsigned int ps)
-{
-	switch (ps) {
-	case 0: return 32;
-	case 1: return 36;
-	case 2: return 40;
-	case 3: return 42;
-	case 4: return 44;
-	case 5:
-	default:
-		return 48;
-	}
-}
-
 static u32 compute_fsc(int level, u32 fsc)
 {
 	return fsc | (level & 0x3);
-- 
2.39.2


