Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0954E71F16A
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjFASMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjFASMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:12:07 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDD2193
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:11:57 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-7749d87d4c1so14458639f.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685643117; x=1688235117;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R4T1JvKYdXUG0M9VKGWPyetHCz5K4cQ6Vex1zPHrz5M=;
        b=xTEAJr2gGDRcrdhFPBqsuxj0Txo6aMBQc+10FLcf2hcXe7LCUCcSYV2aHP2J/IIUpk
         wO9Q6y0jR134eSEcMxpfpKIAtLaqj37izLnVZOOos5LzyG9hO0ms3u98OY63A1S57/kL
         iyFe1Os5W8PY9dCOyXHdWwlI+WK38hJ2SddZNLykb2+v+5RqIUXTioSweM9lEvj/wYcN
         iZVDH3AcMYrMf6fpyABSqQ4KifNRi1XvvmUiOY6IRGiircbdPccZfs1eFG6XH+l+RTiO
         z53CGz+TC/j3hS8guoRiiQIA37xU4qyF9Xihmik1BuINUawxpAoWJ+Dnr0Vchwyujzb/
         EhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685643117; x=1688235117;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4T1JvKYdXUG0M9VKGWPyetHCz5K4cQ6Vex1zPHrz5M=;
        b=QPV6jusgrcsMJW2CQieoXEBwHXyBU6aJIMRqIsrhCT4nBnn3dnrGflKHGT65VXkGAX
         uXrMgdTGyyc0+t7qMaNR4jXHbBjWYhV8fvWquTJUAPl0mLJCsovEj0BaJlaAMEuFxNkz
         7PklSqBB9xx/StleuCGO+OtauK2kHux1eI3+nQ2rJhs6KodLPpsNzbBDiQPy46bcqJZQ
         iYll9SSZJ3v5PDB24Ao4415v1nmy9jHUpp57t/dYPZAPQdTZqeBBQ5MGBt9Q9WjdmS9R
         eBlAT6r+1IknGATcQnfU+n7I8X5s8gtF+09gBI/QKoZLeS61BXlyMYgxxQmsB9hGXvy2
         S3/Q==
X-Gm-Message-State: AC+VfDxmITYdrrcs6fwMP4Yv2iXmV5p9XOSlGcd5sDP8hsn/QZnFPbvk
        fUx5oCcF0zQeFLbXbTfmy2pTnEFAJpJSUhnXTw==
X-Google-Smtp-Source: ACHHUZ6qJkg0oz9NqS+YLL+drYQafayMo0G3iVV5Jqxoh7+8aaChcnZ393QPxxaTAklCGnGNgw3T77DOEt3N7AHQUg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1103:b0:41a:c455:f4c1 with
 SMTP id n3-20020a056638110300b0041ac455f4c1mr3926722jal.4.1685643117230; Thu,
 01 Jun 2023 11:11:57 -0700 (PDT)
Date:   Thu, 01 Jun 2023 18:11:56 +0000
In-Reply-To: <ZHe0okW8G7Z2GrwV@google.com> (message from Sean Christopherson
 on Wed, 31 May 2023 13:57:06 -0700)
Mime-Version: 1.0
Message-ID: <gsnt4jnraw7n.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        andrew.jones@linux.dev, maz@kernel.org, bgardon@google.com,
        ricarkol@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for looking at this again. I'm glad to know there is still
interest in upstreaming it. It fell off my radar and other things took
priority.

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 27, 2023, Colton Lewis wrote:
>> +uint64_t cycles_read(void);

> I would prefer something like get_system_counter() or  
> read_system_counter()
> Pairing "read" after "cycles" can be read (lol) in past tense or current  
> tense,
> e.g. "the number of cycles that were read" versus "read the current  
> number of
> cycles".  I used guest_system_counter_read() in an example in v1[*], but  
> that was
> just me copy+pasting from the patch.

> And "cycles" is typically used to describe latency and elapsed time, e.g.  
> doing

> 	uint64_t time = cycles_to_ns(cycles_read());

> looks valid at a glance, e.g. "convert that number of cycles that were  
> read into
> nanoseconds", but is nonsensical in most cases because it's current  
> tense, and
> there's no baseline time.

> Sorry for not bringing this up in v2, I think I only looked at the  
> implementation.

> [*] https://lore.kernel.org/kvm/Y9LPhs1BgBA4+kBY@google.com

I'll change to get_system_counter_ordered() as Oliver suggests.

>> +uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
>> +{
>> +	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");
>> +	return cycles * NSEC_PER_SEC / timer_get_cntfrq();
>> +}
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c  
>> b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> index ae1e573d94ce..adef76bebff3 100644
>> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> @@ -1270,3 +1270,16 @@ void kvm_selftest_arch_init(void)
>>   	host_cpu_is_intel = this_cpu_is_intel();
>>   	host_cpu_is_amd = this_cpu_is_amd();
>>   }
>> +
>> +uint64_t cycles_read(void)
>> +{
>> +	return rdtsc();
>> +}
>> +
>> +uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
>> +{
>> +	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
>> +
>> +	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");

> Is it possible to calculate this programatically instead of hardcoding a  
> magic
> number?

It is. Unsure why I didn't do it before.
