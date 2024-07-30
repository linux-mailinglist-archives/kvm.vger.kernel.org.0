Return-Path: <kvm+bounces-22607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D829940A7E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29EBA284E66
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A0F1922E7;
	Tue, 30 Jul 2024 07:57:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1F618D4DC;
	Tue, 30 Jul 2024 07:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326268; cv=none; b=UskYcxZvZOiKfLs+vmC0aUXxx45rIfxd3KEQ+9xhnEf8IUrIwOeoUbMvHyVzJRXMAJffj/BSZSYmuxGe8s26/7TI3GxsqSWB5ck9cdVwU1KcUQvoCiTN1DkMnsl2phl5Kj1iSxGgvdxmwWCCTD4nyY7WBIMmDD0UIhRgRKvcVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326268; c=relaxed/simple;
	bh=DfV+XSkYlxPxGgegljPBL3o7ugd5RhsUT0FJbNXDZEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rd6eZcoajn9+AgF+kkUzkjfxyEMnm+aXEqxls/xqAoAJm572IPAUm/AZkwmZMEleIJ92jfBshx/1xJNJhT67AVMWUaW5D24p6vF/bRWS87BzahjuvDUXoof9iHnQ1Ncw8syTo0OzR91IBhfcN1vW+tUM4rXLl71SepwHCl+hMOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cxruv4nKhm8VEEAA--.15032S3;
	Tue, 30 Jul 2024 15:57:44 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxX8f4nKhmrTUGAA--.30670S2;
	Tue, 30 Jul 2024 15:57:44 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v6 0/3] LoongArch: KVM: Add Binary Translation extension support
Date: Tue, 30 Jul 2024 15:57:40 +0800
Message-Id: <20240730075744.1215856-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxX8f4nKhmrTUGAA--.30670S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) is used to accelerate binary
translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
eflags (eflags) and x87 fpu stack pointer (ftop).

Like FPU extension, here lately enabling method is used for LBT. LBT
context is saved/restored during vcpu context switch path.

Also this patch set LBT capability detection, and LBT register get and set
interface for userspace vmm, so that vm supports migration with BT
extension.

---
v5 ... v6:
  1. Solve compiling issue with function kvm_get_one_reg() and
     kvm_set_one_reg().

v4 ... v5:
  1. Add feature detection for LSX/LASX from vm side, previously
     LSX/LASX feature is detected from vcpu ioctl command, now both
     methods are supported.

v3 ... v4:
  1. Merge LBT feature detection for VM and VCPU into one patch.
  2. Move function declaration such as kvm_lose_lbt()/kvm_check_fcsr()/
     kvm_enable_lbt_fpu() from header file to c file, since it is only
     used in one c file.

v2 ... v3:
  1. Split KVM_LOONGARCH_VM_FEAT_LBT capability checking into three
     sub-features, KVM_LOONGARCH_VM_FEAT_X86BT/KVM_LOONGARCH_VM_FEAT_ARMBT
     and KVM_LOONGARCH_VM_FEAT_MIPSBT. Return success only if host
     supports the sub-feature.

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
 arch/loongarch/kvm/vcpu.c             | 128 +++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c               |  52 ++++++++++-
 6 files changed, 218 insertions(+), 2 deletions(-)


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.39.3


