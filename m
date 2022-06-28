Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FB955F0C5
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 23:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiF1V7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 17:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiF1V7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 17:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C7DA22B07
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656453559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0WWZ2h4Ou+3qMEe93oAVSbUord2r1cb1r0isXElizxU=;
        b=JdtYOBgFizAz/a3qmBadfkNf1Is5K7SIDuTwV51pn4L2C2o6jBbPAKVRy+vJfGRYoCdXm0
        xhGx1xB1bRVDBdP6XJTCoyTgX3HgJIKst3gzcWZ9i9/Qr2sSxau8aWLcJPdcJZEZxxQMUv
        QV/gcco8/9aK9B9lVd6T4p1pWFwT4ow=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-BC9dVqFUNFye_z9EpWt68w-1; Tue, 28 Jun 2022 17:59:17 -0400
X-MC-Unique: BC9dVqFUNFye_z9EpWt68w-1
Received: by mail-il1-f198.google.com with SMTP id x5-20020a923005000000b002d1a91c4d13so8086542ile.4
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 14:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0WWZ2h4Ou+3qMEe93oAVSbUord2r1cb1r0isXElizxU=;
        b=X38nPr7zuMmuaQEt1tWWozgxllWuD1luxdTlPw9x2WMicI2LKiiyyuIWq3fC7Jqx98
         U6hXIWYX2xgvedfj0pgszzQ05+rf39xXitIqhoMy8YFbFzy6R0ZDtWVN8h0SKmIa/UCh
         tupZupcmpWaSuoiHqw++LM91XQrJaubWS3G+CMQrNL8eMTHKmR8QMyctMLo8hVEP49hG
         xlJESKL1iVZtmx3xyuJgYbrOhAEGEWaizLkhwO5ZfptLIAuU0af+Jjmm3BMV6rCKpfTG
         2VwRtMQ0jrz8appMWvOO6Uf7IZBQByKtlioIUIn6KGlbCAWs2jHT7i8elu+b2isD/JU3
         D6jQ==
X-Gm-Message-State: AJIora8tM1pgtExAdhd3lQ6YmaJjihpk2Xy6Vzcy0tbzUibTV93vQqWK
        qmtUJFAeP/0Y1W/ScrNM5PZHHd0y3VzipuQQy1dG7R5toI0eeu5h5+E09oATTJB7qI0TvdHnF+U
        ZA1mUP2V3PAs7
X-Received: by 2002:a05:6638:2481:b0:331:df8f:95e0 with SMTP id x1-20020a056638248100b00331df8f95e0mr151521jat.280.1656453557030;
        Tue, 28 Jun 2022 14:59:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uu173+2OVxjSfaHP4q7qPxTBslWKjv/6lZ3otZt97K6XFUw2pYJUvcwU+lNS0e5TZF4qkCKA==
X-Received: by 2002:a05:6638:2481:b0:331:df8f:95e0 with SMTP id x1-20020a056638248100b00331df8f95e0mr151513jat.280.1656453556820;
        Tue, 28 Jun 2022 14:59:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r19-20020a02c853000000b00339dfb793aesm6603705jao.86.2022.06.28.14.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 14:59:16 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:59:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 04/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220628155915.060ba2d9.alex.williamson@redhat.com>
In-Reply-To: <20220628051435.695540-5-hch@lst.de>
References: <20220628051435.695540-1-hch@lst.de>
        <20220628051435.695540-5-hch@lst.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jun 2022 07:14:26 +0200
