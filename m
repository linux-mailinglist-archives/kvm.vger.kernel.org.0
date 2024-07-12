Return-Path: <kvm+bounces-21502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D52B92F9FF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 14:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0364282C8D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 12:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4F416CD30;
	Fri, 12 Jul 2024 12:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Bti3umhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CB6D512
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 12:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720786298; cv=none; b=mwaXxQAd9ftsWdJGBMYuDfnmMbM0gYzYTHCVsnkF5TXB//sbvpxK4BUcnhglIDtDELhbhdUlSn6TtAb2I2NVl1KbuLjKVPAiUHpUKnQp2Gfwm03NXIR9BkXkwBWkCuuc8ZJDribC+eUralP5fOwM4DMiIApenwwmWdSaGwg29JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720786298; c=relaxed/simple;
	bh=qJ/uuD8yxptnuLEFl+UlN58lw1ZU70gDZlM4te8sjzA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=P/Cs1z2Pz68ElCAdFqvhhWyF6bRySsvc2gm+QXWfxZmkF2KBrq1Y/EsznenbN4uV6Z4Sx9DEAvICxx9N+LQQq3y5ejjs5sbFgBs3JCDh5tys7gkPe5Ts18WGsTAlG4w3WC5pwtNEIZ+4LeZRJo4k688LEPOaV1h90Srec4wUYhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Bti3umhR; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-380bfd7cdbfso6970395ab.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 05:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1720786295; x=1721391095; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q1niRraCjqeMyr5cX7PxOFIQ0Sj5Bx+cbn9dmwhfVKo=;
        b=Bti3umhR8SChmYozhjYyTQr8sqf9LArfmA883HXBnI3UkztbyP6VCi4W+FsuscC06M
         iMDvPgmScw5dhvp2JX2cKaHL8J5EygQSQzqacKcpV7ny9Xv2dhZVzENAIQ+0RVKBlkSX
         HiCwPvD8l0Og3O3PC/lpOlMmfkY2ymKxeVa20TKrwB8Hze6yaGhur29+0Wdmm5Xc5ale
         6RnI41pdm0ZkJ4mWfBJfWnHi6LhDOZZILtImksmxVMCW49zVPfdW1lSVroTcOzRhPJ1l
         MLs+8I84ZsX3gYeAgbpwHrycK00n3Ki1iAA/FcQQYSi99/E/pB8XI32CJ/t4hv8QIDW3
         /ZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720786295; x=1721391095;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q1niRraCjqeMyr5cX7PxOFIQ0Sj5Bx+cbn9dmwhfVKo=;
        b=GueE4FnyU3qQf8JsyIwnsuliCOKL2QNKe5SFpMBNHhXCvd/+F/eNwlzy6Mu1sl40Ek
         K1pbCnw73ZjsJ2/ViXDL2VXuEYASCUvLA4YT7aLqW5eUMh2LZd3m2EM9bBOVutqmW406
         Ey785xPlfNSqtpOTiUrt3tCieUXX7ah8Arb9ERhxJ1EyqdGyPH8H538nmV6xBydGnLB+
         mDTCZzPEvByyUIKZH+oJLyJORk79ajtgqDIdVHkd7hVkF8Q9FnX51PJhOnkOU53WY3kk
         l0O9FDBRI0KWDD594ramjHFbgqbXNfuuPeLqjJ5YahgmWLK5o2z8dR+EkOE8QyqC3IGH
         leFw==
X-Forwarded-Encrypted: i=1; AJvYcCXzk9j7UUwnPghLfWMF/4+zZSoLtrXm28v9yZD+b4/xgq7NFSfRiJ6av96iRrqe+UMCd405CTtkW9hkcBfs3ss7pKZz
X-Gm-Message-State: AOJu0Yz78TmSfPJ8LUcqs6+lWAAzWX1aIlUsrR4XcY65B+Uo+Ih07vk/
	XSPfeXR56dy+o05UC638Hh3z/qjiJB3NZgd/UOa7emImk1OoM+Ta+AL6CuQITHwlYLqKC/B3WWG
	ZVYjG3iXDPWGhCLthArkR05cUHQPCuUIWm6qVhw==
X-Google-Smtp-Source: AGHT+IGw1561bmQ8Hies93tHQqB5Q5PqXZjp1CmRpstemMFKZKHlxBTBLx9rL+qxO1iavYhxYJ4+gikZG1emGlfAd4M=
X-Received: by 2002:a05:6e02:1aaa:b0:37a:a9f0:f263 with SMTP id
 e9e14a558f8ab-38a5910a9dbmr139026545ab.20.1720786295403; Fri, 12 Jul 2024
 05:11:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 12 Jul 2024 17:41:22 +0530
Message-ID: <CAAhSdy0jae8TYcbChockXDJ9qL+HnA1p3YJQi32NHQsLUtCGDA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.11
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following KVM RISC-V changes for 6.11:
1) Redirect AMO load/store access fault traps to guest
2) Perf kvm stat support for RISC-V
3) Use HW IMSIC guest files when available

In addition to above, ONE_REG support for Zimop,
Zcmop, Zca, Zcf, Zcd, Zcb and Zawrs ISA extensions
is going through the RISC-V tree.

Please pull.

Regards,
Anup

The following changes since commit 0fc670d07d5de36a54f061f457743c9cde1d8b46:

  KVM: selftests: Fix RISC-V compilation (2024-06-06 15:53:16 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.11-1

for you to fetch changes up to e325618349cdc1fbbe63574080249730e7cff9ea:

  RISC-V: KVM: Redirect AMO load/store access fault traps to guest
(2024-06-26 18:37:41 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.11

- Redirect AMO load/store access fault traps to guest
- Perf kvm stat support for RISC-V
- Use HW IMSIC guest files when available

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Share APLIC and IMSIC defines with irqchip drivers
      RISC-V: KVM: Use IMSIC guest files when available

Shenlin Liang (2):
      RISCV: KVM: add tracepoints for entry and exit events
      perf kvm/riscv: Port perf kvm stat to RISC-V

Yu-Wei Hsu (1):
      RISC-V: KVM: Redirect AMO load/store access fault traps to guest

 arch/riscv/include/asm/kvm_aia_aplic.h             | 58 ----------------
 arch/riscv/include/asm/kvm_aia_imsic.h             | 38 -----------
 arch/riscv/kvm/aia.c                               | 35 ++++++----
 arch/riscv/kvm/aia_aplic.c                         |  2 +-
 arch/riscv/kvm/aia_device.c                        |  2 +-
 arch/riscv/kvm/aia_imsic.c                         |  2 +-
 arch/riscv/kvm/trace.h                             | 67 +++++++++++++++++++
 arch/riscv/kvm/vcpu.c                              |  7 ++
 arch/riscv/kvm/vcpu_exit.c                         |  2 +
 tools/perf/arch/riscv/Makefile                     |  1 +
 tools/perf/arch/riscv/util/Build                   |  1 +
 tools/perf/arch/riscv/util/kvm-stat.c              | 78 ++++++++++++++++++++++
 tools/perf/arch/riscv/util/riscv_exception_types.h | 35 ++++++++++
 13 files changed, 215 insertions(+), 113 deletions(-)
 delete mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 delete mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
 create mode 100644 arch/riscv/kvm/trace.h
 create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
 create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h

