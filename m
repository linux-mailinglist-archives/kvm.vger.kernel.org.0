Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC71A645D37
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiLGPEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLGPDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:03:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A4162EBC
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670425322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAFoepezIvCP3uAHr/BFfLPVvO1u5OHDj5w9FAPQ8+I=;
        b=aCnGIwgVSZd+JpZGYNP2szYzL91KwIezC+Rpz1FzxjEK3KJr1pigQnqThuHXUbI/uv3Mu3
        qzQXBZjQndAB+IIIhy7Y4ONmthNCAgX1THVLR8nSoagFwUTLjI2FBqm7yjD9Y5vVvBosO1
        AXaoJ7uYZXsK72LpSh8gd0v1/wVkm+g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-unw6DvBVNtqiqo2zesaq1w-1; Wed, 07 Dec 2022 10:01:59 -0500
X-MC-Unique: unw6DvBVNtqiqo2zesaq1w-1
Received: by mail-wm1-f70.google.com with SMTP id u9-20020a05600c00c900b003cfb12839d6so699782wmm.5
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAFoepezIvCP3uAHr/BFfLPVvO1u5OHDj5w9FAPQ8+I=;
        b=E4qfRgWg4U0UWt5b3ukP67LrV6/sTczHeeDjpfbQREc4qZuSJsuI1ksugRtH02P8ol
         vDYxLbNtGSptN6PMh0kKAQibg/LFNiJP1G13zd39EfhSRlCnlv1p/spi1dtokTKNthYO
         A6eCv7ZRokLrnez2dWZWdTuGitxJ5nFNkiMbVTITTIO2Ad3p8izabEJ4n9V2Zv4lIwic
         /1NmSRySVib6KxKBsah4KigQ5fB0rDS7HY2OC+0Qs76tsMolRaE+kanx4NRGeX01nRwY
         oF5PUbNrXfMOJUT1XLTJlqjajgPLFMErELnXQc2fGlF6aFq8wEDqjxGpGwuNYrCPe0c5
         OmPA==
X-Gm-Message-State: ANoB5pnepyt2j5tHHc2LzA5fSG8I+1S9SX5QU/tj2y0Q+5NeMMMnvG+Q
        OAae10Uv/YvrXA4wVgCXDrZFY+cxaTaBA/mK/oP7TllbP2WyTOtOJfajOCrWV9pbYp7bwrBfNgL
        TDK/VIwu1eV/V
X-Received: by 2002:a05:6000:137a:b0:242:5b1f:3dd0 with SMTP id q26-20020a056000137a00b002425b1f3dd0mr10163871wrz.633.1670425317215;
        Wed, 07 Dec 2022 07:01:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7WjIG9s5h6WW8iRE/Pz9BUs/TQH8zSEuM+9DqTqN/19T1vpGwnC7f+e6cMwuAEoG4IwzH/4A==
X-Received: by 2002:a05:6000:137a:b0:242:5b1f:3dd0 with SMTP id q26-20020a056000137a00b002425b1f3dd0mr10163852wrz.633.1670425316889;
        Wed, 07 Dec 2022 07:01:56 -0800 (PST)
Received: from redhat.com ([2.52.154.114])
        by smtp.gmail.com with ESMTPSA id e4-20020adff344000000b00236488f62d6sm20203849wrp.79.2022.12.07.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:01:56 -0800 (PST)
Date:   Wed, 7 Dec 2022 10:01:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] drivers/vhost/vhost: fix overflow checks in
 vhost_overflow
Message-ID: <20221207100028-mutt-send-email-mst@kernel.org>
References: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 04:46:31PM +0300, Daniil Tatianin wrote:
> The if statement would erroneously check for > ULONG_MAX, which could
> never evaluate to true. Check for equality instead.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

It can trigger on a 32 bit system. I'd also expect more analysis
of the code flow than "this can not trigger switch to a condition
that can" to accompany a patch.

> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..8df706e7bc6c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -730,7 +730,7 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
>  /* Make sure 64 bit math will not overflow. */
>  static bool vhost_overflow(u64 uaddr, u64 size)
>  {
> -	if (uaddr > ULONG_MAX || size > ULONG_MAX)
> +	if (uaddr == ULONG_MAX || size == ULONG_MAX)
>  		return true;
>  
>  	if (!size)
> -- 
> 2.25.1

