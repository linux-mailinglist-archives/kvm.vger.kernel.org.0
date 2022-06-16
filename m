Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2964D54E588
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377712AbiFPPAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377598AbiFPPAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E3AE3DDC9
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655391634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXxXlYnYhCGpc7S9VveQqavZUJPHiAJ+eb7im3bQ2A8=;
        b=SuQOtzEkr1UWibdnzFXKFX1RmtOAkFyNz6TFLtB7mg30t3HBG4eeLRGc3i5uMpf/w8sCMQ
        vsJdVWDhu8uEZmGsQE5EHiOprRfZg7aFM9qGTbdvEu33pzyYyQtjYqILRvCXCVnHv/rR8x
        ygwRwzC+xvoWlsNqPOC4ZVbtT1hS0Wc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-iAJn7tvHPpa1OpXetZ9h5A-1; Thu, 16 Jun 2022 11:00:25 -0400
X-MC-Unique: iAJn7tvHPpa1OpXetZ9h5A-1
Received: by mail-ed1-f69.google.com with SMTP id v7-20020a056402348700b004351fb80abaso1428072edc.14
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sXxXlYnYhCGpc7S9VveQqavZUJPHiAJ+eb7im3bQ2A8=;
        b=mT5rTlMSUq09jwlXZx7FCsLIZUxIfN2HOTW9vb6bnCTnb70AttC5edDxRZ/kQ9r2vz
         9T6GrHkz8YUFXrzXAo+DuZP2+OQOH3034Ltc9+Dn9PvvZnHPdBeWEdooWBXXEgzmqHgr
         tLqBCsVM+2isdqZnHrlR+IOz3Cqskz5G8NTTWCgeeO69WS0lYuq7iKJciUMPRvg4iJnj
         GBHby8ZwWLKm2UiN+Scb5hJdC/x6jQn4k0sPHvcbyxpH2lj+iCJgBl+IzVV3a+VzW1Do
         fFLzuaIqizTStIgO8Ge6iBHVjchVnvn+DcTqPxkOohhXF3HTiB/uYeRTnpV6GtYhq/R3
         NJ4A==
X-Gm-Message-State: AJIora9cHnvnlIIsFzXpXuIN8fOFJo/jJtmdcbgIJ5EsjIJzYDXqMHsF
        p/tUY+88l/T1z2GZekByL9t26axMD9wO1NtVeg+NBfaD1a0w59i/YilEQqT7hiLxi0AKVyCl240
        ZyrFdDtwh2Aj8
X-Received: by 2002:a05:6402:42c8:b0:42d:f0b0:c004 with SMTP id i8-20020a05640242c800b0042df0b0c004mr6895713edc.356.1655391624770;
        Thu, 16 Jun 2022 08:00:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uLrXhf+s+0dq937PbW8fcacrqQrsPZ9lwKsPd2mBj0KcNbkNXCt99ZEqW7ol+UYPqFEvfXtQ==
X-Received: by 2002:a05:6402:42c8:b0:42d:f0b0:c004 with SMTP id i8-20020a05640242c800b0042df0b0c004mr6895697edc.356.1655391624592;
        Thu, 16 Jun 2022 08:00:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ky4-20020a170907778400b006fe921fcb2dsm897605ejc.49.2022.06.16.08.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 08:00:23 -0700 (PDT)
Message-ID: <e793f8f4-69dd-1824-7bb1-048428d977f4@redhat.com>
Date:   Thu, 16 Jun 2022 17:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 04/10] KVM: Avoid pfn_to_page() and vice versa when
 releasing pages
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429010416.2788472-1-seanjc@google.com>
 <20220429010416.2788472-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220429010416.2788472-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 03:04, Sean Christopherson wrote:
> -
> +/*
> + * Note, checking for an error/noslot pfn is the caller's responsibility when
> + * directly marking a page dirty/accessed.  Unlike the "release" helpers, the
> + * "set" helpers are not to be unused when the pfn might point at garbage.
> + */

s/unused/unused/

But while at it, I'd rather add a WARN_ON(is_error_noslot_pfn(pfn)).

Paolo

>   void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>   {
> -	if (kvm_is_ad_tracked_pfn(pfn))
> -		SetPageDirty(pfn_to_page(pfn));
> +	if (pfn_valid(pfn))
> +		kvm_set_page_dirty(pfn_to_page(pfn));
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
>   
>   void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>   {
> -	if (kvm_is_ad_tracked_pfn(pfn))
> -		mark_page_accessed(pfn_to_page(pfn));
> +	if (pfn_valid(pfn))
> +		kvm_set_page_accessed(pfn_to_page(pfn));
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);

