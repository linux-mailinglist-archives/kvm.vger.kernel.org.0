Return-Path: <kvm+bounces-55906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6F8B3878C
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79DBC189AFEB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E8135CEB4;
	Wed, 27 Aug 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuTmxL6w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501835A287;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311051; cv=none; b=MARATLxla/Bc+RsQGswbXGjwPzlX7AmKJrevj69i89x6Nx2reG/LcQHiB3y04CbJ4PuMGUv1kA+ge1TgjxucJTlGk3pC2YsiOu3bzlvkWdA175PMccdBzfddygujgupPtKa6gar2Agt/B831Ir+n51OYQajYzHoqKxFZ1P/t6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311051; c=relaxed/simple;
	bh=z2QNt9RWN4zT8Ci51cyrFFeAAtDEFGBEVB1qDDNY7qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=teL1M27pD/EUSfLqmT6brLp9yDtA4KzxJiAFVxd+6e0ilhdQIHud5GH/wzXw3WL3egCXIx9SRaSB75n756hCene/y1fCRmFmt5PaO2Bgxt3/kqt72khazLLN7z8V7N01BL8ezWn0gZ53Fs/eTLmLqdf3iX/ZLGGDjW1XWnhA9xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuTmxL6w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E73C4CEEB;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311051;
	bh=z2QNt9RWN4zT8Ci51cyrFFeAAtDEFGBEVB1qDDNY7qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuTmxL6w/vaN7bCsdjsNiSafrHPqIO7Y1cxq7I1OTmwTYPOSyY77n/9UsP8T9IAwI
	 A2QLBFKn+1ZlchfSobF5WS2whfV5h2jJ+xt1+a7+AYcmSs6CuYCxfAbOBQaT4xiUP+
	 3eK9FGIMcetdAFbn86woZFNGjN9C/ZNw3Y6j5X9ylgiWfO1zU43iFMalXCD0qglvGy
	 T7/h0hT62usau7HIcwizJzqHQWjcC5RtbDnxK5r3RxIyY7yar2GYKHqYl9powgw+CQ
	 bbNK1Wc8BFKBnjwfNjHsg57FxkmYeXTQMQebxsjYnfzud0wL1//0cCwMmTCf0o+1IZ
	 XCdK6970s03Fw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjZ-00000000yGc-20oF;
	Wed, 27 Aug 2025 16:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 15/16] KVM: arm64: Populate level on S1PTW SEA injection
Date: Wed, 27 Aug 2025 17:10:37 +0100
Message-Id: <20250827161039.938958-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
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


