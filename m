Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15637769C4F
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjGaQYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjGaQYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:24:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65439A7
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820692; x=1722356692;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xEZHx0KbCw3rxQuoCBZM6LeOuuc/cDcIdUS8q7SYhFA=;
  b=CGq8epE3RXTDXXl7PHnGjUX5rNnPLsw+9a7XzpuMvlc5x3xHPHf+dSjY
   Gj3zCeD6EGY8iar7nY2mSbpgsy/gJMKZrLkt2vVELSwUF5gVQWjQnCiv0
   IrZwIV3Senk8VAOlILXLHVtDD7ZIOz03UCTcpOI0O25zs21iJsxsMnTVk
   4nynazDw1PcH6b8ZKfPd0JrIsu4aVEiz/MvDp2Fg7L7x915/gB69j9+eX
   oPcdS86+wuX6QZzlHDEYw6pzb/eOYnOjozOatBSRFHs8bcIMNRQoUDeH/
   6AwxQD0i9Hr5p3vIYQaX0Vsr3EMe7DyadveLT/vj2LdaWZ2en9aQFhXPz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993276"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993276"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:24:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757983862"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757983862"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:24:47 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 00/19] QEMU gmem implemention
Date:   Mon, 31 Jul 2023 12:21:42 -0400
Message-Id: <20230731162201.271114-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the first RFC version of enabling KVM gmem[1] as the backend for
private memory of KVM_X86_PROTECTED_VM.

It adds the support to create a specific KVM_X86_PROTECTED_VM type VM,
and introduces 'private' property for memory backend. When the vm type
is KVM_X86_PROTECTED_VM and memory backend has private enabled as below,
it will call KVM gmem ioctl to allocate private memory for the backend.

    $qemu -object memory-backend-ram,id=mem0,size=1G,private=on \
          -machine q35,kvm-type=sw-protected-vm,memory-backend=mem0 \
	  ...

Unfortunately this patch series fails the boot of OVMF at very early
stage due to triple fault because KVM doesn't support emulate string IO
to private memory. We leave it as an open to be discussed.

There are following design opens that need to be discussed:

1. how to determine the vm type?

   a. like this series, specify the vm type via machine property
      'kvm-type'
   b. check the memory backend, if any backend has 'private' property
      set, the vm-type is set to KVM_X86_PROTECTED_VM.

2. whether 'private' property is needed if we choose 1.b as design 

   with 1.b, QEMU can decide whether the memory region needs to be
   private (allocates gmem fd for it) or not, on its own.

3. What is KVM_X86_SW_PROTECTED_VM going to look like? What's the
   purose of it and what's the requirement on it. I think it's the
   questions for KVM folks than QEMU folks.

Any other idea/open/question is welcomed.


Beside, TDX QEMU implemetation is based on this series to provide
private gmem for TD private memory, which can be found at [2].
And it can work corresponding KVM [3] to boot TDX guest. 

[1] https://lore.kernel.org/all/20230718234512.1690985-1-seanjc@google.com/
[2] https://github.com/intel/qemu-tdx/tree/tdx-upstream-wip
[3] https://github.com/intel/tdx/tree/kvm-upstream-2023.07.27-v6.5-rc2-workaround

Chao Peng (4):
  RAMBlock: Support KVM gmemory
  kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
  physmem: Add ram_block_convert_range
  kvm: handle KVM_EXIT_MEMORY_FAULT

Isaku Yamahata (4):
  HostMem: Add private property to indicate to use kvm gmem
  trace/kvm: Add trace for page convertion between shared and private
  pci-host/q35: Move PAM initialization above SMRAM initialization
  q35: Introduce smm_ranges property for q35-pci-host

Xiaoyao Li (11):
  trace/kvm: Split address space and slot id in
    trace_kvm_set_user_memory()
  *** HACK *** linux-headers: Update headers to pull in gmem APIs
  memory: Introduce memory_region_can_be_private()
  i386/pc: Drop pc_machine_kvm_type()
  target/i386: Implement mc->kvm_type() to get VM type
  i386/kvm: Create gmem fd for KVM_X86_SW_PROTECTED_VM
  kvm: Introduce support for memory_attributes
  kvm/memory: Introduce the infrastructure to set the default
    shared/private value
  i386/kvm: Set memory to default private for KVM_X86_SW_PROTECTED_VM
  physmem: replace function name with __func__ in
    ram_block_discard_range()
  i386: Disable SMM mode for X86_SW_PROTECTED_VM

 accel/kvm/kvm-all.c         | 166 +++++++++++++++++++++++++++++++++---
 accel/kvm/trace-events      |   4 +-
 backends/hostmem.c          |  18 ++++
 hw/i386/pc.c                |   5 --
 hw/i386/pc_q35.c            |   3 +-
 hw/i386/x86.c               |  27 ++++++
 hw/pci-host/q35.c           |  61 ++++++++-----
 include/exec/cpu-common.h   |   2 +
 include/exec/memory.h       |  24 ++++++
 include/exec/ramblock.h     |   1 +
 include/hw/i386/pc.h        |   4 +-
 include/hw/i386/x86.h       |   4 +
 include/hw/pci-host/q35.h   |   1 +
 include/sysemu/hostmem.h    |   2 +-
 include/sysemu/kvm.h        |   3 +
 include/sysemu/kvm_int.h    |   2 +
 linux-headers/asm-x86/kvm.h |   3 +
 linux-headers/linux/kvm.h   |  50 +++++++++++
 qapi/qom.json               |   4 +
 softmmu/memory.c            |  27 ++++++
 softmmu/physmem.c           |  97 ++++++++++++++-------
 target/i386/kvm/kvm.c       |  84 ++++++++++++++++++
 target/i386/kvm/kvm_i386.h  |   1 +
 23 files changed, 517 insertions(+), 76 deletions(-)

-- 
2.34.1

