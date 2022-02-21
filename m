Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8284BDC8D
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377184AbiBUOAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 09:00:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347740AbiBUOAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 09:00:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70AD51A3A8
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645451977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSVIW7WKSNU5PqfuEaIi9kuilnpf4QQg552O4p0c0vg=;
        b=Vokr/A4fohDcKbA6ZR0nwGtofkFZt+UdAxvewAbmPgr7KnQUK+eBVNj/l+nLxvtj9Hf0X+
        8o/vSAYnOHMb8P73LsckGMivAk3jiEPsrGWBC7OYMiGsCsPyiRRz55W2dnQZkMAKaOl5Up
        sw/AxxIgkslViqRai2fxVEC+utoqSNE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-MA5NvAcnMiqeO6X2K1SkVA-1; Mon, 21 Feb 2022 08:59:36 -0500
X-MC-Unique: MA5NvAcnMiqeO6X2K1SkVA-1
Received: by mail-wr1-f69.google.com with SMTP id e11-20020adf9bcb000000b001e316b01456so7428238wrc.21
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSVIW7WKSNU5PqfuEaIi9kuilnpf4QQg552O4p0c0vg=;
        b=Umxgipz2LfLqL4/PaUEgLCJU6zo1yMGzxffJYWRH2umbmb4vd6u8xEZU13tiSozXxX
         skiBS+LJsQABdsI2DE5uu6eyM3t3dCxmB2kObfkS9lBgaGFM/vTK13ZkunTItICQZ/1w
         TisEU8BOIYqKpsTE40UhBWndTXRceucHNblp4HTAwO7ykP0LrVHKIpTgJrLtGeDG+0s7
         Ckj5UNLgf05nktN3VCgRoD3tSmlNYMWXAwWNzPNrd3tOWhm+Gnt95h1TVNzHIKO5umi1
         rF0VAPcLTiSZu+Qy7v7/BvOfmd7XlBihwFQVVphtQixPZF/60iL7+uB/ChzcFW4iu/2J
         NiMg==
X-Gm-Message-State: AOAM530Tv/3r8Hv7ZN4zpZBKNyHV0lzKbBw6dq9EF8iUwKIly9kbvYy/
        nvtaBC7TzjILn/3cUC1+q/ZL36HwTScelNel4/LcjYoKb/cqGwNyKgRkniF2ujgsF9jnCN2oZeE
        xsq7g10en+yS3
X-Received: by 2002:adf:9f4a:0:b0:1e3:1c28:c298 with SMTP id f10-20020adf9f4a000000b001e31c28c298mr15464347wrg.233.1645451975136;
        Mon, 21 Feb 2022 05:59:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFnMEd+AorTKgUxxWlJ80t1TpsoeHG7oT0Zc9X8kQornxrzt1FVqy8lGYBIKPsefgfErXU1w==
X-Received: by 2002:adf:9f4a:0:b0:1e3:1c28:c298 with SMTP id f10-20020adf9f4a000000b001e31c28c298mr15464328wrg.233.1645451974972;
        Mon, 21 Feb 2022 05:59:34 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id i13sm13512139wrp.87.2022.02.21.05.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 05:59:34 -0800 (PST)
Date:   Mon, 21 Feb 2022 14:59:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
References: <20220221114916.107045-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221114916.107045-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
>
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
>
> Let's check the owner only when vhost_vsock_stop() is called
> by an ioctl.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com

