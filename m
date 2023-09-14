Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B205F79F909
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjINDv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjINDv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:51:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362DB99
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663484; x=1726199484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EJdytUvFegtFO4ub2tojVZa0daaV9vRq2OIwl9Ilnlg=;
  b=IcqoctVIDFQwn1605mLypSwYlo+K6aFhrDgliJJLKd1SifCUKC34hb2x
   +OxrrI9ae/DSh1AZ49uWPnzTr8aIYpplnGQrbArZWmBJH8ShjOUo8Pex8
   ZZsPH8kn3xtEbWCswKTPLo1/4AxhygAjoEOUo8SCelnQcgYv+sovsvaeN
   ls9J6eaZk020cjkk4OWgpWdTi0nATPCnDf+PGW65jwxQOy4RuT898Et4p
   Kd7UWUkRw9Y5jUFyIMZXixM5++s2QEIvFUVJjKKJ/J50qBGGQXbyyVSf0
   PqwFgnZJQKiO6XeWkJnEB7N7qt9YQjt399L25Us1eBQBjVvYQFmvdAABA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528266"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528266"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:51:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500525"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500525"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:51:19 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 00/21] QEMU gmem implemention
Date:   Wed, 13 Sep 2023 23:50:56 -0400
Message-Id: <20230914035117.3285885-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's the v2 RFC of enabling KVM gmem[1] as the backend for private
memory.

For confidential-computing, KVM provides gmem/guest_mem interfaces for
userspace, like QEMU, to allocate user-unaccesible private memory. This
series aims to add gmem support in QEMU's RAMBlock so that each RAM can
have both hva-based shared memory and gmem_fd based private memory. QEMU
does the shared-private conversion on KVM_MEMORY_EXIT and discards the
memory.

It chooses the design that adds "private" property to hostmeory backend.
If "private" property is set, QEMU will allocate/create KVM gmem when
initialize the RAMbloch of the memory backend. 

This sereis also introduces the first user of kvm gmem,
KVM_X86_SW_PROTECTED_VM. A KVM_X86_SW_PROTECTED_VM with private KVM gmem
can be created with 

  $qemu -object sw-protected-vm,id=sp-vm0 \
	-object memory-backend-ram,id=mem0,size=1G,private=on \
	-machine q35,kernel_irqchip=split,confidential-guest-support=sp-vm0,memory-backend=mem0 \
	...

Unfortunately this patch series fails the boot of OVMF at very early
stage due to triple fault, because KVM doesn't support emulating string IO
to private memory.

This version still leave some opens to be discussed:
1. whether we need "private" propery to be user-settable?

   It seems unnecessary because vm-type is determined. If the VM is
   confidential-guest, then the RAM of the guest must be able to be
   mapped as private, i.e., have kvm gmem backend. So QEMU can
   determine the value of "private" property automatiacally based on vm
   type.

   This also aligns with the board internal MemoryRegion that needs to
   have kvm gmem backend, e.g., TDX requires OVMF to act as private
   memory so bios memory region needs to have kvm gmem fd associated.
   QEMU no doubt will do it internally automatically.

2. hugepage support.

   KVM gmem can be allocated from hugetlbfs. How does QEMU determine
   when to allocate KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE. The
   easiest solution is create KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
   only when memory backend is HostMemoryBackendFile of hugetlbfs.

3. What is KVM_X86_SW_PROTECTED_VM going to look like? and do we need it?

   This series implements KVM_X86_SW_PROTECTED_VM because it's introduced
   with gmem together on KVM side and it's supposed to be the first user
   who requires KVM gmem. However the implementation is incomplete and
   there lacks the definition of how KVM_X86_SW_PROTECTED_VM works.

Any other idea/open/question is welcomed.

Beside, TDX QEMU implemetation is based on this series to provide
private gmem for TD private memory, which can be found at [2].
And it can work corresponding KVM [3] to boot TDX guest. 

