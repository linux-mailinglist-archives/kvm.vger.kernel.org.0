Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941FE6B6449
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCLJyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCLJyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AE237F0C
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614834; x=1710150834;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IB+nrOnT5dpqM3uxVxHGi5eT2MRdUOqDC40SwcShEU4=;
  b=hNYZnp42DQZgyqQfZb5hUeuEnr3B+jqsTwwsw1IpS4UV8DcXGJdwJ27h
   +8WD65Pps0HlI8NOGtvdp8W2D0y0KCtItQA76zh/zdQwT++tOU3mpNbHX
   GXpZvMwBrJ3wSy9htpsUe4AbQnjt3T4mEH3QOHNSkkSX5/9Y/1o6Iy5Ux
   UcchtKhjVtr77fVg2+abAZ7vFkhTcRFRuuY7RRPvGHRDLgqrsx0ub9DxT
   tLaCa+WC8BpLWzB5NB8KfrT/ginLcU1hpIc4KYnDRq9HeWmpBP3UM4iCH
   AM02wPUAoISnK9tbYaMQ0XrB7IizzCQs+qgfnVANgvm3jTHkMKlL0sHfx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622818"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622818"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408896"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408896"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:53 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Date:   Mon, 13 Mar 2023 02:00:43 +0800
Message-Id: <20230312180048.1778187-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected-KVM (pKVM) on Intel platform is designed as a thin hypervisor
to extend KVM supporting VMs isolated from the host.

I am sending out this RFC requesting early review. The patches are in a
little early stage and with large LOC, I hope they can present you the
basic idea of pKVM on Intel platform, and give you an overview of most
fundamental changes needed to launch VMs on top of pKVM hypervisor. The
patches are finally intended to slice into more digestible pieces for
review and merge.

The concept of pKVM is first introduced by Google for ARM platform
[1][2][3], which aims to extend Trust Execution Environment (TEE) from
ARM secure world to virtual machines (VMs). Such VMs are protected by the
pKVM from the host OS or other VMs accessing the payloads running inside
(so called protected VM). More details about the overall idea, design,
and motivations can be found in Will's talk at KVM forum 2020 [4].

There are similar use cases on x86 platforms requesting protected
environment which is isolated from host OS for confidential computing.
Meanwhile host OS still presents the primary user interface and people
will expect the same bare metal experience as before in terms of both
performance and functionalities (like rich-IO usages), so the host OS
is desired to remain the ability to manage the system resources as much
as possible. At the same time, in order to mitigate the attack to the
confidential computing environment, the Trusted Computing Base (TCB) of
the solution shall be minimized.

HW solutions e.g. TDX [5] also exist to support above use cases. But
they are available only on very new platforms. Hence having a software
solution on massive existing platforms is also plausible.

pKVM has the merit of both providing an isolated environment for
protected VMs and also sustaining rich bare metal experiences as
expected by the host OS. This is achieved by creating a small
hypervisor below the host OS which contains only minimal
functionalities (e.g. VMX, EPT, IOMMU, etc.) for isolating protected
VMs from host OS and other VMs. In the meantime the host kernel still
remains access to most of the system resources and plays the role of
managing VM life cycles, allocating VM resources, etc. Existing KVM
module calls into the hypervisor (via emulation or enlightened PV ops)
to complete missing functionalities which have been moved downward.

      +--------------------+   +-----------------+
      |                    |   |                 |
      |     host VM        |   |  protected VM   |
      |    (act like       |   |                 |
      |   on bare metal)   |   |                 |
      |			   |   +-----------------+
      |                    +---------------------+
      |            +--------------------+        |
      |            | vVMX, vEPT, vIOMMU |        |
      |            +--------------------+        |
      +------------------------------------------+
      +------------------------------------------+
      |       pKVM (own VMX, EPT, IOMMU)         |
      +------------------------------------------+

[note: above figure is based on Intel terminologies]

The terminologies used in this RFC series:

- host VM:     native Linux which boot pKVM then deprivilege to a VM
- protected VM: VM launched by host but protected by pKVM
- normal VM:    VM launched & protected by host

pKVM binary is compiled as an extension of KVM module, but resides in a
separate, dedicated memory section of the vmlinux image. It makes pKVM
easy to release and verified boot together with Linux kernel image. It
also means pKVM is a post-launched hypervisor since it's started by KVM
module.

ARM platform naturally supports different exception level (EL) and the
host kernel can be set to run at EL1 during the early boot stage before
launching pKVM hypervisor, so pKVM just needs to be installed to EL2.
On Intel platform, the host Linux kernel is originally running in VMX
root mode, then deprivileged to run into vmx non-root mode as a host VM,
whereas pKVM is kept running at VMX root mode. Comparing with pKVM on
ARM, pKVM on Intel platform needs more complicated deprivilege stage to
prepare and setup VMX environment in VMX root mode.

