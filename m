Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7052C6B6461
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCLJzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCLJzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3175071F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614902; x=1710150902;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D9VPyGKd4LILCREEQjIY0JKQ3OrHW6qI5nhjOmTfMg0=;
  b=O0V5hhuE+GIp2pz6FR/V2hY+nOQI5/b+z0NOFvL+k7ySx7ELsF+UgmaI
   w36CHz7PKkJjsX+EIlttCnPIm10qpxfGUFa3CJETDGjH2TEHymI6/YtiZ
   L8/QcQOKHfndjhspGqXU23ay35RIl3vB3t6dkd3gIxF30sHGQEPbGlaAW
   cpdoPhMhm1tN2QOJO+kGCQVm9uQ60JeVMTmn9WvsUH5z+3TITdwbHfatM
   YyDt5hgQUCy4mgAAnLvk0qTs4dVOy7j3E+O0E2II6w156Ig0D77HUEn7w
   4q0YoXVK3vwiIx72svWrhRHaz1rAKOtM0kJLjunijbjAdb7etzIFBt1P8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623008"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623008"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660774"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660774"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:58 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 00/22] Isolate pKVM & host
Date:   Mon, 13 Mar 2023 02:01:30 +0800
Message-Id: <20230312180152.1778338-1-jason.cj.chen@intel.com>
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

This patch set is part-3 of this RFC patches. It introduces page
table management for pKVM on Intel platform, and based on it, build
pKVM's MMU page table and host EPT page table.

pKVM needs isolated address space, so it shall have its own MMU
page table. At the same time, host VM shall not be able to access
pKVM's memory, host EPT page table shall be setup for it.

pKVM requires its own memory pool and memory allocation to setup
above MMU & EPT page table, it leverages the memory reservation
mechanism and buddy page allocator from ARM solution.

The setup of MMU/EPT page table is triggered by new added hypercall
init-finalise after host OS got deprivileged.

After MMU/EPT setup, pKVM can access all system memory, while host VM
can access most of system memory except ones owned by pKVM.

For MMIO access, host EPT only prepared mapping below 4G, for high
address MMIO access from host VM, needs to build during runtime host EPT
violation.

Chuanxiao Dong (3):
  pkvm: x86: Introduce general page table management framework
  pkvm: x86: Introduce find_mem_range API
  pkvm: x86: Dynamically handle host MMIO EPT violation

Jason Chen CJ (19):
  pkvm: x86: Define hypervisor runtime VA/PA APIs
  pkvm: x86: Add arch specific spinlock
  pkvm: x86: Add memset lib
  pkvm: x86: Add buddy page allocator
  pkvm: x86: Generate pkvm_constants.h for pKVM initialization
  pkvm: x86: Calculate total reserve page numbers
  pkvm: x86: Reserve memory for pKVM
  pkvm: x86: Early alloc from reserved memory
  pkvm: x86: Initialize MMU/EPT configuration
  pkvm: x86: Add early allocator based mm_ops
  pkvm: x86: Define linker script alias for kernel-proper symbol
  pkvm: x86: Introduce MMU pgtable support
  pkvm: x86: Add global pkvm_hyp pointer
  pkvm: x86: Add init-finalise hypercall
  pkvm: x86: Create MMU pgtable in init-finalise hypercall
  pkvm: x86: Add vmemmap and switch to buddy page allocator
  pkvm: x86: Introduce host EPT pgtable support
  pkvm: x86: Create host EPT pgtable in init-finalise hypercall
  pkvm: x86: Add pgtable API pkvm_pgtable_lookup

 arch/x86/include/asm/kvm_pkvm.h           | 134 ++++++
 arch/x86/include/asm/pkvm_image.h         |   6 +
 arch/x86/include/asm/pkvm_image_vars.h    |  18 +
 arch/x86/include/asm/pkvm_spinlock.h      |  73 +++
 arch/x86/kernel/setup.c                   |   3 +
 arch/x86/kernel/vmlinux.lds.S             |   4 +
 arch/x86/kvm/.gitignore                   |   1 +
 arch/x86/kvm/vmx/pkvm/Makefile            |  20 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |   9 +-
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c   |  73 +++
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h   |  15 +
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           | 223 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h           |  21 +
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 296 ++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S |  24 +
 arch/x86/kvm/vmx/pkvm/hyp/memory.c        |  65 +++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h        |  23 +
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           | 230 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h           |  19 +
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c       | 560 ++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h       |  81 ++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c          |   8 +
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h      |  10 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c        |  36 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h           |  48 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h       |   5 +-
 arch/x86/kvm/vmx/pkvm/include/pkvm.h      |  49 ++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c    |  15 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         | 220 +++++++--
 virt/kvm/pkvm/gfp.h                       |   1 +
 virt/kvm/pkvm/pkvm.c                      |   1 +
 31 files changed, 2245 insertions(+), 46 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm_pkvm.h
 create mode 100644 arch/x86/include/asm/pkvm_image_vars.h
 create mode 100644 arch/x86/include/asm/pkvm_spinlock.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/ept.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/ept.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/memory.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/memory.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/mmu.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/mmu.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmx.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/pkvm_constants.c

-- 
2.25.1

