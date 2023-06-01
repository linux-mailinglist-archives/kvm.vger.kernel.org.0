Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05BE71F16D
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjFASMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjFASMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:12:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38E518C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:12:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb76a9831so1558608276.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685643159; x=1688235159;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MHaT38Ml3cwIOy+2qf/ZTjiveJA4q7odFZTUFNS32xE=;
        b=CWk8MWdC1DxbBWCfBs9YC7yghqlA0rbJYDdE41uOgPQfEpR/gxHckuuimZkchO0Gz4
         RSAmkuhVsLpxnTen5r+ACQL5bwmK0gEs/F9nf1SZC2WxEMNPwY3LwZO3GH8k0PYGuGlJ
         C/s5jP5E4UOoDyb7hkWfNc+Xe1raRtPWU4sN/oDf+//9cBFbjHUuWI1NMFdkmPfh7ND9
         n4DhfKEp+g/H6G9GdY5RnLEqURzHM29772sA/D75SY91qbx7X2TUF2YPfawUz8gO0/XB
         zIvtziRgRT6J2LQ+JjI7qobOWm3x9jvkO+Ch9NY6dY9uAcy1CU7RD7zY58/v9kOp2zix
         pBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685643159; x=1688235159;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHaT38Ml3cwIOy+2qf/ZTjiveJA4q7odFZTUFNS32xE=;
        b=YwcuvPcVV+ApU8oT+U9JmamxqG34UR9Er5wJCac1X1zo+MeMKMfqMDvnGBiA6Q8S/J
         DD62XjzCRgtABS6k+AiRsKRWcgCx5Wkjeh7ygy36iSGCcII/KFB1HTDnhfvoUkjBRcRd
         9a3h9B3WutCnRtzmikXW5nL+tlHcZv2BzMsgiE/Q72U/c3zYhKxhVTWEdEvwzReCSfb1
         7ZkD0eGEcRYDTAmo29OHXGSRaBTWCWAzRnsNq3GmnjIQq8hYtU7C+KbYlYdF/nQFMxex
         YSJd99YmN1dteBzPH1SJbBWzDwB7kuYpfP50UeU5XchBcbNkM38s7zMo/u+AZLEUlM6g
         kKHQ==
X-Gm-Message-State: AC+VfDwb+MpAoXDgyWwB5A9hfjt5Nog9jzOdBKFbDnQPBgwEDDpuuZ1I
        3sGCF1tCA4Y/nKSNgvwCzdAg3Wqbg3Hk5nef3g==
X-Google-Smtp-Source: ACHHUZ6Kv/DazmgRmhRXHmlS+YDvbnSNwLJJai219AtpJkpJn0UOh45lXqWZD+obGmEt2GiBgtyp/fhP2v4kzkng/Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:ac11:0:b0:bac:7086:c9b2 with SMTP
 id w17-20020a25ac11000000b00bac7086c9b2mr307864ybi.12.1685643159188; Thu, 01
 Jun 2023 11:12:39 -0700 (PDT)
Date:   Thu, 01 Jun 2023 18:12:38 +0000
In-Reply-To: <ZHgx7GpYNoF/Go8O@linux.dev> (message from Oliver Upton on Thu, 1
 Jun 2023 05:51:40 +0000)
Mime-Version: 1.0
Message-ID: <gsnt353baw6h.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        vipinsh@google.com, andrew.jones@linux.dev, maz@kernel.org,
        bgardon@google.com, ricarkol@google.com, kvm@vger.kernel.org
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

Oliver Upton <oliver.upton@linux.dev> writes:

> On Wed, May 31, 2023 at 02:01:52PM -0700, Sean Christopherson wrote:
>> On Mon, Mar 27, 2023, Colton Lewis wrote:
>> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h  
>> b/tools/testing/selftests/kvm/include/aarch64/processor.h
>> > index f65e491763e0..d441f485e9c6 100644
>> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
>> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
>> > @@ -219,4 +219,14 @@ uint32_t guest_get_vcpuid(void);
>> >  uint64_t cycles_read(void);
>> >  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
>> >
>> > +#define MEASURE_CYCLES(x)			\
>> > +	({					\
>> > +		uint64_t start;			\
>> > +		start = cycles_read();		\
>> > +		isb();				\

>> Would it make sense to put the necessary barriers inside the  
>> cycles_read() (or
>> whatever we end up calling it)?  Or does that not make sense on ARM?

> +1. Additionally, the function should have a name that implies ordering,
> like read_system_counter_ordered() or similar.

cycles_read() is currently a wrapper for timer_get_cntct(), which has
an isb() at the beginning but not the end. I think it would make more
sense to add the barrier there if there is no objection.

>> > +		x;				\
>> > +		dsb(nsh);			\

> I assume you're doing this because you want to wait for outstanding
> loads and stores to complete due to 'x', right?

Correct.

> My knee-jerk reaction was that you could just do an mb() and share the
> implementation between arches, but it would seem the tools/ flavor of
> the barrier demotes to a DMB because... reasons.

Yep, and what I read from the ARM manual says it has to be DSB.

>> > +		cycles_read() - start;		\
>> > +	})
>> > +
>> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
>> ...

>> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h  
>> b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> > index 5d977f95d5f5..7352e02db4ee 100644
>> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> > @@ -1137,4 +1137,14 @@ void virt_map_level(struct kvm_vm *vm, uint64_t  
>> vaddr, uint64_t paddr,
>> >  uint64_t cycles_read(void);
>> >  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
>> >
>> > +#define MEASURE_CYCLES(x)			\
>> > +	({					\
>> > +		uint64_t start;			\
>> > +		start = cycles_read();		\
>> > +		asm volatile("mfence");		\

>> This is incorrect as placing the barrier after the RDTSC allows the  
>> RDTSC to be
>> executed before earlier loads, e.g. could measure memory accesses from  
>> whatever
>> was before MEASURE_CYCLES().  And per the kernel's rdtsc_ordered(), it  
>> sounds like
>> RDTSC can only be hoisted before prior loads, i.e. will be ordered with  
>> respect
>> to future loads and stores.

Interesting, so I will swap the fence and the cycles_read()


> Same thing goes for the arm64 variant of the function... You want to
> insert an isb() immediately _before_ you read the counter register to
> avoid speculation.

That's taken care of. See my earlier comment about timer_get_cntct()
