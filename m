Return-Path: <kvm+bounces-5017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E2281B2E4
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4BF71F22432
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CCF4B5B4;
	Thu, 21 Dec 2023 09:51:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EC5481BA
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 09:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgA3tvsxCoRlVowCAA--.17982S4;
	Thu, 21 Dec 2023 17:49:37 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	dbarboza@ventanamicro.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
Date: Thu, 21 Dec 2023 09:49:59 +0000
Message-Id: <20231221095002.7404-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgA3tvsxCoRlVowCAA--.17982S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZF15uF1ruw43Xr18KryUJrb_yoWfAFb_Cr
	WfJ3yrJ397XFW0gFZ7C3Z3GFWDGFWrG3W2yr1I9F1UGr43WrW7Gw4kXr15Zr1UAr45Za4k
	XFn5ZryxZ3429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb7xYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK6svPMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jUfHUUUUUU=
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This series implements KVM Guest Debug on RISC-V. Currently, we can
debug RISC-V KVM guest from the host side, with software breakpoints.

A brief test was done on QEMU RISC-V hypervisor emulator.

A TODO list which will be added later:
1. HW breakpoints support
2. Test cases

This series is based on Linux 6.7-rc6 and is also available at:
https://github.com/Du-Chao/linux/tree/riscv_gd_sw

The matched QEMU is available at:
https://github.com/Du-Chao/qemu/tree/riscv_gd_sw

Chao Du (3):
  RISC-V: KVM: Enable the KVM_CAP_SET_GUEST_DEBUG capability
  RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
  RISC-V: KVM: Handle breakpoint exits for VCPU

 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
 arch/riscv/kvm/vcpu_exit.c        |  4 ++++
 arch/riscv/kvm/vm.c               |  1 +
 4 files changed, 19 insertions(+), 2 deletions(-)

--
2.17.1


