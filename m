Return-Path: <kvm+bounces-54856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC86B294F2
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 829537ACB2E
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59F629E105;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/p1LFvy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F70023F41F;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462126; cv=none; b=tQMk0Y7VMnOyaaCbLwz4WNNdNqIFXA7EZS3Kq1NGIfuH238r5++rQXCebwJMZXj8QhAxSl3z1qV7NDQmKyGP0tAAQW1T5QGdMqg+i0/5Neilhu8zwb6Jvmmjt/GM61fxWQncSB3K/EytNV/mNQW3c022Ik9PpPbohiW5E8j+N2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462126; c=relaxed/simple;
	bh=/kr1h3ivDaybILMj58T9joQcQNXYw3TXcpEPHXi8CWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crU/Lwawnug9XLjdCUuErX4ak9zNyjeSLS/3LI4W3UVhdTCSXUIrgL0SW6t4zsYHwAUOKfkwEpGEFk1KFdG0yAYHiTZOOXGoSs+JEX6YSCvJpMJee00/TOmSszX9Yr2ScanydQSNKkaftDlOq9ZAIea8E4s2tB8+sUQjGdYGjHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/p1LFvy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A7BC116D0;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462125;
	bh=/kr1h3ivDaybILMj58T9joQcQNXYw3TXcpEPHXi8CWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/p1LFvyG1jWQGFGy5M3aZHnSBRa/vq1bKsLxZDZItAsACkJ+cWaK066JObotivc7
	 so7haCYLxbnPyuFWhZ8IA3DhNbcXFXxkorzj62eXIF0G9F4Bo5FZUJPYpSSWTGTe0l
	 DA1qm5DCUkm2F89pDehuWKtv/Sstnq2vGNYEDqX+hSSVnL1mRs48Zt3SiopSlTvJb/
	 ifmaQ6zdh1E8Ml3ddO5aZjoLX4HaOAostCLm2ORaA/qJ5gEzMnmi2bliQoFvsKSsSn
	 VsevUxHY/t8UYuS9x3AK3B7ZNzIElwPCJZjWKXKWJGvAJ7216DVLOHE9ybem/Ve433
	 EngDuW9UR1o2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtD-008PX0-OS;
	Sun, 17 Aug 2025 21:22:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 4/6] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
Date: Sun, 17 Aug 2025 21:21:56 +0100
Message-Id: <20250817202158.395078-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make ID_AA64PFR0_EL1.RAS writable so that we can restore a VM from
a system without RAS to a RAS-equipped machine (or disable RAS
in the guest).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index feb1a7a708e25..3306fef432cbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2941,7 +2941,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ~(ID_AA64PFR0_EL1_AMU |
 		      ID_AA64PFR0_EL1_MPAM |
 		      ID_AA64PFR0_EL1_SVE |
-		      ID_AA64PFR0_EL1_RAS |
 		      ID_AA64PFR0_EL1_AdvSIMD |
 		      ID_AA64PFR0_EL1_FP)),
 	ID_FILTERED(ID_AA64PFR1_EL1, id_aa64pfr1_el1,
-- 
2.39.2


