Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D484272D489
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjFLWif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 18:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjFLWie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 18:38:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D07B1701
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686609470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OlsJhktWOpnOGrwPLFGfPFUUuk70SiPk0xbup/yE/10=;
        b=jHB+kTyFz6OA0i8F9K3bV9ClKrVh+46usjWpjds/XVQyMoLIgn1s1YRu2LVk1jMrmWd9C5
        igE6hHN8JPKpCas6K/KSdUd9+ex2QG5CYbplFB9eOsudOymobjDVOKEo8snaOuYAunHJNn
        H/pSgd+SlfWl9hhCXCve16oRNr5yDSE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-kGhLgiTYOfipnbpw6qFoOQ-1; Mon, 12 Jun 2023 18:37:45 -0400
X-MC-Unique: kGhLgiTYOfipnbpw6qFoOQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-777b6a2582dso563987039f.2
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686609464; x=1689201464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OlsJhktWOpnOGrwPLFGfPFUUuk70SiPk0xbup/yE/10=;
        b=gnDkwnVarcgSwt12tJVr0PFypftsPBzne6O+3b6fr0JwAxdIbh2Dj31a5tI86F9iRN
         /p6YKCaMaY3k7TGGhByrG7TWrzjbCa/B4aKPVWlGFDIewhJxzvafgjih0VWerUg108nz
         KROX5EYYGXFRfzz2u0ARq8B7hIwQjbiTxEwcL9017VFgMuTNm3QbkS5Qq8qJ7LNufYUp
         1vgZpB3m8drx91EVCMu88bkK+DzRV/JKrlx1uI/VZ7bHBAet3ot8orIHhks5bVWF4f4k
         h/jfaIuW9nTJdcWfSRo4A1EuT4bc+asZs49yXU3Yq6+QHfVNYdK/hs+OGXlZ2rsNXGGv
         9jSQ==
X-Gm-Message-State: AC+VfDx2eXYcEVKNNwoYb77JGyyLCExR1f+nY4+BIWTO0tdC5E0F9c7t
        wALIlK6h2bg6+w9vXR8hcs+ztMwPBdLDuFM6NLePlpFRkyYfOalWsYkts18a7cUdhz2jL+ErPgz
        H/MKFsxBSZ53N
X-Received: by 2002:a5d:9ad3:0:b0:769:bdaa:a4d9 with SMTP id x19-20020a5d9ad3000000b00769bdaaa4d9mr8400466ion.12.1686609464336;
        Mon, 12 Jun 2023 15:37:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Q/YdMzaOFvhmUbJ9Qg8ZlVUIaIY3sDJYl5DoaZ6J+wwRakiDgr+MX4WPTG6XR/j4s9Jvayw==
X-Received: by 2002:a5d:9ad3:0:b0:769:bdaa:a4d9 with SMTP id x19-20020a5d9ad3000000b00769bdaaa4d9mr8400441ion.12.1686609464083;
        Mon, 12 Jun 2023 15:37:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ep27-20020a0566384e1b00b0041855b3a685sm2990490jab.150.2023.06.12.15.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:37:43 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:37:42 -0600
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
Subject: Re: [PATCH v12 20/24] vfio: Only check group->type for noiommu test
Message-ID: <20230612163742.215eabde.alex.williamson@redhat.com>
In-Reply-To: <20230602121653.80017-21-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-21-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:16:49 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> group->type can be VFIO_NO_IOMMU only when vfio_noiommu option is true.
> And vfio_noiommu option can only be true if CONFIG_VFIO_NOIOMMU is enabled.
> So checking group->type is enough when testing noiommu.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c | 3 +--
>  drivers/vfio/vfio.h  | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 41a09a2df690..653b62f93474 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -133,8 +133,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  
>  	iommufd = iommufd_ctx_from_file(f.file);
>  	if (!IS_ERR(iommufd)) {
> -		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> -		    group->type == VFIO_NO_IOMMU)
> +		if (group->type == VFIO_NO_IOMMU)
>  			ret = iommufd_vfio_compat_set_no_iommu(iommufd);
>  		else
>  			ret = iommufd_vfio_compat_ioas_create(iommufd);
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 5835c74e97ce..1b89e8bc8571 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -108,8 +108,7 @@ void vfio_group_cleanup(void);
>  
>  static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
>  {
> -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> -	       vdev->group->type == VFIO_NO_IOMMU;
> +	return vdev->group->type == VFIO_NO_IOMMU;
>  }
>  
>  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)

This patch should be dropped.  It's logically correct, but ignores that
the config option can be determined at compile time and therefore the
code can be better optimized based on that test.  I think there was a
specific case where I questioned it, but this drops an otherwise valid
compiler optimization.  Thanks,

Alex

