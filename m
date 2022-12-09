Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7EC647EDB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 08:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLIH7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 02:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLIH7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 02:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646A054775
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 23:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670572720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZ8hUe+wDVfcXZFasPofq++d5JzIKUkQA0LPKASkWts=;
        b=UD4mCOnYTsuIbWY0Sx/u0pBlvmoU0XerfU56k2xyNZz8fms1HkgyQ8PrRSr7r3axVRzIyP
        tHiGDqE75Qhfl2FABg8xAW8SP1zOLtSnDtfK5Qy09Vq0lHqw1fQOcld1EpmAU2Y54GECus
        02HG8iJGOyLajUYmn6iXpA13lUSqiKw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-KxNOdJQ2NmehKYcqbKBeQg-1; Fri, 09 Dec 2022 02:58:38 -0500
X-MC-Unique: KxNOdJQ2NmehKYcqbKBeQg-1
Received: by mail-ej1-f69.google.com with SMTP id sh37-20020a1709076ea500b007c09b177cd1so2592214ejc.12
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 23:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ8hUe+wDVfcXZFasPofq++d5JzIKUkQA0LPKASkWts=;
        b=G/VzDmA8JbyyAAeRBNKEEtVa68F8vYsD8SNjFpTlJkAUno8zKTZN0695UxC6dBBeIG
         Nsg6ItjV/W49I0wYgm7ADELW+XaZPWOvsYINVIluvjUyDh/OwBFt+1rrGkrgRSExs7vK
         C1PRx+dwL6fSDseBFWbKsoESl0WZYWGN6f9/wtA8DQ7hF0xnBmjkIwgHl3pSnXoXpDbr
         azoikB91VcMMpgINURC1bz5DJ2046Ty2Oeh6Kc3rGY4noMo/a6h4jCj3fYx6b6BziMQv
         GqOll9SbK0iEbAnwke0l+F/GuW0XLnJEgOpWzZVnnOl+IaQyQ4n5ZLDRZ2/FlEGamTTU
         qJTA==
X-Gm-Message-State: ANoB5plIGdvBd19E+c7KNCEGzwiOE5vCFVvZSKt4WGrAtAeYfD9IKi0k
        B4+cDJs5SIes70XVs9voVknnCoZgahEGnecOmhEniyA//ZNfY0SzKOYbcSoEGFUPjscqN+5t83v
        JKuy6NplovfWC
X-Received: by 2002:a17:907:9a09:b0:78d:f456:1eb4 with SMTP id kr9-20020a1709079a0900b0078df4561eb4mr4267459ejc.5.1670572717484;
        Thu, 08 Dec 2022 23:58:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6/SRWES9HuWyfYLXZID4ApanvhIB5IAoRnfjhiVRc++E65v/jXuw62NmM58N6WgfuxktObYA==
X-Received: by 2002:a17:907:9a09:b0:78d:f456:1eb4 with SMTP id kr9-20020a1709079a0900b0078df4561eb4mr4267448ejc.5.1670572717233;
        Thu, 08 Dec 2022 23:58:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id sg43-20020a170907a42b00b007be3aa82543sm270823ejc.35.2022.12.08.23.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:58:36 -0800 (PST)
Message-ID: <372a8ea3-6a87-5eb4-0712-ce48e85ba58e@redhat.com>
Date:   Fri, 9 Dec 2022 08:58:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] kvm: x86/mmu: Remove duplicated "be split" in spte.h
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20221207120505.9175-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221207120505.9175-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 13:05, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> "be split be split" -> "be split"
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>   arch/x86/kvm/mmu/spte.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1f03701b943a..6f54dc9409c9 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -363,7 +363,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>    * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
>    *
>    *  1. To intercept writes for dirty logging. KVM write-protects huge pages
> - *     so that they can be split be split down into the dirty logging
> + *     so that they can be split down into the dirty logging
>    *     granularity (4KiB) whenever the guest writes to them. KVM also
>    *     write-protects 4KiB pages so that writes can be recorded in the dirty log
>    *     (e.g. if not using PML). SPTEs are write-protected for dirty logging

Queued, thanks.

Paolo

