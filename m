Return-Path: <kvm+bounces-20366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7807A914358
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33B1B284BA7
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC3555E49;
	Mon, 24 Jun 2024 07:14:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB1A3D969;
	Mon, 24 Jun 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213269; cv=none; b=g/ucjPn1ubJRKAEJ2o/wffvSxN0JxVo7x14duZk09WOxq45ayW9uE23PWeDJGOAEmizB7znzTWqn+qO/MK/NGsX81wLJTjKcSpwYNN9zUx79u/d04HhqvVY799teBCjySpnRIZzSTe36jPhky1eDcUdG8wiHsAAQPkHaH2iN+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213269; c=relaxed/simple;
	bh=mgO3Ffeu+JMPmyYW5o8I9ebUfnt0F2rVvC6Ya7pvejQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gjXTQziOq2Czkow6AQGyHJ2b78ZE7WFgWv+AHSJTzTITRWc3I08wMbGh0E7V1DV4l08B9DXtimOMXzHdj8Ia5RfPse7CV/w6e8cxBqUVAdfgaMkzMuwsQiBBBLV5/QeWVVuSnsBP5UeF+6iCkKEgPv4wRcABFJow3dxf2BUehz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cxe+rQHHlmB3EJAA--.38358S3;
	Mon, 24 Jun 2024 15:14:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S3;
	Mon, 24 Jun 2024 15:14:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 1/7] LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
Date: Mon, 24 Jun 2024 15:14:16 +0800
Message-Id: <20240624071422.3473789-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
References: <20240624071422.3473789-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With hardware assisted virtualization, there are two level HW mmu, one
is GVA to GPA mapping, the other is GPA to HPA mapping which is called
secondary mmu in generic. If there is page fault for secondary mmu,
there needs tlb flush operation indexed with fault gpa address and VMID.
VMID is stored at register CSR_GSTAT and will be reload or recalculated
before guest entry.

Currently CSR_GSTAT is not saved and restored during vcpu context
switch, it is recalculated during guest entry. So CSR_GSTAT is in
effect only when vcpu runs in guest mode, however it may be not in
effected if vcpu exits to host mode, since register CSR_GSTAT may
be stale, it maybe records VMID of last schedule-out vcpu, rather than
current vcpu.

Function kvm_flush_tlb_gpa() should be called with its real VMID,
here move it to guest entrance. Also arch specific request id
KVM_REQ_TLB_FLUSH_GPA is added to flush tlb for secondary mmu, and it can
be optimized if VMID is updated, since all guest tlb entries will be
invalid if VMID is updated.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/main.c             |  1 +
 arch/loongarch/kvm/mmu.c              |  4 ++--
 arch/loongarch/kvm/tlb.c              |  5 +----
 arch/loongarch/kvm/vcpu.c             | 18 ++++++++++++++++++
 5 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index c87b6ea0ec47..32c4948f534f 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #define KVM_PRIVATE_MEM_SLOTS		0
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
+#define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
 
 #define KVM_GUESTDBG_SW_BP_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
@@ -190,6 +191,7 @@ struct kvm_vcpu_arch {
 
 	/* vcpu's vpid */
 	u64 vpid;
+	gpa_t flush_gpa;
 
 	/* Frequency of stable timer in Hz */
 	u64 timer_mhz;
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 86a2f2d0cb27..844736b99d38 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -242,6 +242,7 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
 		kvm_update_vpid(vcpu, cpu);
 		trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
 		vcpu->cpu = cpu;
+		kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
 	}
 
 	/* Restore GSTAT(0x50).vpid */
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 98883aa23ab8..9e39d28fec35 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -908,8 +908,8 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		return ret;
 
 	/* Invalidate this entry in the TLB */
-	kvm_flush_tlb_gpa(vcpu, gpa);
-
+	vcpu->arch.flush_gpa = gpa;
+	kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
 	return 0;
 }
 
diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
index 02535df6b51f..ebdbe9264e9c 100644
--- a/arch/loongarch/kvm/tlb.c
+++ b/arch/loongarch/kvm/tlb.c
@@ -23,10 +23,7 @@ void kvm_flush_tlb_all(void)
 
 void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
+	lockdep_assert_irqs_disabled();
 	gpa &= (PAGE_MASK << 1);
 	invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
-	local_irq_restore(flags);
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 9e8030d45129..b747bd8bc037 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -51,6 +51,16 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
+		if (vcpu->arch.flush_gpa != INVALID_GPA) {
+			kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
+			vcpu->arch.flush_gpa = INVALID_GPA;
+		}
+}
+
 /*
  * Check and handle pending signal and vCPU requests etc
  * Run with irq enabled and preempt enabled
@@ -101,6 +111,13 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_check_vpid(vcpu);
+
+		/*
+		 * Called after function kvm_check_vpid()
+		 * Since it updates csr_gstat used by kvm_flush_tlb_gpa(),
+		 * also it may clear KVM_REQ_TLB_FLUSH_GPA pending bit
+		 */
+		kvm_late_check_requests(vcpu);
 		vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
 		/* Clear KVM_LARCH_SWCSR_LATEST as CSR will change when enter guest */
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
@@ -994,6 +1011,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct loongarch_csrs *csr;
 
 	vcpu->arch.vpid = 0;
+	vcpu->arch.flush_gpa = INVALID_GPA;
 
 	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
-- 
2.39.3


