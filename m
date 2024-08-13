Return-Path: <kvm+bounces-23983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E98079502B6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0C461F22AF6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3BC19B3D6;
	Tue, 13 Aug 2024 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkyje5/5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B5819AA53;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545851; cv=none; b=ge6nyH+okz1kttPU7Caad7M8oCIytsV3wMU8zU/tb7dxX0D0CVjPzD9yq9KBXaiUtMiTytfHCIv9eKvRuGdzAK+Bh24xbsJnmFf1uxrcpZsb3NJ2tENcPoSmJQjxLRS/JkON2daTsDgYR3KRMZtrUt4VKSfXlR9pQJtG/xYKyQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545851; c=relaxed/simple;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j4XkdO58GtO8qptmsneESvBa0U1I7NXOKCup0PNx9w+RQ1GMRBwf8zGn5twCN+OU7lSNev4JjKsGYUpMPZ7s9XW2OwLIQTnx3KrjV7WFNapqjfOqDStKEPHNrpvGkHMG4FULcZoDc8jAM/suLpNsUT1WnFBRYm8UQZuhWQUQAcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkyje5/5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9BBC4AF16;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545850;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkyje5/5HfUnG64bziPwdwV9abferWbjpB7tSV0XfZpYuU14Zj622q4oxm7umZNQm
	 JmMlwz8zzlDTR3iMGaw/mnwXb7kclEhKaniui92/xxRFTDAFAsU9J7BQfZHB6CB9Hi
	 yuU6RIAJpj3fA/+I/MjsgIDTZg/8xYmF7dqhYAgJ6RGDEVwsKQqhR5aAAd72PblfHo
	 zMPLoS6UdW2Mmr9KTWiR9Hid/KGjfo5fWNeaYG46qAd1+TCHzYGuBrWogUOw8BKCx3
	 eTYk7Wx01jyb+NOlcNcOUFjR7G1U2hPHJsmD4xtCN7v59yAgZsn0FefVnAaOXmJ/wa
	 pKGsNAKZM50XQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0b-003JD1-43;
	Tue, 13 Aug 2024 11:44:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 6/8] KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
Date: Tue, 13 Aug 2024 11:43:58 +0100
Message-Id: <20240813104400.1956132-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64FPFR0_EL1 contains all sort of bits that contain a description
of which FP8 subfeatures are implemented.

We don't really care about them, so let's just expose that register
and allow userspace to disable subfeatures at will.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 79d67f19130d..4c2f7c0af537 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2386,7 +2386,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
+	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
 	/* CRm=5 */
 	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-- 
2.39.2


