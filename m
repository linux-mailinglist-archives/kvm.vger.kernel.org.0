Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74226E27C8
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjDNP67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDNP65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:58:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35CC83D2
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:58:54 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o2so18707060plg.4
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487934; x=1684079934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kQTN5TDDgYmrDFBT5h4Y0JZJSw6ynT1QEMNwRDNozwA=;
        b=QsRX2N0BEBnStGPpZ2E55kHq0mp8KwWRq4lVSCdeegl04fhbKnC+6/jv3qn8eynBBI
         kZfiyYdmS6HPY/l71MvtyU8h+dviNlcSvTAbITK6yYcTKDCMAgQ8F71wkIN9DyY4WbQA
         etmEnhMAQYKLIccQPDE5SH9pqY/eyouo1NNexDcKjlz8bZUqEoXmwH9HC9ZRliWtJRkN
         GvxyE7pC/sqqwUgKrSW7IVET7Va2nNOjjs9X75xMA9jIlty9YJqK7/Ejij/pru3j9ZdR
         wId+c+TuDT0e5VDvY2z5BJ/GHB/GkufBzoVnHZGhMvhqn8s0r8Eo5VHhjozxYg7QYUGl
         jlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487934; x=1684079934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kQTN5TDDgYmrDFBT5h4Y0JZJSw6ynT1QEMNwRDNozwA=;
        b=fXPYocm9KNyXDY5/EE2yNu8ZzxU5DF1FefQYAAmuLCs7np6Tw3hSUd6AjXkIitsBOE
         gPa3Gws+tjlDgtYO/m8laChYxRpj7GneyTyqYoDpuk7UanAFZ5z3/GeyghG2d/vqP53n
         d3UYFYzmZHsJ4ODKT6IA5HwVxWTlIWMyIEh+wM4GIC4b95eWTCs26wTNF93DedfdNDfs
         VaWF9kP3m7w1VmuYTc0LtyDRUHFFHi4BApaYEnX2x63kTvVTY49sbXbczd5LQgchSLHk
         mkVGMuuLRWPcguTrvyZUf0MdB1WYalaozRDvOUZd2nReMibQEv094didv0iqLd0hLDfJ
         XiSg==
X-Gm-Message-State: AAQBX9cEE7NkD5719k78797Gb4hKzffEZYTHY77I5xHtMPbn0nSj2vsy
        YW4Ot0ouK439hVb7tSuHWjzmlg==
X-Google-Smtp-Source: AKy350ZdaYpNHVboRqmZmL1t3PFvtI5TcfdiEqKoDxd+QcyqGhrpOx+e7yHhVUnnjZKJtxH3h/xaaA==
X-Received: by 2002:a17:902:d40c:b0:1a6:712c:24c5 with SMTP id b12-20020a170902d40c00b001a6712c24c5mr2753876ple.69.1681487934269;
        Fri, 14 Apr 2023 08:58:54 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:58:53 -0700 (PDT)
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
Subject: [PATCH -next v18 00/20] riscv: Add vector ISA support
Date:   Fri, 14 Apr 2023 15:58:23 +0000
Message-Id: <20230414155843.12963-1-andy.chiu@sifive.com>
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

Source tree:
https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v18

Updated patches: 7, 10, 11
New patches: (none)
Unchanged patches: 1, 2, 3, 4, 5, 6, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20

Thanks in advance for your kind feedback!
Regards,
Andy Chiu

Links:
 - [1] https://lore.kernel.org/all/20220921214439.1491510-17-stillson@rivosinc.com/
 - [2] https://lore.kernel.org/all/73c0124c-4794-6e40-460c-b26df407f322@rivosinc.com/T/#u
 - [3] https://lore.kernel.org/all/20230128082847.3055316-1-apatel@ventanamicro.com/
 - [4] https://lore.kernel.org/all/CAHk-=wiAxtKyxs6BPEzirrXw1kXJ-7ZyGpgOrbzhmC=ud-6jBA@mail.gmail.com/

---
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


*** BLURB HERE ***

Andy Chiu (4):
  riscv: Allocate user's vector context in the first-use trap
  riscv: signal: check fp-reserved words unconditionally
  riscv: signal: validate altstack to reflect Vector
  riscv: detect assembler support for .option arch

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

 arch/riscv/Kconfig                       |  28 ++-
 arch/riscv/Makefile                      |   6 +-
 arch/riscv/include/asm/csr.h             |  18 +-
 arch/riscv/include/asm/elf.h             |   9 +
 arch/riscv/include/asm/hwcap.h           |   1 +
 arch/riscv/include/asm/insn.h            |  29 +++
 arch/riscv/include/asm/kvm_host.h        |   2 +
 arch/riscv/include/asm/kvm_vcpu_vector.h |  82 +++++++++
 arch/riscv/include/asm/processor.h       |   3 +
 arch/riscv/include/asm/switch_to.h       |   9 +-
 arch/riscv/include/asm/thread_info.h     |   3 +
 arch/riscv/include/asm/vector.h          | 180 +++++++++++++++++++
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
 arch/riscv/kernel/ptrace.c               |  70 ++++++++
 arch/riscv/kernel/setup.c                |   3 +
 arch/riscv/kernel/signal.c               | 220 ++++++++++++++++++++---
 arch/riscv/kernel/smpboot.c              |   7 +
 arch/riscv/kernel/traps.c                |  26 ++-
 arch/riscv/kernel/vector.c               | 127 +++++++++++++
 arch/riscv/kvm/Makefile                  |   1 +
 arch/riscv/kvm/vcpu.c                    |  23 +++
 arch/riscv/kvm/vcpu_vector.c             | 186 +++++++++++++++++++
 include/uapi/linux/elf.h                 |   1 +
 32 files changed, 1129 insertions(+), 49 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
 create mode 100644 arch/riscv/include/asm/vector.h
 create mode 100644 arch/riscv/kernel/vector.c
 create mode 100644 arch/riscv/kvm/vcpu_vector.c

-- 
2.17.1

