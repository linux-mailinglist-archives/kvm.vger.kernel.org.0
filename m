Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6104B8B30
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 15:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiBPOOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 09:14:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiBPOOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 09:14:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 231E92604CE
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 06:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645020867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gEbi3XwcZt6Z5i+3i1/6U9JlRePlmr/8q0fC2lCMwd8=;
        b=hxWFZftUeeGoYhqPpdSWVjO//dTrDSZDYzJWJ+3bdGTUQ7u+QpE05Coru+KW7qXChuodom
        m8d45NQ+D7zNcYfQ1jSJje13Gb1RmJoCnM9AXzAU4GZmWWyd71s/1kOY/j9wpftVGv4FXe
        qSFjv9RWncIeQCblbwh/HI/sgYvzBRQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-Egvl--xbPUSxPD4ORXZB9A-1; Wed, 16 Feb 2022 09:14:25 -0500
X-MC-Unique: Egvl--xbPUSxPD4ORXZB9A-1
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so891943ejw.9
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 06:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gEbi3XwcZt6Z5i+3i1/6U9JlRePlmr/8q0fC2lCMwd8=;
        b=h1QShJO7Fa0HcEN1dFWDUlUfR9HwUG8+9Xl3eInitm7BjV9dlEJKFh2KQ1702+CvLN
         cKnaCm7d1M0VNkgvQPMRPFF5jZFp3CpP1t6lemDgRIygOwnevzMiwRze+vozRPowejBu
         751iMTDs4yVmIiOotHNMS5xx6El1jnr3fS2zRAqSMK/QPsc7bWfYqyBqVouNFJl/NFrX
         1leV/mfdlqD6fml4uGj4hlBeBdE2iblAFU8AtsRTT4btUcjm/+Ap10IreMelduQlzBo9
         6kXwQcye9RfyLZWm4YmhknvjPCbu28APFgjZh7cuq+seYu6CWgeOUw59ZJsWg4y4nzHx
         2oxg==
X-Gm-Message-State: AOAM532d47J0FT4z49gEH67bTZcdMeRm74pRpLhcHl2dxWg/Pqc4MaV/
        syoyE14ljONsHnSFWtnmN+ugP9arq5Uq5SRns97YZAkOVczmpnxqWciyo0azB8AMmGaBgnYWl/J
        HUtbhX0gwjqYZ
X-Received: by 2002:a05:6402:201:b0:40f:cff5:6537 with SMTP id t1-20020a056402020100b0040fcff56537mr3318960edv.281.1645020864661;
        Wed, 16 Feb 2022 06:14:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6i/K+R0KR/F3iVz1wLH4zdQ6YKRdux4P+rcGpqeuTKIukNuwp16eJuejz+XWLlCscOHCApQ==
X-Received: by 2002:a05:6402:201:b0:40f:cff5:6537 with SMTP id t1-20020a056402020100b0040fcff56537mr3318938edv.281.1645020864411;
        Wed, 16 Feb 2022 06:14:24 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ed9sm1607592edb.59.2022.02.16.06.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 06:14:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anton Romanov <romanton@google.com>
Cc:     mtosatti@redhat.com, Anton Romanov <romanton@google.com>,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
In-Reply-To: <20220215200116.4022789-1-romanton@google.com>
References: <20220215200116.4022789-1-romanton@google.com>
Date:   Wed, 16 Feb 2022 15:14:22 +0100
Message-ID: <87zgmqq4ox.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anton Romanov <romanton@google.com> writes:

> If vcpu has tsc_always_catchup set each request updates pvclock data.
> KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
> host's side and do hypercall inside pvclock_read_retry loop leading to
> infinite loop in such situation.
>
> v2:
>     Added warn
>
> Signed-off-by: Anton Romanov <romanton@google.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7131d735b1ef..aaafb46a6048 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8945,6 +8945,15 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>  	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
>  		return -KVM_EOPNOTSUPP;
>  
> +	/*
> +	 * When tsc is in permanent catchup mode guests won't be able to use
> +	 * pvclock_read_retry loop to get consistent view of pvclock
> +	 */
> +	if (vcpu->arch.tsc_always_catchup) {
> +		pr_warn_ratelimited("KVM_HC_CLOCK_PAIRING not supported if vcpu is in tsc catchup mode\n");
> +		return -KVM_EOPNOTSUPP;

I'm not sure this warn is a good idea. It is guest triggerable and
'tsc_always_catchup' is not a bug, it is a perfectly valid situation in
the configuration when TSC scaling is unavailable. Even ratelimited,
it's not nice when guests can pollute host's logs.

Also, EOPNOTSUPP makes it sound like the hypercall is unsupported, I'd
suggest changing this to KVM_EFAULT.

> +	}
> +
>  	clock_pairing.sec = ts.tv_sec;
>  	clock_pairing.nsec = ts.tv_nsec;
>  	clock_pairing.tsc = kvm_read_l1_tsc(vcpu, cycle);

-- 
Vitaly

