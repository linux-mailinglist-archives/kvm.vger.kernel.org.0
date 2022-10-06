Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530415F630D
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiJFIuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiJFIt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 04:49:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE55A11441
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665046193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zwlGzTPZfCZ8fk+Fm4Z0zxdAoqVZ4NMoUsnntY3LkAI=;
        b=guv+bG+oAuM67QERvXJWPA1XJ58g/XMzWIwvu5izVBm5weew9YxriRzAYUk2MaKPGxw7KL
        aebtp1yFQsdND4wEkJp9PPqWfi1QTQ2FgQ/w3RQ0TQzSMzSUfzATWAzfOFRncNJErOZWmp
        U1T8om+BMv+f38fEgyCOyduFwfcHFn0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-u0zoDwasP6egvEIlSkKyGg-1; Thu, 06 Oct 2022 04:49:52 -0400
X-MC-Unique: u0zoDwasP6egvEIlSkKyGg-1
Received: by mail-wr1-f71.google.com with SMTP id l6-20020adfa386000000b0022e6b57045bso263806wrb.20
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 01:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=zwlGzTPZfCZ8fk+Fm4Z0zxdAoqVZ4NMoUsnntY3LkAI=;
        b=mbvRnyvF7mxCZCpy7pbsOJDGmpQ15a63lRj1h8BWXOz/QkMkNv/YpbwLzbj50w41eE
         AZEemO4OP9Srp0KMVmxjzbPCwyNEFQCHe+YXEsFug8NWbSirF7lwgEFbURtJeRzq3PSS
         kY8nG240RykXetdBbnpM9DUG07sIefj0TNpVnkzONn0Mw6XCxueHbLKUWSKOb+t3VC1i
         3lKWPWZEm1HPzeVr4q4m5RhP6nR1d9yahrTUv6NQvwToKJEXp6lpodV4fs1QEq8RPAHe
         cdk3Wha/gjhH440MsKwH3a9USF/IMvWwlEzTdSsnFDJqo45xqnHWa1s4NDpSl1UeIOBG
         g6Ng==
X-Gm-Message-State: ACrzQf0M9LvBEKmd2msOy4q8fh3b5RNDeztfedXIsb+9p5oeAwzQIMJt
        2kBhnQ+dXvaB5zXIsqGO3lNd6mvOWVyWlFgx9b09W6qnbk7HesL8ApmEgekvx5U2JA+ZKBFtIP2
        NReY0Z3JH1xJ/
X-Received: by 2002:a05:600c:793:b0:3bf:816b:144e with SMTP id z19-20020a05600c079300b003bf816b144emr4162946wmo.148.1665046191118;
        Thu, 06 Oct 2022 01:49:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6FNsBzjNm5Frdr12LipFXgXTJmJo2XYC8UmfXt0gnOugwiLVnxQisbLuMmcfiivmVGHVDZbQ==
X-Received: by 2002:a05:600c:793:b0:3bf:816b:144e with SMTP id z19-20020a05600c079300b003bf816b144emr4162935wmo.148.1665046190762;
        Thu, 06 Oct 2022 01:49:50 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b003a319b67f64sm13242306wms.0.2022.10.06.01.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 01:49:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
        Shujun Xue <shujunxue@google.com>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        sunilmut@microsoft.com, tianyu.lan@microsoft.com
Subject: Re: HvExtCallQueryCapabilities and HvExtCallGetBootZeroedMemory
 implementation in KVM for Windows guest
In-Reply-To: <CAHVum0cbWBXUnJ4s32Yn=TfPXLypv_RRT6LmA_QoBHw3Y+kA7w@mail.gmail.com>
References: <CAHVum0cbWBXUnJ4s32Yn=TfPXLypv_RRT6LmA_QoBHw3Y+kA7w@mail.gmail.com>
Date:   Thu, 06 Oct 2022 10:49:49 +0200
Message-ID: <877d1d9w0i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> Hi Vitaly, Yury, Sunil, Tianyu

Hi Vipin!

>
> Before I work on a patch series and send it out to the KVM mailing
> list, I wanted to check with you a potential Windows VM optimization
> and see if you have worked on it or if you know about some obvious
> known blockers regarding this feature.
>
> Hypervisor Top-Level Functional Specification v6.0b mentions a hypercall:
>
>     HvExtCallGetBootZeroedMemory
>     Call Code = 0x8002
>
> This hypercall can be used by Windows guest to know which pages are
> already zeroed and then guest can avoid zeroing them again during the
> boot, resulting in Windows VM faster boot time and less memory usage.
>
> KVM currently doesn't implement this feature. I am thinking of
> implementing it, here is a rough code flow:
> 1. KVM will set bit 20 in EBX of CPUID leaf 0x40000003 to let the
> Windows guest know that it can use the extended hypercall interface.
> 2. Guest during the boot will use hypercall HvExtCallQueryCapabilities
> (Call Code = 0x8001) to see which extended calls are available.
> 3. KVM will respond to guest that the hypercall
> HvExtCallGetBootZeroedMemory is available.
> 4. Guest will issue the hypercall HvExtCallGetBootZeroedMemory to know
> which pages are zeroed.
> 5. KVM or userspace VMM will respond with GPA and page count to guest.

I think it's VMM's responsibility. How would KVM know if the memory
allocated to the guest was zeroed or not?

The easiest solution would be to just pass through this hypercall to the
VMM and let it respond. Alternatively, we can probably add a flag to
KVM_SET_USER_MEMORY_REGION to either indicate that the memory is zeroed
or to actually ask KVM to zero it. This way we will have the required
information in KVM. I'm not sure if it's worth it, Windows probably
calls HvExtCallGetBootZeroedMemory just once upon boot so handling it in
the VMM is totally fine.

> 6. Guest will skip zeroing these pages, resulting in faster boot and
> less memory utilization of guest.
>
> This seems like a very easy win for KVM to increase Windows guest boot
> performance but I am not sure if I am overlooking something. If you
> are aware of any potential side effects of enabling these hypercalls
> or some other issue I am not thinking about please let me know,
> otherwise, I can start working on this feature and send RFC patches to
> the mailing list.

I dug through my git archives and found that I've actually tried
HvExtCallQueryCapabilities back in 2018 but for some reason Windows
versions I was testing didn't use it (hope it wasn't some silly mistake
like forgotten CPUID bit on my part :-) so I put it aside and never got
back to it. Thanks for picking this up!

-- 
Vitaly

