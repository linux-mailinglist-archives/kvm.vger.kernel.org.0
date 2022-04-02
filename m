Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10C64F01D0
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354835AbiDBNAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 09:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238974AbiDBNAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 09:00:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B0413DE9;
        Sat,  2 Apr 2022 05:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648904332; x=1680440332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1oh9WbktFqlG6EG6X9CN0PCZbltAesQdU2DAWj+J/rg=;
  b=CKr++QeL2Wdaz4JQnjNr+yh8hR1Y4geLMbdcHxigFxFzNuW6P8PI3nuL
   VXwIphV6wrv8pYlAxY8vAQOLJTd2n9Qv0nMvvouZCSpUMRGJBJ6xb2bM5
   E/d89jpy8ox7rwrbw55I4vQ63yplQzY3/j/9UyhBgV1kWFb4LHnFrYN0o
   en94PqMN+4NuTyqLGPFgL6Bh+xOUtqc0OP2FepTxlujaUF5sebUu+JLOM
   gHURBOJxHWcA9BccMCANS8s+kHX9duVlpcBc6ER67Pwauun8T097085Rw
   qYvYPJPF48V0Z4pZTdCOvyYndG8vkFHg90qqNTX7jvIOR0GL65U7lAO2p
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="260286864"
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="260286864"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 05:58:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="548132631"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.208.38]) ([10.254.208.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 05:58:45 -0700
Message-ID: <1c6ad344-299c-bd78-c6e7-79a815e15ef1@intel.com>
Date:   Sat, 2 Apr 2022 20:58:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 3/8] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
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
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-4-guang.zeng@intel.com> <YkYuDo3hOmcwA1iF@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YkYuDo3hOmcwA1iF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/2022 6:41 AM, Sean Christopherson wrote:
> On Fri, Mar 04, 2022, Zeng Guang wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c569dc2b9192..8a5713d49635 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2422,6 +2422,21 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>>   	return 0;
>>   }
>>   
>> +static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
> I slightly prefer controls64 over controls_64.  As usual, KVM is inconsistent as
> a whole, but vmcs_read/write64 omit the underscore, so we can at least be somewhat
> consistent within VMX.
>
>> +					 u32 msr, u64 *result)
>> +{
>> +	u64 allowed1;
>> +
>> +	rdmsrl(msr, allowed1);
>> +
>> +	/* Ensure minimum (required) set of control bits are supported. */
>> +	if (ctl_min & ~allowed1)
> Eh, just drop @ctl_min.  Practically speaking, there is zero chance tertiary
> controls or any other control of this nature will ever be mandatory.  Secondary
> controls would fall into the same boat, but specifying min=0 allows it to share
> helpers, so it's the lesser of evils.
>
> With the error return gone, this can be
>
>    static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>    {
> 	u64 allowed;
>
> 	rdmsrl(msr, allowed);
>
> 	return ctl_opt & allowed;
>    }

Make sense. I will change it.  Thanks.


> Alternatively, we could take the control-to-modify directly and have no return,
> but I like having the "u64 opt = ..." in the caller.
