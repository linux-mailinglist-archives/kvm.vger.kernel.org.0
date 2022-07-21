Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9857C20B
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 04:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiGUCC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiGUCC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 22:02:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4679876EA9;
        Wed, 20 Jul 2022 19:02:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id l124so427742pfl.8;
        Wed, 20 Jul 2022 19:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HpcRUpj6IiUvvjtSDoaM3wTDrN7fB6SBCqzwQ3NdYug=;
        b=SKrB9hsQsTBjY2hhBm975Cw+42SgVUJYEODjrJBmuYP3nhDd4iQz+WCVXRoBwNXqu9
         4AR8DgHAgY4T65IeZixo1HPFBH6Xh+fqsqI4v8DZ4//U2sWS4zmlDlPIE/xBbYYFao5q
         3cVgZstV9vgukhH1Gz3BPpbJ9OI4Xya5d8WXNe6v7xJ1AnRg02pgLrLxmOma6xGQWJMw
         2zWou9Q66nlXzuWYZbhUYjqYQRFGoHnqcFHJWk1XnrEpIbnaVPLUDztM84yC1ByCWWG6
         1VhkX8yeBV167qpsT9P825UiySUjD8DPQrzDv/exNq1tfJ3Hlm9n0sekqR+G6IZqTz0f
         Oinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HpcRUpj6IiUvvjtSDoaM3wTDrN7fB6SBCqzwQ3NdYug=;
        b=edbBvWcHeFfRIVav47J4PC16cimr2wbbYNX966/XBj/Vp32F0O7Ev/HRZWqee9zmFv
         izwbuv8xnrEBFRW9s3XqE0HaJATnxR3lWuY7rel0mN1E/OLeKvaunn/01kCAGEcRq/x4
         0ZTYoYNBk0eQPahiEfYPJzzyyssA036mtOLiT+mFZY/jv2ofzN9Zlv/nAtMdnNc94xHR
         vQ8EJkXEuxuOgquS1vX5mbANLhX9ekJEplmQdYC3iBVwFq3D7LHxgzW7sMMjweh0fELN
         WbPUz5Ks1QOFGHE2OrUS2ItIjVOzEetYAIxKkOLusrv1gX0tVeS+eFBmxVFpkGInABfO
         tkpw==
X-Gm-Message-State: AJIora8GsjDrpQsOpgTxTeckmhGJZ5gzK8G8x4WIwTtwUVPHOrFGFyQK
        7K/6kuapD+T6B+oz5NWDw8w46Hy27v1pEQ==
X-Google-Smtp-Source: AGRyM1sVHPY1/OZYVWtmwakh8JAAtvQhNlGVzbjZKOnbPHSUXLyeREKlqNnGdAcx9NhDX5TVCq+1Kg==
X-Received: by 2002:a63:111a:0:b0:412:97c3:6907 with SMTP id g26-20020a63111a000000b0041297c36907mr36739521pgl.213.1658368976767;
        Wed, 20 Jul 2022 19:02:56 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14-20020a62d10e000000b005289753448fsm306997pfg.123.2022.07.20.19.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 19:02:56 -0700 (PDT)
Message-ID: <84e1a911-d4f9-8984-a548-62100aafd035@gmail.com>
Date:   Thu, 21 Jul 2022 10:02:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 3/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to
 pmu->host_cross_mapped_mask
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Like Xu <likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
 <20220713122507.29236-4-likexu@tencent.com> <YtihtuxO/uefpAqJ@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YtihtuxO/uefpAqJ@google.com>
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

On 21/7/2022 8:45 am, Sean Christopherson wrote:
> On Wed, Jul 13, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> In the extreme case of host counters multiplexing and contention, the
>> perf_event requested by the guest's pebs counter is not allocated to any
>> actual physical counter, in which case hw.idx is bookkept as -1,
>> resulting in an out-of-bounds access to host_cross_mapped_mask.
>>
>> Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 11 +++++------
>>   1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 53ccba896e77..1588627974fa 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -783,20 +783,19 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>>   void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>>   {
>>   	struct kvm_pmc *pmc = NULL;
>> -	int bit;
>> +	int bit, hw_idx;
>>   
>>   	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
>>   			 X86_PMC_IDX_MAX) {
>>   		pmc = intel_pmc_idx_to_pmc(pmu, bit);
>>   
>>   		if (!pmc || !pmc_speculative_in_use(pmc) ||
>> -		    !intel_pmc_is_enabled(pmc))
>> +		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
>>   			continue;
>>   
>> -		if (pmc->perf_event && pmc->idx != pmc->perf_event->hw.idx) {
>> -			pmu->host_cross_mapped_mask |=
>> -				BIT_ULL(pmc->perf_event->hw.idx);
>> -		}
>> +		hw_idx = pmc->perf_event->hw.idx;
>> +		if (hw_idx != pmc->idx && hw_idx != -1)
> 
> How about "hw_idx > 0" so that KVM is a little less dependent on perf's exact
> behavior?  A comment here would be nice too.

The "hw->idx = 0" means that it occupies counter 0, so this part will look like 
this:

		hw_idx = pmc->perf_event->hw.idx;
		/* make it a little less dependent on perf's exact behavior */
		if (hw_idx != pmc->idx && hw_idx > -1)
			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);

, what do you think ?

> 
>> +			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
>>   	}
>>   }
>>   
>> -- 
>> 2.37.0
>>
