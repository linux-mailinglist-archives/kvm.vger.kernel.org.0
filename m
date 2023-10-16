Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C447CA7CD
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjJPMPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjJPMPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719C5E8
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697458468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8K0GBMWi7yuOkB+hNB45NjHQ0h2LLEOcT0QD5ygf2F4=;
        b=LXqSiwwj+ZyGwYZ0xzV20R0KfE42NgLTc1zlQY7H1518W/Fl7U+DPXvWZUcetpXmBsYiH+
        /OhRSlWmQc7opVVdGsQnXvwrQc8KHGGGjW19ERJXXGGdk1DYyvTybEYJXioRtfOSE0Ar79
        l0FNtax2dxRKc6tk5l1iFcDNAZgjjEs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-BY0MRc47OVySaVMQzr9AWQ-1; Mon, 16 Oct 2023 08:14:27 -0400
X-MC-Unique: BY0MRc47OVySaVMQzr9AWQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-774292d71e3so515724985a.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697458467; x=1698063267;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8K0GBMWi7yuOkB+hNB45NjHQ0h2LLEOcT0QD5ygf2F4=;
        b=K3wJmBP8ymwv4x298xsHZbq1d+4p+Bc8MTfag22Yg6UuYFI0vjOlWSZH6FZVAYPS+Q
         GUIX67gCBFK1befyucu21V4Iat3IBHAKCwOFS+4Dk9rRquIa9Ynq2Q2pX4cuE7uyv2+q
         u17+FCSisH/lgMLSSO9pufwfKEs/lkj3Cs3I/H6LDOkohZZ0JRKGHP0AedQipQS82vA1
         nGLqh+uZpp3ceb9DnO3wqI9Xk9D66/2746R46oyXXEqpzeHh4j6OI+lcQzaAQosp4oSs
         f8tuWYklrcZjUPNUVux94C06WZhzgkvHUTucpDD6Min91rl1Q6f+Y5DW/mVtmPux/nog
         UgaA==
X-Gm-Message-State: AOJu0YymFo+dczg6evA39gqNM+N3LBhUH9qlpIWw5V4TV/fcZiSkzSqQ
        tK62/6Cr9NZUFOu2XBfFOY/s+E3um9vMutbEymEs300q5y7w4T+5jrGXRIrWlvIhZUjVQ4anwQO
        Uwsvz3gObrkbR
X-Received: by 2002:a05:620a:999:b0:76d:ada0:4c0 with SMTP id x25-20020a05620a099900b0076dada004c0mr31781929qkx.76.1697458466917;
        Mon, 16 Oct 2023 05:14:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX+nJ0hdk4wSNp3IL6EMf+BSUKobIFwfujXQ3r3+l1dNl+KKT4FZ0JEJkvltb3efykENBxnQ==
X-Received: by 2002:a05:620a:999:b0:76d:ada0:4c0 with SMTP id x25-20020a05620a099900b0076dada004c0mr31781918qkx.76.1697458466621;
        Mon, 16 Oct 2023 05:14:26 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id d4-20020a05620a166400b0077568327b54sm2930591qko.123.2023.10.16.05.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:14:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, graf@amazon.de, rkagan@amazon.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Don't auto-enable stimer during
 deserialization
In-Reply-To: <20231016095217.37574-1-nsaenz@amazon.com>
References: <20231016095217.37574-1-nsaenz@amazon.com>
Date:   Mon, 16 Oct 2023 14:14:22 +0200
Message-ID: <87sf6a9335.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nicolas Saenz Julienne <nsaenz@amazon.com> writes:

> By not honoring the 'stimer->config.enable' state during stimer
> deserialization we might introduce spurious timer interrupts. For
> example through the following events:
>  - The stimer is configured in auto-enable mode.
>  - The stimer's count is set and the timer enabled.
>  - The stimer expires, an interrupt is injected.
>  - We live migrate the VM.
>  - The stimer config and count are deserialized, auto-enable is ON, the
>    stimer is re-enabled.
>  - The stimer expires right away, and injects an unwarranted interrupt.
>
> So let's not change the stimer's enable state if the MSR write comes
> from user-space.
>
> Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 7c2dac6824e2..9f1deb6aa131 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -729,7 +729,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
>  	stimer->count = count;
>  	if (stimer->count == 0)
>  		stimer->config.enable = 0;

Can this branch be problematic too? E.g. if STIMER[X]_CONFIG is
deserialized after STIMER[X]_COUNT we may erroneously reset 'enable' to
0, right? In fact, when MSRs are ordered like this:

#define HV_X64_MSR_STIMER0_CONFIG		0x400000B0
#define HV_X64_MSR_STIMER0_COUNT		0x400000B1

I would guess that we always de-serialize 'config' first. With
auto-enable, the timer will get enabled when writing 'count' but what
happens in other cases?

Maybe the whole block needs to go under 'if (!host)' instead?

> -	else if (stimer->config.auto_enable)
> +	else if (stimer->config.auto_enable && !host)
>  		stimer->config.enable = 1;
>  
>  	if (stimer->config.enable)

-- 
Vitaly

