Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C96E03A4
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 03:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDMBX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 21:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDMBXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 21:23:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138ED10EF;
        Wed, 12 Apr 2023 18:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681348999; x=1712884999;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uPFFUXaRUA3+p8FaGfmgcJOZ0ecnB25FXfYFzWhIqWo=;
  b=EENTcYvhHRJwGVaGGZZ3LU2bZh7C+NbcD6MU35l2sIgcXc7S0SG9I+78
   XemWmAlN0LfNxpDMfCSvOlJSGd9afFMI7XEAVXA9LYLKou/RchdZ3qOdK
   t1tc6LpLJP8bL91I9vEgEaJdTOIoXYYP1FAj/HU+sSlsKOHmJwBKrHwPz
   Uhi95MFL/l+a+iBweFDzRM31di4DqjNAFH02Lzg9/lxmML4xmYHYqdrn3
   ixR+PHjW+l97TMnS5Veto2vbpbu0ERZiWU9UY0woAq2ANhZNGgr4tzIW/
   PkcLBjKhiEh90EIo0JHJG+uI4kFVcxVuH8xIFLAPQ13tOHxFG4JOAW7gD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="346743376"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="346743376"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:23:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="721795583"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721795583"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.200]) ([10.255.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:23:16 -0700
Message-ID: <8c009f31-2e85-f0fa-9b42-0681fe73d828@intel.com>
Date:   Thu, 13 Apr 2023 09:23:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH 1/2] KVM: VMX: Use kvm_read_cr4() to get cr4 value
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230410125017.1305238-1-xiaoyao.li@intel.com>
 <20230410125017.1305238-2-xiaoyao.li@intel.com> <ZDRDKsPGP9JI2MHA@google.com>
 <f8beddb6-5139-07e7-c880-6767b1e9ba40@intel.com>
 <ZDbIU7uTmj7pCD47@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZDbIU7uTmj7pCD47@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/2023 11:03 PM, Sean Christopherson wrote:
> On Wed, Apr 12, 2023, Xiaoyao Li wrote:
>> On 4/11/2023 1:11 AM, Sean Christopherson wrote:
>>> On Mon, Apr 10, 2023, Xiaoyao Li wrote:
>>>> Directly use vcpu->arch.cr4 is not recommended since it gets stale value
>>>> if the cr4 is not available.
>>>>
>>>> Use kvm_read_cr4() instead to ensure correct value.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/vmx.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index d7bf14abdba1..befa2486836b 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -3431,7 +3431,7 @@ static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>>>    void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>>>    {
>>>> -	unsigned long old_cr4 = vcpu->arch.cr4;
>>>> +	unsigned long old_cr4 = kvm_read_cr4(vcpu);
>>>
>>> Ha!  I've been tempted to change this multiple times, but always thought I was
>>> just being a bit obsessive :-)
>>>
>>> Patches look good, but I'm going to hold them for 6.5 just in case this somehow
>>> causes a problem, e.g. if there's a bizzaro nested path that "works" because KVM
>>> _doesn't_ decache info from the current VMCS.
>>
>> so you will put it in kvm-next after 6.4 merge windows?
> 
> The likely candidate is "kvm-x86 vmx", and I probably won't apply the patches until
> after v6.4-rc2 (rc2 being my preferred base for the next cycle).  But yes, the plan
> is to apply the patches after the 6.4 merge window.
> 
> Are you asking because you want to know if you need to resend for 6.5?  Or does
> the timing/location matter for some other reason, e.g. a dependency from another
> patch/series?

none of it. Just to confirm I get it. :)
