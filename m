Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD8541524B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbhIVVCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 17:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238085AbhIVVCh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 17:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632344466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EkcI36nWkyMmdwAV3luppztFyqzSlOhfIH0Z+Rmy1YE=;
        b=VT3NmozO3j94IEhNrMP6NpdTUsUs50wyjakj69R7DrWM4lwOHrUk/1SHAMhO17RDI48GZX
        fAOwAZFc80iQaPxKd10TiJnASdpdwO0Z8GA5INZ3vsVPcPz8SqKRIa6aFneJ/U9NR1f/zT
        LVSr6v0JakIXNAcK3jJp+uNwY2+JNy4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-7Mj3MpSmP-OHAZ-DRgsNbw-1; Wed, 22 Sep 2021 17:01:05 -0400
X-MC-Unique: 7Mj3MpSmP-OHAZ-DRgsNbw-1
Received: by mail-oi1-f200.google.com with SMTP id y65-20020aca4b44000000b002719194f1e0so2530693oia.7
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 14:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EkcI36nWkyMmdwAV3luppztFyqzSlOhfIH0Z+Rmy1YE=;
        b=B5VCWdbGbkPROFIiLVST18KXnpEXWb2YUiresStfCsnVWSxIazmR6Sh2U6qA3hYNaz
         eqKzSIG0u5kvJr4Up42UbV87CZvuC0UPf2Hyd7IcSxdhtpBHtf114IgGFnCJ4qTtZmGu
         4u0BeVjcb7Bloi5PeYbrb23hICFW/szzk5jrBnsWvS3iqv7j+m2XhS3Q2VC2itVZ1NQm
         Es6sBQIfkTIOl7yVEox1ZKUoEn7WC9Dui2QOEOLoKo46m+PVCx7r5SB1DwuWULSI2l0x
         r7YNiR9+uBLsIOIJGhjWxTBYR/v/iQDuELx0LZcvVkqEKqNqOUkTgTZTi38G96FsfX5w
         YCrQ==
X-Gm-Message-State: AOAM531OepoaJWizzu/pv8pNVXE9H6666jXOx3I2UsRpON7c6FvUyCET
        /nPGDviyqwTUp4Bea+mWFM56YRwMbjnM2GVsxqydwqwfX6LbIw32BtA/jNyHhN7slUm2UEaZthm
        4zmky7qIcUqI2
X-Received: by 2002:a9d:72db:: with SMTP id d27mr1019221otk.279.1632344464317;
        Wed, 22 Sep 2021 14:01:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1foDmaxSBss0gFC+IJcIZIQhSoVK6YGjP2/EeJFqHN5DuMyQV2c7d4zQ3lhJ0DoWQZHDvuQ==
X-Received: by 2002:a9d:72db:: with SMTP id d27mr1019192otk.279.1632344464096;
        Wed, 22 Sep 2021 14:01:04 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id v4sm696691ott.72.2021.09.22.14.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:01:03 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:01:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20210922150101.5548eb6f.alex.williamson@redhat.com>
In-Reply-To: <20210921172939.GU327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-9-yi.l.liu@intel.com>
        <20210921172939.GU327412@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Sep 2021 14:29:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> > +struct vfio_device_iommu_bind_data {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +	__s32	iommu_fd;
> > +	__u64	dev_cookie;  
> 
> Missing explicit padding
> 
> Always use __aligned_u64 in uapi headers, fix all the patches.

We don't need padding or explicit alignment if we just swap the order
of iommu_fd and dev_cookie.  Thanks,

Alex

