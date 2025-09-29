Return-Path: <kvm+bounces-59009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C933BA9F1A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8571A189C656
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D260B30E830;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rIAfF+YX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F130DD2E;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=f2EfRJQWsVH++vZGrGiVgIZVroorviRZP5E8qyp4Q3Eqim5XQMqrNHx3o2/4oVKDAsA0vzjWLAhS09LZfA3e+PEIHFue+n696jJcipQrpWp7TKZKe+Twn7W2BLU+U9/MvJzq6I52A8dYdCU8k3oo2zexjj2/AjYIZSrfOnhpOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=QaAmbIAj1ix/QzZhUtIyoV/YUefuJRxlamqZNSzVlP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/zxAaSL9gQuzZt+uVz0ZkML+Qw1ACpzF25QwIM6vZjFzDRimyqhuy4GXwEgCkTb9kFs1s3IRg3PeQFNn0Ic7f+stXNX9iYdf5/th3vvRxLw55C6FgD7hhxDeSisHqutszqy6Q3o1DGW0fdcXJQjEisF4E8kJZDFHv8t4/BMTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rIAfF+YX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE49C113D0;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161907;
	bh=QaAmbIAj1ix/QzZhUtIyoV/YUefuJRxlamqZNSzVlP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIAfF+YXLJ5xJFUzonj6WlAJdMn8hHPWmmiisY5vES9AER43wAvdWIxm6jbSxfDnR
	 bvdnlDlkaPCx5B1T8xcpleN/i8g2LkHmbHb2FwRSJ4wWKhFA3NF+5qe3jhi0qH/M4o
	 +jcgZ7tV54dENYmFcr2yfqa/ct+x95wxy5QkjmoV7eRN4rOhi37uPnx8wjhy+NgOfx
	 2IX5sDj1jhWlVMBzp+R0wuSuysKy8gyrZD9n+Zcp8HdPlJfDzZTJZnkD0dv6TfHhDe
	 iDRNDC3en4iCe9JRN5DXdWetqTYDggZ9DOI3N8ryFV2dNKgISk5I3r4jCrijUKEIko
	 8AgjM8Q39FLrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN7-0000000AHqo-2hUx;
	Mon, 29 Sep 2025 16:05:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 10/13] KVM: arm64: Kill leftovers of ad-hoc timer userspace access
Date: Mon, 29 Sep 2025 17:04:54 +0100
Message-ID: <20250929160458.3351788-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
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

Now that the whole timer infrastructure is handled as system register
accesses, get rid of the now unused ad-hoc infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 68 ------------------------------------
 arch/arm64/kvm/guest.c       | 55 -----------------------------
 include/kvm/arm_arch_timer.h |  3 --
 3 files changed, 126 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 27662a3a3043e..3f675875abea2 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1112,49 +1112,6 @@ void kvm_timer_cpu_down(void)
 		disable_percpu_irq(host_ptimer_irq);
 }
 
-int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
-{
-	struct arch_timer_context *timer;
-
-	switch (regid) {
-	case KVM_REG_ARM_TIMER_CTL:
-		timer = vcpu_vtimer(vcpu);
-		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
-		break;
-	case KVM_REG_ARM_TIMER_CNT:
-		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
-			      &vcpu->kvm->arch.flags)) {
-			timer = vcpu_vtimer(vcpu);
-			timer_set_offset(timer, kvm_phys_timer_read() - value);
-		}
-		break;
-	case KVM_REG_ARM_TIMER_CVAL:
-		timer = vcpu_vtimer(vcpu);
-		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
-		break;
-	case KVM_REG_ARM_PTIMER_CTL:
-		timer = vcpu_ptimer(vcpu);
-		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
-		break;
-	case KVM_REG_ARM_PTIMER_CNT:
-		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
-			      &vcpu->kvm->arch.flags)) {
-			timer = vcpu_ptimer(vcpu);
-			timer_set_offset(timer, kvm_phys_timer_read() - value);
-		}
-		break;
-	case KVM_REG_ARM_PTIMER_CVAL:
-		timer = vcpu_ptimer(vcpu);
-		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
-		break;
-
-	default:
-		return -1;
-	}
-
-	return 0;
-}
-
 static u64 read_timer_ctl(struct arch_timer_context *timer)
 {
 	/*
@@ -1171,31 +1128,6 @@ static u64 read_timer_ctl(struct arch_timer_context *timer)
 	return ctl;
 }
 
-u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
-{
-	switch (regid) {
-	case KVM_REG_ARM_TIMER_CTL:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_vtimer(vcpu), TIMER_REG_CTL);
-	case KVM_REG_ARM_TIMER_CNT:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_vtimer(vcpu), TIMER_REG_CNT);
-	case KVM_REG_ARM_TIMER_CVAL:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_vtimer(vcpu), TIMER_REG_CVAL);
-	case KVM_REG_ARM_PTIMER_CTL:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
-	case KVM_REG_ARM_PTIMER_CNT:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_ptimer(vcpu), TIMER_REG_CNT);
-	case KVM_REG_ARM_PTIMER_CVAL:
-		return kvm_arm_timer_read(vcpu,
-					  vcpu_ptimer(vcpu), TIMER_REG_CVAL);
-	}
-	return (u64)-1;
-}
-
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 138e5e2dc10c8..1c87699fd886e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -591,49 +591,6 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 	return copy_core_reg_indices(vcpu, NULL);
 }
 
-static const u64 timer_reg_list[] = {
-};
-
-#define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
-
-static bool is_timer_reg(u64 index)
-{
-	return false;
-}
-
-static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-{
-	for (int i = 0; i < NUM_TIMER_REGS; i++) {
-		if (put_user(timer_reg_list[i], uindices))
-			return -EFAULT;
-		uindices++;
-	}
-
-	return 0;
-}
-
-static int set_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
-{
-	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
-	int ret;
-
-	ret = copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id));
-	if (ret != 0)
-		return -EFAULT;
-
-	return kvm_arm_timer_set_reg(vcpu, reg->id, val);
-}
-
-static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
-{
-	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
-
-	val = kvm_arm_timer_get_reg(vcpu, reg->id);
-	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
-}
-
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
 	const unsigned int slices = vcpu_sve_slices(vcpu);
@@ -709,7 +666,6 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
-	res += NUM_TIMER_REGS;
 
 	return res;
 }
@@ -740,11 +696,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return ret;
 	uindices += kvm_arm_get_fw_num_regs(vcpu);
 
-	ret = copy_timer_indices(vcpu, uindices);
-	if (ret < 0)
-		return ret;
-	uindices += NUM_TIMER_REGS;
-
 	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
 }
 
@@ -762,9 +713,6 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
 	}
 
-	if (is_timer_reg(reg->id))
-		return get_timer_reg(vcpu, reg);
-
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
@@ -782,9 +730,6 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
 	}
 
-	if (is_timer_reg(reg->id))
-		return set_timer_reg(vcpu, reg);
-
 	return kvm_arm_sys_reg_set_reg(vcpu, reg);
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 5f7f2ed8817c5..7310841f45121 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -107,9 +107,6 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vm(struct kvm *kvm);
 
-u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
-int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
-
 int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
-- 
2.47.3


