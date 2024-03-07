Return-Path: <kvm+bounces-11269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 932C7874849
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AC832858E4
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 06:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203D81CD2B;
	Thu,  7 Mar 2024 06:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="CXpAODOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A691CD09
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 06:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709793936; cv=none; b=Lrc9r6F35iv9uWLdd1eF3vkoRz2g56iSBap260uebu7TLYFkZipa5hPKX7BNFlRWfEBhPd64nSTc+g15274Y84/w+Xz/C2eVGnysDBRRmPO+yYdsirktdFgAS3Hze0mdtmg/1awlpuUsfys+HvfcRArKvZYIvGiDbnLIHOGvjqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709793936; c=relaxed/simple;
	bh=kcFAZLOrsQBXjwobOxNc+Lpb6gsfmodsQ6hHBuv3gwU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=F+9lecCbxNItjR4mQWZQtc7t0AKwO1IDE4r15Ej1uvkOdkeN601KMsW7au/ESuza6bkExEvnCnJO1+Ks1I44pKmgJfxt4p01cM4/gpE0xBA2cczi+ryfgsCzVvxhgGu5ss8TsMyg5WuaQInXRxco5XCelzW/R+RcHqWYiX4cOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=CXpAODOJ; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36576b35951so2177815ab.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 22:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709793933; x=1710398733; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jFdoT6NxUd7wijjg0PVr8J+9hYlZ4u3LPtuf4wizZgI=;
        b=CXpAODOJaE01UKwJBGvJslSTsqL2dSKeZ0Gh5ZenUk58FfRxZFqgUp1vpySXkH2fp0
         aOiZ3VPV5/mUYovJv5qXfCF4lAW5y1ztSmf3cccm/+24LYU/CWF4zLXUw85+c06uGbzA
         0kIQ/7A9lA1zTbZeMG44cH2ZdOySDM3fFSvzM36GidBm7/ACYwMDXX3rAb4MAVPr2grv
         oMjiGc31otixZM94zdQWBvJPekb8wb7BXzmD1eaXNaAxSpLOB4PRfu4sx/b5IZqJT/R6
         eM0AfyjsB5XK7r1hH/2y2uL6oKI5BQgqImtp+TodNDdFzQ+ahPa8x1UIlx04yojqlwkL
         UA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709793933; x=1710398733;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFdoT6NxUd7wijjg0PVr8J+9hYlZ4u3LPtuf4wizZgI=;
        b=dUw7hyw6ym14eFC8GPhrtYpoKY70cVpiQd6fzzw/LzX8hzz2GtWHwmTws8WuMc4Nn2
         n2W8uReup7quoQKW5c/a4dgVVhv7dbJw0BljIFyKlhC1z/lo25ZdHftLqirpEri1Elf2
         sRl2qnIpKqIY0BmqzzkSPWQIhbu1G1HALTU7JexjUr66H2HGoARNSj3fcyeV9UaRNthX
         TUBS0ZjXtxayjQR+rd3yHJKYfIGn8YHOhrdGqOK4w8ayAwqYdToMwd+Oxhjo5tmHnNgh
         5GvdzMdK5isSSKEPH1JL7DcdfeVGBZk61bSc++KSuHu7AQhb0OdfWrKpvUB9f0NrpuJi
         pOQg==
X-Forwarded-Encrypted: i=1; AJvYcCVkzspGTCVZ2qpr52IXvSWC9tguPd7zpTMWoph7JgHpZI5eTffoXkydoOGl4o9i/6O6axfzaK2m4dzm69ZzR61a+Jnh
X-Gm-Message-State: AOJu0Yxctiz593ZKifSDIZQgpCVe865o0paheiVkPyVcxty7BlIQig6w
	YsyhfoNYnltfJeyZ0cAjBnE6cvemvX/KpTkbjYrI5EjIo5tY+Oyc2+cb2psbhAOz+JVLawuMKhs
	yh2lYyGwiEsfeE3UTmuhxTMv7CQ9vpiNrUpNBnCTJr6C+Ea6cirQ=
