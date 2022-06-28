Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC155E78B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347391AbiF1PuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347178AbiF1PuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F57825C7E
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656431417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DakxM/+KiFO/D3po2I8kW227ufqvmzL2vNaM+Nshp8A=;
        b=GPd8kAa3safcG/cbjKoqrOAKQ/XlXnFmn3V1JPyeqyw6JVSYhQthJ12mG//P3mJZh/Bl/B
        haREDhG7cWkrWB+XD1LIe4Zui+djXiNl05wDYqCW0GmQL44ealAmjmqrORjWrDRPIkbzN9
        Tdp1d2ysZEAtbqx2tMxcMe2hnjqkCkw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-qI1WW9aSP1WrHoUXUjmvXw-1; Tue, 28 Jun 2022 11:50:15 -0400
X-MC-Unique: qI1WW9aSP1WrHoUXUjmvXw-1
Received: by mail-il1-f200.google.com with SMTP id b3-20020a92ce03000000b002da9b854bcdso2820837ilo.20
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DakxM/+KiFO/D3po2I8kW227ufqvmzL2vNaM+Nshp8A=;
        b=eqONdIsaXIq4xoxR0e+vCbTH241pK+9/mchW2SZWgUFi9TEt+wdA38tFd8jTIFIWPE
         bjRx3bJuxBcq4QlcbwoDBhtZKAZj7X/meehwxwElSg1kor0vg76uJoby9NpfL2l7BfGQ
         kfxml2YoAb/x6u3cUMklZlw/T/FoY1J/lTrDCKO7aollqhoKtqSZpdujJ3uvYOWQPjUI
         9ePnhgrj6PGBjfJNI8yqjV0N7DSQ6G4WrF2f9D5ZJp4ASuulhQUZt0PANs0Dk7Bz8OjL
         vfTYjI6HccRL3hWooNppQnfmoOG75+dseBQ8V8IFSY9cZqjOfWUaca8IWwm6dXa6Ekku
         HugQ==
X-Gm-Message-State: AJIora8YKLy4xBpPVeXCagW6vdfUSV06gRjQDS1SrdW6JSAnwpIfK3un
        6SdNm6LJnYvSsdLttPWaYI2l1KlAztaO9hIyDe/h0uDVKhYM8CRgfqQ8aP1RWf8jJC7I9wHLLOj
        4oPU85OFLzUGz
X-Received: by 2002:a05:6e02:801:b0:2da:7df7:e7c3 with SMTP id u1-20020a056e02080100b002da7df7e7c3mr9657806ilm.105.1656431415121;
        Tue, 28 Jun 2022 08:50:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sTVMbC8M0efZplHFG6sL7/SCrWa4uNmFX9wKMHlhrZRZ81Qtgx1LsCXyNRHQBr028dopIYBA==
X-Received: by 2002:a05:6e02:801:b0:2da:7df7:e7c3 with SMTP id u1-20020a056e02080100b002da7df7e7c3mr9657799ilm.105.1656431414921;
        Tue, 28 Jun 2022 08:50:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a14-20020a5d980e000000b006696754eef5sm6655206iol.13.2022.06.28.08.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:50:14 -0700 (PDT)
Date:   Tue, 28 Jun 2022 09:50:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Schspa Shi <schspa@gmail.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: Clear the caps->buf to NULL after free
Message-ID: <20220628095013.266d4a40.alex.williamson@redhat.com>
In-Reply-To: <20220628152429.286-1-schspa@gmail.com>
References: <20220628152429.286-1-schspa@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jun 2022 23:24:29 +0800
Schspa Shi <schspa@gmail.com> wrote:

> API vfio_info_cap_add will free caps->buf, clear it to NULL after
> free.

Should this be something like:

    On buffer resize failure, vfio_info_cap_add() will free the buffer,
    report zero for the size, and return -ENOMEM.  As additional
    hardening, also clear the buffer pointer to prevent any chance of a
    double free.

Thanks,
Alex
 
> Signed-off-by: Schspa Shi <schspa@gmail.com>
> ---
>  drivers/vfio/vfio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..a0fb93866f61 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1812,6 +1812,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
> +		caps->buf = NULL;
>  		caps->size = 0;
>  		return ERR_PTR(-ENOMEM);
>  	}

