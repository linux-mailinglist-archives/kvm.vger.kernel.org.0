Return-Path: <kvm+bounces-59010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA8EBA9F32
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 342A31C6BAC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2759230EF81;
	Mon, 29 Sep 2025 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja6RLET7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE3D30DECF;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161908; cv=none; b=cZ+EalAXtPyH8BQB/g+DgebmaY0yGqcH7NeJvdpl0o61j2ossnCAqAv9jISOnYNn178i7SQ8xDMhOCL00Bgr4yICIfWLnO0ckQ0ItI5q668h/GjVSHSf6dNe6wqmEnF7B48Pk9eBhuYPNyCU4Rbl96F54WuUur6S1+Q9Rb/tQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161908; c=relaxed/simple;
	bh=myl3kJcHcZU+j81WLuyOyt+RJbJ0t5SjDn5XC0asxto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWmN1lF6nTbvTikXD5Jhp9WJznvWHzOp630kiWBu2wJoD1Gpsoh12J2a6FLDBDksamsrykj9P9DM/FUm73lH15GeN7uSOxsJac9j6O8Vb1PbcVCU4NfP17SCI+jWd5nWGyXIQRG5s4YnxSzajubKk3krldZHC8kyxoZNk7AO+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja6RLET7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A3C116B1;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161907;
	bh=myl3kJcHcZU+j81WLuyOyt+RJbJ0t5SjDn5XC0asxto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja6RLET7ZPulgjDtRzKVsBAeH0Oanr9WlhZtHrBHWSDHJgjU6AWzQKzHZT7GKHFed
	 kt/S2teyqQWKkG7jA5SS2vKT9o8A++5jIE1Hj7zLrTRcekQ2ImZa/KqFlF1sP60q86
	 omXjUJeNcOZqYnSZYYUW+OlnYF/3fwVvu2W+r+CEv1XNJ7uV7wC/kZvSrR9IT6J7xf
	 6g+G1IHqbzP9WHruY9sekPpo7Lc5cCc4p83811mmau3tfgsr1lTRC30/+KCmgNZ+WK
	 rBQX0m4xLp/8pJ7htVzKftekJj8MOAPdEFcwG6X2LNlj8rEONwb73IcCOX9+x71jlQ
	 3sPDg+BVaGNqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN7-0000000AHqo-3bVX;
	Mon, 29 Sep 2025 16:05:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 11/13] KVM: arm64: selftests: Make dependencies on VHE-specific registers explicit
Date: Mon, 29 Sep 2025 17:04:55 +0100
Message-ID: <20250929160458.3351788-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
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

The hyp virtual timer registers only exist when VHE is present,
Similarly, VNCR_EL2 only exists when NV2 is present.

Make these dependencies explicit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 011fad95dd021..0a4cfb368512a 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -65,6 +65,9 @@ static struct feature_id_reg feat_id_regs[] = {
 	REG_FEAT(SCTLR2_EL1,	ID_AA64MMFR3_EL1, SCTLRX, IMP),
 	REG_FEAT(VDISR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
 	REG_FEAT(VSESR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
+	REG_FEAT(VNCR_EL2,	ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY),
+	REG_FEAT(CNTHV_CTL_EL2, ID_AA64MMFR1_EL1, VH, IMP),
+	REG_FEAT(CNTHV_CVAL_EL2,ID_AA64MMFR1_EL1, VH, IMP),
 };
 
 bool filter_reg(__u64 reg)
-- 
2.47.3


