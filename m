Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B525AF80E
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 00:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiIFWmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 18:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiIFWmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 18:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4CA8FD77
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662504120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KaiiwGogUVf/sW/NCZ1A9G8Q7iwk+zy+Q12Kp9/22/g=;
        b=HD96lwawyWN2vHaI0I+iNA59G9nyQHLC1TP7aLhRKGKOWsIvvn/rIBtNSRoVGAB18mPGju
        1Ss6d+lPThzFTA6agwOtSINUt89wylUmTGly1FoLWY+Gd4ueNKJ2vUxjHibgdq+RvB/hEA
        lHddImbrgrIWTOXwJxGAoY/psqBB3KQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-ydPFOfIfMsqMl6i22C9HSQ-1; Tue, 06 Sep 2022 18:41:59 -0400
X-MC-Unique: ydPFOfIfMsqMl6i22C9HSQ-1
Received: by mail-il1-f197.google.com with SMTP id d18-20020a056e020c1200b002eaea8e6081so10593389ile.6
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 15:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KaiiwGogUVf/sW/NCZ1A9G8Q7iwk+zy+Q12Kp9/22/g=;
        b=SLVzkqm7AMk00XLNICAkiG8O//GODuy4mXDStky41A1HW6ggJcOlcWysf9x1xW+2PL
         tGC7lI/m2rkra9NxFU9+x7fI624VcyIp2PK+XmtWRtmio7wQOdNx5f8m/+ak9N/7Ij1S
         NhZvj6nSt4wMnor1Qcb0m5ExCWqdJvXA7GK98xxm6eokF1qj42O4E7y2NIqTTv6HClKW
         wC3e+icPz3Sn5jLQIiaEOnQ46fcgR/xKhA2FZ4XysSJgcJIQpMqTUI2rf+GXW8UrRJHp
         KpL61wASu/jvS29jptS49gNTpcFNN5xWv3RP87GSYNXYEPu7avDEB2uGZ/ylskplHHEQ
         K0hQ==
X-Gm-Message-State: ACgBeo3mW69crJnJwmkpIXXsVO3vFGbLGoKVpVQPH0cm+ohDYy1Nk4g1
        Sv1GYV4Z1L4QS+jdeAfVVt1Ot3Gqp0tlYLSnfz1VIrZi899TnvYOejKjTN0nQH3PNAqtUMSuzzW
        bwzHGIwXldVk+
X-Received: by 2002:a05:6e02:102e:b0:2f1:4eca:9a13 with SMTP id o14-20020a056e02102e00b002f14eca9a13mr332476ilj.253.1662504117509;
        Tue, 06 Sep 2022 15:41:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6hgGiqG9jecy+m8uYtmkseWMgh4xJGw+yZ1NW4U1B7crGOGfiqga+xjAaXhVMhE4rplSgpIg==
X-Received: by 2002:a05:6e02:102e:b0:2f1:4eca:9a13 with SMTP id o14-20020a056e02102e00b002f14eca9a13mr332462ilj.253.1662504117277;
        Tue, 06 Sep 2022 15:41:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u15-20020a02b1cf000000b00344c3de5ec7sm6083130jah.150.2022.09.06.15.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 15:41:56 -0700 (PDT)
Date:   Tue, 6 Sep 2022 16:41:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V6 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220906164154.756e26aa.alex.williamson@redhat.com>
In-Reply-To: <20220905105852.26398-6-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
        <20220905105852.26398-6-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Sep 2022 13:58:47 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e05ddc6fe6a5..b17f2f454389 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -108,6 +110,21 @@ struct vfio_migration_ops {
>  				   enum vfio_device_mig_state *curr_state);
>  };
>  
> +/**
> + * @log_start: Optional callback to ask the device start DMA logging.
> + * @log_stop: Optional callback to ask the device stop DMA logging.
> + * @log_read_and_clear: Optional callback to ask the device read
> + *         and clear the dirty DMAs in some given range.

I don't see anywhere in the core that we track the device state
relative to the DEVICE_FEATURE_DMA_LOGGING features, nor do we
explicitly put the responsibility on the driver implementation to
handle invalid user requests.  The mlx5 driver implementation appears
to do this, but maybe we should at least include a requirement here, ex.

   The vfio core implementation of the DEVICE_FEATURE_DMA_LOGGING_ set
   of features does not track logging state relative to the device,
   therefore the device implementation of vfio_log_ops must handle
   arbitrary user requests.  This includes rejecting subsequent calls
   to log_start without an intervening log_stop, as well as graceful
   handling of log_stop and log_read_and_clear from invalid states.

With something like that.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

You can also add my Ack on 3, 4, and (fwiw) 6-10 as I assume this would
be a PR from Leon.  Thanks,

Alex

> + */
> +struct vfio_log_ops {
> +	int (*log_start)(struct vfio_device *device,
> +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
> +	int (*log_stop)(struct vfio_device *device);
> +	int (*log_read_and_clear)(struct vfio_device *device,
> +		unsigned long iova, unsigned long length,
> +		struct iova_bitmap *dirty);
> +};
> +
>  /**
>   * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
>   * @flags: Arg from the device_feature op

