Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F123A5A1A8F
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiHYUt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiHYUty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 16:49:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEAB199
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661460592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vCNp8onSsBOOAnD85MiLb1VrhM+q+amfgv6dKZtoeo=;
        b=FC0hA60K1YnyzbQ9Y8LO+KUM1SyWetw+4rn84puJ3M+/BFmK/sQ26aRhmD9ie9+rgx5Kx3
        fjujVdbuxuKmzRIOdGrzuIAjUp3OFi4yqxn5wHy4n0QGFY6Fd7t6tv/0YZQ95xKElJd65T
        hF+ivAXRApyl8XXOyv+fIneqSvoQ5aw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-GP0ljEb2MbaAA01SolcnAA-1; Thu, 25 Aug 2022 16:49:49 -0400
X-MC-Unique: GP0ljEb2MbaAA01SolcnAA-1
Received: by mail-io1-f71.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so7568567ioz.8
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=4vCNp8onSsBOOAnD85MiLb1VrhM+q+amfgv6dKZtoeo=;
        b=55ZRZx5D09ZTy1ID7hzBaWLvCNnhVQsbyWqnG1bEYxhQh6Zy6bi52F++qgUaMgVZcr
         qrwkSMS5n4xXGQK7XXf/iDs6+o/ZOTW5Z0hd4uqqGqye3tpCRPT0UL8cVJiuJInC7gXI
         3iri0s5FZkiWeT4Gn3qnOmkurgKA0qFFzSI8/hzUVKDVoeLJ8JDqR6tCFuPw8rNcPE//
         j/OtuY63KMbYB0OuPsWiuRe4UEHBm6yLfseKujSpvumtqxe+FFiMy/pBtPtPAhLnB1OU
         x8JIphBaFClYYDUK+8U2cBnFd3nwO1JHMRjzAOesFRnLx1AQl8i16xJUqXiVdAdm+4mo
         A6iA==
X-Gm-Message-State: ACgBeo0ZKBH46RESNzm4Z4HM7KSYoo+85p0OHyDHw+sp3oDJksFcY1MU
        5w5TkmNe7jMjwzPZZHK8R1xB6wR6So5Ags+H+rRoIMD2xMQLV7qbSPRaQ+AtH5Sii2mIPFi2H8j
        VKEasp1rpm0pd
X-Received: by 2002:a05:6638:338b:b0:34a:499:c638 with SMTP id h11-20020a056638338b00b0034a0499c638mr2751373jav.87.1661460588992;
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ncR7r2bodD0dv6e5o5tpCa2HHBqoCEgDTRAa3LrjFO0tKio77PfyjOMcNZpw9ftHlfyLjww==
X-Received: by 2002:a05:6638:338b:b0:34a:499:c638 with SMTP id h11-20020a056638338b00b0034a0499c638mr2751362jav.87.1661460588801;
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h12-20020a056602154c00b0068a235db030sm103496iow.27.2022.08.25.13.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:49:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220825144944.237eb78f.alex.williamson@redhat.com>
In-Reply-To: <20220815151109.180403-6-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-6-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Aug 2022 18:11:04 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> +static int
> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> +					 u32 flags, void __user *arg,
> +					 size_t argsz)
> +{
> +	size_t minsz =
> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> +			    bitmap);
> +	struct vfio_device_feature_dma_logging_report report;
> +	struct iova_bitmap_iter iter;
> +	int ret;
> +
> +	if (!device->log_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(report));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&report, arg, minsz))
> +		return -EFAULT;
> +
> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))

Why is PAGE_SIZE a factor here?  I'm under the impression that
iova_bitmap is intended to handle arbitrary page sizes.  Thanks,

Alex

> +		return -EINVAL;
> +
> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
> +				    report.page_size,
> +				    u64_to_user_ptr(report.bitmap));
> +	if (ret)
> +		return ret;
> +
> +	for (; !iova_bitmap_iter_done(&iter) && !ret;
> +	     ret = iova_bitmap_iter_advance(&iter)) {
> +		ret = device->log_ops->log_read_and_clear(device,
> +			iova_bitmap_iova(&iter),
> +			iova_bitmap_length(&iter), &iter.dirty);
> +		if (ret)
> +			break;
> +	}
> +
> +	iova_bitmap_iter_free(&iter);
> +	return ret;
> +}

