Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858F079264F
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjIEQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344514AbjIEDrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 23:47:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA3DCC7;
        Mon,  4 Sep 2023 20:47:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68a3f1d8be2so1609860b3a.3;
        Mon, 04 Sep 2023 20:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693885634; x=1694490434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wu9j4OkQlij9hX3sOBxtoguWLNmOkEhzG1dxFHt2D8c=;
        b=Wk8qczVJjzFdGp2kEhDIX7apreNKjfRQ3gQLrQ+aHhjzNQTQTdH3Nu0SmUKBTJZQEI
         v9zSWefXksThK2/H1D2hMWNsNNUz8aZucc8h0rzsxuLhFG1Z0FtgQmXqFV/norLRJeZa
         VnAI33qmrWTbXGMtNz2b6U1ec82U6tqtw09TFgzDpwAshB8rhK45jpId93qyAqoIHh8v
         Gbe2KeMfG0vSdZ+Oc9JPXWqbQga08PnYBEIujH7AA+vZSlUvkWdsnsf/HR/hUU1B4070
         6qrdutYavjis5/as4zYzKUUMbBhknp1T7M2dub9hKTI3ozDMFDOT4NuZu5VNXhXyLSLl
         qUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693885634; x=1694490434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wu9j4OkQlij9hX3sOBxtoguWLNmOkEhzG1dxFHt2D8c=;
        b=LY4cYSyiJ35o9MncvOKW0QjmXIH8KUnj4qDu9KD6pfn1zVt2gR4NSBi9kBFmQWutqc
         EgoprD3Oujre6LuEC823NcwGA0skowvhe8edXEbklyURXABqIQrhj2WkCP/iJQn3mQkD
         cqH+ew9WVM4SKPIcLdA1r1swmjXwoTz4itwz3yQ6M4efcJefjUwHbufKT9FTIfbpBdTk
         cZCgtaN13bwR9eCaaxSpweezYaebAIe3xeJ0XmZBFj5KHrTAeBacdeijjImGfttKoyeq
         DOPnPr6zfdl6VQz0HLyW7hGBt4nVJ9CVnd68FsW7+qXqWWbNwPcIDpmVCSOrpfeQPawx
         RF3A==
X-Gm-Message-State: AOJu0YwaYa+4NN5fD0jfMQcF0agU3H5uP/bxKTM6A0s7h5ZEWcFxrGJW
        pfJfUdiHxvbBHN7pu4/QD09N64nwYXN7hYxyz+8=
X-Google-Smtp-Source: AGHT+IGXGBWdNysCh5nbeFw7KKV6tJB8tZUdKNSXvaeZ1FXLEBSkDe8uZ6knI1oe2Hb5ck4IjJTdUw==
X-Received: by 2002:a05:6a00:c86:b0:68b:eb5a:664 with SMTP id a6-20020a056a000c8600b0068beb5a0664mr15087170pfv.22.1693885633661;
        Mon, 04 Sep 2023 20:47:13 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([129.41.57.2])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78097000000b0063f0068cf6csm7994951pff.198.2023.09.04.20.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 20:47:13 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v4 00/11] KVM: PPC: Nested APIv2 guest support
Date:   Tue,  5 Sep 2023 13:46:47 +1000
Message-Id: <20230905034658.82835-1-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A nested-HV API for PAPR has been developed based on the KVM-specific
nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API had
to break compatibility to accommodate implementation in other
hypervisors and partitioning firmware. The existing KVM-specific API
will be known as the Nested APIv1 and the PAPR API will be known as the
Nested APIv2. 

The control flow and interrupt processing between L0, L1, and L2 in
the Nested APIv2 are conceptually unchanged. Where Nested APIv1 is almost
stateless, the Nested APIv2 is stateful, with the L1 registering L2 virtual
machines and vCPUs with the L0. Supervisor-privileged register switching
duty is now the responsibility for the L0, which holds canonical L2
register state and handles all switching. This new register handling
motivates the "getters and setters" wrappers to assist in syncing the
L2s state in the L1 and the L0.

