Return-Path: <kvm+bounces-7214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D12E083E474
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001461C2173E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532082555E;
	Fri, 26 Jan 2024 22:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wbcunhWo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD6B25543
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306654; cv=none; b=Ye/dcyTHrBBPA1IrJCX2gIHrOavD5QREd1vIKaCfsJt0RPEzaVR0c0ztE46h5XJOof00zD8JVO/m6yBkPNKPKBeRIZHJC6kvRKKEf5+cjzhuIQ/rqcA0ijiekMmqvN2GnJ06nEDVRp1OfURSBZqU0TF7+7Ai4nNViDPKEgWXWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306654; c=relaxed/simple;
	bh=DkgttLBAlymmd03MCZsAV1//umks8Npk86CTHI2wLbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dCrlOCeMhYga+tkoKfjyGmB3t7odCPkOYPkSyIyLA5PEvJoeDfnXde5VcMGMdbRZuor52rVZaSyAVr9wPJL96SFXXEfm8Nww4TQl6WnEKYh9xo0QRFLIOOslwAyqAARt0261PUv5o4ZC1eWGnr+TDIhIeb5ABCJXqJF/7q/35Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wbcunhWo; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55817a12ad8so633753a12.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306650; x=1706911450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tLDD+gX81/flexkUVsp4uo9ttE0hN1WJun7ndqYAwQ4=;
        b=wbcunhWoDg4hFICL4ioNTqD26HcxAxuxfFKy8hH3wUZg4UXvpbRVomQLZczmUJGJ3K
         ydk/C0JcyXVlwROQn0SMy1uVcI7v1ZfIwYqPbsjQvzzRmizP+oZGvw3GG5IbplRZYvKE
         I99H6/JVj6p303I3l/sygP073q46WtWJ3CicieGt4exilm9FQQjXoI1Vt+mlEhHs4org
         Rc1/PTEpNKtok5Y/Xd716rJDrVqZch/FAkqMIZ4aNfln6XdV8yUOEHENF726JTiRQU/K
         SoW+Dg42TPhulfPQrxdN4ausN7HS4I0ZV+oRR16sRQTTHvfaFNf6D2PGl8ArWtnL6hYf
         aKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306650; x=1706911450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLDD+gX81/flexkUVsp4uo9ttE0hN1WJun7ndqYAwQ4=;
        b=cynSjdImDSHldR018wNystSOtIMbNc7h3tQ0S/rK4AqgnQIWI87O7lxgI4BXnUc5f4
         oKYRbtUL0TIMpJnrKqjGnNpQTyruuHUV4s/267NX4r2UQdZrLhrduFcOAXai4xMict6j
         RKU4rsvgt4JaUBBLhVOaLRIRk+/M0Z/QDKJaI1fChGQFhYrNhb1Obh2fDNE65+S6ZsLT
         Xw6+yH9Jwc4LRimtceo8OkoipvdxgeuNo1FBhg7Ssv1NAXeMZuNzaevx7WvApCtkfCHB
         kOCHSqr1RkvY1HqpDXJV727Jm4EmK8EAWZz3J5UQCHBkWTqogbnARSiGX38HUX5F/BlL
         t0tA==
X-Gm-Message-State: AOJu0Yzyfi9RzVoOAXETcZl5qnCGeyHh9mZcvE/afYEFWM6eJW3SJjEC
	thWjcxq1hQNT54b7FZ5fgqXxHLmdneVnBVJsVs52bky/WdxTIbQAB4kJPo7kKT8F8GsepcWsTuF
	+
X-Google-Smtp-Source: AGHT+IGWhZXaRIHB9nwyS9lCEMvqEDeCuORw5KmVreqBxAf4Gq4cXJxAPlMEFjgBo9HmOpkFYvI2/A==
X-Received: by 2002:aa7:dc0f:0:b0:55c:d474:56dc with SMTP id b15-20020aa7dc0f000000b0055cd47456dcmr203467edu.39.1706306650281;
        Fri, 26 Jan 2024 14:04:10 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id q15-20020a056402032f00b0055ce4ea1c81sm1006182edw.89.2024.01.26.14.04.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:09 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 00/23] hw,target: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:42 +0100
Message-ID: <20240126220407.95022-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Use cpu_env() -- which is fast path -- when possible.
Bulk conversion using Coccinelle spatch (script included).

