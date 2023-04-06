Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D496D994E
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbjDFOO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 10:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjDFOO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 10:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D717C180
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 07:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680790422;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZqDQDqjyds8VPlocoEi3C0IrbNugg8tUJmM/qJ6sTM=;
        b=Xbbo4tVGcs5qisoWZKu9vVepVZ4ISPgEgJnPSUXd5cdi+sFEm3yfUQ8MU/hVcbTUjX57/M
        nXswK8C5APvvgEGY31teAP1HWILGH3opZiaEB1LdIyktz11MNEQrQSJ2ItKaTWsJlPsKI4
        UEBinJAeTwrp9EFxx4IrNSvaeJRA0T4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-tReaqPCDOYSzoFsx-F7nIQ-1; Thu, 06 Apr 2023 10:13:40 -0400
X-MC-Unique: tReaqPCDOYSzoFsx-F7nIQ-1
Received: by mail-qv1-f71.google.com with SMTP id p14-20020a0cc3ce000000b005e14204a86bso9864413qvi.10
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 07:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680790419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZqDQDqjyds8VPlocoEi3C0IrbNugg8tUJmM/qJ6sTM=;
        b=UsKXyhD6iXN4DrAgCkCvN/1uZpE7Rw1d3oVsU8SfFT4kykisO8VNnivLFgEL13OyhT
         +lSPBbOjlIhhmkKFkUnGoLgCL3h+aQRPfNRdw5u9mfItvRlmTosseWRNuUEUqD+KbjX2
         fCVguyG9KLDSBOCz+JP8uJacnzj7EoFHS8x98qSgAEqRZ/+vYZv1pTx7ZZ0caPz3Ri7L
         q9bsJSc7BpvtXqxSVJ3bhU515AZMEksunH4UTPRD74WXY4u4y9hb9YaS65BDy5hOATns
         R5tIXh9ipAj7abQ1uooCoch+e1zMPOaLDc/dvYeQV0BMdFpBaP117B/VP+nTcMeZ3Iy3
         D0Nw==
X-Gm-Message-State: AAQBX9fjImc/SOkq1Mm+oLAQPg9ZVl6a/K8QH6a+hE0fQThZRlPACPkf
        fV3AZX1QwqTwYTmENFeRj25XusEtuvZ5oYqj48j/C7PJ1ihEi+B9hl8HmiCnhqSZlAUHmv7RDOX
        cht0pCkkd9NHJuG+Gi0rj
X-Received: by 2002:a05:6214:2aab:b0:5ce:7b40:89bd with SMTP id js11-20020a0562142aab00b005ce7b4089bdmr4087291qvb.18.1680790418946;
        Thu, 06 Apr 2023 07:13:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350bO91aKaALXlf/32wwODUUkbjJFfCvulNU+0tH+77KwqRdD7uBXiKVvaUVXOK53XyO/yxSRcA==
X-Received: by 2002:a05:6214:2aab:b0:5ce:7b40:89bd with SMTP id js11-20020a0562142aab00b005ce7b4089bdmr4087239qvb.18.1680790418519;
        Thu, 06 Apr 2023 07:13:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id lv6-20020a056214578600b005dd8b9345cbsm534712qvb.99.2023.04.06.07.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 07:13:37 -0700 (PDT)
Message-ID: <0c51b289-4393-46d5-fb05-a4fc6de92e7b@redhat.com>
Date:   Thu, 6 Apr 2023 16:13:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 09/25] vfio: Add cdev_device_open_cnt to vfio_group
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-10-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 17:18, Yi Liu wrote:
> for counting the devices that are opened via the cdev path. This count
> is increased and decreased by the cdev path. The group path checks it
> to achieve exclusion with the cdev path. With this, only one path (group
> path or cdev path) will claim DMA ownership. This avoids scenarios in
> which devices within the same group may be opened via different paths.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/group.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h  |  3 +++
>  2 files changed, 36 insertions(+)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 71f0a9a4016e..d55ce3ca44b7 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -383,6 +383,33 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
>  	}
>  }
>  
> +int vfio_device_block_group(struct vfio_device *device)
> +{
> +	struct vfio_group *group = device->group;
> +	int ret = 0;
> +
> +	mutex_lock(&group->group_lock);
> +	if (group->opened_file) {
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +
> +	group->cdev_device_open_cnt++;
> +
> +out_unlock:
> +	mutex_unlock(&group->group_lock);
> +	return ret;
> +}
> +
> +void vfio_device_unblock_group(struct vfio_device *device)
> +{
> +	struct vfio_group *group = device->group;
> +
> +	mutex_lock(&group->group_lock);
> +	group->cdev_device_open_cnt--;
> +	mutex_unlock(&group->group_lock);
> +}
> +
>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  {
>  	struct vfio_group *group =
> @@ -405,6 +432,11 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  		goto out_unlock;
>  	}
>  
> +	if (group->cdev_device_open_cnt) {
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +
>  	/*
>  	 * Do we need multiple instances of the group open?  Seems not.
>  	 */
> @@ -479,6 +511,7 @@ static void vfio_group_release(struct device *dev)
>  	mutex_destroy(&group->device_lock);
>  	mutex_destroy(&group->group_lock);
>  	WARN_ON(group->iommu_group);
> +	WARN_ON(group->cdev_device_open_cnt);
>  	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
>  	kfree(group);
>  }
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 854f2c97cb9a..b2f20b78a707 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -83,8 +83,11 @@ struct vfio_group {
>  	struct blocking_notifier_head	notifier;
>  	struct iommufd_ctx		*iommufd;
>  	spinlock_t			kvm_ref_lock;
> +	unsigned int			cdev_device_open_cnt;
>  };
>  
> +int vfio_device_block_group(struct vfio_device *device);
> +void vfio_device_unblock_group(struct vfio_device *device);
>  int vfio_device_set_group(struct vfio_device *device,
>  			  enum vfio_group_type type);
>  void vfio_device_remove_group(struct vfio_device *device);

