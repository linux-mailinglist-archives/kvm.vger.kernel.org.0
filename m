Return-Path: <kvm+bounces-41890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DAE7A6E8F5
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAD26168239
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF971A83E8;
	Tue, 25 Mar 2025 04:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vb0Gz+5s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0A11187
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878764; cv=none; b=Taw+iNOW5Vc7F0iL9wTB8TiKlT51O6YwtVfXwU3al/Amipu1QQAH2jMFYqZIq+s+AyoAjvvvAlf6ZNfKt8c812nrwRW3tVTE+DnPYCvMcmz2uDvlIzQMjunSWSbAcozMlpuFrzK6b1+2wATiGQIMgmOo4uuPHZZuWp1jgM9MMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878764; c=relaxed/simple;
	bh=hYBYd+2vP8vR5WoTBsLTYhmCKzLc5Nf4mEr9GcOstUI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Ih55la09LOZlwQOHURP6BnjSpr0rzV4KnbqnoFn68O6qCocZzqCRrlfG5ZvXxVyndknj2P03jBv6co/wiBU65S6to2eZu2tDq6BBHkkFSKQ9GcbsLNLikgYeIes3hQDrnDqt7T4aAeI1SvgRCd4DbGzrCMF+qIBLwclMZxJBYVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vb0Gz+5s; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff187f027fso11092929a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878762; x=1743483562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rajTAshyyuf+9dBkelCHSUjwpcojpUqSjWQK0047Uzc=;
        b=vb0Gz+5s2mEkO+kwbcSAP35Q9J17Fq1/5GXGNj/78IvVf5P0saqeGZYGRMQfbUX/zy
         YPAsbl6oluCzNAk+gzMw2pQPbj9/YoLPIf6zHu/YVfDPH1EuNjZnmVA+o+nE6JAD1oMM
         SORBDk2J1gTqokRYUzMokW87NaeTvJCOx7inIpKJPm761eGpdRNGbK6JtZFsWg4uwf31
         w2+VaQRfKEixRCXskwPAgoTYPLrZ9pecSL/Zhl8j3EEaq7CsPL6qycKGgcJA+GH98ild
         54FQD7jPMXoRzr+DGpF91/EH6DG3wI+dcEur4MX9jzmTNn52XY/9vKNpjYLMxe2ZAPZ0
         DNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878762; x=1743483562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rajTAshyyuf+9dBkelCHSUjwpcojpUqSjWQK0047Uzc=;
        b=IKwYr6hW+aQ4RTQf//n5+DsNwAsEBU9AHP6fOCNAl+9nAo8L5yLrUqoZkmg6bqpmDP
         JzxCAhoiHwMLvqtYQFi+X1gA6DFtCNrcuJPC6RoSradh43boN4RojLln/fHTfjoXLlqx
         CqVWwrjTADPzVea4t3wQ86S7NJ4WZvkx1FRhBgvIdPngXYHbUxjJAs0r20R3PImA0c/y
         vAeRNcazZqSwSXXUB2FGy4hCkwmBz35Ujg/Td0z16n2k5RvefcL59Fd/S6C5NAVe3bLF
         j0HGMTAsAV2e9vUGNvO3l6PlocC4aj8hMTlOl2eGd4UErqR23PfpmgYibQnjfTLMql8l
         ozaA==
X-Forwarded-Encrypted: i=1; AJvYcCWo0pXccaEs9W1eV1bu7RFYN+R+EQPWqRJulZchS4HbMqjrub/Bp2wC9cOsZgV0JOZ2mD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL2vRG2Gw+7Ls7ttX4JKdFDAdmRIGm1xKG7egR8J8KtXCzSFW1
	JZ756vrGgYUPZE3JHOXE2Z7KruHagaXlqbJIpOakXTLP0DdccYfiHhp/h2dY1v8=
