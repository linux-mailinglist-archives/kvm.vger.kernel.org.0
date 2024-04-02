Return-Path: <kvm+bounces-13339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F89B894B6B
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0839B20C72
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AD3224D8;
	Tue,  2 Apr 2024 06:31:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.231.56.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C313522097
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=20.231.56.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039463; cv=none; b=G08riQKkTlrcfrwgjouUFiFd3p7CWv7kUgZ4TThOuc70zRb0HidQOZ1f6I9qjBVlt/vmrFNyXQDdjhiFj7ov+0a27Wuphm+i7xfxgFnuadAOCJbeZJoSCPf4fDKBtjOYOlyk/f12feXAxdO+VBlz+JB3ggcHBUcc9lCcQn3Zy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039463; c=relaxed/simple;
	bh=cjZNPkPJkCrQyMwTfTwsMi7L72pwVK9l3n9+xXGX9Wc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=Pbgr4xZX84+1x6Cpl6/aUULx+jN9G6cVoitC2yaBFcv8EPddnmHyKakmoV6x4N+HZ/DbOXC/4DUd/5Q2OV14UlA16RjbEVlsuYG3pwGmuaQctpWqAKn/rvF9RG3esOaFQl6TXkpabEfKF47a/sWglHBomTnkUYIc8HRy6BOrqW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=20.231.56.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app2 (Coremail) with SMTP id TQJkCgBHWry1pQtm5G0EAA--.36929S5;
	Tue, 02 Apr 2024 14:29:13 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	dbarboza@ventanamicro.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	haibo1.xu@intel.com,
	duchao713@qq.com
Subject: [PATCH v4 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
Date: Tue,  2 Apr 2024 06:26:26 +0000
Message-Id: <20240402062628.5425-2-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240402062628.5425-1-duchao@eswincomputing.com>
References: <20240402062628.5425-1-duchao@eswincomputing.com>
X-CM-TRANSID:TQJkCgBHWry1pQtm5G0EAA--.36929S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW8CF1xZw1fuFWktF4fKrg_yoWrtF4rpa
	9xC3s093yrKr1xK3WxAFZ5urW3WrZ5KwnIgrW2vFyYyr4YkryFvanYgrZrJFyUXrWrWrWI
	kFy5CFyruFn0qwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2
	xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0ep
	B3UUUUU==
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG is
been checked.

kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
from userspace accordingly. Route the breakpoint exceptions to HS mode
if the VCPU is being debugged by userspace, by clearing the
corresponding bit in hedeleg.

Initialize the hedeleg configuration in kvm_riscv_vcpu_setup_config().
Write the actual CSR in kvm_arch_vcpu_load().

Signed-off-by: Chao Du <duchao@eswincomputing.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/include/asm/kvm_host.h | 12 ++++++++++++
 arch/riscv/kvm/main.c             | 18 ++----------------
 arch/riscv/kvm/vcpu.c             | 16 ++++++++++++++--
 arch/riscv/kvm/vm.c               |  1 +
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..da4ab7e175ff 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -43,6 +43,17 @@
 	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)

+#define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
+					 BIT(EXC_BREAKPOINT)      | \
+					 BIT(EXC_SYSCALL)         | \
+					 BIT(EXC_INST_PAGE_FAULT) | \
+					 BIT(EXC_LOAD_PAGE_FAULT) | \
+					 BIT(EXC_STORE_PAGE_FAULT))
+
+#define KVM_HIDELEG_DEFAULT		(BIT(IRQ_VS_SOFT)  | \
+					 BIT(IRQ_VS_TIMER) | \
+					 BIT(IRQ_VS_EXT))
+
 enum kvm_riscv_hfence_type {
 	KVM_RISCV_HFENCE_UNKNOWN = 0,
 	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
@@ -169,6 +180,7 @@ struct kvm_vcpu_csr {
 struct kvm_vcpu_config {
 	u64 henvcfg;
 	u64 hstateen0;
+	unsigned long hedeleg;
 };

 struct kvm_vcpu_smstateen_csr {
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 225a435d9c9a..bab2ec34cd87 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *filp,

 int kvm_arch_hardware_enable(void)
 {
-	unsigned long hideleg, hedeleg;
-
-	hedeleg = 0;
-	hedeleg |= (1UL << EXC_INST_MISALIGNED);
-	hedeleg |= (1UL << EXC_BREAKPOINT);
-	hedeleg |= (1UL << EXC_SYSCALL);
-	hedeleg |= (1UL << EXC_INST_PAGE_FAULT);
-	hedeleg |= (1UL << EXC_LOAD_PAGE_FAULT);
-	hedeleg |= (1UL << EXC_STORE_PAGE_FAULT);
-	csr_write(CSR_HEDELEG, hedeleg);
-
-	hideleg = 0;
-	hideleg |= (1UL << IRQ_VS_SOFT);
-	hideleg |= (1UL << IRQ_VS_TIMER);
-	hideleg |= (1UL << IRQ_VS_EXT);
-	csr_write(CSR_HIDELEG, hideleg);
+	csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
+	csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);

 	/* VS should access only the time counter directly. Everything else should trap */
 	csr_write(CSR_HCOUNTEREN, 0x02);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..f3c87f0c93ba 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	/* TODO; To be implemented later. */
-	return -EINVAL;
+	if (dbg->control & KVM_GUESTDBG_ENABLE) {
+		vcpu->guest_debug = dbg->control;
+		vcpu->arch.cfg.hedeleg &= ~BIT(EXC_BREAKPOINT);
+	} else {
+		vcpu->guest_debug = 0;
+		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
+	}
+
+	return 0;
 }

 static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
@@ -505,6 +512,10 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 		if (riscv_isa_extension_available(isa, SMSTATEEN))
 			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
 	}
+
+	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
+	if (vcpu->guest_debug)
+		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);
 }

 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -519,6 +530,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	csr_write(CSR_VSEPC, csr->vsepc);
 	csr_write(CSR_VSCAUSE, csr->vscause);
 	csr_write(CSR_VSTVAL, csr->vstval);
+	csr_write(CSR_HEDELEG, cfg->hedeleg);
 	csr_write(CSR_HVIP, csr->hvip);
 	csr_write(CSR_VSATP, csr->vsatp);
 	csr_write(CSR_HENVCFG, cfg->henvcfg);
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index ce58bc48e5b8..7396b8654f45 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
--
2.17.1


