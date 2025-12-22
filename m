Return-Path: <kvm+bounces-66470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E4BCD5EA9
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 13:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A758730E136E
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 11:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E73F2222D1;
	Mon, 22 Dec 2025 11:59:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AFF30BF64;
	Mon, 22 Dec 2025 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766404758; cv=none; b=aemMybmsk22Fn2ygW+pmz4EDqyoiWo3AroD58u0GWF5MEIBsMbX6bHTKXUtyJN9YmCGRcElqcPdOdh3/N1sB6Z7kCWeTCg7D+k73p+LyCLI6ho+UgOo8Wmt9loFm7utfgpmgaW6c5XIj29f3HemLe/iD41A2skuTp91Qgf46mKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766404758; c=relaxed/simple;
	bh=uV6ycqyEJp91PheAqzqh21JIy9p4WIX+UKIubTO6ywA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qI/choSReDoHHgx+S6azN4CNGUOkj4MYjWgTUxpo9xD1LNSOZ8LAYgjXRgNRtwUpJcSrNm4Q4C3b3hywUq+XUlDQLz2baH8+hI+UaTQYSf1gVlZ1KgEVKkyCciL6uKBBHHvrmHgZwggh5aboRUy+XdUxjzgMiqLJsiCNg0Lrpyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxAfF_Mklpv_EBAA--.6802S3;
	Mon, 22 Dec 2025 19:58:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCxGOB6MklpP2IDAA--.10467S2;
	Mon, 22 Dec 2025 19:58:50 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	lixianglai@loongson.cn
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org
Subject: [PATCH V2 0/2] LoongArch: KVM: fix "unreliable stack" issue
Date: Mon, 22 Dec 2025 19:34:07 +0800
Message-Id: <20251222113409.2343711-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxGOB6MklpP2IDAA--.10467S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

When starting multi-core loongarch virtualization on loongarch physical
machine, loading livepatch on the physical machine will cause an error
similar to the following:
[  411.686289] livepatch: klp_try_switch_task: CPU 31/KVM:3116 has an
unreliable stack

The specific test steps are as follows:
1.Start a multi-core virtual machine on a physical machine

2.Enter the following command on the physical machine to turn on the debug
switch:
  echo "file kernel/livepatch/transition.c +p"  > /sys/kernel/debug/\
dynamic_debug/control 


3.Load livepatch:
 modprobe  livepatch-sample 

Through the above steps, similar prints can be viewed in dmesg.

The reason for this issue is that the code of the kvm_exc_entry function
was copied in the function kvm_loongarch_env_init. When the cpu needs to
execute kvm_exc_entry, it will switch to the copied address for execution.
The new address of the kvm_exc_entry function cannot be recognized in ORC,
which eventually leads to the arch_stack_walk_reliable function returning
an error and printing an exception message.

To solve the above problems, we directly compile the switch.S file into
the kernel instead of the module. In this way, the function kvm_exc_entry
will no longer need to be copied.

changlog:
V2<-V1:
1.Rollback the modification of function parameter types such as
kvm_save_fpu. In the asm-prototypes.h header file, only the parameter types
it depends on are included

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Xianglai Li <lixianglai@loongson.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org

Xianglai Li (2):
  LoongArch: KVM: Compile the switch.S file directly into the kernel
  LoongArch: KVM: fix "unreliable stack" issue

 arch/loongarch/Kbuild                       |  2 +-
 arch/loongarch/include/asm/asm-prototypes.h | 21 +++++++++++++
 arch/loongarch/include/asm/kvm_host.h       |  3 --
 arch/loongarch/kvm/Makefile                 |  2 +-
 arch/loongarch/kvm/main.c                   | 35 ++-------------------
 arch/loongarch/kvm/switch.S                 | 24 +++++++++++---
 6 files changed, 45 insertions(+), 42 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.39.1


