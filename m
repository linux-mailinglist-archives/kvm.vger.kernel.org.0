Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6914F526840
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 19:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382950AbiEMRXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 13:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382923AbiEMRXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 13:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A63D06FA05
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 10:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652462627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FrsyeLVbUblbq1nilfyr14YJP5SGJc2cuYqB6u7Y70=;
        b=b9826e5b9Ug2b5t8ka6L9z5iZJF2JpzuX7oWihHptEVmQtxyYQ44pUPX9c7IJ3AVH1EB+Y
        wxw7cpcrqjfK4GW/6bl9YCT+7OqS64sEPYlVUj644JKbJWnCgtnvvDpEzotZkOooYXKO3T
        gQIMTheKnv0PmtzlAgFL5c2LIxkYyM8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-K7bOjQinN_S_Z9OCCs0kMQ-1; Fri, 13 May 2022 13:23:46 -0400
X-MC-Unique: K7bOjQinN_S_Z9OCCs0kMQ-1
Received: by mail-il1-f197.google.com with SMTP id j4-20020a92c204000000b002caad37af3fso5531766ilo.22
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 10:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9FrsyeLVbUblbq1nilfyr14YJP5SGJc2cuYqB6u7Y70=;
        b=RrGa+g9U8SLKiYA9IT5OXJvEKv6YnULKRvrmUnEXGUNyIdhFmp5BmjTV2drJQN489i
         e5xN9GeXquFshm3LcM3wJAEzfuFo82D/PObu0lZpI5R+7ZO/pBY4whOamdw6YXb87jyK
         CYumbAjzwR7McLsnjPYn0Hk0DQwl2QAwZJPyqBSIOLLSkHHrY+1vYeOdjpeOIKuXvZfe
         qrn5ErLWdIe35wWM5rmR9MeBml7N1ynwESAuPhg81mq9YyALNJvDknFeBvDe9JirO7v+
         cNOLzEU8Uu9UzuSA6I7eRCHfd8JXpb7O/mPNcgXI6kkWXNeT+zop5OjJBVHFAmaIwZlc
         iAIQ==
X-Gm-Message-State: AOAM531gzRqm5p0nT8os9T2zp+abJnOqT48spjbzirPBSDSxtCfAj2iQ
        7DtVo5iXm6J7+hiQZFFcU+H6A3L9qMaJIYDifBwtrgds3Rt409eCM6QkcrwtadYznLXZRX2/8kM
        gHe9S4EQcDH/F
X-Received: by 2002:a05:6e02:15ca:b0:2bf:ad58:4a6d with SMTP id q10-20020a056e0215ca00b002bfad584a6dmr3278747ilu.13.1652462625744;
        Fri, 13 May 2022 10:23:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIHVIOTlmSlf69/m0ZOrIz35Oq+OCsuLpzQtmBjch4Kxc4BgIod4rJfvzF76VBh7Ev5XWX2g==
X-Received: by 2002:a05:6e02:15ca:b0:2bf:ad58:4a6d with SMTP id q10-20020a056e0215ca00b002bfad584a6dmr3278739ilu.13.1652462625494;
        Fri, 13 May 2022 10:23:45 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id l19-20020a056e02067300b002cbed258dcfsm757428ilt.0.2022.05.13.10.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 10:23:45 -0700 (PDT)
Date:   Fri, 13 May 2022 11:23:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH] vfio: Delete container_q
Message-ID: <20220513112342.75146994.alex.williamson@redhat.com>
In-Reply-To: <0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com>
References: <0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Apr 2022 15:46:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Now that the iommu core takes care of isolation there is no race between
> driver attach and container unset. Once iommu_group_release_dma_owner()
> returns the device can immediately be re-used.
> 
> Remove this mechanism.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> This was missed in Baolu's series, and applies on top of "iommu: Remove iommu
> group changes notifier"
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 0c766384cee0f8..4a1847f50c9289 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -74,7 +74,6 @@ struct vfio_group {
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
>  	atomic_t			opened;
> -	wait_queue_head_t		container_q;
>  	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
>  	struct kvm			*kvm;
> @@ -363,7 +362,6 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>  	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
> -	init_waitqueue_head(&group->container_q);
>  	group->iommu_group = iommu_group;
>  	/* put in vfio_group_release() */
>  	iommu_group_ref_get(iommu_group);
> @@ -723,23 +721,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  	group->dev_counter--;
>  	mutex_unlock(&group->device_lock);
>  
> -	/*
> -	 * In order to support multiple devices per group, devices can be
> -	 * plucked from the group while other devices in the group are still
> -	 * in use.  The container persists with this group and those remaining
> -	 * devices still attached.  If the user creates an isolation violation
> -	 * by binding this device to another driver while the group is still in
> -	 * use, that's their fault.  However, in the case of removing the last,
> -	 * or potentially the only, device in the group there can be no other
> -	 * in-use devices in the group.  The user has done their due diligence
> -	 * and we should lay no claims to those devices.  In order to do that,
> -	 * we need to make sure the group is detached from the container.
> -	 * Without this stall, we're potentially racing with a user process
> -	 * that may attempt to immediately bind this device to another driver.
> -	 */
> -	if (list_empty(&group->device_list))
> -		wait_event(group->container_q, !group->container);
> -
>  	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
>  		iommu_group_remove_device(device->dev);
>  
> @@ -984,7 +965,6 @@ static void __vfio_group_unset_container(struct vfio_group *group)
>  	iommu_group_release_dma_owner(group->iommu_group);
>  
>  	group->container = NULL;
> -	wake_up(&group->container_q);
>  	list_del(&group->container_next);
>  
>  	/* Detaching the last group deprivileges a container, remove iommu */
> 
> base-commit: 46788c84354d07f8b1e5df87e805500611fd04fb

Applied to vfio next branch for v5.19.  Thanks,

Alex

