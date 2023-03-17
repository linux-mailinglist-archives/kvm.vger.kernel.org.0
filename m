Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C06BE84F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCQLhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCQLhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C502ECC305
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ja10so4991483plb.5
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679052978;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJDBG7kBBHxN4whOw8CwS1rep1qG2OJuyYu9ivjuoOk=;
        b=ASKdAvlndZMl4rdtER/7MdXa3ELTowJ/5bUURqeAo2jxbQ1oSWiRJqT6pz/jOfAr0o
         n0t8s6P8ST0kUmPV4cQRREpwfhdLovGmkHmScfiX20AoKX364Qt34+cfC3piav18M95c
         zQlqdfI2ZtmXxWXjS1Nvu7QtuVpQyTpNs7tVrXXdyYmID3iODkuGj8rQKoAhfP8BmF2P
         7TfzafE9MZ37FFQo4Gwy82FGz1M8i7i4+F9Ko5a0y0gRBm5xCHEJee8eYqHr0jXDXhtG
         7YGBobEVbrKaFrmghqj45Pqfw1AdP9T2VxTyT7OunQY4tdDsbI99YgyBozPvDOOF5eil
         2SUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052978;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJDBG7kBBHxN4whOw8CwS1rep1qG2OJuyYu9ivjuoOk=;
        b=pZVjdv9c7P126ojXzogh9IISdmuZebg1f1jVT7VA/AjWrB2gvsIkUV1g2KNs0C/fqg
         S37KeAycthSssi1iOu9y15GoTznsk942xp6ppRNwlZ8CJm3tSiCgO3s63GJ5GWudhM7S
         X6HBNVCAKOlOx82c58PxybQOp7pmGMAjoARq90b5cmtFFUH1X26dc/CngWkp/CbG8rhL
         kR343F3aWL0c+lrSUjjjb8xtzXVMG7hBi0tnn6X6lL+9lcMo9RhLToFk4ojKTbrvtiu/
         gTZ41+oGuj/eI4k36pUPOVIFUOs6ybNc0He+MPC/Iy+ZAbMJ2GJQVdKfds/tUVx4v6bA
         3RZQ==
X-Gm-Message-State: AO0yUKWcqEWDrAjrGVxGtj68o9AH+lZ5ETIEPDYM4DRt1Mp1fekzo+Mk
        OTYt87pbfC9KoK1oC4qxXLrxdQ==
X-Google-Smtp-Source: AK7set+rTZY+uRb998wvZMyisVnvIRiKtTFiLAHr7HIt9Xb91qYyx5HYH3MEYZQ0JVZo7tSQkZfOhg==
X-Received: by 2002:a17:90b:1b4e:b0:234:c030:7c7f with SMTP id nv14-20020a17090b1b4e00b00234c0307c7fmr3204248pjb.18.1679052978375;
        Fri, 17 Mar 2023 04:36:18 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:17 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH -next v15 00/19] riscv: Add vector ISA support
Date:   Fri, 17 Mar 2023 11:35:19 +0000
Message-Id: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is implemented based on vector 1.0 spec to add vector support
in riscv Linux kernel. There are some assumptions for this implementations.

1. We assume all harts has the same ISA in the system.
2. We disable vector in both kernel andy user space [1] by default. Only
   enable an user's vector after an illegal instruction trap where it
   actually starts executing vector (the first-use trap [2]).
3. We detect "riscv,isa" to determine whether vector is support or not.

We defined a new structure __riscv_v_ext_state in struct thread_struct to
save/restore the vector related registers. It is used for both kernel space
and user space.
 - In kernel space, the datap pointer in __riscv_v_ext_state will be
   allocated to save vector registers.
 - In user space,
	- In signal handler of user space, the structure is placed
	  right after __riscv_ctx_hdr, which is embedded in fp reserved
	  aera. This is required to avoid ABI break [2]. And datap points
	  to the end of __riscv_v_ext_state.
	- In ptrace, the data will be put in ubuf in which we use
	  riscv_vr_get()/riscv_vr_set() to get or set the
	  __riscv_v_ext_state data structure from/to it, datap pointer
	  would be zeroed and vector registers will be copied to the
	  address right after the __riscv_v_ext_state structure in ubuf.