Broadly, the new hcalls will be used for  creating and managing guests
by a regular partition in the following way:

  - L1 and L0 negotiate capabilities with
    H_GUEST_{G,S}ET_CAPABILITIES

  - L1 requests the L0 create a L2 with
    H_GUEST_CREATE and receives a handle to use in future hcalls

  - L1 requests the L0 create a L2 vCPU with
    H_GUEST_CREATE_VCPU

  - L1 sets up the L2 using H_GUEST_SET and the
    H_GUEST_VCPU_RUN input buffer

  - L1 requests the L0 runs the L2 vCPU using H_GUEST_VCPU_RUN

  - L2 returns to L1 with an exit reason and L1 reads the
    H_GUEST_VCPU_RUN output buffer populated by the L0

  - L1 handles the exit using H_GET_STATE if necessary

  - L1 reruns L2 vCPU with H_GUEST_VCPU_RUN

  - L1 frees the L2 in the L0 with H_GUEST_DELETE

Further details are available in Documentation/powerpc/kvm-nested.rst.

This series adds KVM support for using this hcall interface as a regular
PAPR partition, i.e. the L1. It does not add support for running as the
L0.

The new hcalls have been implemented in the spapr qemu model for
testing.

This is available at https://github.com/planetharsh/qemu/tree/upstream-0714-kop

There are scripts available to assist in setting up an environment for
testing nested guests at https://github.com/iamjpn/kvm-powervm-test

A tree with this series is available at
https://github.com/iamjpn/linux/tree/features/kvm-nestedv2-v4

Thanks to Amit Machhiwal, Kautuk Consul, Vaibhav Jain, Michael Neuling,
Shivaprasad Bhat, Harsh Prateek Bora, Paul Mackerras and Nicholas
Piggin.

Change overview in v4:
  - Split previous "KVM: PPC: Use getters and setters for vcpu register
    state" into a number of seperate patches
    - Remove _hv suffix from VCORE wrappers
    - Do not create arch_compat and lpcr setters, use the existing ones
    - Use #ifdef ALTIVEC
  - KVM: PPC: Rename accessor generator macros
    - Fix typo
  - KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
    - Use u64
    - Change format strings instead of casting
  - KVM: PPC: Add support for nestedv2 guests
    - Batch H_GUEST_GET calls in kvmhv_nestedv2_reload_ptregs()
    - Fix compile without CONFIG_PSERIES
    - Fix maybe uninitialized 'trap' in kvmhv_p9_guest_entry()
    - Extend existing setters for arch_compat and lpcr


Change overview in v3:
  - KVM: PPC: Use getters and setters for vcpu register state
      - Do not add a helper for pvr
      - Use an expression when declaring variable in case
      - Squash in all getters and setters
      - Pass vector registers by reference
  - KVM: PPC: Rename accessor generator macros
      - New to series
  - KVM: PPC: Add helper library for Guest State Buffers
      - Use EXPORT_SYMBOL_GPL()
      - Use the kvmppc namespace
      - Move kvmppc_gsb_reset() out of kvmppc_gsm_fill_info()
      - Comments for GSID elements
      - Pass vector elements by reference
      - Remove generic put and get functions
  - KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
      - New to series
  - KVM: PPC: Add support for nestedv2 guests
      - Use EXPORT_SYMBOL_GPL()
      - Change to kvmhv_nestedv2 namespace
      - Make kvmhv_enable_nested() return -ENODEV on NESTEDv2 L1 hosts
      - s/kvmhv_on_papr/kvmhv_is_nestedv2/
      - mv book3s_hv_papr.c book3s_hv_nestedv2.c
      - Handle shared regs without a guest state id in the same wrapper
      - Use a static key for API version
      - Add a positive test for NESTEDv1
      - Give the amor a static value
      - s/struct kvmhv_nestedv2_host/struct kvmhv_nestedv2_io/
      - Propagate failure in kvmhv_vcpu_entry_nestedv2()
      - WARN if getters and setters fail
      - Progagate failure from kvmhv_nestedv2_parse_output()
      - Replace delay with sleep in plpar_guest_{create,delete,create_vcpu}()
      - Add logical PVR handling
      - Replace kvmppc_gse_{get,put} with specific version
  - docs: powerpc: Document nested KVM on POWER
      - Fix typos


