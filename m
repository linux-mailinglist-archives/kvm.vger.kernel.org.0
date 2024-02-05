Return-Path: <kvm+bounces-7972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EF58494D6
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CE2BB224C0
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375AF11184;
	Mon,  5 Feb 2024 07:50:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE9F10A11;
	Mon,  5 Feb 2024 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707119410; cv=none; b=LwtfA8mYpWYWxP7q1sknVg4YhdbD6RsiEPnwJCNV/1QmDJCdMncYUwF0F5qjkzAKWfcnFlPpzXtlNe4OSvdspSJ00hszlK9vuih7PxsdK/EBJ5rXbwLHw39/m4O1xy7WgZlJt2pb08ttQjE+PHLRCowGaURTIwIEy6HH3c79pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707119410; c=relaxed/simple;
	bh=s/DcuOGFR/+eSImApTA3KtjZxPydZqpVORSw3JubMF8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FYepYskYK8MYr88rGMDkP7ryaZf/XCjhJWGRQkScdnz9BCp+TWz7BmDNbFrvQOx8mHxq8cm6MwSSwRVUrpUr6cVGIDPrQxB1H6C93DvcdsihkOiEfThncjSr2h6ZUip+x/XrbyolUVScSXB0G1nYuzeX/1KZuf4+UFbfDUTEt+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx3+suk8Blic8KAA--.30263S3;
	Mon, 05 Feb 2024 15:50:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhMrk8BlsfwvAA--.59749S2;
	Mon, 05 Feb 2024 15:50:03 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add software breakpoint support
Date: Mon,  5 Feb 2024 15:50:03 +0800
Message-Id: <20240205075003.3970281-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhMrk8BlsfwvAA--.59749S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGw13uw1DJw48KryfWryxXrc_yoWrZw1UpF
	9rArn5Kr4rKrZ3C34xtws8ur43ta93Kr1Iqa4293ySyF12vw1rJrW09rZ8AFy5tw4rXFyI
	qFn5Kw1YgFs8twbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU=

When VM runs in kvm mode, system will not exit to host mode if
executing general software breakpoint instruction, one trap exception
happens in guest mode rather than host mode. In order to debug guest
kernel on host side, one mechanism should be used to let vm exit to
host mode.

Here one special hypercall code is used for software breakpoint usage,
vm exists to host mode and kvm hypervisor identifies the special hypercall
code and set exit_reason with KVM_EXIT_DEBUG, and then let qemu handle it.

This patch uses hypercall code and needs hypercall instruction emulation
handling, and it is dependent on this patchset:
https://lore.kernel.org/all/20240201031950.3225626-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_para.h |  2 ++
 arch/loongarch/include/uapi/asm/kvm.h |  3 +++
 arch/loongarch/kvm/exit.c             | 12 ++++++++++--
 arch/loongarch/kvm/vcpu.c             | 16 ++++++++++++++--
 arch/loongarch/kvm/vm.c               |  1 +
 5 files changed, 30 insertions(+), 4 deletions(-)

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
index 923d0bd38294..ad6d79ff6742 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -15,10 +15,13 @@
  */
 
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_GUEST_DEBUG
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 189b70bad825..01e3f30f041b 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -758,23 +758,31 @@ static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
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
+		vcpu->run->exit_reason = KVM_EXIT_DEBUG;
+		ret = RESUME_HOST;
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
index 80e05ba9b48d..aa0d2eaddafe 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -245,10 +245,22 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
+			KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-					struct kvm_guest_debug *dbg)
+			struct kvm_guest_debug *dbg)
 {
-	return -EINVAL;
+	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
+		return -EINVAL;
+
+	if (dbg->control & KVM_GUESTDBG_ENABLE) {
+		vcpu->guest_debug = dbg->control;
+		/* No hardware breakpoint */
+	} else {
+		vcpu->guest_debug = 0;
+	}
+
+	return 0;
 }
 
 static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
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
-- 
2.39.3


