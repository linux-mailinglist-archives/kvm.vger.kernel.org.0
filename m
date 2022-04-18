Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA08505558
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbiDRNME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbiDRNKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:10:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E483C2E6;
        Mon, 18 Apr 2022 05:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650286188; x=1681822188;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ABkdpW+V2FJ0I93fLJrLSjfEAalvHr2mygxY11H9jGg=;
  b=IJKjD8MoL0bhRXaAvvtYx90ROTn/qZCbxRvS1xY9j2uWNz6xMXHN+029
   6ov5hSFrAPgoUhQvIaPyY6MzQcGHDrtyEfKl5dpNGI6p1Bzz1sWtHxEkN
   EL0VW7zgIYEs+2zRBmBxbNlPEDFSqVcuvkl9TIs9KLfC4dgYmKBfLeweL
   QLGD8uhuC2z/64eZN4eJO84tEbud/M4rGYWOsyUJtars8scQE+oVUTmLk
   H1foY43tCH8wyPkI7tfs1CyFGPlPllm4vFuNRYeSI/0KKfg/lIRHHy6V9
   6NXFjVeYRP4HIZmaoEB4NnIZqEwdN1TYxXqGalHB+g4MTtrBKKZny7J3X
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="288598413"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="288598413"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 05:49:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="575558445"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.215.57]) ([10.254.215.57])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 05:49:22 -0700
Message-ID: <8dee4d22-8b32-e2b0-4f4f-8c1921fce5b3@intel.com>
Date:   Mon, 18 Apr 2022 20:49:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v8 9/9] KVM: VMX: enable IPI virtualization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-10-guang.zeng@intel.com> <YlmOUtXgIdQcUTO1@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YlmOUtXgIdQcUTO1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/15/2022 11:25 PM, Sean Christopherson wrote:
> On Mon, Apr 11, 2022, Zeng Guang wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d1a39285deab..23fbf52f7bea 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11180,11 +11180,15 @@ static int sync_regs(struct kvm_vcpu *vcpu)
>>   
>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>   {
>> +	int ret = 0;
>> +
>>   	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
>>   		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
>>   			     "guest TSC will not be reliable\n");
>>   
>> -	return 0;
>> +	if (kvm_x86_ops.alloc_ipiv_pid_table)
>> +		ret = static_call(kvm_x86_alloc_ipiv_pid_table)(kvm);
> Add a generic kvm_x86_ops.vcpu_precreate, no reason to make this so specific.
> And use KVM_X86_OP_RET0 instead of KVM_X86_OP_OPTIONAL, then this can simply be
>
> 	return static_call(kvm_x86_vcpu_precreate);
>
> That said, there's a flaw in my genius plan.
>
>    1. KVM_CREATE_VM
>    2. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=1
>    3. KVM_CREATE_VCPU, create IPIv table but ultimately fails
>    4. KVM decrements created_vcpus back to '0'
>    5. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=4096
>    6. KVM_CREATE_VCPU w/ ID out of range
>
> In other words, malicious userspace could trigger buffer overflow.


This is the tricky exploit that make max_vcpu_ids update more times. I 
think we
can avoid this issue by checking pid table availability during the 
pre-creation
of the first vCPU. If it's already allocated, free it and re-allocate to 
accommodate
table size to new max_vcpu_ids if updated.

> That could be solved by adding an arch hook to undo precreate, but that's gross
> and a good indication that we're trying to solve this the wrong way.
>
> I think it's high time we add KVM_FINALIZE_VM, though that's probably a bad name
> since e.g. TDX wants to use that name for VM really, really, being finalized[*],
> i.e. after all vCPUs have been created.
>
> KVM_POST_CREATE_VM?  That's not very good either.
>
> Paolo or anyone else, thoughts?
>
> [*] https://lore.kernel.org/all/83768bf0f786d24f49d9b698a45ba65441ef5ef0.1646422845.git.isaku.yamahata@intel.com
