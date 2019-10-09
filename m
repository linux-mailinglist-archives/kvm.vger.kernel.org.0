Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A71ED056D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 04:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfJICPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 22:15:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:37987 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfJICPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 22:15:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 19:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="192744373"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 08 Oct 2019 19:15:37 -0700
Date:   Wed, 9 Oct 2019 10:17:35 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Zhang, Yu C" <yu.c.zhang@intel.com>,
        "alazar@bitdefender.com" <alazar@bitdefender.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
Message-ID: <20191009021735.GA27250@local-michael-cet-test>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 04:52:55PM +0800, Yang, Weijiang wrote:
Hi, Paolo,
Could you review this v5 patch at your convenience?
Thanks a lot!

> EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> Virtual Machine Monitor(VMM) to specify write-permission for guest
> physical memory at a sub-page(128 byte) granularity. When this
> capability is enabled, the CPU enforces write-access check for sub-pages
> within a 4KB page.
> 
> The feature is targeted to provide fine-grained memory protection for
> usages such as device virtualization, memory check-point and VM
> introspection etc.
> 
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> called Sub-Page Permission Table Pointer (SPPTP) which contains a
> 4K-aligned physical address.
> 
> To enable SPP for certain physical page, the gfn should be first mapped
> to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry. 
> While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> physical address to find out the sub-page permissions at the leaf entry.
> If the corresponding bit is set, write to sub-page is permitted,
> otherwise, SPP induced EPT violation is generated.
> 
> This patch serial passed SPP function test and selftest on Ice-Lake platform.
> 
> Please refer to the SPP introduction document in this patch set and
> Intel SDM for details:
> 
> Intel SDM:
> https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> SPP selftest patch:
> https://lkml.org/lkml/2019/6/18/1197
> 
> Previous patch:
> https://lkml.org/lkml/2019/8/14/97
> 
> Patch 1: Introduction to SPP.
> Patch 2: Add SPP related flags and control bits.
> Patch 3: Functions for SPPT setup.
> Patch 4: Add SPP access bitmaps for memslots.
> Patch 5: Introduce SPP {init,set,get} functions
> Patch 6: Implement User space access IOCTLs.
> Patch 7: Set up SPP paging table at vm-entry/exit.
> Patch 8: Enable lazy mode SPPT setup.
> Patch 9: Handle SPP protected pages when VM memory changes
> 
> 
> Change logs:
> 
> V5 -> V4:
>   1. Enable SPP support for Hugepage(1GB/2MB) to extend application.
>   2. Make SPP miss vm-exit handler as the unified place to set up SPPT.
>   3. If SPP protected pages are access-tracked or dirty-page-tracked,
>      store SPP flag in reserved address bit, restore it in
>      fast_page_fault() handler.
>   4. Move SPP specific functions to vmx/spp.c and vmx/spp.h
>   5. Rebased code to kernel v5.3
>   6. Other change suggested by KVM community.
>   
> V3 -> V4:
>   1. Modified documentation to make it consistent with patches.
>   2. Allocated SPPT root page in init_spp() instead of vmx_set_cr3() to
>      avoid SPPT miss error.
>   3. Added back co-developers and sign-offs.
> 
> V2 -> V3:                                                                
>   1. Rebased patches to kernel 5.1 release                                
>   2. Deferred SPPT setup to EPT fault handler if the page is not
>      available while set_subpage() is being called.
>   3. Added init IOCTL to reduce extra cost if SPP is not used.
>   4. Refactored patch structure, cleaned up cross referenced functions.
>   5. Added code to deal with memory swapping/migration/shrinker cases.
> 
> V2 -> V1:
>   1. Rebased to 4.20-rc1
>   2. Move VMCS change to a separated patch.
>   3. Code refine and Bug fix 
> 
> 
> Yang Weijiang (9):
>   Documentation: Introduce EPT based Subpage Protection
>   vmx: spp: Add control flags for Sub-Page Protection(SPP)
>   mmu: spp: Add SPP Table setup functions
>   mmu: spp: Add functions to create/destroy SPP bitmap block
>   mmu: spp: Introduce SPP {init,set,get} functions
>   x86: spp: Introduce user-space SPP IOCTLs
>   vmx: spp: Set up SPP paging table at vm-entry/exit
>   mmu: spp: Enable Lazy mode SPP protection
>   mmu: spp: Handle SPP protected pages when VM memory changes
> 
>  Documentation/virtual/kvm/spp_kvm.txt | 178 +++++++
>  arch/x86/include/asm/cpufeatures.h    |   1 +
>  arch/x86/include/asm/kvm_host.h       |  10 +-
>  arch/x86/include/asm/vmx.h            |  10 +
>  arch/x86/include/uapi/asm/vmx.h       |   2 +
>  arch/x86/kernel/cpu/intel.c           |   4 +
>  arch/x86/kvm/mmu.c                    |  78 ++-
>  arch/x86/kvm/mmu.h                    |   2 +
>  arch/x86/kvm/vmx/capabilities.h       |   5 +
>  arch/x86/kvm/vmx/spp.c                | 651 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/spp.h                |  27 ++
>  arch/x86/kvm/vmx/vmx.c                |  99 ++++
>  arch/x86/kvm/x86.c                    |  51 ++
>  include/uapi/linux/kvm.h              |  17 +
>  14 files changed, 1133 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
>  create mode 100644 arch/x86/kvm/vmx/spp.c
>  create mode 100644 arch/x86/kvm/vmx/spp.h
> 
> -- 
> 2.17.2
