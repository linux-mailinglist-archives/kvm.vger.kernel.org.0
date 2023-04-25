Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0666EDA3F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 04:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbjDYCfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 22:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjDYCfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 22:35:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F4B5277;
        Mon, 24 Apr 2023 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682390134; x=1713926134;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HnndgSw2hkm6qwVldvp2S2bsgVjK2XmJ95F+bAcDGyg=;
  b=N7n3HQPugrEIPr1ZvVKFkxCwdJzVaQAoKgY9W+2OznZeNDtTarFsfUJJ
   wZfOUKfUK6pHP4VsMpdWMVxOmivT3vPPFuotjri4J5hSbBvAGpOCMqSG3
   056HMCzaQkwjI1s4IXO/5SjxLjlSsTYTKB9WHPHnZpkNjZVI9dmUHQ33j
   IQyxe7Gx6wGsSsx6rC1FeYogSxB/9UvffVDp4JtVsca1q8cRm3QrnTigb
   4eurUCMvAvMccPh2B5ZiHgVmaVuQjuE8po/duLuFRfEch4OD502NznVxv
   Ib/s96BYKU/jYeQvMNnR4lGtJbqBYQUkcqp3DJ87wxfCaNAGsGDXTwyFw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="348548970"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="348548970"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="725923676"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="725923676"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.183]) ([10.238.0.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:35:31 -0700
Message-ID: <848cb820-e634-4608-5d09-a9bd9ee6de18@intel.com>
Date:   Tue, 25 Apr 2023 10:35:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/6] KVM: x86: Virtualize CR4.LASS
Content-Language: en-US
To:     "Gao, Chao" <chao.gao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-2-guang.zeng@intel.com> <ZEYwlMmzYnJjNNHq@chao-email>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZEYwlMmzYnJjNNHq@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/2023 3:32 PM, Gao, Chao wrote:
> On Thu, Apr 20, 2023 at 09:37:19PM +0800, Zeng Guang wrote:
>> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
>> as CR4.LASS generally set once for each vCPU at boot time and won't be
>> toggled at runtime. Besides, only if VM has LASS capability enumerated with
>> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
>> to set CR4.LASS.
>> By design CR4.LASS can be manipulated by nested guest as
>> well.
> This is inaccurate. The change in nested_vmx_cr_fixed1_bits_update() is
> to allow L1 guests to set CR4.LASS in VMX operation.

Essentially it allows nested guest to set CR4.LASS. L1 guest uses 
cr4_fixed1 to check
cr4 value requested to set by nested guest valid or not. Nested guest 
will get #GP
fault if it's not allowed.

> I would say:
>
> Set the CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests
> to allow guests to enable LASS in nested VMX operation.

