Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81483617454
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiKCCim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKCCik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:38:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87A360DB;
        Wed,  2 Nov 2022 19:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443119; x=1698979119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HDFLCaCyc3lX5iiak5BW5IDi2drtmEaHv9p5NRzhnWI=;
  b=UlnqelkOZGAZmT7bdY3UNYY2v4jFRhrnthwW0xjMWPkd8xlTLs7wMpOf
   kxc5AHfFAhkdjdek6Z0KX9qAZ3AxwqX0H/auKvHQhPMbJSqj0/lQIlymK
   rScdUXKteiAu3wzrpnmz5wXSfv0vhD2FeNwxMzY/JpBsPBGEXlXAFCJrY
   ImCMnflz0X5KMPFwWzO+rIm1yd9TfDtgMUVJo95r5/tThidKlxy4egHY0
   zO57cHCglLk0oDPOixKdX9Bsd2BGyNxGmxkUTWwbrhTRxb57R6VADF4T1
   DOrOANT/E4QVtaQAS/x3OvEP4cB9h23LR8PFEMNLACwvvaBJE8yoW+Fs4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="307185247"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="307185247"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:38:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="585624843"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="585624843"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:38:33 -0700
Message-ID: <13f4d8c0-4bf9-1822-f5de-8a45cfbb0199@linux.intel.com>
Date:   Thu, 3 Nov 2022 10:38:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 2/6] x86: KVM: Enable AMX-FP16 CPUID and expose it to
 guest
To:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-3-jiaxi.chen@linux.intel.com>
 <639c22a1-b0b0-9fb0-2a9a-060c53f9f540@intel.com>
 <aa7f6efc-de4c-c5f6-fb5f-ef514e4513a3@redhat.com>
 <c00a4715-94f7-2d4a-02b3-533bb309c130@intel.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <c00a4715-94f7-2d4a-02b3-533bb309c130@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/2022 2:21 AM, Dave Hansen wrote:
> On 11/2/22 11:16, Paolo Bonzini wrote:
>> On 11/2/22 19:14, Dave Hansen wrote:
>>>>         kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>>> -        F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
>>>> +        F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
>>>>       );
>>>>         kvm_cpu_cap_mask(CPUID_D_1_EAX,
>>>
>>> KVM folks, is the idea that every feature that is enumerated to a guest
>>> needs to be in one of these masks?  Or is there something special about
>>> the features in these masks?
>>
>> Yes, all features are vetted manually to see whether they require new
>> MSRs and the like.  Therefore, anything that userspace can set in the
>> guest's CPUID must be in the list.
> 
> Makes sense.
> 
> Intel folks, when you add these bits, can you please include information
> about the "vetting" that you performed?
> 
> For example, it would be handy to say:
> 
> 	AMX_FP16 is just a new instruction that operates on existing AMX
> 	tile registers.  It needs no additional enabling on top of the
> 	existing kernel AMX enabling.

Thanks for Dave's suggestion.  It makes the commit message much clear
and readable. Will modify it in v2.

-- 
Regards,
Jiaxi
