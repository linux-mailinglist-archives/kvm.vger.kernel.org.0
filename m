Return-Path: <kvm+bounces-8558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAD6851747
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 15:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F352F1F21ADC
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD57C3BB27;
	Mon, 12 Feb 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvIDdJ3J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BB13A8E1;
	Mon, 12 Feb 2024 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707749273; cv=none; b=NI/F0m0CkyIuxAyC97Fpt7rGK5mcXNpaSV2lJbfAH8r89yVS2ntmKDo3y+cF2L8n3qQDSZugpdMkwm4IwRa1AQNXFoTyNrPmddyY/+SGa0lotCXtMqhKLbSnt7A6l+rm4gIkJb7gHNxbqRHLl9N71LoUIM39PqHQIeP11KOKP9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707749273; c=relaxed/simple;
	bh=ZXneBhFmBJdEwSkN2n4xuDWuiLWPPGEZARRHNq4gGLI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SpcrCkNI7lv2W1AF0qeBvFdNUzURb0aImPp6RLnqmil52CoxH5WGc6tCEdTI0ZzCmQD+98ICCOoqSeVW+6K5wZECFyDKf7IOv4YwCweKZP26vbN7I2HlOFJy78DFHbuf7KxfvIk8P1Z4UZBC/PqaxEeiX+vheYHV0dZC+fnhT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvIDdJ3J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D22EC43390;
	Mon, 12 Feb 2024 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707749272;
	bh=ZXneBhFmBJdEwSkN2n4xuDWuiLWPPGEZARRHNq4gGLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvIDdJ3JH5kyYue4QQP7iIaXZCOgHTKhzkdGwgvRdbzDju+TQICIepcWg8kueLwGF
	 6xtBlDaFxUSVD8tZhKaRKpG01ZpxuNXtfT4fuB6xy7ulCj12ksR/3ZdJxkx0d4B42l
	 SFdXy2KhOQhWyT/gWvrwcO6RwxtgAbYaH8fAIaWdS3E9BCtyoMPcwfq1W7TRwcqU5o
	 HWoOrNzBVgcHJ1hwzLRt56JNLjqDJYZM3u4+Yf2VvestASo8bnUk3NhCPSHFLDuIyv
	 Feo4mU7m9+oXM3oTbQaCz42clxgAPAqm9/u+8veBX/iI/hfmj2XnXCi1YihtfHPIKZ
	 MbGQYnx21gLjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rZXb4-002SFp-ED;
	Mon, 12 Feb 2024 14:47:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/2] arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to __read_sysreg_by_encoding()
Date: Mon, 12 Feb 2024 14:47:35 +0000
Message-Id: <20240212144736.1933112-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240212144736.1933112-1-maz@kernel.org>
References: <20240212144736.1933112-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, m.szyprowski@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When triggering a CPU hotplug scenario, we reparse the CPU feature
with SCOPE_LOCAL_CPU, for which we use __read_sysreg_by_encoding()
to get the HW value for this CPU.

As it turns out, we're missing the handling for ID_AA64MMFR4_EL1,
and trigger a BUG(). Funnily enough, Marek isn't completely happy
about that.

Add the damn register to the list.

Fixes: 805bb61f8279 ("arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0f29ac43c7a2..2f8958f27e9e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1456,6 +1456,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64MMFR1_EL1);
 	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
 	read_sysreg_case(SYS_ID_AA64MMFR3_EL1);
+	read_sysreg_case(SYS_ID_AA64MMFR4_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
-- 
2.39.2


