Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A94413B08
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhIUT5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 15:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232143AbhIUT5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 15:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632254165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLzwRXGzw6x+C1v9j0yrnbrduVN9978/t8EjVYLLyME=;
        b=FpItfJjY9ixQKF+Fbik9AlBIbs1uFIbATbRTsueLrWUvjjm4bRXA9HJ6jz3QMYZgXVL2vi
        zkNjZXgAYSQxK9b7gUDm6df+HKHbl6xNnFTwBSJoyB8HbsjzzvHcwgho/TZnHYYdRbebCX
        F4eKp2KT80PXuv0H4ydk6L6DmRkgzVg=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350--MXbpu8SOtqJaLKatUvw8A-1; Tue, 21 Sep 2021 15:56:04 -0400
X-MC-Unique: -MXbpu8SOtqJaLKatUvw8A-1
Received: by mail-ot1-f72.google.com with SMTP id c19-20020a056830001300b00546faa88f0cso25469otp.13
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 12:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLzwRXGzw6x+C1v9j0yrnbrduVN9978/t8EjVYLLyME=;
        b=SSMcuYXEaM6Z1LXcc6e3GcM7nQ29qD50Uji3shCLRx5XE5cxvVIWoVq10GvBKiemSj
         HSCRPbkdZJOy2U/u5ftZrjnD5l1BLF47HIvmgYvCnEVHc40Dx/kQJcJOf6Ql8IkAkIK+
         LmDD32hJmoQU80hW06EYlDe973qG0DiU4xXYjLCBnxlXlgkoum2X7Q/wfy6yaLOD/G9/
         fB0eSShTvibtwms8ux2E1KWhMA9XbWvUtXkNHKVHsxQYPitogMpyonL1KhnpvLoWlSgt
         HaaMz3zuNt7vUCZRYPv0PNPE1PEoUk9lzRxE4hwk1kewn0sCSSbX+mrj0k4inmBhIFly
         arzQ==
X-Gm-Message-State: AOAM533sVrO7fMiSUGHv7Us+732KDct7sDC156CfghIe0ZyOb036c8e8
        mk+9Pxrb3lRs0R9uDWERzerj0XgTZ8EQ96rjRs5ulzXo5J5C3OtastvkdL/z+FerimhcUrfFQ+x
        Y8cgVd/xd0CmX
X-Received: by 2002:a05:6808:57:: with SMTP id v23mr5129809oic.172.1632254164032;
        Tue, 21 Sep 2021 12:56:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoOu2++jQHPmZljv5zNozGgELfd2kP7Ma8jcLIdKYbhKK+ntKv4cH2e/ruocpLeO/GYmaibg==
X-Received: by 2002:a05:6808:57:: with SMTP id v23mr5129791oic.172.1632254163793;
        Tue, 21 Sep 2021 12:56:03 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a8sm471046otv.14.2021.09.21.12.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 12:56:03 -0700 (PDT)
Date:   Tue, 21 Sep 2021 13:56:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20210921135601.3393f51b.alex.williamson@redhat.com>
In-Reply-To: <20210919063848.1476776-3-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-3-yi.l.liu@intel.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Sep 2021 14:38:30 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> userspace to directly open a vfio device w/o relying on container/group
> (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> iommufd (more specifically in iommu core by this RFC) in a device-centric
> manner.
> 
> In case a device is exposed in both legacy and new interfaces (see next
> patch for how to decide it), this patch also ensures that when the device
> is already opened via one interface then the other one must be blocked.
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c  | 228 +++++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h |   2 +
>  2 files changed, 213 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 02cc51ce6891..84436d7abedd 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
...
> @@ -2295,6 +2436,52 @@ static struct miscdevice vfio_dev = {
>  	.mode = S_IRUGO | S_IWUGO,
>  };
>  
> +static char *vfio_device_devnode(struct device *dev, umode_t *mode)
> +{
> +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> +}

dev_name() doesn't provide us with any uniqueness guarantees, so this
could potentially generate naming conflicts.  The similar scheme for
devices within an iommu group appends an instance number if a conflict
occurs, but that solution doesn't work here where the name isn't just a
link to the actual device.  Devices within an iommu group are also
likely associated within a bus_type, so the potential for conflict is
pretty negligible, that's not the case as vfio is adopted for new
device types.  Thanks,

Alex

