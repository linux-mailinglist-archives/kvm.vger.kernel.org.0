Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9E6220F3
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKIAsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiKIAsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:48:10 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44422627DD
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:48:10 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id z30so10123304qkz.13
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+y+o2LSkoAVoMeDy58W+U4Gsq87tRhoJvkciUM9vy6Q=;
        b=IeATlO0NPnmqR3Scmwmh3SGxr4vyzOEjfr7qlUfaruSmjXxvKBHI6Nxnu1QoG1u21u
         Gpcq6ywoXYHHaJnu4nmxlWhBfMKdcdnIimMr8VjvmwJoht4cPYmDXAQR/KdxAQxidwl6
         jwfDIpE4wY/Ul5rxrmjkY9jaVSNr6S/C/PXZHH/tD/wWL5jX2Yv1xDrdTQ/15X7Hmim/
         VK3jznT0WsvofSC912SXQj/8V+QVFc9fnSSXdHwooSWRJDFAbk+P0/h1t176DgrhUydS
         Lwapch7PYhM6qp00z/+55/xYlvdYJXq1Lngn/Y9MhxmnZoJOU49vl9NMOHpvRjB38tyY
         KjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+y+o2LSkoAVoMeDy58W+U4Gsq87tRhoJvkciUM9vy6Q=;
        b=6O3wdBLoj2lFIzf3iAuX/OGbmpx+vadvHOd02ykRem9abUztGY2QrGOuJEvysajDp2
         sCizRxUQmz2Ew1mZ4SziGi4EvF14yBHWKtAUCOaCfMKcOmQQKyRYWCb4mmTPFyEBrOgn
         Gg1eqyBWFVa7nLYOrabFf7J6IY5X3FjZAHy2iCM4E0oo4edlnkP1HVtyccybklwPJjsK
         BgET7t6T2ZWjsOx1+YrMT/enX/KPLxD2UeHKigegueClJqwPrEfQnJCwy44L3ugm2N1+
         795Id+W9anc76uGZzVMAtYamPnS7Y6XIYR+yTmZP9SzQ1hM+7p39NIQ8FekzPafEgau3
         3riA==
X-Gm-Message-State: ACrzQf2D/+yuA7QNqEM/Q9Fw0Rt7ZCFy97hatm4pSD0bdyZoqt+JiR+j
        LccAI3wpBjPR/f1FWxDdRXpEww==
X-Google-Smtp-Source: AMsMyM4aMveP3gDx3QDwbE/MjWkJEgbTutW3935X9J26Xvn15mKZ8s+Mswbxqy/r4NtdhmBxLQNERw==
X-Received: by 2002:a05:620a:b15:b0:6fa:ae89:dcf8 with SMTP id t21-20020a05620a0b1500b006faae89dcf8mr13452809qkg.266.1667954889424;
        Tue, 08 Nov 2022 16:48:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id fw9-20020a05622a4a8900b003a56d82fd8csm8943337qtb.91.2022.11.08.16.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:48:08 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1osZGC-00HZqg-9N;
        Tue, 08 Nov 2022 20:48:08 -0400
Date:   Tue, 8 Nov 2022 20:48:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v5 2/3] vfio: Export the device set open count
Message-ID: <Y2r4yHY5re97WA7G@ziepe.ca>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-3-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105224458.8180-3-ajderossi@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 05, 2022 at 03:44:57PM -0700, Anthony DeRossi wrote:
> The open count of a device set is the sum of the open counts of all
> devices in the set. Drivers can use this value to determine whether
> shared resources are in use without tracking them manually or accessing
> the private open_count in vfio_device.
> 
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/vfio_main.c | 11 +++++++++++
>  include/linux/vfio.h     |  1 +
>  2 files changed, 12 insertions(+)

>  
> +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
> +{
> +	struct vfio_device *cur;
> +	unsigned int open_count = 0;

I'd probably just make this a bool

'vfio_device_set_last_close()'

And roll in the < 1 logic too

Nothing will ever need to know the number of fds open across the set.

But this is fine as written

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
