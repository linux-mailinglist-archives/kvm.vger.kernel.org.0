Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4B65086C
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiLSIKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSIKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:10:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003E5637F
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671437413; x=1702973413;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5odpid/0oc3uLwhuScs/T51K/cILT9cgLNu3VtasXpM=;
  b=QbN3cJKKe6jeT9/kVbaNhHEEC8qxpB1E5U9I+1u2P+0RzGM5Fofiyui4
   Bb3HgymPdzGihN2AIT6vjsLdmPpKRnpfUClJ9GJA7W9GddwmBSe43uMde
   a+GmZ7Qf0zeySTbJdnwJ79HvmECRUbRJSu2ZAvmD0I5Qn7ziCuOsuL3NZ
   ++hj8ZFPrmHwI6x2OWmQbqrbuALxxpvKCx//jNW6yWVxMIdWjbgRzZxTh
   8IwBZANbpj3cChV1y3XUo/WmINuCUVlsT4Seo095K4M6Cms1LuPs49T9/
   EvjdSTP04MHiet6WlSBVys8ZnxHGFMrYEXt2UJ+nXbmYrC3STu3mWEmiw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="383640205"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="383640205"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:10:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="713931021"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="713931021"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 19 Dec 2022 00:09:59 -0800
Date:   Mon, 19 Dec 2022 16:09:59 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/9] Linear Address Masking (LAM) KVM Enabling
Message-ID: <20221219080959.y2auxxtba3fw6zrq@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:45:48PM +0800, Robert Hoo wrote:
> ===Feature Introduction===
>
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated
> address (upper) bits for metadata.
> As for which upper bits of linear address can be borrowed, LAM has 2 modes:
> LAM_48 (bits 62:48, i.e. LAM width of 15) and LAM_57 (bits 62:57, i.e. LAM
> width of 6), controlled by these new bits: CR3[62] (LAM_U48), CR3[61]
> (LAM_U57), and CR4[28] (LAM_SUP).
>
> * LAM_U48 and LAM_U57 bits controls LAM for user mode address. I.e. if
>   CR3.LAM_U57 = 1, LAM57 is applied; if CR3.LAM_U48 = 1 and CR3.LAM_U57 = 0,
>   LAM48 is applied.
> * LAM_SUP bit, combined with paging mode (4-level or 5-level), determines
>   LAM status for supervisor mode address. I.e. when CR4.LAM_SUP =1, 4-level
>   paging mode will have LAM48 for supervisor mode address while 5-level paging
>   will have LAM57.
>
> Note:
> 1. LAM applies to only data address, not to instructions.
> 2. LAM identification of an address as user or supervisor is based solely on the
>    value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
> 3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
>    set, in this case, the effective usable linear address width is 48, i.e. bit
>    56:47 is reserved by LAM. [2]

It's worth to higlight that vmx exit Guest Linear Address field is always filled
without the LAM metadata part, it can be used as linear address directly. I think
this explains reason of no modification on paging_tmpl.h for shadow paging.

>
>
> ===LAM KVM Design===
>
> Pass CR4.LAM_SUP under guest control.
>
> Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
> KVM. Nothing more need to do.
>
> For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
> toggles.
>
> Patch 1 -- This patch can be mostly independent from LAM enabling. It just renames
>            CR4 reserved bits for better understanding, esp. for beginners.
>
> Patch 2, 9 -- Common part for both EPT and Shadow Paging modes enabling.
>
> Patch 3 ~ 8 -- For Shadow Paging mode LAM enabling.
>
> [1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
> [2] Thus currently, Kernel enabling patch only enables LAM57 mode. https://lore.kernel.org/lkml/20220815041803.17954-1-kirill.shutemov@linux.intel.com/
>
> ---
> Changelog
> v2 --> v3:
> As LAM Kernel patches are in tip tree now, rebase to it.
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/
>
> v1 --> v2:
> 1. Fixes i386-allyesconfig build error on get_pgd(), where
>    CR3_HIGH_RSVD_MASK isn't applicable.
>    (Reported-by: kernel test robot <lkp@intel.com>)
> 2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
>    toggles. (Kirill)
>
> Robert Hoo (9):
>   KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
>   KVM: x86: Add CR4.LAM_SUP in guest owned bits
>   KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for
>     pgd
>   KVM: x86: MMU: Commets update
>   KVM: x86: MMU: Integrate LAM bits when build guest CR3
>   KVM: x86: Untag LAM bits when applicable
>   KVM: x86: When judging setting CR3 valid or not, consider LAM bits
>   KVM: x86: When guest set CR3, handle LAM bits semantics
>   KVM: x86: LAM: Expose LAM CPUID to user space VMM
>
>  arch/x86/include/asm/kvm_host.h        |  7 ++--
>  arch/x86/include/asm/processor-flags.h |  1 +
>  arch/x86/kvm/cpuid.c                   |  6 +--
>  arch/x86/kvm/kvm_cache_regs.h          |  3 +-
>  arch/x86/kvm/mmu.h                     |  5 +++
>  arch/x86/kvm/mmu/mmu.c                 | 18 ++++++---
>  arch/x86/kvm/vmx/vmx.c                 |  8 +++-
>  arch/x86/kvm/x86.c                     | 51 ++++++++++++++++++++------
>  arch/x86/kvm/x86.h                     | 43 +++++++++++++++++++++-
>  9 files changed, 115 insertions(+), 27 deletions(-)
>
>
> base-commit: a5dadcb601b4954c60494d797b4dd1e03a4b1ebe
> --
> 2.31.1
>
