Return-Path: <kvm+bounces-47660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 864CAAC3080
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 18:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93A317A11FB
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 16:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168D21EF39A;
	Sat, 24 May 2025 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="eY4uQTWI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C199823BE
	for <kvm@vger.kernel.org>; Sat, 24 May 2025 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748105613; cv=none; b=LcJRo5m09ZdBjh3GTkztNyJVEcJUNMAnGVRqV5sZTLnaf8cJhXdtIctJ0/weqBwofPlzdAWmM4rQQ5CpzMRJFCq115rP5/AC22sndV4nTjmjK8FmKxi2WJPr4Wt1iffvTb/pMdIlOBPz58sjpfxsLLxjKD2umdcqLSsDUTeBVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748105613; c=relaxed/simple;
	bh=Uu6hrwLmRSZi/RYBApTxXJqTp9Im7qqvmuCz0t5+a6A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=R7fnsKZNSYu1ts8tZyqh/NN5eLufs6nXF3I9GXuTF9T9NQRu/H3UUiNLcN5ILds0H8DhTIoxhCpaOMRy+LtxWCG2pwGvUYxamZdQqHLOZuxYlqvISakEEkeG+J9A7yUxSGSqM4v6IEiOS+inPR+UrcmV9MSb1dCzaNuWneO3kVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=eY4uQTWI; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so7899905ab.1
        for <kvm@vger.kernel.org>; Sat, 24 May 2025 09:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1748105611; x=1748710411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OwKoML0MAYDTPVb8TPExeUIOI27H3gCygqp9HjGFNzY=;
        b=eY4uQTWIXJPFzwPNgMATICQpRk7MOzjwiqX4iWblndIdeOdIKzNoDu/kjkllXc8lr6
         aAt4qZo/XJEdy/XqKlFbEmAWEVLClKtg81VhtoVhalMGqOiSmhYT0VIC9bus1QKgM8dQ
         PHwKZJfSdmHzg46d7BCRZUH3OKt/fhKh26ZUmCRVZ7FogHXZrzpFAifOuhDbsnHwghIU
         Hwt2qjq4ucYSg+k2vv5rqHfjiXdE4XoH8ciLGiiNOup9RHLZSzlFc9/AJspVljGj+4zg
         lGJXysl9szz0k5ucaBrLhfInApa/CCRt56f/vhiNozZ4dPtUj1z+4jcE0BQVulwyrWSa
         Xrqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748105611; x=1748710411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OwKoML0MAYDTPVb8TPExeUIOI27H3gCygqp9HjGFNzY=;
        b=VhW/+GUiw1Wk/DIN0EicG3MsXNaQ+Wx1X9jysqqd3lFO+4nGrl883ZRXfAAXZbpb1+
         FIJq6JMjsWxtgWd813G5vRXVdOWvujgFwc4fUM/ajVoJdA4PHu8Ds6fSwg93GbbBT6Vb
         8BAvarD3W2DrYTY4p7UWQknki30hBbx4lfEKaLWqqxNAbeIAGGPpE5trVe2Draf16itV
         20cczZILxPVnwJlQjxRphhjf4ZzuMNbMk4EFeMYLQxSzaK2j/9uttqkGAPnIpqn6UlLj
         eWnOUoYuhESVjWQB+pOAHWdcZl04cNNEwQ4Qs3hObrKcD6YNu2TUz2MmRucGXlMeM/bA
         vdEw==
X-Forwarded-Encrypted: i=1; AJvYcCWaIhh1BlaravXIFdwyNAplHD84K9akGk5rCnOdrH/miCrtmYTCFtPO79rIMQR5X9yazKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSm7cNEzZNBqP9uLJicm+yoe4RT66VONfkxddbVpKaTePPMuUZ
	TMQZtVOtx8ji5LDdTamQAeguxrWJaaLv7EmOZ26H4xJvF/MZTeVabRdtJY4z1gWuO8LK2Pp0EfY
	0xAYZJssb0oLiq4qlN4itqefTHNTtmrHWdCiVrrotSg==
