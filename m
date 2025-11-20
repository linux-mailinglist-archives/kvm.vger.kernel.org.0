Return-Path: <kvm+bounces-63848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C09CC744C9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 14:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DCD404F8473
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F53E33EAFE;
	Thu, 20 Nov 2025 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8BSLByV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8257233C181;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763645540; cv=none; b=FdZydYq1Wd+d8/mxDUELz+sheV1W5LVtimWnXaAwz6tsLCRQ1iKhJEOOAWfSGOShsv76n7TrcPDRNY6+UeQ5LbaSs8ZrPSltiMw+XzkCmNVJUXEC/0dvww1Xtlo8jd/bIihnhOlXgrzOp3IYx1SO9SJiXl+ZLpSzIeBEV9niMdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763645540; c=relaxed/simple;
	bh=b2L49jfqGv4rJQF7Nj77KE4YqTNOsdlKLv3vMtsROlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM5fq8tZqwc4ARe1Lec6TLUF6KZ3+WZwzlO8Ok9mtRn4a5COgOUYJYxWoFw8KLLM45JLSl/ln8yOgbnWbfSnhr9avKoQXqrllEkPjlm2arpaPYYa7txfIwgDvpBvVIM3mjoslPpkiwpZv9aoDeTA0KZrUi0rGY1qDxd9VtLMf+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8BSLByV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA0EC16AAE;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763645540;
	bh=b2L49jfqGv4rJQF7Nj77KE4YqTNOsdlKLv3vMtsROlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8BSLByVUD3MU8KJdONAL/52a2W5AKt8Fe3bxtJBNoUX8WZbH3LbTeiT5uw/+nYwd
	 IhLc5S44IdJwpVDSuPiil+u8R3wqIvLwGZZrEFGgfTz6jO7kbS3co9gxFa8aPIOUAz
	 dRbULX72ahYLqSYjEKzipM8E8CozhwG8oY4tcrNZrhYEZcENjgvjqQQwj17C+wSHGk
	 skD5E+Af0s2Hf8Yq+2YRwFpmiMS5NFeMz5hz3Gi7OkMqSQz0K0vNHQqQ3Fpkq6WzjO
	 VaZO+ZwmKrdGnUbIYMTFoanIZaK8hvgIcK2P4T+JUitE0VpQ8m6CDOtErZsfgSMoy9
	 KwXR5BR5lzOkQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM4lm-00000006tUG-0kH8;
	Thu, 20 Nov 2025 13:32:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
Date: Thu, 20 Nov 2025 13:31:59 +0000
Message-ID: <20251120133202.2037803-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120133202.2037803-1-maz@kernel.org>
References: <20251120133202.2037803-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
to force GMID_EL1 being trapped.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 84e6f04220589..40f32b017f107 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5558,6 +5558,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 
 	if (kvm_has_mte(vcpu->kvm))
 		vcpu->arch.hcr_el2 |= HCR_ATA;
+	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
+		vcpu->arch.hcr_el2 |= HCR_TID5;
 
 	/*
 	 * In the absence of FGT, we cannot independently trap TLBI
-- 
2.47.3


