Return-Path: <kvm+bounces-37710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74440A2F782
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46A4A3A1FA8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013242566C1;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRA+Dc4w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0434F25A2B8;
	Mon, 10 Feb 2025 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212920; cv=none; b=QhgKuOWw8UOux/P4oMFgjQsMijh2TtoeUrVwD8rS7ixQkkflaNcQ0lWIGNfOpIm9bGjQE3JiwkYSFJZF5pVfYkdKtqEfjIb7bRjfqyIMrHPZyOHszqBDq9td5C3iYbMMgvZp6eEfpJtRj32MxdT7PL0tpAhU9cQujOumQZZL/Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212920; c=relaxed/simple;
	bh=mwzvC1hwjzZ73H1jse2BNgJhdi0FIYrJ/BY6AQtHATU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BtFJE0G8v7idYE5/rDF5st6Lda2HW3EznYy6SNyN8SkTaGG28ocJo6lofk6YP8qdLe99NMk7nyMFw5VotjSTEP6Ef/rV+KecUfjXUfyBwAITv+YUuAQRwHK1SEvoOFQmnomb5ZZuogvSRsOpsDCH+Wd5/zKur8SNm96Ov838+0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRA+Dc4w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC24C4CEE4;
	Mon, 10 Feb 2025 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212919;
	bh=mwzvC1hwjzZ73H1jse2BNgJhdi0FIYrJ/BY6AQtHATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRA+Dc4wJmGlO31/fAY6+HzLZ6vdg5Zj49iOj4enN7XoO6YEumrhlpj0TSbC5HYur
	 2BvZ2h1W69s/QMHqAP0H2pDOG7fr2L8PaPJKVDJjhcXFzaS5BEnRmoEQxaVklPspgi
	 2SajxzbPzcJ9hIe0X4BFyQcZhp3LHGG0l1VG8y2kvQ7d6psgIayLdagSXlOq6iZF9K
	 QZf9/B+y4O1PIAWCW5fyN7jOxh6JP+dGnpb39qOuqeGUW6r7OyCMLlNcwXRmuJTmuw
	 mzHKM0wYmIifYg7KspDs2b4606cmIwVinGFylrkDn7R0uDmM+IE0VYWBQZdnj14FnP
	 XTXgT/AE4KVbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjF-002g2I-Cz;
	Mon, 10 Feb 2025 18:41:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 01/18] arm64: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
Date: Mon, 10 Feb 2025 18:41:32 +0000
Message-Id: <20250210184150.2145093-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The 2024 extensions are adding yet another variant of LS64
(aptly named FEAT_LS64WB) supporting LS64 accesses to write-back
memory, as well as 32 byte single-copy atomic accesses using pairs
of FP registers.

Add the relevant encoding to ID_AA64ISAR1_EL1.LS64.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 762ee084b37c5..8c4229b34840f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1466,6 +1466,7 @@ UnsignedEnum	63:60	LS64
 	0b0001	LS64
 	0b0010	LS64_V
 	0b0011	LS64_ACCDATA
+	0b0100	LS64WB
 EndEnum
 UnsignedEnum	59:56	XS
 	0b0000	NI
-- 
2.39.2


