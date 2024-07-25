Return-Path: <kvm+bounces-22232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 414C293C20B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAECCB21AF1
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A1619AA61;
	Thu, 25 Jul 2024 12:28:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951F81993BA;
	Thu, 25 Jul 2024 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721910501; cv=none; b=jQ8wWc1wVtsjOFKOwpAzG2KmvSuFQgXpWyW/DnnCG/eZnb6fDL6LaN8JnqVxrJyrXxPJ59NBJtazpFJfBI76ar1dXbkIWK11GYWvE7CqPGQhiHOrXFR+tyM6raxssFV4GhR5Ad8ULSphtlI5WhdTNs/SqatDFYtSnu0OLoRFL5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721910501; c=relaxed/simple;
	bh=MvUCDXs2wFdaYwczgJ0I/v9jzVlvm5YIot1iKRT+yaM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=izNNOudBnnvx1IT0HINo5QPSowRHdmq9ecthQqOeYe8GE2VsqBPRQM14YcHX4BFZCu76hQqk6aATyAbhGnJ3jOW3hafFD7e3Pc3dHo+qHHPCqQ//+2i2wwevT3Mdh6C14OVId7GD0bkcbn7Ex4bqnsVpMW0SmLUO+YFXDJexQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.34])
	by gateway (Coremail) with SMTP id _____8Ax2endRKJmT4cBAA--.5691S3;
	Thu, 25 Jul 2024 20:28:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.10.34])
	by front1 (Coremail) with SMTP id qMiowMDxIuTcRKJmog8BAA--.7001S2;
	Thu, 25 Jul 2024 20:28:12 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH v3 0/2] Add paravirt KVM_FEATURE_VIRT_EXTIOI feature
Date: Thu, 25 Jul 2024 20:28:10 +0800
Message-Id: <20240725122812.3296140-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxIuTcRKJmog8BAA--.7001S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJrW5Gr47Cr1DZF45Xr45XFc_yoW8Ar15pa
	sxArn3Jr48Gr4fAwsxtan5ury3Xr1xG3Waqay2k34UAF4a9r1UZr48KrZ8ZFyDt3yfXr10
	gF1rG345W3WqvabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcyxRUUUUU

KVM_FEATURE_VIRT_EXTIOI is paravirt feature defined with EXTIOI
interrupt controller, it can route interrupt to 256 CPUs and cpu
interface IP0-IP7. Now irqchip is emulated in user space rather than
kernel space, here interface is provide for VMM to pass it to KVM
hyperviso.

Also interface is provide to VMM to detect and enable/disable paravirt
features provided in KVM hypervisor.

---
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
Bibo Mao (2):
  LoongArch: KVM: Enable paravirt feature control from VMM
  LoongArch: KVM: Implement function kvm_arch_para_features

 arch/loongarch/include/asm/kvm_host.h      |  9 +++++
 arch/loongarch/include/asm/kvm_para.h      | 11 ++++++
 arch/loongarch/include/asm/loongarch.h     | 13 -------
 arch/loongarch/include/uapi/asm/Kbuild     |  2 --
 arch/loongarch/include/uapi/asm/kvm.h      |  2 ++
 arch/loongarch/include/uapi/asm/kvm_para.h | 24 +++++++++++++
 arch/loongarch/kernel/paravirt.c           | 22 ++++++++----
 arch/loongarch/kvm/exit.c                  |  4 +--
 arch/loongarch/kvm/vcpu.c                  | 41 +++++++++++++++++++---
 arch/loongarch/kvm/vm.c                    | 12 +++++++
 10 files changed, 111 insertions(+), 29 deletions(-)
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h


base-commit: c33ffdb70cc6df4105160f991288e7d2567d7ffa
-- 
2.39.3


