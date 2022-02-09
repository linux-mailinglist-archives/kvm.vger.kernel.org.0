Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72E4AED75
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 10:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiBIJCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 04:02:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241264AbiBIJBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 04:01:52 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A665E015664;
        Wed,  9 Feb 2022 01:01:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z13so3183304pfa.3;
        Wed, 09 Feb 2022 01:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=VH+A8xJEaUloO4mKzD8JGvj5AR88+tYefIL2An16MRk=;
        b=WozUnmY9CDhyCgkAKyKhJYFx0T2j9sVRi5iXjd73tjpqESfHLQDC6z7Xv8t5gF7COQ
         fZ/s8/Ltziy/6orG6v/wRObTsbiBW3xK6Rva0y4e1nHx8z5ruj4nqiptU/gBJLPHj25g
         QPwVB93bhVwblFCisEsDkn6zLFKtH9g5yCcTjt324u0IlsNV+1I3A8IF3URtz0IetoJh
         B3SsSKp5l67CZZzp/ZeQ4iPeDJx2Epi2VfdJBD5o5z+HD9QhJmdPMeK7IvgkIIdEbBkC
         2Nj55aOsYN1wOlh3/7typty1qWFPvoDKEf2jcDeDpdTapkmkWUhXzMwxrUIpZXbAFV2q
         Kbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=VH+A8xJEaUloO4mKzD8JGvj5AR88+tYefIL2An16MRk=;
        b=u2hvm+uVptqL5cl7IJXhnXr+kO/rLJHjWy6Me24APlyi45saWiCDfBCiE/KGj3hdLT
         c8s2QGs8pXkqpP0EzIhHgH2DtCMOmMubzIRYp46RmMyofMymKzmHO9S+X4F0AZEtqdzk
         Rgg10dwLjfxnAdInsX0M7iXyNNmykbWcg/2mwRLabXTkTS5aqWu9tPHmWF/5n1s9P3zm
         vjqok3XiuZL27oUCmsiNFv66uNDX4HqMszyMYNsbrdh+GwbLI4XzaCH3c83kdPsXEPvd
         T/ZW1gD+FsiWxdXnpCwvzQq3eA8DTpPeorUWRfvpeDwr6/CFMZLAbenDigDhkXA1Hl6z
         +r4g==
X-Gm-Message-State: AOAM531vd4o8To47ne/3wAY8Z5AGSFfEzW/W/sah+78Pq+C5PytPfBLx
        YfvCMCvXK7f4eC6SD0CtCMg=
X-Google-Smtp-Source: ABdhPJxxXvWNoMxfn7e3rxqaz81krZRXdIaswiGkABfOo7ZtIW61n31Ohr57+0oAIESF347QNNoVrw==
X-Received: by 2002:a63:8849:: with SMTP id l70mr1056522pgd.437.1644397225928;
        Wed, 09 Feb 2022 01:00:25 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mu13sm6107068pjb.28.2022.02.09.01.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 01:00:25 -0800 (PST)
Message-ID: <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
Date:   Wed, 9 Feb 2022 17:00:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/2022 9:55 am, Jim Mattson wrote:
>> +static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
>>   {
>> +       u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> On AMD, the event select is 12 bits.

Out of your carefulness, we already know this fact.

This function to get the perf_hw_id by the last 16 bits still works because we 
currently
do not have a 12-bits-select event defined in the amd_event_mapping[]. The 
12-bits-select
events (if any) will be programed in the type of PERF_TYPE_RAW.

IMO, a minor patch that renames some AMD variables and updates the relevant comments
to avoid misunderstandings is quite acceptable.

Thanks,
Like Xu
