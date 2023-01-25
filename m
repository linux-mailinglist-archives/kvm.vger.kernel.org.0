Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2167AB3D
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 08:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjAYH4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 02:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjAYH4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 02:56:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53929457C2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 23:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674633356;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O27zZx2fjGXVLntPmy1wi4nf/LLllnmjmtwtEs3YlHs=;
        b=JnLAoHIf7RlSpIElwFwD8HjwA6VOK/KQ4vt/idtcMVfiNnGmGiD6cFXztysiN9fXVcTNDZ
        aU0f7JBZj1dYQoW8iklNAGiFIOGdyl7588ea4NkPIGezJlVwygocrW1tW6zl8FCfxwVTfq
        GOSTnb869rzKNwhKEq4AnpTTd9zbevg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-BlqXfdGHMTmq08Xhq8IOxw-1; Wed, 25 Jan 2023 02:55:55 -0500
X-MC-Unique: BlqXfdGHMTmq08Xhq8IOxw-1
Received: by mail-qk1-f198.google.com with SMTP id bm30-20020a05620a199e00b007090f3c5ec0so10821924qkb.21
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 23:55:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O27zZx2fjGXVLntPmy1wi4nf/LLllnmjmtwtEs3YlHs=;
        b=UDBjEbqsMGCdcFinUfV+uVviWLe4G0SjNY2jAxCohgyF7RK7DYlqtpnembexMesSvM
         fFQ+d2DkqqoIltnkWiGHvl3NZVA0OYByCgQgGSWXDz9UXvYMVHuJucCfoTUs31rAMknX
         25QBlo3+mlltwEC4neRxGMtlzeqWC+wPwciixdY0eTFqFMnN9VZ2B06fSbAg1bkgdlX7
         3LBlLeLgDHjHmwg5pCTDPun5cevDnJD55/IsI8ZXGm9ityom/SZckGdIJGlqWnsXUTaq
         hQnrhsMLeM581aSdTzjM4sYZT0yjVOy4F65bPsoOkhcmHY8V6x47MdNF7bDNdv+lqKtT
         qDww==
X-Gm-Message-State: AFqh2kpO4+mtAp8ZKarJmEASS/yDcle7phyzWWs2R/nHaqGGPos2l7+E
        Vhl8rzSSCzMaUdH4JwBhgH5BFDZnp4nuXOlQJRhGNz43kFWZcOC4+9EDeQX7TYoVWupflDcAZMa
        fEy+3w4D717jz
X-Received: by 2002:a05:622a:1a08:b0:3b6:340b:fb29 with SMTP id f8-20020a05622a1a0800b003b6340bfb29mr61433308qtb.15.1674633354470;
        Tue, 24 Jan 2023 23:55:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDVwkxMfe/xtSrhm+NVGpcvVkFVI2tHJ6Kil61r+JE9vARpW1B0Sdxlz2Zbz7Fgdm0B+8Slg==
X-Received: by 2002:a05:622a:1a08:b0:3b6:340b:fb29 with SMTP id f8-20020a05622a1a0800b003b6340bfb29mr61433289qtb.15.1674633354226;
        Tue, 24 Jan 2023 23:55:54 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m15-20020aed27cf000000b003afbf704c7csm2865980qtg.24.2023.01.24.23.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:55:53 -0800 (PST)
Message-ID: <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>
Date:   Wed, 25 Jan 2023 08:55:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Content-Language: en-US
To:     Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        oliver.upton@linux.dev
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
 <Y9CRxb2YvPtX340D@google.com>
 <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/25/23 05:11, Reiji Watanabe wrote:
> On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
>> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
>>> Hi Ricardo,
>>>
>>> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
>>>> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>
>>>>         pmu_reset_stats();
>>> This isn't directly related to the patch.
>>> But, as bits of pmovsclr_el0 are already set (although interrupts
>>> are disabled), I would think it's good to clear pmovsclr_el0 here.
>>>
>>> Thank you,
>>> Reiji
>>>
>> There's no need in this case as there's this immediately before the
>> pmu_reset_stats();
>>
>>         report(expect_interrupts(0), "no overflow interrupt after counting");
>>
>> so pmovsclr_el0 should be clear.
> In my understanding, it means that no overflow *interrupt* was reported,
> as the interrupt is not enabled yet (pmintenset_el1 is not set).
> But, (as far as I checked the test case,) the both counters should be
> overflowing here. So, pmovsclr_el0 must be 0x3.

I would tend to agree with Reiji.  The PMOVSSET_EL0<idx> will impact the
next test according to aarch64/debug/pmu/AArch64.CheckForPMUOverflow and
I think the overflow reg should be reset.

Eric
>
> Or am I misunderstanding something?
>
> Thank you,
> Reiji
>
>
>>>> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>>> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>>>> +       write_regn_el0(pmevcntr, 0, pre_overflow);
>>>> +       write_regn_el0(pmevcntr, 1, pre_overflow);
>>>>         write_sysreg(ALL_SET, pmintenset_el1);
>>>>         isb();
>>>>

