Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5794F522D86
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 09:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbiEKHn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 03:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiEKHnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 03:43:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E5E6B001;
        Wed, 11 May 2022 00:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652255004; x=1683791004;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=P0abuEy5rcc4ymlheFvp1poiCTfeWdKzAwRCJAEPCyk=;
  b=QLPfb3TcSm/8Kg9X+0p1Irr/HClvYU4VcKfuYnZRlqyjx/HXANndZFLN
   X/+Ni9h41RnaWxNJQsouPIhDWFLjAdb2COv04iKLYyqJOT2P7i9cCgBqs
   gDwmCvlssDvypUDM0XHwk43ooKu94CiYGK9cNss0Ge9mTwCL0Oj8Jo+EC
   /jgJOupAXLrjWo6D3kgXblSePYUib3jwkKR8O6A2RXO3Qc58c4qcCB7FY
   rFPJ+wAN9RyWd5AQM/9AExyQ/tgPITanPVGq9lZdhV8+YMQnex4L7gzAd
   o7F6Qlzcx1HwBfg0TWnauHEQQU7uta9xjmgOcBCjKXNgYqQi5HBdyBAp5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="294858276"
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="294858276"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 00:43:23 -0700
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="593988901"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.95]) ([10.249.171.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 00:43:20 -0700
Message-ID: <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
Date:   Wed, 11 May 2022 15:43:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/2022 11:51 PM, Paolo Bonzini wrote:
> On 5/6/22 05:33, Yang Weijiang wrote:
>> Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
>> on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
>> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
>> LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
>> clear the bit when guest does warm reset.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>    arch/x86/kvm/vmx/vmx.c | 4 ++++
>>    1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 6d6ee9cf82f5..b38f58868905 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4593,6 +4593,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>    	if (!init_event) {
>>    		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>>    			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>> +	} else {
>> +		flip_arch_lbr_ctl(vcpu, false);
>>    	}
>>    }
>>    
>> @@ -7704,6 +7706,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>>    	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>>    	vmx->nested.vmxon = false;
>>    	vmx_clear_hlt(vcpu);
>> +	flip_arch_lbr_ctl(vcpu, false);
>>    	return 0;
>>    }
>>    
>> @@ -7725,6 +7728,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>>    		vmx->nested.nested_run_pending = 1;
>>    		vmx->nested.smm.guest_mode = false;
>>    	}
>> +	flip_arch_lbr_ctl(vcpu, true);
>>    	return 0;
>>    }
>>    
> This is incorrect, you hare not saving/restoring the actual value of
> LBREn (which is "lbr_desc->event != NULL").  Therefore, a migration
> while in SMM would lose the value of LBREn = true.
>
> Instead of using flip_arch_lbr_ctl, SMM should save the value of the MSR
> in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm
> (feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), i.e.
> the 32-bit case can be ignored).

In the case of migration in SMM, I assume kvm_x86_ops->enter_smm() 
called in source side

and kvm_x86_ops->leave_smm() is called at destination, then should the 
saved LBREn be transferred

to destination too? The destination can rely on the bit to defer setting 
LBREn bit in

VMCS until kvm_x86_ops->leave_smm() is called. is it good? thanks!

>   
>
> Paolo
