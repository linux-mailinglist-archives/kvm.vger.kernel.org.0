Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E531296E
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 04:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBHDhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 22:37:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:16981 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBHDhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 22:37:02 -0500
IronPort-SDR: B0ifOn87Q9YPjZ3tpVT44vpQN4SfonZH2M6pZSzFPp+92+rF3EEtHgDji8uB12rFzc0V6uNYEw
 PuKkYgXm6wBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="168777509"
X-IronPort-AV: E=Sophos;i="5.81,160,1610438400"; 
   d="scan'208";a="168777509"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 19:35:16 -0800
IronPort-SDR: HDxLVyIePuGZ1je3OPJ0RJlopV8uyvfolnmxjy00IYLaABmdDx53l5E2rm9zudA1h0LFTF02cc
 KFpnorD8b0rg==
X-IronPort-AV: E=Sophos;i="5.81,160,1610438400"; 
   d="scan'208";a="376959749"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.67]) ([10.238.130.67])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 19:35:13 -0800
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
To:     Borislav Petkov <bp@alien8.de>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com,
        x86-ml <x86@kernel.org>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <20210207114902.GA6723@zn.tnic>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <d770033f-5c75-8b83-08cc-eb6b3ff3a1cf@linux.intel.com>
Date:   Mon, 8 Feb 2021 11:35:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210207114902.GA6723@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2021 7:49 PM, Borislav Petkov wrote:
> On Sun, Feb 07, 2021 at 10:42:52AM -0500, Jing Liu wrote:
>> diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
>> index 7e0c68043ce3..fbb761fc13ec 100644
>> --- a/arch/x86/kernel/fpu/init.c
>> +++ b/arch/x86/kernel/fpu/init.c
>> @@ -145,6 +145,7 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_min_size);
>>    * can be dynamically expanded to include some states up to this size.
>>    */
>>   unsigned int fpu_kernel_xstate_max_size;
>> +EXPORT_SYMBOL_GPL(fpu_kernel_xstate_max_size);
>>   
>>   /* Get alignment of the TYPE. */
>>   #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 080f3be9a5e6..9c471a0364e2 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -77,12 +77,14 @@ static struct xfeature_capflag_info xfeature_capflags[] __initdata = {
>>    * XSAVE buffer, both supervisor and user xstates.
>>    */
>>   u64 xfeatures_mask_all __read_mostly;
>> +EXPORT_SYMBOL_GPL(xfeatures_mask_all);
>>   
>>   /*
>>    * This represents user xstates, a subset of xfeatures_mask_all, saved in a
>>    * dynamic kernel XSAVE buffer.
>>    */
>>   u64 xfeatures_mask_user_dynamic __read_mostly;
>> +EXPORT_SYMBOL_GPL(xfeatures_mask_user_dynamic);
>>   
>>   static unsigned int xstate_offsets[XFEATURE_MAX] = { [ 0 ... XFEATURE_MAX - 1] = -1};
>>   static unsigned int xstate_sizes[XFEATURE_MAX]   = { [ 0 ... XFEATURE_MAX - 1] = -1};
> Make sure you Cc x86@kernel.org when touching code outside of kvm.
>
> There's this script called scripts/get_maintainer.pl which will tell you who to
> Cc. Use it before you send next time please.
>
> Thx.
Thank you for the reminder. I'll cc that next time.

BRs,
Jing