X-Gm-Gg: ASbGncuAOVNZR5aDtBJ64KG+O2h7Al7Z5WWzSDoIIZ+SYM/0pMsMa9XGjpOOOk3nAqx
	B7KcQ2i8mKEldz3R/fRKFckRMlc9RQtm+T5BUi93xk2WC33CAAQXCj4uIbfXjD9enhuwRT9Qz24
	B7Stbyi7v8SdMo3vlQqLpguacrDyIG2DyGL3e7NOPMm+8VS0fUiTbds9SciuQi93s2VIeE7Lbi9
	IBk41q6sILXYOKnD/3QLWILXvbDcJY3g92rNLAa2ScyoJYIh70wXiq+p/h7pDZz1efVMHljV/or
	pFSyPP147l98Vj/qYlOW8Gv/BlHpoNdPZv4ulafmCdQv
X-Google-Smtp-Source: AGHT+IEuyoNLVrmTssAXxfIaajKKAVuUdLb1GQFc5Uc47d6bqWDu7TeJ4gC61YmsDCrDsik7egiLGw==
X-Received: by 2002:a17:90a:e7c7:b0:302:fc48:4f0a with SMTP id 98e67ed59e1d1-3030e148d42mr22800129a91.0.1742878761922;
        Mon, 24 Mar 2025 21:59:21 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 00/29] single-binary: start make hw/arm/ common
Date: Mon, 24 Mar 2025 21:58:45 -0700
Message-Id: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series focuses on removing compilation units duplication in hw/arm. We
start with this architecture because it should not be too hard to transform it,
and should give us some good hints on the difficulties we'll meet later.

We first start by making changes in global headers to be able to not rely on
specific target defines. In particular, we completely remove cpu-all.h.
We then focus on removing those defines from target/arm/cpu.h.

From there, we modify build system to create a new hw common library (per base
architecture, "arm" in this case), instead of compiling the same files for every
target.

Finally, we can declare hw/arm/boot.c, and most of the boards as common as a
first step for this part.

- Based-on: 20250317183417.285700-1-pierrick.bouvier@linaro.org
("[PATCH v6 00/18] make system memory API available for common code")
https://lore.kernel.org/qemu-devel/20250317183417.285700-1-pierrick.bouvier@linaro.org/
- Based-on: 20250318213209.2579218-1-richard.henderson@linaro.org
("[PATCH v2 00/42] accel/tcg, codebase: Build once patches")
https://lore.kernel.org/qemu-devel/20250318213209.2579218-1-richard.henderson@linaro.org

v2:
- rebase on top of Richard series
- add target include in hw_common lib
- hw_common_lib uses -DCOMPILE_SYSTEM_VS_USER introduced by Richard series
- remove cpu-all header
- remove BSWAP_NEEDED define
- new tlb-flags header
- Cleanup i386 KVM_HAVE_MCE_INJECTION definition + move KVM_HAVE_MCE_INJECTION
- remove comment about cs_base in target/arm/cpu.h
- updated commit message about registers visibility between aarch32/aarch64
- tried remove ifdefs in target/arm/helper.c but this resulted in more a ugly
  result. So just comment calls for now, as we'll clean this file later.
- make most of the boards in hw/arm common

v3:
- rebase on top of Richard series and master
- BSWAP_NEEDED commit was already merged
- Update description for commits removing kvm related headers