Change overview in v2:
  - Rebase on top of kvm ppc prefix instruction support
  - Make documentation an individual patch
  - Move guest state buffer files from arch/powerpc/lib/ to
    arch/powerpc/kvm/
  - Use kunit for testing guest state buffer
  - Fix some build errors
  - Change HEIR element from 4 bytes to 8 bytes

Previous revisions:

  - v1: https://lore.kernel.org/linuxppc-dev/20230508072332.2937883-1-jpn@linux.vnet.ibm.com/
  - v2: https://lore.kernel.org/linuxppc-dev/20230605064848.12319-1-jpn@linux.vnet.ibm.com/
  - v3: https://lore.kernel.org/linuxppc-dev/20230807014553.1168699-1-jniethe5@gmail.com/

Jordan Niethe (10):
  KVM: PPC: Always use the GPR accessors
  KVM: PPC: Introduce FPR/VR accessor functions
  KVM: PPC: Rename accessor generator macros
  KVM: PPC: Use accessors for VCPU registers
  KVM: PPC: Use accessors VCORE registers
  KVM: PPC: Book3S HV: Use accessors for VCPU registers
  KVM: PPC: Book3S HV: Introduce low level MSR accessor
  KVM: PPC: Add helper library for Guest State Buffers
  KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
  KVM: PPC: Add support for nestedv2 guests

Michael Neuling (1):
  docs: powerpc: Document nested KVM on POWER

 Documentation/powerpc/index.rst               |   1 +
 Documentation/powerpc/kvm-nested.rst          | 636 +++++++++++
 arch/powerpc/Kconfig.debug                    |  12 +
 arch/powerpc/include/asm/guest-state-buffer.h | 995 +++++++++++++++++
 arch/powerpc/include/asm/hvcall.h             |  30 +
 arch/powerpc/include/asm/kvm_book3s.h         | 220 +++-
 arch/powerpc/include/asm/kvm_book3s_64.h      |   8 +-
 arch/powerpc/include/asm/kvm_booke.h          |  10 +
 arch/powerpc/include/asm/kvm_host.h           |  22 +-
 arch/powerpc/include/asm/kvm_ppc.h            | 102 +-
 arch/powerpc/include/asm/plpar_wrappers.h     | 248 ++++-
 arch/powerpc/kvm/Makefile                     |   4 +
 arch/powerpc/kvm/book3s.c                     |  38 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |   7 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |  31 +-
 arch/powerpc/kvm/book3s_64_vio.c              |   4 +-
 arch/powerpc/kvm/book3s_hv.c                  | 358 +++++--
 arch/powerpc/kvm/book3s_hv.h                  |  76 ++
 arch/powerpc/kvm/book3s_hv_builtin.c          |  11 +-
 arch/powerpc/kvm/book3s_hv_nested.c           |  42 +-
 arch/powerpc/kvm/book3s_hv_nestedv2.c         | 998 ++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_p9_entry.c         |   4 +-
 arch/powerpc/kvm/book3s_hv_ras.c              |   4 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |   8 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c          |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c            |   2 +-
 arch/powerpc/kvm/book3s_xive.c                |  12 +-
 arch/powerpc/kvm/emulate_loadstore.c          |   6 +-
 arch/powerpc/kvm/guest-state-buffer.c         | 621 +++++++++++
 arch/powerpc/kvm/powerpc.c                    |  76 +-
 arch/powerpc/kvm/test-guest-state-buffer.c    | 328 ++++++
 31 files changed, 4655 insertions(+), 263 deletions(-)
 create mode 100644 Documentation/powerpc/kvm-nested.rst
 create mode 100644 arch/powerpc/include/asm/guest-state-buffer.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_nestedv2.c
 create mode 100644 arch/powerpc/kvm/guest-state-buffer.c
 create mode 100644 arch/powerpc/kvm/test-guest-state-buffer.c

-- 
2.39.3