Since v1:
- Avoid CPU() cast (Paolo)
- Split per targets (Thomas)

Philippe Mathieu-Daudé (23):
  hw/acpi/cpu: Use CPUState typedef
  scripts/coccinelle: Add cpu_env.cocci_template script
  bulk: Call in place single use cpu_env()
  target/alpha: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/arm: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/avr: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/cris: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/hppa: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/i386/hvf: Use CPUState typedef
  target/i386: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/m68k: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/microblaze: Prefer fast cpu_env() over slower CPU QOM cast
    macro
  target/mips: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/nios2: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/openrisc: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/ppc: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/riscv: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/rx: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/s390x: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/sh4: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/tricore: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/xtensa: Prefer fast cpu_env() over slower CPU QOM cast macro
  target/sparc: Prefer fast cpu_env() over slower CPU QOM cast macro

 MAINTAINERS                               |  1 +
 include/hw/acpi/cpu.h                     |  2 +-
 target/i386/hvf/vmx.h                     | 13 +---
 target/i386/hvf/x86.h                     | 26 +++----
 target/i386/hvf/x86_descr.h               | 14 ++--
 target/i386/hvf/x86_emu.h                 |  4 +-
 target/i386/hvf/x86_mmu.h                 |  6 +-
 accel/tcg/cpu-exec.c                      |  3 +-
 hw/i386/vmmouse.c                         |  6 +-
 hw/i386/xen/xen-hvm.c                     |  3 +-
 hw/intc/arm_gicv3_cpuif_common.c          |  5 +-
 hw/ppc/mpc8544_guts.c                     |  3 +-
 hw/ppc/pnv.c                              |  3 +-
 hw/ppc/pnv_xscom.c                        |  5 +-
 hw/ppc/ppce500_spin.c                     |  3 +-
 hw/ppc/spapr.c                            |  3 +-
 hw/ppc/spapr_caps.c                       |  6 +-
 linux-user/i386/cpu_loop.c                |  4 +-
 target/alpha/cpu.c                        | 31 ++------
 target/alpha/gdbstub.c                    |  6 +-
 target/alpha/helper.c                     | 12 +--
 target/alpha/mem_helper.c                 | 11 +--
 target/arm/cpu.c                          | 19 ++---
 target/arm/debug_helper.c                 |  8 +-
 target/arm/gdbstub.c                      |  6 +-
 target/arm/gdbstub64.c                    |  6 +-
 target/arm/helper.c                       |  9 +--
 target/arm/hvf/hvf.c                      | 12 +--
 target/arm/kvm.c                          |  3 +-
 target/arm/ptw.c                          |  3 +-
 target/arm/tcg/cpu32.c                    |  3 +-
 target/avr/cpu.c                          | 27 ++-----
 target/avr/gdbstub.c                      |  6 +-
 target/avr/helper.c                       | 10 +--
 target/cris/cpu.c                         |  5 +-
 target/cris/gdbstub.c                     |  9 +--
 target/cris/helper.c                      | 12 +--
 target/cris/translate.c                   |  3 +-
 target/hppa/cpu.c                         |  8 +-
 target/hppa/int_helper.c                  |  8 +-
 target/hppa/mem_helper.c                  |  6 +-
 target/hppa/translate.c                   |  3 +-
 target/i386/arch_memory_mapping.c         |  3 +-
 target/i386/cpu-dump.c                    |  3 +-
 target/i386/cpu.c                         | 37 +++------
 target/i386/helper.c                      | 39 +++-------
 target/i386/hvf/hvf.c                     |  8 +-
 target/i386/hvf/x86.c                     | 30 ++++----
 target/i386/hvf/x86_descr.c               |  8 +-
 target/i386/hvf/x86_emu.c                 |  6 +-
 target/i386/hvf/x86_mmu.c                 | 14 ++--
 target/i386/hvf/x86_task.c                | 10 +--
 target/i386/hvf/x86hvf.c                  |  6 +-
 target/i386/kvm/kvm.c                     |  6 +-
 target/i386/kvm/xen-emu.c                 | 32 +++-----
 target/i386/nvmm/nvmm-all.c               |  6 +-
 target/i386/tcg/sysemu/bpt_helper.c       |  3 +-
 target/i386/tcg/tcg-cpu.c                 | 14 +---
 target/i386/tcg/user/excp_helper.c        |  3 +-
 target/i386/tcg/user/seg_helper.c         |  3 +-
 target/i386/whpx/whpx-all.c               | 18 ++---
 target/loongarch/tcg/translate.c          |  3 +-
 target/m68k/cpu.c                         | 30 +++-----
 target/m68k/gdbstub.c                     |  6 +-
 target/m68k/helper.c                      |  3 +-
 target/m68k/m68k-semi.c                   |  6 +-
 target/m68k/op_helper.c                   | 11 +--
 target/m68k/translate.c                   |  3 +-
 target/microblaze/helper.c                |  3 +-
 target/microblaze/translate.c             |  3 +-
 target/mips/cpu.c                         | 11 +--
 target/mips/gdbstub.c                     |  6 +-
 target/mips/kvm.c                         | 27 +++----
 target/mips/sysemu/physaddr.c             |  3 +-
 target/mips/tcg/exception.c               |  3 +-
 target/mips/tcg/op_helper.c               |  3 +-
 target/mips/tcg/sysemu/special_helper.c   |  3 +-
 target/mips/tcg/sysemu/tlb_helper.c       |  6 +-
 target/mips/tcg/translate.c               |  3 +-
 target/nios2/cpu.c                        | 15 +---
 target/nios2/helper.c                     |  3 +-
 target/nios2/nios2-semi.c                 |  6 +-
 target/openrisc/gdbstub.c                 |  3 +-
 target/openrisc/interrupt.c               |  6 +-
 target/openrisc/translate.c               |  3 +-
 target/ppc/cpu_init.c                     | 11 +--
 target/ppc/excp_helper.c                  |  3 +-
 target/ppc/gdbstub.c                      | 12 +--
 target/ppc/kvm.c                          |  6 +-
 target/ppc/ppc-qmp-cmds.c                 |  3 +-
 target/ppc/user_only_helper.c             |  3 +-
 target/riscv/arch_dump.c                  |  6 +-
 target/riscv/cpu.c                        | 17 ++---
 target/riscv/cpu_helper.c                 | 14 +---
 target/riscv/debug.c                      |  9 +--
 target/riscv/gdbstub.c                    |  6 +-
 target/riscv/kvm/kvm-cpu.c                |  6 +-
 target/riscv/tcg/tcg-cpu.c                |  9 +--
 target/riscv/translate.c                  |  3 +-
 target/rx/gdbstub.c                       |  6 +-
 target/rx/helper.c                        |  6 +-
 target/rx/translate.c                     |  6 +-
 target/s390x/cpu-dump.c                   |  3 +-
 target/s390x/gdbstub.c                    |  6 +-
 target/s390x/helper.c                     |  3 +-
 target/s390x/kvm/kvm.c                    |  6 +-
 target/s390x/tcg/excp_helper.c            | 11 +--
 target/s390x/tcg/translate.c              |  3 +-
 target/sh4/cpu.c                          | 15 ++--
 target/sh4/gdbstub.c                      |  6 +-
 target/sh4/helper.c                       | 11 +--
 target/sh4/op_helper.c                    |  4 +-
 target/sh4/translate.c                    |  3 +-
 target/sparc/cpu.c                        | 14 +---
 target/sparc/gdbstub.c                    |  3 +-
 target/sparc/int32_helper.c               |  3 +-
 target/sparc/int64_helper.c               |  3 +-
 target/sparc/ldst_helper.c                |  6 +-
 target/sparc/mmu_helper.c                 | 15 ++--
 target/sparc/translate.c                  |  3 +-
 target/tricore/cpu.c                      | 20 +----
 target/tricore/gdbstub.c                  |  6 +-
 target/tricore/helper.c                   |  3 +-
 target/tricore/translate.c                |  3 +-
 target/xtensa/dbg_helper.c                |  3 +-
 target/xtensa/exc_helper.c                |  3 +-
 target/xtensa/gdbstub.c                   |  6 +-
 target/xtensa/helper.c                    |  9 +--
 target/xtensa/translate.c                 |  3 +-
 scripts/coccinelle/cpu_env.cocci_template | 92 +++++++++++++++++++++++
 130 files changed, 432 insertions(+), 714 deletions(-)
 create mode 100644 scripts/coccinelle/cpu_env.cocci_template

-- 
2.41.0


