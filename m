Return-Path: <kvm+bounces-16559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E0E8BB963
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 05:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D7641C21D8B
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 03:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3530E10A0A;
	Sat,  4 May 2024 03:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OoCVahjd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFF0F4E7
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 03:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714793801; cv=none; b=GlKamrpVO/9lXhBSzER24JMh3z5SB8bbeIfVE56wAq+RLWZWSGq61NsiMYbYuizyOg6rs1WxMaVj1hXOyvfVAf1DrJmkKQe2wIjce0B1UjpxRcDIzk2jkx9He9/OxOXMWXUU5kjq/u0uVnTF4KWjkui9vAg5EestlKS9A0+xhFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714793801; c=relaxed/simple;
	bh=dXcd8KulHSvcSnMSu5QDreJ7DJ5FZYutSPM8aI+pCEU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jd6yeMhRMJS1lfP37UCiAU32p+Kg/IaBcgyzLZVjzN69Ub1cpP7ae13Sam9+EVHENRL0dTL5S+n0EEMvuLDOESiZrWK+83FXAO+hogbcb4qZSRp/l0mqdFEQ3X8G76XJMtEKAAGYVS7W9pXfxe3w+dQYrapB/goPFWM7mdaGxlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=OoCVahjd; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36c5f780600so1394185ab.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 20:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1714793798; x=1715398598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WrQPfuHK9ZPrb7b1skq1LAAIb1YBEYUCzbNgahRzdcQ=;
        b=OoCVahjdANs3s0S2Ga3oiBi/c79s1E8OA01KZqbdtWqw2xhpoMwLLMNU2sVewShCzI
         mUTbM5Hi3rVZE2at2AbA5hKPVHm7ZUgHLP/4ZgaIuN6UOMJwC1vgJvNp5wADWgYJ+7u7
         B0jww8dk81oc0tjmHJKSb30v5Aa1fgGAmJybXumfn/W7pexOtPoDAmwgW22VxIRe9NMd
         3i0uMFNONMTcgvLcEJQljsXPr+c41OYXzUSHGPTWHliLZ3Klj3xuJWkzk2aPF/okTjmN
         EKl8K5BQpQXkJ7bsTesPVeaqvSk9o2XihX8fruywddLX84AA6iBBbZhN7+pyQeHhaYue
         3PDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714793798; x=1715398598;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WrQPfuHK9ZPrb7b1skq1LAAIb1YBEYUCzbNgahRzdcQ=;
        b=XKqXGI7TwCuu4F81WC5SE2hRYOfkFQN+7ZZWkXmghI89/Z1NHl7Y2xgPAg6enBY5Kt
         H2XmJm422NkRYwFoLbqW3vFCV2TgatCOVG61t24OrjeZL0Q/syVQFXGthwu69jHVwbhI
         SWjqUOORQ/2LL9S5FkvGzw7LAJ6lC+MjJSrj7l8T/6CrpLt2r0eaM3vCPT6H0NOK+xY3
         7PO6FeAPXeZHPsXvvCM1ni/tZe10wm3TFl7jA5kWNGlFpt6zr2yG01WRURBBr5NIbuAP
         I9QC/A/VBUfpy9J00VR8zvkvbOQ/YFvG7gL68kcVS5Ef/66dZ2mcEgWKYwglWt+SGcaa
         7UDA==
X-Forwarded-Encrypted: i=1; AJvYcCWIwwLUlQYND4eRaeboFt7qDvfOAVNiXt44WNs/SCUPDouPMbsK2vmyh7Bxy6dNZRFquAa9aD+1PML3grCeBHaK438m
X-Gm-Message-State: AOJu0Ywet9lbCqjjuwYsQSr7oeCa2+q5ukGRBH+woQFyWfbFbRRt/895
	54KyyIGVCxuNiJaK1OP+hK7Xv5+v9xIwk362nU0s/aqoMeR2hT6/poLpTMLNNreDIvHbHdGfLBP
	hd74qqVcZ2snWKFgFNHmjDsNkZePS7fDk9edZzg==
X-Google-Smtp-Source: AGHT+IE+XMb9sTPv9u8dDdzHuc12dQbmwrRLhkJV+w0HApRFDG7vEhpWj6KAvofx5l8XLzMGT1U4LzxR6i2eDD2pXpQ=
X-Received: by 2002:a05:6e02:1aae:b0:36b:2a07:6767 with SMTP id
 l14-20020a056e021aae00b0036b2a076767mr6127246ilv.12.1714793798636; Fri, 03
 May 2024 20:36:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 4 May 2024 09:06:27 +0530
