Return-Path: <kvm+bounces-64932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B0EC91C1B
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 12:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90E293AB0A0
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 11:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CE330C372;
	Fri, 28 Nov 2025 11:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="XhX96mtd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7528A306D54
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 11:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764328173; cv=none; b=o66eBzQZil7OCWHk2nFywdou56C7PFRaBji24DuexBhNAldpFcuNOhp9tVUBnAr7KqjWciTBe0bJtwjbIW/8kpBFawZMajEYS52QckXJksbxgAcuqyX98yaksdt/qe/GIhLSHIDI2ExO1tiDMAvceRcTflT8iI/7iQ1mB4+4kWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764328173; c=relaxed/simple;
	bh=/OCtPtLEn5ROYinh+dCP6hViP0o0Y3ftVujZQstf4TI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sf6nswPkX2elsWYKyJSNwH1ctFTXkHUM7WoSbcWQU/kdS1k4RY2ul6FCNiRCy42R/4sS4YRHsJvP6UdhOtynyrOvVtRPC7SdpZT/XUNxoja8DR0j19T6fA4NYA7cNOBMCJ7UgrCsI/7oC3q7DQW6RkJVyQ/eJpEFQoUyRv38uP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=XhX96mtd; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4330dfb6ea3so6592295ab.0
        for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 03:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1764328170; x=1764932970; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ev8osqQslZ1HDuUmpz2SAJrU4WVNGotFbl7NHJTtz5M=;
        b=XhX96mtdURWfy5UGDKaMzwuNS1bGpbfla16o5XwiDOwyvM3uw69nKyPKTszO3LvoTu
         j/KNBOXh83ja5xI9no3YJ20rnpsbY7I87yTgfhiSIVU/02lPgC0Zj3wdOgkYLk1/F4Jm
         6b41eUEFXp8fkqPF5j/IaYaiayHs94OEK/eVHfCDiCxeyZZPJTOOqRBrnj2RGyZWUR92
         ttw3KGNVUx7lvYy9vIDMRO4jRXF4DD9y5g1LJJlxFaKltXwLpnUVJ/KHTpHU2tP4Fpec
         5be/CfQQ1qRiAnLGrWgfFiVljp+IgyWRa5A2qwtxJCZAnC7PdGTqZYwp9liMVYw5TiSU
         PlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764328170; x=1764932970;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ev8osqQslZ1HDuUmpz2SAJrU4WVNGotFbl7NHJTtz5M=;
        b=WGo6JhDpMizYW62KWGjQGomCDesPftRUXdY+jeQTx+K8+j33KC0vJgFRoLfclpWcSY
         uGxpnnUWpvq0ooiCpkDHRmDFpeUpEQXuWcrxVLnp3phqfDIfqTPmOzOxz8KI+wdRPNrW
         wbEdRQKKjwdsW/PyGYW3BeIkdlnf9RK5EflMgop/cqY25dO3B0d9y0+A4iXVltdMvQ6s
         weE+gBEi+7YHy3EsMDEnL31YhV6deBEVtBNxhNZ5MkCzAJQqDqiLSlkPqbdfe6ulpA77
         VKMDV75SnAto8g8tzROpA4ViQRIvesdwZL7PIrZgSOmagcnWAk54oMI3biV0eB5wHq6K
         SJzA==
X-Forwarded-Encrypted: i=1; AJvYcCW2F+mhcEHjad8kMHuixUrQ4F64STt7ak3a2DwrV6On9WF5GidT9QucmgYQt2m2QvVJI9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFp6Sydi6zmjmuWu3lJLabFRO5wp1wVq/CoPMuTBS8Vb1kmehn
	0nQcqNMme2FQ/f8vLEFFpqJUHHBSmU21PrFXrxRdKo5BYNt/Ow5qWMt9DLrsi/CuP6d5MLEG7I+
	f/dtS2uFnljwvwEQ/DPsUtllIJkbJUAbdyeq0qdd2Mg==
X-Gm-Gg: ASbGnctO6LzmIdgaDQ2LStSSPX/dqqoYUOdd0Qqr2kPnITiS6I0ox67KInBpHHlSwmf
	aJrECNDPPAmmIzJwDh8ADRmBFyNGnpqWqnAS/KVoPuavx5UJhf3f0IhBz7HRi9V3LjWjm3f3XK+
	o6+avnwZampGSS3FA8vAUyyoD6XPG2PaaVEYIpFcZQ7rR2nkKyfpzi7SxsTF/DaptFN0/bXrtYz
	9gMbEMrG47eNS2Fl3yKUvs/VTYiwEnjOu4rtpgtOw0THuJ1XKOSyBePVRcZtqeWgr8GdGI=
