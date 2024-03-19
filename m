Return-Path: <kvm+bounces-12071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6175387F61C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 04:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70014B220AC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C547BB15;
	Tue, 19 Mar 2024 03:38:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFEF7BB19;
	Tue, 19 Mar 2024 03:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710819508; cv=none; b=TEODua9VzhYbVzzBMS8Wo9m7PMfQJTadWzXZsMb5r8gCyQXLVfwHCo8iaEU93uOycxoK6SbBAImRJSt3C6WFo/kY7Qze9AI4xnGsz7Q9psdAV4t0F/BqcmnFzHoalru+FXRs/vMRLw6i0NL6ffBJRsDaFar2/d8GPgl5yn6ZYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710819508; c=relaxed/simple;
	bh=FmZRKU5BT9yF+Rad8osguGw2+X0zD5+e6MUcgnvLH4U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d6c/4SHcDgi0YF467WLLc5MmPB05WvaeGD2EHdP3Lauo+3JcvAQ5lEUniEJqaIultntIOyprmKL9iFPhFxh8XDp9+pdF4lu0+dGGGsSTrIEaqYwT2msWBZCLV9osJp3I6J1rBwQb8bfyXrft3xIhhn/AAw8Wx4onOgkoImru9g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxaOisCPllWZ0aAA--.44080S3;
	Tue, 19 Mar 2024 11:38:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxvhOrCPllRRNdAA--.58700S2;
	Tue, 19 Mar 2024 11:38:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v4] LoongArch: KVM: Add software breakpoint support
Date: Tue, 19 Mar 2024 11:38:19 +0800
Message-Id: <20240319033819.3017483-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxvhOrCPllRRNdAA--.58700S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

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
https://lore.kernel.org/all/20240315080710.2812974-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
v3 -- v4:
1. Rebase on the latest kernel, remove adding macro __KVM_HAVE_GUEST_DEBUG
in arch specific header files since it is put in common kvm header
files.
2. Rebase on pv ipi patch, rename KVM_HC_SWDBG with KVM_HCALL_SWDBG.

v2 -- v3:
1. Add api KVM_REG_LOONGARCH_DEBUG_INST to get sw breakpoint instruction
for vmm.
2. Check vcpu::guest_debug with value KVM_GUESTDBG_USE_SW_BP only, since
another value KVM_GUESTDBG_ENABLE will be set if it is not zero.

v1 -- v2:
1. Add checking for hypercall code KVM_HC_SWDBG, it is effective only if
KVM_GUESTDBG_USE_SW_BP and KVM_GUESTDBG_ENABLE is set.
---
 arch/loongarch/include/asm/inst.h     |  1 +
 arch/loongarch/include/asm/kvm_host.h |  4 ++++
 arch/loongarch/include/asm/kvm_para.h |  2 ++
 arch/loongarch/include/uapi/asm/kvm.h |  3 +++
 arch/loongarch/kvm/exit.c             | 16 ++++++++++++++--
 arch/loongarch/kvm/vcpu.c             | 13 ++++++++++++-
 arch/loongarch/kvm/vm.c               |  1 +
 7 files changed, 37 insertions(+), 3 deletions(-)

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
index 0b96c6303cf7..c53946f8ef9f 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -31,6 +31,10 @@
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 
+#define KVM_GUESTDBG_VALID_MASK		(KVM_GUESTDBG_ENABLE | \
+			KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
+#define KVM_GUESTDBG_SW_BP_MASK		(KVM_GUESTDBG_ENABLE | \
+			KVM_GUESTDBG_USE_SW_BP)
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index a5809a854bae..56775554402a 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -9,8 +9,10 @@
 #define HYPERVISOR_VENDOR_SHIFT		8
 #define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
 #define KVM_HCALL_CODE_PV_SERVICE	0
+#define KVM_HCALL_CODE_SWDBG		1
 #define KVM_HCALL_PV_SERVICE		HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_PV_SERVICE)
 #define  KVM_HCALL_FUNC_PV_IPI		1
+#define KVM_HCALL_SWDBG			HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
 
 /*
  * LoongArch hypercall return code
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 109785922cf9..8f78b23672ac 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -17,6 +17,7 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
@@ -72,6 +73,8 @@ struct kvm_fpu {
 
 #define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
 #define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+/* Debugging: Special instruction for software breakpoint */
+#define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 78857147bc14..d71172e2568e 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -774,23 +774,35 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 {
 	larch_inst inst;
 	unsigned int code;
+	int ret;
 
 	inst.word = vcpu->arch.badi;
 	code = inst.reg0i15_format.immediate;
-	update_pc(&vcpu->arch);
+	ret = RESUME_GUEST;
 
 	switch (code) {
 	case KVM_HCALL_PV_SERVICE:
 		vcpu->stat.hypercall_exits++;
 		kvm_handle_pv_service(vcpu);
 		break;
+	case KVM_HCALL_SWDBG:
+		/* KVM_HC_SWDBG only in effective when SW_BP is enabled */
+		if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
+			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
+			ret = RESUME_HOST;
+			break;
+		}
+		fallthrough;
 	default:
 		/* Treat it as noop intruction, only set return value */
 		kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
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
index 76f2086ab68b..f22d10228cd2 100644
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
@@ -500,6 +508,9 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
 		case KVM_REG_LOONGARCH_COUNTER:
 			*v = drdtime() + vcpu->kvm->arch.time_offset;
 			break;
+		case KVM_REG_LOONGARCH_DEBUG_INST:
+			*v = INSN_HVCL + KVM_HCALL_SWDBG;
+			break;
 		default:
 			ret = -EINVAL;
 			break;
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6006a28653ad..06fd746b03b6 100644
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

base-commit: 0a7b0acecea273c8816f4f5b0e189989470404cf
-- 
2.39.3


