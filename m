Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FAE3F90A4
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbhHZWVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:21:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhHZWVo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 18:21:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630016456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E45zJc4oH06emd8/Yu3NtU7GehJdnqxTJyDZ7X6eE2A=;
        b=SeyH9ktsRFi/mTRxrBQI6+RHuHD0wuP9ieSr6oDAAey2I2qY5XkPg6gMn3ShbPXAlC9bj8
        oGqiT89yx8E9fwItKnOW+nYjy2Qj74p91Yw3MvT0uYmM3LnpIJHOvdkPTJpj3PMeRfppZd
        ogAWE9jyPZybRIMYFOg/+tMc/6qJCGs=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-Rx7fD8bMOZ6lFk04cr1Yxg-1; Thu, 26 Aug 2021 18:20:54 -0400
X-MC-Unique: Rx7fD8bMOZ6lFk04cr1Yxg-1
Received: by mail-oo1-f70.google.com with SMTP id 68-20020a4a0d47000000b0028fe7302d04so2057032oob.8
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E45zJc4oH06emd8/Yu3NtU7GehJdnqxTJyDZ7X6eE2A=;
        b=Y5la9MP0QTg84a+hWzYjgsUYsNnud4LCWy2ITr11z+c6KYdTd6UkHRCDdu0ettwDOt
         ZRI7x9IzgA1nKtrZ5lfc3ZMY8jktzRlIzb9+j/WCTEL7678RgI1FyCtoNw6gz0kJjQ/d
         t3Zf8MTmfJjZ6hrNU2qpIxbRlBADesotw1aPpA3ZJcij8AcCEVgS1RrI8YLqTBUEHVlO
         /PuxK0pD5gzqN9I40h8DAJ4zZwrJgEOrJpfFmaOoV6hTtEfNpTvA2BrG4wTTBvHw7tGU
         zq0L93jg2jOWep0+A+acnJZKYOT6TeZPDHHzVpfD33vRww9wKJoZbfpnCt+2nR4eGfOP
         ifNw==
X-Gm-Message-State: AOAM531KUNSLAhJzDJwbl9NSxuqtwgIvRnDVGHUOnWZcA4+90qsDNWUC
        qZqOHYvB3pBUTx9m34Vu13D0qhJslU6/F4AESCK7+8CRDPdow6kzLTnrAzqgDXFyhDsSarc2O6I
        6NO0jKRAZHR/q
X-Received: by 2002:a05:6808:2114:: with SMTP id r20mr8550375oiw.110.1630016454216;
        Thu, 26 Aug 2021 15:20:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV5g6FNgRXBdSqttIdFMv3Sr3DrKeu9HRoTkffbcSn69IA92vPaVYUw5wDBA60+nwRvHURiQ==
X-Received: by 2002:a05:6808:2114:: with SMTP id r20mr8550358oiw.110.1630016454035;
        Thu, 26 Aug 2021 15:20:54 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a15sm842242otq.13.2021.08.26.15.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:20:53 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:20:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use
 vfio_register_group_dev()
Message-ID: <20210826162052.4e510767.alex.williamson@redhat.com>
In-Reply-To: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Aug 2021 11:42:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is straightforward conversion, the ap_matrix_mdev is actually serving
> as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> simple container_of() or a dev_get_drvdata() for sysfs paths.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
>  drivers/s390/crypto/vfio_ap_private.h |   2 +
>  2 files changed, 91 insertions(+), 66 deletions(-)

Applied proposed port to Tony's series to vfio next branch for v5.15.
Thanks,

Alex