X-Google-Smtp-Source: AGHT+IFc/ry5UpHjP3r/OfTOToFIN7uuwb7cq3NZruvPD9SmePUAvE+8mJAN0tC4qknnjQrfmNXoFUaXRVof3Et5lUs=
X-Received: by 2002:a05:6e02:1fe8:b0:433:7e25:b93d with SMTP id
 e9e14a558f8ab-435b98e6823mr258774305ab.28.1764328170460; Fri, 28 Nov 2025
 03:09:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 28 Nov 2025 16:39:20 +0530
X-Gm-Features: AWmQ_bmhFxPdJkF-zIY_yLVqZOdy6yi8l1326gMlp_2aI20DPgm8qhw27bUypWs
Message-ID: <CAAhSdy3C7zxovYDZJvzpuCytRmdBrGwgLF2MtOMzP7vFVm4ohQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.19
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atish.patra@linux.dev>, 
	Atish Patra <atishp@rivosinc.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following KVM RISC-V changes for 6.19:
1) SBI MPXY support for KVM guest
2) New KVM_EXIT_FAIL_ENTRY_NO_VSFILE
3) Enable dirty logging gradually in small chunks
4) Fix guest page fault within HLV* instructions
5) Flush VS-stage TLB after VCPU migration for Andes cores

Please pull.

Regards,
Anup

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.19-1

for you to fetch changes up to 3239c52fd21257c80579875e74c9956c2f9cd1f9:

  RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores
(2025-11-24 09:55:36 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.19

- SBI MPXY support for KVM guest
- New KVM_EXIT_FAIL_ENTRY_NO_VSFILE for the case when in-kernel
  AIA virtualization fails to allocate IMSIC VS-file
- Support enabling dirty log gradually in small chunks
- Fix guest page fault within HLV* instructions
- Flush VS-stage TLB after VCPU migration for Andes cores

----------------------------------------------------------------
Anup Patel (4):
      RISC-V: KVM: Convert kvm_riscv_vcpu_sbi_forward() into extension handler
      RISC-V: KVM: Add separate source for forwarded SBI extensions
      RISC-V: KVM: Add SBI MPXY extension support for Guest
      KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list

BillXiang (1):
      RISC-V: KVM: Introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE

Dong Yang (1):
      KVM: riscv: Support enabling dirty log gradually in small chunks

Fangyu Yu (1):
      RISC-V: KVM: Fix guest page fault within HLV* instructions

Hui Min Mina Chou (1):
      RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores

 Documentation/virt/kvm/api.rst                   |  2 +-
 arch/riscv/include/asm/kvm_host.h                |  6 +++++
 arch/riscv/include/asm/kvm_tlb.h                 |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h            |  5 +++-
 arch/riscv/include/asm/kvm_vmid.h                |  1 -
 arch/riscv/include/uapi/asm/kvm.h                |  3 +++
 arch/riscv/kvm/Makefile                          |  1 +
 arch/riscv/kvm/aia_imsic.c                       |  2 +-
 arch/riscv/kvm/main.c                            | 14 ++++++++++
 arch/riscv/kvm/mmu.c                             |  5 +++-
 arch/riscv/kvm/tlb.c                             | 30 +++++++++++++++++++++
 arch/riscv/kvm/vcpu.c                            |  2 +-
 arch/riscv/kvm/vcpu_insn.c                       | 22 +++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c                        | 10 ++++++-
 arch/riscv/kvm/vcpu_sbi_base.c                   | 28 +------------------
 arch/riscv/kvm/vcpu_sbi_forward.c                | 34 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_replace.c                | 32 ----------------------
 arch/riscv/kvm/vcpu_sbi_system.c                 |  4 +--
 arch/riscv/kvm/vcpu_sbi_v01.c                    |  3 +--
 arch/riscv/kvm/vmid.c                            | 23 ----------------
 tools/testing/selftests/kvm/riscv/get-reg-list.c |  4 +++
 21 files changed, 138 insertions(+), 94 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c

