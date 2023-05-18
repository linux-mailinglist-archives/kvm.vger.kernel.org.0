Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054117085D8
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjERQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjERQUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:20:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85BA10D2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64cfb8d33a5so1248159b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426809; x=1687018809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QkAP+MCzid27lQKKAKPDtQpx75fhMpiVU9fXRekdLpM=;
        b=XFoc/VQGrdaOTqbwR2Vg3vCogNIeAQQnwV8YEZLCEIGUgy0WcxsagYBaFxKByr84/E
         6uXXZB137+WF/j7A3eRQ9QzuI0xPknz73Q8+rHqXYp8tHGyAKTYTizbpO8SWkdjkfUo6
         kt5XWI8jQi7HhtmW29mqbtzRmlBONGXdsLSL5Vobhie0Kwo9De1dTIirYNcu1/zDKLp4
         j17cvB1mIPG0O88ezpgLZTuXCpIVIr35n3dHsD2SRWOeiwgCwbUWGa2nPBQeclQEN94/
         1umts+pjtSwyqwQuBHF1/h+ParHXmrI9rbftJ2hu8VrCNiPabB/HkYqkbpfSVTzHsadT
         u0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426809; x=1687018809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QkAP+MCzid27lQKKAKPDtQpx75fhMpiVU9fXRekdLpM=;
        b=lLr2z0giKBOIGttt5Jwh2VY7HhJGDn5GEkhSDFjth6XYHVJZpFlfqmKcsvVPMCkEDl
         rU7BfAGq2mqI/Bi0wDPnrAPWxZUBwb4MVwKPJbCnw7sgZ3UhEyQOGwW8jtQQQEQpEtWr
         OW9Y8Rwot603dGw+VkHg0HH5Pjl9H8aIcBBB83xPBTcu2KVzy5q2iDy+k6vvMu1rtpAr
         uCNAWcvhCaOii+EWcLUJEhEsfhJk7se6eAgUK/tMQkK2uMwHu6kMaq0nIHNk4a/AArjj
         JSINeXP9m4TSUnVZ3FdVfOsNH/vWecRSUPz4y/vjjU6hbcIrDE+cT1BndAoVZ0x4x618
         FBdQ==
X-Gm-Message-State: AC+VfDwbz5rYsS6R1OsfI7vLKgFbgx28c40RMqf3Xp2W/EXVn2qW1PNd
        IB0GS9Cr9tG9WR9Mkg+v4ZVcVg==
X-Google-Smtp-Source: ACHHUZ6evOWqHzjBY1VisM9AARicYsq+twqQSS2M5FR2J99qSIS9g5lLhNdFkcXzj6KENKCxC7llNA==
X-Received: by 2002:a05:6a00:2446:b0:645:fc7b:63d6 with SMTP id d6-20020a056a00244600b00645fc7b63d6mr4512980pfj.6.1684426808999;
        Thu, 18 May 2023 09:20:08 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:07 -0700 (PDT)
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
Subject: [PATCH -next v20 00/26] riscv: Add vector ISA support
Date:   Thu, 18 May 2023 16:19:23 +0000
Message-Id: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is implemented based on vector 1.0 spec to add vector support
in riscv Linux kernel. There are some assumptions for this implementations.

1. We assume all harts has the same ISA in the system.
2. We disable vector in both kernel and user space [1] by default. Only
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

This patchset is rebased to v6.4-rc1 and it is tested by running several
vector programs simultaneously. It delivers signals correctly in a test
where we can see a valid ucontext_t in a signal handler, and a correct V
context returing back from it. And the ptrace interface is tested by
PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
a guest using the same kernel image. All tests are done on an rv64gcv
virt QEMU.

Additionally, to work with the potential impact on ABI stability
mentioned at [4], we implement prctl(), and a sysctl interfaces to
control userspace Vector for compatibility. The prctl interface can be
tested by kselftest, which is provided at the end of the series. The
default is to enable Vector for userspace given that it is likely a
theoretical case for ABI break, and that it provides a chance to find
breakages (if any) early and developers to play around with V[5].

Source tree:
https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v20

Links:
 - [1] https://lore.kernel.org/all/20220921214439.1491510-17-stillson@rivosinc.com/
 - [2] https://lore.kernel.org/all/73c0124c-4794-6e40-460c-b26df407f322@rivosinc.com/T/#u
 - [3] https://lore.kernel.org/all/20230128082847.3055316-1-apatel@ventanamicro.com/
 - [4] https://inbox.sourceware.org/libc-alpha/87leinq5wg.fsf@all.your.base.are.belong.to.us/
 - [5] https://lore.kernel.org/all/mhng-8554b236-c9d4-4590-8941-ed7ca5316d18@palmer-ri-x1c9a/

Updated patches: 2, 3, 11, 20, 21, 23, 24
New patches: 25, 26
Unchanged patches: 1, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 22

---
Changelog V20
 - Add .gitignore into hwprobe (patch 26)
 - Implement test for prctl and fix issues (patch 20, 25)
 - Fix compile error with allmodconfig (patch 20).
 - Check elf_hwcap in first-use trap (patch 11).
 - Refine code (patch 11, 20, 21, 23, 24)
 - Properly add V entry into hwprobe (patch 3).
 - Fix typos (patch 3, 24)
 - Use "_unlikely" to detect V since there is no public available hw
   that supports it (patch 2).

Changelog V19
 - Rebase to the latest -next branch (at 6.4-rc1 ac9a786). Solve
   conflicts at patch 14, 15, and 19.
 - Add a sysctl, and prctl intefaces for userspace Vector control, and a
   document for it. (patch 20, 21, 24)
 - Add a Kconfig RISCV_V_DISABLE to set the default value of userspace
   Vector enablement status at compile-time. (patch 23)
 - Allow hwprobe interface to probe Vector. (patch 3)
 - Fix typos and commit msg at patch 6 and 8.

