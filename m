Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCA05E6B8B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiIVTLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiIVTK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE5EB114
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663873854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnhWouSde45ALHbYWXdy8WS/vwDNaUoNBSEjHAFskkU=;
        b=WHyqXmbHL6boLMgIvrfDjZs6lCkPxpaLBjEsPgn2RIcGu+oYQuvgqOYi80PEsKDci2w/i8
        V/EAVUq8Ta/kDTHzMrCvBIn2/uJxgj7EHlmBbxCWFA6zWGKs89tU9qbf+KZQWAL4SyXW6V
        Nj1dMG2nN1btRe/9qsNLoo24rhWQwuM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-ajLP06e1Py-MIb6xERa1QA-1; Thu, 22 Sep 2022 15:10:53 -0400
X-MC-Unique: ajLP06e1Py-MIb6xERa1QA-1
Received: by mail-io1-f70.google.com with SMTP id y187-20020a6bc8c4000000b006a4014e192fso1218717iof.21
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cnhWouSde45ALHbYWXdy8WS/vwDNaUoNBSEjHAFskkU=;
        b=Xade1XZ5rkymbC++nlfKlMJEJyUJ18y5+tLhSKBN+NZzF5c3Zm3xxSbPnejKZOINjJ
         8hufnbv3ZUikM5qPf+O7eBMc9VBSVOytOINKKPUQfCpLjr5GCfpDG3TtCgJKXnJ+uVbR
         JjMUaX6wJbxR0X7P/JIAlRU1j1jQpilt5zb71U+Qefl0QRiDiwawxLoMHNtrsEbS4Hr3
         2YcoAdAVCJZ6HRMu/gHV2QTw3ZBNnzHK2PswerHotkljAvGj461p/Ml26SfkxuqIYxmy
         Y/5QKLTzLn4xpGuWMATg8uoLa1KWxJnzmJvmXhno/LoLmT8ilUwv+wWRdm0LwhNUtRa1
         6ZQA==
X-Gm-Message-State: ACrzQf1bwSWc9g0FdMbbs23gbOoYRppYF0bSh+BiKFJuhJ+3IZ/4veRw
        2h3rnVMRSOXYiXHdbGYzrr2H6LbJvVe/BODiMcrXypjGdDNzBE4LWwNZpG0ijcnJM4jnjFdCraB
        /9ti0rY6vXMst
X-Received: by 2002:a05:6638:1385:b0:35a:723c:2fb3 with SMTP id w5-20020a056638138500b0035a723c2fb3mr2605030jad.222.1663873852784;
        Thu, 22 Sep 2022 12:10:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7OOqQI1ZbCpUd9PIr2GP68ipI3WaHRHanmNIUyWftUVzE+2xlt4tzAiqmWoKUi9DkClCwqog==
X-Received: by 2002:a05:6638:1385:b0:35a:723c:2fb3 with SMTP id w5-20020a056638138500b0035a723c2fb3mr2605021jad.222.1663873852560;
        Thu, 22 Sep 2022 12:10:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f12-20020a02a10c000000b0035b0eeeab89sm2402985jag.10.2022.09.22.12.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:10:52 -0700 (PDT)
Date:   Thu, 22 Sep 2022 13:10:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 2/4] vfio: Move the sanity check of the group to
 vfio_create_group()
Message-ID: <20220922131050.7136481f.alex.williamson@redhat.com>
In-Reply-To: <2-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
References: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
        <2-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Sep 2022 15:44:59 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> __vfio_register_dev() has a bit of code to sanity check if an (existing)
> group is not corrupted by having two copies of the same struct device in
> it. This should be impossible.
> 
> It then has some complicated error unwind to uncreate the group.
> 
> Instead check if the existing group is sane at the same time we locate
> it. If a bug is found then there is no error unwind, just simply fail
> allocation.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 79 ++++++++++++++++++----------------------
>  1 file changed, 36 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 4ab13808b536e1..ba8b6bed12c7e7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -306,15 +306,15 @@ static void vfio_container_put(struct vfio_container *container)
>   * Group objects - create, release, get, put, search
>   */
>  static struct vfio_group *
> -__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> +vfio_group_find_from_iommu(struct iommu_group *iommu_group)
>  {
>  	struct vfio_group *group;
>  
> +	lockdep_assert_held(&vfio.group_lock);
> +
>  	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> -		if (group->iommu_group == iommu_group) {
> -			vfio_group_get(group);
> +		if (group->iommu_group == iommu_group)
>  			return group;
> -		}
>  	}
>  	return NULL;
>  }
> @@ -365,11 +365,27 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>  	return group;
>  }
>  
> +static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
> +{
> +	struct vfio_device *device;
> +
> +	mutex_lock(&group->device_lock);
> +	list_for_each_entry(device, &group->device_list, group_next) {
> +		if (device->dev == dev) {
> +			mutex_unlock(&group->device_lock);
> +			return true;
> +		}
> +	}
> +	mutex_unlock(&group->device_lock);
> +	return false;
> +}
> +
>  /*
>   * Return a struct vfio_group * for the given iommu_group. If no vfio_group
>   * already exists then create a new one.
>   */
> -static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
> +static struct vfio_group *vfio_get_group(struct device *dev,
> +					 struct iommu_group *iommu_group,
>  					 enum vfio_group_type type)
>  {
>  	struct vfio_group *group;
> @@ -378,13 +394,20 @@ static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
>  
>  	mutex_lock(&vfio.group_lock);
>  
> -	ret = __vfio_group_get_from_iommu(iommu_group);
> -	if (ret)
> -		goto err_unlock;
> +	ret = vfio_group_find_from_iommu(iommu_group);
> +	if (ret) {
> +		if (WARN_ON(vfio_group_has_device(ret, dev))) {
> +			ret = ERR_PTR(-EINVAL);
> +			goto out_unlock;
> +		}

This still looks racy.  We only know within vfio_group_has_device() that
the device is not present in the group, what prevents a race between
here and when we finally do add it to group->device_list?  We can't
make any guarantees if we drop group->device_lock between test and add.

The semantics of vfio_get_group() are also rather strange, 'return a
vfio_group for this iommu_group, but make sure it doesn't include this
device' :-\  Thanks,

Alex

