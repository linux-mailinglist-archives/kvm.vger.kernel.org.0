Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176236C0259
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 15:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjCSOTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCSOS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 10:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477741A486
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679235489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6aFNRO2JT6HAWO7tCApABxmO5PTROa8NFsgv1LNIMDU=;
        b=YpL3rEfbGZ3Lc7c+sMzD98WFYsA7JIzW6ybEkqyRFzO92ptmlsDL9dAJqNKy8OUHZxY8+F
        Ezx5aA82Od43LeRJ2wMWqPwF30M+LnQ4ctIVHJqvT9JP5FTWiULaiYYgelDeIh7tLmb4Mx
        abre5YAa5vMsqj95yrg0oAJLDqHl9ag=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-rrQ0dEI-MGGiiq613vyyNQ-1; Sun, 19 Mar 2023 10:18:07 -0400
X-MC-Unique: rrQ0dEI-MGGiiq613vyyNQ-1
Received: by mail-io1-f69.google.com with SMTP id r25-20020a056602235900b0074d472df653so4795294iot.2
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 07:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679235487;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6aFNRO2JT6HAWO7tCApABxmO5PTROa8NFsgv1LNIMDU=;
        b=bCfp/BggcYiupocm+JWnwTxhvjMCED7JhuDSnly4AKvZw5Yuxj2B54hS8A8ckxCL0w
         mS/v+bYCcBH4OF2y0RXyb0dbdu2tRU4Cg5fKbpt2yIZtxvvXLz61OnZhZe134XQ904s0
         KcpOguGN4zh4Iyd2mY4SgKJaFWYXHmHmyItGLSVDqawB5o4KnP5Fhk4CuYHq2brQP3y/
         MsJFVsbe0FsQn8LUx0dQ51Fk9D7SfdMEK/Clfal55b8I83bzDvyEusJ1LiXMYhlHSPSA
         62FEUgGMlGWw3YO6lmHhAJLscTMmbjtCytlw/nX+kTf086xbdsw95ATNdCPVYR5K063D
         dU1g==
X-Gm-Message-State: AO0yUKXFe5cCgOA3k+TaHtL5IImIRYuTIKBq9bubLJWbObbTgzCedP5t
        D8v6p/YaYdjFv/s/BuOQrUB+/zuHsDSyiUn4A9sRrs70oRhWoT9MwcxHikob+9k7YPvlkdP6RHR
        tNUGqYjcX3y/Z
X-Received: by 2002:a5e:a60c:0:b0:753:42d:25ec with SMTP id q12-20020a5ea60c000000b00753042d25ecmr2756565ioi.20.1679235487358;
        Sun, 19 Mar 2023 07:18:07 -0700 (PDT)
X-Google-Smtp-Source: AK7set8vXhp+C5HN6FcO/dlNnK7JU9SNlPq1VXxLva12OLzXK/lnt/uPEDGwqX1OpgZ0JRScOscdvA==
X-Received: by 2002:a5e:a60c:0:b0:753:42d:25ec with SMTP id q12-20020a5ea60c000000b00753042d25ecmr2756558ioi.20.1679235487070;
        Sun, 19 Mar 2023 07:18:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w4-20020a6b4a04000000b0073fe9d412fasm2115727iob.33.2023.03.19.07.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 07:18:06 -0700 (PDT)
Date:   Sun, 19 Mar 2023 08:18:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lizhe <sensor1010@163.com>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] vfio/mdev: Remove redundant driver match function
Message-ID: <20230319081805.487b1fd6.alex.williamson@redhat.com>
In-Reply-To: <20230319050130.360515-1-sensor1010@163.com>
References: <20230319050130.360515-1-sensor1010@163.com>
Organization: Red Hat
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

On Sun, 19 Mar 2023 13:01:30 +0800
Lizhe <sensor1010@163.com> wrote:

> If there is no driver match function, the driver core assumes that each
> candidate pair (driver, device) matches, see driver_match_device().
> 
> Drop the bus's match function that always returned 1 and so
> implements the same behaviour as when there is no match function.

The removed function returns 0, not 1, so this is replacing the
functionality with something that does exactly the opposite of the
current behavior.  Please explain.  Thanks,

Alex
 
> Signed-off-by: Lizhe <sensor1010@163.com>
> ---
>  drivers/vfio/mdev/mdev_driver.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 7825d83a55f8..fafa4416aad9 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -31,20 +31,10 @@ static void mdev_remove(struct device *dev)
>  		drv->remove(to_mdev_device(dev));
>  }
>  
> -static int mdev_match(struct device *dev, struct device_driver *drv)
> -{
> -	/*
> -	 * No drivers automatically match. Drivers are only bound by explicit
> -	 * device_driver_attach()
> -	 */
> -	return 0;
> -}
> -
>  struct bus_type mdev_bus_type = {
>  	.name		= "mdev",
>  	.probe		= mdev_probe,
>  	.remove		= mdev_remove,
> -	.match		= mdev_match,
>  };
>  
>  /**

