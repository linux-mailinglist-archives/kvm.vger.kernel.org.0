Return-Path: <kvm+bounces-24494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE244956B31
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A9B7B240E1
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8228F16C696;
	Mon, 19 Aug 2024 12:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBlv6oZx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3B816B72B;
	Mon, 19 Aug 2024 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724071871; cv=none; b=QHXnABT9DmtQqbFbOM65ANXhr5o/PTlQXeaxy9cXfl6E2yDwSFY/L4WfBr948kxkI9gI8O87GzoHyS7cTLA347WyPMx5GYFRhRQzWY8C7FM8+Nvde+cpI2nsdFUyQB+ig7nFZ8qmst2vnm9+nH6dNv4G6dBmzmhDGQwNiZicMpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724071871; c=relaxed/simple;
	bh=JXUpYHtZACRIuspTSI0Js+ODC8Xo4P7wetbbael4Ih4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O2Ipd7XU9qUhvHHHXG96+7PrTWL0Js/n17SfNOYpQalafhWZ9tIFnMqTxP5ReQ/6eMOZ2TURxVPZtjnw8de6S3N+37MIySAxyHa8uDs3foy18q8UYdbPsUt5V0UJxaHKQJwbIl/imbTS1gA1F7PVq7xnqWRfEfAAt1BgYYC/9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBlv6oZx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BE8C32782;
	Mon, 19 Aug 2024 12:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724071871;
	bh=JXUpYHtZACRIuspTSI0Js+ODC8Xo4P7wetbbael4Ih4=;
	h=From:To:Cc:Subject:Date:From;
	b=UBlv6oZx7OQw/ZMewuNPV/fyZzMXH+WXgzC0eXUD/Cu7j3YkIc5feQ6xlYRKBwDt1
	 wx2p4z7Y9KzmMXWmSGdhUK4ofSMX2qJmes62M8OZnv7GFDRrsTbY0zKt47i8l2dq82
	 umVQIf035O/k63kqv02aA+LJ2HmO1Iyxe0DzghYshd4AGuV9bu+B/3vcoPu8t1dZpO
	 EZBZxZV1kyQK1be+8H2NU0zz0oAEGCBfu8DHbhAEKaaq53nUfT01hJifBBmuGHa2Rx
	 2z1Wir6Aym+02h6kkB8dRQCjWHs9tYLH6RYdpnN93Je3PeETMKx7UPKE3GrlHBRuyf
	 WeTb+3Mix0IPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sg1qn-004uwa-DR;
	Mon, 19 Aug 2024 13:51:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic: Don't hold config_lock while unregistering redistributors
Date: Mon, 19 Aug 2024 13:50:45 +0100
Message-Id: <20240819125045.3474845-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We recently moved the teardown of the vgic part of a vcpu inside
a critical section guarded by the config_lock. This teardown phase
involves calling into kvm_io_bus_unregister_dev(), which takes the
kvm->srcu lock.

However, this violates the established order where kvm->srcu is
taken on a memory fault (such as an MMIO access), possibly
followed by taking the config_lock if the GIC emulation requires
mutual exclusion from the other vcpus.

It therefore results in a bad lockdep splat, as reported by Zenghui.

Fix this by moving the call to kvm_io_bus_unregister_dev() outside
of the config_lock critical section. At this stage, there shouln't
be any need to hold the config_lock.

As an additional bonus, document the ordering between kvm->slots_lock,
kvm->srcu and kvm->arch.config_lock so that I cannot pretend I didn't
know about those anymore.

Fixes: 9eb18136af9f ("KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 9 ++++++---
 arch/arm64/kvm/vgic/vgic.c      | 5 +++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 41feb858ff9a..e7c53e8af3d1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -417,10 +417,8 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->private_irqs);
 	vgic_cpu->private_irqs = NULL;
 
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		vgic_unregister_redist_iodev(vcpu);
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
 		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
-	}
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -448,6 +446,11 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	kvm_vgic_dist_destroy(kvm);
 
 	mutex_unlock(&kvm->arch.config_lock);
+
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			vgic_unregister_redist_iodev(vcpu);
+
 	mutex_unlock(&kvm->slots_lock);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2caa64415ff3..f50274fd5581 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -36,6 +36,11 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  * we have to disable IRQs before taking this lock and everything lower
  * than it.
  *
+ * The config_lock has additional ordering requirements:
+ * kvm->slots_lock
+ *   kvm->srcu
+ *     kvm->arch.config_lock
+ *
  * If you need to take multiple locks, always take the upper lock first,
  * then the lower ones, e.g. first take the its_lock, then the irq_lock.
  * If you are already holding a lock and need to take a higher one, you
-- 
2.39.2


