Return-Path: <kvm+bounces-33946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8D39F4D8C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D6691689A9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216741F63D9;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQIynE8Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D6E1F4E23;
	Tue, 17 Dec 2024 14:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445407; cv=none; b=fxeLpeGyfKZd1JQXnmDpbDWz7tDJZ1KV3Camu/4n/qw7ClTJqzsUx3dgN4Yt7hE7smMbzqqRCjlMRaTCWmFA7ezj64JCltYpFVAyMnSMQHoKqrsKtM17eTRk2HWdD5sBilyBRd1PyRu+440mGqHvShUV2/v4wHsLKST2Qdqa7Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445407; c=relaxed/simple;
	bh=nt83Bx4IHnA3dzdKS/0K9IvUZKFruxfW2Pr7Afn3zv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ILehVmwFYxPH/4fP4cyVO8bu1xB6M5he7IbZnIOinTj6Myg3H49mLA+9R9ykjjA1n7utO5W6lRfdM+wAvUlMLpBW7zDoLHN+Q3k5uU0ZOt0gQHg1yxk67TiwS2QiF1V13S72strOI195vjhbXKTuyL5KMuTdZpMxlJ3prW7kQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQIynE8Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AD0C4CED4;
	Tue, 17 Dec 2024 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445406;
	bh=nt83Bx4IHnA3dzdKS/0K9IvUZKFruxfW2Pr7Afn3zv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQIynE8QpmGUpRjsK5ottqArt6PSiSqa0XjRb0tbaXVre7Yd+6dYg8jkxM2Hp3Cgg
	 OFT9dcfOltxZ9eADuStA2C1CPfqxsGvCixmyIFbC9Q6AbBqMp+TzT+PH4W12QDAsIp
	 gK9vpCq+zmD9J0eaNRh1FmOV/lU5atCpY+A0Cfkf1HTUbIU/5WvXLf3blwmRr4we+8
	 OiRULy6rmgKBw1tM/Sp0LCQiepPxp7mAeBD+rBTVCUbfjtOD+9a7VU4cVLaDZODtqQ
	 /aUmno6TAFShy0lkpk3y3MZ19pRilri3uqKr9gpdz5ZxzY3mVAL80TOSjV7pfLmtsW
	 LNZKQYTo7HshA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTs-004aJx-U5;
	Tue, 17 Dec 2024 14:23:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 03/12] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
Date: Tue, 17 Dec 2024 14:23:11 +0000
Message-Id: <20241217142321.763801-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With FEAT_NV2, the EL0 timer state is entirely stored in memory,
meaning that the hypervisor can only provide a very poor emulation.

The only thing we can really do is to publish the interrupt state
in the guest view of CNT{P,V}_CTL_EL0, and defer everything else
to the next exit.

Only FEAT_ECV will allow us to fix it, at the cost of extra trapping.

Suggested-by: Chase Conklin <chase.conklin@arm.com>
Suggested-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 21 +++++++++++++++++++++
 arch/arm64/kvm/arm.c        |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index ee5f732fbbece..8bff913ed1264 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -441,11 +441,30 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 		regs->device_irq_level |= KVM_ARM_DEV_EL1_PTIMER;
 }
 
+static void kvm_timer_update_status(struct arch_timer_context *ctx, bool level)
+{
+	/*
+	 * Paper over NV2 brokenness by publishing the interrupt status
+	 * bit. This still results in a poor quality of emulation (guest
+	 * writes will have no effect until the next exit).
+	 *
+	 * But hey, it's fast, right?
+	 */
+	if (is_hyp_ctxt(ctx->vcpu) &&
+	    (ctx == vcpu_vtimer(ctx->vcpu) || ctx == vcpu_ptimer(ctx->vcpu))) {
+		unsigned long val = timer_get_ctl(ctx);
+		__assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &val, level);
+		timer_set_ctl(ctx, val);
+	}
+}
+
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx)
 {
 	int ret;
 
+	kvm_timer_update_status(timer_ctx, new_level);
+
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
 				   timer_ctx->irq.level);
@@ -471,6 +490,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 		return;
 	}
 
+	kvm_timer_update_status(ctx, should_fire);
+
 	/*
 	 * If the timer can fire now, we don't need to have a soft timer
 	 * scheduled for the future.  If the timer cannot fire at all,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fa3089822f9f3..bda905022df40 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1228,7 +1228,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 			kvm_timer_sync_user(vcpu);
 
-		if (vcpu_has_nv(vcpu))
+		if (is_hyp_ctxt(vcpu))
 			kvm_timer_sync_nested(vcpu);
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
-- 
2.39.2


