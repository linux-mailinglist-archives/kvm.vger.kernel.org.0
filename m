Return-Path: <kvm+bounces-44990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C25AA5583
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 019CA1BC3D28
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580422C1E32;
	Wed, 30 Apr 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NH1SsQUc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66362BE11B
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746045047; cv=none; b=rLWh8BA+w5rUhLlKqeo4ZZPlDcM7aoPf2FazpflV+Qla4HzubukegRKDbsBU2qgD+fwzjImyFH/zBachDPGPwv7q4acoNydoEVKOeiEcT/NohpXaRIkkZoT5oFdSOtpE8fw9xS11a8HFOcJYdZwtlJ0f5AX19MzxvPOpdTZ3afE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746045047; c=relaxed/simple;
	bh=8LOVouw/uXiAyDHqo28yXBTFK41O/HPRr3Q48Y2c4NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Krd1FfWpjxLK6rYYheLcTEoVGHvBOBZaYjIRokQwLcIgCLJGkLuc1TpS45S5fDXuwLWx8QOnWt/+4xxP7lX+ASC95JMoLpNWAIDxtrs7uxI10QrMQcTlwaZcLZ8qFiLNQnBpnoM+yVF1O4em+/dEwinEyzq9YcKy+ECG74T/i1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NH1SsQUc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746045044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSDMr6CrswXgqByQYff1QxuCHlV9bXTUySTX4ETsg9o=;
	b=NH1SsQUc2EVhs7oHWIJhMNlvm2qFdiZc3SEHSN/BwZIGjchcyA2GorxkCusCe+1ZbyOJLU
	a/WeDgZZAo0COAhv/tsrDRQ+dV3dXeZKOFvawsqjtyV4cKbwAk6aiqUjM0I3SkVN53WdEq
	fReewhPP9uXqSjnn6owL+aEfDF+SU48=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-JeYiPc9bMbmPGcw60FO2yQ-1; Wed,
 30 Apr 2025 16:30:41 -0400
X-MC-Unique: JeYiPc9bMbmPGcw60FO2yQ-1
X-Mimecast-MFC-AGG-ID: JeYiPc9bMbmPGcw60FO2yQ_1746045036
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C6F31801A16;
	Wed, 30 Apr 2025 20:30:35 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C7F71800879;
	Wed, 30 Apr 2025 20:30:29 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>,
	x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
Date: Wed, 30 Apr 2025 16:30:10 -0400
Message-ID: <20250430203013.366479-3-mlevitsk@redhat.com>
In-Reply-To: <20250430203013.366479-1-mlevitsk@redhat.com>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Use mutex_trylock_nest_lock instead of mutex_trylock when locking all vCPUs
of a VM, to avoid triggering a lockdep warning, if the VM is configured to
have more than MAX_LOCK_DEPTH vCPUs.

This fixes the following false lockdep warning:

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

Since the locking of all vCPUs is a primitive that can be useful in other
architectures that are supported by KVM, also move the code to kvm_main.c

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h     |  3 --
 arch/arm64/kvm/arch_timer.c           |  4 +--
 arch/arm64/kvm/arm.c                  | 43 ---------------------------
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +--
 arch/arm64/kvm/vgic/vgic-its.c        |  8 ++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++++----
 include/linux/kvm_host.h              |  3 ++
 virt/kvm/kvm_main.c                   | 34 +++++++++++++++++++++
 8 files changed, 51 insertions(+), 60 deletions(-)

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
index 5133dcbfe9f7..fdbc8beec930 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1766,7 +1766,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 
-	if (lock_all_vcpus(kvm)) {
+	if (!kvm_trylock_all_vcpus(kvm)) {
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
index 1f33e71c2a73..6a426d403a6b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -88,7 +88,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	lockdep_assert_held(&kvm->lock);
 
 	ret = -EBUSY;
-	if (!lock_all_vcpus(kvm))
+	if (kvm_trylock_all_vcpus(kvm))
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
index fb96802799c6..7454388e3646 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1999,7 +1999,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
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
+	if (kvm_trylock_all_vcpus(kvm)) {
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
index 359094f68c23..f9ae790163fb 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -268,7 +268,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 				return -ENXIO;
 			mutex_lock(&dev->kvm->lock);
 
-			if (!lock_all_vcpus(dev->kvm)) {
+			if (kvm_trylock_all_vcpus(dev->kvm)) {
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
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
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
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1dedc421b3e3..10d6652c7aa0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1015,6 +1015,9 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 
 void kvm_destroy_vcpus(struct kvm *kvm);
 
+int kvm_trylock_all_vcpus(struct kvm *kvm);
+void kvm_unlock_all_vcpus(struct kvm *kvm);
+
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..834f08dfa24c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1368,6 +1368,40 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * Try to lock all of the VM's vCPUs.
+ * Assumes that the kvm->lock is held.
+ */
+int kvm_trylock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i, j;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
+			goto out_unlock;
+	return 0;
+
+out_unlock:
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		if (i == j)
+			break;
+		mutex_unlock(&vcpu->mutex);
+	}
+	return -EINTR;
+}
+EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
+
+void kvm_unlock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		mutex_unlock(&vcpu->mutex);
+}
+EXPORT_SYMBOL_GPL(kvm_unlock_all_vcpus);
+
 /*
  * Allocation size is twice as large as the actual dirty bitmap size.
  * See kvm_vm_ioctl_get_dirty_log() why this is needed.
-- 
2.46.0