As a hypervisor, pKVM on Intel platform leverages virtualization
technologies (see below) to guarantee the isolation among itself and low
privilege guests (include host Linux) on top of it:

 - pKVM manages CPU state/context switch between hypervisor and different
   guests. It's largely done by VMCS.

 - pKVM owns EPT page table to manage the GPA to HPA mapping of its host
   VM and guest VMs, which ensures they will not touch the hypervisor's
   memory and isolate among each other. It's similar to pKVM on ARM which
   owns stage-2 MMU page table to isolate memory among hypervisor, host,
   protected VMs and normal VMs. To allow host manage EPT or stage-2 page
   tables, pKVM can choose to provide either PV ops or emulation for these
   page tables. pKVM on ARM chose PV ops, which providing hypervisor calls
   (HVCs) in pKVM for stage-2 MMU page table changes. pKVM on Intel
   platform provides emulation for EPT page table management - this avoids
   the code changes in x86 KVM MMU.

 - pKVM owns IOMMU (VT-d for Intel platform and SMMU for ARM platform)
   to manage device DMA buffer mapping to isolate DMA access. To allow
   host manage IOMMU page tables, smilar to EPT/stage-2 page table
   management, PV ops or emulation method could be chosen. pKVM on ARM
   chose PV ops [6], while pKVM on Intel platform will use IOMMU
   emulation (this RFC does not cover it and we are willing to change if
   see more advantages from PV ops).

A topic in KVM forum 2022 about supporting TEE on x86 client platforms
with pKVM [7] may help you understand more details about the framework
of pKVM on Intel platforms and the deltas between pKVM on Intel and ARM
platforms.

This RFC patch series is essential groundwork for future patch series.
Based on this RFC, host OS is deprivileged and normal VM can be launched
on top of pKVM hypervisor. Following is the TODO list after this series:

- protected VMs
   * page state management
   * security enforcement at vCPU context switch
   * QEMU & crosvm
   * fd-based proposal around KVM private memory [8]
   * guest attestation

- pass-thru devices
   * IOMMU virtualization

This RFC series is organized as follows:

  - Part-1 (this patch set) are refactor of small portions of the pKVM on
    ARM code to ease the pKVM on Intel platform's support;

  - Part-2 introduce pKVM on Intel platform and do the deprivilege for
    host OS, meantime build pKVM as an independent binary;

  - Part-3 introduce pgtable management in pKVM on Intel platform then
    finally isolate pKVM & host VM through creating its own address
    space (MMU + host EPT);

  - Part-4 are misc changes to support VPID, debug and nmi handling in
    pKVM on Intel platform;

  - Part-5 add VMX emulation based on shadow VMCS;

  - Part-6 add EPT emulation based on shadow EPT;

  - and finally part-7 add memory protection based on page stage
    management.

This work is based on Linux 6.2, and you can also get the branch if
you would like to:

  https://github.com/intel-staging/pKVM-IA/tree/RFC-v6.2

Thanks

Jason CJ Chen

[1]: https://lwn.net/Articles/836693/
[2]: https://lwn.net/Articles/837552/
[3]: https://lwn.net/Articles/895790/
[4]: https://kvmforum2020.sched.com/event/eE24/virtualization-for-the-masses-exposing-kvm-on-android-will-deacon-google
[5]: https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
[6]: https://lore.kernel.org/linux-arm-kernel/20230201125328.2186498-1-jean-philippe@linaro.org/T/
[7]: https://kvmforum2022.sched.com/event/15jKc/supporting-tee-on-x86-client-platforms-with-pkvm-jason-chen-intel
[8]: https://lwn.net/Articles/916589/

Jason Chen CJ (5):
  pkvm: arm64: Move nvhe/spinlock.h to include/asm dir
  pkvm: arm64: Make page allocator arch agnostic
  pkvm: arm64: Move page allocator to virt/kvm/pkvm
  pkvm: arm64: Make memory reservation arch agnostic
  pkvm: arm64: Move general part of memory reservation to virt/kvm/pkvm

 arch/arm64/include/asm/kvm_pkvm.h             |  8 ++
 .../asm/pkvm_spinlock.h}                      |  6 +-
 arch/arm64/kvm/Makefile                       |  3 +
 arch/arm64/kvm/hyp/hyp-constants.c            |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  4 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile              |  4 +-
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  4 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  6 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |  2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  4 +-
 arch/arm64/kvm/pkvm.c                         | 76 ++---------------
 .../memory.h => virt/kvm/pkvm/buddy_memory.h  | 10 +--
 .../hyp/include/nvhe => virt/kvm/pkvm}/gfp.h  | 10 +--
 .../hyp/nvhe => virt/kvm/pkvm}/page_alloc.c   |  3 +-
 virt/kvm/pkvm/pkvm.c                          | 84 +++++++++++++++++++
 19 files changed, 134 insertions(+), 102 deletions(-)
 rename arch/arm64/{kvm/hyp/include/nvhe/spinlock.h => include/asm/pkvm_spinlock.h} (95%)
 rename arch/arm64/kvm/hyp/include/nvhe/memory.h => virt/kvm/pkvm/buddy_memory.h (89%)
 rename {arch/arm64/kvm/hyp/include/nvhe => virt/kvm/pkvm}/gfp.h (86%)
 rename {arch/arm64/kvm/hyp/nvhe => virt/kvm/pkvm}/page_alloc.c (99%)
 create mode 100644 virt/kvm/pkvm/pkvm.c

-- 
2.25.1

