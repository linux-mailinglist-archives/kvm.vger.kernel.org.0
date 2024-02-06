Return-Path: <kvm+bounces-8080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9DA84AF53
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC53284D40
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 07:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCD212BF37;
	Tue,  6 Feb 2024 07:52:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmty3ljk5ljewns4xndka.icoremail.net (zg8tmty3ljk5ljewns4xndka.icoremail.net [167.99.105.149])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C106012BEA0
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 07:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.99.105.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707205940; cv=none; b=ZxM105oWyTucAEhmeOIPSQV1v+TgiFQVMJLxt+qcviSscvotZk5TBNLpSexV8Vw8stCHKpIslD95eRQkG2rSK7N5WY9DA2gl+H4gI3OUIniEwVCwG93S22mqBzU3iApB82ZVrmwCFeitxFW++0Gj4FEzSrAUJrzrN8+kVbRigpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707205940; c=relaxed/simple;
	bh=2ZHJenO61DwFOlgvMyfaU/qk5xsg2ftQognLAJ2xIVQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EIflWnwJhHsaued459nL0yrOeMCaLxL2F9dwGepYyxvf05wKa+aPUq3tBtkzZsuFXIlR1aJY9PEcots2oysbLT5HlKrceh2bmUmuwggv5ZUgzQDm5kYUzaarGBwyrGJl4VyV0UT1oxDlwpA6FMiV3P/dbhT8e+K6zYjIf4kvrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=167.99.105.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgD3gv2B5MFlygcKAA--.4463S4;
	Tue, 06 Feb 2024 15:49:22 +0800 (CST)
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
	duchao713@qq.com
Subject: [PATCH v1 0/3] RISC-V: KVM: Guest Debug Support - Software Breakpoint Part
Date: Tue,  6 Feb 2024 07:49:28 +0000
Message-Id: <20240206074931.22930-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:TAJkCgD3gv2B5MFlygcKAA--.4463S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar43ZFyfGr47Kw43Ww1ftFb_yoW8AFyrpa
	n5Gr1F9rs3Xry3G34fCFnF9r4Sgws5Wr4fWw13W3y7Z3yjyFyFyrs2gryYv3sxCaykWFyS
	kF1Ig3Wkua45J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

This series implements the “KVM Guset Debug” feature on RISC-V. This is
an existing feature which is already supported by some other arches.
It allows us to debug a RISC-V KVM guest from GDB in host side.

As the first stage, the software breakpoints (ebreak instruction) is
implemented. HW breakpoints support will come later after a synthetically
consideration with the SBI debug trigger extension.

A selftest case was added in this series. Manual test was done on QEMU
RISC-V hypervisor emulator. (add '-s' to enable the gdbserver in QEMU)

This series is based on Linux 6.8-rc2 and also available at:
https://github.com/Du-Chao/kvm-riscv/tree/guest_debug_sw

The matched QEMU is available at:
https://github.com/Du-Chao/qemu/tree/riscv_gd_sw

Changes from RFC->v1:
- Rebased on Linux 6.8-rc2.
- Merge PATCH1 and PATCH2 into one patch. (If Paolo's change
  https://lore.kernel.org/kvm/20240131233056.10845-8-pbonzini@redhat.com/
  is adopted, then we can keep 'arch/riscv/include/uapi/asm/kvm.h'
  untouched)
- kselftest case added.

RFC link:
https://lore.kernel.org/kvm/20231221095002.7404-1-duchao@eswincomputing.com

Chao Du (3):
  RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
  RISC-V: KVM: Handle breakpoint exits for VCPU
  RISC-V: KVM: selftests: Add breakpoints test support

 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kvm/vcpu.c                         | 15 +++++-
 arch/riscv/kvm/vcpu_exit.c                    |  4 ++
 arch/riscv/kvm/vm.c                           |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/riscv/breakpoints.c | 49 +++++++++++++++++++
 6 files changed, 69 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/riscv/breakpoints.c

--
2.17.1


