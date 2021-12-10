Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9165B46FDDE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbhLJJjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhLJJjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:39:12 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B32CC061746;
        Fri, 10 Dec 2021 01:35:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so27632583edd.0;
        Fri, 10 Dec 2021 01:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J7+bfSl77k8qoKRfxoMaCemHVKj1XiOHFVSzqWLEq1U=;
        b=IxdtM2RgbgdqXYq+PnABuVIMOt1ff6DKxgFQ4SyincfofYFQ40qErcr1ZLmdDKFMRf
         MJX+mMcnVf61L2d0dbT5HM0MI9blIf4ZJ73h1rr0o4XoCmpJ0TQStETFGmJ0t5CO74Ot
         Z8suMAWfhkPu9fBtUN0ZLkKcfKjH1IjwrypVx9tkaS/vnBxFdF1wn42LQc+dz/2csNUA
         6ZdLwLT8IdPbgok+Q7IhkSwHkC9fJCM8+xDdxlvX/qBaFN9bc7nAP/qZOs/RKPLmTdCh
         KiX77FAtKC1Pq7980eVWRbWz7PQQM1XQ0/9/+p+xOY5W2OJS1PfFHAJBarkxxr/SjR/C
         iXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J7+bfSl77k8qoKRfxoMaCemHVKj1XiOHFVSzqWLEq1U=;
        b=sjhNiQkoZDbxHgU1JF8F0AjBhbCBJAM/gmGgAwDCDD7plNMblbsX0XIHyXDwSYr5Kx
         sYeynvlMGpgpdUlWSmgUgc5pPz5v4do2FmbW41wXRM1iF83T2bekjjLWyRBjYjl7l9nW
         HyeWzvKUi8dy41W9mJVYMbCMDwn0VVRwTs61d+JzckUv4nNmbXRfu43ePW1PC9br/Ppm
         cUgr/umn+qU7MZXb51WAt8UafZVdUkMdTdKdHvtsluNsorq6pddAQiqyLYHbcouSp8KF
         nHRZhJT91VHI8LsHwJIhYanICUdcGAeeH6FDXtYWQT/REmHtEXSOCQdLO5JXI8Yv2/Qk
         ryig==
X-Gm-Message-State: AOAM530Npu9FdrF9t8Q4XI8DU/ZfSSF1d2jMM5+E6yU2ZXLjoCiM2/OP
        c/zRKd9+HgElFYEAIlDDoJM=
X-Google-Smtp-Source: ABdhPJx6LeQTDODOD8BSaFoJoDbt86J4KIl9CB80zm0rZMvG3trQ0MR1VhZgrlcxSnV5p8ZlauA4gw==
X-Received: by 2002:a17:906:e28b:: with SMTP id gg11mr22837899ejb.23.1639128935850;
        Fri, 10 Dec 2021 01:35:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::973? ([2001:b07:6468:f312::973])
        by smtp.googlemail.com with ESMTPSA id m25sm1105752edj.80.2021.12.10.01.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:35:35 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
Date:   Fri, 10 Dec 2021 10:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor
 kvm_perf_overflow{_intr}()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Andi Kleen <ak@linux.intel.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 01:54, Jim Mattson wrote:
> On Thu, Dec 9, 2021 at 12:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 9/12/2021 12:25 pm, Jim Mattson wrote:
>>>
>>> Not your change, but if the event is counting anything based on
>>> cycles, and the guest TSC is scaled to run at a different rate from
>>> the host TSC, doesn't the initial value of the underlying hardware
>>> counter have to be adjusted as well, so that the interrupt arrives
>>> when the guest's counter overflows rather than when the host's counter
>>> overflows?
>>
>> I've thought about this issue too and at least the Intel Specification
>> did not let me down on this detail:
>>
>>          "The counter changes in the VMX non-root mode will follow
>>          VMM's use of the TSC offset or TSC scaling VMX controls"
> 
> Where do you see this? I see similar text regarding TSC packets in the
> section on Intel Processor Trace, but nothing about PMU counters
> advancing at a scaled TSC frequency.

Indeed it seems quite unlikely that PMU counters can count fractionally.

Even for tracing the SDM says "Like the value returned by RDTSC, TSC 
packets will include these adjustments, but other timing packets (such 
as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone 
TSC packets are typically generated only when generation of other timing 
packets (MTCs and CYCs) has ceased for a period of time", I'm not even 
sure it's a good thing that the values in TSC packets are scaled and offset.

Back to the PMU, for non-architectural counters it's not really possible 
to know if they count in cycles or not.  So it may not be a good idea to 
special case the architectural counters.

Paolo
