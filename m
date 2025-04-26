Return-Path: <kvm+bounces-44412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10738A9DA8D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BA045A4862
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54D2230BED;
	Sat, 26 Apr 2025 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbdbB6xg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2D1E50E;
	Sat, 26 Apr 2025 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670531; cv=none; b=d+q77jBCeHQp4sYLfStIzTchRTCAF7osh/j4/V7lRpbjs2xzCTLsvbURBr3oKEGAyXR6GWFzSGm/Rv4Fy2FSs6xFwexXrQv3EsK3EUH7Y0WoYLgLXsawm/x9DQi3nOloiBDdVOfUjf0wFdjcNjm1tQwhDqN9/7iO/vsu5gLPR2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670531; c=relaxed/simple;
	bh=44gRQXHmjU599W1FzWtYTLfeRPiNOJ8OSvboqazC2Q0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AVK+DGHrsngFZSZucXZAYWoeQF9TYl7HQ/eJ1yukuZtSOqZYhbbZDo1v6bd/9Ml6zvQx/AwlfSuGOquNeBTXIqfQUpaDbGEa4ac4lRBS8n/vUplWt1rbOg47HBDDWpyE/34C2q35H0/6lIXMXvjWh/Kp1LUerMfAulo04vYQg0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbdbB6xg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E8AC4CEE2;
	Sat, 26 Apr 2025 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670530;
	bh=44gRQXHmjU599W1FzWtYTLfeRPiNOJ8OSvboqazC2Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbdbB6xgxessSw9Q5prEE/drdKGxcL6YWXlwkA5c37yzG25/n/Fp2fjx39IbIwRMi
	 5/nImXAcHxZX+jiDB8ituxHqzpTRSLOlnDEmshuIeTzX5JABfu8wq0AlPyfhR9LG/8
	 GYWgye2slLBlUD9UoY/2u0vPi+ZvIkhPMnZc34aoIa2PCbhmjV6fh9eJ5X93KgjbqD
	 +h0q4lUGfBhw6MViJSJV9mK0BwM783IKhIxh/8OwOz5hdM9yMSBuAOkyaMq+f1Z9FL
	 4gSPn0iivEdjPrKlj+TPF1z5nPstHz9S1C/Iu/k0ryz2ifG2vzZhiusUkt8IsJgwGO
	 37pCaWDwtIGew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeG-0092VH-8J;
	Sat, 26 Apr 2025 13:28:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 01/42] arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
Date: Sat, 26 Apr 2025 13:27:55 +0100
Message-Id: <20250426122836.3341523-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
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
index bdf044c5d11b6..e5da8848b66b5 100644
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


