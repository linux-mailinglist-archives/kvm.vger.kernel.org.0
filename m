Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DB6D6E1F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbjDDUcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjDDUcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:32:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E9E44B6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680640293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XqS1tmmJr7PAF8X4LNYoZBpPsb/UgoghZYeXc9m09Fg=;
        b=anJAqy4yXUEjiFsX1oilflu/Cd/fjYkmdqQo3f+fxJttg8GtX+4MuaqobfERp+StK8C56W
        aNUt7k4Ki4KQq92VataAcah04s6SQ842TfGs8Aq0Kv/lIFGFov/+gM+NVS7JUDrq4wsEXf
        VKoJsUYoOyso1S/rdQnXuyAdDE2filo=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-DfRV-VRFOCG6SOova7wUPA-1; Tue, 04 Apr 2023 16:31:31 -0400
X-MC-Unique: DfRV-VRFOCG6SOova7wUPA-1
Received: by mail-io1-f70.google.com with SMTP id g7-20020a056602242700b00758e7dbd0dbso21375362iob.16
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 13:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680640291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqS1tmmJr7PAF8X4LNYoZBpPsb/UgoghZYeXc9m09Fg=;
        b=OpCU81XbHS5w3248WlKkNZF03UNlICtxECg2SRvVUMh52DPRQ9v3wJKcN0ejfZ15OE
         3vHJjywnRBr770Ly1kMxbS/vvSdbD8DnTufSWkuOcJ4BaNQVCfEP8fgqIQDcIXKJAD92
         rbbLGNVOwOlfBxIEwJTHN8WoQOMZLzUy/RQbgZgvRQlNDsUYTStCN6+1ANgwPgu1U/4b
         QIu9RTiIgFyaTyt3B8lqBlBppKJdyPeoUyXVTOJJkrFriz7d+jXVB4kW9Asyjjop/0df
         9DsOXq0WzD8q2USU+K9J2Ojb6A+8AtB0eNJ1UPACFPioIRU5DP2UhEs+D4JraparG5bh
         TgWA==
X-Gm-Message-State: AAQBX9eKCf2vQki8RvxJ6PNp49xDatDHfl2RDzjUWsEBB+4qzZRVu1yP
        pda5Dgw+KhfVLRplQUDqlwMinneDOtHGSZBCGFpMfPEr669tS0okzgKa89avKGcg1Y4TPeLdQw6
        GNmKzi5ktECwx
X-Received: by 2002:a5d:818e:0:b0:75c:8ca2:c9dd with SMTP id u14-20020a5d818e000000b0075c8ca2c9ddmr3054668ion.13.1680640290847;
        Tue, 04 Apr 2023 13:31:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZjUtpAYCx6yaQp4dhQD6EMAb3LqUkY7lWvfjoqBYl2aC4WHyIt9JLMzzeXtpK9Oh7S0irxFA==
X-Received: by 2002:a5d:818e:0:b0:75c:8ca2:c9dd with SMTP id u14-20020a5d818e000000b0075c8ca2c9ddmr3054643ion.13.1680640290625;
        Tue, 04 Apr 2023 13:31:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j195-20020a0263cc000000b003b331f0bbdfsm3476000jac.97.2023.04.04.13.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:31:30 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:31:28 -0600
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 07/12] vfio: Accpet device file from vfio PCI hot
 reset path
Message-ID: <20230404143128.52d8a256.alex.williamson@redhat.com>
In-Reply-To: <20230401144429.88673-8-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-8-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  1 Apr 2023 07:44:24 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> device file from the vfio PCI hot reset.
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

Nit, unless we expect to be testing against NULL devices, this could
just be:

	return device == vfio_device_from_file(file);

Thanks,
Alex

