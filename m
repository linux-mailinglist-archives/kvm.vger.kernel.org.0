Return-Path: <kvm+bounces-26512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE969754A6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9502838DE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D701A38FA;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEQF3FIN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9351A263E;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062718; cv=none; b=KU13qe8bPuoHRIo/75cVIXG+BkfvEKkvuAtJVU8P6+GK/8LJCQPHER6e2u4lUiUxJ1nqAlbXVIb7ruIRfD8iftTxrbgez44/BedKLW6KB80hr9LlLQ7Y7PP7EeoXmpu+vehvhwL3dK+3+y3Tz2mrH2rTXN+YF13Z3QnKGbFAe4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062718; c=relaxed/simple;
	bh=RVi+1I6LHJFjDgWJwNVL5kApho4YyFCEEb67AVAUBRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mwk/26I13gitBrxB5uhYoB/TiLng2HEVEDb68JH06SnE96DkrXIhnucaKz6HRD6hC2FpO6YDyASpPJ4tV2nnIFNVgbzcsG5nQ0jhf6qdTvcNA5ngl9fmsHJlKi1jUnsEA6xaJnVPN0alf8AtZhUprG6NzmRDQB+IQUxZyOuZBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEQF3FIN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84357C4CEC7;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062718;
	bh=RVi+1I6LHJFjDgWJwNVL5kApho4YyFCEEb67AVAUBRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEQF3FINAa+vMUiVHbAvcNSvaS/sT2VwdLEk7dBZmjcKR8tz5aJiWlhrl4TALyESY
	 zZpCfLnISzweUUqVjhIYk8e4dqQJFehl+eh2u843q07DjD88Sn04vylRQldgozOX2V
	 w6yMubigThey7LlmQUalvNhZt38p9PViaLeDQkDKZPuBMazsgXwh91JlCDXj6Jaw3T
	 8UVofbH1Y5K4TU9q2sNjQgbDRhAjpFVZmeM6qhsxKBWOfSzdlxkb9h/Z6HKRjZ/gL/
	 8WoZ7nwRFAewDXRzs3l5+vUfExM8Fxym4tv8Ymluo9TxhlwQd49qi7tOcxwIlsxcEM
	 b13gAbdar/9xQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlE-00C7tL-Dy;
	Wed, 11 Sep 2024 14:51:56 +0100
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 01/24] arm64: Drop SKL0/SKL1 from TCR2_EL2
Date: Wed, 11 Sep 2024 14:51:28 +0100
Message-Id: <20240911135151.401193-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite what the documentation says, TCR2_EL2.{SKL0,SKL1} do not exist,
and the corresponding information is in the respective TTBRx_EL2. This
is a leftover from a development version of the architecture.

This change makes TCR2_EL2 similar to TCR2_EL1 in that respect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7ceaa1e0b4bc2..27c71fe3952f1 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2789,8 +2789,7 @@ Field	13	AMEC1
 Field	12	AMEC0
 Field	11	HAFT
 Field	10	PTTWI
-Field	9:8	SKL1
-Field	7:6	SKL0
+Res0	9:6
 Field	5	D128
 Field	4	AIE
 Field	3	POE
-- 
2.39.2


