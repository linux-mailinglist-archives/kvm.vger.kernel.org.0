Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D069C6F0C1C
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 20:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbjD0SoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 14:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244599AbjD0SoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 14:44:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E32F2D5D
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682621011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PdhbKN3Hq6ATKU2FwFReGd5PqSlgE93t3FlWgzR0mA=;
        b=Daaj1IOrUTl2MBz0BRlb8wY7z9ix2FQwZXMsvkqbPm6PlBOtaK1Ld3ywfFQtBJ7R3t1Yvx
        TzwmCfBXkhR0GoZ2p76FlXa8TZfUJ1XSB34e6SePf0lklC/vGchBPLDZK9hVvJcLMuAXHD
        cpERuv117GhKKD2CjEMl3v/GWPXx7sk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-9bd9UZtBPXW6GVvVRfbfPg-1; Thu, 27 Apr 2023 14:43:29 -0400
X-MC-Unique: 9bd9UZtBPXW6GVvVRfbfPg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-32a7770f504so137804525ab.2
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682621008; x=1685213008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+PdhbKN3Hq6ATKU2FwFReGd5PqSlgE93t3FlWgzR0mA=;
        b=b2sWMZj/1EGNggGXVQaNerNpTWzvdxexZe4GgILifNZQdRDohVB/kLYMa/TmC4GGW3
         23eQneP6EhTHflayzFKZgWfV/v7ibICUsUI5rzBGRJcsoZFuJvb+Jses/NdcoGoXO3XO
         tyD7Zo6jjNc3GRW+dyT9rUyGZHkf3GZSA4Evg3WeQbuTEFO5/995fuO3SZ7aMUDKe2JO
         xbWxHLJYhoEB6ITFXXqAckv4l9Ql6slgx1T8FnIt800u+9rL1Z2vjpiqMOJT/0pvG4Ps
         oRYos5pGinrzCD4dlxkpqcVDhHrhP4EO2CpPZcUS35lvK3qc9NRRNJQwVO+msQ9oVbVR
         Bumw==
X-Gm-Message-State: AC+VfDyR1TV/84yIjhz6VVYpgBjrUW0fL5JUB5ia+22cq7Q7/gCwqu6B
        oJV1C++GS2HhfHY3ityGFVV9D/IZ4jzJ8fv6VL/defhWOGb4cvKCO3qvthboTBrRDLAMssEB1S6
        UPLArPhIUGJs/
X-Received: by 2002:a92:2807:0:b0:32a:b78f:e7d5 with SMTP id l7-20020a922807000000b0032ab78fe7d5mr1938820ilf.27.1682621008596;
        Thu, 27 Apr 2023 11:43:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7UUI5T89n2E0LlOJtzG6NmTPZsvmV0AM+vihZgbau2Vo7OjUcOrWffld+4o1Eu4YBc56YFUA==
X-Received: by 2002:a92:2807:0:b0:32a:b78f:e7d5 with SMTP id l7-20020a922807000000b0032ab78fe7d5mr1938791ilf.27.1682621008333;
        Thu, 27 Apr 2023 11:43:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j8-20020a056638148800b0040fa726ff04sm5845305jak.45.2023.04.27.11.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:43:27 -0700 (PDT)
Date:   Thu, 27 Apr 2023 12:43:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: Re: [PATCH v4 5/9] vfio: Mark cdev usage in vfio_device
Message-ID: <20230427124326.20621b3a.alex.williamson@redhat.com>
In-Reply-To: <20230426145419.450922-6-yi.l.liu@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-6-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Apr 2023 07:54:15 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> Use it to differentiate whether to report group_id or dev_id in revised
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. Though it is not set at this
> moment introducing it now allows us to get hot reset ready for cdev.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  include/linux/vfio.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 4ee613924435..298f4ef16be7 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -63,6 +63,7 @@ struct vfio_device {
>  	bool iommufd_attached;
>  #endif
>  	bool noiommu;
> +	bool cdev_opened;
>  };
>  
>  /**
> @@ -140,6 +141,12 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
>  #endif
>  
> +static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> +{
> +	lockdep_assert_held(&device->dev_set->lock);
> +	return device->cdev_opened;
> +}

The lockdep test doesn't make much sense here, the method of opening
the device can't change from an ioctl called on the device, which is
the only path using this.  If there needs to be a placeholder for
future code, it should probably statically return false here and we can
save adding the structure field and locking checks based on the
semantics of how the field is actually used later.  Thanks,

Alex

