Return-Path: <kvm+bounces-5406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 715048209CF
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 06:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2092B2831B6
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 05:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0017733CF;
	Sun, 31 Dec 2023 05:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="CG9r/4Ud"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E43209
	for <kvm@vger.kernel.org>; Sun, 31 Dec 2023 05:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35ff6de2068so31821065ab.0
        for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 21:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1704000832; x=1704605632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AYOj0zMDCoqSqL2SogFY0FvJoNBa1dfvwCNFWFJHm2I=;
        b=CG9r/4Ud//mJv9f/K2ztWp0Q5E3E3r8XrtdPzpjcVxfDKawO+J0xUp+jBW5q0N6fjf
         wn6o86FWPs5CPJQ+AY+V9imADybobXIe8jDgAcRH8m+YMV+bvHRHUN4charrIdObozDd
         uv3abvC3mNvbNzUsod22GO0IdKvXyjhCb7AAHYoMY7xTYiaeQmbM4AVk0K6l1L1ERLNG
         IdGjXy2sxrFZPDQrZh+KIVOeRBzhEIhqrNC4V/ic5Rtkq17ZfpEjWusIEcXXWRiQBZEt
         bhqLAZ46k9WjWQuePP0JBDx4ENd6tqia57v+tpuISCx7UOMkM/TR7eKQ5v66T22yzxsx
         rYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704000832; x=1704605632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AYOj0zMDCoqSqL2SogFY0FvJoNBa1dfvwCNFWFJHm2I=;
        b=gE+kjJCKegVbsxOOtCimEC79kf2V2RF3CkWs0Z1BQ5r5wPKxVXb55C1zrvsMW4biCX
         81elWH8isC5BGnit7AMSqHAIihszUSeJuo32e6sGeHBzA4RwXp0XvFJrE3wks4wmfXAn
         L6YdBf1Xhge41yI/UsY3QXC+T39WgRi1+0eFd0srwlXQ5D68QNUDwPlUMdZPHx8ZuCcS
         Wz9B64SmLv0/wW3zW1+ihVrG7ia2JuJjns99fZv5+zwklFx/A2RdraXHd0HyV41E71bZ
         uFphFORbqIubNgMczjkPZrvYz0hKmqpWA+8NO2oOVMaMID+g+wFfB2tsvXhc47aqL/Np
         0p/w==
X-Gm-Message-State: AOJu0YyHMhiKjgQQ1YwIOBa8rwj6QshxltuZ4JnoM+fa/IIDWMeJFxEC
	SBVY4Cjvsrs+8+CLFNb2rOBqg2pCqGhidQ9RroGhSUyXfFUyxg==
X-Google-Smtp-Source: AGHT+IGADCclY2p323xug2yA4KRTE8gqRECPoGx4dnY0cdPc9tr7UVakowIStDz9s11jYb+mg4x6EX2YdybivHBhpjI=
X-Received: by 2002:a05:6e02:20e6:b0:360:173a:b2da with SMTP id
 q6-20020a056e0220e600b00360173ab2damr12581608ilv.12.1704000832362; Sat, 30
 Dec 2023 21:33:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sun, 31 Dec 2023 11:03:41 +0530
Message-ID: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.8 part #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.8:
1) KVM_GET_REG_LIST improvement for vector registers
2) Generate ISA extension reg_list using macros in get-reg-list selftest
3) Steal time account support along with selftest

Please pull.

Please note that I will be sending another PR for 6.8 which will
include two more changes:
1) KVM RISC-V report more ISA extensions through ONE_REG
2) RISC-V SBI v2.0 PMU improvements and Perf sampling in KVM guest

Two separate PRs are because #1 (above) depends on a series
merged by Palmer for 6.8 and #2 (above) requires little more testing.
I hope you are okay with two separate PRs for 6.8.

Regards,
Anup

