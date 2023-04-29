Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905E16F22FD
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 06:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjD2E4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Apr 2023 00:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjD2E4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Apr 2023 00:56:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7FA268A
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 21:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682744202; x=1714280202;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nfFCfg3kPJdoPLIutQ72kVJYEJcJKaGdbgjoK6AaExQ=;
  b=KRV93cJQrBRz/mdxF0h+m25PU+7ErYcDMqaoazy5fJ7Vzx+HEZW6FTve
   ejUBGbIPi7az5SPMpsVJyF5qnuGlbKUu2OwZcGPfgnntPAIBMSOhyUl+a
   pR/ozSAh3XD8aVliYVulqZcQgZvbdmBEoc6aMrHVP8/vodPsErD3iWF2N
   duFEdRroweXpZKLJlieLgNKuX0P7bWrcu59VllrHUAsGsYj56kL1UIsIU
   C4UpxsGkiande7lMGoDeZ6/F5pxFJ8YcOfhTt+s1lvNQFhXUbHllhmj5Y
   B8sDCz37d9/JZ5CAPcI6s68YGnkaYKeAKGnfXPEC2rXCvaRIjcMJA7loj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="434199411"
X-IronPort-AV: E=Sophos;i="5.99,236,1677571200"; 
   d="scan'208";a="434199411"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 21:56:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="697806337"
X-IronPort-AV: E=Sophos;i="5.99,236,1677571200"; 
   d="scan'208";a="697806337"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.239]) ([10.255.28.239])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 21:56:39 -0700
Message-ID: <dc5cdf92-aacc-4e68-2a94-9d1da929ecbd@linux.intel.com>
Date:   Sat, 29 Apr 2023 12:56:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
 <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
 <ZENl3oGrLXvVaI1O@chao-email>
 <262ed94998cf104c5fefcb290a81d60d10342173.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <262ed94998cf104c5fefcb290a81d60d10342173.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/27/2023 9:19 PM, Huang, Kai wrote:
> On Sat, 2023-04-22 at 12:43 +0800, Gao, Chao wrote:
>> On Sat, Apr 22, 2023 at 11:32:26AM +0800, Binbin Wu wrote:
>>> Kai,
>>>
>>> Thanks for your inputs.
>>>
>>> I rephrased the changelog as following:
>>>
>>>
>>> LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
>>> masking for user mode pointers.
>>>
>>> To support LAM in KVM, CR3 validity checks and shadow paging handling need to
>>> be
>>> modified accordingly.
>>>
>>> == CR3 validity Check ==
>>> When LAM is supported, CR3 LAM bits are allowed to be set and the check of
>>> CR3
>>> needs to be modified.
>> it is better to describe the hardware change here:
>>
>> On processors that enumerate support for LAM, CR3 register allows
>> LAM_U48/U57 to be set and VM entry allows LAM_U48/U57 to be set in both
>> GUEST_CR3 and HOST_CR3 fields.
>>
>> To emulate LAM hardware behavior, KVM needs to
>> 1. allow LAM_U48/U57 to be set to the CR3 register by guest or userspace
>> 2. allow LAM_U48/U57 to be set to the GUES_CR3/HOST_CR3 fields in vmcs12
> Agreed.  This is more clearer.
>
>>> Add a helper kvm_vcpu_is_legal_cr3() and use it instead of
>>> kvm_vcpu_is_legal_gpa()
>>> to do the new CR3 checks in all existing CR3 checks as following:
>>> When userspace sets sregs, CR3 is checked in kvm_is_valid_sregs().
>>> Non-nested case
>>> - When EPT on, CR3 is fully under control of guest.
>>> - When EPT off, CR3 is intercepted and CR3 is checked in kvm_set_cr3() during
>>>    CR3 VMExit handling.
>>> Nested case, from L0's perspective, we care about:
>>> - L1's CR3 register (VMCS01's GUEST_CR3), it's the same as non-nested case.
>>> - L1's VMCS to run L2 guest (i.e. VMCS12's HOST_CR3 and VMCS12's GUEST_CR3)
>>>    Two paths related:
>>>    1. L0 emulates a VMExit from L2 to L1 using VMCS01 to reflect VMCS12
>>>           nested_vm_exit()
>>>           -> load_vmcs12_host_state()
>>>                 -> nested_vmx_load_cr3()     //check VMCS12's HOST_CR3
>> This is just a byproduct of using a unified function, i.e.,
>> nested_vmx_load_cr3() to load CR3 for both nested VM entry and VM exit.
>>
>> LAM spec says:
>>
>> VM entry checks the values of the CR3 and CR4 fields in the guest-area
>> and host-state area of the VMCS. In particular, the bits in these fields
>> that correspond to bits reserved in the corresponding register are
>> checked and must be 0.
>>
>> It doesn't mention any check on VM exit. So, it looks to me that VM exit
>> doesn't do consistency checks. Then, I think there is no need to call
>> out this path.
> But this isn't a true VMEXIT -- it is indeed a VMENTER from L0 to L1 using
> VMCS01 but with an environment that allows L1 to run its VMEXIT handler just
> like it received a VMEXIT from L2.
>
> However I fully agree those code paths are details and shouldn't be changelog
> material.
>
> How about below changelog?
>
> Add support to allow guest to set two new CR3 non-address control bits to allow
> guest to enable the new Intel CPU feature Linear Address Masking (LAM).
>
> LAM modifies the checking that is applied to 64-bit linear addresses, allowing
> software to use of the untranslated address bits for metadata.  For user mode
> linear address, LAM uses two new CR3 non-address bits LAM_U48 (bit 62) and
> LAM_U57 (bit 61) to configure the metadata bits for 4-level paging and 5-level
> paging respectively.  LAM also changes VMENTER to allow both bits to be set in
> VMCS's HOST_CR3 and GUEST_CR3 to support virtualization.
>
> When EPT is on, CR3 is not trapped by KVM and it's up to the guest to set any of
> the two LAM control bits.  However when EPT is off, the actual CR3 used by the
> guest is generated from the shadow MMU root which is different from the CR3 that
> is *set* by the guest, and KVM needs to manually apply any active control bits
> to VMCS's GUEST_CR3 based on the cached CR3 *seen* by the guest.
>
> KVM manually checks guest's CR3 to make sure it points to a valid guest physical
> address (i.e. to support smaller MAXPHYSADDR in the guest).  Extend this check
> to allow the two LAM control bits to be set.  And to make such check generic,
> introduce a new field 'cr3_ctrl_bits' to vcpu to record all feature control bits
> that are allowed to be set by the guest.
>
> In case of nested, for a guest which supports LAM, both VMCS12's HOST_CR3 and
> GUEST_CR3 are allowed to have the new LAM control bits set, i.e. when L0 enters
> L1 to emulate a VMEXIT from L2 to L1 or when L0 enters L2 directly.  KVM also
> manually checks VMCS12's HOST_CR3 and GUEST_CR3 being valid physical address.
> Extend such check to allow the new LAM control bits too.
>
> Note, LAM doesn't have a global enable bit in any control register to turn
> on/off LAM completely, but purely depends on hardware's CPUID to determine
> whether to perform LAM check or not.  That means, when EPT is on, even when KVM
> doesn't expose LAM to guest, the guest can still set LAM control bits in CR3 w/o
> causing problem.  This is an unfortunate virtualization hole.  KVM could choose
> to intercept CR3 in this case and inject fault but this would hurt performance
> when running a normal VM w/o LAM support.  This is undesirable.  Just choose to
> let the guest do such illegal thing as the worst case is guest being killed when
> KVM eventually find out such illegal behaviour and that is the guest to blame.
Thanks for the advice.


