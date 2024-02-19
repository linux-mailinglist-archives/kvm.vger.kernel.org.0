Return-Path: <kvm+bounces-9052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CC2859F7F
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 843CA1C21CBC
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCE024A06;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOAU80Ko"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D922F02;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=ma90FXyCFnTbxb/kAdBohNO4S/MrKsfkz3pJPZeYfiwnMzijHjUtaWCc5CvLaff7Q4NAP0v8m6N54CfR+NQYaYUq1Hri4gMjj1XlAfsDhYv+ZBY34vxKl0w4RXC84Ej/H4BvcRq0GVnfjDWIeid5sBtTOtOBKL51OeeUJsRWKAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=vgRLwq7Xgg3mkOBLCbxDTHOAAGNZox10P/aUL125qb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PG3B630JU7LKSwpj5Ag/mRvPNJK8ufL+tUlsZFSuPZaU0SfeyPYBOXY6qfLCiIpV+G7v0/bRBt7RFgtfKlNR/fCOYfuoMAhiXfL+m2u0dnJiMbyBXyrkm9mqN3Vov4Sj46Aqt9+3K2hhVoPjiTos/bGJ7r3T9qHWdXGje56/1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOAU80Ko; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAB4C43399;
	Mon, 19 Feb 2024 09:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334424;
	bh=vgRLwq7Xgg3mkOBLCbxDTHOAAGNZox10P/aUL125qb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOAU80Kops03hFfKf2Qg0pH6J12Cgt64kR7juF/o0W+hjzDrqaPgy/R/SPjXnJFhD
	 cghurczpI28Hwv/pTRxM6jRqjmvr3h8ocdNkQw+xHGgd4gGoAYM1Ssm0wk/TTLPHba
	 apQwAkgBrm4E06nhVyDrsQzikEHCVzvfKXXBXMYhL5TaA7xCcZH+hEbYBewkRg38w+
	 +943CVkdGvmSFLxCIIIP1vbjM2jHy+p6//WGu4tdV3VhRd6oIyXSFvuQ3i8c+IAR2f
	 iUQrFky1iDNHx9Gdn1XDG5PFsoc8JOmuMrJGlUrfRVOXFr+swtPmYa4ZgSkRFeNE45
	 Ab32fs76aSWlg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp0-004WBZ-1r;
	Mon, 19 Feb 2024 09:20:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 03/13] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Date: Mon, 19 Feb 2024 09:20:04 +0000
Message-Id: <20240219092014.783809-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It has become obvious that HCR_EL2.NV serves the exact same use
as VCPU_HYP_CONTEXT, only in an architectural way. So just drop
the flag for good.

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


