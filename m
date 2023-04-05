Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF406D7C4D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbjDEMVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 08:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEMVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 08:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB740E0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680697215;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=erf4UNO3fNS9mv22A+JjIcgyW6S0YpQ5DUbNcYGvtZ0=;
        b=Vv4bu1gFUdPCE0hvzS7JGgrxDvPYvsck+PahetuwUkXrcTNPKiWOu+gYzURj+YIKO9beXf
        O9J3ohWquh5LkXs/I4PLyyjDJFkDzf6gIwYrgmtAQ4fnn0JL0g2oSbESDjfSE3nWRrxJsf
        9xWA4dC1BVG5YJD/TZ27Le5o+Oirz+A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-mIvpZW08Ndyt6V2JrHAQ8Q-1; Wed, 05 Apr 2023 08:20:14 -0400
X-MC-Unique: mIvpZW08Ndyt6V2JrHAQ8Q-1
Received: by mail-qv1-f69.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so16085301qvu.20
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 05:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erf4UNO3fNS9mv22A+JjIcgyW6S0YpQ5DUbNcYGvtZ0=;
        b=BvltmPMcExtdsfKaKxjErI6jHcCYfS1/zIf1LiEdjzGzsq0cz6tMBgKMBqb3VpZNxT
         yzidgnrkr7164TpCIaQYCKtKCNy8/FG1m2HlHqsisstYIwdqBQOiMGfNoLIrBsI+qrQ9
         uvdDM3fTwBLqPZUJkxmh/KkTSkmDXSuhf+9EahasLYvq1fWCW5X10EJIcjvmm9cQyj/0
         G7k+qUmEW2WFgsO2Ueg6IEsVMz+uNrTgRTHmpmtj0BNordWSx2FkpzCKxQ8low1rGv9P
         oSYOlIevjxGhy/HBoLnYnVHzINQ0SRCVQuc/oSzsMH87l5IvszmxKbUHfIGlzr/OIg94
         ilIA==
X-Gm-Message-State: AAQBX9cNbOzo6e0On+0LUwfVDM7MDSQpV5qwZFBEOPQ5qTtaO5qSftlu
        YHXHwID4GEEByuPqJ1bD21AvTYaKJJ/AeooFl56F+23ETW4/EZvbkFCKx2OuNP59M6q1g8JQqYU
        anT9O+gnMrzEz
X-Received: by 2002:a05:6214:e6e:b0:56e:f9a2:1aff with SMTP id jz14-20020a0562140e6e00b0056ef9a21affmr7785845qvb.35.1680697213721;
        Wed, 05 Apr 2023 05:20:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350YufqLIW4kTurRmpoStx2boSEtRlVeqT/uSnU6kdOvvAZfwzmAklgvT9NeSB7a7bO7FCPIIzA==
X-Received: by 2002:a05:6214:e6e:b0:56e:f9a2:1aff with SMTP id jz14-20020a0562140e6e00b0056ef9a21affmr7785819qvb.35.1680697213472;
        Wed, 05 Apr 2023 05:20:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l8-20020a0cc208000000b005dd8b9345a2sm4164191qvh.58.2023.04.05.05.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:20:12 -0700 (PDT)
Message-ID: <f90410e0-96f1-9719-9d83-f7caa5992d6d@redhat.com>
Date:   Wed, 5 Apr 2023 14:20:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 03/25] vfio: Remove vfio_file_is_group()
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
 <20230401151833.124749-4-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
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
> since no user of vfio_file_is_group() now.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/group.c | 10 ----------
>  include/linux/vfio.h |  1 -
>  2 files changed, 11 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index ede4723c5f72..4f937ebaf6f7 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -792,16 +792,6 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>  
> -/**
> - * vfio_file_is_group - True if the file is a vfio group file
> - * @file: VFIO group file
> - */
> -bool vfio_file_is_group(struct file *file)
> -{
> -	return vfio_group_from_file(file);
> -}
> -EXPORT_SYMBOL_GPL(vfio_file_is_group);
> -
>  bool vfio_group_enforced_coherent(struct vfio_group *group)
>  {
>  	struct vfio_device *device;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index d9a0770e5fc1..7519ae89fcd6 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -264,7 +264,6 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>   * External user API
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
> -bool vfio_file_is_group(struct file *file);
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);

