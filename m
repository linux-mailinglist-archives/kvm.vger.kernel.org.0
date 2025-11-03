Return-Path: <kvm+bounces-61878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4985BC2D4ED
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2BAF188AEBA
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D77324B32;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHpgYn8J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759A2321426;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188931; cv=none; b=ZG0TbncjQqu7HjHyZ+GrNWNTi62ZViv6xeVx1RwEy/huRpgimw4prWFbk2YQQXKMIBf9ooRNnXkg1VnOFbCutHqVtIm8MREzaEJemommmwWxHhyTKXSsJV5BvSCudTxJ2OWZUG2gjEEEiQCvBJx1kRjzJMOH4VLBvcXViw/Av2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188931; c=relaxed/simple;
	bh=5IkFfNBLzAtUk47cnyzmf/J4gBVwD0aQa6Mumy1Fgbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqw/5PA73uN6SfdbuEFNDngexMKfKN/a5TGnOo72SFoTcJr0O4CcO7IE4NtZ7wtFXcXa+IDaCxY7CIrfLQuK/BHIAR4ec+mV6XPv+uAqjC5EY5spweJdHeOS7ZWxo8weZ4SOpPX/ljZHnCqjS2MULVXNJcXe5KdM0a79E0h8Yfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHpgYn8J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA14C19422;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188930;
	bh=5IkFfNBLzAtUk47cnyzmf/J4gBVwD0aQa6Mumy1Fgbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHpgYn8JjWDQ1My6pKlCQRrT0bVmbnSKZL1ZUb5Kus5oqf5Id37XMJXWEXI1t/R6p
	 sE2RxnmAtAXP1Xa/g8Zi/uB2e51bkaKCygS1yts7G3HNtW3daZSYpTEx0V8agfxPUE
	 z0Av7EFv9h0Dk++Xye8VELUjIfsweKktQY6nIac5uOAR7K6Q3Jai+a8q/eVGbf06E8
	 OG96WKNOV4z8YxJ9Balm+HQc8hTH+WyPZ8zOpIOgKi+3OKlgCY4GBXghXUy7tNTvoo
	 GvSS+TcMD5WjZyy/oaQi6qC0GYa4oI6mXYxb2fAUDrkTsnE2yK69XLLK3UkBUdwdNR
	 Z4lobF/7eqdaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq4-000000021VN-3yAC;
	Mon, 03 Nov 2025 16:55:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 18/33] KVM: arm64: Compute vgic state irrespective of the number of interrupts
Date: Mon,  3 Nov 2025 16:55:02 +0000
Message-ID: <20251103165517.2960148-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to rely on the [G]ICH_HCR{,_EL2} register to be
programmed with MI information at all times, slightly de-optimise
the flush/sync code to always be called. This is rather lightweight
when no interrupts are in flight.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8d7f6803e601b..46b31cd365466 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -985,8 +985,6 @@ static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	int used_lrs;
-
 	/* If nesting, emulate the HW effect from L0 to L1 */
 	if (vgic_state_is_nested(vcpu)) {
 		vgic_v3_sync_nested(vcpu);
@@ -996,20 +994,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu))
 		vgic_v3_nested_update_mi(vcpu);
 
-	/* An empty ap_list_head implies used_lrs == 0 */
-	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
-		return;
-
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
 
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
-		used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
-	else
-		used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
-
-	if (used_lrs)
-		vgic_fold_lr_state(vcpu);
+	vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
 }
 
@@ -1053,29 +1041,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu))
 		vgic_v3_nested_update_mi(vcpu);
 
-	/*
-	 * If there are no virtual interrupts active or pending for this
-	 * VCPU, then there is no work to do and we can bail out without
-	 * taking any lock.  There is a potential race with someone injecting
-	 * interrupts to the VCPU, but it is a benign race as the VCPU will
-	 * either observe the new interrupt before or after doing this check,
-	 * and introducing additional synchronization mechanism doesn't change
-	 * this.
-	 *
-	 * Note that we still need to go through the whole thing if anything
-	 * can be directly injected (GICv4).
-	 */
-	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
-	    !vgic_supports_direct_irqs(vcpu->kvm))
-		return;
-
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
-	if (!list_empty(&vcpu->arch.vgic_cpu.ap_list_head)) {
-		raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
 		vgic_flush_lr_state(vcpu);
-		raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
-	}
 
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
-- 
2.47.3