X-Gm-Gg: ASbGncu62hxXhF4zwoEhO3Y+VjQ2f/U/BE5IWNamUtg7t44yDOX9IBA2DvVsQ53n+/7
	fbC+Wqjy3p8Wipn0rha6luyQkiDrRozOPkRs/RazaDM1rN8PepXDKgaujJfjtJqBp7NmPF1kqxC
	5QEtJFkjfaanZGo8x/V3OhrFUuKWLhnfP1MvNWnwk7wfc=
X-Google-Smtp-Source: AGHT+IG3vP7Okat+L0gtmmsR6qLRW5AcyZWw1gZgeAT1V7lWH3wF+08plur/vF9mezTOpwDjrxhK9jtoeEUsTU2WJM8=
X-Received: by 2002:a05:6e02:3981:b0:3dc:79e5:e696 with SMTP id
 e9e14a558f8ab-3dc9b6a1243mr30239315ab.11.1748105610710; Sat, 24 May 2025
 09:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 24 May 2025 22:23:19 +0530
X-Gm-Features: AX0GCFvRi28me7s3_9LFe9PyWAhydowqCM3SLbjRgOwG-lz7Nf5u5s4_a-20sKE
Message-ID: <CAAhSdy0H6GEBaY1NfCyF5O1PsHAmuxgW4mQyoC47bVFmMjqk-Q@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.16
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.16:
1) Add vector registers to get-reg-list selftest
2) VCPU reset related improvements
3) Remove scounteren initialization from VCPU reset
4) Support VCPU reset from userspace using set_mpstate() ioctl
    (NOTE: we have re-used KVM_MP_STATE_INIT_RECEIVED
     for this purpose since it is a temporary state. This way of
     VCPU reset only resets the register state and does not
     affect the actual VCPU MP_STATE. This new mechanism
     of VCPU reset can be used by KVM user space upon
     SBI system reset to reset the register state of the VCPU
     initiating SBI system reset. )

Please pull.

Regards,
Anup

The following changes since commit 87ec7d5249bb8ebf40261420da069fa238c21789=
:

  KVM: RISC-V: reset smstateen CSRs (2025-05-01 18:26:14 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.16-1

for you to fetch changes up to 7917be170928189fefad490d1a1237fdfa6b856f:

  RISC-V: KVM: lock the correct mp_state during reset (2025-05-24
21:30:47 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.16

- Add vector registers to get-reg-list selftest
- VCPU reset related improvements
- Remove scounteren initialization from VCPU reset
- Support VCPU reset from userspace using set_mpstate() ioctl

----------------------------------------------------------------
Atish Patra (5):
      KVM: riscv: selftests: Align the trap information wiht pt_regs
      KVM: riscv: selftests: Decode stval to identify exact exception type
      KVM: riscv: selftests: Add vector extension tests
      RISC-V: KVM: Remove experimental tag for RISC-V
      RISC-V: KVM: Remove scounteren initialization

Radim Kr=C4=8Dm=C3=A1=C5=99 (5):
      KVM: RISC-V: refactor vector state reset
      KVM: RISC-V: refactor sbi reset request
      KVM: RISC-V: remove unnecessary SBI reset state
      RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
      RISC-V: KVM: lock the correct mp_state during reset

 Documentation/virt/kvm/api.rst                     |  11 ++
 arch/riscv/include/asm/kvm_aia.h                   |   3 -
 arch/riscv/include/asm/kvm_host.h                  |  17 ++-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   3 +
 arch/riscv/include/asm/kvm_vcpu_vector.h           |   6 +-
 arch/riscv/kernel/head.S                           |  10 ++
 arch/riscv/kvm/Kconfig                             |   2 +-
 arch/riscv/kvm/aia_device.c                        |   4 +-
 arch/riscv/kvm/vcpu.c                              |  64 +++++-----
 arch/riscv/kvm/vcpu_sbi.c                          |  32 ++++-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  13 +-
 arch/riscv/kvm/vcpu_sbi_system.c                   |  10 +-
 arch/riscv/kvm/vcpu_vector.c                       |  13 +-
 arch/riscv/kvm/vm.c                                |  13 ++
 include/uapi/linux/kvm.h                           |   1 +
 .../selftests/kvm/include/riscv/processor.h        |  23 +++-
 tools/testing/selftests/kvm/lib/riscv/handlers.S   | 139 +++++++++++------=
----
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |   2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 132 +++++++++++++++++=
++
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  24 +++-
 22 files changed, 374 insertions(+), 152 deletions(-)

