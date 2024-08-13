Return-Path: <kvm+bounces-24004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8588B95081B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B83141C2269C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176521A01D5;
	Tue, 13 Aug 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qsGJ919E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1719FA6B;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=tgDi41Dwxpu9tlaNkUP0WojjoTL18xMh1i1ljRIyK6f7x4b18MqHCpOoabOknQVvO2PTj+4oZBhVo3w/F6FFRPnPr9PdfsLHykeRMpTVnSL+nAQl+hr6R+bF94aEF7ByOHQZuF8FcNQqYlUCb/YihTuiGY7+srFUnH0Y2+MRs/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=vT/5asr8l07sZbrUs7NSkiwidQ979neRK/s0Vwf6rPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qjj0KXtaoEohni4nmea84XZTvT5uJqg8laGTsBlyvopml7zGpcbAjd1NhZnW3yM7t5UnX6/t5RTKLZzWxF/axrZJj5h8tJmW77cqEIvhvwIFZ72+8fJAUA0ZKZtlDjfOZ7JNnmIpRAZoAaUxVEvYZU7zGRk9ROIbzf05QgzdE6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qsGJ919E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2E0C4AF17;
	Tue, 13 Aug 2024 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560478;
	bh=vT/5asr8l07sZbrUs7NSkiwidQ979neRK/s0Vwf6rPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsGJ919E5blg80Wg3QFLF39t16IkKhfRmKXBO3HXWSN64qjKCN6pkmJkSil044iCG
	 5WpqU6aMPlDfy2nzqqFc9TRjB73SBKfipXVyx5bUqc+ZEc9RWEG7XA9hklzDcRJed0
	 W6vdHrul5sPxWFI+pqPeZCwXBkLNVMRvVdRL1MbqWObz73tUH/MDN7prf0PKPC5KT+
	 oOGF+BYSNPOLRqUyFYPYn62LC/8+USaJvpr5tZGitxvM/2SlKQPfMhYXIvbMnau3k3
	 +LcNpU2Fn9zaPlHB+v64fXhwlERNBS2HSST4ZgXC986AHfnX8dIZ97JmpN+PmQSI+O
	 TsYxs8FnByGWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoX-003O27-4v;
	Tue, 13 Aug 2024 15:47:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 05/10] arm64: Add encoding for PIRE0_EL2
Date: Tue, 13 Aug 2024 15:47:33 +0100
Message-Id: <20240813144738.2048302-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7ceaa1e0b4bc..8e1aed548e93 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2853,6 +2853,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	PIRE0_EL2	3	4	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	PIR_EL1		3	0	10	2	3
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2


