Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA853356B
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 04:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242649AbiEYClP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 22:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243620AbiEYClB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 22:41:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1E76F4B5;
        Tue, 24 May 2022 19:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653446460; x=1684982460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EoglK7wI9wFrWezRsQe3Br0zDO3xeXDwJ23PuVxLiPA=;
  b=F1MWyDkGsYyryrQWkUEZ9WW1qcuNNi100Dq/cUJG5awqxsUKN3XFaNkQ
   yZ2uHb/98ahsN2+gjC50OClCDE7b7q0gKQ2lBowg2ibusFeOh/rYtMJka
   AdiTMtJIRQxpgBbU3ztr6vx0zLEC9untcWYqzl8mexRn5DeO/bimHQRTi
   c6yGHp6xcZGTUlG+FdPH6GWwIX+31yT3EDMV3tzWBVanHRqwRxTlkNIV0
   KxWCBngBZn9rfaYvXepvaJ2oA9jeXWKLYjYILYX8D8sbSjigvjUwdMV2j
   0j2Y32LcSOJUdI5DHhCgiPn2diyEmGARks8yxaFAs6zawe3VGt4xqR8LU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="253572689"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="253572689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 19:40:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="601612579"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.184]) ([10.254.211.184])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 19:40:56 -0700
Message-ID: <9f675446-7028-6f45-7e06-1efde012afb4@intel.com>
Date:   Wed, 25 May 2022 10:40:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] KVM: VMX: Read BNDCFGS if not from_vmentry
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421091331.11196-1-lei4.wang@intel.com>
 <YoaFknp7Swj0DdRw@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <YoaFknp7Swj0DdRw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/2022 1:59 AM, Sean Christopherson wrote:
> On Thu, Apr 21, 2022, Lei Wang wrote:
>> In the migration case, if nested state is set after MSR state, the value
>> needs to come from the current MSR value.
>>
>> Signed-off-by: Lei Wang <lei4.wang@intel.com>
>> Reported-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f18744f7ff82..58a1fa7defc9 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -3381,7 +3381,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>>   	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
>>   		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>   	if (kvm_mpx_supported() &&
>> -		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>> +	    (!from_vmentry ||
> Gah, my bad, this isn't correct either.  The minor issue is that it should check
> vmx->nested.nested_run_pending, not just from_vmentry.  If nested state is restored
> and a VM-Entry is pending, then the MSRs that were saved+restore were L1's MSRs,
> not L2's MSRs.
>
> That won't cause problems because the consumption correctly checks nested_run_pending,
> it's just confusing and an unnecessary VMREAD.
>
> But that's a moot point because vmcs01 will not hold the correct value in the SMM
> case.  Luckily, BNDCFGS is easy to handle because it's unconditionally saved on
> VM-Exit, which means that vmcs12 is guaranteed to hold the correct value for both
> SMM and state restore (without pending entry) because the pseudo-VM-Exit for both
> will always save vmcs02's value into vmcs12.
>
> GUEST_IA32_DEBUGCTL is a much bigger pain because it's conditionally saved on
> exit.   I think the least awful approach would be to save L2's value into
> vmcs01_debugctl prior to the forced exit in vmx_enter_smm(), but that will require
> more changes to the state restore flow.  Grr.
>
> I'll send patches for both BNDCFGS and IA32_DEBUGCTL, and will take a careful look
> at the PKS stuff too.  I'm guessing it should follow the BNDCFGS logic.
>
> Sorry for the runaround.

Thanks for your detailed reviewing, no need for sorry.

Looking forward to your fix patches.

