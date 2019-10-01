Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC5C372D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 16:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389154AbfJAOYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 10:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388567AbfJAOYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 10:24:20 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17B1446673
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 14:24:20 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f11so6059211wrt.18
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 07:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W3GR9papAEXHX043kiaC8LTFO8bg9XO+Ud3u2pcC4iI=;
        b=KVgyeXNr310n9xSD8mOMMD3x7gtYqVtJaVHo7+a/ad7Sw/AIRLQDaSWdkgKoUlDAi/
         DN7LHyTarbMiJuh1TWrHG95eMKdDkrBevCAdL2T6+6XY9MRtnvGbRNo+Yd1y44gsage8
         aEveEtARm8ma4QpeopNB8LTKvKYMOSUoN8THQ/qCPdToK7crWF30Q6gBM3vDIPxXq+Z1
         kmHYkGaCcGD5IwzaAdcPWHkq1tqK1CFLBApy4HYXI+dpsIN7bg58ASXxCOHc5OtAzZV/
         P0ngPS7wcu7rhISTNqFGiIqvAxfY7tGQoACbXLr5zO7agAuje56IpsUdPqHi7sBwHwfl
         C33Q==
X-Gm-Message-State: APjAAAU0fay+UcwTba+DX03JFLJe49QNHwuXdAYpUcFkcdGuLZr+R1T2
        hodYF6iExVdpi187BYHvxCwbH7cF302dy7VaPgRG+mPw46iqE2x1rioQt8B0PqhZdeVeK3wXfmx
        Fx9BvOvU2h93a
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr19373862wrt.100.1569939858748;
        Tue, 01 Oct 2019 07:24:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzORLkuNzHf4U1+bG8M7lcDYpyd5xZy4wuVHfWzHzhZ0mVWCWsuudhjwCKFJb/4kvVTW1gw8A==
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr19373835wrt.100.1569939858454;
        Tue, 01 Oct 2019 07:24:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dd94:29a5:6c08:c3b5? ([2001:b07:6468:f312:dd94:29a5:6c08:c3b5])
        by smtp.gmail.com with ESMTPSA id h17sm2708084wmb.33.2019.10.01.07.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 07:24:17 -0700 (PDT)
Subject: Re: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190930233854.158117-1-jmattson@google.com>
 <87blv03dm7.fsf@vitty.brq.redhat.com>
 <08e172b2-eb75-04af-0b63-b0516c8455e1@redhat.com>
 <CALMp9eRu42dSwuZ5ZoGmPd9A5qw7wJmfh-OhCUFaWEke2vcHkg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <89918126-97f6-37ff-9d28-68440a15b710@redhat.com>
Date:   Tue, 1 Oct 2019 16:24:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRu42dSwuZ5ZoGmPd9A5qw7wJmfh-OhCUFaWEke2vcHkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 16:07, Jim Mattson wrote:
> On Tue, Oct 1, 2019 at 6:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 01/10/19 13:32, Vitaly Kuznetsov wrote:
>>> Jim Mattson <jmattson@google.com> writes:
>>>
>>>> KVM can only virtualize as many PMCs as the host supports.
>>>>
>>>> Limit the number of generic counters and fixed counters to the number
>>>> of corresponding counters supported on the host, rather than to
>>>> INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.
>>>>
>>>> Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
>>>> contiguous MSR indices reserved by Intel for event selectors. Since
>>>> the existing code relies on a contiguous range of MSR indices for
>>>> event selectors, it can't possibly work for more than 18 general
>>>> purpose counters.
>>>
>>> Should we also trim msrs_to_save[] by removing impossible entries
>>> (18-31) then?
>>
>> Yes, I'll send a patch in a second.
> 
> I thought you were going to revert that msrs_to_save patch. I've been
> working on a replacement.

We can use a little more time to think more about it and discuss it.

For example, trimming is enough for the basic usage of passing
KVM_SET_SUPPORTED_CPUID output to KVM_SET_CPUID2 and then retrieving all
MSRs in the list.  If that is also okay for Google's userspace, we might
actually leave everything that way and retroactively decide that you
need to filter the MSRs but only if you pass your own CPUID.

Paolo
