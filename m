Return-Path: <kvm+bounces-41603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FD0A6B0C6
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 081E6987F7B
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7541C22A7F0;
	Thu, 20 Mar 2025 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lpxhq8ve"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD143223707
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509813; cv=none; b=TRhX5l5ZGXq4pdzEnuPrqr5wnN96MtmUdXRmb8Oo3Q3v1yxyhTcTIBLWykjJ0ZNimNHxkchTTbpuayfvg23Un7W5TTN/zJALsx1jP8eXRkvB15ByHSOfXnS2+MQabzy78azI56rrnZC4qcY63RC1/EzcYsdTryEIeX72TPP6qx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509813; c=relaxed/simple;
	bh=A8t9/UQ/F6dgOl4CV/crVKcvm/z/FnLkTJUHG5htwIY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=RWfK4TJMk3H8pvvQzKcIJgXLguwoc8lAPvW6P4Ifgu70GBtzcSAnTIZVs9H/8nGd07SmxqlaENhT7vvxBF9V0EDWbKdx/1gUb5gGdP2DyftTsKsA+EGNj95e7bUdflrQf/CeFE8llkaBYNHleSb+ZO+pGAspJ8OxS6rT2WwVXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lpxhq8ve; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-225a28a511eso29428385ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509811; x=1743114611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iqhwlkf8vVBUTfdErW46dXre9tdQWHJk62D7NGKBzrU=;
        b=lpxhq8veGG2lVrQv7A6oTe2zTZbo27QBgu1vPEKfh9Ey0Zmnx+Rl8M0t2QRUZHZtSv
         8MokDjb1pEYJHN8nOt6YOSZZCO72kw4oU2QZz99wYqYySGSAQHHpK4NxCEULkvHMvDPZ
         U+otjCbuiHRoils+l2iG4JfhHOMHDROGUcuztGfCEkD60SPavVDhMy/mrpLMaBQvW1h6
         lfBbDPkURQHSkpmVo9qANt+bKe5JJf2eDLSqE1KrhTY+z+vkO2cFD41keY38xAxhMLl7
         bVf+LKm1LcBKJ8zj2o8+BMUeYz/nuAmpZ4Rzxc5x1dBG08CkS0fc62sTEJXcBx/zxt21
         N0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509811; x=1743114611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iqhwlkf8vVBUTfdErW46dXre9tdQWHJk62D7NGKBzrU=;
        b=pemQYEHPTTK2wbIhK2bJah5KAKcqt0nbxfp3pvQgjEVHI6nhi3rKN/utby6fuIty45
         USt7O9uaWpv/kcyKQTPOfwPsqVbUfKFw9XQrBq7ctQZrnv3QjbSQIgb4CJrhyVEgpAxW
         HJXUTc3Mw+13a9TU+IVXEdqVtfcOYCu3Q1IQX8TWbfzodllE27J4r5jDCQSRL7oRIKh9
         LvXDmYiy3LrRrTyCnIgcJLgxw5m3noQ1PoXOhSXChgHTB1XGTqDb0N68nU8/SMZGmt7T
         iiRU+VGrXoxG5tl7UbcgjU/6vp/hbGSPsQZCdTM6vAWj6uI4f9Y7NGIHW7X9S2WgUt7E
         5j7w==
X-Gm-Message-State: AOJu0YzgmCO9a0nGNz1k5cQe4m6y+GE28hbZgjfkLbsYluVryPn0wHp+
	dxhUgXIVi9Yu8OTEttuYn58AuXuePaYYzCus2ddxXcpwKKrg9r9b7mIWGWZSbwU=
X-Gm-Gg: ASbGncs6RWK0/ubjzCaEoobu21hXDsvZSuS639brNLiFDA8oKOe1vHBVxLSzPa91zdy
	+1cTLfMoTsG47X/AB46rUDNMMzC99TB4/WBPg7Gtswp3dIWXRFxOlX+VIiMoaz3h6WgL4DnY08W
	EA/PU8xg8m2avIWsThH6NAH4ILIdyxKjwFJWgdnHxwr8dIQTM+7NRTqkHkCW3xg+mZe2lqbLlZo
	WrlAq2Z5pqIVbdbpxlYchiimcGq1q7lELRo1VQ81DGjR/QsUMnyIV7sO6V0ybOpLP/sE4SGePaM
	Au9kjCa3tAM/Fl7gk640gKU12n0HACXfFvtzt37resXrIvZtTOmQ4ac=
X-Google-Smtp-Source: AGHT+IF7rxq36QivV5DZYlbW16JQVFyK0VK5/tg8mquF2bSISfiJtuxjSj/kyOctpc9S1USrnAuYdg==
X-Received: by 2002:a17:903:1110:b0:21f:ba77:c45e with SMTP id d9443c01a7336-22780e20562mr11953595ad.45.1742509810917;
        Thu, 20 Mar 2025 15:30:10 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:10 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 00/30] single-binary: start make hw/arm/ common
Date: Thu, 20 Mar 2025 15:29:32 -0700
Message-Id: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
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

Pierrick Bouvier (30):
  exec/cpu-all: remove BSWAP_NEEDED
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
 include/exec/{cpu-all.h => tlb-flags.h} |  38 +-------
 include/hw/core/cpu.h                   |   2 +-
 include/qemu/bswap.h                    |   2 +-
 include/system/kvm.h                    |   2 -
 linux-user/qemu.h                       |   3 +
 linux-user/sparc/target_syscall.h       |   2 +
 linux-user/syscall_defs.h               |   2 +-
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
 bsd-user/elfload.c                      |   6 +-
 cpu-target.c                            |   5 +
 hw/alpha/dp264.c                        |   1 +
 hw/alpha/typhoon.c                      |   1 +
 hw/arm/armv7m.c                         |  12 ++-
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
 hw/ppc/mac_newworld.c                   |   5 +-
 hw/ppc/mac_oldworld.c                   |   5 +-
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
 hw/sparc/sun4m.c                        |   7 +-
 hw/sparc64/sun4u.c                      |   7 +-
 hw/xtensa/pic_cpu.c                     |   1 +
 linux-user/elfload.c                    |   8 +-
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
 136 files changed, 302 insertions(+), 205 deletions(-)
 rename include/exec/{cpu-all.h => tlb-flags.h} (78%)

-- 
2.39.5


