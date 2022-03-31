Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2924ED35E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 07:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiCaFpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 01:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiCaFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 01:45:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3408FD2;
        Wed, 30 Mar 2022 22:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648705436; x=1680241436;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=32l1uw52vjX3hXWFSGOXFGPoiNZh7RQ9ud/xkeBw28U=;
  b=NN8HjWL4n5rOe6BIol17kSXbSZOl4r77RyoYWrk3t6BCmYTC3m6dUcQL
   SvXU3DH1xxNtTZol8L0FNcBDmX+GisOb9fxUAisamakkzvJEPOZ7OajMw
   rYgwuhQjvtbdjoNMh3K0r2aly3Qi9au5IjSjt0OUrsCu3ix047/wp3y7L
   ljNfDbeRkRr0yPNNjEswHFcQvd1EdtPA3mw8lC9ffOyACXvgIldz1AUk9
   T66UP8VRpkM5t8qmKU+3K33WnhVcGO4kMa5Ei7hEr+ruHwJ5T8+k+LR5o
   7nzyc6sRFFHrEao5Z72tpCWiG8aTVA7tbi8COqkaR7n45Ji9fPJFgL6vb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="346162846"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="346162846"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 22:43:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="566161887"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.172.223]) ([10.249.172.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 22:43:53 -0700
Message-ID: <873f6789-6ec2-245c-d61d-98a14b546733@intel.com>
Date:   Thu, 31 Mar 2022 13:43:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v6 5/7] KVM: MMU: Add support for PKS emulation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-6-chenyi.qiang@intel.com> <YkTLXGdu2I9i44ti@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YkTLXGdu2I9i44ti@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2022 5:27 AM, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Chenyi Qiang wrote:
>> @@ -277,14 +278,18 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>   	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>>   	if (unlikely(mmu->pkr_mask)) {
>>   		u32 pkr_bits, offset;
>> +		u32 pkr;
>>   
>>   		/*
>> -		* PKRU defines 32 bits, there are 16 domains and 2
>> -		* attribute bits per domain in pkru.  pte_pkey is the
>> -		* index of the protection domain, so pte_pkey * 2 is
>> -		* is the index of the first bit for the domain.
>> +		* PKRU and PKRS both define 32 bits. There are 16 domains
>> +		* and 2 attribute bits per domain in them. pte_key is the
>> +		* index of the protection domain, so pte_pkey * 2 is the
>> +		* index of the first bit for the domain. The use of PKRU
>> +		* versus PKRS is selected by the address type, as determined
>> +		* by the U/S bit in the paging-structure entries.
>>   		*/
>> -		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>> +		pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : kvm_read_pkrs(vcpu);
> 
> Blindly reading PKRU/PKRS is wrong.  I think this magic insanity will be functionally
> correct due to update_pkr_bitmask() clearing the appropriate bits in pkr_mask based
> on CR4.PK*, but the read should never happen.  PKRU is benign, but I believe reading
> PKRS will result in VMREAD to an invalid field if PKRU is supported and enabled, but
> PKRS is not supported.
> 

Nice catch.

> I belive the easiest solution is:
> 
> 		if (pte_access & PT_USER_MASK)
> 			pkr = is_cr4_pke(mmu) ? vcpu->arch.pkru : 0;
> 		else
> 			pkr = is_cr4_pks(mmu) ? kvm_read_pkrs(vcpu) : 0;
> 
> The is_cr4_pk*() helpers are restricted to mmu.c, but this presents a good
> opportunity to extra the PKR stuff to a separate, non-inline helper (as a prep
> patch).  E.g.
> 
> 
> 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
> 	if (unlikely(mmu->pkr_mask))
> 		u32 pkr_bits = kvm_mmu_pkr_bits(vcpu, mmu, pte_access, pte_pkey);
> 
> 		errcode |= -pkr_bits & PFERR_PK_MASK;
> 		fault |= (pkr_bits != 0);
> 	}
> 
> 	return -(u32)fault & errcode;
> 
> permission_fault() is inline because it's heavily used for shadow paging, but
> when using TDP, it's far less performance critical.  PKR is TDP-only, so moving
> it out-of-line should be totally ok (this is also why this patch is "unlikely").

Make sense, will do it.