Christoph Hellwig <hch@lst.de> wrote:
...
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
> index 5c828556cefd7..cea8113d2200e 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -131,6 +131,11 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  	if (!gvt->types)
>  		return -ENOMEM;
>  
> +	gvt->mdev_types = kcalloc(num_types, sizeof(*gvt->mdev_types),
> +			     GFP_KERNEL);
> +	if (!gvt->mdev_types)
> +		goto out_free_types;
> +
>  	min_low = MB_TO_BYTES(32);
>  	for (i = 0; i < num_types; ++i) {
>  		if (low_avail / vgpu_types[i].low_mm == 0)
> @@ -142,7 +147,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  
>  		if (vgpu_types[i].weight < 1 ||
>  					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> -			goto out_free_types;
> +			goto out_free_mdev_types;
>  
>  		gvt->types[i].weight = vgpu_types[i].weight;
>  		gvt->types[i].resolution = vgpu_types[i].edid;
> @@ -150,24 +155,28 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  						   high_avail / vgpu_types[i].high_mm);
>  
>  		if (GRAPHICS_VER(gvt->gt->i915) == 8)
> -			sprintf(gvt->types[i].name, "GVTg_V4_%s",
> +			sprintf(gvt->types[i].type.sysfs_name, "GVTg_V4_%s",
>  				vgpu_types[i].name);
>  		else if (GRAPHICS_VER(gvt->gt->i915) == 9)
> -			sprintf(gvt->types[i].name, "GVTg_V5_%s",
> +			sprintf(gvt->types[i].type.sysfs_name, "GVTg_V5_%s",
>  				vgpu_types[i].name);

Nit, sysfs_name is an arbitrary size, shouldn't we use snprintf() here
to make a good example?

>  		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
> -			     i, gvt->types[i].name,
> +			     i, gvt->types[i].type.sysfs_name,
>  			     gvt->types[i].avail_instance,
>  			     gvt->types[i].low_gm_size,
>  			     gvt->types[i].high_gm_size, gvt->types[i].fence,
>  			     gvt->types[i].weight,
>  			     vgpu_edid_str(gvt->types[i].resolution));
> +
> +		gvt->mdev_types[i] = &gvt->types[i].type;
>  	}
>  
>  	gvt->num_types = i;
>  	return 0;
>  
> +out_free_mdev_types:
> +	kfree(gvt->mdev_types);
>  out_free_types:
>  	kfree(gvt->types);
>  	return -EINVAL;
...
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 9192a21085ce4..25b8d42a522ac 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -95,23 +95,13 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>  }
>  static MDEV_TYPE_ATTR_RO(available_instances);
>  
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>  	&mdev_type_attr_name.attr,
>  	&mdev_type_attr_device_api.attr,
>  	&mdev_type_attr_available_instances.attr,
>  	NULL,
>  };
>  
> -static struct attribute_group mdev_type_group = {
> -	.name  = "io",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group,
> -	NULL,
> -};
> -
>  static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>  {
>  	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
> @@ -654,13 +644,16 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>  	},
>  	.probe = vfio_ccw_mdev_probe,
>  	.remove = vfio_ccw_mdev_remove,
> -	.supported_type_groups  = mdev_type_groups,
> +	.types_attrs = mdev_types_attrs,
>  };
>  
>  int vfio_ccw_mdev_reg(struct subchannel *sch)
>  {
> +	sprintf(sch->mdev_type.sysfs_name, "io");

Here too, but this gets randomly changed to an strcat() in patch 09/
and pretty_name is added in 10/, also with an strcat().  Staying with
snprintf() seems easier to get both overflow and termination.

> +	sch->mdev_types[0] = &sch->mdev_type;
>  	return mdev_register_parent(&sch->parent, &sch->dev,
> -				    &vfio_ccw_mdev_driver);
> +				    &vfio_ccw_mdev_driver, sch->mdev_types,
> +				    1);
>  }
>  
>  void vfio_ccw_mdev_unreg(struct subchannel *sch)
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 834945150dc9f..ff25858b2ebbe 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -537,23 +537,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>  
>  static MDEV_TYPE_ATTR_RO(device_api);
>  
> -static struct attribute *vfio_ap_mdev_type_attrs[] = {
> +static const struct attribute *vfio_ap_mdev_type_attrs[] = {
>  	&mdev_type_attr_name.attr,
>  	&mdev_type_attr_device_api.attr,
>  	&mdev_type_attr_available_instances.attr,
>  	NULL,
>  };
>  
> -static struct attribute_group vfio_ap_mdev_hwvirt_type_group = {
> -	.name = VFIO_AP_MDEV_TYPE_HWVIRT,
> -	.attrs = vfio_ap_mdev_type_attrs,
> -};
> -
> -static struct attribute_group *vfio_ap_mdev_type_groups[] = {
> -	&vfio_ap_mdev_hwvirt_type_group,
> -	NULL,
> -};
> -
>  struct vfio_ap_queue_reserved {
>  	unsigned long *apid;
>  	unsigned long *apqi;
> @@ -1472,7 +1462,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>  	},
>  	.probe = vfio_ap_mdev_probe,
>  	.remove = vfio_ap_mdev_remove,
> -	.supported_type_groups = vfio_ap_mdev_type_groups,
> +	.types_attrs = vfio_ap_mdev_type_attrs,
>  };
>  
>  int vfio_ap_mdev_register(void)
> @@ -1485,8 +1475,11 @@ int vfio_ap_mdev_register(void)
>  	if (ret)
>  		return ret;
>  
> +	strcpy(matrix_dev->mdev_type.sysfs_name, VFIO_AP_MDEV_TYPE_HWVIRT);

And then this might as well be an snprintf() as well too.

Series looks good to me otherwise, hopefully the mdev driver owners
will add some acks.  Thanks,

Alex

