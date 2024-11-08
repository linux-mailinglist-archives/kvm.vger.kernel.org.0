Return-Path: <kvm+bounces-31253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 588B99C1C45
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DF20282FE9
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 11:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6089C1E47B2;
	Fri,  8 Nov 2024 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VYxTQUY/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730881E22FA
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 11:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731065868; cv=none; b=XAxHWUppmankdrA9hXiqgO9lHyvAkXj0K8D5+t0gMW0nCjA9Ig46Nefegoy6BjaDqaYIFqyHZ/gmWNgCePpmf5d+GURyHOuEUdSzRPJfmwHGG4fi9QQ9stghM86PU4X/odkKqiXkBTSy3EMOmpOVHb3S2fkeWMIr7Iwe/pBxD6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731065868; c=relaxed/simple;
	bh=kyf5fw0B6194YqwWfY8S7EexyJexO76CPyACncH8VQ0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uVYsd23lpcGhWe4onQ4S8RteYIzxSrRNt6o7ydI2YGHODjDSox6gWXOl48BMDHLbGYhWS5/agLCEkhzm+nqnvL4FBv0GNTyRqlsit7uO/bdWshuy6AWyMr+8DdOtS4JgEjUh3gtT9UTwSkGspi0PZAQVciBZjQqOLMAUaGTY+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=VYxTQUY/; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a4e5e57678so10086915ab.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 03:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1731065865; x=1731670665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uOXTxT3QVzkr6+CIu71XOWqnHn0lKuAZkobd+xubmCQ=;
        b=VYxTQUY/9apivZOy19QjYxAeSesmqSVm0qwM4LCx2f1ljMkcda3KqHuPmzSgV9s9RW
         40aJslzTGOKLRfwZ3BKLYcC+qkqdmVK1wt2aBk8QcH2bQmTEcSOL4ssKfk3XhqmSTSGK
         7wXIn7meQuL8/6hpr1EHdf+y5IU0KvC1kNt9aLuPQfyAHZTuffukUODjPDpf7J9an6dE
         Tqjro37MhNAqhxoiQY7WOgk/2FHiM0YNklKd+okgVrBveqqHoAtUpvAJwDem4FWDsX4b
         C/ZmKc6bU9SoOVWXhZ0oQrbf2lOxiIjiCqMqQX2P0FJIE4QMUyh3JQP4RG3l1ZsNBC82
         sT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731065865; x=1731670665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOXTxT3QVzkr6+CIu71XOWqnHn0lKuAZkobd+xubmCQ=;
        b=cp2CIIQRdXD/jxKvoxmamw1cyMuZ/u2vlcp4fxmUQftAIIXNcE2BGWhhaoNnjGFEku
         L9TomXliayIBuP/UNVm0zcw/nCzIPHYsAh4O53+XE5Yp9Ad593N3GATd6xzedgW7JEpC
         V1XBV2tKp91wHs/TmbTAAvbimne972trgwWPlSElN+sOajQID452XZqLx5KYwwOSQE+d
         WOl1Zz4FLb/+Qu7N27AP+uNmCcfi4r9AGCpXHo1+uXfTREBoSRy6gZIH+dgYkWFGs10o
         PEpyI/VPNikrrUcfqWxd7MmjhBJMWdG5xXnVJUSfqE3+hcF11QNqOGhQk/gnSb4oLh/j
         2bPg==
X-Forwarded-Encrypted: i=1; AJvYcCUBmJ5UGRGQW+DxZOP7y/bQlnNYM7tvB9l6S0zW06lV6MNVGt9bPvKd7aYiaehi0Kg9DIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY2P73MPWAQcrbsCusRYaMuxaWjcO4cchnb7zgDiGaFxUudztJ
	C4jP6aZQsVegkaw9a7ME4v1ajC5XqVVmU/x+wWfTL9UlIYXRVyWCmjox23Hss9vZP95/aSCaEbS
	y4ZfTIVTqdUijkyIzgsmTeiY9guMjSW3u/hREGw==
