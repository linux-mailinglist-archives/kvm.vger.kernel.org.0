Return-Path: <kvm+bounces-12406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 133C6885CAC
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:54:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C183A285C2B
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E5212BEA6;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUkk7VLM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369B86622;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036472; cv=none; b=YAh01xmhFcRrgyIENl/sJVZtclzunCZpMjGxbVjf1pEp7/Am7J018Q7wu5YFjEY3Wqmn4RbS0PaGljAFsRUlpYZF28SbvfdGF0fA+kb9FjZ28F8Fx6y+mx6o1xzt6k0JHnyvfWu6PAH4riDRALqzPkZ9rzbnS2hGU0wK0f548UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036472; c=relaxed/simple;
	bh=GA1KleUB16oUS7y7HqfqvAiW952IEgag5B1ooVUmgBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UuE2IoG0XDANfy0fv/XBpRPRablTQTxkd+/C3jjFbgtbytqCbi4KLzNM2aPt9407/9uD1b2akUHf2wRnLUot+1MRDe+RXKw72nJ+/m5rHTLNV0Sm/a3wcQ0gip7R88wQ0ny1Sp+nZFTQFqscc9lQD6xDNxo8qnIT0sIDLrK40cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUkk7VLM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AE1C433C7;
	Thu, 21 Mar 2024 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036471;
	bh=GA1KleUB16oUS7y7HqfqvAiW952IEgag5B1ooVUmgBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUkk7VLMUvssGxWt0sH6W69zpMQreu6SDVV9cBkLs0TQXgUMFFCBLMrOs+21mcbLN
	 Avf/YfiBcVP1v3cZOv51Kjn1GhGiSLErtfcVotA1MR/hf+K3XpdvmZgq0TPZ9WqWgA
	 SETqT7HGsOLavOTEmA7a1Sk8XuIUmLMv7NjMkiGaAWpTG5wouW3u/yhoBuq4yGLwtT
	 66oeyvP1MSX/dOR90knHtdvWOZwmOj81BGs6Nzu4NZiZ7lHMoQg8Ic704Zj+T/Z+b9
	 o3wqZdOP/mKBSfpCTn3vBfPS56h9xHNcOMKunvj7c3F2n25f2xKa+UVp0L1+8oyWpI
	 t6Af6Z6yd/GGQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkQ-00EEqz-68;
	Thu, 21 Mar 2024 15:54:30 +0000
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
Subject: [PATCH v3 04/15] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Date: Thu, 21 Mar 2024 15:53:45 +0000
Message-Id: <20240321155356.3236459-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
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
index 839c76529bb2..3f1c3c91e5c2 100644
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