Changelog V18
 - Rebase to the latest -next branch (at 9c2598d)
 - patch 7: Detect inconsistent VLEN setup on an SMP system (Heiko).
 - patch 10: Add blank lines (Heiko)
 - patch 10: Return immediately in insn_is_vector() if an insn matches (Heiko)
 - patch 11: Use sizeof(vstate->datap) instead of sizeof(void*) (Eike)

Changelog V17
 - Rebase to the latest -next branch (at e45d6a5):
   - Solve conflicts at 9 and 13 due to generic entry
   - Use generic entry in do_trap_insn_illegal() trap handler

Changelog V16
 - Rebase to the latest for-next (at 4b74077):
 - Solve conflicts at 7, and 17
 - Use as-instr to detect if assembler supports .option arch directive
   and remove dependency from GAS, for both ZBB and V.
 - Cleanup code in KVM vector
 - Address issue reported by sparse
 - Refine code:
   - Fix a mixed-use of space/tab
   - Remove new lines at the end of file

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

Andy Chiu (10):
  riscv: hwprobe: Add support for probing V in
    RISCV_HWPROBE_KEY_IMA_EXT_0
  riscv: Allocate user's vector context in the first-use trap
  riscv: signal: check fp-reserved words unconditionally
  riscv: signal: validate altstack to reflect Vector
  riscv: Add prctl controls for userspace vector management
  riscv: Add sysctl to set the default vector rule for new processes
  riscv: detect assembler support for .option arch
  riscv: Add documentation for Vector
  selftests: Test RISC-V Vector prctl interface
  selftests: add .gitignore file for RISC-V hwprobe

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

 Documentation/riscv/hwprobe.rst               |   3 +
 Documentation/riscv/index.rst                 |   1 +
 Documentation/riscv/vector.rst                | 120 ++++++++
 arch/riscv/Kconfig                            |  39 ++-
 arch/riscv/Makefile                           |   6 +-
 arch/riscv/include/asm/csr.h                  |  18 +-
 arch/riscv/include/asm/elf.h                  |   9 +
 arch/riscv/include/asm/hwcap.h                |   1 +
 arch/riscv/include/asm/insn.h                 |  29 ++
 arch/riscv/include/asm/kvm_host.h             |   2 +
 arch/riscv/include/asm/kvm_vcpu_vector.h      |  82 +++++
 arch/riscv/include/asm/processor.h            |  16 +
 arch/riscv/include/asm/switch_to.h            |   9 +-
 arch/riscv/include/asm/thread_info.h          |   3 +
 arch/riscv/include/asm/vector.h               | 184 ++++++++++++
 arch/riscv/include/uapi/asm/auxvec.h          |   1 +
 arch/riscv/include/uapi/asm/hwcap.h           |   1 +
 arch/riscv/include/uapi/asm/hwprobe.h         |   1 +
 arch/riscv/include/uapi/asm/kvm.h             |   8 +
 arch/riscv/include/uapi/asm/ptrace.h          |  39 +++
 arch/riscv/include/uapi/asm/sigcontext.h      |  16 +-
 arch/riscv/kernel/Makefile                    |   1 +
 arch/riscv/kernel/cpufeature.c                |  13 +
 arch/riscv/kernel/entry.S                     |   6 +-
 arch/riscv/kernel/head.S                      |  41 ++-
 arch/riscv/kernel/process.c                   |  19 ++
 arch/riscv/kernel/ptrace.c                    |  70 +++++
 arch/riscv/kernel/setup.c                     |   3 +
 arch/riscv/kernel/signal.c                    | 220 ++++++++++++--
 arch/riscv/kernel/smpboot.c                   |   7 +
 arch/riscv/kernel/sys_riscv.c                 |   4 +
 arch/riscv/kernel/traps.c                     |  26 +-
 arch/riscv/kernel/vector.c                    | 280 ++++++++++++++++++
 arch/riscv/kvm/Makefile                       |   1 +
 arch/riscv/kvm/vcpu.c                         |  25 ++
 arch/riscv/kvm/vcpu_vector.c                  | 186 ++++++++++++
 include/uapi/linux/elf.h                      |   1 +
 include/uapi/linux/prctl.h                    |  11 +
 kernel/sys.c                                  |  12 +
 tools/testing/selftests/riscv/Makefile        |   2 +-
 .../selftests/riscv/hwprobe/.gitignore        |   1 +
 .../testing/selftests/riscv/vector/.gitignore |   2 +
 tools/testing/selftests/riscv/vector/Makefile |  15 +
 .../riscv/vector/vstate_exec_nolibc.c         | 111 +++++++
 .../selftests/riscv/vector/vstate_prctl.c     | 189 ++++++++++++
 45 files changed, 1784 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/riscv/vector.rst
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
 create mode 100644 arch/riscv/include/asm/vector.h
 create mode 100644 arch/riscv/kernel/vector.c
 create mode 100644 arch/riscv/kvm/vcpu_vector.c
 create mode 100644 tools/testing/selftests/riscv/hwprobe/.gitignore
 create mode 100644 tools/testing/selftests/riscv/vector/.gitignore
 create mode 100644 tools/testing/selftests/riscv/vector/Makefile
 create mode 100644 tools/testing/selftests/riscv/vector/vstate_exec_nolibc.c
 create mode 100644 tools/testing/selftests/riscv/vector/vstate_prctl.c

-- 
2.17.1

