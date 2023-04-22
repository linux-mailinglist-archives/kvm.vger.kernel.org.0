Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3004D6EB717
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 05:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDVDcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 23:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDVDcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 23:32:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1498319A8
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 20:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682134351; x=1713670351;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yc/2dUW2r3okKm7cotGE+CAPo5gFZLlukvB/JLwPwps=;
  b=JRRQE9iLa9b6UegC1OpeRG445CbYTJyp6yTUMivjngDQC4mMTaErwrDE
   C5cv/jZ5odtA7G/yhjjfZz1Mjvty87cgoM4wyS2gELggZZNNP119O2DoU
   tAoTuBslGDSS8aiCOAP8pL3I/7enBMipdx6O0mWx+/IC7idwW4qxQhGh8
   LjYOCmBGijf1HDfEd/JZY8e0pT4gq/hzRxhNq9na4RdIUag2zsGCpzhv8
   KV7XHdMeiFPyqxZ8caJwW0GM+buX4/TtbRqCpck4n6iI4E2SBq53uSp7U
   AU+KOQ74l1c4ZJ+sppUT7z7zOS2Jijem/4MR1Mx6H8NllmiFeau/kcqDi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344873678"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="344873678"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:32:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="695139303"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="695139303"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.122]) ([10.254.215.122])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:32:28 -0700
Message-ID: <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
Date:   Sat, 22 Apr 2023 11:32:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kai,

Thanks for your inputs.

I rephrased the changelog as following:


LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
masking for user mode pointers.

To support LAM in KVM, CR3 validity checks and shadow paging handling 
need to be
modified accordingly.

== CR3 validity Check ==
When LAM is supported, CR3 LAM bits are allowed to be set and the check 
of CR3
needs to be modified.
Add a helper kvm_vcpu_is_legal_cr3() and use it instead of 
kvm_vcpu_is_legal_gpa()
to do the new CR3 checks in all existing CR3 checks as following:
When userspace sets sregs, CR3 is checked in kvm_is_valid_sregs().
Non-nested case
- When EPT on, CR3 is fully under control of guest.
- When EPT off, CR3 is intercepted and CR3 is checked in kvm_set_cr3() 
during
   CR3 VMExit handling.
Nested case, from L0's perspective, we care about:
- L1's CR3 register (VMCS01's GUEST_CR3), it's the same as non-nested case.
- L1's VMCS to run L2 guest (i.e. VMCS12's HOST_CR3 and VMCS12's GUEST_CR3)
   Two paths related:
   1. L0 emulates a VMExit from L2 to L1 using VMCS01 to reflect VMCS12
          nested_vm_exit()
          -> load_vmcs12_host_state()
                -> nested_vmx_load_cr3()     //check VMCS12's HOST_CR3
   2. L0 to VMENTER to L2 using VMCS02
          nested_vmx_run()
          -> nested_vmx_check_host_state()   //check VMCS12's HOST_CR3
          -> nested_vmx_enter_non_root_mode()
             -> prepare_vmcs02()
                -> nested_vmx_load_cr3()     //check VMCS12's GUEST_CR3
   Path 2 can fail to VMENTER to L2 of course, but later this should 
result in
   path 1.

== Shadow paging handling ==
When EPT is off, the following changes needed to handle shadow paging:
- LAM bits should be stripped to perform GFN calculation from guest PGD 
when it
   is CR3 (for nested EPT case, guest PGD is nested EPTP).
   To be generic, extract the maximal base address mask from guest PGD 
since the
   validity of guest PGD has been checked already.
- Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination.
   It could potentially increase root cache misses and MMU reload, however,
   it's very rare to turn off EPT when performance matters.
- Active CR3 LAM bits should be kept to form a shadow CR3.

To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
the bits used to control supported features related to CR3 (e.g. LAM).
- Supported control bits are set to the field after set cpuid.
- the field is used in
   kvm_vcpu_is_legal_cr3() to check CR3.
   kvm_get_active_cr3_ctrl_bits() to extract active control bits of CR3.
   Also as a quick check for LAM feature support.

