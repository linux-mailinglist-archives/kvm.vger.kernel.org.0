Return-Path: <kvm+bounces-18169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A5C8CFA61
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E1772815C2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0404F3C463;
	Mon, 27 May 2024 07:46:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582A92232A;
	Mon, 27 May 2024 07:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796015; cv=none; b=f3pjI39kHFWTANadTPDvjmmKfB/KL1T2vmiS3t43syNa6AM4UeNt0vKiaKxCnB8hXN/lMN261O0K8RdDATZ5hJHyj6eYgmZA+Ze5Obqne99YfPLOrHH3q/wpcy4O4GagUBzHJC88oU9ujgDyDPIcihXOl+876I3GIw+qIvh/2M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796015; c=relaxed/simple;
	bh=uRPYeu1g//OQLx04rdY+78NfsbRwAUuTxvQddEsoBHs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VBxBXI9e5p8Nw9HYIVU5Cxou3esUaDcUkvfDEOZtXT7AW+56i50pA78+7TQsvHRjGfeMjoiRGPy1cwCvOPvWvfQUDTSG3HnNgVUXSGILpwzzf4A0cwMTW0Yt0fUeIgHD+HvV4J9+s2zI4X4F330dCfsW3tzt2LCyStqxroUUBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOplOlRmrB4AAA--.364S3;
	Mon, 27 May 2024 15:46:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxTcdlOlRmHuIKAA--.28594S2;
	Mon, 27 May 2024 15:46:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] LoongArch: KVM: Add Binary Translation extension support
Date: Mon, 27 May 2024 15:46:40 +0800
Message-Id: <20240527074644.836699-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxTcdlOlRmHuIKAA--.28594S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) is used to accelerate binary
translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
eflags (eflags) and x87 fpu stack pointer (ftop).

Like FPU extension, here late enabling method is used for LBT. LBT context
is saved/restored on vcpu context switch path.

Also this patch set BT capability detection, and BT register get/set
interface for userspace vmm, so that vm supports migration with BT
extension.

---
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

Bibo Mao (4):
  LoongArch: KVM: Add HW Binary Translation extension support
  LoongArch: KVM: Add LBT feature detection with cpucfg
  LoongArch: KVM: Add vm migration support for LBT registers
  LoongArch: KVM: Add VM LBT feature detection support

 arch/loongarch/include/asm/kvm_host.h |   8 ++
 arch/loongarch/include/asm/kvm_vcpu.h |  10 +++
 arch/loongarch/include/uapi/asm/kvm.h |  15 ++++
 arch/loongarch/kvm/exit.c             |   9 ++
 arch/loongarch/kvm/vcpu.c             | 121 +++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c               |  44 +++++++++-
 6 files changed, 205 insertions(+), 2 deletions(-)


base-commit: 29c73fc794c83505066ee6db893b2a83ac5fac63
-- 
2.39.3