Message-ID: <CAAhSdy3C7N11wV8U7qMWsKtT2U+_G_FsW8EVMER8fkKHPgy8rg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.10
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following KVM RISC-V changes for 6.10:
1) Support guest breakpoints using ebreak
2) Introduce per-VCPU mp_state_lock and reset_cntx_lock
3) Virtualize SBI PMU snapshot and counter overflow interrupts
4) New selftests for SBI PMU and Guest ebreak

Please pull.

Regards,
Anup

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.10-1

for you to fetch changes up to 5ef2f3d4e747c7851678ad2b70e37be886a8c9eb:

  KVM: riscv: selftests: Add commandline option for SBI PMU test
(2024-04-26 13:14:15 +0530)

----------------------------------------------------------------
 KVM/riscv changes for 6.10

- Support guest breakpoints using ebreak
- Introduce per-VCPU mp_state_lock and reset_cntx_lock
- Virtualize SBI PMU snapshot and counter overflow interrupts

----------------------------------------------------------------
Atish Patra (24):
      RISC-V: Fix the typo in Scountovf CSR name
      RISC-V: Add FIRMWARE_READ_HI definition
      drivers/perf: riscv: Read upper bits of a firmware counter
      drivers/perf: riscv: Use BIT macro for shifting operations
      RISC-V: Add SBI PMU snapshot definitions
      RISC-V: KVM: Rename the SBI_STA_SHMEM_DISABLE to a generic name
      RISC-V: Use the minor version mask while computing sbi version
      drivers/perf: riscv: Fix counter mask iteration for RV32
      drivers/perf: riscv: Implement SBI PMU snapshot function
      RISC-V: KVM: Fix the initial sample period value
      RISC-V: KVM: No need to update the counter value during reset
      RISC-V: KVM: No need to exit to the user space if perf event failed
      RISC-V: KVM: Implement SBI PMU Snapshot feature
      RISC-V: KVM: Add perf sampling support for guests
      RISC-V: KVM: Support 64 bit firmware counters on RV32
      RISC-V: KVM: Improve firmware counter read function
      KVM: riscv: selftests: Move sbi definitions to its own header file
      KVM: riscv: selftests: Add helper functions for extension checks
      KVM: riscv: selftests: Add Sscofpmf to get-reg-list test
      KVM: riscv: selftests: Add SBI PMU extension definitions
      KVM: riscv: selftests: Add SBI PMU selftest
      KVM: riscv: selftests: Add a test for PMU snapshot functionality
      KVM: riscv: selftests: Add a test for counter overflow
      KVM: riscv: selftests: Add commandline option for SBI PMU test

Chao Du (3):
      RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
      RISC-V: KVM: Handle breakpoint exits for VCPU
      RISC-V: KVM: selftests: Add ebreak test support

Yong-Xuan Wang (2):
      RISCV: KVM: Introduce mp_state_lock to avoid lock inversion
      RISCV: KVM: Introduce vcpu->reset_cntx_lock

 arch/riscv/include/asm/csr.h                       |   5 +-
 arch/riscv/include/asm/kvm_host.h                  |  21 +-
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |  16 +-
 arch/riscv/include/asm/sbi.h                       |  38 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   1 +
 arch/riscv/kernel/paravirt.c                       |   6 +-
 arch/riscv/kvm/aia.c                               |   5 +
 arch/riscv/kvm/main.c                              |  18 +-
 arch/riscv/kvm/vcpu.c                              |  85 ++-
 arch/riscv/kvm/vcpu_exit.c                         |   4 +
 arch/riscv/kvm/vcpu_onereg.c                       |   6 +
 arch/riscv/kvm/vcpu_pmu.c                          | 260 +++++++-
 arch/riscv/kvm/vcpu_sbi.c                          |   7 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  42 +-
 arch/riscv/kvm/vcpu_sbi_pmu.c                      |  17 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      |   4 +-
 arch/riscv/kvm/vm.c                                |   1 +
 drivers/perf/riscv_pmu.c                           |   3 +-
 drivers/perf/riscv_pmu_sbi.c                       | 316 +++++++++-
 include/linux/perf/riscv_pmu.h                     |   8 +
 tools/testing/selftests/kvm/Makefile               |   2 +
 .../selftests/kvm/include/riscv/processor.h        |  49 +-
 tools/testing/selftests/kvm/include/riscv/sbi.h    | 141 +++++
 tools/testing/selftests/kvm/include/riscv/ucall.h  |   1 +
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  12 +
 tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |  82 +++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |   4 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   | 681 +++++++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c           |   4 +-
 30 files changed, 1674 insertions(+), 167 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/riscv/sbi.h
 create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
 create mode 100644 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c

