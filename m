Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8995C71810E
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 15:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbjEaNJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 09:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbjEaNIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 09:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FE3E75
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 06:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685538442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XR1Y7uTlBlZpPpTqhSt6hoa8GuKCXSWN+tjCf5DVvbw=;
        b=RofOgSPcpFIFrtpf9x5/yYG4uOMw9quSkKEZZmg7k6nSb0Qf6vTjG904FUXaaTqmwm+TNi
        ETvNRmIhAEUgam/II/PgoLdsl3EwPCFe+MwR/QMjCMhSWwEheMfkPxzb1iG9Bp1zvm/i7T
        Huv47EsnJzBU1l8Buy36wILpS2+VeKg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-cGE1IfanO9ifpYuVCy1xvw-1; Wed, 31 May 2023 09:01:15 -0400
X-MC-Unique: cGE1IfanO9ifpYuVCy1xvw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2af20808e06so30078091fa.2
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 06:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685538074; x=1688130074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XR1Y7uTlBlZpPpTqhSt6hoa8GuKCXSWN+tjCf5DVvbw=;
        b=Kr0gpQgBTZEbDW69uj6OWHlOQHtjpAeLAmwLE5mXtl7ZJCGU4Pj4AUiN/GTazlLgM8
         IgaC7Ly5I/f3n3VgLKDvxmaR7UX3nfZ2IF36Y4Dn1jvn1ZOET/XKmjE6IP4h0Nmdi5Vt
         DLAtZIdh6RoDMCcyU+TWiOmHcVjs4lN0gUZqn9pai7CYiEutQy91mzupki3zItv4HDNB
         X5pOwRMCSsI5k1+Ec2fYyFiP6lzLWZ/5h9ZjwDGCDbCYG3rYs1Ywb38TfBhy37AyZtS4
         JGUkmaxBzFsdSfbDudJBwTz5aMOSHFh8e0NWx1aP2mLSvUwLSIwXSaTY0okGCtY+ELfi
         bLpQ==
X-Gm-Message-State: AC+VfDy9pAFGkIYjjwD+HFTcp5lqTnq0fNvlD35DPA2KM4XP2Vsb/bbt
        QvkU8NqM++2H1k7ND8eyh27J5jrpefI+2N/COmKu7M0arfmB44/kZNBC42ANmZIWPjTn+qXrRT5
        c8JD05Kh+F4aA
X-Received: by 2002:ac2:4d16:0:b0:4e7:dd1e:e521 with SMTP id r22-20020ac24d16000000b004e7dd1ee521mr2699479lfi.9.1685538074048;
        Wed, 31 May 2023 06:01:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6YCZxJTTNZh6g/t1HiIjoxj6FPMPoopmQRHMqaYgGBEE8GvCQf77HNrvRfeg62Qi4NfxTyQQ==
X-Received: by 2002:ac2:4d16:0:b0:4e7:dd1e:e521 with SMTP id r22-20020ac24d16000000b004e7dd1ee521mr2699467lfi.9.1685538073855;
        Wed, 31 May 2023 06:01:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c059300b003f60119ee08sm24268206wmd.43.2023.05.31.06.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 06:01:13 -0700 (PDT)
Message-ID: <e7ec6a4c-2eeb-3a08-5add-a06e250162b6@redhat.com>
Date:   Wed, 31 May 2023 15:01:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] s390/vfio-ap: Wire in the vfio_device_ops request
 callback
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <20230530223538.279198-4-akrowiak@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20230530223538.279198-4-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/23 00:35, Tony Krowiak wrote:
> The mdev device is being removed, so pass the request to userspace to
> ask for a graceful cleanup. This should free up the thread that
> would otherwise loop waiting for the device to be fully released.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 44f159136891..a8f58e133e6e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1736,6 +1736,26 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
>   	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   }
>   
> +static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
> +{
> +	struct device *dev = vdev->dev;
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
> +
> +	if (matrix_mdev->req_trigger) {
> +		if (!(count % 10))
> +			dev_notice_ratelimited(dev,
> +					       "Relaying device request to user (#%u)\n",
> +					       count);
> +
> +		eventfd_signal(matrix_mdev->req_trigger, 1);
> +	} else if (count == 0) {
> +		dev_notice(dev,
> +			   "No device request registered, blocked until released by user\n");
> +	}
> +}
> +
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)
>   {
>   	unsigned long minsz;
> @@ -1955,6 +1975,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>   	.bind_iommufd = vfio_iommufd_emulated_bind,
>   	.unbind_iommufd = vfio_iommufd_emulated_unbind,
>   	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
> +	.request = vfio_ap_mdev_request
>   };
>   
>   static struct mdev_driver vfio_ap_matrix_driver = {