[1] https://lore.kernel.org/all/20230718234512.1690985-1-seanjc@google.com/
[2] https://github.com/intel/qemu-tdx/tree/tdx-qemu-upstream
[3] https://github.com/intel/tdx/tree/kvm-upstream-2023.07.27-v6.5-rc2-workaround

===
Changes since rfc v1:
- Implement KVM_X86_SW_PROTECTED_VM with confidential-guest-support
interface;
- rename memory_region_can_be_private() to memory_region_has_gmem_fd();
- allocate kvm gmem fd when creating/initializing the memory backend by
introducing the RAM_KVM_GMEM flag;


Chao Peng (3):
  RAMBlock: Add support of KVM private gmem
  kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
  kvm: handle KVM_EXIT_MEMORY_FAULT

Isaku Yamahata (4):
  HostMem: Add private property and associate it with RAM_KVM_GMEM
  trace/kvm: Add trace for page convertion between shared and private
  pci-host/q35: Move PAM initialization above SMRAM initialization
  q35: Introduce smm_ranges property for q35-pci-host

Xiaoyao Li (14):
  *** HACK *** linux-headers: Update headers to pull in gmem APIs
  memory: Introduce memory_region_has_gmem_fd()
  i386: Add support for sw-protected-vm object
  i386/pc: Drop pc_machine_kvm_type()
  target/i386: Implement mc->kvm_type() to get VM type
  target/i386: Introduce kvm_confidential_guest_init()
  i386/kvm: Implement kvm_sw_protected_vm_init() for sw-protcted-vm
    specific functions
  kvm: Introduce support for memory_attributes
  kvm/memory: Introduce the infrastructure to set the default
    shared/private value
  i386/kvm: Set memory to default private for KVM_X86_SW_PROTECTED_VM
  physmem: replace function name with __func__ in
    ram_block_discard_range()
  physmem: extract ram_block_discard_range_fd() from
    ram_block_discard_range()
  physmem: Introduce ram_block_convert_range()
  i386: Disable SMM mode for X86_SW_PROTECTED_VM

 accel/kvm/kvm-all.c               | 180 ++++++++++++++++++++-
 accel/kvm/trace-events            |   4 +-
 backends/hostmem-file.c           |   1 +
 backends/hostmem-memfd.c          |   1 +
 backends/hostmem-ram.c            |   1 +
 backends/hostmem.c                |  18 +++
 hw/i386/pc.c                      |   5 -
 hw/i386/pc_q35.c                  |   3 +-
 hw/i386/x86.c                     |  12 ++
 hw/pci-host/q35.c                 |  61 ++++---
 include/exec/cpu-common.h         |   2 +
 include/exec/memory.h             |  20 +++
 include/exec/ramblock.h           |   1 +
 include/hw/i386/pc.h              |   4 +-
 include/hw/i386/x86.h             |   1 +
 include/hw/pci-host/q35.h         |   1 +
 include/sysemu/hostmem.h          |   2 +-
 include/sysemu/kvm.h              |   5 +
 include/sysemu/kvm_int.h          |   2 +
 linux-headers/asm-x86/kvm.h       |   3 +
 linux-headers/linux/kvm.h         |  50 ++++++
 qapi/qom.json                     |   5 +
 softmmu/memory.c                  |  18 +++
 softmmu/physmem.c                 | 256 ++++++++++++++++++------------
 target/i386/kvm/kvm.c             |  43 ++++-
 target/i386/kvm/kvm_i386.h        |   1 +
 target/i386/kvm/meson.build       |   1 +
 target/i386/kvm/sw-protected-vm.c |  71 +++++++++
 target/i386/kvm/sw-protected-vm.h |  19 +++
 target/i386/sev.c                 |   1 -
 target/i386/sev.h                 |   2 +
 31 files changed, 648 insertions(+), 146 deletions(-)
 create mode 100644 target/i386/kvm/sw-protected-vm.c
 create mode 100644 target/i386/kvm/sw-protected-vm.h

-- 
2.34.1

