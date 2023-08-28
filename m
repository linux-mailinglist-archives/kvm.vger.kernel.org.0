Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADDE78A4E1
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 06:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjH1EGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 00:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjH1EG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 00:06:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396CA107;
        Sun, 27 Aug 2023 21:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693195585; x=1724731585;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OULJKEe473kdhF1m2dfcAYsUMb0z7uoejfE3vAVjmts=;
  b=m7/vnLumHbtcJjgWMXzLBmHCTyE7RytBiQAP/Lo5UFgaWk0yEPeUtIhu
   m1GChwtPWS93BTDS1l0CM4vPKxM5b6/R6IBwrMFgXk3Xkw7iaujCymzPq
   0P7m5sWvMPoATNXQP60wReWv6gN0yCeRE6vq3dvfobN0gFogJiFyPm/b0
   WxhnjFLAhDb9QLoGaEiUbwOQsHCuG/9ho97/HbBsfKpYEMZbWsfh0SiDi
   BZdOETqMCpuavlk4lOcoWy1WvdJX5+e4cX5PQqGAqTaXbTgXF4+e3E1lH
   IYutbZbvtY9cLj2NDh518yw+j9NIYBR2FsdqQfFvuaHNbNPPvLSG6xnCC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10815"; a="405996981"
X-IronPort-AV: E=Sophos;i="6.02,206,1688454000"; 
   d="scan'208";a="405996981"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2023 21:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10815"; a="803554538"
X-IronPort-AV: E=Sophos;i="6.02,206,1688454000"; 
   d="scan'208";a="803554538"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2023 21:06:22 -0700
Message-ID: <7463d8dd-5290-59c0-73bc-68053d6a320a@linux.intel.com>
Date:   Mon, 28 Aug 2023 12:06:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 1/9] KVM: x86/mmu: Use GENMASK_ULL() to define
 __PT_BASE_ADDR_MASK
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-2-binbin.wu@linux.intel.com>
 <ZN0454peMb3z/0Bg@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZN0454peMb3z/0Bg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 5:00 AM, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Binbin Wu wrote:
>> Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.
> Using GENMASK_ULL() is an opportunistic cleanup, it is not the main purpose for
> this patch.  The main purpose is to extract the maximum theoretical mask for guest
> MAXPHYADDR so that it can be used to strip bits from CR3.
>
> And rather than bury the actual use in "KVM: x86: Virtualize CR3.LAM_{U48,U57}",
> I think it makes sense to do the masking in this patch.  That change only becomes
> _necessary_ when LAM comes along, but it's completely valid without LAM.
>
> That will also provide a place to explain why we decided to unconditionally mask
> the pgd (it's harmless for 32-bit guests, querying 64-bit mode would be more
> expensive, and for EPT the mask isn't tied to guest mode).
OK.

> And it should also
> explain that using PT_BASE_ADDR_MASK would actually be wrong (PAE has 64-bit
> elements _except_ for CR3).
Hi Sean, I am not sure if I understand it correctly.
Do you mean when KVM shadows the page table of guest using 32-bit paging 
or PAE paging,
guest CR3 is or can be 32 bits for 32-bit paging or PAE paging, so that 
apply the mask to a 32-bit
value CR3 "would actually be wrong" ?


>
> E.g. end up with a shortlog for this patch along the lines of:
>
>    KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>
> and write the changelog accordingly.
>
>> No functional change intended.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   arch/x86/kvm/mmu/mmu_internal.h | 1 +
>>   arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index d39af5639ce9..7d2105432d66 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -21,6 +21,7 @@ extern bool dbg;
>>   #endif
>>   
>>   /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>> +#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
>>   #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>>   	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>>   #define __PT_INDEX(address, level, bits_per_level) \
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 0662e0278e70..00c8193f5991 100644
>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>> @@ -62,7 +62,7 @@
>>   #endif
>>   
>>   /* Common logic, but per-type values.  These also need to be undefined. */
>> -#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
>> +#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
>>   #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>>   #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>>   #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
>> -- 
>> 2.25.1
>>

