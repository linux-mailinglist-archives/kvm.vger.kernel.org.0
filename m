Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4462643B43
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 03:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiLFCSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 21:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiLFCSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 21:18:31 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A471EC61;
        Mon,  5 Dec 2022 18:18:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so13375846pjo.3;
        Mon, 05 Dec 2022 18:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqqdWtbS1Za0VDsi/rh/cVZ5aKPEWT3hv/yn2eqCqJs=;
        b=AHbf74axBnmD7bSWUpMXudG6pNssGEW5Kzk/eaKwQiSqvdWSchI6V/QyDddcQci9lU
         A9zrDyrg3BCLV43JmaiMBr6rhcsanYz/8YQ4TgWYcaN31Afv1CLfyvtxkVzYmy6/eTWL
         rCBe961Wq/zdsM0HIjxjN3DBLPEgY6juScaW2tFlojZwq2W1FyCpyY/7iVupyh9aVc+U
         fQlMkyFFBf7uL5EGm+0TOwrJYVkyqOk/bnJhMP/vVY/LBFI/DX4T8s2IqoY0DroETGed
         T5g0Er03vQzjFsYSzzYCOpq3NVEDICSHN6DMmcZMwvTUWBwDaG6ZJ+7H2mfzEC10ExEn
         RASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqqdWtbS1Za0VDsi/rh/cVZ5aKPEWT3hv/yn2eqCqJs=;
        b=sL3mMYQlJq15DDywZzuPXtuac6RrBl5zQ8kua6fLw0NH8tsT+vVU3JCIC/Szgm59p2
         qtzW+9WMmdNJX7CrjlnKHVaTmveBm+ior6XEls38rC1AbEbrjrwEqWG9sNCye5m1lODu
         0pTgFZZOXiKC9i3saLVbBwfmqaMVr32spooI8J+hnkz5KQUuyx/JwifS8WMr/JXYVR47
         7bjdC/UrHXzmMXBLQYm4gmqecD9t/6OBIfquS3QIGK8hMuZoUOZTX/G5FEfOl0bdT7Ne
         Os6CW8nDSwusp35DhyREv+izWIPQa8RR1ZUxD+AocXq4tYo1dZZqa7K8aaatFrfPidFr
         KYBA==
X-Gm-Message-State: ANoB5plALKeSHSAptrMuGRCYhdfgL09x2lTQNCY0WlmHYTvV5sS7Mrkk
        SiEU6uPQwLMJaLE/ryXNSX4=
X-Google-Smtp-Source: AA0mqf64GNCDs44HWdx1P1slXStAgamhWcUPiCdLtt05xWzQWtABC5DZSld8WQ66zNP9zXU2r1NqfA==
X-Received: by 2002:a17:903:50c:b0:189:6de9:deb9 with SMTP id jn12-20020a170903050c00b001896de9deb9mr48616384plb.153.1670293108760;
        Mon, 05 Dec 2022 18:18:28 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902a38e00b00189743ed3b6sm11245758pla.64.2022.12.05.18.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:18:28 -0800 (PST)
Message-ID: <38b2a836-f9a4-23e4-107b-61efc74638a4@gmail.com>
Date:   Tue, 6 Dec 2022 10:18:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86/pmu: Avoid ternary operator by directly
 referring to counters->type
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221205113718.1487-1-likexu@tencent.com>
 <Y44gbvm5Zb7a1Sbj@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y44gbvm5Zb7a1Sbj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/12/2022 12:46 am, Sean Christopherson wrote:
> On Mon, Dec 05, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> In either case, the counters will point to fixed or gp pmc array, and
>> taking advantage of the C pointer, it's reasonable to use an almost known
>> mem load operation directly without disturbing the branch predictor.
> 
> The compiler is extremely unlikely to generate a branch for this, e.g. gcc-12 uses
> setne and clang-14 shifts "fixed" by 30.  FWIW, clang is also clever enough to
> use a cmov to load the address of counters, i.e. the happy path will have no taken
> branches for either type of counter.

If so, good news for users of the new tool chain. I assume our Linux project is also
to be commended when it comes to supporting legacy issues even if just a little.

> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index e5cec07ca8d9..28b0a784f6e9 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -142,7 +142,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>>   	}
>>   	if (idx >= num_counters)
>>   		return NULL;
>> -	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
>> +	*mask &= pmu->counter_bitmask[counters->type];
> 
> In terms of readability, I have a slight preference for the current code as I
> don't have to look at counters->type to understand its possible values.
When someone tries to add a new type of pmc type, the code bugs up. And,
this one will make all usage of pmu->counter_bitmask[] more consistent.

Please reconsider this minor diff if it does no harm.
