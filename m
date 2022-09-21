Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC4E5BF8DB
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIUISr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 04:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiIUISR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 04:18:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8094C7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 01:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663748279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UB796Vt6XXX5oZ6lyqB/fr2UDx3FHm5YRogO/KgZ0Gc=;
        b=HrRX5pb0Oc0FJcA85XsTiFAxxXtg3CJukv+7kBiY/BVpTewXHf0+aBI4+yKzSkmR4EaIiP
        EW8vnqHLCjMHbGh8H91c/v7MetrlQX30xL8KIv59+mrpZghx/bffLqOlofUkI19CVFeVmq
        +YSJCFusdQ5dFjE9QT41cYrhUcfDuxM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-C0QKILOPO2yT30v7mySuxA-1; Wed, 21 Sep 2022 04:17:56 -0400
X-MC-Unique: C0QKILOPO2yT30v7mySuxA-1
Received: by mail-wm1-f69.google.com with SMTP id 84-20020a1c0257000000b003b4be28d7e3so938527wmc.0
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 01:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=UB796Vt6XXX5oZ6lyqB/fr2UDx3FHm5YRogO/KgZ0Gc=;
        b=5CK6PhN1eQbJTCrEx4PMcUM4ztf/WKbMD2s0k9dmJggLV/QaiUyXnzk1hHq020MW0Z
         uP5qptp+VFYlzrwfnj2nCSCXx/fjeMqtHcNfYdZYW/P+Cxz9QOrFWdGy++zxtGtNvo3N
         xAJV/30r+wolbcPSDUmYSVC7hqZdbcMejYyakVtyAWeZcQjqIYsG2mgh4a3tnKH12trY
         L/FKgcpJIz1lER8v3JDbp02ThkArNc8pVzA1oxFbOpZXN073q/KhzbjkHlk2UvMA2U0l
         17xXKhH8u3AfWDZPD3QvNyJK0fsXhAy0+OdMT2v/1sZ2pn/0yeDD/uQ0FDLtAweOxChk
         A+NQ==
X-Gm-Message-State: ACrzQf3YLy8muwWX4ekdlCU88McFBvcg2iQALWUBolafRG86AWFCTTlF
        cdQNps7AWKU2a4+5rt9TQCLxnx+Ygmk11oE8fjLDPWPvWNOWZgzVv8GTxLVUpNqlfDvAm3igMtr
        9KCsuTR9zWkoP
X-Received: by 2002:a5d:4444:0:b0:22a:2a64:a0fd with SMTP id x4-20020a5d4444000000b0022a2a64a0fdmr16661955wrr.293.1663748275627;
        Wed, 21 Sep 2022 01:17:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM43v7wWRoXSXV6v4Az3dSj1S/kPw0MIiHrhTuij8Z+2yQa1grcSowSXQ8ZmRtHUuPrI50y4HQ==
X-Received: by 2002:a5d:4444:0:b0:22a:2a64:a0fd with SMTP id x4-20020a5d4444000000b0022a2a64a0fdmr16661948wrr.293.1663748275362;
        Wed, 21 Sep 2022 01:17:55 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i15-20020adfaacf000000b00228df23bd51sm1767242wrc.82.2022.09.21.01.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 01:17:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] KVM: x86: Introduce CPUID_8000_0007_EDX
 'scattered' leaf
In-Reply-To: <YypEReJYrI0c7Oii@google.com>
References: <20220916135205.3185973-1-vkuznets@redhat.com>
 <20220916135205.3185973-3-vkuznets@redhat.com>
 <YypEReJYrI0c7Oii@google.com>
Date:   Wed, 21 Sep 2022 10:17:53 +0200
Message-ID: <8735clp2dq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Sep 16, 2022, Vitaly Kuznetsov wrote:
>> CPUID_8000_0007_EDX may come handy when X86_FEATURE_CONSTANT_TSC
>> needs to be checked.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/cpuid.c         | 4 ++++
>>  arch/x86/kvm/reverse_cpuid.h | 9 ++++++++-
>>  2 files changed, 12 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 75dcf7a72605..f68b14053c9b 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -669,6 +669,10 @@ void kvm_set_cpu_caps(void)
>>  	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
>>  		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
>>  
>> +	kvm_cpu_cap_init_scattered(CPUID_8000_0007_EDX,
>> +		SF(CONSTANT_TSC)
>> +	);
>
> The scattered leaf needs to be used in __do_cpuid_func(), e.g.
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ffdc28684cb7..c91f23bb3605 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1137,8 +1137,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 /* L2 cache and TLB: pass through host info. */
>                 break;
>         case 0x80000007: /* Advanced power management */
> -               /* invariant TSC is CPUID.80000007H:EDX[8] */
> -               entry->edx &= (1 << 8);
> +               cpuid_entry_override(entry, CPUID_8000_0007_EDX);
> +

Ah, missed that part! Will add.

>                 /* mask against host */
>                 entry->edx &= boot_cpu_data.x86_power;
>                 entry->eax = entry->ebx = entry->ecx = 0;
>

-- 
Vitaly

