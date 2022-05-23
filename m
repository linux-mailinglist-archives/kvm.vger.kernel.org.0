Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA17C5312B9
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbiEWPh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiEWPh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 11:37:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08DD252A4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653320247; x=1684856247;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h1HbB3DDLhhFuCUQQLlXpf9LZqQh0bJznUSAY7BwaBU=;
  b=hy957UwXUOfPPmMoPVj7LOFb71RilSy+JXavKvFjLNeSApU2fayrz7vr
   F49nZDOT+sG9gKz/Df2xvT7mjNYjCs9xQ9v9m2du14nmDzWUaYPtA0OdH
   iyILZuqC+6OD81bD5RF4xv8OfdIbl9Wc5v3SBtAC7T6K6mBu38x5rsMKI
   7geMHPuz2DdAoZk57zqmqJcbUcyQdtlu745puE3C9kjeBJAVhrRK7Tsb2
   q2K9mG91NE/8mmqPFdmEgUqh92oHHqEZSRRZ/qUdnr/aMhI1GNtnoe3v+
   g7ZbUZq1Eyb1Q7wvzlIJphtN7GI02+MwKMUOTgDUKr/ku4whs2aKN/c9G
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253133956"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253133956"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:37:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="600709334"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.127]) ([10.249.171.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:37:21 -0700
Message-ID: <7b167777-c33f-b99f-5377-bdf909c8dbee@intel.com>
Date:   Mon, 23 May 2022 23:37:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 08/36] i386/tdx: Adjust get_supported_cpuid() for
 TDX VM
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-9-xiaoyao.li@intel.com>
 <20220523090133.tdctqihkmwv7nlog@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220523090133.tdctqihkmwv7nlog@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/2022 5:01 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> - The supported XCR0 and XSS bits needs to be cap'ed by tdx_caps, because
>>    KVM uses them to setup XFAM of TD.
> 
>> +    case 0xd:
>> +        if (index == 0) {
>> +            if (reg == R_EAX) {
>> +                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
>> +                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
>> +            } else if (reg == R_EDX) {
>> +                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
>> +                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
>> +            }
>> +        } else if (index == 1) {
>> +            /* TODO: Adjust XSS when it's supported. */
>> +        }
>> +        break;
> 
>> +    default:
>> +        /* TODO: Use tdx_caps to adjust CPUID leafs. */
>> +        break;
> 
> Hmm, that looks all a bit messy and incomplete, also the commit
> message doesn't match the patch (describes XSS which isn't actually
> implemented).

For XSS, QEMU recently got XSS MASK defined, I will use it in this patch.

For other CPUID leaves, we have following patches (a series) to enable 
fine-grained feature control for TDX guest and CPU model for it. So the 
plan is to make it functional with no error in this basic series. Anyway 
I will update the commit message to describe clearly.

> take care,
>    Gerd
> 

