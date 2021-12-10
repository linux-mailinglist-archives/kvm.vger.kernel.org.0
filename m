Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E21470E45
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243508AbhLJXDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbhLJXDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 18:03:25 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF8BC061746;
        Fri, 10 Dec 2021 14:59:49 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so34804003eda.11;
        Fri, 10 Dec 2021 14:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T2puOokeCNV8xWAxhgz6YPlQa9F/yVQdmT6GpYFr/Zc=;
        b=CCL811133lml5fd6U1ueyd3Fxrn45u9zqPDFGfCdpB/EXRG6oRsNsMDuyE8XFpDFnA
         4V2noEE0PHrv0wyttvk2BRV2Q1ES7+OXiAAenzWydEFyOXiEAcFH8o0mzCXHzeDYNfJN
         JkzViCvaGid5GI/ve3nYCm8wANkiYNziU39tud7fDjTNWxLQVMmnE0hXfjiVLZG/HaRi
         0aql2OVCN0CZ5rT7OFz80abW5d+oQAtz3ATZuugl8XyUG7gThjP+bWB7js7NkpBX6+JK
         y2LBvwYPpqoaMhuv29/y8hU0XcZhdlX4p3cPBXqQCj1BKJsc6EzhySIeqdy8geOAyo9a
         NJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T2puOokeCNV8xWAxhgz6YPlQa9F/yVQdmT6GpYFr/Zc=;
        b=6+A39iTAaI9rcna9HSsNPuIhh7SU6deiceqk3FbzKm7RHgzPmZNaXDNY/zSW/5oI6g
         S0CLjJgr9pbAi2Vb7FozbU+EvSAbRAA6S4o8Dl2ctZrwkheaD9wVJ7Eb6Co5Sj1MqOMz
         QzwAtoUFSzts68G70YrXDjFFyG3idcuFMDMsZhuEE2SW7TOKiAMyNMMlxWR81YVPdh0h
         MgrKsGNr/c2pcZKNXg1iEPb7zDs0ra2FC4qHSCpSM/Tee73IWND1z/0hxhYZE/yens7b
         Nixy0RTjOfkrWwELC+AJ4vNeIuUrUZstEAgVLfIsMXCwoG4HH8Y/y3ENoTj8UeOUC1vn
         vQmQ==
X-Gm-Message-State: AOAM533VugPtSD5IzUe8HSI7FQsQf3btAns4oNTzGrxjqdmbXFtlSNzg
        K3yWaOSjAGWnl4QzmiTmYYI=
X-Google-Smtp-Source: ABdhPJwZw8dSkutBgvsjnnlCtJC5aztTokriuEiyFlFXjYartfxcC9JMZ/9I4QWDbVzqZf+BkDizYw==
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr43198775edb.185.1639177187825;
        Fri, 10 Dec 2021 14:59:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id w5sm2214182edc.58.2021.12.10.14.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 14:59:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c381aa2c-beb5-480f-1f24-a14de693e78f@redhat.com>
Date:   Fri, 10 Dec 2021 23:59:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor
 kvm_perf_overflow{_intr}()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com>
 <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
 <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 23:55, Jim Mattson wrote:
>>
>> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
>> packets will include these adjustments, but other timing packets (such
>> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
>> TSC packets are typically generated only when generation of other timing
>> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
>> sure it's a good thing that the values in TSC packets are scaled and offset.
>>
>> Back to the PMU, for non-architectural counters it's not really possible
>> to know if they count in cycles or not.  So it may not be a good idea to
>> special case the architectural counters.
>
> In that case, what we're doing with the guest PMU is not
> virtualization. I don't know what it is, but it's not virtualization.

It is virtualization even if it is incompatible with live migration to a 
different SKU (where, as you point out below, multiple TSC frequencies 
might also count as multiple SKUs).  But yeah, it's virtualization with 
more caveats than usual.

> Exposing non-architectural events is questionable with live migration,
> and TSC scaling is unnecessary without live migration. I suppose you
> could have a migration pool with different SKUs of the same generation
> with 'seemingly compatible' PMU events but different TSC frequencies,
> in which case it might be reasonable to expose non-architectural
> events, but I would argue that any of those 'seemingly compatible'
> events are actually not compatible if they count in cycles.

I agree.  Support for marshaling/unmarshaling PMU state exists but it's 
more useful for intra-host updates than for actual live migration, since 
these days most live migration will use TSC scaling on the destination.

Paolo

> 
> Unless, of course, Like is right, and the PMU counters do count fractionally.
> 

