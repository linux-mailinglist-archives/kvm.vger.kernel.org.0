Return-Path: <kvm+bounces-40718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C74A5B7B4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF113AFB4E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C691EFFBB;
	Tue, 11 Mar 2025 04:03:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B631EA7FF;
	Tue, 11 Mar 2025 04:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665824; cv=none; b=dhi2p4Yvdt2Pd/8sIPSCQIMjmS6r5qGYffb8Eg51zl8RigS0ciH4B3Ntsb8LEAjENPE5Dg6OcTv0S7TbjN+XeV5KbqqD98ETej+8xo77EQUpovMO77YnTgrVIWThPnF94gVsLEcp5iM/AkmDo/yCYk5hnt7opOJeAONhX7cOdXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665824; c=relaxed/simple;
	bh=W2fjiz10uTkl6epLzqjMqom8vKAEYUI9EDrH25MkceU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jzEpO2w8KpYWnm8Xs5x/cWX/fB02VNvUKvlIeVXbuOx4S+bW4DR3dOt/8JstwkTjJG80qPEyuDe4+r2RJMOgj1HMl5RqUfrGOBlru1uewHO5QrnZb/6z867rIFHX9YUmQLbGqgf4n/Bg8MKCSlVJ1lx0LdrwIQraGnSAfz7Gfks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZBg9N59TJz1cyWs;
	Tue, 11 Mar 2025 12:03:36 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BFB01800CD;
	Tue, 11 Mar 2025 12:03:39 +0800 (CST)
Received: from DESKTOP-KKJBAGG.huawei.com (10.174.178.32) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 12:03:38 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
To: <maz@kernel.org>, <yuzenghui@huawei.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <joey.gouly@arm.com>
CC: <linux-kernel@vger.kernel.org>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v1 4/5] arm64/kvm: support to handle the HDBSSF event
Date: Tue, 11 Mar 2025 12:03:20 +0800
Message-ID: <20250311040321.1460-5-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
In-Reply-To: <20250311040321.1460-1-yezhenyu2@huawei.com>
References: <20250311040321.1460-1-yezhenyu2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj500003.china.huawei.com (7.202.194.33)

From: eillon <yezhenyu2@huawei.com>

Updating the dirty bitmap based on the HDBSS buffer. Similar
to the implementation of the x86 pml feature, KVM flushes the
buffers on all VM-Exits, thus we only need to kick running
vCPUs to force a VM-Exit.

Signed-off-by: eillon <yezhenyu2@huawei.com>
---
 arch/arm64/kvm/arm.c         | 10 ++++++++
 arch/arm64/kvm/handle_exit.c | 47 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c         |  7 ++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 825cfef3b1c2..fceceeead011 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1845,7 +1845,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	/*
+	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
+	 * before reporting dirty_bitmap to userspace.  KVM flushes the buffers
+	 * on all VM-Exits, thus we only need to kick running vCPUs to force a
+	 * VM-Exit.
+	 */
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
 }
 
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 512d152233ff..db9d7e1f72bf 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -330,6 +330,50 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[esr_ec];
 }
 
+#define HDBSS_ENTRY_VALID_SHIFT 0
+#define HDBSS_ENTRY_VALID_MASK (1UL << HDBSS_ENTRY_VALID_SHIFT)
+#define HDBSS_ENTRY_IPA_SHIFT 12
+#define HDBSS_ENTRY_IPA_MASK GENMASK_ULL(55, HDBSS_ENTRY_IPA_SHIFT)
+
+static void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
+{
+	int idx, curr_idx;
+	u64 *hdbss_buf;
+
+	if (!vcpu->kvm->enable_hdbss)
+		return;
+
+	dsb(sy);
+	isb();
+	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
+
+	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
+	if (curr_idx == 0 || vcpu->arch.hdbss.br_el2 == 0)
+		return;
+
+	hdbss_buf = page_address(phys_to_page(HDBSSBR_BADDR(vcpu->arch.hdbss.br_el2)));
+	if (!hdbss_buf) {
+		kvm_err("Enter flush hdbss buffer with buffer == NULL!");
+		return;
+	}
+
+	for (idx = 0; idx < curr_idx; idx++) {
+		u64 gpa;
+
+		gpa = hdbss_buf[idx];
+		if (!(gpa & HDBSS_ENTRY_VALID_MASK))
+			continue;
+
+		gpa = gpa & HDBSS_ENTRY_IPA_MASK;
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+	}
+
+	/* reset HDBSS index */
+	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
+	dsb(sy);
+	isb();
+}
+
 /*
  * We may be single-stepping an emulated instruction. If the emulation
  * has been completed in the kernel, we can return to userspace with a
@@ -365,6 +409,9 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (vcpu->kvm->enable_hdbss)
+		kvm_flush_hdbss_buffer(vcpu);
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		/*
 		 * The SError is handled by handle_exit_early(). If the guest
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9c11e2292b1e..3e0781ae0ae1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1790,6 +1790,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
+	/*
+	 * HDBSS buffer already flushed when enter handle_trap_exceptions().
+	 * Nothing to do here.
+	 */
+	if (ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
+		return 1;
+
 	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
-- 
2.39.3


