Return-Path: <kvm+bounces-57564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4BEB578D7
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C15A51603EB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8507C302CD6;
	Mon, 15 Sep 2025 11:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0Xq/kLB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ED530147D;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936700; cv=none; b=Bw7ZDbYNrVZ9pPwsYbne6R+rJPxfjlZiL3j9A4SxVlvKSQKo7k/eNU73dZNfhy+veC+QYWo44avbnzqGt27QF7q0K8EbjWrfhwr+VPUjJtKWs0x/c8LS2K8vqf00Q12SArWnUy8Icr/j3UVJ36jFPmVke3gNhK9YzwMFJ+7WS+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936700; c=relaxed/simple;
	bh=z2QNt9RWN4zT8Ci51cyrFFeAAtDEFGBEVB1qDDNY7qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DdSVp9/bKUBYbx43C8nO6ru6UZeO+t/5RduioXpcE/ZxwBvHf+cyRt/myKhN6DhKlOLERnvm8fD12LLG2z9Hi/oyOAfKnDr4jLLkghrpg2eafrdHgBd2gtMn/f1dWWAfi5ttrR4S983cjyJbIH0ySCF4To8aEBliRUo3AX+1SiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0Xq/kLB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8320C4CEF5;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936699;
	bh=z2QNt9RWN4zT8Ci51cyrFFeAAtDEFGBEVB1qDDNY7qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0Xq/kLBiiv/ouO4uVwk2aqCB5U6PtbxQWGSwhfhR+MITR5M5Wq0R7ZKw0SqaUFzn
	 9njR3osRvpNSKnQcUYEvd3Bfw/S3vD9okXHcflEVSGNZj9Tx+JhOpifwu2fg3pawZ5
	 6OmH1mwxJdzECiGQGuWoRrp1bcXEnIY3iTdf0eBVODRssLICOCBYJTjw5ybTZBXlkx
	 1kkT+x/CXfbunvRr/DQDYL/zIxVSmtDzdN+2CBAPRT80vqhjoU9IR553zbQ9emcDuz
	 jUmIaUiEyFM65NyVBy1Hn+e+LAqW1aqLRyZyUKi1xCpVKMzK1yeUFpQXYNEkFf+J1q
	 YZZ98a5e5JgEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dh-00000006MDw-3r8g;
	Mon, 15 Sep 2025 11:44:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 15/16] KVM: arm64: Populate level on S1PTW SEA injection
Date: Mon, 15 Sep 2025 12:44:50 +0100
Message-Id: <20250915114451.660351-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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

Our fault injection mechanism is mildly primitive, and doesn't
really implement the architecture when it comes to reporting
the level of a failing S1 PTW (we blindly report a SEA outside
of a PTW).

Now that we can walk the S1 page tables and look for a particular
IPA in the descriptors, it is pretty easy to improve the SEA
injection code.

Note that we only do it for AArch64 guests, and that 32bit guests
are left to their own device (oddly enough, I don't fancy writing
a 32bit PTW...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/inject_fault.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 6745f38b64f9c..dfcd66c655179 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -106,7 +106,30 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
-	u64 esr = 0;
+	u64 esr = 0, fsc;
+	int level;
+
+	/*
+	 * If injecting an abort from a failed S1PTW, rewalk the S1 PTs to
+	 * find the failing level. If we can't find it, assume the error was
+	 * transient and restart without changing the state.
+	 */
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		u64 hpfar = kvm_vcpu_get_fault_ipa(vcpu);
+		int ret;
+
+		if (hpfar == INVALID_GPA)
+			return;
+
+		ret = __kvm_find_s1_desc_level(vcpu, addr, hpfar, &level);
+		if (ret)
+			return;
+
+		WARN_ON_ONCE(level < -1 || level > 3);
+		fsc = ESR_ELx_FSC_SEA_TTW(level);
+	} else {
+		fsc = ESR_ELx_FSC_EXTABT;
+	}
 
 	/* This delight is brought to you by FEAT_DoubleFault2. */
 	if (effective_sctlr2_ease(vcpu))
@@ -133,7 +156,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-	esr |= ESR_ELx_FSC_EXTABT;
+	esr |= fsc;
 
 	vcpu_write_sys_reg(vcpu, addr, exception_far_elx(vcpu));
 	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
-- 
2.39.2


