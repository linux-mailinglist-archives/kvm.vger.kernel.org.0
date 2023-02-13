Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2F69404F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjBMJDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 04:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjBMJDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 04:03:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58E9A5C5
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676278995; x=1707814995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QVE8zxe84HNAEzVKI67rQATE0ACd5a3oK5FW2+l1uSY=;
  b=ndYh4MKC75bHW61BFQETNeb8giSwYPIGH7TbnxVH/xdoU0Zb48GXSlJE
   ol1a4wLQj8kL8Kth5Gs+wC10Mi0LXx3Mpv4F/BObyMydi9XDNBx/ZHygg
   /SGyxTOi/MoESiykkPTfz4EY4OsT9v202ZeDwaFszlDj0WF7mUDg2kkno
   TTbe/vnDgtpj8UG1a/HllbnEcyauw5R4TqfUBVpzt3LQn5A+BcNGUQ1G+
   5bO8VmS/kptxaAMMkYuhR66nOKGvpQgMhHTxJW0J91LihXI+uMUQDz2p7
   ZdyRzMj9oFLPjxvofI8pJntumwSjc6kIFid4cVTKz0bxf/lStQ0TGuKS2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="310478450"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="310478450"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 01:02:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="662106941"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="662106941"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.196]) ([10.255.30.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 01:02:23 -0800
Message-ID: <f6db6ca0-8ed8-857d-5115-e22bf7d596fc@linux.intel.com>
Date:   Mon, 13 Feb 2023 17:02:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2023 10:40 AM, Robert Hoo wrote:
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
>    CR3.LAM_U57 = 1, LAM57 is applied; if CR3.LAM_U48 = 1 and CR3.LAM_U57 = 0,
>    LAM48 is applied.
> * LAM_SUP bit, combined with paging mode (4-level or 5-level), determines
>    LAM status for supervisor mode address. I.e. when CR4.LAM_SUP =1, 4-level
>    paging mode will have LAM48 for supervisor mode address while 5-level paging
>    will have LAM57.
>
> Note:
> 1. LAM applies to only data address, not to instructions.
> 2. LAM identification of an address as user or supervisor is based solely on the
>     value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
> 3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
>     set, in this case, the effective usable linear address width is 48, i.e. bit
>     56:47 is reserved by LAM. [2]

How to understand "reserved by LAM"?

According to the spec, bits 56:48 of the pointer contained metadata.


> 4. When VM exit, the problematic address saved in VMCS field is clean, i.e.
>     metadata cleared with canonical form.
>
>
> ===LAM KVM Design===
>
> Intercept CR4.LAM_SUP by KVM, to avoid read VMCS field every time, with
> expectation that guest won't toggle this bit frequently.
>
> Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
> KVM. Nothing more need to do.
>
> For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
> toggles.
>
> [1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
> [2] Thus currently, Kernel enabling patch only enables LAM_U57. https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/
>
> ---
> Changelog
> v3 --> v4:
> Drop unrelated Patch 1 in v3 (Binbin, Sean, Xiaoyao)
> Intercept CR4.LAM_SUP instead of pass through to guest (Sean)
> Just filter out CR3.LAM_{U48, U57}, instead of all reserved high bits
> (Sean, Yuan)
> Use existing __canonical_address() helper instead write a new one (Weijiang)
> Add LAM handling in KVM emulation (Yu, Yuan)
> Add Jingqi's reviwed-by on Patch 7
> Rebased to Kirill's latest code, which is 6.2-rc1 base.
>
> v2 --> v3:
> As LAM Kernel patches are in tip tree now, rebase to it.
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/
>
> v1 --> v2:
> 1. Fixes i386-allyesconfig build error on get_pgd(), where
>     CR3_HIGH_RSVD_MASK isn't applicable.
>     (Reported-by: kernel test robot <lkp@intel.com>)
> 2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
>     toggles. (Kirill)
>
>
> Robert Hoo (9):
>    KVM: x86: Intercept CR4.LAM_SUP when LAM feature is enabled in guest
>    KVM: x86: MMU: Clear CR3 LAM bits when allocate shadow root
>    [Trivial] KVM: x86: MMU: Commets update
>    KVM: x86: MMU: Integrate LAM bits when build guest CR3
>    KVM: x86: Untag LAM bits when applicable
>    KVM: x86: When judging setting CR3 valid or not, consider LAM bits
>    KVM: x86: When guest set CR3, handle LAM bits semantics
>    KVM: x86: LAM: Expose LAM CPUID to user space VMM
>    KVM: x86: emulation: Apply LAM when emulating data access
>
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/cpuid.c            |  2 +-
>   arch/x86/kvm/emulate.c          |  6 +++++
>   arch/x86/kvm/mmu.h              |  5 ++++
>   arch/x86/kvm/mmu/mmu.c          | 11 ++++++--
>   arch/x86/kvm/vmx/vmx.c          |  6 ++++-
>   arch/x86/kvm/x86.c              | 38 ++++++++++++++++++++++----
>   arch/x86/kvm/x86.h              | 47 +++++++++++++++++++++++++++++++++
>   8 files changed, 108 insertions(+), 10 deletions(-)
>
> base-commit: 03334443640f226f56f71b5dfa3b1be6d4a1a1bc
> (https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git lam)
