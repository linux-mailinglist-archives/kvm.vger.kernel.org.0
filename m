Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDA2210B2A
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgGAMoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 08:44:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730521AbgGAMoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 08:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593607461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=riQxZ5rhfq+xTLDrKWBK+2YUUfRaxcLTVz5p24IUk7M=;
        b=A9YbqXI2T25yE+Cyp9Ydb46O+KMb9UPuSmomLQXvRdkJOdHCtdhktELm+3/W4D2cLrJZRS
        uxPyMqD8DU+MO/Gk1UEKRKgBfH57LUsghNghBWum0HTvFY50dYxSYntnISCylloIZVGJCf
        bYL8efmsseIXeu82B9lcc3rAqcFB0/U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-04T5n_qXN6iTbwFlAZRwNA-1; Wed, 01 Jul 2020 08:44:17 -0400
X-MC-Unique: 04T5n_qXN6iTbwFlAZRwNA-1
Received: by mail-ed1-f72.google.com with SMTP id m12so18721590edv.3
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 05:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=riQxZ5rhfq+xTLDrKWBK+2YUUfRaxcLTVz5p24IUk7M=;
        b=V0lTuGR9PqrDk9U00eN5vJy4QgMCuuV8eb9E1XpaCmuMjrGZBBqEGTe5O/XqT8CexA
         JW6KUcDkvWlP4BuDe+8uBEy2/WRzQZW3dbHOzh5Mh4NeY82g5Ggix6EeeYYRie3N4b41
         b4QiIDbtp3KCvN7d/vqyKfVcBvN9fKWYqLgMoMdMMh8bM1F60EvHV8fWQ9NqyQueTYFj
         ZokQNxByDkcoRY2CujWMMvw3LnFWgtOC4vgsb/MLyM8ZhOSLCMcVZY3rhEsnysUbmnRh
         O3LTmPqSPfci1suUxoNKw0HJkeyjUHc6rv5VqjLMf+Oxr07KSxZh5QFXq06qOJ54pgTZ
         oUPA==
X-Gm-Message-State: AOAM532oncbSEf+DVym9dC1xngm37vBfqCDAPEsLsJSrCcZlhdosVuP9
        EscFiCENvFie5H9Z6gnlAqVvPVdzmgV6ZdlqcgXdjEWLdVbCxFCE+CRfaNUZqATUxKTXMRv2+x+
        gQdFPpxa26rAD
X-Received: by 2002:a05:6402:31ba:: with SMTP id dj26mr22401323edb.181.1593607455470;
        Wed, 01 Jul 2020 05:44:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlhs2/hMdT+AuIFl2+vhvO3qechJDVg98Gz7ZMissArc72TZWdEtQtZ/ZYXN935osYIJZjfg==
X-Received: by 2002:a05:6402:31ba:: with SMTP id dj26mr22401299edb.181.1593607455292;
        Wed, 01 Jul 2020 05:44:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c18sm4595965eja.59.2020.07.01.05.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 05:44:13 -0700 (PDT)
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
In-Reply-To: <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
References: <20200628085341.5107-1-chenyi.qiang@intel.com> <20200628085341.5107-3-chenyi.qiang@intel.com> <878sg3bo8b.fsf@vitty.brq.redhat.com> <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
Date:   Wed, 01 Jul 2020 14:44:09 +0200
Message-ID: <87366bbe1y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/1/2020 5:04 PM, Vitaly Kuznetsov wrote:
>> Chenyi Qiang <chenyi.qiang@intel.com> writes:
> [...]
>>>   static const int kvm_vmx_max_exit_handlers =
>>> @@ -6830,6 +6838,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>   	if (unlikely(vmx->exit_reason.failed_vmentry))
>>>   		return EXIT_FASTPATH_NONE;
>>>   
>>> +	/*
>>> +	 * check the exit_reason to see if there is a bus lock
>>> +	 * happened in guest.
>>> +	 */
>>> +	if (vmx->exit_reason.bus_lock_detected)
>>> +		handle_bus_lock(vcpu);
>> 
>> In case the ultimate goal is to have an exit to userspace on bus lock,
>
> I don't think we will need an exit to userspace on bus lock. See below.
>
>> the two ways to reach handle_bus_lock() are very different: in case
>> we're handling EXIT_REASON_BUS_LOCK we can easily drop to userspace by
>> returning 0 but what are we going to do in case of
>> exit_reason.bus_lock_detected? The 'higher priority VM exit' may require
>> exit to userspace too. So what's the plan? Maybe we can ignore the case
>> when we're exiting to userspace for some other reason as this is slow
>> already and force the exit otherwise? 
>
>> And should we actually introduce
>> the KVM_EXIT_BUS_LOCK and a capability to enable it here?
>> 
>
> Introducing KVM_EXIT_BUS_LOCK maybe help nothing. No matter 
> EXIT_REASON_BUS_LOCK or exit_reason.bus_lock_detected, the bus lock has 
> already happened. Exit to userspace cannot prevent bus lock, so what 
> userspace can do is recording and counting as what this patch does in 
> vcpu->stat.bus_locks.

Exiting to userspace would allow to implement custom 'throttling'
policies to mitigate the 'noisy neighbour' problem. The simplest would
be to just inject some sleep time.

-- 
Vitaly

