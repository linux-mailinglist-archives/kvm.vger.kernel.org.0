Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9D57C232
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGUCWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 22:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGUCWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 22:22:31 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91CB753B0;
        Wed, 20 Jul 2022 19:22:30 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r186so372616pgr.2;
        Wed, 20 Jul 2022 19:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4nLuxiwxNWSo6nYVmF5yVIePyzyJgZedSv2mAEqQoU0=;
        b=XGsC8Qj+Vasfdh4AYTuUjqAVu0i6Jw68beIIBCjNEfp1WOKPdNq1d+/xhAlrH67CEe
         uVvdOA88CnT13lTjaam+E7Qaaihs7SPqvmIPNaKSwmg10or8K5cLli2F6pKTSpihbb1E
         8T4l9lg50W8vKFVJL5Fk035sf8wuWMJD9/enKMmvO5c+zmc39Lcy8Uc9r0qEigJeLpU1
         uxK8q7lwH4a0lYy1rkO5xyRO7dbGHcMmY6uB0UEQOiubv1R9EZ6LrkUPgjjhizZ/yjHr
         +CbCvW3MQiETTPiDP3EzG7w1lucyBTBH+rc5GHqIEDZCLa5srQFBnU1nw0shsc1B6bF3
         xOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4nLuxiwxNWSo6nYVmF5yVIePyzyJgZedSv2mAEqQoU0=;
        b=rnwlHG/N2fZpGejsjFYHCetRm+MFgMQ4F2ZTR918O9gUqrekMB11t8pVqurj1/cyYR
         imzwOBcmR4GvPn54g4lgYNmb4LOGHuF181/6xc4PGFih/SB22KspfM/+7xDLlwx3x6Ns
         Ukd/VqIQGP1rKpnZTyuqDMCnID786t+/sIwmUGgaGKV+3MsAtChVrlv7IDr2asdKs82N
         z1OkXEZGK8ObNkyZPvrUcVoyZgpBadJKw9AN/ezOwUrWjJ9aRgp+ySBLK1UMv7PSklCx
         tbE+N8e+PIcNmPbS02WfMO/yJErW8ROIRsaj9OJWVlGTYIPz8+rujnPaLX6rkvfiNah0
         ON8w==
X-Gm-Message-State: AJIora+0u5/W/TwewumlcPvDInszzf9wwWGj1qB5Y/a7UhN5XYqvmdpb
        hdrzw9go33ZFZ8RnCef8sBBtTz+NzKX/ww==
X-Google-Smtp-Source: AGRyM1tTvNe9tf8JnJSMKZmwPrM8GisIkMzBuVY5qL4Ry1vpfCNZfvak0SQ1NTvQf2a78QRXRNV69g==
X-Received: by 2002:a63:1e49:0:b0:3fd:cf48:3694 with SMTP id p9-20020a631e49000000b003fdcf483694mr37308384pgm.275.1658370149785;
        Wed, 20 Jul 2022 19:22:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f34200b0015e8d4eb27esm247824ple.200.2022.07.20.19.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 19:22:29 -0700 (PDT)
Message-ID: <aacf1eb4-26f6-4c62-9c4a-d8249a986c8c@gmail.com>
Date:   Thu, 21 Jul 2022 10:22:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 4/7] KVM: x86/pmu: Not to generate PEBS records for
 emulated instructions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220713122507.29236-1-likexu@tencent.com>
 <20220713122507.29236-5-likexu@tencent.com> <YtijFDufUBR7buyv@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YtijFDufUBR7buyv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/7/2022 8:51 am, Sean Christopherson wrote:
> "Don't" instead of "Not to".  Not is an adverb, not a verb itself.
> 
> On Wed, Jul 13, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> The KVM accumulate an enabeld counter for at least INSTRUCTIONS or
> 
> Probably just "KVM" instead of "the KVM"?
> 
> s/enabeld/enabled

Applied, thanks.

> 
>> BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
>> generating emulated overflow interrupt on counter overflow, which
>> in theory should also happen when the PEBS counter overflows but
>> it currently lacks this part of the underlying support (e.g. through
>> software injection of records in the irq context or a lazy approach).
>>
>> In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
>> dropping one PEBS record) and let the overflow counter move on. The loss
>> of a single sample does not introduce a loss of accuracy, but is easily
>> noticeable for certain specific instructions.
>>
>> This issue is expected to be addressed along with the issue
>> of PEBS cross-mapped counters with a slow-path proposal.
>>
>> Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 02f9e4f245bd..08ee0fed63d5 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -106,9 +106,14 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>>   		return;
>>   
>>   	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
>> -		/* Indicate PEBS overflow PMI to guest. */
>> -		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
>> -					      (unsigned long *)&pmu->global_status);
>> +		if (!in_pmi) {
>> +			/* The emulated instructions does not generate PEBS records. */
> 
> This needs a better comment.  IIUC, it's not that they don't generate records,
> it's that KVM is _choosing_ to not generate records to hack around a different
> bug(s).  If that's true a TODO or FIXME would also be nice.

Indeed, to understand more of the context, this part will look like this:

		if (!in_pmi) {
			/*
			* TODO: KVM is currently _choosing_ to not generate records
			* for emulated instructions, avoiding BUFFER_OVF PMI when
			* there are no records. Strictly speaking, it should be done
			* as well in the right context to improve sampling accuracy.
			*/
			skip_pmi = true;
		} else {
			/* Indicate PEBS overflow PMI to guest. */
			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
						      (unsigned long *)&pmu->global_status);
		}

, what do you think ?

> 
>> +			skip_pmi = true;
>> +		} else {
>> +			/* Indicate PEBS overflow PMI to guest. */
>> +			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
>> +						      (unsigned long *)&pmu->global_status);
>> +		}
>>   	} else {
>>   		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>>   	}
>> -- 
>> 2.37.0
>>
