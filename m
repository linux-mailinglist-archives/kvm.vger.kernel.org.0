Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059325F121A
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiI3TIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 15:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiI3TIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 15:08:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7231D7BDA
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664564922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QRzyyCmCNmJWKnkITELLGxOI7FsQQI8IvhTf8+qIa/I=;
        b=KSlGATLLUovwlxrfeQ1w6og5eZaA8qBgIixOy9p481YBZOLq19mxIVFcd3gKYdO5PvnN4U
        GyMC9+YEOH5X8I/HCb0ccbw+7/Pb/ehHVBE1M08Fa78gLQQqlQGsmHIqQavioe5Mz+9HAF
        0hxAsbNAKVj+O1CfinhSC/xZeU9uQXM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-prWAGRE2N7iyC9kspetJGg-1; Fri, 30 Sep 2022 15:08:40 -0400
X-MC-Unique: prWAGRE2N7iyC9kspetJGg-1
Received: by mail-ed1-f71.google.com with SMTP id c6-20020a05640227c600b004521382116dso4234214ede.22
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:08:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=QRzyyCmCNmJWKnkITELLGxOI7FsQQI8IvhTf8+qIa/I=;
        b=AO/SL5TW4kxuDLC+bVWeEYl+wGOv8Wf2gKqsy6yoouOcVklInj69CmBbuqPj5kP7z8
         HympoHEVT7Qn0tz280om9UzVJLMV01g2alY7nMI4KIeIuNjdLQAh0wwy1uQE3Hzc68Cj
         PnJTJkW5PpmepfRfaSxT5Ujpas8GTN41HZGGaDJKoKcyznmV6SC/O3BM+OMOwqBzMvwE
         f7txN5M7qc5bpAXd/7Yo8W+/1ujQAIpz0tKuPHTvKxNrBDWtnCg5HhjefTcTWN3wekW+
         BOkUCDLXYMldl58eNKY+W/Bqe7CUoKL7SzKLL6g1J4WtAE65qEaasr3INSsyacVyqkC8
         bVBQ==
X-Gm-Message-State: ACrzQf2gynpA3MGrh5P+bJ6qosLtJ4/Tnu+oaPL2dSflNl86OERAnOgI
        FTm8+db8tytYKrO4HI7QjlmDzTpG/hPX2GLE1eRsV6GYTLA98ELTE2X89jn8pn+9W+VPI7ELczY
        uWGHaaID4iuLy
X-Received: by 2002:a05:6402:204a:b0:456:eed5:5f2c with SMTP id bc10-20020a056402204a00b00456eed55f2cmr9054192edb.200.1664564919173;
        Fri, 30 Sep 2022 12:08:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5f+6ImkiqMMMpKXAVej3idNcYRRTQXvAmb7ov7zdytGGALbUSxPraf1RX0k0bIKEiusFaK4Q==
X-Received: by 2002:a05:6402:204a:b0:456:eed5:5f2c with SMTP id bc10-20020a056402204a00b00456eed55f2cmr9054175edb.200.1664564918827;
        Fri, 30 Sep 2022 12:08:38 -0700 (PDT)