X-Google-Smtp-Source: AGHT+IF+ciN17ub4TIrETUvpzLaSq6I/9rWGP4XRPhpnawOHx3FcfWs8O7SeGXcL/Hobw0nycafCJTqEinG8leLSWHc=
X-Received: by 2002:a05:6e02:349c:b0:3a0:9c04:8047 with SMTP id
 e9e14a558f8ab-3a6f24b2433mr21370795ab.6.1731065865452; Fri, 08 Nov 2024
 03:37:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 8 Nov 2024 17:07:34 +0530
Message-ID: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.13
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.13:
1) Accelerate KVM RISC-V when running as a guest
2) Perf support to collect KVM guest statistics from host side

In addition, the pointer masking support (Ssnpm and
Smnpm) for KVM guest is going through the RISC-V tree.

I also have Svade and Svadu support for host and guest
in my queue which I will send in the second week of the
merge window to avoid conflict with the RISC-V tree.

Please pull.

Regards,
Anup

The following changes since commit 81983758430957d9a5cb3333fe324fd70cf63e7e=
:

  Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.13-1

for you to fetch changes up to 332fa4a802b16ccb727199da685294f85f9880cb:

  riscv: kvm: Fix out-of-bounds array access (2024-11-05 13:27:32 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.13

- Accelerate KVM RISC-V when running as a guest
- Perf support to collect KVM guest statistics from host side

----------------------------------------------------------------
Anup Patel (13):
      RISC-V: KVM: Order the object files alphabetically
      RISC-V: KVM: Save/restore HSTATUS in C source
      RISC-V: KVM: Save/restore SCOUNTEREN in C source
      RISC-V: KVM: Break down the __kvm_riscv_switch_to() into macros
      RISC-V: KVM: Replace aia_set_hvictl() with aia_hvictl_value()
      RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
      RISC-V: Add defines for the SBI nested acceleration extension
      RISC-V: KVM: Add common nested acceleration support
      RISC-V: KVM: Use nacl_csr_xyz() for accessing H-extension CSRs
      RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
      RISC-V: KVM: Use SBI sync SRET call when available
      RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
      RISC-V: KVM: Use NACL HFENCEs for KVM request based HFENCEs

Bj=C3=B6rn T=C3=B6pel (1):
      riscv: kvm: Fix out-of-bounds array access

Quan Zhou (2):
      riscv: perf: add guest vs host distinction
      riscv: KVM: add basic support for host vs guest profiling

Yong-Xuan Wang (1):
      RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation

 arch/riscv/include/asm/kvm_host.h   |  10 ++
 arch/riscv/include/asm/kvm_nacl.h   | 245 ++++++++++++++++++++++++++++++++=
++++
 arch/riscv/include/asm/perf_event.h |   6 +
 arch/riscv/include/asm/sbi.h        | 120 ++++++++++++++++++
 arch/riscv/kernel/perf_callchain.c  |  38 ++++++
 arch/riscv/kvm/Kconfig              |   1 +
 arch/riscv/kvm/Makefile             |  27 ++--
 arch/riscv/kvm/aia.c                | 114 +++++++++++------
 arch/riscv/kvm/aia_aplic.c          |   3 +-
 arch/riscv/kvm/main.c               |  63 +++++++++-
 arch/riscv/kvm/mmu.c                |   4 +-
 arch/riscv/kvm/nacl.c               | 152 ++++++++++++++++++++++
 arch/riscv/kvm/tlb.c                |  57 ++++++---
 arch/riscv/kvm/vcpu.c               | 191 +++++++++++++++++++++-------
 arch/riscv/kvm/vcpu_sbi.c           |  11 +-
 arch/riscv/kvm/vcpu_switch.S        | 137 ++++++++++++--------
 arch/riscv/kvm/vcpu_timer.c         |  28 ++---
 17 files changed, 1022 insertions(+), 185 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_nacl.h
 create mode 100644 arch/riscv/kvm/nacl.c

