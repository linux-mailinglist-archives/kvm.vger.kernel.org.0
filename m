Return-Path: <kvm+bounces-42978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B9B0A81AA1
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 03:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE4C6464390
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 01:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296FB1ADC93;
	Wed,  9 Apr 2025 01:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/2misdF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968918A92D
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 01:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162937; cv=none; b=ZMzZrT/oT55QhZfKs2UeNkaWnvd9JiM+ncG80XwDjygpu6dnjXGUZXDX4sRIqOv0smk7CO9QGNaVyNA2AMFiegm3Rz4uyi7yxzgKdaC0P5/VNfxUiy3Gr6fhkoMyNr9SCviVUB0zUDCuKlwuati82o+dEsMbP31du5eXWjVBdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162937; c=relaxed/simple;
	bh=kWMoAZ/6MoptLjZVnborOmzeog9qJPTlM+Akp+Z5jBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FUp2F4lvqWE+F0ALEw8u6HMpUAJyXB8PBZAXvxt3652UilC/Drjhab/+5ifBu3gRdoyltRhoqc9H7qRV+3OkCmIxADhW7TZenE3fXjl3uqQGIIb+po3d8G8tNW7FuCOutTzhfqluTH3U0xS4m1JVUlRLKPg21ap3rOjaQ5Q0u44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/2misdF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744162933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdWJa1iWuf75Z3WwaZMFwx3loSaLxfrrFv/72IaVBE4=;
	b=Y/2misdFToaxW0L2Lvuf59DndIcE6X2QXLbSdFtUdOO7tXBVN/HVZW62NJrdeQhk7ZlvZz
	5Kd5ctUo0UUZqbHRLZwc9EfZ1+drT8HyITI3ypPS2KuO/CyFlS1UsFy2ni7vrxOvc9aE7o
	qo4LgU+W0jNBOdiiWkK1EeKSFK/kkvo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-25-SCjKqFNoPX2Alb788oTNSg-1; Tue,
 08 Apr 2025 21:42:08 -0400
X-MC-Unique: SCjKqFNoPX2Alb788oTNSg-1
X-Mimecast-MFC-AGG-ID: SCjKqFNoPX2Alb788oTNSg_1744162925
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A72A0180035E;
	Wed,  9 Apr 2025 01:42:04 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB6BC180174E;
	Wed,  9 Apr 2025 01:41:58 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>,
	x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
Date: Tue,  8 Apr 2025 21:41:35 -0400
Message-Id: <20250409014136.2816971-4-mlevitsk@redhat.com>
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h     |  3 --
 arch/arm64/kvm/arch_timer.c           |  4 +--
 arch/arm64/kvm/arm.c                  | 43 ---------------------------
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +--
 arch/arm64/kvm/vgic/vgic-its.c        |  8 ++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++++----
 6 files changed, 14 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..96ce0b01a61e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1263,9 +1263,6 @@ int __init populate_sysreg_config(const struct sys_reg_desc *sr,
 				  unsigned int idx);
 int __init populate_nv_trap_config(void);
 
-bool lock_all_vcpus(struct kvm *kvm);
-void unlock_all_vcpus(struct kvm *kvm);
-
 void kvm_calculate_traps(struct kvm_vcpu *vcpu);
 
 /* MMIO helpers */
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 5133dcbfe9f7..1c71ce9a5e73 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1766,7 +1766,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 
-	if (lock_all_vcpus(kvm)) {
+	if (!kvm_lock_all_vcpus(kvm, true)) {
 		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
 
 		/*
@@ -1778,7 +1778,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 		kvm->arch.timer_data.voffset = offset->counter_offset;
 		kvm->arch.timer_data.poffset = offset->counter_offset;
 
-		unlock_all_vcpus(kvm);
+		kvm_unlock_all_vcpus(kvm);
 	} else {
 		ret = -EBUSY;
 	}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95fee..d31f42a71bdc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1914,49 +1914,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	}
 }
 
-/* unlocks vcpus from @vcpu_lock_idx and smaller */
-static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
-{
-	struct kvm_vcpu *tmp_vcpu;
-
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
-	}
-}
-
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
index 1f33e71c2a73..8241a57e3f96 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -88,7 +88,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	lockdep_assert_held(&kvm->lock);
 
 	ret = -EBUSY;
-	if (!lock_all_vcpus(kvm))
+	if (kvm_lock_all_vcpus(kvm, true))
 		return ret;
 
 	mutex_lock(&kvm->arch.config_lock);
@@ -142,7 +142,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb96802799c6..a06d554cb8a2 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1999,7 +1999,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (kvm_lock_all_vcpus(dev->kvm, true)) {
 		mutex_unlock(&dev->kvm->lock);
 		return -EBUSY;
 	}
@@ -2034,7 +2034,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	}
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
 }
@@ -2704,7 +2704,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 
 	mutex_lock(&kvm->lock);
 
-	if (!lock_all_vcpus(kvm)) {
+	if (kvm_lock_all_vcpus(kvm, true)) {
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
 	}
@@ -2726,7 +2726,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->arch.config_lock);
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	mutex_unlock(&kvm->lock);
 	return ret;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 359094f68c23..232838891464 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -268,7 +268,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 				return -ENXIO;
 			mutex_lock(&dev->kvm->lock);
 
-			if (!lock_all_vcpus(dev->kvm)) {
+			if (kvm_lock_all_vcpus(dev->kvm, true)) {
 				mutex_unlock(&dev->kvm->lock);
 				return -EBUSY;
 			}
@@ -276,7 +276,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_v3_save_pending_tables(dev->kvm);
 			mutex_unlock(&dev->kvm->arch.config_lock);
-			unlock_all_vcpus(dev->kvm);
+			kvm_unlock_all_vcpus(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
 		}
@@ -390,7 +390,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (kvm_lock_all_vcpus(dev->kvm, true)) {
 		mutex_unlock(&dev->kvm->lock);
 		return -EBUSY;
 	}
@@ -415,7 +415,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && !is_write)
@@ -554,7 +554,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (kvm_lock_all_vcpus(dev->kvm, true)) {
 		mutex_unlock(&dev->kvm->lock);
 		return -EBUSY;
 	}
@@ -611,7 +611,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && uaccess && !is_write) {
-- 
2.26.3


