Return-Path: <kvm+bounces-62447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1A4C443F5
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2F1284E56C8
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBDD30DEA2;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXzU+rng"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D230BB97;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708596; cv=none; b=M7mLwg9Y5lEQZ1Oxl4C4NmV30enhvlgoQtdlpC4Zskf99Ke34PdpBhpWslgS0RAAT54C0Fzf0nZ4Zb2U/NdRs4FQM6AjPxRlJSf3Gd7f2kU/CB3/WC1KVXXZ6OUjjeuDINXPTUu5Y8GIZZXFFilZhRGpQ2ainAyuIql96ABK030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708596; c=relaxed/simple;
	bh=MbdtwSik8XmKu9gMYviJLErwRbd5OqFthOk0PFdkfWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjG/V9u0nWILRORdeg0uk1/OQ3Ds61xvSNTJ4qTLLBrCvSg+uTBlFSeWkQ9LtHV9QPzMKV3H9tmXQwTsW4w/4kNvHXQMW02/HX41gp6XQkhIXQc8Y2dDMhbU/Aurtv22njyFkiJQhTFRd3qsk0htPIu2oGjxZhT9oH8/LqJ07Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXzU+rng; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69441C19423;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708595;
	bh=MbdtwSik8XmKu9gMYviJLErwRbd5OqFthOk0PFdkfWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXzU+rngqH92GeXd8SLrjUv9/o0wYB7wZLuijkUG9cjMWSvBr83HMxpK384hfAXOm
	 2A67HZoZNodlDTMoS/7Mca9nDxWEk7mLGRx0SEBrY0xdHAWq7CyQ9Ccre3WlczKeRW
	 UEu6vyRxbVW2450yvrUyZH4AtMe4vjymHTMYAKRouBARwD0jA0MhYAeMTua3NFdvcE
	 xuD78xiHXzTPNFYAY6Wn7M+ZbOGZqUPJv8L8q3wUdcYXACItyVJaUrcAN5l4PJkBDK
	 NSPaC1wNNWnhRHb518JOrtXXq8Jm0FXpEuLRnbdBQu/1S+tEwgH5RCJGxvrioMmVS6
	 3q/MEQxXyoeEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91l-00000003exw-2EFw;
	Sun, 09 Nov 2025 17:16:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 22/45] KVM: arm64: Make vgic_target_oracle() globally available
Date: Sun,  9 Nov 2025 17:15:56 +0000
Message-ID: <20251109171619.1507205-23-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make the internal crystal ball global, so that implementation-specific
code can use it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 arch/arm64/kvm/vgic/vgic.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c420f8262e4c1..570cc8fe42b87 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -237,7 +237,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
  *
  * Requires the IRQ lock to be held.
  */
-static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 {
 	lockdep_assert_held(&irq->irq_lock);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e48294521541e..037efb6200823 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -261,6 +261,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
-- 
2.47.3


