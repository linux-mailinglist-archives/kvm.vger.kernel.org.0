Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E47C210E05
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbgGAOt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 10:49:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbgGAOt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 10:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593614994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VfENiHNRnwNDgfhjH2onCnBOkQjCEWTV+c8v5VnSwKY=;
        b=Bf5ojbllwYISojpLvMUsF8a2FUMslam+MIr5TXk7uqvCARHIdaIQsTNUAUtJSd6tEvj8v0
        simHKtg3GnFzvxtuGgrXoyK0TyW+wSxLptvih8tux7GMmufEWur61rMwpPSm225dBLw1GS
        IjAT6NbWqXz8HJwI0LDwtFy9oH8Th1Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-jenL8w2lNne_2BKOoXBSaw-1; Wed, 01 Jul 2020 10:49:53 -0400
X-MC-Unique: jenL8w2lNne_2BKOoXBSaw-1
Received: by mail-ej1-f71.google.com with SMTP id yh3so9160225ejb.16
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 07:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VfENiHNRnwNDgfhjH2onCnBOkQjCEWTV+c8v5VnSwKY=;
        b=tqzA4kRp2b5N7karkwNNtqVacEB7NRRwhOxLe3HKCwWpAhzlD99BD3U54eHLwiI1K2
         0YHPtfJiFPtvepgPUEtnDpoQAkNffTsjfZiJti5fmXO+UbLIbsu7pPwiBvakb/ivb5Zn
         EvOatLHc5pciuv4c5DC4HonZNsHYURA4T9Yk2/QT2CKLTicUiMH5M4rZ1U/hzn9zGMrB
         DL037GrRizRZjbwRdLti+jZj/b6lQiWDLw7F3wzmxzHXd69/dIn9i3JzpxUWyQ//DDI6
         00fRRZZHrsc4oM3ky2dfLMjunnSo6aJqRl/MMA1ppVb3mgMzgu+LOdoFOC1WlU9IppDL
         dcbg==
X-Gm-Message-State: AOAM533W9sIfoYTryAd9GKar9t4A/9akt0T/5cL+lg0fwQG8jK60irzP
        QZrJezcS6DNsE3Ve58N/ci6LueZf9kbUFMVdYR5lQe1dcnbDBtdwq+6WIJLD9uBbE+Cf2uI4izD
        0qWD0PBSJi3IL
X-Received: by 2002:a17:906:4f87:: with SMTP id o7mr22886621eju.233.1593614991814;
        Wed, 01 Jul 2020 07:49:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFsmocBW6sUuPzil85gcSE/fWsfuLfnmCtOnoI7ei4G309ht7jv4kcRD+SnbqzFh2OzQabFg==
X-Received: by 2002:a17:906:4f87:: with SMTP id o7mr22886610eju.233.1593614991615;
        Wed, 01 Jul 2020 07:49:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z25sm4831346ejd.38.2020.07.01.07.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 07:49:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
In-Reply-To: <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
References: <20200628085341.5107-1-chenyi.qiang@intel.com> <20200628085341.5107-3-chenyi.qiang@intel.com> <878sg3bo8b.fsf@vitty.brq.redhat.com> <0159554d-82d5-b388-d289-a5375ca91323@intel.com> <87366bbe1y.fsf@vitty.brq.redhat.com> <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
Date:   Wed, 01 Jul 2020 16:49:49 +0200
Message-ID: <87zh8j9to2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/1/2020 8:44 PM, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 
>>> On 7/1/2020 5:04 PM, Vitaly Kuznetsov wrote:
>>>> Chenyi Qiang <chenyi.qiang@intel.com> writes:
>>> [...]
>>>>>    static const int kvm_vmx_max_exit_handlers =
>>>>> @@ -6830,6 +6838,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>>    	if (unlikely(vmx->exit_reason.failed_vmentry))
>>>>>    		return EXIT_FASTPATH_NONE;
>>>>>    
>>>>> +	/*
>>>>> +	 * check the exit_reason to see if there is a bus lock
>>>>> +	 * happened in guest.
>>>>> +	 */
>>>>> +	if (vmx->exit_reason.bus_lock_detected)
>>>>> +		handle_bus_lock(vcpu);
>>>>
>>>> In case the ultimate goal is to have an exit to userspace on bus lock,
>>>
>>> I don't think we will need an exit to userspace on bus lock. See below.
>>>
>>>> the two ways to reach handle_bus_lock() are very different: in case
>>>> we're handling EXIT_REASON_BUS_LOCK we can easily drop to userspace by
>>>> returning 0 but what are we going to do in case of
>>>> exit_reason.bus_lock_detected? The 'higher priority VM exit' may require
>>>> exit to userspace too. So what's the plan? Maybe we can ignore the case
>>>> when we're exiting to userspace for some other reason as this is slow
>>>> already and force the exit otherwise?
>>>
>>>> And should we actually introduce
>>>> the KVM_EXIT_BUS_LOCK and a capability to enable it here?
>>>>
>>>
>>> Introducing KVM_EXIT_BUS_LOCK maybe help nothing. No matter
>>> EXIT_REASON_BUS_LOCK or exit_reason.bus_lock_detected, the bus lock has
>>> already happened. Exit to userspace cannot prevent bus lock, so what
>>> userspace can do is recording and counting as what this patch does in
>>> vcpu->stat.bus_locks.
>> 
>> Exiting to userspace would allow to implement custom 'throttling'
>> policies to mitigate the 'noisy neighbour' problem. The simplest would
>> be to just inject some sleep time.
>> 
>
> So you want an exit to userspace for every bus lock and leave it all to 
> userspace. Yes, it's doable.
>

In some cases we may not even want to have a VM exit: think
e.g. real-time/partitioning case when even in case of bus lock we may
not want to add additional latency just to count such events. I'd
suggest we make the new capability tri-state:
- disabled (no vmexit, default)
- stats only (what this patch does)
- userspace exit
But maybe this is an overkill, I'd like to hear what others think.

> As you said, the exit_reason.bus_lock_detected case is the tricky one. 
> We cannot do the similar to extend vcpu->run->exit_reason, this breaks 
> ABI. Maybe we can extend the vcpu->run->flags to indicate bus lock 
> detected for the other exit reason?

This is likely the easiest solution.

-- 
Vitaly

