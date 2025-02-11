Return-Path: <kvm+bounces-37766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78283A2FEDD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 01:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84E9166C57
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 00:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C1029CE6;
	Tue, 11 Feb 2025 00:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHZt7xKw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F753D69
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 00:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739232589; cv=none; b=VdWnh04f4Fh0SEay0Yr5QSZu3gOyPavnrBLVwh/nBvCbwEdXj/NP8FTsRr3D/8/qLRam6tLg58JA66zgceAR/RoVjiaG5dfb+/g6Gu+lCCXiWx7haTEuI+b/4Xq2Yy5Xx35rgCk0De+sViYlDwuxHhKoUTMOhSiQ3B2699vo6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739232589; c=relaxed/simple;
	bh=KJomRqJkCpKLjIGWzlYvjYswbKH5iJCSmGxFmTkH6Zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K+GF3BxhhehbSRbDBbrsZ7AOUnU0Euts/tHV8jn1XWSWpZ978axDVbOzv1OJ2NAj3dcntUvyugTjY9vLo2Mpl61I9BTDzliaBi693jODKcTt+mxYM7FAQX+BIrwdDBO9XrRrcBQ3pQZx1ViQUIBYFnLIlMV9MhnRyvTLM3yo7uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHZt7xKw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739232586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7d2yvMM2I9d/oyc1V0faCkOl8VeyuNqArkVlFzxUCDE=;
	b=gHZt7xKwY/eGZmjL5b/6QhxnJh5sbKeHaEFKLXNONL9JKhCmxeagvPxbfTAVqkambx2+AZ
	rqL2EYyY7W3gXW3OE0wvd7xAkCCmRY6TrAKhAFBJZj5ICmv4XO5dFJzp3XJa7Ys0Jc2flE
	zCNGPX7XuqdMXEG5AMlVfi/aiQePmFo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-9uH7qvCwOL6Q2OM-ph_X4g-1; Mon,
 10 Feb 2025 19:09:42 -0500
X-MC-Unique: 9uH7qvCwOL6Q2OM-ph_X4g-1
X-Mimecast-MFC-AGG-ID: 9uH7qvCwOL6Q2OM-ph_X4g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3B081800874;
	Tue, 11 Feb 2025 00:09:38 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.174])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1BF519560B0;
	Tue, 11 Feb 2025 00:09:32 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-riscv@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
Date: Mon, 10 Feb 2025 19:09:16 -0500
Message-Id: <20250211000917.166856-3-mlevitsk@redhat.com>
In-Reply-To: <20250211000917.166856-1-mlevitsk@redhat.com>
References: <20250211000917.166856-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Switch to kvm_lock/unlock_all_vcpus instead of arm's own
version.

This fixes lockdep warning about reaching maximum lock depth:

