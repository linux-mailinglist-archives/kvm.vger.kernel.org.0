Return-Path: <kvm+bounces-22605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB967940A5F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5F81C22DB1
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A004192B66;
	Tue, 30 Jul 2024 07:53:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE340191F65;
	Tue, 30 Jul 2024 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326031; cv=none; b=A2rZw5W1/MNNXIO679TXQc2XvjrapkPZyVh5HoHsU1AcMff30wzUXaFi6KZueRN0ZwONM0Oxm6avr4eLC4jYN5jnNGYUh98aHwz4a1Xbzgm3HSJuwJImcr4L76GYjAi5avEN/S0tT1lDMMeRyInQAsk/wMQhyg6N/EwaqsCmpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326031; c=relaxed/simple;
	bh=B8RUK1g11kb2OLV716SLnWeR6vK05XOqKkBGmsrUtq0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k1kFTobmuIdlerJWBVmokgKXZ8tdun1M8tjUO2tRcKNmMY3y0MO0hbpPEA8cp2DgC0Fw24X2kbHVbyhpaSuMEPDirC97t3s2UJAT2M8dLTMpdOMSKS9awqUa0CAotgdQTmCgfEHiqVCxpLeRFgGYLzgE1RhTXm6Friq5fjpIocQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOoJnKhmCVEEAA--.15132S3;
	Tue, 30 Jul 2024 15:53:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLscInKhmVjQGAA--.31411S2;
	Tue, 30 Jul 2024 15:53:44 +0800 (CST)
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
Subject: [PATCH v4 0/3] Add extioi virt extension support
Date: Tue, 30 Jul 2024 15:53:41 +0800
Message-Id: <20240730075344.1215681-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLscInKhmVjQGAA--.31411S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

KVM_FEATURE_VIRT_EXTIOI is paravirt feature defined with EXTIOI
interrupt controller, it can route interrupt to 256 CPUs and cpu
Interrupt Pin IP0-IP7. Now irqchip is emulated in user space rather than
kernel space, here interface is provide for VMM to pass it to KVM
hyperviso.

Also interface is provide to VMM to detect and enable/disable paravirt
features provided in KVM hypervisor.

---
v3 ... v4:
  1. Implement function kvm_para_has_feature() on LoongArch platform,
and redefine feature with normal number rather than bitmap number, since
function kvm_para_has_feature() requires this.
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
usr_features should be assigned directly, also suggested by WangXueRui.

---
Bibo Mao (3):
  LoongArch: KVM: Enable paravirt feature control from VMM
  LoongArch: KVM: Implement function kvm_para_has_feature
  irqchip/loongson-eiointc: Add extioi virt extension support

 .../arch/loongarch/irq-chip-model.rst         |  64 ++++++++++
 .../zh_CN/arch/loongarch/irq-chip-model.rst   |  55 +++++++++
 arch/loongarch/include/asm/irq.h              |   1 +
 arch/loongarch/include/asm/kvm_host.h         |   7 ++
 arch/loongarch/include/asm/kvm_para.h         |  11 ++
 arch/loongarch/include/asm/loongarch.h        |  13 ---
 arch/loongarch/include/uapi/asm/Kbuild        |   2 -
 arch/loongarch/include/uapi/asm/kvm.h         |   5 +
 arch/loongarch/include/uapi/asm/kvm_para.h    |  24 ++++
 arch/loongarch/kernel/paravirt.c              |  32 ++---
 arch/loongarch/kvm/exit.c                     |   6 +-
 arch/loongarch/kvm/vcpu.c                     |  41 ++++++-
 arch/loongarch/kvm/vm.c                       |  43 ++++++-
 drivers/irqchip/irq-loongson-eiointc.c        | 109 ++++++++++++++----
 14 files changed, 355 insertions(+), 58 deletions(-)
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.39.3


