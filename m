Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D910F5F309B
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 15:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJCNBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 09:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiJCNBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 09:01:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E313641999
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 06:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664802075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRj6bSlUC53GGB5VwGt/QTv7mNL3dMlu/4FM8+Jr3Ho=;
        b=ZW9Bz6RKQOUiGLjcjyrcOF3qz0yD/7Mo8TNGPnZ3X1jJR2iOtaGV+hgni3VvtAy8SYHrGE
        KdbkgnL7BGNDLIKkIqmGHOyr/Kvbgk+LVL/6MMvrHYPTIV6P1tXA+gwYnddO8fMq8PVTxf
        CYU1awks3BSWIbhWHIGY464J8USCI7s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-HeIQlJWAPl-WYcSuGuAn-Q-1; Mon, 03 Oct 2022 09:01:10 -0400
X-MC-Unique: HeIQlJWAPl-WYcSuGuAn-Q-1
Received: by mail-ed1-f69.google.com with SMTP id b17-20020a056402351100b00453b19d9bd0so8647339edd.4
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 06:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=cRj6bSlUC53GGB5VwGt/QTv7mNL3dMlu/4FM8+Jr3Ho=;
        b=BDmFEJWryyuflr3bOhl9ykLZIYxnvB7WgGnrPh6kcpRnRZx3rXSswr07ijwKnBtlBJ
         qfuzT0xcOkz3nmGeVUS2ZgD4eKgc0uVVWNJYkRSTDs/Y3bjaHavPWH0YKNwlaVBG7BPx
         1M1u2e3ZK9M7ZMs7wG4N7oPNqJVzcYTHOl9ZPpU7/V1JjsfV6noMjbgqCyUEHIkHKXVW
         JTZV96Dz5d3lB41PGk83UmRaw0+fF/GZBSLbHHdiNEWFugbfL4GsSOThCDPdMmbsp8Vg
         FU6aTBGu6E7CQYFeXX/Qh93Sf7Nv1LeKF3zi/t9cMk0fq1lvVc6/kNNgqDpFQjZ5V4YA
         rpCg==
X-Gm-Message-State: ACrzQf2cjz7zTwt+77ypqixEnDN8TNgDX8snoynuSOCf2wKzPuCos7iM
        cfoHbxb9MVdUMiTAPTn+ZZM/eraAsDNQ+eqdVSScjWA3sr9qOKi2DuS4iBx510AdKt0n0jepIbS
        WHh3wIdEts7CR
X-Received: by 2002:aa7:d306:0:b0:459:6e9:6284 with SMTP id p6-20020aa7d306000000b0045906e96284mr3362808edq.70.1664802069338;
        Mon, 03 Oct 2022 06:01:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4LhOt7lq8KC+MtSWbuxFBRAsDpLqs6b02Vk7/jD6P80CM9LRWg42h4L75YMKjHN7LJ+v/WZg==
X-Received: by 2002:aa7:d306:0:b0:459:6e9:6284 with SMTP id p6-20020aa7d306000000b0045906e96284mr3362761edq.70.1664802068878;
        Mon, 03 Oct 2022 06:01:08 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m21-20020a50ef15000000b00458bb36042asm4966689eds.1.2022.10.03.06.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 06:01:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 30/39] KVM: selftests: Hyper-V PV TLB flush selftest
In-Reply-To: <YyuVtrpQwZGHs4ez@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-31-vkuznets@redhat.com>
 <YyuVtrpQwZGHs4ez@google.com>
Date:   Mon, 03 Oct 2022 15:01:07 +0200
Message-ID: <87wn9h9i3w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:

...

>> +}
>> +
>> +/* Delay */
>> +static inline void rep_nop(void)
>
> LOL, rep_nop() is a hilariously confusing function name.  "REP NOP" is "PAUSE",
> and for whatever reason the kernel proper use rep_nop() as the function name for
> the wrapper.  My reaction to the MFENCE+rep_nop() below was "how the hell does
> MFENCE+PAUSE guarantee a delay?!?".

Well, at least you got the joke :-)

>
> Anyways, why not do e.g. usleep(1)?  

I was under the impression that all these 'sleep' functions result in a
syscall (and I do see TRIPLE_FAULT when I swap my rep_nop() with usleep())
and here we need to wait in the guest (sender) ...

> And if you really need a udelay() and not a
> usleep(), IMO it's worth adding exactly that instead of throwing NOPs at the CPU.
> E.g. aarch64 KVM selftests already implements udelay(), so adding an x86 variant
> would move us one step closer to being able to use it in common tests.

... so yes, I think we need a delay. The problem with implementing
udelay() is that TSC frequency is unknown. We can get it from kvmclock
but setting up kvmclock pages for all selftests looks like an
overkill. Hyper-V emulation gives us HV_X64_MSR_TSC_FREQUENCY but that's
not generic enough. Alternatively, we can use KVM_GET_TSC_KHZ when
creating a vCPU but we'll need to pass the value to guest code somehow.
AFAIR, we can use CPUID.0x15 and/or MSR_PLATFORM_INFO (0xce) or even
introduce a PV MSR for our purposes -- or am I missing an obvious "easy"
solution?

I'm thinking about being lazy here and implemnting a Hyper-V specific
udelay through HV_X64_MSR_TSC_FREQUENCY (unless you object, of course)
to avoid bloating this series beyond 46 patches it already has.

...

-- 
Vitaly

