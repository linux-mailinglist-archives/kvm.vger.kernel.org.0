Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6052A535661
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 01:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349514AbiEZXZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 19:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349502AbiEZXZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 19:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F02A0E64CD
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 16:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653607509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9X8JUoVO3ItYFMP0lxBdt9F+7PIN+J/Kt3iw5v3WE2U=;
        b=iK1SE2WUTidlTsLmLJddRBWbe/D7dw2dibY64pdC09va1KSccCf53kMoJftllFnOHYSMeG
        ljSIS5w4dIEPSe3M3/we/H02mFcyLKG/38AK+sB9rZ4yj+SQQfcwad0INwOnP+HJzc4v4M
        bvpKhwRdpR6cGqKBCizQJNXopa4tOKU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-EECyTVrVOXq4utU8k4FZRw-1; Thu, 26 May 2022 19:25:07 -0400
X-MC-Unique: EECyTVrVOXq4utU8k4FZRw-1
Received: by mail-wm1-f70.google.com with SMTP id j40-20020a05600c1c2800b003972dbb1066so3779514wms.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 16:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9X8JUoVO3ItYFMP0lxBdt9F+7PIN+J/Kt3iw5v3WE2U=;
        b=2hxUXR/H5IJ236pCPOA35LsxOgnOYqOueoCu34WZrM7M8hZTLKt8WMqz4Rv1z6NdpE
         urb+Zw9T91nWUUNXGKoBn0/j/yygoV0TVyXmweoaaAWqhIHz/97sDyQvt8BvfTDWvXUv
         oXPg7OeOsmdAPRJ52eUk1XlQdIvr6pBkG58tpK5HQw/vcDTAJRsyV0gwo+87dSfHgo/d
         RNTMRUgxT2ApYL36cQ0wFeMzk4qPNPZ5/jDcWU+Pwe4p/LkyFDcsVhDJ1AJoeo6AnHIh
         pcItZc2+QV68f5Y6tMK9tXtiizh2oR9Ia5GGJxNA9/5/WsOl4fNRzuMkWViIM/s5aw9S
         mPVw==
X-Gm-Message-State: AOAM531ervVuF2eQ73WgOs+035Dh140xFnKr52GYvP1KW7VprydTTt+R
        VPR789Z1s0MhC1hleVQjyfJfPEKohsTvDsLsQmd4SQW8/Y4SHskmPJFTH9ejyIp/NcKfqOH75cA
        0kl0sGcrfCuZ5
X-Received: by 2002:a5d:6d8c:0:b0:20e:72ce:c9d9 with SMTP id l12-20020a5d6d8c000000b0020e72cec9d9mr29002642wrs.598.1653607505645;
        Thu, 26 May 2022 16:25:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6jLtwn+a7vihIpXB+X9zxsi4oW40VzxI37oPu2ky+U6YhL+3ESFEOquhhiPVK7ZSiEhjghw==
X-Received: by 2002:a5d:6d8c:0:b0:20e:72ce:c9d9 with SMTP id l12-20020a5d6d8c000000b0020e72cec9d9mr29002625wrs.598.1653607505366;
        Thu, 26 May 2022 16:25:05 -0700 (PDT)
Received: from redhat.com ([2.55.29.191])
        by smtp.gmail.com with ESMTPSA id 8-20020a1c0208000000b003942a244ed1sm466085wmc.22.2022.05.26.16.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 16:25:04 -0700 (PDT)
Date:   Thu, 26 May 2022 19:25:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     dan.carpenter@oracle.com, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: Fix some error handling path in
 vhost_vdpa_process_iotlb_msg()
Message-ID: <20220526192401-mutt-send-email-mst@kernel.org>
References: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 22, 2022 at 03:59:01PM +0200, Christophe JAILLET wrote:
> In the error paths introduced by the commit in the Fixes tag, a mutex may
> be left locked.
> Add the correct goto instead of a direct return.
> 
> Fixes: a1468175bb17 ("vhost-vdpa: support ASID based IOTLB API")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> WARNING: This patch only fixes the goto vs return mix-up in this function.
> However, the 2nd hunk looks really spurious to me. I think that the:
> -		return -EINVAL;
> +		r = -EINVAL;
> +		goto unlock;
> should be done only in the 'if (!iotlb)' block.
> 
> As I don't know this code, I just leave it as-is but draw your attention
> in case this is another bug lurking.
> ---
>  drivers/vhost/vdpa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 1f1d1c425573..3e86080041fc 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1000,7 +1000,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>  		if (!as) {
>  			dev_err(&v->dev, "can't find and alloc asid %d\n",
>  				asid);
> -			return -EINVAL;
> +			r = -EINVAL;
> +			goto unlock;
>  		}
>  		iotlb = &as->iotlb;
>  	} else
> @@ -1013,7 +1014,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>  		}
>  		if (!iotlb)
>  			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
> -		return -EINVAL;
> +		r = -EINVAL;
> +		goto unlock;
>  	}
>  
>  	switch (msg->type) {
> -- 
> 2.34.1

