Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303905B0D54
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 21:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiIGTgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 15:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiIGTgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 15:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6B8BCC02
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 12:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662579359;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpAWAgyga4+TA9fA5HlAdMkYKlmLpnYSbT76a8Tb7hY=;
        b=X7VmqUeONFeA2CIb2q5RE0hmnroKBExrcY3NpTiV5Cs/UQzsqX4MABfFrn1kjREvATQoTG
        iaT2BshRDKEykYCl7UIICGGDzGBz8AGm/eXrmuThLwqIbkmR+zG3Wf2PZhzqtp5SA+BgNd
        a/QnTHbhoKpIGhyRoLjQIyId1Ay+37k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-QB8Cik5YPVykQ3hqgK3NLQ-1; Wed, 07 Sep 2022 15:35:58 -0400
X-MC-Unique: QB8Cik5YPVykQ3hqgK3NLQ-1
Received: by mail-wr1-f69.google.com with SMTP id t12-20020adfa2cc000000b00224f577fad1so3939625wra.4
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 12:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=mpAWAgyga4+TA9fA5HlAdMkYKlmLpnYSbT76a8Tb7hY=;
        b=qk26POBfD6Pqmvk5yuscaRutaGvpPLc1cJeTzUDVYz0DFYcSl2D5ySX2yLDdgMlaU2
         1BFN8qzRsi6/P9CeRPMEu2Z3R/HgwHbw6Z01zLU3GJ5XdL8ONXlSA5rRUwxx9HYY4U4g
         KU3eJWCtO1H95KFXOv2hBXziBjDM+lsJ2gs0GNqNTU/v5vEN73JlPG8rfg8uG6k6fizw
         h5gtVrr/HYKY0e97HFsjuiGUs+I2vKva6O3OjbLVquuhzgRfOwain3Ma36kpYUzsAcHx
         tHtD0MCvHixpVhjszIeZiz25X/+Rr4jmLqeEkVtTQ4Q6NG2OQhWDiSQGcdNX3aHUiLl8
         mrZA==
X-Gm-Message-State: ACgBeo0khn7BNHFQ6uUI1nGdEUEe79Tkc2NgC2hnXkRAMSPpN/84wEmS
        ouSHDj8rJhfOmDxGIFoTS+h18xWvVkNVXIVM4o86fzwfxmm+NS8hqvV9uyI0wYiVXHpQ7+Grpy8
        CS5H799K8iTCX
X-Received: by 2002:a5d:6c62:0:b0:222:cda4:e09e with SMTP id r2-20020a5d6c62000000b00222cda4e09emr3050017wrz.449.1662579356977;
        Wed, 07 Sep 2022 12:35:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7DQVp4ThiLrF8zCJxrYqEfGa4avGnhmnwSWvOSff9WwFAQINELHmvVNNO3IJ11QLwoE6qAfw==
X-Received: by 2002:a5d:6c62:0:b0:222:cda4:e09e with SMTP id r2-20020a5d6c62000000b00222cda4e09emr3049984wrz.449.1662579356689;
        Wed, 07 Sep 2022 12:35:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w4-20020adfee44000000b0022863c18b93sm14810197wro.13.2022.09.07.12.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 12:35:55 -0700 (PDT)
Message-ID: <2ed84b0f-5d60-919f-06a4-a5ede2f98ce5@redhat.com>
Date:   Wed, 7 Sep 2022 21:35:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 14/15] vfio: Rename vfio_device_put() and
 vfio_device_try_get()
Content-Language: en-US
To:     Kevin Tian <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
References: <20220901143747.32858-1-kevin.tian@intel.com>
 <20220901143747.32858-15-kevin.tian@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220901143747.32858-15-kevin.tian@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/1/22 16:37, Kevin Tian wrote:
> With the addition of vfio_put_device() now the names become confusing.
>
> vfio_put_device() is clear from object life cycle p.o.v given kref.
>
> vfio_device_put()/vfio_device_try_get() are helpers for tracking
> users on a registered device.
>
> Now rename them:
>
>  - vfio_device_put() -> vfio_device_put_registration()
>  - vfio_device_try_get() -> vfio_device_try_get_registration()
>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/vfio_main.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 957d9f286550..bfa675d314ab 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -451,13 +451,13 @@ static void vfio_group_get(struct vfio_group *group)
>   * Device objects - create, release, get, put, search
>   */
>  /* Device reference always implies a group reference */
> -static void vfio_device_put(struct vfio_device *device)
> +static void vfio_device_put_registration(struct vfio_device *device)
>  {
>  	if (refcount_dec_and_test(&device->refcount))
>  		complete(&device->comp);
>  }
>  
> -static bool vfio_device_try_get(struct vfio_device *device)
> +static bool vfio_device_try_get_registration(struct vfio_device *device)
>  {
>  	return refcount_inc_not_zero(&device->refcount);
>  }
> @@ -469,7 +469,8 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
>  
>  	mutex_lock(&group->device_lock);
>  	list_for_each_entry(device, &group->device_list, group_next) {
> -		if (device->dev == dev && vfio_device_try_get(device)) {
> +		if (device->dev == dev &&
> +		    vfio_device_try_get_registration(device)) {
>  			mutex_unlock(&group->device_lock);
>  			return device;
>  		}
> @@ -671,7 +672,7 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (existing_device) {
>  		dev_WARN(device->dev, "Device already exists on group %d\n",
>  			 iommu_group_id(group->iommu_group));
> -		vfio_device_put(existing_device);
> +		vfio_device_put_registration(existing_device);
>  		if (group->type == VFIO_NO_IOMMU ||
>  		    group->type == VFIO_EMULATED_IOMMU)
>  			iommu_group_remove_device(device->dev);
> @@ -730,7 +731,7 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
>  			ret = !strcmp(dev_name(it->dev), buf);
>  		}
>  
> -		if (ret && vfio_device_try_get(it)) {
> +		if (ret && vfio_device_try_get_registration(it)) {
>  			device = it;
>  			break;
>  		}
> @@ -750,7 +751,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  	bool interrupted = false;
>  	long rc;
>  
> -	vfio_device_put(device);
> +	vfio_device_put_registration(device);
>  	rc = try_wait_for_completion(&device->comp);
>  	while (rc <= 0) {
>  		if (device->ops->request)
> @@ -1286,7 +1287,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  err_put_fdno:
>  	put_unused_fd(fdno);
>  err_put_device:
> -	vfio_device_put(device);
> +	vfio_device_put_registration(device);
>  	return ret;
>  }
>  
> @@ -1461,7 +1462,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	vfio_device_unassign_container(device);
>  
> -	vfio_device_put(device);
> +	vfio_device_put_registration(device);
>  
>  	return 0;
>  }