On 4/21/2023 7:43 PM, Huang, Kai wrote:
> On Fri, 2023-04-21 at 14:35 +0800, Binbin Wu wrote:
>> On 4/13/2023 5:13 PM, Huang, Kai wrote:
>>>> On 4/13/2023 10:27 AM, Huang, Kai wrote:
>>>>> On Thu, 2023-04-13 at 09:36 +0800, Binbin Wu wrote:
>>>>>> On 4/12/2023 7:58 PM, Huang, Kai wrote:
>>>>>>
>>>> ...
>>>>>>>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>>>>>>> Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this
>>>>>>> way, below
>>>>>>> mmu_check_root() may potentially catch other invalid bits, but in
>>>>>>> practice there should be no difference I guess.
>>>>>> In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.
>>>>>>
>>>>>> However, Sean pointed out that the return value of
>>>>>> mmu->get_guest_pgd(vcpu) could be
>>>>>> EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.
>>>>> Yes, although EPTP's high bits don't contain any control bits.
>>>>>
>>>>> But perhaps we want to make it future-proof in case some more control
>>>>> bits are added to EPTP too.
>>>>>
>>>>>> Since the guest pgd has been check for valadity, for both CR3 and
>>>>>> EPTP, it is safe to mask off non-address bits to get GFN.
>>>>>>
>>>>>> Maybe I should add this CR3 VS. EPTP part to the changelog to make it
>>>>>> more undertandable.
>>>>> This isn't necessary, and can/should be done in comments if needed.
>>>>>
>>>>> But IMHO you may want to add more material to explain how nested cases
>>>>> are handled.
>>>> Do you mean about CR3 or others?
>>>>
>>> This patch is about CR3, so CR3.
>> For nested case, I plan to add the following in the changelog:
>>
>>       For nested guest:
>>       - If CR3 is intercepted, after CR3 handled in L1, CR3 will be
>> checked in
>>         nested_vmx_load_cr3() before returning back to L2.
>>       - For the shadow paging case (SPT02), LAM bits are also be handled
>> to form
>>         a new shadow CR3 in vmx_load_mmu_pgd().
>>
>>
> I don't know a lot of code detail of KVM nested code, but in general, since your
> code only changes nested_vmx_load_cr3() and nested_vmx_check_host_state(), the
> changelog should focus on explaining why modifying these two functions are good
> enough.
>
> And to explain this, I think we should explain from hardware's perspective
> rather than from shadow paging's perspective.
>
>  From L0's perspective, we care about:
>
> 	1) L1's CR3 register (VMCS01's GUEST_CR3)
> 	2) L1's VMCS to run L2 guest
> 		2.1) VMCS12's HOST_CR3
> 		2.2) VMCS12's GUEST_CR3
>
> For 1) the current changelog has explained (that we need to catch _active_
> control bits in guest's CR3 etc).  For nested (case 2)), L1 can choose to
> intercept CR3 or not.  But this isn't the point because from hardware's point of
> view we actually care about below two cases instead:
>
> 	1) L0 to emulate a VMExit from L2 to L1 by VMENTER using VMCS01
> 	   to reflect VMCS12
> 	2) L0 to VMENTER to L2 using VMCS02 directly
>
> The case 2) can fail due to fail to VMENTER to L2 of course but this should
> result in L0 to VMENTER to L1 with a emulated VMEXIT from L2 to L1 which is the
> case 1).
>
> For case 1) we need new code to check VMCS12's HOST_CR3 against guest's _active_
> CR3 feature control bits.  The key code path is:
>
> 	vmx_handle_exit()
> 		-> prepare_vmcs12()
> 		-> load_vmcs12_host_state().
>
> For case 2) I _think_ we need new code to check both VMCS12's HOST_CR3 and
> GUEST_CR3 against active control bits.  The key code path is
>
> 	nested_vmx_run() ->
> 		-> nested_vmx_check_host_state()
> 		-> nested_vmx_enter_non_root_mode()
> 			-> prepare_vmcs02_early()
> 			-> prepare_vmcs02()
>
> Since nested_vmx_load_cr3() is used in both VMENTER using VMCS12's HOST_CR3
> (VMEXIT to L1) and GUEST_CR3 (VMENTER to L2), and it currently already checks
> kvm_vcpu_is_illegal_gpa(vcpu, cr3), changing it to additionally check guest CR3
> active control bits seems just enough.
>
> Also, nested_vmx_check_host_state() (i.e. it is called in nested_vmx_run() to
> return early if any HOST state is wrong) currently checks
> kvm_vcpu_is_illegal_gpa(vcpu, cr3) too so we should also change it.
>
> That being said, I do find it's not easy to come up with a "concise" changelog
> to cover both non-nested and (especially) nested cases, but it seems we can
> abstract some from my above typing?
>
> My suggestion is to focus on the hardware behaviour's perspective as typed
> above.  But I believe Sean can easily make a "concise" changelog if he wants to
> comment here :)