X-Google-Smtp-Source: AGHT+IF968ZqmYYThRYVmnBpyJc6Q8Hnnpb/12/shALsyC4DrXEZfzmp+mUo2vV3lFDMBhD2/0h1w0r5r0TJ414mxHs=
X-Received: by 2002:a05:6e02:148d:b0:365:1dd9:ee6b with SMTP id
 n13-20020a056e02148d00b003651dd9ee6bmr25804253ilk.25.1709793933163; Wed, 06
 Mar 2024 22:45:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Thu, 7 Mar 2024 12:15:21 +0530
Message-ID: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.9
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following KVM RISC-V changes for 6.9:
1) Exception and interrupt handling for selftests
2) Sstc (aka arch_timer) selftest
3) Forward seed CSR access to KVM user space
4) Ztso extension support for Guest/VM
5) Zacas extension support for Guest/VM

Please pull.

Regards,
Anup

The following changes since commit d206a76d7d2726f3b096037f2079ce0bd3ba329b:

  Linux 6.8-rc6 (2024-02-25 15:46:06 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.9-1

for you to fetch changes up to d8c0831348e78fdaf67aa95070bae2ef8e819b05:

  KVM: riscv: selftests: Add Zacas extension to get-reg-list test
(2024-03-06 20:53:44 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.9

- Exception and interrupt handling for selftests
- Sstc (aka arch_timer) selftest
- Forward seed CSR access to KVM userspace
- Ztso extension support for Guest/VM
- Zacas extension support for Guest/VM

----------------------------------------------------------------
Anup Patel (5):
      RISC-V: KVM: Forward SEED CSR access to user space
      RISC-V: KVM: Allow Ztso extension for Guest/VM
      KVM: riscv: selftests: Add Ztso extension to get-reg-list test
      RISC-V: KVM: Allow Zacas extension for Guest/VM
      KVM: riscv: selftests: Add Zacas extension to get-reg-list test

Haibo Xu (11):
      KVM: arm64: selftests: Data type cleanup for arch_timer test
      KVM: arm64: selftests: Enable tuning of error margin in arch_timer test
      KVM: arm64: selftests: Split arch_timer test code
      KVM: selftests: Add CONFIG_64BIT definition for the build
      tools: riscv: Add header file csr.h
      tools: riscv: Add header file vdso/processor.h
      KVM: riscv: selftests: Switch to use macro from csr.h
      KVM: riscv: selftests: Add exception handling support
      KVM: riscv: selftests: Add guest helper to get vcpu id
      KVM: riscv: selftests: Change vcpu_has_ext to a common function
      KVM: riscv: selftests: Add sstc timer test

Paolo Bonzini (1):
      selftests/kvm: Fix issues with $(SPLIT_TESTS)

 arch/riscv/include/uapi/asm/kvm.h                  |   2 +
 arch/riscv/kvm/vcpu_insn.c                         |  13 +
 arch/riscv/kvm/vcpu_onereg.c                       |   4 +
 tools/arch/riscv/include/asm/csr.h                 | 541 +++++++++++++++++++++
 tools/arch/riscv/include/asm/vdso/processor.h      |  32 ++
 tools/testing/selftests/kvm/Makefile               |  27 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   | 295 +----------
 tools/testing/selftests/kvm/arch_timer.c           | 259 ++++++++++
 .../selftests/kvm/include/aarch64/processor.h      |   4 -
 .../testing/selftests/kvm/include/kvm_util_base.h  |   2 +
 .../selftests/kvm/include/riscv/arch_timer.h       |  71 +++
 .../selftests/kvm/include/riscv/processor.h        |  72 ++-
 tools/testing/selftests/kvm/include/test_util.h    |   2 +
 tools/testing/selftests/kvm/include/timer_test.h   |  45 ++
 tools/testing/selftests/kvm/lib/riscv/handlers.S   | 101 ++++
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  87 ++++
 tools/testing/selftests/kvm/riscv/arch_timer.c     | 111 +++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  19 +-
 18 files changed, 1380 insertions(+), 307 deletions(-)
 create mode 100644 tools/arch/riscv/include/asm/csr.h
 create mode 100644 tools/arch/riscv/include/asm/vdso/processor.h
 create mode 100644 tools/testing/selftests/kvm/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/riscv/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/timer_test.h
 create mode 100644 tools/testing/selftests/kvm/lib/riscv/handlers.S
 create mode 100644 tools/testing/selftests/kvm/riscv/arch_timer.c

