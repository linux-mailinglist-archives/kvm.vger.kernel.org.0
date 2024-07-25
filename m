Return-Path: <kvm+bounces-22208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0947E93BB41
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 05:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AA761F22F7E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 03:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE0318028;
	Thu, 25 Jul 2024 03:34:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7796A1C683;
	Thu, 25 Jul 2024 03:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721878458; cv=none; b=aCR0G0NUru5HLWAecl8ZiSs7jQlOWBrE3l9uZ1ssi2bvVSCJmlKxSUx/TXVNS7nI6rAcNQ+RDXF7DiRAuoBKPZseQ87ORLlylVsYUVgQQ8tUhwwTd1yKx+VS2fC6+CkgFnE2zocVAH8boEqYb3Jw0rcj+6rAE3Dp1u6rnPaGR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721878458; c=relaxed/simple;
	bh=/N706srqYtuJMkT+BpYGzLjZvdeXYv1h11HRHGRQDu8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rvakj91OIZeBKLlPQKqVYLLMzCa2j++XCbdLyEh5VTBa+GdwWxXo5XSytzQc1n2WjDaOnf+c+D30KLNJ9x36Z+enevEEnN72pxl4F5B6c8z0pBQgzx1hwES6E40hn7/TSbRkxTkm4nYHk5IrxbhWRjxFvWkIDs4WFmB6nhk/roI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.34])
	by gateway (Coremail) with SMTP id _____8Cxd+mux6Fm5FUBAA--.3577S3;
	Thu, 25 Jul 2024 11:34:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.10.34])
	by front1 (Coremail) with SMTP id qMiowMBxicWsx6FmppEAAA--.37S2;
	Thu, 25 Jul 2024 11:34:04 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v5 0/3] LoongArch: KVM: Add Binary Translation extension support
Date: Thu, 25 Jul 2024 11:34:01 +0800
Message-Id: <20240725033404.2675204-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxicWsx6FmppEAAA--.37S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJr45trWUXrW7Xry8AryrGrX_yoW8urWxpa
	43Crn5GF18Kr43AwsIq34q9r1YgFWxCrW8WF9xJ3yYyF4DGry8Xr40kFyDWF1UCw4rXry0
	vF1vy3y8uFs8AwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=

Loongson Binary Translation (LBT) is used to accelerate binary
translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
eflags (eflags) and x87 fpu stack pointer (ftop).

Like FPU extension, here lately enabling method is used for LBT. LBT
context is saved/restored during vcpu context switch path.

Also this patch set LBT capability detection, and LBT register get/set
interface for userspace vmm, so that vm supports migration with BT
extension.

---
v4 ... v5:
  1. Add feature detection for LSX/LASX from vm side, previously
LSX/LASX feature is detected from vcpu ioctl command, now both methods
are supported.

v3 ... v4:
  1. Merge LBT feature detection for VM and VCPU into one patch.
  2. Move function declaration such as kvm_lose_lbt()/kvm_check_fcsr()/
kvm_enable_lbt_fpu() from header file to c file, since it is only
used in one c file.

v2 ... v3:
  1. Split KVM_LOONGARCH_VM_FEAT_LBT capability checking into three
sub-features, KVM_LOONGARCH_VM_FEAT_X86BT/KVM_LOONGARCH_VM_FEAT_ARMBT
and KVM_LOONGARCH_VM_FEAT_MIPSBT. Return success only if host supports
the sub-feature.

v1 ... v2:
  1. With LBT register read or write interface to userpace, replace
device attr method with KVM_GET_ONE_REG method, since lbt register is
vcpu register and can be added in kvm_reg_list in future.
  2. Add vm device attr ctrl marcro KVM_LOONGARCH_VM_FEAT_CTRL, it is
used to get supported LBT feature before vm or vcpu is created.
---

Bibo Mao (3):
  LoongArch: KVM: Add HW Binary Translation extension support
  LoongArch: KVM: Add LBT feature detection function
  LoongArch: KVM: Add vm migration support for LBT registers

 arch/loongarch/include/asm/kvm_host.h |   8 ++
 arch/loongarch/include/asm/kvm_vcpu.h |   6 ++
 arch/loongarch/include/uapi/asm/kvm.h |  17 ++++
 arch/loongarch/kvm/exit.c             |   9 ++
 arch/loongarch/kvm/vcpu.c             | 126 +++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c               |  52 ++++++++++-
 6 files changed, 216 insertions(+), 2 deletions(-)


base-commit: c33ffdb70cc6df4105160f991288e7d2567d7ffa
-- 
2.39.3


