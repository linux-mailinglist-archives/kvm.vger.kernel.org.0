Return-Path: <kvm+bounces-13337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6337894B68
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 164571C2261F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6816220DD2;
	Tue,  2 Apr 2024 06:31:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmtu5ljy1ljeznc42.icoremail.net (zg8tmtu5ljy1ljeznc42.icoremail.net [159.65.134.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CD213FE7
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 06:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.65.134.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039459; cv=none; b=s9FAPwX+FDvmv/6XhhbQzZ4YS/qV96bujEARPhwIKmcmVPFAB6KG+ri9CF60+LJSvzLf95cA7VvFBEaAzfw8SWNfdsbCVrfYG4t1BmGKniPfKAdDBcFVAKG60WXOxoFolzT3yNkmjFcFNkxiaqIqvfZt47qyR6XATypiXfS+GO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039459; c=relaxed/simple;
	bh=wvQQY5s2EzmBuqVh0mz/m0qTg8o4aBHL6BQYYikJlo0=;
	h=From:To:Subject:Date:Message-Id; b=mSti7jJK2qK0O2Oh8BUQ+JlmF4zGXF/KfXNcfQek4TDk6Z8NanQDxZXkdLxSJrcxyJ8lGz2PuijMOwzVWQ1PeXM3dHWReFSbHhOsJnobUAL3tDzjtEkE34vqi3givxcDj5QPyN2VawbVJty2FBE2mGT4wvqPJXGss1CnMRdiRFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=159.65.134.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app2 (Coremail) with SMTP id TQJkCgBHWry1pQtm5G0EAA--.36929S4;
	Tue, 02 Apr 2024 14:29:10 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	dbarboza@ventanamicro.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	haibo1.xu@intel.com,
	duchao713@qq.com
Subject: [PATCH v4 0/3] RISC-V: KVM: Guest Debug Support - Software Breakpoint Part
Date: Tue,  2 Apr 2024 06:26:25 +0000
Message-Id: <20240402062628.5425-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TQJkCgBHWry1pQtm5G0EAA--.36929S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1xJr48Gw1rAFyrWrW7Arb_yoW5JrWxpF
	W8GF909rs3Xr1fGayxCr1v9r1fXrs5ur4fWw1fW3y3Zr4jkFyFyrs2gryYkr98CrykWFya
	y3Z2g3WkCa4DA37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY
	04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07beAp5UUUUU=
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This series implements the "KVM Guset Debug" feature on RISC-V. This is
an existing feature which is already supported by some other arches.
It allows us to debug a RISC-V KVM guest from GDB in host side.

As the first stage, the software breakpoints (ebreak instruction) is
implemented. HW breakpoints support will come later after a synthetically
consideration with the SBI debug trigger extension.

A selftest case was added in this series. Manual test was done on QEMU
RISC-V hypervisor emulator. (add '-s' to enable the gdbserver in QEMU)

This series is based on Linux 6.9-rc1 and also available at:
https://github.com/Du-Chao/kvm-riscv/tree/guest_debug_sw_v3_6.9-rc1

The matched QEMU is available at:
https://github.com/Du-Chao/qemu/tree/riscv_gd_sw


Changes from v3->v4:
- Some optimization on the testcase as per review comments.

Changes from v2->v3:
- Rebased on Linux 6.9-rc1.
- Use BIT() in the macro definition.
- set/clear the bit EXC_BREAKPOINT explicitly.
- change the testcase name to ebreak_test.
- test the scenario without GUEST_DEBUG. vm_install_exception_handler()
  is used thanks to Haibo's patch.

Changes from v1->v2:
- Rebased on Linux 6.8-rc6.
- Maintain a hedeleg in "struct kvm_vcpu_config" for each VCPU.
- Update the HEDELEG csr in kvm_arch_vcpu_load().

Changes from RFC->v1:
- Rebased on Linux 6.8-rc2.
- Merge PATCH1 and PATCH2 into one patch.
- kselftest case added.

v3 link:
https://lore.kernel.org/kvm/20240327075526.31855-1-duchao@eswincomputing.com
v2 link:
https://lore.kernel.org/kvm/20240301013545.10403-1-duchao@eswincomputing.com
v1 link:
https://lore.kernel.org/kvm/20240206074931.22930-1-duchao@eswincomputing.com
RFC link:
https://lore.kernel.org/kvm/20231221095002.7404-1-duchao@eswincomputing.com

Chao Du (3):
  RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
  RISC-V: KVM: Handle breakpoint exits for VCPU
  RISC-V: KVM: selftests: Add ebreak test support

 arch/riscv/include/asm/kvm_host.h             | 12 +++
 arch/riscv/kvm/main.c                         | 18 +---
 arch/riscv/kvm/vcpu.c                         | 16 +++-
 arch/riscv/kvm/vcpu_exit.c                    |  4 +
 arch/riscv/kvm/vm.c                           |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/riscv/ebreak_test.c | 82 +++++++++++++++++++
 7 files changed, 116 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c

--
2.17.1


