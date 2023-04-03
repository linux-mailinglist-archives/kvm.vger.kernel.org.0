Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829326D3C2C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 05:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjDCDh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 23:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDCDhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 23:37:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA38B72BC
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 20:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680493042; x=1712029042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RoBj8L0+FlXiFiZc0OsVac2fgoZBe/txBJA7aUvnXe8=;
  b=eDxph58+qG3LKP4qka1VxysTQ1bXFKHEjoOM4sl1bUeHSgV38UJXMqdV
   Hs+iSZ1BCIthyT5dR+uYtxWA1DOZP8Knz+Azm5NqByz6H60ztTIJksenc
   juzBAzSvwa42+26GPO8XJEgiiq81G/P4FMQhFvfojRQDxjHJSowUPC7lx
   /ftVHfaNn03BLCJjChz7GRsMRkzY9AjaHmfTFjNTwkxTZYEMkt9ayYQZL
   6wQPinMwzfg9JS1TsjTetLPdOOSd5E6oK4na1sOCp7YnA9AIVnsXEad5+
   Le2+LYqTII1j+iWza91r6C66epjom6qj35J74Tc60Ke2RH2dIhMJiJcEo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="339296769"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="339296769"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 20:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="635964146"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="635964146"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.210.241]) ([10.254.210.241])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 20:37:20 -0700
Message-ID: <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
Date:   Mon, 3 Apr 2023 11:37:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
 <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
 <ZCR2PBx/4lj9X0vD@google.com>
 <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/2023 6:46 AM, Huang, Kai wrote:
> On Wed, 2023-03-29 at 10:34 -0700, Sean Christopherson wrote:
>> On Wed, Mar 29, 2023, Binbin Wu wrote:
>>> On 3/29/2023 10:04 AM, Huang, Kai wrote:
>>>> On Wed, 2023-03-29 at 09:27 +0800, Binbin Wu wrote:
>>>>> On 3/29/2023 7:33 AM, Huang, Kai wrote:
>>>>>> On Tue, 2023-03-21 at 14:35 -0700, Sean Christopherson wrote:
>>>>>>> On Mon, Mar 20, 2023, Chao Gao wrote:
>>>>>>>> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>>>>>>>>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>>>>>>>>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>>>>>>>>
>>>>>>>>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>>>>>>>>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
>>>>>>>> It is better to split this patch into two: one for nested and one for
>>>>>>>> SGX.
>>>>>>>>
>>>>>>>> It is possible that there is a kernel release which has just one of
>>>>>>>> above two flawed commits, then this fix patch cannot be applied cleanly
>>>>>>>> to the release.
>>>>>>> The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
>>>>>>> for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
>>>>>>> just drop the nVMX side of things.
>>>>>> But it looks the old code doesn't unconditionally inject #UD when in
>>>>>> compatibility mode?
>>>>> I think Sean means VMX instructions is not valid in compatibility mode
>>>>> and it triggers #UD, which has higher priority than VM-Exit, by the
>>>>> processor in non-root mode.
>>>>>
>>>>> So if there is a VM-Exit due to VMX instruction , it is in 64-bit mode
>>>>> for sure if it is in long mode.
>>>> Oh I see thanks.
>>>>
>>>> Then is it better to add some comment to explain, or add a WARN() if it's not in
>>>> 64-bit mode?
>>> I also prefer to add a comment if no objection.
>>>
>>> Seems I am not the only one who didn't get itï¿½ : )
>> I would rather have a code change than a comment, e.g.
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f63b28f46a71..0460ca219f96 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4931,7 +4931,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>>          int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
>>          bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
>>   
>> -       if (is_reg) {
>> +       if (is_reg ||
>> +           WARN_ON_ONCE(is_long_mode(vcpu) && !is_64_bit_mode(vcpu))) {
>>                  kvm_queue_exception(vcpu, UD_VECTOR);
>>                  return 1;
>>          }
>>
>>
> Looks good to me.
>
>> The only downside is that querying is_64_bit_mode() could unnecessarily trigger a
>> VMREAD to get the current CS.L bit, but a measurable performance regressions is
>> extremely unlikely because is_64_bit_mode() all but guaranteed to be called in
>> these paths anyways (and KVM caches segment info), e.g. by kvm_register_read().
> Agreed.
>
>> And then in a follow-up, we should also be able to do:
>>
>> @@ -5402,7 +5403,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>>          if (instr_info & BIT(10)) {
>>                  kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
>>          } else {
>> -               len = is_64_bit_mode(vcpu) ? 8 : 4;
>> +               len = is_long_mode(vcpu) ? 8 : 4;
>>                  if (get_vmx_mem_address(vcpu, exit_qualification,
>>                                          instr_info, true, len, &gva))
>>                          return 1;
>> @@ -5476,7 +5477,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>>          if (instr_info & BIT(10))
>>                  value = kvm_register_read(vcpu, (((instr_info) >> 3) & 0xf));
>>          else {
>> -               len = is_64_bit_mode(vcpu) ? 8 : 4;
>> +               len = is_long_mode(vcpu) ? 8 : 4;
>>                  if (get_vmx_mem_address(vcpu, exit_qualification,
>>                                          instr_info, false, len, &gva))
>>                          return 1;
>>
> Yeah, although it's a little bit wired the actual WARN() happens after above
> code change.  But I don't know how to make the code better.  Maybe we should put
> the WARN() at the very beginning but this would require duplicated code in each
> handle_xxx() for VMX instructions.

I checked the code again and find the comment of 
nested_vmx_check_permission().

"/*
  * Intel's VMX Instruction Reference specifies a common set of 
prerequisites
  * for running VMX instructions (except VMXON, whose prerequisites are
  * slightly different). It also specifies what exception to inject 
otherwise.
  * Note that many of these exceptions have priority over VM exits, so they
  * don't have to be checked again here.
  */"

I think the Note part in the comment has tried to callout why the check 
for compatibility mode is unnecessary.

But I have a question here, nested_vmx_check_permission() checks that 
the vcpu is vmxon,
otherwise it will inject a #UD. Why this #UD is handled in the VMExit 
handler specifically?
Not all #UDs have higher priority than VM exits?

According to SDM Section "Relative Priority of Faults and VM Exits":
"Certain exceptions have priority over VM exits. These include 
invalid-opcode exceptions, ..."
Seems not further classifications of #UDs.

Anyway, I will seperate this patch from the LAM KVM enabling patch. And 
send a patch seperately if
needed later.

