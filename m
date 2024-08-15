Return-Path: <kvm+bounces-24260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7868F952EAD
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E456BB2709F
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9080E1A7057;
	Thu, 15 Aug 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tOpN1n7Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2C1A08C6;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726807; cv=none; b=GcFX86oB3cU7DDp7+YQncENYTxc10bL7TgeU23oH9wlVs9GWq8SNEHuCfir2ISpMjRNZubupnhvr98diY0J6Xuc+AAZ+8bREE3RyPD81+JB+MTzjUMmcxBosJUbqI60UkiceEPi54za34RL0P4YKq+jtefj9xUDCo7IVCuQEko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726807; c=relaxed/simple;
	bh=mK14fzCAqNWDU2X/p4rg7gI3jGtTuF6ltMZP9FdhjP4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ScuM1ZFD9ttwfAUoIAQ5qaaGf+PMxtwxCahw8DtOEBaEaUEifpEVaHCyjUxZWwBB2xMTh6Ubxssf72tG4k19ixBSTynp7+AETqf9y2WY0DRMex4tBAjb5/CZVGkdSr0/0qr71aeHCboG0Y86WXxevGAK+sI3P+Mqh73toB9QH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tOpN1n7Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464BCC4AF13;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726807;
	bh=mK14fzCAqNWDU2X/p4rg7gI3jGtTuF6ltMZP9FdhjP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOpN1n7QiW060Vpp74zalPtBnU5Ocs9BA94JbF9j766RRI8IjoBe4wEI4ocNgiMh/
	 CfmS8nRZ2IW7BTAX5xUHy43X9t1a4r5yAG8uJ5p/ztLxzQUP15nyhVkJY0oLceouwz
	 xV+LXRUW0VZ0+6jBZC+9epWmBuuSQKOtCVLUeG8j7NRjlnvJpGj8TdHnJC6ccFgZn/
	 FW2B7BvHlUQetje/2XvK+1GDvphTYRKkl13vZzUw4uXDH5Qs3yM51YbJgqGz7ZepWY
	 n+uUXVNPdKng3fiuJ0KIw032tGBBzobKFv3PW6+CwsxcbnOo9mOeqjigUG081J2SCR
	 w4N8+R7y1c+vQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5F-003xld-I8;
	Thu, 15 Aug 2024 14:00:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 10/11] arm64: Expose ID_AA64ISAR1_EL1.LS64 to sanitised feature consumers
Date: Thu, 15 Aug 2024 13:59:58 +0100
Message-Id: <20240815125959.2097734-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite KVM now being able to deal with FEAT_LS64, we still don't
expose these feature bits to KVM.

Plumb in the feature in ID_AA64ISAR1_EL1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4901daace5a3..1489179f1b25 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -228,6 +228,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_LS64_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
-- 
2.39.2


