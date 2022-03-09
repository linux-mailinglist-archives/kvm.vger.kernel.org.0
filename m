Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0944D356B
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiCIRfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiCIRfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:35:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B047310E063
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646847286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jARVDG/B6xgHpwc3hZSIDUezMyHA7D5JGNb+U6xC/8=;
        b=BE6RbXuXzL90K8I/j55L0+l4PH7mAhNG7UogkTfemiS29gn3CmLHhsEf7rMah3UQK77Uw2
        cS/TRHc/xNlgG9mfY/KjDbZM87mSoFN7DKmBGZviCjvjobe+Guc/GK4kIaMGifWTm+/J4t
        sTOVLbnXwj+9ZcxToEiVFMxIEj4ef6o=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-fkr7Epn-OZiBiyY3MqVYwA-1; Wed, 09 Mar 2022 12:34:42 -0500
X-MC-Unique: fkr7Epn-OZiBiyY3MqVYwA-1
Received: by mail-ot1-f70.google.com with SMTP id w7-20020a9d6747000000b005b25c9036fdso2100593otm.5
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 09:34:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9jARVDG/B6xgHpwc3hZSIDUezMyHA7D5JGNb+U6xC/8=;
        b=VpHNP3l/ysJGoC+312fr92+EFu3owH47EMlD6F529NJ0yvaa3u11Xpi6SVvGYnLjXU
         D1laaiYWjI36bWjEzAob2hq5MvblqCBvUdeggBBUsaap+pYG8xyWrTVzY/cSlHgFSXt5
         hSM0eM3/HBm67kF3UkQwYLW4YTIEjfMmE8JSQ3F4cfOzk51qyl6h5KliX8ombPR6vpV5
         ViEzfUDymb4T3L4Cvw8cNjle7e+cV8aOqkcrGqjgXJHx3q1nd+bqO2Xlum9mktcedVvh
         LHSDuy7qbR0c+/n2KyYcNN8+5NxJvHep68eT/oxN2Ftepvt4URYPfbLtJWrAuip0vxim
         1X/w==
X-Gm-Message-State: AOAM533SJFbsTJFm2OsaLGdiOACxqbhfHdOrjcE8dD8zRWvBYeZj2OJ1
        zsJnhlCBad9NsZRifM5cV2CEjqQQzfgVfQWrujxaZ3H+ljsClvLtLY48jhiftbZIgspLxfmlb1t
        Af6BRsvxytm73
X-Received: by 2002:a05:6808:1403:b0:2da:3ab6:3c1e with SMTP id w3-20020a056808140300b002da3ab63c1emr2085543oiv.226.1646847281978;
        Wed, 09 Mar 2022 09:34:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeCA3Y8zQSwgEBg0rpeIpjD+iSjTfPBm1NeHd22ZloJICsal7qD033KyXytVX3ix+ZMbq5ow==
X-Received: by 2002:a05:6808:1403:b0:2da:3ab6:3c1e with SMTP id w3-20020a056808140300b002da3ab63c1emr2085531oiv.226.1646847281714;
        Wed, 09 Mar 2022 09:34:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e28-20020a056820061c00b00320bf3ecf05sm1261268oow.4.2022.03.09.09.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:34:41 -0800 (PST)
Date:   Wed, 9 Mar 2022 10:34:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] vfio/mlx5: Fix to not use 0 as NULL pointer
Message-ID: <20220309103439.2dd682f9.alex.williamson@redhat.com>
In-Reply-To: <20220309080217.94274-1-yishaih@nvidia.com>
References: <20220309080217.94274-1-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Mar 2022 10:02:17 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Fix sparse warning to not use plain integer (i.e. 0) as NULL pointer.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 282a9d4bf776..bbec5d288fee 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -409,7 +409,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>  
>  	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
>  		mlx5vf_disable_fds(mvdev);
> -		return 0;
> +		return NULL;
>  	}
>  
>  	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
> @@ -430,7 +430,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>  		if (ret)
>  			return ERR_PTR(ret);
>  		mlx5vf_disable_fds(mvdev);
> -		return 0;
> +		return NULL;
>  	}
>  
>  	/*

Applied to vfio next branch for v5.18.  Thanks,

Alex

