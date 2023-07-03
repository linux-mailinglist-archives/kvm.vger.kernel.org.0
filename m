Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856BB745F23
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjGCOww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 10:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjGCOwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 10:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19F7E66
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688395929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hxWPFMlR4kZ1+JmDhDbo+VkKWcHB0JOfutQmGW+4K4A=;
        b=OYX0ATNPr1aKHfunGXKJ+picDNwMmv2J+oON6T3DuMs2tpNmsbtbob/r+DngbKlOnSAcZ6
        rs5+4YI4yDxKU8SUUeEA0YqQHF3dd66Oeqt0gO0z3j/9BISI4OuEzw2PZJvcyWijcZ2LpC
        g37h5raP7DhSnANiun8xCXv/m5ISkLk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-UBgG4v1DPquJx_mCfCB3mg-1; Mon, 03 Jul 2023 10:52:08 -0400
X-MC-Unique: UBgG4v1DPquJx_mCfCB3mg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fa83859fa4so24784285e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 07:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688395927; x=1690987927;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hxWPFMlR4kZ1+JmDhDbo+VkKWcHB0JOfutQmGW+4K4A=;
        b=BuIQ2L6zwB9BgD0D7LgwqTM8pMXc4gSRaaGYyyELIBxLTmadcRVp4i8ibdTlwyqwHg
         g6uPDdNE4eBR8BEI820mifRXKHZg4Fdy6zRG/MjTAS95vv69fTDyQ8h4Fxm1KISjgLAE
         n9DM7W/6KCemHI+tQv6agmWfyYxTsnzSKQPAEE6AvQNbXVta+QPdDYx8RW+r7bJX0gk9
         qTc9uaobEnFe1Le52qo7TscrGwalPQEoob/xsn4U9iD3AMcvH0glcfb1WID53OzgkLb4
         LALW/7n98iYrc0gUoR4wXFwgWLDG+H6THARZJhkQbq6CB2Uu9lMAWT1uZfOYPtS7cTxZ
         fLOg==
X-Gm-Message-State: AC+VfDzZVh7iWTunSRuKv3ygG+Pq6MtI1vYmLm0HsN/5NykUpHez0X71
        3p61R9YpcoznsK99AHb7NhCbgbDZFN+rKGTmUO2csrzIWj5OYOCdaQCirX0j0o8707OBl9KlTEv
        BfsR0VqczOy4R
X-Received: by 2002:a1c:7908:0:b0:3f8:fb7c:6793 with SMTP id l8-20020a1c7908000000b003f8fb7c6793mr7708569wme.24.1688395927802;
        Mon, 03 Jul 2023 07:52:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47ys+l55usHyGP6AT5yJibBBM3aCFWJJsiZ8eURago1u09Y9uC8molkOyCSHZ78useV0c8hg==
X-Received: by 2002:a1c:7908:0:b0:3f8:fb7c:6793 with SMTP id l8-20020a1c7908000000b003f8fb7c6793mr7708551wme.24.1688395927496;
        Mon, 03 Jul 2023 07:52:07 -0700 (PDT)
Received: from redhat.com ([2.52.13.33])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c229800b003fa98908014sm21973630wmf.8.2023.07.03.07.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 07:52:07 -0700 (PDT)
Date:   Mon, 3 Jul 2023 10:52:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does
 not support it
Message-ID: <20230703105022-mutt-send-email-mst@kernel.org>
References: <20230703142218.362549-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230703142218.362549-1-eperezma@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
> With the current code it is accepted as long as userland send it.
> 
> Although userland should not set a feature flag that has not been
> offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
> complain for it.
> 
> Since there is no specific reason for any parent to reject that backend
> feature bit when it has been proposed, let's control it at vdpa frontend
> level. Future patches may move this control to the parent driver.
> 
> Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

Please do send v3. And again, I don't want to send "after driver ok" hack
upstream at all, I merged it in next just to give it some testing.
We want RING_ACCESS_AFTER_KICK or some such.


> ---
> Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
> commit. Please let me know if I should send a v3 of [1] instead.
> 
> [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
> ---
>  drivers/vhost/vdpa.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e1abf29fed5b..a7e554352351 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  {
>  	struct vhost_vdpa *v = filep->private_data;
>  	struct vhost_dev *d = &v->vdev;
> +	const struct vdpa_config_ops *ops = v->vdpa->config;
>  	void __user *argp = (void __user *)arg;
>  	u64 __user *featurep = argp;
> -	u64 features;
> +	u64 features, parent_features = 0;
>  	long r = 0;
>  
>  	if (cmd == VHOST_SET_BACKEND_FEATURES) {
>  		if (copy_from_user(&features, featurep, sizeof(features)))
>  			return -EFAULT;
> +		if (ops->get_backend_features)
> +			parent_features = ops->get_backend_features(v->vdpa);
>  		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
>  				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>  				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
> -				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
> +				 parent_features))
>  			return -EOPNOTSUPP;
>  		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>  		     !vhost_vdpa_can_suspend(v))
> -- 
> 2.39.3

