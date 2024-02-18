Return-Path: <kvm+bounces-8982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D36085950A
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 07:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C23E9B21766
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 06:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2856AC0;
	Sun, 18 Feb 2024 06:33:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25DB538A;
	Sun, 18 Feb 2024 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708237994; cv=none; b=syz1ouq4yUJbJer5esP9wyDhbZnuRBtx0W8yAPGOP6jrcrDhNUg0b875HNxcWRirXDgNGrMMh3eg6yQ7hs/ZLvKrh2LKLZvuJEwKfkvLL5KbP5RnicYLIlLcphP7sCOfjWP6C2cf2teYidiNzv3uIzEeAxO7llQvaBBZypyVxcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708237994; c=relaxed/simple;
	bh=Ou67CknKNFvkJHA5VHdGs4weGL65WHqLtM05EXx8+gc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lPEJFNdLNJfjqa97Eorv0f/P4yx3C/Pd46enUazO4O1l+gUCY5fOERwXv+eyT35I5lCmnJIFxEWpM6UAdVrKVcVK0xh/3/614BsKMOA6CCMRMFApkypaVVi5wO6sg/h/hZaloF3+sL3o+1URGYoXGSD4PKQzMBxMBLNCGcrwhGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxSPCfpNFlNxIOAA--.38546S3;
	Sun, 18 Feb 2024 14:33:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c6epNFlyos6AA--.18718S2;
	Sun, 18 Feb 2024 14:33:02 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3] LoongArch: KVM: Add software breakpoint support
Date: Sun, 18 Feb 2024 14:33:02 +0800
Message-Id: <20240218063302.218019-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx_c6epNFlyos6AA--.18718S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gw43GF1fCw1rWr45tFW8AFc_yoWxuF1DpF
	9rArs5Gr4rKrZ3C340yr4Dur13Xa93Gr1Iqa42v3ySyF1Yq34rJrWkKr98AFy5Jw4rXa4I
	q3Z3Kw1YvFn8t3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-e5UUUUU==

When VM runs in kvm mode, system will not exit to host mode if
executing general software breakpoint instruction such as INSN_BREAK,
trap exception happens in guest mode rather than host mode. In order to
debug guest kernel on host side, one mechanism should be used to let vm
exit to host mode.

Here hypercall instruction with special code is used for software
breakpoint usage, vm exists to host mode and kvm hypervisor identifies the
special hypercall code and sets exit_reason with KVM_EXIT_DEBUG, and then
let qemu handle it.

Idea comes from ppc kvm, one api KVM_REG_LOONGARCH_DEBUG_INST is added to
get hypercall code. VMM needs get sw breakpoint instruction with this api
and set the corresponding sw break point for guest kernel.

Since it needs hypercall instruction emulation handling, and it is
dependent on this patchset:
https://lore.kernel.org/all/20240201031950.3225626-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
Changes in v3:
1. Add api KVM_REG_LOONGARCH_DEBUG_INST to get sw breakpoint instruction
for vmm.
2. Check vcpu::guest_debug with value KVM_GUESTDBG_USE_SW_BP only, since
another value KVM_GUESTDBG_ENABLE will be set if it is not zero.

Changes in v2:
1. Add checking for hypercall code KVM_HC_SWDBG, it is effective only if
KVM_GUESTDBG_USE_SW_BP and KVM_GUESTDBG_ENABLE is set.
---
 arch/loongarch/include/asm/inst.h     |  1 +
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/include/asm/kvm_para.h |  2 ++
 arch/loongarch/include/uapi/asm/kvm.h |  4 ++++
 arch/loongarch/kvm/exit.c             | 16 ++++++++++++++--
 arch/loongarch/kvm/vcpu.c             | 13 ++++++++++++-
 arch/loongarch/kvm/vm.c               |  1 +
 7 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
index ad120f924905..c3993fd88aba 100644
--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -12,6 +12,7 @@
 
 #define INSN_NOP		0x03400000
 #define INSN_BREAK		0x002a0000
+#define INSN_HVCL		0x002b8000
 
 #define ADDR_IMMMASK_LU52ID	0xFFF0000000000000
 #define ADDR_IMMMASK_LU32ID	0x000FFFFF00000000
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 1bf927e2bfac..ef4f1195d9fa 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -31,6 +31,8 @@
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 
+#define KVM_GUESTDBG_VALID_MASK		(KVM_GUESTDBG_ENABLE | \
+			KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index a25a84e372b9..c44412feabb3 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -10,8 +10,10 @@
 #define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
 
 #define KVM_HC_CODE_SERVICE		0
+#define KVM_HC_CODE_SWDBG		1
 #define KVM_HC_SERVICE			HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HC_CODE_SERVICE)
 #define  KVM_HC_FUNC_IPI		1
+#define KVM_HC_SWDBG			HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HC_CODE_SWDBG)
 
 /*
  * LoongArch hypcall return code
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 923d0bd38294..4cec8c16013c 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -15,10 +15,12 @@
  */
 
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_GUEST_DEBUG
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
@@ -74,6 +76,8 @@ struct kvm_fpu {
 
 #define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
 #define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+/* Debugging: Special instruction for software breakpoint */
+#define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 189b70bad825..2a79d40ea2b2 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -758,23 +758,35 @@ static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
 {
 	larch_inst inst;
 	unsigned int code;
+	int ret;
 
 	inst.word = vcpu->arch.badi;
 	code = inst.reg0i15_format.immediate;
-	update_pc(&vcpu->arch);
+	ret = RESUME_GUEST;
 
 	switch (code) {
 	case KVM_HC_SERVICE:
 		vcpu->stat.hvcl_exits++;
 		kvm_handle_pv_hcall(vcpu);
 		break;
+	case KVM_HC_SWDBG:
+		/* KVM_HC_SWDBG only in effective when SW_BP is enabled */
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
+			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
+			ret = RESUME_HOST;
+		} else
+			vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
+		break;
 	default:
 		/* Treat it as noop intruction, only set return value */
 		vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
 		break;
 	}
 
-	return RESUME_GUEST;
+	if (ret == RESUME_GUEST)
+		update_pc(&vcpu->arch);
+
+	return ret;
 }
 
 /*
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 80e05ba9b48d..273ac10eaba5 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -248,7 +248,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	return -EINVAL;
+	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
+		return -EINVAL;
+
+	if (dbg->control & KVM_GUESTDBG_ENABLE)
+		vcpu->guest_debug = dbg->control;
+	else
+		vcpu->guest_debug = 0;
+
+	return 0;
 }
 
 static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
@@ -482,6 +490,9 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
 		case KVM_REG_LOONGARCH_COUNTER:
 			*v = drdtime() + vcpu->kvm->arch.time_offset;
 			break;
+		case KVM_REG_LOONGARCH_DEBUG_INST:
+			*v = INSN_HVCL + KVM_HC_SWDBG;
+			break;
 		default:
 			ret = -EINVAL;
 			break;
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6fd5916ebef3..44fb18118442 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -77,6 +77,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_MP_STATE:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:

base-commit: 7e90b5c295ec1e47c8ad865429f046970c549a66
-- 
2.39.3