[  328.171264] BUG: MAX_LOCK_DEPTH too low!
[  328.175227] turning off the locking correctness validator.
[  328.180726] Please attach the output of /proc/lock_stat to the bug report
[  328.187531] depth: 48  max: 48!
[  328.190678] 48 locks held by qemu-kvm/11664:
[  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
[  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h     |  3 ---
 arch/arm64/kvm/arch_timer.c           |  8 +++----
 arch/arm64/kvm/arm.c                  | 32 ---------------------------
 arch/arm64/kvm/vgic/vgic-init.c       | 11 +++++----
 arch/arm64/kvm/vgic/vgic-its.c        | 18 ++++++++-------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 21 ++++++++++--------
 6 files changed, 33 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..bba97ea700ca 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1234,9 +1234,6 @@ int __init populate_sysreg_config(const struct sys_reg_desc *sr,
 				  unsigned int idx);
 int __init populate_nv_trap_config(void);
 
-bool lock_all_vcpus(struct kvm *kvm);
-void unlock_all_vcpus(struct kvm *kvm);
-
 void kvm_calculate_traps(struct kvm_vcpu *vcpu);
 
 /* MMIO helpers */
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 231c0cd9c7b4..3af1da807f9c 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1769,7 +1769,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 
-	if (lock_all_vcpus(kvm)) {
+	ret = kvm_lock_all_vcpus(kvm);
+
+	if (!ret) {
 		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
 
 		/*
@@ -1781,9 +1783,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 		kvm->arch.timer_data.voffset = offset->counter_offset;
 		kvm->arch.timer_data.poffset = offset->counter_offset;
 
-		unlock_all_vcpus(kvm);
-	} else {
-		ret = -EBUSY;
+		kvm_unlock_all_vcpus(kvm);
 	}
 
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 071a7d75be68..f58849c5b4f0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1895,38 +1895,6 @@ static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
 	}
 }
 
-void unlock_all_vcpus(struct kvm *kvm)
-{
-	lockdep_assert_held(&kvm->lock);
-
-	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
-}
-
-/* Returns true if all vcpus were locked, false otherwise */
-bool lock_all_vcpus(struct kvm *kvm)
-{
-	struct kvm_vcpu *tmp_vcpu;
-	unsigned long c;
-
-	lockdep_assert_held(&kvm->lock);
-
-	/*
-	 * Any time a vcpu is in an ioctl (including running), the
-	 * core KVM code tries to grab the vcpu->mutex.
-	 *
-	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
-	 * other VCPUs can fiddle with the state while we access it.
-	 */
-	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
-			unlock_vcpus(kvm, c - 1);
-			return false;
-		}
-	}
-
-	return true;
-}
-
 static unsigned long nvhe_percpu_size(void)
 {
 	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index bc7e22ab5d81..8fbce4db5c2e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -85,8 +85,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	/* Must be held to avoid race with vCPU creation */
 	lockdep_assert_held(&kvm->lock);
 
-	ret = -EBUSY;
-	if (!lock_all_vcpus(kvm))
+	ret = kvm_lock_all_vcpus(kvm);
+	if (ret)
 		return ret;
 
 	mutex_lock(&kvm->arch.config_lock);
@@ -97,9 +97,12 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_has_run_once(vcpu))
+		if (vcpu_has_run_once(vcpu)) {
+			ret = -EBUSY;
 			goto out_unlock;
+		}
 	}
+
 	ret = 0;
 
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
@@ -124,7 +127,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb96802799c6..02b02b4fff5d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1977,7 +1977,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	struct vgic_its *its;
 	gpa_t addr, offset;
 	unsigned int len;
-	int align, ret = 0;
+	int align, ret;
 
 	its = dev->private;
 	offset = attr->attr;
@@ -1999,9 +1999,10 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	ret = kvm_lock_all_vcpus(sdev->kvm);
+	if (ret) {
 		mutex_unlock(&dev->kvm->lock);
-		return -EBUSY;
+		return ret;
 	}
 
 	mutex_lock(&dev->kvm->arch.config_lock);
@@ -2034,7 +2035,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	}
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
 }
@@ -2697,16 +2698,17 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	int ret = 0;
+	int ret;
 
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
 		return 0;
 
 	mutex_lock(&kvm->lock);
 
-	if (!lock_all_vcpus(kvm)) {
+	ret = kvm_lock_all_vcpus(kvm);
+	if (ret) {
 		mutex_unlock(&kvm->lock);
-		return -EBUSY;
+		return ret;
 	}
 
 	mutex_lock(&kvm->arch.config_lock);
@@ -2726,7 +2728,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->arch.config_lock);
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	mutex_unlock(&kvm->lock);
 	return ret;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 5f4f57aaa23e..ee70a9d642ed 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -268,15 +268,16 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 				return -ENXIO;
 			mutex_lock(&dev->kvm->lock);
 
-			if (!lock_all_vcpus(dev->kvm)) {
+			r = kvm_lock_all_vcpus(dev->kvm);
+			if (r) {
 				mutex_unlock(&dev->kvm->lock);
-				return -EBUSY;
+				return r;
 			}
 
 			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_v3_save_pending_tables(dev->kvm);
 			mutex_unlock(&dev->kvm->arch.config_lock);
-			unlock_all_vcpus(dev->kvm);
+			kvm_unlock_all_vcpus(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
 		}
@@ -384,9 +385,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	ret = kvm_lock_all_vcpus(dev->kvm);
+	if (ret) {
 		mutex_unlock(&dev->kvm->lock);
-		return -EBUSY;
+		return ret;
 	}
 
 	mutex_lock(&dev->kvm->arch.config_lock);
@@ -409,7 +411,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && !is_write)
@@ -545,9 +547,10 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	ret = kvm_lock_all_vcpus(dev->kvm);
+	if (ret) {
 		mutex_unlock(&dev->kvm->lock);
-		return -EBUSY;
+		return ret;
 	}
 
 	mutex_lock(&dev->kvm->arch.config_lock);
@@ -589,7 +592,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && uaccess && !is_write) {
-- 
2.26.3


