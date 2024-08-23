Return-Path: <kvm+bounces-24867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 485AD95C598
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 08:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AF921C21C05
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 06:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD681369B1;
	Fri, 23 Aug 2024 06:39:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CD44D8BA;
	Fri, 23 Aug 2024 06:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724395197; cv=none; b=j5agsG9Cydvz1NR+YEzh/IbjP0fdBdPzcDUeGPRNvoDKucOhw+CX6pu4p6gZ84ZTQnjAu2Zrcn87SYWBK6eEgtSz0Diug07oeWGq1YmSjGrTlZhkkPKfz/u4YcQ4h0Lw9jsi7xEVMbOs7cyIisVrpWIlYZVubdlaw36w+6dLEjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724395197; c=relaxed/simple;
	bh=tDRlbZQkEh6EaTQpQlbIFGu7reNtKZ5DdfTQpHKuM88=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UqWFcM4Qg0jhZmy9lA8ffnkzYU1rAxAD8CSZSZUIfOiJPql0uYirO6OKD1P7XQzmlu6d6MsobIhoTQov85LB2PdIeDhujDaYzS8TwcKb+Mc4TwfRTg7hTrIkc5kK2gfNSMNtFu9iGriBVqJ72gT3P+7wnVBX6dol6WG1I5k7l6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxipqxLshmyR8dAA--.24997S3;
	Fri, 23 Aug 2024 14:39:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxnWevLshmUPoeAA--.41360S2;
	Fri, 23 Aug 2024 14:39:44 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org,
	Song Gao <gaosong@loongson.cn>
Subject: [PATCH v7 0/3] Add extioi virt extension support
Date: Fri, 23 Aug 2024 14:39:40 +0800
Message-Id: <20240823063943.2618675-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxnWevLshmUPoeAA--.41360S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

KVM_FEATURE_VIRT_EXTIOI is paravirt feature defined with EXTIOI
interrupt controller, it can route interrupt to 256 vCPUs and CPU
interrupt pin IP0-IP7. Now EXTIOI irqchip is emulated in user space
rather than kernel space, here interface is provided for VMM to pass
this feature to KVM hypervisor.

Also interface is provided for user-mode VMM to detect and enable/disable
paravirt features from KVM hypervisor. And api kvm_para_has_feature() is
available on LoongArch for device driver to detect paravirt features and
do some optimization.

---
v6 ... v7:
  1. Replase function name guest_pv_has() to check whether paravirt feature
     is supported with kvm_guest_has_pv_feature(), since there is
     similiar function kvm_guest_has_lsx/lasx
  2. Keep notation about CPUCFG area 0x40000000 -- 0x400000ff in header
     file arch/loongarch/include/asm/loongarch.h
  3. Remove function kvm_eiointc_init() and inline it with caller
     function.

v5 ... v6:
  1. Put KVM hypervisor type checking function kvm_para_available()
     inside function kvm_arch_para_features(), so that upper caller
     is easy to use.
  2. Add inline function guest_pv_has() in KVM module to judge whether
     the specific paravirt feature is supported or not. And do valid
     checking at hypercall and user space ioctl entrance with it.
  3. Fix some coding style issue such as variable declarations and spell
     checking.

v4 ... v5:
  1. Refresh annotation "WITH Linux-syscall-note" about uapi header file
     arch/loongarch/include/uapi/asm/kvm_para.h

v3 ... v4:
  1. Implement function kvm_para_has_feature() on LoongArch platform,
     and redefine feature with normal number rather than bitmap number,
     since function kvm_para_has_feature() requires this.
  2. Add extioi virt extension support in this patch set.
  3. Update extioi virt extension support patch with review comments,
     including documentation, using kvm_para_has_feature() to detect
     features etc.

v2 ... v3:
  1. Add interface to detect and enable/disable paravirt features in
     KVM hypervisor.
  2. Implement function kvm_arch_para_features() for device driver in
     VM side to detected supported paravirt features.

v1 ... v2:
  1. Update changelog suggested by WangXuerui.
  2. Fix typo issue in function kvm_loongarch_cpucfg_set_attr(),
     usr_features should be assigned directly, also suggested by
     WangXueRui.
---
Bibo Mao (3):
  LoongArch: KVM: Enable paravirt feature control from VMM
  LoongArch: KVM: Implement function kvm_para_has_feature
  irqchip/loongson-eiointc: Add extioi virt extension support

 .../arch/loongarch/irq-chip-model.rst         |  64 +++++++++++
 .../zh_CN/arch/loongarch/irq-chip-model.rst   |  55 +++++++++
 arch/loongarch/include/asm/irq.h              |   1 +
 arch/loongarch/include/asm/kvm_host.h         |   7 ++
 arch/loongarch/include/asm/kvm_para.h         |  11 ++
 arch/loongarch/include/asm/kvm_vcpu.h         |   4 +
 arch/loongarch/include/asm/loongarch.h        |  11 +-
 arch/loongarch/include/uapi/asm/Kbuild        |   2 -
 arch/loongarch/include/uapi/asm/kvm.h         |   5 +
 arch/loongarch/include/uapi/asm/kvm_para.h    |  24 ++++
 arch/loongarch/kernel/paravirt.c              |  35 +++---
 arch/loongarch/kvm/exit.c                     |  19 ++--
 arch/loongarch/kvm/vcpu.c                     |  47 ++++++--
 arch/loongarch/kvm/vm.c                       |  43 ++++++-
 drivers/irqchip/irq-loongson-eiointc.c        | 106 ++++++++++++++----
 15 files changed, 368 insertions(+), 66 deletions(-)
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h


base-commit: aa0743a229366e8c1963f1b72a1c974a9d15f08f
-- 
2.39.3


