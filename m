Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C159497B18
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 10:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbiAXJLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 04:11:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242436AbiAXJLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 04:11:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643015478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OMYGpin1GmNWwbbojqUVpe990D8pktHZFFcCMALRStg=;
        b=Qxf+qyNbCFwzV0dDYx0RHHaSgsE8BSOZQvwNZNfSoARuSg0oad6ALkFwndvWdyqbFmv5EF
        6mlvDKwFS76vkP4NTQ6QUK5tj3uu5Yx/P0FAWLTf7L637ICetVF7t/2CVJBU+zdmmvcMn2
        vG3/d7qMgnOzUK23cpCV3XWzvsYz25A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-U7imZs39Po6_bFc7qu2M_Q-1; Mon, 24 Jan 2022 04:11:16 -0500
X-MC-Unique: U7imZs39Po6_bFc7qu2M_Q-1
Received: by mail-wr1-f69.google.com with SMTP id b17-20020adfee91000000b001d70ba23156so1591420wro.10
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 01:11:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OMYGpin1GmNWwbbojqUVpe990D8pktHZFFcCMALRStg=;
        b=hqJ/mAGYSSXACgnbS9qjQAn70P1qlqpDpupAfEv1utQ6VJf+g4bHGd81v8vWDaw+q6
         v/EZHtz1AMfrLD8rr7I3ig45u4tgKQuiC55Psa3Y62nBgRbNuWj7T4ZZQQNbM+Xp+vG+
         v6gahqPF0qkb3bOWkbU+W05ynbsxecJDM5xF01rLRFEd4LGHAOx8seWkL0oQVJbocRtA
         nocyr3Y4joI/zCaRClrGYGUYeHxbxz5uNfuL+73OL98wBVjUSWZF3qHgVcKae7AIIHwv
         Z9iOPHjbQ2fXBldN0gtVT8LDEpYvrLPuOd+5DrzBKOlNGARNpuxpnD9q1CxBreD0jd7p
         ZohA==
X-Gm-Message-State: AOAM5330KRq5c4gYlcKP3PH42dJe0Ri2fAIhpyqsA6e/a2dgxIMDVfbv
        YOxwjxle+sVWo2ERnDIWlThf+3j91KcuXON1xxq5GCsrp8M6UJWh1VjyjdGfGe7599rXxs/yZwG
        6aSBFugs7TlROKA6u/wmmD1ek7mYtKYVzOQbDIMigxp/reZYmF0DrzVr5REC68Y+w
X-Received: by 2002:a5d:598a:: with SMTP id n10mr13089727wri.582.1643015475102;
        Mon, 24 Jan 2022 01:11:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhROMhxI51amPelFZSuWBFEYDzDjRJZl5mQ1KWe926i8sMhv1aUBQfdX4YJbP2yysVszrsOQ==
X-Received: by 2002:a5d:598a:: with SMTP id n10mr13089684wri.582.1643015474784;
        Mon, 24 Jan 2022 01:11:14 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v5sm18175419wmh.19.2022.01.24.01.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 01:11:14 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 06/54] x86/kvm: replace bitmap_weight with bitmap_empty
 where appropriate
In-Reply-To: <20220123183925.1052919-7-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-7-yury.norov@gmail.com>
Date:   Mon, 24 Jan 2022 10:11:12 +0100
Message-ID: <87y235ijm7.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yury Norov <yury.norov@gmail.com> writes:

> In some places kvm/hyperv.c code calls bitmap_weight() to check if any bit
> of a given bitmap is set. It's better to use bitmap_empty() in that case
> because bitmap_empty() stops traversing the bitmap as soon as it finds
> first set bit, while bitmap_weight() counts all bits unconditionally.
>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 6e38a7d22e97..2c3400dea4b3 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -90,7 +90,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  {
>  	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
>  	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> -	int auto_eoi_old, auto_eoi_new;
> +	bool auto_eoi_old, auto_eoi_new;
>  
>  	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
>  		return;
> @@ -100,16 +100,16 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  	else
>  		__clear_bit(vector, synic->vec_bitmap);
>  
> -	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +	auto_eoi_old = bitmap_empty(synic->auto_eoi_bitmap, 256);

I would've preferred this written as 

	auto_eoi_old = !bitmap_empty(synic->auto_eoi_bitmap, 256);

so the variable would indicate wether AutoEOI was previosly enabled, not
disabled.

>  
>  	if (synic_has_vector_auto_eoi(synic, vector))
>  		__set_bit(vector, synic->auto_eoi_bitmap);
>  	else
>  		__clear_bit(vector, synic->auto_eoi_bitmap);
>  
> -	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +	auto_eoi_new = bitmap_empty(synic->auto_eoi_bitmap, 256);

Same here, of course. "auto_eoi_new = true" sounds like "AutoEOI is now
enabled".

>  
> -	if (!!auto_eoi_old == !!auto_eoi_new)
> +	if (auto_eoi_old == auto_eoi_new)
>  		return;
>  
>  	down_write(&vcpu->kvm->arch.apicv_update_lock);

The change look good to me otherwise, feel free to add

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

