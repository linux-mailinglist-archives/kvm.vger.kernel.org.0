Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0E64067D4
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 09:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhIJHk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 03:40:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:22333 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhIJHkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 03:40:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="220691649"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="220691649"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2021 00:39:11 -0700
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="549158582"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2021 00:39:07 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, Tao Xu <tao3.xu@intel.com>,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <4079f0c9-e34c-c034-853a-b26908a58182@intel.com>
 <YTD7+v2t0dSZqVHF@google.com>
 <c7ff247a-0046-e461-09bf-bcf8b5d0f426@intel.com>
 <YTpW3M8Iyh8kLpyx@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ce2dfc44-d1cf-8d09-6a38-9befb6f65885@intel.com>
Date:   Fri, 10 Sep 2021 15:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTpW3M8Iyh8kLpyx@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/2021 2:47 AM, Sean Christopherson wrote:
> On Tue, Sep 07, 2021, Xiaoyao Li wrote:
>> On 9/3/2021 12:29 AM, Sean Christopherson wrote:
>>>> After syncing internally, we know that the internal threshold is not
>>>> architectural but a model-specific value. It will be published in some place
>>>> in future.
>>>
>>> Any chance it will also be discoverable, e.g. via an MSR?
>>
>> I also hope we can expose it via MSR. If not, we can maintain a table per
>> FMS in KVM to get the internal threshold. However, per FMS info is not
>> friendly to be virtualized (when we are going to enable the nested support).
> 
> Yeah, FMS is awful.  If the built-in buffer isn't discoverable, my vote is to
> assume the worst, i.e. a built-in buffer of '0', and have the notify_window
> param default to a safe value, e.g. 25k or maybe even 150k (to go above what the
> hardware folks apparently deemed safe for SPR).  It's obviously not idea, but
> it's better than playing FMS guessing games.
> 
>> I'll try to persuade internal to expose it via MSR, but I guarantee nothing.
> 
> ...
> 
>>> On a related topic, this needs tests.  One thought would be to stop unconditionally
>>> intercepting #AC if NOTIFY_WINDOW is enabled, and then have the test set up the
>>> infinite #AC vectoring scenario.
>>>
>>
>> yes, we have already tested with this case with notify_window set to 0. No
>> false positive.
> 
> Can you send a selftest or kvm-unit-test?
> 

Actually we implement the attacking case of CVE-2015-5307 with 
kvm-unit-test, while manually disabling the intercept of #AC.

First, it requires modification of KVM that only posting the 
kvm-unit-test doesn't help.

Second, release the attacking case is not the correct action.
