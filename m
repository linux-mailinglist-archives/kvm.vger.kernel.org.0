Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE27071B3
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 21:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjEQTN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 15:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjEQTNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 15:13:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21454A5C5
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 12:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684350768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUYw29Zoa6zK25906srnQFhBp6MIgdBaKePMJ7buoyk=;
        b=LuZMGcfI3V3uL0bsqjV65VP0mK4HJo0SXKeeQS8XOrw+yDib1zR/NigbqhQNchGD0VdjKw
        fI15GTeM9N2ek9Ixeq6wgwDNQkUFEC+W9ibXiQHglv/Yp27+ci2wRoxmr7ceR7yUretZfx
        CVqbKk6atadXlyzM0ZrS1IwUT71C3mo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-Ry5hC1NbOsGwzqoNDx5XzA-1; Wed, 17 May 2023 15:12:46 -0400
X-MC-Unique: Ry5hC1NbOsGwzqoNDx5XzA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-763997ab8cdso175990039f.2
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 12:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350765; x=1686942765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kUYw29Zoa6zK25906srnQFhBp6MIgdBaKePMJ7buoyk=;
        b=kpIBCszZ97Y1FdtsDT0ZwPevINt9SpgW24CGOiQ0+umUyLhQ++F9jDGIpmacrQOD5B
         y5U22RJVMHneGQqAKMgDisugROqKPli4Jms+IAVpWAx2ZfZgpErihv/rkV19v8mZl5Xq
         3sb2Xu9TRfkGHff6pjDeS/1pmTuGA6/7XMlnE5FbftM/fYlNGGSYahqvWKeBgp3CewLW
         z0TdPuidP6eWp8yrmFTkLmqxlrjFZqkZmqFhOFvJdN3ZwN8ksgRgpLxy3SDCuYb+D1eg
         qAxlubgVeF2MkFL+goDZWhh4C40l3QP6wzOb7obxUOgvjAyvcNPIZgQCAycNkX0WWKWN
         NWvA==
X-Gm-Message-State: AC+VfDw3urcecv3RDKFIuDg5yZpyec9gpYJh67REvaU8qm5SvtaAvqZB
        Jo9ZVDV7paK0X3jFx1Y4zopp8q2YKhKkR0yarp1bjHkQUIDic6+xcXk4nobWOThx2Gupam8rHDl
        +VySGOQa1Lasa
X-Received: by 2002:a5d:8349:0:b0:769:c95b:29d2 with SMTP id q9-20020a5d8349000000b00769c95b29d2mr5175317ior.15.1684350765742;
        Wed, 17 May 2023 12:12:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6uBqxqAG67zrv6YM/LC+1w6MWWX/cwdvMLlHlj+jf/jYQ8FiDSZBcs0tVU+pbwwdfg9LZu7A==
X-Received: by 2002:a5d:8349:0:b0:769:c95b:29d2 with SMTP id q9-20020a5d8349000000b00769c95b29d2mr5175304ior.15.1684350765494;
        Wed, 17 May 2023 12:12:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r14-20020a02b10e000000b0040fc3543ff2sm8744956jah.84.2023.05.17.12.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:44 -0700 (PDT)
Date:   Wed, 17 May 2023 13:12:43 -0600
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v5 07/10] vfio: Add helper to search vfio_device in a
 dev_set
Message-ID: <20230517131243.7028bf9c.alex.williamson@redhat.com>
In-Reply-To: <20230513132136.15021-8-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-8-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 May 2023 06:21:33 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> There are drivers that need to search vfio_device within a given dev_set.
> e.g. vfio-pci. So add a helper.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |  8 +++-----
>  drivers/vfio/vfio_main.c         | 15 +++++++++++++++
>  include/linux/vfio.h             |  3 +++
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 39e7823088e7..4df2def35bdd 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2335,12 +2335,10 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
>  static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_device_set *dev_set = data;
> -	struct vfio_device *cur;
>  
> -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> -		if (cur->dev == &pdev->dev)
> -			return 0;
> -	return -EBUSY;
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	return vfio_find_device_in_devset(dev_set, &pdev->dev) ? 0 : -EBUSY;

Maybe an opportunity to revisit why this returns -EBUSY rather than
something reasonable like -ENODEV.  It looks like we picked up the
-EBUSY in a882c16a2b7e where I think it was trying to preserve the
return of vfio_pci_try_zap_and_vma_lock_cb() but the return value here
is not even propagated so this looks like an chance to have it make
sense again.  Thanks,

Alex

>  }
>  
>  /*
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f0ca33b2e1df..ab4f3a794f78 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -141,6 +141,21 @@ unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
>  
> +struct vfio_device *
> +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> +			   struct device *dev)
> +{
> +	struct vfio_device *cur;
> +
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		if (cur->dev == dev)
> +			return cur;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_find_device_in_devset);
> +
>  /*
>   * Device objects - create, release, get, put, search
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index fcbe084b18c8..4c17395ed4d2 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -259,6 +259,9 @@ void vfio_unregister_group_dev(struct vfio_device *device);
>  
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>  unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
> +struct vfio_device *
> +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> +			   struct device *dev);
>  
>  int vfio_mig_get_next_state(struct vfio_device *device,
>  			    enum vfio_device_mig_state cur_fsm,

