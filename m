Return-Path: <kvm+bounces-66104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C891CC5EDA
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 04:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA4AB3033C82
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 03:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129DA2D5C71;
	Wed, 17 Dec 2025 03:49:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1EA263C7F;
	Wed, 17 Dec 2025 03:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765943384; cv=none; b=WwBG3xz+A79SFKd1APf3GZLEq5kiSzTN43IM0ljDBKJrQgCN2WDreFR0s+kZiJLepmVtzotEIRoE/Tuja6UvgRvOdaKthwjJiI1sK5TgUmS/rABK5eVdIS/zBES1x2Hms2bx3tQNdd4RdU+nKt/sW+oos1JHViw8ZTD2gUGv/F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765943384; c=relaxed/simple;
	bh=lROeOcWhUnInlzVqAwbfImHEp+MDu7ampUOQE1mrDy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PPEMyqjWgPxZ0DXNol8Stw6542IoH9hdTVJOokT4qYpL40+3NaeoRyAQ0tQ2dU3pg5WthBM63Ne+QXECJwDMJRBap2HvDHZsSkVMRZZLTrE7gvCs6Jpk91etJle2mi7SYc7M3DeiNAugXmupSAB1K3J3ybWsNy2+QZ571cIUvXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxvsNKKEJpzgAAAA--.8S3;
	Wed, 17 Dec 2025 11:49:30 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCxPMJFKEJpksAAAA--.913S4;
	Wed, 17 Dec 2025 11:49:29 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	lixianglai@loongson.cn
Cc: stable@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] LoongArch: KVM: fix "unreliable stack" issue
Date: Wed, 17 Dec 2025 11:24:50 +0800
Message-Id: <20251217032450.954344-3-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251217032450.954344-1-lixianglai@loongson.cn>
References: <20251217032450.954344-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPMJFKEJpksAAAA--.913S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
the assembly function to guide the generation of correct ORC table entries,
thereby solving the timeout problem of loading the livepatch-sample module
on a physical machine running multiple vcpus virtual machines.

While solving the above problems, we have gained an additional benefit,
that is, we can obtain more call stack information

Stack information that can be obtained before the problem is fixed:
[<0>] kvm_vcpu_block+0x88/0x120 [kvm]
[<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
[<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
[<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
[<0>] kvm_handle_exit+0x160/0x270 [kvm]
[<0>] kvm_exc_entry+0x100/0x1e0

Stack information that can be obtained after the problem is fixed:
[<0>] kvm_vcpu_block+0x88/0x120 [kvm]
[<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
[<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
[<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
[<0>] kvm_handle_exit+0x160/0x270 [kvm]
[<0>] kvm_exc_entry+0x100/0x1e0
[<0>] kvm_arch_vcpu_ioctl_run+0x260/0x488 [kvm]
[<0>] kvm_vcpu_ioctl+0x200/0xcd8 [kvm]
[<0>] sys_ioctl+0x498/0xf00
[<0>] do_syscall+0x94/0x190
[<0>] handle_syscall+0xb8/0x158

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Xianglai Li <lixianglai@loongson.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>

 arch/loongarch/kvm/switch.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 93845ce53651..e3ecb24a3bc5 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -170,6 +170,7 @@ SYM_CODE_START(kvm_exc_entry)
 	/* restore per cpu register */
 	ld.d	u0, a2, KVM_ARCH_HPERCPU
 	addi.d	sp, sp, -PT_SIZE
+	UNWIND_HINT_REGS
 
 	/* Prepare handle exception */
 	or	a0, s0, zero
@@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
 	addi.d	a2, sp, -PT_SIZE
 	/* Save host GPRs */
 	kvm_save_host_gpr a2
+	st.d	ra, a2, PT_ERA
 
 	addi.d	a2, a1, KVM_VCPU_ARCH
 	st.d	sp, a2, KVM_ARCH_HSP
-- 
2.39.1


