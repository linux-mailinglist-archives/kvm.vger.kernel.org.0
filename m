Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60175A20DA
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 08:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244991AbiHZGYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 02:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiHZGY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 02:24:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB623A3467;
        Thu, 25 Aug 2022 23:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661495068; x=1693031068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dIU8pZHYiZ6O4dmorHDdZWn/aLhwXgrJJMoBlipzCRA=;
  b=FTO2r+Q9yLp4ncHeptMJdglilmmhNvwXvtPP2NiJmcVItrXnxkFpWTdJ
   Ft9+GbK+aN5nNySbhhS1Zw15coh9/F+4QMYd1qLH/Hr5CB09+D8NEYllM
   oeca5trEqhHdsbAr9v8maBn56RgfZAmXplZjxx2+CE0hVncUk6pDPaPHZ
   Tt6MRlVSdCXD+/+Y1Ziu0BTd6axKhdJaVP/BbUHUkbV73/mII6k7ztipI
   9xXCeE3rkqqJ3vpLi+wHH98X3+3UrbUztzHgIIk3lErzdZ8UIXGjxa82V
   yyZeaMDf9vXCbgKvdEcP/uYQPSxIBGAlRr8wJC7Nn5+xv1ROwh+/IKLiR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295709701"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="295709701"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 23:24:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="678755446"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.28]) ([10.255.30.28])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 23:24:26 -0700
Message-ID: <705268cd-6280-21dd-e825-62d416d64f42@linux.intel.com>
Date:   Fri, 26 Aug 2022 14:24:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
 <651c33a5-4b9b-927f-cb04-ec20b8c3d730@linux.intel.com>
 <YwT0+DO4AuO1xL82@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <YwT0+DO4AuO1xL82@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/23 23:40, Sean Christopherson wrote:
> On Tue, Aug 23, 2022, Binbin Wu wrote:
>> On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
>>> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>>> +{
>>> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
>>> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
>>> +
>>> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
>>> +
>>> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
>>> +			 (((field) & 0x6000) == 0x2000 ||
>>> +			  ((field) & 0x6000) == 0x6000),
>>> +			 "Invalid TD VMCS access for 64-bit field");
>> if bits is 64 here, "bits != 64" is false, how could this check for "Invalid
>> TD VMCS access for 64-bit field"?
> Bits 14:13 of the encoding, which is extracted by "(field) & 0x6000", encodes the
> width of the VMCS field.  Bit 0 of the encoding, "(field) & 0x1" above, is a modifier
> that is only relevant when operating in 32-bit mode, and is disallowed because TDX is
> 64-bit only.
>
> This yields four possibilities for TDX:
>
>    (field) & 0x6000) == 0x0000 : 16-bit field
>    (field) & 0x6000) == 0x2000 : 64-bit field
>    (field) & 0x6000) == 0x4000 : 32-bit field
>    (field) & 0x6000) == 0x6000 : 64-bit field (technically "natural width", but
>                                                effectively 64-bit because TDX is
> 					      64-bit only)
>
> The assertion is that if the encoding indicates a 64-bit field (0x2000 or 0x6000),
> then the number of bits KVM is accessing must be '64'.  The below assertions do
> the same thing for 32-bit and 16-bit fields.

Thanks for explanation, it is crystal clear to me now.  :)


>   
>>> +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
>>> +			 ((field) & 0x6000) == 0x4000,
>>> +			 "Invalid TD VMCS access for 32-bit field");
>> ditto
>>
>>
>>> +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
>>> +			 ((field) & 0x6000) == 0x0000,
>>> +			 "Invalid TD VMCS access for 16-bit field");
>> ditto