This patchset is rebased to v6.3-rc1 and it is tested by running several
vector programs simultaneously. It delivers signals correctly in a test
where we can see a valid ucontext_t in a signal handler, and a correct V
context returing back from it. And the ptrace interface is tested by
PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
a guest using the same kernel image. All tests are done on an rv64gcv
virt QEMU.

Note: please apply the patch at [4] due to a regression introduced by
commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations") before testing the series.

Specail thanks to Conor and Vineet for kindly giving help on- and off-list.

Source tree:
https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v15

Links:
 - [1] https://lore.kernel.org/all/20220921214439.1491510-17-stillson@rivosinc.com/
 - [2] https://lore.kernel.org/all/73c0124c-4794-6e40-460c-b26df407f322@rivosinc.com/T/#u
 - [3] https://lore.kernel.org/all/20230128082847.3055316-1-apatel@ventanamicro.com/
 - [4] https://lore.kernel.org/all/CAHk-=wiAxtKyxs6BPEzirrXw1kXJ-7ZyGpgOrbzhmC=ud-6jBA@mail.gmail.com/
---
Changelog V15
 - Rebase to risc-v -next (v6.3-rc1)
 - Make V depend on FD in Kconfig according to the spec and shut off v
   properly.
 - Fix a syntax error for clang build. But mark RISCV_ISA_V GAS only due
   to https://reviews.llvm.org/D123515
 - Use scratch reg in inline asm instead of t4.
 - Refine code.
 - Cleanup per-patch changelogs.

Changelog V14
 - Rebase to risc-v -next (v6.2-rc7)
 - Use TOOLCHAIN_HAS_V to detect if we can enable Vector. And refine
   KBUILD_CFLAGS to remove v from default compile option.
 - Drop illegal instruction handling patch in kvm and leave it to a
   independent series[3]. The series has merged into 6.3-rc1
 - Move KVM_RISCV_ISA_EXT_V to the end of enum to prevent potential ABI
   breaks.
 - Use PT_SIZE_ON_STACK instead of PT_SIZE to fit alignment. Also,
   remove panic log from v13 (15/19) because it is no longer relevant.
 - Rewrite insn_is_vector for better structuring (change if-else chain to
   a switch)
 - Fix compilation error in the middle of the series
 - Validate size of the alternative signal frame if V is enabled
   whenever:
     - The user call sigaltstack to update altstack
     - A signal is being delivered
 - Rename __riscv_v_state to __riscv_v_ext_state.
 - Add riscv_v_ prefix and rename rvv appropriately
 - Organize riscv_v_vsize setup code into vector.c
 - Address the issue mentioned by Heiko on !FPU case
 - Honor orignal authors that got changed accidentally in v13 4,5,6

Changelog V13
 - Rebase to latest risc-v next (v6.2-rc1)
 - vineetg: Re-organize the series to comply with bisect-ability
 - andy.chiu: Improve task switch with inline assembly
 - Re-structure the signal frame to avoid user ABI break.
 - Implemnt first-use trap and drop prctl for per-task V state
   enablement. Also, redirect this trap from hs to vs for kvm setup.
 - Do not expose V context in ptrace/sigframe until the task start using
   V. But still reserve V context for size ofsigframe reported by auxv.
 - Drop the kernel mode vector and leave it to another (future) series.

Changelog V12 (Chris)
 - rebases to some point after v5.18-rc6
 - add prctl to control per-process V state

Chnagelog V10
 - Rebase to v5.18-rc6
 - Merge several patches
 - Refine codes
 - Fix bugs
 - Add kvm vector support

Changelog V9
 - Rebase to v5.15
 - Merge several patches
 - Refine codes
 - Fix a kernel panic issue

Changelog V8
 - Rebase to v5.14
 - Refine struct __riscv_v_ext_state with struct __riscv_ctx_hdr
 - Refine has_vector into a static key
 - Defined __reserved space in struct sigcontext for vector and future extensions

Changelog V7
 - Add support for kernel mode vector
 - Add vector extension XOR implementation
 - Optimize task switch codes of vector
 - Allocate space for vector registers in start_thread()
 - Fix an illegal instruction exception when accessing vlenb
 - Optimize vector registers initialization
 - Initialize vector registers with proper vsetvli then it can work normally
 - Refine ptrace porting due to generic API changed
 - Code clean up

Changelog V6
 - Replace vle.v/vse.v instructions with vle8.v/vse8.v based on 0.9 spec
 - Add comments based on mailinglist feedback
 - Fix rv32 build error