Pierrick Bouvier (29):
  exec/cpu-all: extract tlb flags defines to exec/tlb-flags.h
  exec/cpu-all: move cpu_copy to linux-user/qemu.h
  include/exec/cpu-all: move compile time check for CPUArchState to
    cpu-target.c
  exec/cpu-all: remove system/memory include
  exec/cpu-all: remove exec/page-protection include
  exec/cpu-all: remove tswap include
  exec/cpu-all: remove exec/cpu-interrupt include
  exec/cpu-all: remove exec/cpu-defs include
  exec/cpu-all: remove exec/target_page include
  exec/cpu-all: remove hw/core/cpu.h include
  accel/tcg: fix missing includes for TCG_GUEST_DEFAULT_MO
  accel/tcg: fix missing includes for TARGET_HAS_PRECISE_SMC
  exec/cpu-all: remove cpu include
  exec/cpu-all: transfer exec/cpu-common include to cpu.h headers
  exec/cpu-all: remove this header
  exec/target_page: runtime defintion for TARGET_PAGE_BITS_MIN
  accel/kvm: move KVM_HAVE_MCE_INJECTION define to kvm-all.c
  exec/poison: KVM_HAVE_MCE_INJECTION can now be poisoned
  target/arm/cpu: always define kvm related registers
  target/arm/cpu: flags2 is always uint64_t
  target/arm/cpu: define same set of registers for aarch32 and aarch64
  target/arm/cpu: remove inline stubs for aarch32 emulation
  meson: add common hw files
  hw/arm/boot: make compilation unit hw common
  hw/arm/armv7m: prepare compilation unit to be common
  hw/arm/digic_boards: prepare compilation unit to be common
  hw/arm/xlnx-zynqmp: prepare compilation unit to be common
  hw/arm/xlnx-versal: prepare compilation unit to be common
  hw/arm: make most of the compilation units common

 meson.build                             |  37 +++++++-
 accel/tcg/internal-target.h             |   1 +
 accel/tcg/tb-internal.h                 |   1 -
 hw/s390x/ipl.h                          |   2 +
 include/exec/cpu_ldst.h                 |   1 +
 include/exec/exec-all.h                 |   1 +
 include/exec/poison.h                   |   4 +
 include/exec/target_page.h              |   3 +
 include/exec/{cpu-all.h => tlb-flags.h} |  26 +-----
 include/hw/core/cpu.h                   |   2 +-
 include/qemu/bswap.h                    |   2 +-
 include/system/kvm.h                    |   2 -
 linux-user/qemu.h                       |   3 +
 linux-user/sparc/target_syscall.h       |   2 +
 target/alpha/cpu.h                      |   4 +-
 target/arm/cpu.h                        |  40 ++------
 target/arm/internals.h                  |   1 +
 target/avr/cpu.h                        |   4 +-
 target/hexagon/cpu.h                    |   3 +-
 target/hppa/cpu.h                       |   5 +-
 target/i386/cpu.h                       |   5 +-
 target/i386/hvf/vmx.h                   |   1 +
 target/loongarch/cpu.h                  |   4 +-
 target/m68k/cpu.h                       |   4 +-
 target/microblaze/cpu.h                 |   4 +-
 target/mips/cpu.h                       |   4 +-
 target/openrisc/cpu.h                   |   4 +-
 target/ppc/cpu.h                        |   4 +-
 target/ppc/mmu-hash32.h                 |   2 +
 target/ppc/mmu-hash64.h                 |   2 +
 target/riscv/cpu.h                      |   4 +-
 target/rx/cpu.h                         |   4 +-
 target/s390x/cpu.h                      |   4 +-
 target/sh4/cpu.h                        |   4 +-
 target/sparc/cpu.h                      |   4 +-
 target/tricore/cpu.h                    |   3 +-
 target/xtensa/cpu.h                     |   4 +-
 accel/kvm/kvm-all.c                     |   5 +
 accel/tcg/cpu-exec.c                    |   3 +-
 accel/tcg/cputlb.c                      |   1 +
 accel/tcg/tb-maint.c                    |   1 +
 accel/tcg/translate-all.c               |   1 +
 accel/tcg/user-exec.c                   |   2 +
 cpu-target.c                            |   5 +
 hw/alpha/dp264.c                        |   1 +
 hw/alpha/typhoon.c                      |   1 +
 hw/arm/armv7m.c                         |   8 +-
 hw/arm/boot.c                           |   2 +
 hw/arm/digic_boards.c                   |   2 +-
 hw/arm/smmuv3.c                         |   1 +
 hw/arm/xlnx-versal.c                    |   2 -
 hw/arm/xlnx-zynqmp.c                    |   2 -
 hw/hppa/machine.c                       |   1 +
 hw/i386/multiboot.c                     |   1 +
 hw/i386/pc.c                            |   1 +
 hw/i386/pc_sysfw_ovmf.c                 |   1 +
 hw/i386/vapic.c                         |   1 +
 hw/loongarch/virt.c                     |   1 +
 hw/m68k/next-cube.c                     |   1 +
 hw/m68k/q800.c                          |   1 +
 hw/m68k/virt.c                          |   1 +
 hw/openrisc/boot.c                      |   1 +
 hw/pci-host/astro.c                     |   1 +
 hw/ppc/e500.c                           |   1 +
 hw/ppc/mac_newworld.c                   |   1 +
 hw/ppc/mac_oldworld.c                   |   1 +
 hw/ppc/ppc.c                            |   1 +
 hw/ppc/ppc_booke.c                      |   1 +
 hw/ppc/prep.c                           |   1 +
 hw/ppc/spapr_hcall.c                    |   1 +
 hw/ppc/spapr_ovec.c                     |   1 +
 hw/riscv/riscv-iommu-pci.c              |   1 +
 hw/riscv/riscv-iommu.c                  |   1 +
 hw/s390x/s390-pci-bus.c                 |   1 +
 hw/s390x/s390-pci-inst.c                |   1 +
 hw/s390x/s390-skeys.c                   |   1 +
 hw/sparc/sun4m.c                        |   1 +
 hw/sparc64/sun4u.c                      |   1 +
 hw/xtensa/pic_cpu.c                     |   1 +
 monitor/hmp-cmds-target.c               |   1 +
 semihosting/uaccess.c                   |   2 +-
 target/alpha/helper.c                   |   2 +
 target/arm/gdbstub64.c                  |   1 +
 target/arm/helper.c                     |   6 ++
 target/arm/hvf/hvf.c                    |   1 +
 target/arm/ptw.c                        |   1 +
 target/arm/tcg/helper-a64.c             |   1 +
 target/arm/tcg/hflags.c                 |   4 +-
 target/arm/tcg/mte_helper.c             |   1 +
 target/arm/tcg/sve_helper.c             |   1 +
 target/arm/tcg/tlb-insns.c              |   1 +
 target/avr/helper.c                     |   2 +
 target/hexagon/translate.c              |   1 +
 target/i386/arch_memory_mapping.c       |   1 +
 target/i386/helper.c                    |   2 +
 target/i386/hvf/hvf.c                   |   1 +
 target/i386/kvm/hyperv.c                |   1 +
 target/i386/kvm/kvm.c                   |   1 +
 target/i386/kvm/xen-emu.c               |   1 +
 target/i386/sev.c                       |   1 +
 target/i386/tcg/system/excp_helper.c    |   2 +
 target/i386/tcg/system/misc_helper.c    |   1 +
 target/i386/tcg/system/tcg-cpu.c        |   1 +
 target/i386/xsave_helper.c              |   1 +
 target/loongarch/cpu_helper.c           |   1 +
 target/loongarch/tcg/translate.c        |   1 +
 target/m68k/helper.c                    |   1 +
 target/microblaze/helper.c              |   1 +
 target/microblaze/mmu.c                 |   1 +
 target/mips/tcg/system/cp0_helper.c     |   1 +
 target/mips/tcg/translate.c             |   1 +
 target/openrisc/mmu.c                   |   1 +
 target/ppc/excp_helper.c                |   1 +
 target/ppc/mmu-book3s-v3.c              |   1 +
 target/ppc/mmu-hash64.c                 |   1 +
 target/ppc/mmu-radix64.c                |   1 +
 target/riscv/cpu_helper.c               |   1 +
 target/riscv/op_helper.c                |   1 +
 target/riscv/pmp.c                      |   1 +
 target/riscv/vector_helper.c            |   2 +
 target/rx/cpu.c                         |   1 +
 target/s390x/helper.c                   |   1 +
 target/s390x/ioinst.c                   |   1 +
 target/s390x/tcg/mem_helper.c           |   1 +
 target/sparc/ldst_helper.c              |   1 +
 target/sparc/mmu_helper.c               |   2 +
 target/tricore/helper.c                 |   1 +
 target/xtensa/helper.c                  |   1 +
 target/xtensa/mmu_helper.c              |   1 +
 target/xtensa/op_helper.c               |   1 +
 target/xtensa/xtensa-semi.c             |   1 +
 tcg/tcg-op-ldst.c                       |   2 +-
 hw/arm/meson.build                      | 117 ++++++++++++------------
 133 files changed, 286 insertions(+), 169 deletions(-)
 rename include/exec/{cpu-all.h => tlb-flags.h} (84%)

-- 
2.39.5