The following changes since commit 861deac3b092f37b2c5e6871732f3e11486f7082=
:

  Linux 6.7-rc7 (2023-12-23 16:25:56 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.8-1

for you to fetch changes up to aad86da229bc9d0390dc2c02eb0db9ab1f50d059:

  RISC-V: KVM: selftests: Add get-reg-list test for STA registers
(2023-12-30 11:26:47 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.8 part #1

- KVM_GET_REG_LIST improvement for vector registers
- Generate ISA extension reg_list using macros in get-reg-list selftest
- Steal time account support along with selftest

----------------------------------------------------------------
Andrew Jones (19):
      RISC-V: KVM: Don't add SBI multi regs in get-reg-list
      KVM: riscv: selftests: Drop SBI multi registers
      RISC-V: KVM: Make SBI uapi consistent with ISA uapi
      KVM: riscv: selftests: Add RISCV_SBI_EXT_REG
      KVM: riscv: selftests: Use register subtypes
      RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs
      RISC-V: paravirt: Add skeleton for pv-time support
      RISC-V: Add SBI STA extension definitions
      RISC-V: paravirt: Implement steal-time support
      RISC-V: KVM: Add SBI STA extension skeleton
      RISC-V: KVM: Add steal-update vcpu request
      RISC-V: KVM: Add SBI STA info to vcpu_arch
      RISC-V: KVM: Add support for SBI extension registers
      RISC-V: KVM: Add support for SBI STA registers
      RISC-V: KVM: Implement SBI STA extension
      RISC-V: KVM: selftests: Move sbi_ecall to processor.c
      RISC-V: KVM: selftests: Add guest_sbi_probe_extension
      RISC-V: KVM: selftests: Add steal_time test support
      RISC-V: KVM: selftests: Add get-reg-list test for STA registers

Anup Patel (2):
      KVM: riscv: selftests: Generate ISA extension reg_list using macros
      RISC-V: KVM: Fix indentation in kvm_riscv_vcpu_set_reg_csr()

Chao Du (1):
      RISC-V: KVM: remove a redundant condition in kvm_arch_vcpu_ioctl_run(=
)

Cl=C3=A9ment L=C3=A9ger (2):
      riscv: kvm: Use SYM_*() assembly macros instead of deprecated ones
      riscv: kvm: use ".L" local labels in assembly when applicable

Daniel Henrique Barboza (3):
      RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
      RISC-V: KVM: add 'vlenb' Vector CSR
      RISC-V: KVM: add vector registers and CSRs in KVM_GET_REG_LIST

 Documentation/admin-guide/kernel-parameters.txt    |   6 +-
 arch/riscv/Kconfig                                 |  19 +
 arch/riscv/include/asm/kvm_host.h                  |  10 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  20 +-
 arch/riscv/include/asm/paravirt.h                  |  28 +
 arch/riscv/include/asm/paravirt_api_clock.h        |   1 +
 arch/riscv/include/asm/sbi.h                       |  17 +
 arch/riscv/include/uapi/asm/kvm.h                  |  13 +
 arch/riscv/kernel/Makefile                         |   1 +
 arch/riscv/kernel/paravirt.c                       | 135 +++++
 arch/riscv/kernel/time.c                           |   3 +
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/vcpu.c                              |  10 +-
 arch/riscv/kvm/vcpu_onereg.c                       | 135 +++--
 arch/riscv/kvm/vcpu_sbi.c                          | 142 +++--
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   2 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      | 208 ++++++++
 arch/riscv/kvm/vcpu_switch.S                       |  32 +-
 arch/riscv/kvm/vcpu_vector.c                       |  16 +
 tools/testing/selftests/kvm/Makefile               |   5 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
 .../selftests/kvm/include/riscv/processor.h        |  62 ++-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  49 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  26 -
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 588 ++++++++++-------=
----
 tools/testing/selftests/kvm/steal_time.c           |  99 ++++
 27 files changed, 1184 insertions(+), 446 deletions(-)
 create mode 100644 arch/riscv/include/asm/paravirt.h
 create mode 100644 arch/riscv/include/asm/paravirt_api_clock.h
 create mode 100644 arch/riscv/kernel/paravirt.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi_sta.c

