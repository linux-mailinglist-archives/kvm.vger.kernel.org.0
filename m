Return-Path: <kvm+bounces-16979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C37558BF6E5
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 09:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F32D51C227F4
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 07:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4585328383;
	Wed,  8 May 2024 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oJWVbB2j"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3427737
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 07:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715152811; cv=none; b=AzGspfZGQOm1RiHEAn53ZJxKn1D/7jdjWW5HqJC3EkmT+5ei77MO4bEjdzveuZUeIC2eJvYhAdeUmzRioBf/h0f4QhTeseDp52N2GzGbq1Wt//jXrUReO/894Y1CYJ7lkqcL+nZz4jXIAaVPPlmYMFteHbty4IBTonni3klYhPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715152811; c=relaxed/simple;
	bh=SVynrX49HHwV5UFx7t9hP6iHl1bqeFLNhHVpTEYJ9Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T9M8A5s3yo/iWGaJnRDbtDQ3SD40wWGH5mWIHrpP+TZGyEcplhPyyI4kEvMBQKvBvs2/F7F+5TLiX06eXF1FKlIGpVs/jwS3grHuZkZVySQAxr2R6vXkOHGQQIcIJNB0faoK9Y84AGUoyyNY5EGWhHCC4oMEea7+8SvVi9fSbcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oJWVbB2j; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715152806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZVEvH24OKzSwtjMxF4Wxw/MKR5iMHFWlNjdr5PwFkAE=;
	b=oJWVbB2jHPis5P90EDd+PeBfuIxBGbpyUl5lFCnr6ytKaI9XV8cLbbK0WH8+vW6mJXufWs
	0G9Cx8TkcE8v1LBmdJESThkkCgqjBWJpir6deOiJTOlgIvLrtbsQoA7MRV0otkfraRvGSX
	WCegsW1WvJCFookyJfxx45xo9uKScP4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2] KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
Date: Wed,  8 May 2024 07:19:52 +0000
Message-ID: <20240508071952.2035422-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A particularly annoying userspace could create a vCPU after KVM has
computed mpidr_data for the VM, either by racing against VGIC
initialization or having a userspace irqchip.

In any case, this means mpidr_data no longer fully describes the VM, and
attempts to find the new vCPU with kvm_mpidr_to_vcpu() will fail. The
fix is to discard mpidr_data altogether, as it is only a performance
optimization and not required for correctness. In all likelihood KVM
will recompute the mappings when KVM_RUN is called on the new vCPU.

Note that reads of mpidr_data are not guarded by a lock; promote to RCU
to cope with the possibility of mpidr_data being invalidated at runtime.

Fixes: 54a8006d0b49 ("KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

v1 ->v2:
 - Use rcu_dereference_protected() while behind config_lock [Marc]

 arch/arm64/kvm/arm.c | 50 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35e02c7..6cda738a4157 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -195,6 +195,23 @@ void kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	kvm_sys_regs_create_debugfs(kvm);
 }
 
+static void kvm_destroy_mpidr_data(struct kvm *kvm)
+{
+	struct kvm_mpidr_data *data;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	data = rcu_dereference_protected(kvm->arch.mpidr_data,
+					 lockdep_is_held(&kvm->arch.config_lock));
+	if (data) {
+		rcu_assign_pointer(kvm->arch.mpidr_data, NULL);
+		synchronize_rcu();
+		kfree(data);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 /**
  * kvm_arch_destroy_vm - destroy the VM data structure
  * @kvm:	pointer to the KVM struct
@@ -209,7 +226,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (is_protected_kvm_enabled())
 		pkvm_destroy_hyp_vm(kvm);
 
-	kfree(kvm->arch.mpidr_data);
+	kvm_destroy_mpidr_data(kvm);
+
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
@@ -395,6 +413,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
+	/*
+	 * This vCPU may have been created after mpidr_data was initialized.
+	 * Throw out the pre-computed mappings if that is the case which forces
+	 * KVM to fall back to iteratively searching the vCPUs.
+	 */
+	kvm_destroy_mpidr_data(vcpu->kvm);
+
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
 		return err;
@@ -594,7 +619,8 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 
 	mutex_lock(&kvm->arch.config_lock);
 
-	if (kvm->arch.mpidr_data || atomic_read(&kvm->online_vcpus) == 1)
+	if (rcu_access_pointer(kvm->arch.mpidr_data) ||
+	    atomic_read(&kvm->online_vcpus) == 1)
 		goto out;
 
 	kvm_for_each_vcpu(c, vcpu, kvm) {
@@ -631,7 +657,7 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 		data->cmpidr_to_idx[index] = c;
 	}
 
-	kvm->arch.mpidr_data = data;
+	rcu_assign_pointer(kvm->arch.mpidr_data, data);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 }
@@ -2470,21 +2496,27 @@ static int __init init_hyp_mode(void)
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = NULL;
+	struct kvm_mpidr_data *data;
 	unsigned long i;
 
 	mpidr &= MPIDR_HWID_BITMASK;
 
-	if (kvm->arch.mpidr_data) {
-		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
+	rcu_read_lock();
+	data = rcu_dereference(kvm->arch.mpidr_data);
 
-		vcpu = kvm_get_vcpu(kvm,
-				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+	if (data) {
+		u16 idx = kvm_mpidr_index(data, mpidr);
+
+		vcpu = kvm_get_vcpu(kvm, data->cmpidr_to_idx[idx]);
 		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
 			vcpu = NULL;
+	}
 
+	rcu_read_unlock();
+
+	if (vcpu)
 		return vcpu;
-	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))

base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


