Return-Path: <kvm+bounces-10570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5E486D904
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 02:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60E7A1F22BD8
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 01:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7D639AC7;
	Fri,  1 Mar 2024 01:39:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EECF383A9
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.101.248.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709257172; cv=none; b=HD7vNwkXpIy7PpS3kUSWc8ib3esxlsDX8JNVn9f+gpUuPYLTQsluDtBn62CTWnKAd51TwFzW2SQQxz8+BhBNoCPzFr+OaGrLxJPmwnxBruOxKjG0mvSXpob0TIWnoAFzjJAZtIrO0feaifngtdFX7FsbP2/EO1L4DRQlT+fTDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709257172; c=relaxed/simple;
	bh=Y3I5Kg8ZAiUpH1ozDhfbNnrI764/aFZ90bRIzQhTkxQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VlK4WFSdUfYkPmJMiH3yQ6/eUitYAcniCQ+SYu9x3XsX2jSnIx0IPO/HERvAA4OCQ8qrzWXmpojWvTZO8+CouPviTlZRva0q0YHcBUWBu5CJm6+5ZnaBMdworExLQdHYMjZeWplLsLpBpFDdPbCNcDd/wCP3Hc/XV9yzRDVnVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=46.101.248.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgCnJfucMeFljDIdAA--.45179S4;
	Fri, 01 Mar 2024 09:38:36 +0800 (CST)
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
Subject: [PATCH v2 0/3] RISC-V: KVM: Guest Debug Support - Software Breakpoint Part
Date: Fri,  1 Mar 2024 01:35:42 +0000
Message-Id: <20240301013545.10403-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:TAJkCgCnJfucMeFljDIdAA--.45179S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar43ZFyfGr47Kw43Ww1ftFb_yoW8uFWxpa
	1rWrn09rs5Xry3G34fCrnF9r4fXws5Wr4fXw43W3y3Z3yjkFyrArs7KryYvr9xCrWkWryS
	kF1Ig3Wku34DJ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

This series is based on Linux 6.8-rc6 and also available at:
https://github.com/Du-Chao/kvm-riscv/tree/guest_debug_sw_v2

The matched QEMU is available at:
https://github.com/Du-Chao/qemu/tree/riscv_gd_sw

Please note that if Paolo's change
https://lore.kernel.org/kvm/20240131233056.10845-8-pbonzini@redhat.com/
is adopted, then we can keep 'arch/riscv/include/uapi/asm/kvm.h'
untouched.

Changes from v1->v2:
- Rebased on Linux 6.8-rc6.
- Maintain a hedeleg in "struct kvm_vcpu_config" for each VCPU.
- Update the HEDELEG csr in kvm_arch_vcpu_load().

Changes from RFC->v1:
- Rebased on Linux 6.8-rc2.
- Merge PATCH1 and PATCH2 into one patch.
- kselftest case added.

v1 link:
https://lore.kernel.org/kvm/20240206074931.22930-1-duchao@eswincomputing.com
RFC link:
https://lore.kernel.org/kvm/20231221095002.7404-1-duchao@eswincomputing.com

Chao Du (3):
  RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
  RISC-V: KVM: Handle breakpoint exits for VCPU
  RISC-V: KVM: selftests: Add breakpoints test support

 arch/riscv/include/asm/kvm_host.h             | 17 +++++++
 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kvm/main.c                         | 18 +------
 arch/riscv/kvm/vcpu.c                         | 15 +++++-
 arch/riscv/kvm/vcpu_exit.c                    |  4 ++
 arch/riscv/kvm/vm.c                           |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/riscv/breakpoints.c | 49 +++++++++++++++++++
 8 files changed, 88 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/riscv/breakpoints.c

--
2.17.1


