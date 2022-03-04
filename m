Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A094CD27A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiCDKgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbiCDKf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:35:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2A361A6357
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646390110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aTP72OuXUGyN5QMTKund2mceL2rox5drVmYYqAWWAWE=;
        b=JqxCLh+zSWqJK5SZR0vvFDTnMid4pRqfSB/PyWGG7rO0MfCnSTkRMQaWAZ1GglVrLlaXDD
        Z66fJxNBKiij/HyhL5hfxmA4yx3ACMotttCbVvgpbmHaEeEF6H9GD5K5DFcungd9kN1123
        w3w7aQpdhHlkrNFNcxf5mEjV27Q4A7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-IWJparflN3yoYwKZqq_DWA-1; Fri, 04 Mar 2022 05:35:09 -0500
X-MC-Unique: IWJparflN3yoYwKZqq_DWA-1
Received: by mail-wm1-f71.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so859776wmc.3
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aTP72OuXUGyN5QMTKund2mceL2rox5drVmYYqAWWAWE=;
        b=uX1CbxJKFXRhdtJapMyhWHywjGb5ZLj344GBrZeXj2QmrYfD1Xejl+uQtiWZlVts1q
         5HNg0SZi0SOBtGPmdYz0SCWiaexR3tE9xUahoSobynpaHNh9aB3J7vzlq1Ae9vgMcyUH
         4T2jDRbfNthbXrfPuaKx/NFkFPhdyUl1+x8Zn46ecnQln7ki/ScArbwaVyx2Ft1Ce+zD
         4ADZGr8NQMxhgf0KqGHxTvTGi87uD4kO2hhUDWyu6VhdqzVXkfO+jakI5alEoPrzLqdd
         i49xhxUIf8ULku3u6KO2wMZGTS84xs19Oi0DNhL69qG60+qmdWzW1Du32sV7Nrq6npzj
         I9mA==
X-Gm-Message-State: AOAM530xJk1Jkhax4sW0B/6vQsm1p5hqaA+yfqPt6+bXJb5ib71EVQd7
        igDfn4056FSzDjhPmctr0u7jEm9S4YMygsAar6aTxAwTOu7DPpoWHgMIAK7idTimBzMGU831UhC
        pGr1VYSel5ejd
X-Received: by 2002:adf:d1c9:0:b0:1ea:830d:f1b0 with SMTP id b9-20020adfd1c9000000b001ea830df1b0mr30082454wrd.522.1646390108374;
        Fri, 04 Mar 2022 02:35:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBoEWnkTyY47uRej3nBN62Zla7j1qhOJQg1IbWcq42GoEOzdoGVLqDv4sEqS2Q9IErD+aglg==
X-Received: by 2002:adf:d1c9:0:b0:1ea:830d:f1b0 with SMTP id b9-20020adfd1c9000000b001ea830df1b0mr30082440wrd.522.1646390108163;
        Fri, 04 Mar 2022 02:35:08 -0800 (PST)
Received: from redhat.com ([2.52.16.157])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b0037bf934bca3sm13576042wmq.17.2022.03.04.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:35:07 -0800 (PST)
Date:   Fri, 4 Mar 2022 05:35:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v3 4/4] docs: vhost-user: add subsection for non-Linux
 platforms
Message-ID: <20220304053326-mutt-send-email-mst@kernel.org>
References: <20220303115911.20962-1-slp@redhat.com>
 <20220303115911.20962-5-slp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303115911.20962-5-slp@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 12:59:11PM +0100, Sergio Lopez wrote:
> Add a section explaining how vhost-user is supported on platforms
> other than Linux.
> 
> Signed-off-by: Sergio Lopez <slp@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index edc3ad84a3..590a626b92 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -38,6 +38,24 @@ conventions <backend_conventions>`.
>  *Master* and *slave* can be either a client (i.e. connecting) or
>  server (listening) in the socket communication.
>  
> +Support for platforms other than Linux


It's not just Linux - any platform without eventfd.

So I think we should have a section explaining that whereever
spec says eventfd it can be a pipe if system does not
support creating eventfd.

> +--------------------------------------
> +
> +While vhost-user was initially developed targeting Linux, nowadays is
> +supported on any platform that provides the following features:
> +
> +- The ability to share a mapping injected into the guest between
> +  multiple processes, so both QEMU and the vhost-user daemon servicing
> +  the device can access simultaneously the memory regions containing
> +  the virtqueues and the data associated with each request.
> +
> +- AF_UNIX sockets with SCM_RIGHTS, so QEMU can communicate with the
> +  vhost-user daemon and send it file descriptors when needed.
> +
> +- Either eventfd or pipe/pipe2. On platforms where eventfd is not
> +  available, QEMU will automatically fallback to pipe2 or, as a last
> +  resort, pipe.
> +
>  Message Specification
>  =====================
>  
> -- 
> 2.35.1

