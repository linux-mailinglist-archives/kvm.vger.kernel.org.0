Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC645284F7
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243697AbiEPNI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 09:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbiEPNI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 09:08:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65E0314025
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652706502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ahj44x/BThs3nBk586YivBZ1J36s03+MALnNDY4lSeY=;
        b=EKlnz8g+Hsj8y7yHt52gB80Rs8B8OcvD8eMnY5DweYnBDrnsDhXGavDBjpHWMccUsgoZ49
        5JbQEKJNp9ImDKzya3xObcsEJX0LCFQOaZD3CUQgyZh6uvNP8SiS5iOe/W5Gk1L0CJlqN0
        7WSEP89XpJynUOK52Q1Lcp7koxrvzyQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-ICs7YOUuNJSizFG21Mo-8g-1; Mon, 16 May 2022 09:08:21 -0400
X-MC-Unique: ICs7YOUuNJSizFG21Mo-8g-1
Received: by mail-wm1-f71.google.com with SMTP id t184-20020a1c46c1000000b00394209f54f1so6746185wma.4
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 06:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ahj44x/BThs3nBk586YivBZ1J36s03+MALnNDY4lSeY=;
        b=ZwkGgKKoI53VHrjx0xmp2JW2w1E/tK2gwGbzIrtqjHljKoHnL4P071tinRxQZSBJVV
         yfdWvRxyW6nc1nLsHpRjpz9/Bg2so46RtuVPGpti2qwXM2R74UWRScm1Qbfgyh6G/x3d
         ob5+Jq7hBJWLC01sGiU3Y/GruvkXJKO5yELANhaHHXbuf852eUfGT99f1uHt2MVfLY+E
         N9oZU34IqpEzttOYgARMQhXHkfg9dRJl77xwBPf54BaFgZTamMRMjcwjTT6ta0/9SZ8b
         i397KPQxqQlueb7H3q2jvEAdbZkGmcGsQDcZsIF8tXs/X8peOnpcI7b3UMi/1JK8ycyK
         ATkw==
X-Gm-Message-State: AOAM533NYYYZQ9w3c0PgyupED9UGpck2v+gHL33Lbyo5l9vsMc/uphGK
        a6+h2g7Hx1ZApE3w+xR54AapZGFiWex0Bww3jWngd8h/P4A2jSguLxX9F7ITGNGRtEiRjH8GGFm
        BrwpcOKBa+Ko5
X-Received: by 2002:a5d:5989:0:b0:20c:582c:d19e with SMTP id n9-20020a5d5989000000b0020c582cd19emr14029837wri.531.1652706499684;
        Mon, 16 May 2022 06:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6fgCRsLAA0WoNr9f2Y5NL1IPlghb5iuei3h19mg6L2QQq793yIMdONSUjNZfKG/8iruVqVg==
X-Received: by 2002:a5d:5989:0:b0:20c:582c:d19e with SMTP id n9-20020a5d5989000000b0020c582cd19emr14029820wri.531.1652706499409;
        Mon, 16 May 2022 06:08:19 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y25-20020a1c4b19000000b0039489e1bbd6sm12852529wma.47.2022.05.16.06.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:08:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/22] KVM: x86: hyper-v: replace bitmap_weight() with
 hweight64()
In-Reply-To: <20220510154750.212913-12-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
 <20220510154750.212913-12-yury.norov@gmail.com>
Date:   Mon, 16 May 2022 15:08:17 +0200
Message-ID: <871qwtwrpa.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yury Norov <yury.norov@gmail.com> writes:

> kvm_hv_flush_tlb() applies bitmap API to a u64 variable valid_bank_mask.
> Since valid_bank_mask has a fixed size, we can use hweight64() and avoid
> excessive bloating.
>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Jim Mattson <jmattson@google.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Wanpeng Li <wanpengli@tencent.com>
> CC: kvm@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: x86@kernel.org
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 41585f0edf1e..b652b856df2b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1855,7 +1855,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		all_cpus = flush_ex.hv_vp_set.format !=
>  			HV_GENERIC_SET_SPARSE_4K;
>  
> -		if (hc->var_cnt != bitmap_weight((unsigned long *)&valid_bank_mask, 64))
> +		if (hc->var_cnt != hweight64(valid_bank_mask))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		if (all_cpus)
> @@ -1956,7 +1956,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
>  		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
>  
> -		if (hc->var_cnt != bitmap_weight(&valid_bank_mask, 64))
> +		if (hc->var_cnt != hweight64(valid_bank_mask))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		if (all_cpus)

(please Cc: me on the whole series next time)

Acked-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

