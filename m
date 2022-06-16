Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741EA54E670
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbiFPP4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiFPP43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:56:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C19530559;
        Thu, 16 Jun 2022 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655394989; x=1686930989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vl6QQxwjCAX4+CqE6Wqd7HLf/CcgifYO4slix8mPH74=;
  b=SfXsXRNLqq/aRYCWuJ1kU9xgGroTHI8U+tavOH2CjNTnls3L5yiYzD31
   /5rWT2Ni0z3Inw5rruVSScKBIU9+EpoIWjgDC5DBVx/DnXdb1nlUq6uJX
   iVv8wmwQSdka+3KNnZCCZ8zrHqRRSuYo90/MqxJIjclycvouXzr35+Dyz
   F+f5ohxXLMSlmlP35krC37A7DC6u9eTViL9h9sqV4kKI1tHebxFHouCxd
   vHqMFwPvrMNRT01qlIxvdcRTAuLnvbe4quDCchLuoB+m50YdVaJ6qRK70
   Jc5/y0HB3f3sDhHIvSYy6mCDDSOXmW7U8AqS8F6SZAdKoSisOcbTdI2BW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278074937"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="278074937"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:56:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="675079729"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.30.124]) ([10.255.30.124])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:56:26 -0700
Message-ID: <8d104ff6-5f31-5388-90f9-7dd6474440c9@intel.com>
Date:   Thu, 16 Jun 2022 23:56:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 19/19] KVM: x86: Enable supervisor IBT support for guest
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-20-weijiang.yang@intel.com>
 <YqsRttmgmbthHWVR@worktop.programming.kicks-ass.net>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YqsRttmgmbthHWVR@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2022 7:19 PM, Peter Zijlstra wrote:
> On Thu, Jun 16, 2022 at 04:46:43AM -0400, Yang Weijiang wrote:
>> Mainline kernel now supports supervisor IBT for kernel code,
>> to make s-IBT work in guest(nested guest), pass through
>> MSR_IA32_S_CET to guest(nested guest) if host kernel and KVM
>> enabled IBT. Note, s-IBT can work independent to host xsaves
>> support because guest MSR_IA32_S_CET can be stored/loaded from
>> specific VMCS field.
>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fe049d0e5ecc..c0118b33806a 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1463,6 +1463,7 @@ static const u32 msrs_to_save_all[] = {
>>   	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>>   	MSR_IA32_XSS,
>>   	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
>> +	MSR_IA32_S_CET,
>>   };
>
> So much like my local kvm/qemu hacks; this patch suffers the problem of
> not exposing S_SHSTK. What happens if a guest tries to use that?
With current solution, I think guest kernel will hit #GP while 
reading/writing PL0_SSP.
>
> Should we intercept and reject setting those bits or complete this patch
> and support full S_SHSTK? (with all the warts and horrors that entails)
>
> I don't think throwing this out in this half-finished state makes much
> sense (which is why I never much shared my hacks).

You reminded me to think over these cases even I don't have a solution now,

thank you!

>
>
>> @@ -11830,7 +11835,13 @@ int kvm_arch_hardware_setup(void *opaque)
>>   	/* Update CET features now as kvm_caps.supported_xss is finalized. */
>>   	if (!kvm_cet_user_supported()) {
>>   		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> -		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> +		/* If CET user bit is disabled due to cmdline option such as
>> +		 * noxsaves, but kernel IBT is on, this means we can expose
>> +		 * kernel IBT alone to guest since CET user mode msrs are not
>> +		 * passed through to guest.
>> +		 */
> Invalid multi-line comment style.
Oops, last minute change messed it up :-(
>
>> +		if (!cet_kernel_ibt_supported())
>> +			kvm_cpu_cap_clear(X86_FEATURE_IBT);
