Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988124029C4
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 15:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbhIGNen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 09:34:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:31512 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhIGNem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 09:34:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="218337167"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="218337167"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 06:33:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="537974849"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.12]) ([10.249.169.12])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 06:33:23 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <seanjc@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <4079f0c9-e34c-c034-853a-b26908a58182@intel.com>
 <YTD7+v2t0dSZqVHF@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <c7ff247a-0046-e461-09bf-bcf8b5d0f426@intel.com>
Date:   Tue, 7 Sep 2021 21:33:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTD7+v2t0dSZqVHF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/2021 12:29 AM, Sean Christopherson wrote:
> On Thu, Sep 02, 2021, Chenyi Qiang wrote:
>> On 8/3/2021 8:38 AM, Xiaoyao Li wrote:
>>> On 8/2/2021 11:46 PM, Sean Christopherson wrote:
>>>> IIRC, SGX instructions have a hard upper bound of 25k cycles before they
>>>> have to check for pending interrupts, e.g. it's why EINIT is
>>>> interruptible.  The 25k cycle limit is likely a good starting point for
>>>> the combined minimum.  That's why I want to know the internal minimum; if
>>>> the internal minimum is _guaranteed_ to be >25k, then KVM can be more
>>>> aggressive with its default value.
>>>
>>> OK. I will go internally to see if we can publish the internal threshold.
>>>
>>
>> Hi Sean,
>>
>> After syncing internally, we know that the internal threshold is not
>> architectural but a model-specific value. It will be published in some place
>> in future.
> 
> Any chance it will also be discoverable, e.g. via an MSR?  

I also hope we can expose it via MSR. If not, we can maintain a table 
per FMS in KVM to get the internal threshold. However, per FMS info is 
not friendly to be virtualized (when we are going to enable the nested 
support). I'll try to persuade internal to expose it via MSR, but I 
guarantee nothing.

> That would be ideal
> as we could give the module param an "auto" mode where the combined threshold is
> set to a minimum KVM-defined value, e.g.
> 
> 	static int __read_mostly notify_window = -1;
> 	module_param(notify_window, int, 444);
> 
> 	...
> 
> 	rdmsrl_safe(MSR_NOTIFY_WINDOW_BUFFER, &buffer);
> 	if (notify_window == -1) {
> 		if (buffer < KVM_DEFAULT_NOTIFY_WINDOW)
> 			notify_window = 0;
> 		else
> 			notifiy_window = KVM_DEFAULT_NOTIFY_WINDOW - buffer;
> 	}
> 		
>> On Sapphire Rapids platform, the threshold is 128k. With this in mind, is it
>> appropriate to set 0 as the default value of notify_window?
> 
> Maybe?  That's still not a guarantee that _future_ CPUs will have an internal
> threshold >25k.

but we can always use the formula above to guarantee it.

vmcs.notify_window = KVM_DEFAULT_NOTIFY_WINDOW > internal ?
                      KVM_DEFAULT_NOTIFY_WINDOW - internal : 0;

> On a related topic, this needs tests.  One thought would be to stop unconditionally
> intercepting #AC if NOTIFY_WINDOW is enabled, and then have the test set up the
> infinite #AC vectoring scenario.
> 

yes, we have already tested with this case with notify_window set to 0. 
No false positive.

