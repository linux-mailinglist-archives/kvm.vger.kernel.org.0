Return-Path: <kvm+bounces-9793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D878670AD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FE141F2C69D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDCE5647F;
	Mon, 26 Feb 2024 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5UHoJwR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AFE56458;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942056; cv=none; b=Uh66AYCh7XCKguGq30cTLIf9GrHXsogr3jRmKEXFy6zdFnkB0RmgCjcdaya1rlYkBjNsPVic9n1MKhqPYm4Qe0X1IdBvlZPCr3l8ZGPuxuiClMn2R/j/KUik6yZ5JJ1pSwopwCTJGFYj20wPhwPcJOGnj6+ozQyQc43vVCy0INg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942056; c=relaxed/simple;
	bh=/JFNRuFhSNGUhTs1Ose+PaTc1pfV2tE0oa2Vq1kSAYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oXrM5Wm92+zJV0hnR3s1zmSpCnTe0Ns42a4qaNchvk/OkW4fgd1HrINN8vxnAgVrIBeEmralWlXDeebMWz9Qv83zPkuLiyxyMsnbEW1eQ035Z+3U9CkUgTAjxakrBKgxjbuaP+PmWUt6o8PEKYdx3vnTPXKLvqICoPO0wsYMsrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5UHoJwR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F7CC433F1;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942056;
	bh=/JFNRuFhSNGUhTs1Ose+PaTc1pfV2tE0oa2Vq1kSAYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5UHoJwRw7p66gnCLeiadvZecd7/5/7v6eJbv9DNVZuJFOMk+sUYviiKs5t+P6p9f
	 uB68Pin4ZBtc0fPFUUcHeLz0EqjsZfkTQfl5hKJM2xJDV4gjwMbHco5MsDO4ymkuI2
	 4lJ86wET6qqhUedE/OJ6Hd4yFHvQSBU7yDtiuqWZxNhlVyWYvPjb/XmfQf9syuQRyq
	 7LHOn8ieDjorZXRCSVLrckweQWJqXHmEErttT6h0Cm2UDuUgZZV74a9zc1faIGzmQ0
	 E6RCS5zpbHz7AxVjLFA3p2EjSEIxy2cket01KZ/riWBd2fzloO7ySbWIDSEOnxA1gQ
	 bUEZfhwBE3xLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtV-006nQ5-Up;
	Mon, 26 Feb 2024 10:07:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 03/13] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Date: Mon, 26 Feb 2024 10:05:51 +0000
Message-Id: <20240226100601.2379693-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It has become obvious that HCR_EL2.NV serves the exact same use
as VCPU_HYP_CONTEXT, only in an architectural way. So just drop
the flag for good.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 --
 arch/arm64/kvm/hyp/vhe/switch.c   | 7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a5ec4c7d3966..75eb8e170515 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -816,8 +816,6 @@ struct kvm_vcpu_arch {
 #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
-/* vcpu running in HYP context */
-#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..58415783fd53 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -197,7 +197,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * If we were in HYP context on entry, adjust the PSTATE view
 	 * so that the usual helpers work correctly.
 	 */
-	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
+	if (unlikely(read_sysreg(hcr_el2) & HCR_NV)) {
 		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 		switch (mode) {
@@ -240,11 +240,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
-	if (is_hyp_ctxt(vcpu))
-		vcpu_set_flag(vcpu, VCPU_HYP_CONTEXT);
-	else
-		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
-
 	do {
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
-- 
2.39.2


