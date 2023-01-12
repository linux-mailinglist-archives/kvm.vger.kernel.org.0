Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF5667ED6
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbjALTPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjALTOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:14:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AA63FC83
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673550019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ymk2GFL+loFdDUMfdkHxN/0F1V1VDp0Nz7oj7NONjgA=;
        b=X4XoinBKtUQnyigs1IiVp00ZsE2euTbIaiQKW+M8aK90NmnibmKjWqSN9X0ZAH5ZbE6O3D
        FQpoaJ36NF7XSe0XNwrAi6dEiP5lpFWXUOA6UDhC8pEW1ELaB2ptgVqemBVwCN822WPFuR
        eBopIPAi1LMBYtygMjNP/fijTXIDYi4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-495-CW2DjsXzNQavgdF07LFLlw-1; Thu, 12 Jan 2023 14:00:18 -0500
X-MC-Unique: CW2DjsXzNQavgdF07LFLlw-1
Received: by mail-il1-f198.google.com with SMTP id z8-20020a056e02088800b0030c247efc7dso14061346ils.15
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:00:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ymk2GFL+loFdDUMfdkHxN/0F1V1VDp0Nz7oj7NONjgA=;
        b=tLvqXr3Vszw2m3LCLMS3A2iVsFrY44HjLWpe24WG6JTGD7dAYMkL1ggcoHIjhSq8ed
         7CVNINJfCTyuQTMhNrZj2xcyB8jef16sIHT/OsQPTssKkWynQKEu918cpxEM0hQYH7XK
         dvscbm3ajmxvpKPYfw+8BjbXSmEItg02yn4Gbeb7CpiNtKUPT/+k/6hlDoL14bGtBmcq
         UyNShDM7q5iMaAFqqxcBbuq43aU+w8G39aU5f5wXoQy6NUMRnXF3m0U453mxNi5WIfQT
         Sxy9l/LwCOsJwLamHXi7IBd0dNViCQgth71iQfIOTV6FKYxU/LhkV3DXJdnthCFyxAKs
         aFPg==
X-Gm-Message-State: AFqh2kqLAhQWFREbk47FObK97vefI2llZDOKW5bfKbC2B83HsDBU8gLd
        AGj920NGzDjIxmTL7nCFPnhV5xGZbQL5XhmTDkXlSLSqjIC9WSYLzYEngN5cr36rc9snJQwjQY1
        WdH7ThxruSis5
X-Received: by 2002:a5d:8058:0:b0:6e5:d22f:8566 with SMTP id b24-20020a5d8058000000b006e5d22f8566mr5191325ior.14.1673550017736;
        Thu, 12 Jan 2023 11:00:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXun1NjzuNT3op4TZby4hpLXDuIi1i3Yy7JJCdIUVQQq0FazXV7VR++Phiusq+s/g7BQ4Bi0Uw==
X-Received: by 2002:a5d:8058:0:b0:6e5:d22f:8566 with SMTP id b24-20020a5d8058000000b006e5d22f8566mr5191317ior.14.1673550017520;
        Thu, 12 Jan 2023 11:00:17 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f16-20020a056602089000b006e31544bea5sm6235766ioz.49.2023.01.12.11.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 11:00:16 -0800 (PST)
Date:   Thu, 12 Jan 2023 12:00:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: step down as vfio reviewer
Message-ID: <20230112120015.30c4f2e0.alex.williamson@redhat.com>
In-Reply-To: <20230112145707.27941-1-cohuck@redhat.com>
References: <20230112145707.27941-1-cohuck@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:57:07 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> As my focus has shifted in recent months, my involvement with vfio has
> decreased to occasionally reviewing some simpler patches, which is
> probably less than you'd expect when you cc: someone for review.
> 
> Given that I currently don't have spare time to invest in looking at
> vfio things, let's adjust the entry to match reality.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e278cd5d0de0..d1a1b30a3043 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21836,7 +21836,6 @@ F:	tools/testing/selftests/filesystems/fat/
>  
>  VFIO DRIVER
>  M:	Alex Williamson <alex.williamson@redhat.com>
> -R:	Cornelia Huck <cohuck@redhat.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
>  T:	git https://github.com/awilliam/linux-vfio.git

Sorry to see you step down, but your contributions over the years are
very much appreciated!  Queued for v6.3.  Thanks,

Alex