Received: from avogadro.local ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.gmail.com with ESMTPSA id la15-20020a170907780f00b007812ba2a360sm1601357ejc.149.2022.09.30.12.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:08:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.1
Date:   Fri, 30 Sep 2022 21:08:36 +0200
Message-Id: <20220930190836.116605-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 372d07084593dc7a399bf9bee815711b1fb1bcf2:

  KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE() (2022-08-19 07:38:05 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c59fb127583869350256656b7ed848c398bef879:

  KVM: remove KVM_REQ_UNHALT (2022-09-26 12:37:21 -0400)

----------------------------------------------------------------
The first batch of KVM patches, mostly covering x86, which I
am sending out early due to me travelling next week.  There is a
lone mm patch for which Andrew gave an informal ack at
https://lore.kernel.org/linux-mm/20220817102500.440c6d0a3fce296fdf91bea6@linux-foundation.org.

I will send the bulk of ARM work, as well as other
architectures, at the end of next week.

ARM:

* Account stage2 page table allocations in memory stats.

x86:

* Account EPT/NPT arm64 page table allocations in memory stats.

* Tracepoint cleanups/fixes for nested VM-Enter and emulated MSR accesses.

* Drop eVMCS controls filtering for KVM on Hyper-V, all known versions of
  Hyper-V now support eVMCS fields associated with features that are
  enumerated to the guest.

* Use KVM's sanitized VMCS config as the basis for the values of nested VMX
  capabilities MSRs.

* A myriad event/exception fixes and cleanups.  Most notably, pending
  exceptions morph into VM-Exits earlier, as soon as the exception is
  queued, instead of waiting until the next vmentry.  This fixed
  a longstanding issue where the exceptions would incorrecly become
  double-faults instead of triggering a vmexit; the common case of
  page-fault vmexits had a special workaround, but now it's fixed
  for good.

* A handful of fixes for memory leaks in error paths.

* Cleanups for VMREAD trampoline and VMX's VM-Exit assembly flow.

* Never write to memory from non-sleepable kvm_vcpu_check_block()

* Selftests refinements and cleanups.

* Misc typo cleanups.

Generic:

* remove KVM_REQ_UNHALT

----------------------------------------------------------------
Aaron Lewis (1):
      KVM: x86: Delete duplicate documentation for KVM_X86_SET_MSR_FILTER

David Matlack (1):
      KVM: nVMX: Add tracepoint for nested VM-Enter

Hou Wenlong (2):
      KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
      KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path

Jilin Yuan (1):
      KVM: x86/mmu: fix repeated words in comments

Jim Mattson (1):
      KVM: x86: VMX: Replace some Intel model numbers with mnemonics

Junaid Shahid (1):
      kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails

Liam Ni (1):
      KVM:x86: Clean up ModR/M "reg" initialization in reg op decoding

Miaohe Lin (2):
      KVM: x86/mmu: fix memoryleak in kvm_mmu_vendor_module_init()
      KVM: fix memoryleak in kvm_init()

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mingwei Zhang (2):
      KVM: x86: Update trace function for nested VM entry to support VMX
      KVM: x86: Print guest pgd in kvm_nested_vmenter()

Oliver Upton (2):
      KVM: selftests: Require DISABLE_NX_HUGE_PAGES cap for NX hugepage test
      mailmap: Update Oliver's email address

Paolo Bonzini (6):
      KVM: SVM: remove unnecessary check on INIT intercept
      KVM: x86: make vendor code check for all nested events
      KVM: x86: lapic does not have to process INIT if it is blocked
      KVM: x86: never write to memory from kvm_vcpu_check_block()
      KVM: mips, x86: do not rely on KVM_REQ_UNHALT
      KVM: remove KVM_REQ_UNHALT

Sean Christopherson (44):
      KVM: x86: Use u64 for address and error code in page fault tracepoint
      KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
      KVM: x86: Report error when setting CPUID if Hyper-V allocation fails
      KVM: nVMX: Treat eVMCS as enabled for guest iff Hyper-V is also enabled
      KVM: nVMX: Use CC() macro to handle eVMCS unsupported controls checks
      KVM: nVMX: WARN once and fail VM-Enter if eVMCS sees VMFUNC[63:32] != 0
      KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02
      KVM: nVMX: Always emulate PERF_GLOBAL_CTRL VM-Entry/VM-Exit controls
      KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit kernels/KVM
      KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
      KVM: x86: Don't check for code breakpoints when emulating on exception
      KVM: x86: Allow clearing RFLAGS.RF on forced emulation to test code #DBs
      KVM: x86: Suppress code #DBs on Intel if MOV/POP SS blocking is active
      KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
      KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
      KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)
      KVM: x86: Use DR7_GD macro instead of open coding check in emulator
      KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
      KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
      KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
      KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
      KVM: x86: Make kvm_queued_exception a properly named, visible struct
      KVM: x86: Formalize blocking of nested pending exceptions
      KVM: x86: Use kvm_queue_exception_e() to queue #DF
      KVM: x86: Hoist nested event checks above event injection logic
      KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential VM-Exit
      KVM: nVMX: Add a helper to identify low-priority #DB traps
      KVM: nVMX: Document priority of all known events on Intel CPUs
      KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
      KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
      KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle behavior
      KVM: x86: Rename inject_pending_events() to kvm_check_and_inject_events()
      KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
      KVM: selftests: Add an x86-only test to verify nested exception queueing
      KVM: x86: Allow force_emulation_prefix to be written without a reload
      KVM: nVMX: Make an event request when pending an MTF nested VM-Exit
      KVM: x86: Rename and expose helper to detect if INIT/SIPI are allowed
      KVM: x86: Rename kvm_apic_has_events() to make it INIT/SIPI specific
      KVM: SVM: Make an event request if INIT or SIPI is pending when GIF is set
      KVM: nVMX: Make an event request if INIT or SIPI is pending on VM-Enter
      KVM: nVMX: Make event request on VMXOFF iff INIT/SIPI is pending
      KVM: x86: Don't snapshot pending INIT/SIPI prior to checking nested events