Changelog V5
 - Using regset_size() correctly in generic ptrace
 - Fix the ptrace porting
 - Fix compile warning

Changelog V4
 - Support dynamic vlen
 - Fix bugs: lazy save/resotre, not saving vtype
 - Update VS bit offset based on latest vector spec
 - Add new vector csr based on latest vector spec
 - Code refine and removed unused macros

Changelog V3
 - Rebase linux-5.6-rc3 and tested with qemu
 - Seperate patches with Anup's advice
 - Give out a ABI puzzle with unlimited vlen

Changelog V2
 - Fixup typo "vecotr, fstate_save->vstate_save".
 - Fixup wrong saved registers' length in vector.S.
 - Seperate unrelated patches from this one.

Andy Chiu (3):
  riscv: Allocate user's vector context in the first-use trap
  riscv: signal: check fp-reserved words unconditionally
  riscv: signal: validate altstack to reflect Vector

Greentime Hu (9):
  riscv: Add new csr defines related to vector extension
  riscv: Clear vector regfile on bootup
  riscv: Introduce Vector enable/disable helpers
  riscv: Introduce riscv_v_vsize to record size of Vector context
  riscv: Introduce struct/helpers to save/restore per-task Vector state
  riscv: Add task switch support for vector
  riscv: Add ptrace vector support
  riscv: signal: Add sigcontext save/restore for vector
  riscv: prevent stack corruption by reserving task_pt_regs(p) early

Guo Ren (4):
  riscv: Rename __switch_to_aux() -> fpu
  riscv: Extending cpufeature.c to detect V-extension
  riscv: Disable Vector Instructions for kernel itself
  riscv: Enable Vector code to be built

Vincent Chen (3):
  riscv: signal: Report signal frame size to userspace via auxv
  riscv: kvm: Add V extension to KVM ISA
  riscv: KVM: Add vector lazy save/restore support

 arch/riscv/Kconfig                       |  20 ++
 arch/riscv/Makefile                      |   6 +-
 arch/riscv/include/asm/csr.h             |  18 +-
 arch/riscv/include/asm/elf.h             |   9 +
 arch/riscv/include/asm/hwcap.h           |   1 +
 arch/riscv/include/asm/insn.h            |  29 +++
 arch/riscv/include/asm/kvm_host.h        |   2 +
 arch/riscv/include/asm/kvm_vcpu_vector.h |  77 ++++++++
 arch/riscv/include/asm/processor.h       |   3 +
 arch/riscv/include/asm/switch_to.h       |   9 +-
 arch/riscv/include/asm/thread_info.h     |   3 +
 arch/riscv/include/asm/vector.h          | 179 ++++++++++++++++++
 arch/riscv/include/uapi/asm/auxvec.h     |   1 +
 arch/riscv/include/uapi/asm/hwcap.h      |   1 +
 arch/riscv/include/uapi/asm/kvm.h        |   8 +
 arch/riscv/include/uapi/asm/ptrace.h     |  39 ++++
 arch/riscv/include/uapi/asm/sigcontext.h |  16 +-
 arch/riscv/kernel/Makefile               |   1 +
 arch/riscv/kernel/cpufeature.c           |  13 ++
 arch/riscv/kernel/entry.S                |   6 +-
 arch/riscv/kernel/head.S                 |  41 ++++-
 arch/riscv/kernel/process.c              |  18 ++
 arch/riscv/kernel/ptrace.c               |  70 +++++++
 arch/riscv/kernel/setup.c                |   3 +
 arch/riscv/kernel/signal.c               | 221 ++++++++++++++++++++---
 arch/riscv/kernel/traps.c                |  14 +-
 arch/riscv/kernel/vector.c               | 111 ++++++++++++
 arch/riscv/kvm/Makefile                  |   1 +
 arch/riscv/kvm/vcpu.c                    |  31 ++++
 arch/riscv/kvm/vcpu_vector.c             | 177 ++++++++++++++++++
 include/uapi/linux/elf.h                 |   1 +
 31 files changed, 1081 insertions(+), 48 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
 create mode 100644 arch/riscv/include/asm/vector.h
 create mode 100644 arch/riscv/kernel/vector.c
 create mode 100644 arch/riscv/kvm/vcpu_vector.c

-- 
2.17.1

