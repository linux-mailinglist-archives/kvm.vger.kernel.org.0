Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A930027B547
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgI1T3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 15:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbgI1T3e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 15:29:34 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601321372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7R0uSUBVOBC3ELw6r6XW5F6NVJS5n7iWxx/t8OjrN0=;
        b=dypPn5/nQJFbFVSZY75Rhdtg76ngyeLH70mSQfeVEjP0K2x2KTmZXyIicOLy+KTltCg/s5
        6BPrOz8hgEpGgW6O52wv8aMwSwhuv/He0Z6Gkt8Bu673vFhbU8h8AwybUjdDoAB94MOKVf
        zJQaAXbRf1Jdx9QBSPYsEvqjrPrydlA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-2S9z53i0PJ6mklImnz_9yA-1; Mon, 28 Sep 2020 15:29:30 -0400
X-MC-Unique: 2S9z53i0PJ6mklImnz_9yA-1
Received: by mail-wr1-f71.google.com with SMTP id w7so797899wrp.2
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 12:29:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g7R0uSUBVOBC3ELw6r6XW5F6NVJS5n7iWxx/t8OjrN0=;
        b=HYGrldtEABz42g0b5WDXqllrHApkdDxO6Hs05iqO8oPCUB1ynp7vyY+Rykt9Jz3QXU
         nSpJhXLcHTtuIblg7lQ7Mwxc93ytoCtv+u+pswohIJsozrxs/bmFijKVsfnxMJt3povm
         r3iC9ReLmb83LTXFMcL9gaS181kPDryOSzRzSeILjibJy7liTP7ltAozzJX45QWYuWPB
         w9sS9pxcUSw06zGRWCcEOuuGtX84iBcSYao+DsV3LPROqoeHIC52mU/oKyfGzGS5vFAv
         Dbv31BDhZIoTzCtLjgbJsnIPHW193RiXGoJKewwIAGumkiAViUetycMNul3um6FzsxXz
         bhYw==
X-Gm-Message-State: AOAM531mjWNxeUYBDDMWRmBcQLiEViLjm85lxNKkGzv0LrG3Itani1lb
        8SxfvheXeZjBls8NmripoJXI2cIcipORPsTzz9Laj1lxqOEBllvDPam8m+TkG8mBzlxA/Js54eJ
        ItwrD4HBwac1Z
X-Received: by 2002:adf:e304:: with SMTP id b4mr27435wrj.141.1601321369186;
        Mon, 28 Sep 2020 12:29:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE21P0wkiAkvryE+2wIqsoKtS+RuwPRqx3bJhGPxwgCgHmMCakq2DNpqAYhl0gF/KFYyDoXA==
X-Received: by 2002:adf:e304:: with SMTP id b4mr27421wrj.141.1601321368968;
        Mon, 28 Sep 2020 12:29:28 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id n10sm2662427wmk.7.2020.09.28.12.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 12:29:28 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:29:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vhost: Don't call vq_access_ok() when using IOTLB
Message-ID: <20200928152859-mutt-send-email-mst@kernel.org>
References: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 02:35:04PM +0200, Greg Kurz wrote:
> When the IOTLB device is enabled, the vring addresses we get from
> userspace are GIOVAs. It is thus wrong to pass them to vq_access_ok()
> which only takes HVAs. The IOTLB map is likely empty at this stage,
> so there isn't much that can be done with these GIOVAs. Access validation
> will be performed at IOTLB prefetch time anyway.
> 
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
> Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
> Cc: jasowang@redhat.com
> CC: stable@vger.kernel.org # 4.14+
> Signed-off-by: Greg Kurz <groug@kaod.org>

Hmm I was sure the addresses are HVAs in any case ...
Jason?

> ---
>  drivers/vhost/vhost.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..6296e33df31d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1509,7 +1509,10 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>  	 * If it is not, we don't as size might not have been setup.
>  	 * We will verify when backend is configured. */
>  	if (vq->private_data) {
> -		if (!vq_access_ok(vq, vq->num,
> +		/* If an IOTLB device is present, the vring addresses are
> +		 * GIOVAs. Access will be validated during IOTLB prefetch. */
> +		if (!vq->iotlb &&
> +		    !vq_access_ok(vq, vq->num,
>  			(void __user *)(unsigned long)a.desc_user_addr,
>  			(void __user *)(unsigned long)a.avail_user_addr,
>  			(void __user *)(unsigned long)a.used_user_addr))
> 