Uros Bizjak (2):
      KVM/VMX: Avoid stack engine synchronization uop in __vmx_vcpu_run
      KVM: VMX: Do not declare vmread_error() asmlinkage

Vitaly Kuznetsov (23):
      x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
      x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
      KVM: x86: Zero out entire Hyper-V CPUID cache before processing entries
      KVM: nVMX: Refactor unsupported eVMCS controls logic to use 2-d array
      KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
      KVM: nVMX: Support several new fields in eVMCSv1
      KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
      KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
      KVM: selftests: Switch to updated eVMCSv1 definition
      KVM: nVMX: Support PERF_GLOBAL_CTRL with enlightened VMCS
      KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
      KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
      KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
      KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
      KVM: VMX: Extend VMX controls macro shenanigans
      KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of setup_vmcs_config()
      KVM: VMX: Add missing VMEXIT controls to vmcs_config
      KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
      KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()
      KVM: nVMX: Always set required-1 bits of pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
      KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
      KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
      KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up nested MSR

Wonhyuk Yang (1):
      KVM: Add extra information in kvm_page_fault trace point

Yosry Ahmed (3):
      mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
      KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
      KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

 .mailmap                                           |   1 +
 Documentation/admin-guide/cgroup-v2.rst            |   5 +
 Documentation/filesystems/proc.rst                 |   4 +
 Documentation/virt/kvm/api.rst                     | 113 +---
 Documentation/virt/kvm/vcpu-requests.rst           |  28 +-
 arch/arm64/kvm/arm.c                               |   1 -
 arch/arm64/kvm/mmu.c                               |  36 +-
 arch/mips/kvm/emulate.c                            |   6 +-
 arch/powerpc/kvm/book3s_pr.c                       |   1 -
 arch/powerpc/kvm/book3s_pr_papr.c                  |   1 -
 arch/powerpc/kvm/booke.c                           |   1 -
 arch/powerpc/kvm/powerpc.c                         |   1 -
 arch/riscv/kvm/vcpu_insn.c                         |   1 -
 arch/s390/kvm/kvm-s390.c                           |   2 -
 arch/x86/include/asm/hyperv-tlfs.h                 |  22 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  39 +-
 arch/x86/kvm/cpuid.c                               |  18 +-
 arch/x86/kvm/emulate.c                             |  31 +-
 arch/x86/kvm/hyperv.c                              |  70 ++-
 arch/x86/kvm/hyperv.h                              |   6 +-
 arch/x86/kvm/lapic.c                               |  38 +-
 arch/x86/kvm/lapic.h                               |   9 +-
 arch/x86/kvm/mmu/mmu.c                             |  22 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  12 +
 arch/x86/kvm/svm/nested.c                          | 124 +++--
 arch/x86/kvm/svm/svm.c                             |  35 +-
 arch/x86/kvm/trace.h                               |  53 +-
 arch/x86/kvm/vmx/capabilities.h                    |  14 +-
 arch/x86/kvm/vmx/evmcs.c                           | 192 ++++---
 arch/x86/kvm/vmx/evmcs.h                           |  10 +-
 arch/x86/kvm/vmx/nested.c                          | 468 +++++++++++------
 arch/x86/kvm/vmx/nested.h                          |   2 +-
 arch/x86/kvm/vmx/sgx.c                             |   2 +-
 arch/x86/kvm/vmx/vmenter.S                         |  24 +-
 arch/x86/kvm/vmx/vmx.c                             | 321 ++++++------
 arch/x86/kvm/vmx/vmx.h                             | 172 +++++-
 arch/x86/kvm/vmx/vmx_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 576 ++++++++++++++-------
 arch/x86/kvm/x86.h                                 |  16 +-
 arch/x86/kvm/xen.c                                 |   1 -
 drivers/base/node.c                                |   2 +
 fs/proc/meminfo.c                                  |   2 +
 include/linux/kvm_host.h                           |  16 +-
 include/linux/mmzone.h                             |   1 +
 mm/memcontrol.c                                    |   1 +
 mm/page_alloc.c                                    |   6 +-
 mm/vmstat.c                                        |   1 +
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/include/x86_64/evmcs.h |  45 +-
 .../selftests/kvm/include/x86_64/svm_util.h        |   7 +-
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  53 +-
 .../selftests/kvm/x86_64/nested_exceptions_test.c  | 295 +++++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  24 +-
 virt/kvm/kvm_main.c                                |   9 +-
 57 files changed, 1871 insertions(+), 1077 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c

