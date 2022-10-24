Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BF96097DE
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 03:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJXBiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 21:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJXBiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 21:38:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797B66D56C;
        Sun, 23 Oct 2022 18:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666575484; x=1698111484;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2H2z3QDOm830n+Fd6QFs4UpTvtG9t3ftZ4pDHombJ+o=;
  b=FGEEKm1IWLh3zj/SRgSUBEorlRO3ssbZRgmgphgww1qiUKsh4qf8CNq4
   gkAZiBijlaF5ailX8tRyxbaXEWtQ7jgxT+iY9m3G/QX42nS+45+UrDFrQ
   9lEG2c9Ekc4oAmyLPMqiOTKtdkgRZY0gAjCMdojnMFRYmE3G/cRKtExHQ
   WzLQUJbHkULVENJmrghgmhp7Ttx7o3RpUkkmucS+w2CFtT6b/IiU3vhV0
   cBsQIBNGC9SYgL9JYf91inGzpVNSgh9JZfXVwvKUwHxIuREb6dQkkW9qs
   Bs6DdCr9BcfkDturJUxUl7Eial7TOfowyB0SVIadU+xnwxAjgey/zMQV5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371536635"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="371536635"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 18:38:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="664392993"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="664392993"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.136]) ([10.255.30.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 18:38:02 -0700
Message-ID: <70ea1214-38aa-3b51-9c1d-6661b3b45144@intel.com>
Date:   Mon, 24 Oct 2022 09:37:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
 <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
 <Y1F4AoeOhNFQnHnJ@google.com>
 <b40fd338-cb3b-b602-0059-39f775e77ad6@intel.com>
 <Y1LmWAyG7S4bgzBs@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Y1LmWAyG7S4bgzBs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/2022 2:35 AM, Sean Christopherson wrote:
> On Fri, Oct 21, 2022, Xiaoyao Li wrote:
>> On 10/21/2022 12:32 AM, Sean Christopherson wrote:
>>> If we really want to clean up this code, I think the correct approach would be to
>>> inject #GP on all relevant MSRs if CPUID.MCA==0, e.g.
>>
>> It's what I thought of as well. But I didn't find any statement in SDM of
>> "Accessing Machine Check MSRs gets #GP if no CPUID.MCA"
> 
> Ugh, stupid SDM.  Really old SDMs, e.g. circa 1997, explicity state in the
> CPUID.MCA entry that:
> 
>    Processor supports the MCG_CAP MSR.
> 
> But, when Intel introduced the "Architectural MSRs" section (2001 or so), the
> wording was changed to be less explicit:
> 
>    The Machine Check Architecture, which provides a compatible mechanism for error
>    reporting in P6 family, Pentium 4, and Intel Xeon processors, and future processors,
>    is supported. The MCG_CAP MSR contains feature bits describing how many banks of
>    error reporting MSRs are supported.
> 
> and the entry in the MSR index just lists P6 as the dependency:
> 
>    IA32_MCG_CAP (MCG_CAP) Global Machine Check Capability (R/O) 06_01H
> 
> So I think it's technically true that MCG_CAP is supposed to exist iff CPUID.MCA=1,
> but we'd probably need an SDM change to really be able to enforce that :-(

I'll talk to Intel architects for this. :)
