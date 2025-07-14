Return-Path: <kvm+bounces-52313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F068B03DD0
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728BC3BD89D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E29248F47;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdA8KyOZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09076A927;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=U3ByNkVTPZqCWsFgQoS8Bsc5QjGjROCtZf8MuvUPclIJZaGyrLkeWwg5L8+xsKXLxyPchQgt9RMFZpUBcLSUGW9VsKIdW/6OND6FLliy8HyDBctKBW2CwOMWVx/KCkBZTmNPb/c3HIwOcRmz8ihPLo+5rqi5JFsQgqtUnLO1lto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=VhFheOHSkHxcC8PFeBMrTsiY11oDDOR0N2HXFI7KxNw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TqzqFIbvz6pTUJBzDglVe9NrGlZLnEplz62wrBgqE2IPqgwMegTKu9j1Qzy62rbPHp42tUDEz09/NnzGJ2T1wlwUnFofi4WHVSSlarqTB6tmV3tPNR9J3701dZTbn/XEz5U87aCJ7wAKJjYo5+/veRIYXkT2eEz74jTGl6fyLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdA8KyOZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97EFC4CEF7;
	Mon, 14 Jul 2025 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494114;
	bh=VhFheOHSkHxcC8PFeBMrTsiY11oDDOR0N2HXFI7KxNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdA8KyOZS0Cr4uv4TlwM0YlGmYDb2Re6tPr5WTgUmc0YhX4tNBbCQAtbmv+846HLD
	 +o16W2f3PFF7vn0JdP+l10DBYX7JI62GVzUh/JYT2J0fc8mY2gCUXZtTaoVwJK6Bby
	 4zyqSC/PNoCafEJ+f0sVXS1BnJ2MqpWF5xbD9zhOVKxokIv+8xcG+KgLCbsTFStSnk
	 70lJ7kYpK5+lZUCVja1UW9yYkxuw/sbiIKWfcVCyGgi6smaWujrJ2Rhq8t6LlC2tA4
	 Ms8oNw9pi9Rz06YEJQsF+Z3j+FZUo1aNqInxaLCLBKVtKs+razbxhpYuUeuRox/2HL
	 oRsBZyi9x4eSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm4-00FVUo-Pr;
	Mon, 14 Jul 2025 12:55:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/5] arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
Date: Mon, 14 Jul 2025 12:54:59 +0100
Message-Id: <20250714115503.3334242-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714115503.3334242-1-maz@kernel.org>
References: <20250714115503.3334242-1-maz@kernel.org>
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

FEAT_THE and FEAT_ASID2 add new controls to the TCR2_ELx registers.

Add them to the register descriptions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8a8cf68742986..40d916a6e78aa 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4150,7 +4150,13 @@ Mapping	TCR_EL1
 EndSysreg
 
 Sysreg	TCR2_EL1	3	0	2	0	3
-Res0	63:16
+Res0	63:22
+Field	21	FNGNA1
+Field	20	FNGNA0
+Res0	19	
+Field	18	FNG1
+Field	17	FNG0
+Field	16	A2
 Field	15	DisCH1
 Field	14	DisCH0
 Res0	13:12
@@ -4174,7 +4180,10 @@ Mapping	TCR2_EL1
 EndSysreg
 
 Sysreg	TCR2_EL2	3	4	2	0	3
-Res0	63:16
+Res0	63:19
+Field	18	FNG1
+Field	17	FNG0
+Field	16	A2
 Field	15	DisCH1
 Field	14	DisCH0
 Field	13	AMEC1
-- 
2.39.2


