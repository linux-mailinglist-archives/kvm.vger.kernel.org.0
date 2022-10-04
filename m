Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2EF5F4885
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJDRbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJDRbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA02C8
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 10:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664904690;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QfpTNaT0ZloKMOY8r0juaL8paBYlY22qFA0iYzAyK40=;
        b=B3m7FWWZBCD/EpxN1NKnhjLHd3nid+ViyqiBSo2erqMBbt5BDBc3PdU+GUtb19BrgRI88Y
        G99ShRoxxVeGoAjx1pvTxv67mviisd+3uBpFbpUIg8Qcz7W4MAF0aXFcW7guRIHhvGnH4E
        fz0B/sTHdrowFgFiPcz2PBRVHjPq+oA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-6-rKfqpG0ZOoy4f4p93zj1rg-1; Tue, 04 Oct 2022 13:31:29 -0400
X-MC-Unique: rKfqpG0ZOoy4f4p93zj1rg-1
Received: by mail-wr1-f72.google.com with SMTP id f9-20020adfc989000000b0022b3bbc7a7eso4366894wrh.13
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 10:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=QfpTNaT0ZloKMOY8r0juaL8paBYlY22qFA0iYzAyK40=;
        b=XkYdMlQH/bkz6CDuGO+khXz4DGFS+WQ+/cEAgT6lby0C2hjOq42HCpcbOl9hpaLoUT
         r5R4PeXEEauMqJ4XTudPR/awPpL8UVBvH+YijUd2OaZrAQ7V0rjieSkdmWYbo8cW46UB
         lrV/cS7ydrl/9g0QbRi9Nvz0r8IR0BwBfCd3Hr/1eLNv1/Yag3Z5fXEMJpgXxV3kK3Xs
         rQTv5ZrYEmPj0bctueG7rsVra4BnuWKxJhwkOzoENZnW4vYrB+QWr3Q3LQDeYrwwV6WW
         z47Bl1G1PBDACfir/HKmx8vuLt+OFbVHAecSc2YC0CV5NMMXyGFrgBd/FwUTun8XfF51
         oXFg==
X-Gm-Message-State: ACrzQf0Urr0OZpwrSLUjS2sr44tKCjPM8PPjTX04KgwT0TBSEzyXoLdo
        XbMsITeCNM5ia9RKmu7r28r2OphoCAmf3bbCszg6DUNBtQa2zUWHFOToGjhFOQODq1OO5xJ00Yi
        3ViZWsjYyCa8D
X-Received: by 2002:a05:6000:1acb:b0:22a:d11b:5eb9 with SMTP id i11-20020a0560001acb00b0022ad11b5eb9mr17180505wry.492.1664904687729;
        Tue, 04 Oct 2022 10:31:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5yrT7770uIlpxu6HmeliV8GUUVY18truzMnC0Ze9CV4u6SD/dsmXVK/0kjzc4Z1jjHiMnL6A==
X-Received: by 2002:a05:6000:1acb:b0:22a:d11b:5eb9 with SMTP id i11-20020a0560001acb00b0022ad11b5eb9mr17180477wry.492.1664904687306;
        Tue, 04 Oct 2022 10:31:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h6-20020adfe986000000b0022cd6e852a2sm16033030wrm.45.2022.10.04.10.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 10:31:26 -0700 (PDT)
Message-ID: <5b69f259-4a25-18eb-6c7c-4b59e1f81036@redhat.com>
Date:   Tue, 4 Oct 2022 19:31:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        maz@kernel.org, oliver.upton@linux.dev, reijiw@google.com
References: <20220805004139.990531-1-ricarkol@google.com>
 <89c93f1e-6e78-f679-aecb-7e506fa0cea3@redhat.com>
 <YzxmHpV2rpfaUdWi@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <YzxmHpV2rpfaUdWi@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 10/4/22 18:58, Alexandru Elisei wrote:
> Hi Eric,
>
> On Tue, Oct 04, 2022 at 06:20:23PM +0200, Eric Auger wrote:
>> Hi Ricardo, Marc,
>>
>> On 8/5/22 02:41, Ricardo Koller wrote:
>>> There are some tests that fail when running on bare metal (including a
>>> passthrough prototype).  There are three issues with the tests.  The
>>> first one is that there are some missing isb()'s between enabling event
>>> counting and the actual counting. This wasn't an issue on KVM as
>>> trapping on registers served as context synchronization events. The
>>> second issue is that some tests assume that registers reset to 0.  And
>>> finally, the third issue is that overflowing the low counter of a
>>> chained event sets the overflow flag in PMVOS and some tests fail by
>>> checking for it not being set.
>>>
>>> Addressed all comments from the previous version:
>>> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
>>> - adding missing isb() and fixed the commit message (Alexandru).
>>> - fixed wording of a report() check (Andrew).
>>>
>>> Thanks!
>>> Ricardo
>>>
>>> Ricardo Koller (3):
>>>   arm: pmu: Add missing isb()'s after sys register writing
>>>   arm: pmu: Reset the pmu registers before starting some tests
>>>   arm: pmu: Check for overflow in the low counter in chained counters
>>>     tests
>>>
>>>  arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
>>>  1 file changed, 39 insertions(+), 17 deletions(-)
>>>
>> While testing this series and the related '[PATCH 0/9] KVM: arm64: PMU:
>> Fixing chained events, and PMUv3p5 support' I noticed I have kvm unit
>> test failures on some machines. This does not seem related to those
>> series though since I was able to get them without. The failures happen
>> on Amberwing machine for instance with the pmu-chain-promotion.
>>
>> While further investigating I noticed there is a lot of variability on
>> the kvm unit test mem_access_loop() count. I can get the counter = 0x1F
>> on the first iteration and 0x96 on the subsequent ones for instance.
>> While running mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E) I was
>> expecting the counter to be close to 20. It is on some HW.
>>
>> [..]
>>
>> So I come to the actual question. Can we do any assumption on the
>> (virtual) PMU quality/precision? If not, the tests I originally wrote
>> are damned to fail on some HW (on some other they always pass) and I
>> need to make a decision wrt re-writing part of them, expecially those
>> which expect overflow after a given amount of ops. Otherwise, there is
>> either something wrong in the test (asm?) or in KVM PMU emulation.
>>
>> I tried to bisect because I did observe the same behavior on some older
>> kernels but the bisect was not successful as the issue does not happen
>> always.
>>
>> Thoughts?
> Looking at mem_access_loop(), the first thing that jumps out is the fact
> that is missing a DSB barrier. ISB affects only instructions, not memory
> accesses and without a DSB, the PE can reorder memory accesses however it
> sees fit.
Following your suggestion I added a dsh ish at the end of loop and
before disabling pmcr_el0 (I hope this is the place you were thinking
of) but unfortunately it does not seem to fix my issue.
>
> I also believe precise_instrs_loop() to be in the same situation, as the
> architecture doesn't guarantee that the cycle counter increments after
> every CPU cycle (ARM DDI 0487I.a, page D11-5246):
>
> "Although the architecture requires that direct reads of PMCCNTR_EL0 or
> PMCCNTR occur in program order, there is no requirement that the count
> increments between two such reads. Even when the counter is incrementing on
> every clock cycle, software might need check that the difference between
> two reads of the counter is nonzero."
OK
>
> There's also an entire section in ARM DDI 0487I.a dedicated to this, titled
> "A reasonable degree of inaccuracy" (page D11-5248). I'll post some
> snippets that I found interesting, but there are more examples and
> explanations to be found in that chapter.

yeah I saw that, hence my question about the reasonable disparity we can
expect from the HW/SW stack.
>
> "In exceptional circumstances, such as a change in Security state or other
> boundary condition, it is acceptable for the count to be inaccurate."
>
> PMCR writes are trapped by KVM. Is a change in exception level an
> "exception circumstance"? Could be, but couldn't find anything definitive.
> For example, the architecture allows an implementation to drop an event in
> the case of an interrupt:
>
> "However, dropping a single branch count as the result of a rare
> interaction with an interrupt is acceptable."
>
> So events could definitely be dropped because of an interrupt for the host.
>
> And there's also this:
>
> "The imprecision means that the counter might have counted an event around
> the time the counter was disabled, but does not allow the event to be
> observed as counted after the counter was disabled."
In our case there seems to be a huge discrepancy.
>
> If you want my opinion, if it is necessary to count the number of events
> for a test instead, I would define a margin of error on the number of
> events counted. Or the test could be changed to check that at least one
> such event was observed.
I agree with you on the fact a reasonable margin must be observed and
the tests may need to be rewritten to account for the observed disparity
if considered "normal". Another way to proceed is to compute the
disparity before launching the main tests and if too big, skip the main
tests. Again on some HW, the counts are really 'as expected' and constant.

Thanks!

Eric
>
> Thanks,
> Alex
>

