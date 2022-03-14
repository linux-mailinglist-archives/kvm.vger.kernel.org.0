Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8934D819F
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 12:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiCNLui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 07:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbiCNLug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 07:50:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0279C3F309
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647258566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2OV+JMiHtDmU80bd8QdGrPwVuVFZHYuiIn55+GlQmhk=;
        b=X9iG2BRZhp0tUxW9OLTwpp2FWKrOPP4X8rpaVEEo9CUwVMIcsE0IhDNwEnK/2vC+aE1tAo
        cNaw186OgSMOgK59GeFXNcBQdEd0UV0T5U1OXwwnZzel9iFTW2TrE9Q2Mh8unswb9nM2nA
        YJqq7CJ1SENtQiplR+rzGgV1to4unt4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-mp5GdjcLMUWi86k5gOAjDA-1; Mon, 14 Mar 2022 07:49:24 -0400
X-MC-Unique: mp5GdjcLMUWi86k5gOAjDA-1
Received: by mail-wr1-f70.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so4261069wri.2
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OV+JMiHtDmU80bd8QdGrPwVuVFZHYuiIn55+GlQmhk=;
        b=Ae3HLXDx0a1CIkjPOPv80YM5PLOd7y9S9EmhDhztSaq196DEyPioGARq6tFsL/bpeS
         nxcZxbtn4Bcw8sd3idDlxCYCc3Kog4yUlg3pwsNiLud2wh7kaPQntzHR+PBNUVS7Wtkb
         fnBDlr4we4dp02NX/zOJIt24CrH9frspneLhCmRni2Q71oLBzrJIGOxfydNPtEx9nHeW
         vPTo+opBI6A3Yz07ltKVLLqp4NGp6gjAjX2mFEyNWBpm0s+ax4DDxsyrYy8/Lqg+c81d
         zjqFCRmMk7f5GCtmgCw8XT/uiLG1/HtG8GttFtVuErsngVwQ14ETp5+rH8Vldxe5LuIR
         +a0g==
X-Gm-Message-State: AOAM533xPSYOm0OcLM/giFQ8bgFXdG+J4MzWeG1rjD80GHB+5IuEJcay
        zU5GnsrDypYuVIIwATnO2kmqb9Z0YT/0G6AwtSD5U9BGljsX8iRAgtiuJaejCrR+xciNvPFEkLq
        0JArSf/f/lrKo
X-Received: by 2002:a7b:c4d9:0:b0:382:a5cb:ff2f with SMTP id g25-20020a7bc4d9000000b00382a5cbff2fmr24926183wmk.193.1647258563830;
        Mon, 14 Mar 2022 04:49:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0vEUQerg7rtj1M60xY/4WI1a07DNC4tgLgIhZzRrnktkhTqSbm6C/0HM52Wm6/8e4NBhRaQ==
X-Received: by 2002:a7b:c4d9:0:b0:382:a5cb:ff2f with SMTP id g25-20020a7bc4d9000000b00382a5cbff2fmr24926169wmk.193.1647258563574;
        Mon, 14 Mar 2022 04:49:23 -0700 (PDT)
Received: from redhat.com ([2.55.183.53])
        by smtp.gmail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm18037161wml.43.2022.03.14.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:49:22 -0700 (PDT)
Date:   Mon, 14 Mar 2022 07:49:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220314072137-mutt-send-email-mst@kernel.org>
References: <20220314084302.2933167-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314084302.2933167-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 08:43:02AM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do here is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.
> 
> Also WARN() as a precautionary measure.  The purpose of this is to
> capture possible future race conditions which may pop up over time.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Pls refer to my previous responses to this patch.  I'd like to see an
argument for why this will make future bugs less and not more likely.


> ---
>  drivers/vhost/vhost.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..bbaff6a5e21b8 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}
>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.723.g4982287a31-goog

