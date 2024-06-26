Return-Path: <kvm+bounces-20523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EDD917901
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 08:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFE18B2338B
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 06:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84766156257;
	Wed, 26 Jun 2024 06:32:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C2E145356;
	Wed, 26 Jun 2024 06:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719383570; cv=none; b=mrqNOykOvgfFhU/te75uRbNLRB64UOx0EOloZJTUcC3KJMSaenl0ONEVnckyelpfEVpNnez0Js3Kz6Mo+lj8h+WehVApbVvH64sKchyLDm4VN+wyyxwoX/B68ZeYtkhLyr7p+wflj3Ei6lSXO9c8NchPN0+WM+pon2sMtQtdaFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719383570; c=relaxed/simple;
	bh=04LylK4WLFzgwQvnXifumbQ9XXXgzpCJwzHl8Nf3rRM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qYWD3MIZctWC2YAvgtnBG9q9n0BrSG+bmp1iCjd0N+GyLs8YalPetcunIgQLB0Ve5aL3N4+Qwlt2dMD2rAG537np7x7Jl9XDo0tWaikTQHM8f+SeMDih5so37QUFyqLkbEPj9Vd9iyPQCbqXgNZzKvlve37KCo3BaXTHEJu/7DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bxb+sItntm+CkKAA--.40648S3;
	Wed, 26 Jun 2024 14:32:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHMcHtntmo5ExAA--.53222S2;
	Wed, 26 Jun 2024 14:32:39 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] LoongArch: KVM: Add Binary Translation extension support
Date: Wed, 26 Jun 2024 14:32:36 +0800
Message-Id: <20240626063239.3722175-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHMcHtntmo5ExAA--.53222S2
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
 arch/loongarch/include/asm/kvm_vcpu.h |  10 +++
 arch/loongarch/include/uapi/asm/kvm.h |  15 ++++
 arch/loongarch/kvm/exit.c             |   9 ++
 arch/loongarch/kvm/vcpu.c             | 121 +++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c               |  44 +++++++++-
 6 files changed, 205 insertions(+), 2 deletions(-)


base-commit: 55027e689933ba2e64f3d245fb1ff185b3e7fc81
-- 
2.39.3


