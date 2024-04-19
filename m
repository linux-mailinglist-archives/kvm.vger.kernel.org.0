Return-Path: <kvm+bounces-15232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDE78AACD3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA34C1F220C4
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1B580022;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1z7xiyT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317F47E564;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=XiWJoTGuJIviVesBS8IGCpGg+oO+gBada+QvqgncLCb6vrd8C2wQaMOMxguMDSvdZoaO0bG7buY36pfqrUkq+H5XqgI7rzyRAAk1YpgIjYSVM2fqtlghaXElzA/0tDEOPU55Xg/eUWOAlCK1bQT5qmWEFJxUq0rD05+LFTciylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=0rZiPoamnUU17Xi5/XFxXZrf+/7ihZhKHezWSfWcHpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WAJo7enf+FUEqt3pyLGgZoaU2gGyomRqP2m23loD91HJKI+RN9xk4yAlxy1QWXjDV6Xy1604eO6NepPueQkGBAZPc3PcdOpedI6225NzeNdl4UW+1Sp7tZ4/zMLtajpD1MmkBPR9z+dtGCfrPvzThy3+uzZNdiSICHWyS9LDlFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1z7xiyT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCFAC072AA;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522591;
	bh=0rZiPoamnUU17Xi5/XFxXZrf+/7ihZhKHezWSfWcHpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1z7xiyTEIxzXpTg0RkBC6qcAQDuOZUzt+2jku/MtFaEiWNp+yguhSSeEiTZnlkQ8
	 pgd351OXr/iUn/8YlmA1hM+lpo+kmQTIfzDQ5EO/g+8NTLPn3cS+xEEpRHmRw3HTQn
	 DRaZtNK0mZZLgv1Tmg4vxbH5QKwcdGt/bzjbkOpLw7099k9eMzF23uxYvHbQh8Fp9C
	 b78OIc5qdxhMFQXwY7bHv2KxzfBcYvhpbN1jwWw2VRbEgG8qokChQGWYoFAJboUax7
	 v3RZHlLKAzCWbPEqoUGL2cvtbfSMY5SyGUsqPxd7To091DqYpSw66PO+pt4/JiqwXw
	 vlQB7EP2G8LEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV7-00636W-Q1;
	Fri, 19 Apr 2024 11:29:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 04/15] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Date: Fri, 19 Apr 2024 11:29:24 +0100
Message-Id: <20240419102935.1935571-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
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
index e24bd876ec9a..5566191d646a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -817,8 +817,6 @@ struct kvm_vcpu_arch {
 #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
-/* vcpu running in HYP context */
-#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..07fd9f70f870 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -197,7 +197,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * If we were in HYP context on entry, adjust the PSTATE view
 	 * so that the usual helpers work correctly.
 	 */
-	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
+	if (vcpu_has_nv(vcpu) && (read_sysreg(hcr_el2) & HCR_NV)) {
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


