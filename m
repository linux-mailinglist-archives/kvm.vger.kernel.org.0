Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6AE535D66
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbiE0J2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 05:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350555AbiE0J2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 05:28:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028FDDFE9;
        Fri, 27 May 2022 02:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653643696; x=1685179696;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=efyypdxFtKwj98j5J7dnwyYqKUsUcxzC2VXnwZlhrMk=;
  b=YQa4NODRyXIeoG2SUk7VC9fA+F5Kyo0XaVoL0yj+0pVqJOjUvS1RSMdc
   qzvkvJMdPWhGI4Z6FAe6NMkBXq3N6NWbrsF8UQY5xIOdNvoCGfoTLXHON
   roJk7BeGPt1RZpm6+z5UnoNrzhJdJkJ8knarrhbd44bYPY4Ftoz3KfEK1
   EyCliRg+SWTlqpJ45S5OMfW+0hOtkSwwTMMwGO6jxHI81YJSNL3o/7kxq
   o5SfvTC0lNsJ5i/rYc7rXE7ITpFvku3q2QErQx2JaPKGpu4+HOEszxyd/
   DAli142EQEDXXUs6Xl4xIHYBT9zkeiJ3+9nEPWEpIagSelxkUelrJ5eaR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="360819280"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="360819280"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:28:15 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705040963"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:28:13 -0700
Message-ID: <1bab5e74-70b9-64b0-b4e0-645ba832c3a9@intel.com>
Date:   Fri, 27 May 2022 17:28:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 5/8] KVM: MMU: Add helper function to get pkr bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-6-lei4.wang@intel.com> <Yo1okaacf2kbvrxh@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yo1okaacf2kbvrxh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2022 7:21 AM, Sean Christopherson wrote:
> On Sun, Apr 24, 2022, Lei Wang wrote:
>> Extra the PKR stuff to a separate, non-inline helper, which is a
> s/Extra/Extract

My mistake, will fix it.

>> preparation to introduce pks support.
> Please provide more justification.  The change is justified, by random readers of
> this patch/commit will be clueless.
>
>    Extract getting the effective PKR bits to a helper that lives in mmu.c
>    in order to keep the is_cr4_*() helpers contained to mmu.c.  Support for
>    PKRS (versus just PKRU) will require querying MMU state to see if the
>    relevant CR4 bit is enabled because pkr_mask will be non-zero if _either_
>    bit is enabled).
>
>    PKR{U,S} are exposed to the guest if and only if TDP is enabled, and
>    while permission_fault() is performance critical for ia32 shadow paging,
>    it's a rarely used path with TDP is enabled.  I.e. moving the PKR code
>    out-of-line is not a performance concern.

Will add more justification to make it clearer to random readers.

>> Signed-off-by: Lei Wang <lei4.wang@intel.com>
>> ---
>>   arch/x86/kvm/mmu.h     | 20 +++++---------------
>>   arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++++++++
>>   2 files changed, 26 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index cb3f07e63778..cea03053a153 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -204,6 +204,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   	return vcpu->arch.mmu->page_fault(vcpu, &fault);
>>   }
>>   
>> +u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> kvm_mmu_get_pkr_bits() so that there's a verb in there.

Will fix it.

>> +		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec);
>> +
>>   /*
>>    * Check if a given access (described through the I/D, W/R and U/S bits of a
>>    * page fault error code pfec) causes a permission fault with the given PTE
>> @@ -240,21 +243,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>   
>>   	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>>   	if (unlikely(mmu->pkr_mask)) {
>> -		u32 pkr_bits, offset;
>> -
>> -		/*
>> -		* PKRU defines 32 bits, there are 16 domains and 2
>> -		* attribute bits per domain in pkru.  pte_pkey is the
>> -		* index of the protection domain, so pte_pkey * 2 is
>> -		* is the index of the first bit for the domain.
>> -		*/
>> -		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>> -
>> -		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
>> -		offset = (pfec & ~1) +
>> -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
>> -
>> -		pkr_bits &= mmu->pkr_mask >> offset;
>> +		u32 pkr_bits =
>> +			kvm_mmu_pkr_bits(vcpu, mmu, pte_access, pte_pkey, pfec);
> Nit, I prefer wrapping in the params, that way the first line shows the most
> important information, e.g. what variable is being set and how (by a function call).
> And then there won't be overflow with the longer helper name:
>
> 		u32 pkr_bits = kvm_mmu_get_pkr_bits(vcpu, mmu, pte_access,
> 						    pte_pkey, pfec);

Make sense, will make the wrapping more reasonable.

> Comment needs to be aligned, and it can be adjust to wrap at 80 chars (its
> indentation has changed).
>
> 	/*
> 	 * PKRU and PKRS both define 32 bits. There are 16 domains and 2
> 	 * attribute bits per domain in them. pte_key is the index of the
> 	 * protection domain, so pte_pkey * 2 is the index of the first bit for
> 	 * the domain. The use of PKRU versus PKRS is selected by the address
> 	 * type, as determined by the U/S bit in the paging-structure entries.
> 	 */
Will align and adjust it.
