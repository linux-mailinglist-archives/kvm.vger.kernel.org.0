Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9151D2BD
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 10:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389800AbiEFIDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 04:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380568AbiEFIDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 04:03:36 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3690C67D0A
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 00:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651823993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bsgg9zj8toPMa6RKQ+ORrZfT23tgfI9A1Wk3qhWVRNA=;
        b=XlCGUC4TTw76GR7BYhKQsJBmhurnFnr5FoMQr9T0OxMaSQQBMl6W/XHgJTC6XNYsBVS6Jb
        WDDM8tvGy7+aisa+b/vLCd5ro8S73Go5+ZTf5AN5/JZqQNAJjnWA+huNFmhQXMMdSuA/Sq
        0wUWaSrbA2H3UThp97R2mzuwrlqfAlk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-z5dk4ChDOAC6jWDHnz1o8A-1; Fri, 06 May 2022 03:59:52 -0400
X-MC-Unique: z5dk4ChDOAC6jWDHnz1o8A-1
Received: by mail-wm1-f69.google.com with SMTP id h65-20020a1c2144000000b0038e9ce3b29cso5773264wmh.2
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 00:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Bsgg9zj8toPMa6RKQ+ORrZfT23tgfI9A1Wk3qhWVRNA=;
        b=Psdp8Pchbrbh3lIcyGRAyZ8wiU5uG9t5zjKg9MQ7Aq9dDSvLMU3FEMd8MmANxexS3c
         qlRf0ldt8NBfZm2gtTk/zX0R51H/Kops5beAWJW5lagWLzhspWUs4xT9ctflBtAcOPQW
         HVTekuSBgRKIDf5SWAHk8o1S2NAr4d0MQyCuVi9gBYIM7KFmbRKoQnx0RYhqvQS13A+N
         XaP4kyPTqXUrTSP4jIpfbM+5ck3/cl8sR2MrilHomyMxiLjpNeABX0lZccT99OnG/8XU
         duzPrvYYXUtFrNSyBcg9QB/PkyDZNVhNxKF5jtJKxGxQoAsyKUEANpNhTJakBTDB8z5C
         Zf2w==
X-Gm-Message-State: AOAM533DNpQme3qDQBMnkL14KmXqZkPySW1v3XC5m+UW+mPk8k0+ShXU
        K5MFDXbrfET8oGHMcpSdVKXo1zZz+0UCJT+iGWFXRDFj9WHVNJ6amR6k2hWucKa2u9RHg3/y3fo
        3acgdZAkcrprJ
X-Received: by 2002:a05:600c:3b24:b0:394:7b59:dfd9 with SMTP id m36-20020a05600c3b2400b003947b59dfd9mr1359819wms.129.1651823991021;
        Fri, 06 May 2022 00:59:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE1zgbkAlfK8+e30cJb3x2oDGpjUVAOHA5fFkoYMNd+DSJwuYDvkBAtVzD6ils1TWxuYqTZg==
X-Received: by 2002:a05:600c:3b24:b0:394:7b59:dfd9 with SMTP id m36-20020a05600c3b2400b003947b59dfd9mr1359793wms.129.1651823990799;
        Fri, 06 May 2022 00:59:50 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w8-20020a1cf608000000b003942a244ed0sm3414488wmc.21.2022.05.06.00.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 00:59:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86: The return type of the function could be void
In-Reply-To: <20220506042105.6245-1-kunyu@nfschina.com>
References: <20220506042105.6245-1-kunyu@nfschina.com>
Date:   Fri, 06 May 2022 09:59:49 +0200
Message-ID: <87v8ujytu2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li kunyu <kunyu@nfschina.com> writes:

> Perhaps the return value of the function is not used.
> It may be possible to optimize the execution instructions.
>
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  arch/x86/kvm/hyperv.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 46f9dfb60469..64c0d1f54258 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -608,7 +608,7 @@ static enum hrtimer_restart stimer_timer_callback(struct hrtimer *timer)
>   * a) stimer->count is not equal to 0
>   * b) stimer->config has HV_STIMER_ENABLE flag
>   */
> -static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
> +static void stimer_start(struct kvm_vcpu_hv_stimer *stimer)
>  {
>  	u64 time_now;
>  	ktime_t ktime_now;
> @@ -638,7 +638,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
>  			      ktime_add_ns(ktime_now,
>  					   100 * (stimer->exp_time - time_now)),
>  			      HRTIMER_MODE_ABS);
> -		return 0;
> +		return;
>  	}
>  	stimer->exp_time = stimer->count;
>  	if (time_now >= stimer->count) {
> @@ -649,7 +649,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
>  		 * the past, it will expire immediately."
>  		 */
>  		stimer_mark_pending(stimer, false);
> -		return 0;
> +		return;
>  	}
>  
>  	trace_kvm_hv_stimer_start_one_shot(hv_stimer_to_vcpu(stimer)->vcpu_id,
> @@ -659,7 +659,6 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
>  	hrtimer_start(&stimer->timer,
>  		      ktime_add_ns(ktime_now, 100 * (stimer->count - time_now)),
>  		      HRTIMER_MODE_ABS);
> -	return 0;
>  }
>  
>  static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,

stimer_start() has only one user so it'll likely get inlined by the
compiler which then will be able to figure out that the return value is
not used and thus the assembley code will likely remain the same but
this is a good cleanup nevertheless, so 

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

