Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2646D7669
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbjDEIJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbjDEIIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:08:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE00B5254
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680682079;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8U/LZFacKxvEJhXlhZDIRP53Ufg1yjOKWtnSX+iUULI=;
        b=f3NzmqA4Z00Bq3B5A8OeKCu7iNGhXFfxDF6Z5InfRWviQHIp2qHZWoqaoRAmagQxDYnX/s
        lIZPsOnyvJni5cIk0TvBeq/Xrk7g88yq2NkGEpkWA0yv9yyggDOof2z4pxRf/VcClUOB1h
        UcjGT/pEd0oFXa4mJd0CvSyEGCKe/1I=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-4DW9EUX2Pn-jG33X3XntHg-1; Wed, 05 Apr 2023 04:07:58 -0400
X-MC-Unique: 4DW9EUX2Pn-jG33X3XntHg-1
Received: by mail-qk1-f198.google.com with SMTP id 72-20020a37064b000000b007467c5d3abeso15863454qkg.19
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680682078;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8U/LZFacKxvEJhXlhZDIRP53Ufg1yjOKWtnSX+iUULI=;
        b=4+KmSyPtHqRi3P89WGnJ8QEk2qx4IXSk/bwQFmBoaCN1Uz/eyN0x9tVKdy8WHSZadG
         InH8W/3eX1Jt3va91uCYg3q2k2wKuP3OsbHO3oIXUY/6WdOKPKXrklhTLN17dNsIC18g
         4rXdrWQrLh1lmUBKS8klGY93GX3q6JLmv/1RWQEwZAHK3hYyvQ9x22MTrJw7q4WbFciU
         8x6sBooGlaOh7jtiIVKiM1F+aqtu4B30LPBfHmnXRrAjidvrAYolhNx0xKuYboxGLhxp
         7T1Y2bbqfq2+zdYhTy1HYjtzqcOD6EoyFWsrDg4g/+7Wbg/I+yXoLl1WyKhItJHtGW1D
         zdFg==
X-Gm-Message-State: AAQBX9cro7pzOe9xQFBjgFMuxe638Pc8oPyBTwCuuh/QACrjAm9i1wpT
        jSzl+55eT0SNbjE+CN8teEvHdIpuOFGhamXwPjnTVFaRSvQ/9FStv6zv8YObaHhGPgYEYEWh7NJ
        r3HXQkzwf/xvd
X-Received: by 2002:a05:6214:27e8:b0:5a9:2bc0:ea8b with SMTP id jt8-20020a05621427e800b005a92bc0ea8bmr8017276qvb.47.1680682077937;
        Wed, 05 Apr 2023 01:07:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZgI1tC1SFeJbsYcH6xJzpDHdFw2Hx/LUgx1rr9zrgKewKcPFylgHGZySRoD8+iCQ6DLLI0oA==
X-Received: by 2002:a05:6214:27e8:b0:5a9:2bc0:ea8b with SMTP id jt8-20020a05621427e800b005a92bc0ea8bmr8017242qvb.47.1680682077580;
        Wed, 05 Apr 2023 01:07:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id mz6-20020a0562142d0600b005dd8b9345e9sm4012411qvb.129.2023.04.05.01.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 01:07:56 -0700 (PDT)
Message-ID: <f92c5f99-f519-e67c-71a9-476f08e4117c@redhat.com>
Date:   Wed, 5 Apr 2023 10:07:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 07/12] vfio: Accpet device file from vfio PCI hot reset
 path
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
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-8-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 16:44, Yi Liu wrote:
> This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> device file from the vfio PCI hot reset.
typo in the title s/Accpet/Accept
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index fe7446805afd..ebbb6b91a498 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1154,13 +1154,23 @@ const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +static struct vfio_device *vfio_device_from_file(struct file *file)
> +{
> +	struct vfio_device *device = file->private_data;
> +
> +	if (file->f_op != &vfio_device_fops)
> +		return NULL;
> +	return device;
> +}
> +
>  /**
>   * vfio_file_is_valid - True if the file is valid vfio file
>   * @file: VFIO group file or VFIO device file
>   */
>  bool vfio_file_is_valid(struct file *file)
>  {
> -	return vfio_group_from_file(file);
> +	return vfio_group_from_file(file) ||
> +	       vfio_device_from_file(file);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>  
> @@ -1174,12 +1184,17 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
>  {
>  	struct vfio_group *group;
> +	struct vfio_device *vdev;
>  
>  	group = vfio_group_from_file(file);
> -	if (!group)
> -		return false;
> +	if (group)
> +		return vfio_group_has_dev(group, device);
> +
> +	vdev = vfio_device_from_file(file);
> +	if (vdev)
> +		return vdev == device;
>  
> -	return vfio_group_has_dev(group, device);
> +	return false;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_has_dev);
>  
With Alex' suggestion
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

