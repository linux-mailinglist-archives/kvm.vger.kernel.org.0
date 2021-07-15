Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132D23CAE55
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 23:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGOVDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 17:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhGOVDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 17:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626382859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w6cMvV3xGXdKHq4WzPyleEVhevpPRqkhvlCWSt+Y12E=;
        b=UlZ//gQ9Vq9zWrksL/UIApx4nA5S+VDj0vuN0tvDhwpVVekNoeqHLefIFyDzX8Ua1hAzfE
        o/5g8GmTroPI1h0CiwuTxiZ2cLn3XVvuN9FzDidCwwoDysuu5prpyUgQQiOFa4t7KwX0bK
        lJWlOOTuuoxfKut6P177d1pGtODlIUo=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-dJVj_-jmMAuX7V2Y26e3RA-1; Thu, 15 Jul 2021 17:00:58 -0400
X-MC-Unique: dJVj_-jmMAuX7V2Y26e3RA-1
Received: by mail-ot1-f69.google.com with SMTP id e15-20020a9d63cf0000b02904ccb7285c38so1277993otl.14
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 14:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w6cMvV3xGXdKHq4WzPyleEVhevpPRqkhvlCWSt+Y12E=;
        b=ooUKb/6SZqLS5GZOrGiMBNAmNDt5m+KWkZS2c1v/bvS9VRvpFBmfJ85NGQJ+pPt2iD
         VId+NqrGV+5XvBfVCOA/0GZDiZN7KxzRNhW8580iJBUzWrH31KEcSiPbPuJJ4E+Gg6s+
         2dT+WQ7zAkDldCGdDLSOe7t1To4X67ScqqtsQukFIFwP1F8rGXJURbV7txz50MkJg6KG
         fPhTwURd7ozZLXrHoRmLM9AR1jwiFqCnnnDJ/s2Ugxcf/lQ4O7PRxM99UYAhKFtv7yN7
         1E47wpnDbz3auYoluWnVYaIo+ay3dY2Teqq2qlStCUkGVZOfNbmZ6vx+r5bhzj8amkOr
         Fzgg==
X-Gm-Message-State: AOAM532LdJeyk/D065Zirg5618hHxrBLr17xnDElicOeFHKKgiZxC2ss
        e7GtfOtydZBTMlgr8V7zjBAtnA5h/8A+RpEqtS64TJREb13TgCdIiUyjnBnqOaEJvur3DVLZqEl
        4Ejq+ziWrvM7x
X-Received: by 2002:aca:2112:: with SMTP id 18mr9993626oiz.48.1626382857937;
        Thu, 15 Jul 2021 14:00:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhGopnxXSOUkiyj2IazWlzUmam8q3Wm1mG8M1diFnOhbK2stM6MvqH6+i/pmWQg4ZlT4QnEQ==
X-Received: by 2002:aca:2112:: with SMTP id 18mr9993610oiz.48.1626382857721;
        Thu, 15 Jul 2021 14:00:57 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id n9sm1367932otn.54.2021.07.15.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 14:00:57 -0700 (PDT)
Date:   Thu, 15 Jul 2021 15:00:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 09/13] vfio/pci: Reorganize VFIO_DEVICE_PCI_HOT_RESET to
 use the device set
Message-ID: <20210715150055.474f535f.alex.williamson@redhat.com>
In-Reply-To: <9-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
References: <0-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
        <9-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Jul 2021 21:20:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> +/*
> + * We need to get memory_lock for each device, but devices can share mmap_lock,
> + * therefore we need to zap and hold the vma_lock for each device, and only then
> + * get each memory_lock.
> + */
> +static int vfio_hot_reset_device_set(struct vfio_pci_device *vdev,
> +				     struct vfio_pci_group_info *groups)
> +{
> +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> +	struct vfio_pci_device *cur_mem =
> +		list_first_entry(&dev_set->device_list, struct vfio_pci_device,
> +				 vdev.dev_set_list);

We shouldn't be looking at the list outside of the lock, if the first
entry got removed we'd break our unwind code.

> +	struct vfio_pci_device *cur_vma;
> +	struct vfio_pci_device *cur;
> +	bool is_mem = true;
> +	int ret;
>  
> -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> -		vfio_device_put(device);
> -		return -EBUSY;
> +	mutex_lock(&dev_set->lock);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^

> +
> +	/* All devices in the group to be reset need VFIO devices */
> +	if (vfio_pci_for_each_slot_or_bus(
> +		    vdev->pdev, vfio_pci_check_all_devices_bound, dev_set,
> +		    !pci_probe_reset_slot(vdev->pdev->slot))) {
> +		ret = -EINVAL;
> +		goto err_unlock;
>  	}
>  
> -	vdev = container_of(device, struct vfio_pci_device, vdev);
> +	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
> +		/*
> +		 * Test whether all the affected devices are contained by the
> +		 * set of groups provided by the user.
> +		 */
> +		if (!vfio_dev_in_groups(cur_vma, groups)) {
> +			ret = -EINVAL;
> +			goto err_undo;
> +		}
>  
> -	/*
> -	 * Locking multiple devices is prone to deadlock, runaway and
> -	 * unwind if we hit contention.
> -	 */
> -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> -		vfio_device_put(device);
> -		return -EBUSY;
> +		/*
> +		 * Locking multiple devices is prone to deadlock, runaway and
> +		 * unwind if we hit contention.
> +		 */
> +		if (!vfio_pci_zap_and_vma_lock(cur_vma, true)) {
> +			ret = -EBUSY;
> +			goto err_undo;
> +		}
>  	}
>  
> -	devs->devices[devs->cur_index++] = vdev;
> -	return 0;
> +	list_for_each_entry(cur_mem, &dev_set->device_list, vdev.dev_set_list) {
> +		if (!down_write_trylock(&cur_mem->memory_lock)) {
> +			ret = -EBUSY;
> +			goto err_undo;
> +		}
> +		mutex_unlock(&cur_mem->vma_lock);
> +	}
> +
> +	ret = pci_reset_bus(vdev->pdev);
> +


> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> +		up_write(&cur->memory_lock);
> +	mutex_unlock(&dev_set->lock);
> +
> +	return ret;


Isn't the above section actually redundant to below, ie. we could just
fall through after the pci_reset_bus()?  Thanks,

Alex

> +
> +err_undo:
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> +		if (cur == cur_mem)
> +			is_mem = false;
> +		if (cur == cur_vma)
> +			break;
> +		if (is_mem)
> +			up_write(&cur->memory_lock);
> +		else
> +			mutex_unlock(&cur->vma_lock);
> +	}
> +err_unlock:
> +	mutex_unlock(&dev_set->lock);
> +	return ret;
>  }
>  
>  /*

