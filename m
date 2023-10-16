Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F2D7CA105
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 09:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjJPHxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 03:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJPHxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 03:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BD2AD
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 00:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697442767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gd31wjQltRaRKMtxCuA7b8PZltpyuznttFUDFi0zJmk=;
        b=XmdepxTPk46eePj8CZ63eHEr6WROMbJZam4jxD7YsWb9bEeG0zFGA5XghQtVuItcGyqy+m
        4gYpZErMRsEvcTj8rhxNhyM+PWTQ13EOoHYilkkQ7zBge4x1VaMB8HNNJ5FiOKAMy/hHaF
        sQj02LrhCT9yTAohJ7+Q+UD9fVOqX94=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-w4L8-pl4PbS9bQFdnN_E5Q-1; Mon, 16 Oct 2023 03:52:45 -0400
X-MC-Unique: w4L8-pl4PbS9bQFdnN_E5Q-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-77415adf76fso496193085a.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 00:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697442764; x=1698047564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd31wjQltRaRKMtxCuA7b8PZltpyuznttFUDFi0zJmk=;
        b=JCXj+Y6Yv16euMRh2XhvTJ2zpTA9dAEjAhEx4JJoeoRHSOQ/7dJU5P0TjyPIjf8GPL
         3MLgifXrfyM5t/9D8V4b957FvRwJAQJkVl0tE8WDYJ9YX7Lsjqki5M+jZ7vK86ygP/c/
         KOHKNBgU2vE3ZVQw50u7dFBLjd4gThTjPHwjv0XxD8/WpougpOfBVG8dhvArKtQrAg1O
         +Xq+SwtjAQ0F42MPkyx45wZfYcxozuZTW/lbUqwRhFL1TElyMPRZTPIm6xnlnK+ws8il
         hdTBqLvNsUHPFAisjMmx4aEYAhNm23jB+gZYh4XscZGDzBr6kpPy2P3tSpRBYUZGg7zb
         njJg==
X-Gm-Message-State: AOJu0YyHmVnIV4ujbfxDtfanWFbMsgm4/PB79Ucvd1MdXeZCeXHvdVO1
        vQanOOB8DrHx0fmjIwWQ/bfzFZxIxBILdwFzisnxvGYOuOCLlyb9wYT85pMQtAe71m5fIQbzIFf
        aHmn0N65GzWdDyXjPrTcb
X-Received: by 2002:a05:620a:2848:b0:772:64cb:bc64 with SMTP id h8-20020a05620a284800b0077264cbbc64mr40238564qkp.12.1697442764622;
        Mon, 16 Oct 2023 00:52:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEl2/SzdDDVZjUrbwr5gzZZOpok0RU8kRHbed8p9DMVTOZv/ans+kepJDDT4etaHuTttLD3kg==
X-Received: by 2002:a05:620a:2848:b0:772:64cb:bc64 with SMTP id h8-20020a05620a284800b0077264cbbc64mr40238553qkp.12.1697442764336;
        Mon, 16 Oct 2023 00:52:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id r30-20020a05620a03de00b0076ca9f79e1fsm2799111qkm.46.2023.10.16.00.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 00:52:43 -0700 (PDT)
Message-ID: <04d9af1d-e459-4431-bea3-679ade88f7d5@redhat.com>
Date:   Mon, 16 Oct 2023 09:52:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vfio/mtty: Fix eventfd leak
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231013195653.1222141-1-alex.williamson@redhat.com>
 <20231013195653.1222141-2-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231013195653.1222141-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/23 21:56, Alex Williamson wrote:
> Found via kmemleak, eventfd context is leaked if not explicitly torn
> down by userspace.  Clear pointers to track released contexts.  Also
> remove unused irq_fd field in mtty structure, set but never used.

This could be 2 different patches, one cleanup and one fix.
  
> Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   samples/vfio-mdev/mtty.c | 28 +++++++++++++++++++++++-----
>   1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 5af00387c519..0a2760818e46 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -127,7 +127,6 @@ struct serial_port {
>   /* State of each mdev device */
>   struct mdev_state {
>   	struct vfio_device vdev;
> -	int irq_fd;
>   	struct eventfd_ctx *intx_evtfd;
>   	struct eventfd_ctx *msi_evtfd;
>   	int irq_index;
> @@ -938,8 +937,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   		{
>   			if (flags & VFIO_IRQ_SET_DATA_NONE) {
>   				pr_info("%s: disable INTx\n", __func__);
> -				if (mdev_state->intx_evtfd)
> +				if (mdev_state->intx_evtfd) {
>   					eventfd_ctx_put(mdev_state->intx_evtfd);
> +					mdev_state->intx_evtfd = NULL;
> +				}
>   				break;
>   			}
>   
> @@ -955,7 +956,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   						break;
>   					}

Shouln't mdev_state->intx_evtfd value be tested before calling
eventfd_ctx() ?

Thanks,

C.


>   					mdev_state->intx_evtfd = evt;
> -					mdev_state->irq_fd = fd;
>   					mdev_state->irq_index = index;
>   					break;
>   				}
> @@ -971,8 +971,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   			break;
>   		case VFIO_IRQ_SET_ACTION_TRIGGER:
>   			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -				if (mdev_state->msi_evtfd)
> +				if (mdev_state->msi_evtfd) {
>   					eventfd_ctx_put(mdev_state->msi_evtfd);
> +					mdev_state->msi_evtfd = NULL;
> +				}
>   				pr_info("%s: disable MSI\n", __func__);
>   				mdev_state->irq_index = VFIO_PCI_INTX_IRQ_INDEX;
>   				break;
> @@ -993,7 +995,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   					break;
>   				}
>   				mdev_state->msi_evtfd = evt;
> -				mdev_state->irq_fd = fd;
>   				mdev_state->irq_index = index;
>   			}
>   			break;
> @@ -1262,6 +1263,22 @@ static unsigned int mtty_get_available(struct mdev_type *mtype)
>   	return atomic_read(&mdev_avail_ports) / type->nr_ports;
>   }
>   
> +static void mtty_close(struct vfio_device *vdev)
> +{
> +	struct mdev_state *mdev_state =
> +		container_of(vdev, struct mdev_state, vdev);
> +
> +	if (mdev_state->intx_evtfd) {
> +		eventfd_ctx_put(mdev_state->intx_evtfd);
> +		mdev_state->intx_evtfd = NULL;
> +	}
> +	if (mdev_state->msi_evtfd) {
> +		eventfd_ctx_put(mdev_state->msi_evtfd);
> +		mdev_state->msi_evtfd = NULL;
> +	}
> +	mdev_state->irq_index = -1;
> +}
> +
>   static const struct vfio_device_ops mtty_dev_ops = {
>   	.name = "vfio-mtty",
>   	.init = mtty_init_dev,
> @@ -1273,6 +1290,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
>   	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
>   	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
>   	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
> +	.close_device	= mtty_close,
>   };
>   
>   static struct mdev_driver mtty_driver = {

