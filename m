Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2348F8A85
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 09:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfKLIbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 03:31:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:38908 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfKLIbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 03:31:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 00:31:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="355043467"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 12 Nov 2019 00:31:38 -0800
Date:   Tue, 12 Nov 2019 16:33:52 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v6 0/9] Enable Sub-Page Write Protection Support
Message-ID: <20191112083352.GA1008@local-michael-cet-test>
References: <20191106074504.14858-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106074504.14858-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 03:44:55PM +0800, Yang Weijiang wrote:
Ping...
Hi, Paolo,
Could you add comments on this patch serial? Thanks!

> EPT-Based Sub-Page write Protection(SPP) allows Virtual Machine Monitor(VMM)
> specify write-permission for guest physical memory at a sub-page(128 byte)
> granularity. When SPP works, HW enforces write-access check for sub-pages
> within a protected 4KB page.
> 
> The feature targets to provide fine-grained memory protection for
> usages such as memory guard and VM introspection etc.
> 
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), and subpage permission vector is stored in the
> leaf entry of SPPT. The root page is referenced via a Sub-Page Permission
> Table Pointer (SPPTP) in VMCS.
> 
> To enable SPP for guest memory, the guest page should be first mapped
> to a 4KB EPT entry, then set SPP bit 61 of the corresponding entry. 
> While HW walks EPT, it traverses SPPT with the gpa to look up the sub-page
> permission vector within SPPT leaf entry. If the corresponding bit is set,
> write to sub-page is permitted, otherwise, SPP induced EPT violation is generated.
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
> https://lkml.org/lkml/2019/9/17/180
> 
> Patch 1: Documentation for SPP and related API.
> Patch 2: Add control flags for Sub-Page Protection(SPP).
> Patch 3: Add SPP Table setup functions.
> Patch 4: Add functions to create/destroy SPP bitmap block.
> Patch 5: Introduce user-space SPP IOCTLs.
> Patch 6: Set up SPP paging table at vmentry/vmexit.
> Patch 7: Enable Lazy mode SPP protection.
> Patch 8: Handle SPP protected pages when VM memory changes.
> Patch 9: Add SPP protection check in emulation case.
> 
> 
> Change logs:
> 
> V5 -> V6:
>   1. Added SPP protection patch for emulation cases per Jim's review.
>   2. Modified documentation and added API description per Jim's review.
>   3. Other minior changes suggested by Jim.
> 
> V4 -> V5:
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
>   Documentation: Introduce EPT based Subpage Protection and related
>     ioctls
>   vmx: spp: Add control flags for Sub-Page Protection(SPP)
>   mmu: spp: Add SPP Table setup functions
>   mmu: spp: Add functions to create/destroy SPP bitmap block
>   x86: spp: Introduce user-space SPP IOCTLs
>   vmx: spp: Set up SPP paging table at vmentry/vmexit
>   mmu: spp: Enable Lazy mode SPP protection
>   mmu: spp: Handle SPP protected pages when VM memory changes
>   x86: spp: Add SPP protection check in emulation.
> 
>  Documentation/virt/kvm/api.txt        |  46 ++
>  Documentation/virtual/kvm/spp_kvm.txt | 180 +++++++
>  arch/x86/include/asm/cpufeatures.h    |   1 +
>  arch/x86/include/asm/kvm_host.h       |  10 +-
>  arch/x86/include/asm/vmx.h            |  10 +
>  arch/x86/include/uapi/asm/vmx.h       |   2 +
>  arch/x86/kernel/cpu/intel.c           |   4 +
>  arch/x86/kvm/mmu.c                    |  78 +++-
>  arch/x86/kvm/mmu.h                    |   2 +
>  arch/x86/kvm/vmx/capabilities.h       |   5 +
>  arch/x86/kvm/vmx/spp.c                | 649 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/spp.h                |  28 ++
>  arch/x86/kvm/vmx/vmx.c                |  97 ++++
>  arch/x86/kvm/x86.c                    |  87 ++++
>  include/uapi/linux/kvm.h              |  17 +
>  15 files changed, 1214 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
>  create mode 100644 arch/x86/kvm/vmx/spp.c
>  create mode 100644 arch/x86/kvm/vmx/spp.h
> 
> -- 
> 2.17.2
