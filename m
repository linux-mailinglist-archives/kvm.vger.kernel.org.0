Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0D356238B
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbiF3Twe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbiF3Twd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A647F44752
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0+2pDdUaNGzjBJmwVT+QiGeQZhQhYLIiJRnkL/vTGVI=;
        b=NYq1ibEkGck8q1dY5rqD7qFm0764rXP6Yv7vOswply669NKPVoY1NGQeATw+dqAh5lgHeH
        fzG6E2p3CixPglHzXlqjymEA6gsa0/xkKiWf1J4XFwgcGWMDP44tvkgYU9GSPodTXT4Uqm
        EeVj7DxMhlgs4GdghFQ0dUEr/fT/d0I=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-b_vqNAP0Nqat9hAIsLyNmQ-1; Thu, 30 Jun 2022 15:52:30 -0400
X-MC-Unique: b_vqNAP0Nqat9hAIsLyNmQ-1
Received: by mail-il1-f197.google.com with SMTP id j17-20020a056e02219100b002d955e89a54so41734ila.11
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0+2pDdUaNGzjBJmwVT+QiGeQZhQhYLIiJRnkL/vTGVI=;
        b=ztDYQFCECNpJfH5yTitu1vQi9YIevIHqHfrpgPhssIQlKVE4PQ7Mmpqc/+1CIBqUHn
         3dGFq1BiF2XqWJEI9jMSM7jplSJQNvT9Mu1S2mB3cJ4tYxaVKsTVFclpGHOCCB0Fbpjt
         SkvbWnxpFt5QOG9P2Y7iwsTyFQdTY3uBCvDYvnJYxEuI/Yh1LQ7mVbxa+IBRXb2l2/g+
         /lMZQZi7IwDKbkAw89dQq2gyHsGWD1BmBahrXUPjc2kcWa0UVTHzrbrgV7QKQIaT6jll
         JiR9rsOZ4iz7OAk2t3yc+wOucOZDOLqYRdJxbUu0BT8OfPkSF6yMQgnlaoPmG/9VW1l+
         Rqbg==
X-Gm-Message-State: AJIora+C2oq7WlcFbxOcKgQIxU+CKcv3olS/rPNK1mWoJUNvu2PjTtM8
        dzsZEnx/d0X8PmRmOnDEQrG1Y/7eCKNj535Yusb8gSOklEHAc2EqiLcMiZ+yUOVg21LI/OyVwUL
        a4OLQSChHRnew
X-Received: by 2002:a05:6e02:20c9:b0:2d9:4742:9411 with SMTP id 9-20020a056e0220c900b002d947429411mr6103408ilq.302.1656618749679;
        Thu, 30 Jun 2022 12:52:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tyxOEYoou7g3Aqa2+pRm3Tv100NCPw5gFaScNbg4+85uoTACNtk8ArIZ5jNpbwvu83s2P0EQ==
X-Received: by 2002:a05:6e02:20c9:b0:2d9:4742:9411 with SMTP id 9-20020a056e0220c900b002d947429411mr6103399ilq.302.1656618749435;
        Thu, 30 Jun 2022 12:52:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:28 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     kevin.tian@intel.com, kvm@vger.kernel.org, jgg@nvidia.com,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Message-ID: <20220630135138.0fee6b32.alex.williamson@redhat.com>
In-Reply-To: <20220627074119.523274-1-yi.l.liu@intel.com>
References: <20220627074119.523274-1-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 00:41:19 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> We do not protect the vfio_device::open_count with group_rwsem elsewhere (see
> vfio_device_fops_release as a comparison, where we already drop group_rwsem
> before open_count--). So move the group_rwsem unlock prior to open_count--.
> 
> This change now also drops group_rswem before setting device->kvm = NULL,
> but that's also OK (again, just like vfio_device_fops_release). The setting
> of device->kvm before open_device is technically done while holding the
> group_rwsem, this is done to protect the group kvm value we are copying from,
> and we should not be relying on that to protect the contents of device->kvm;
> instead we assume this value will not change until after the device is closed
> and while under the dev_set->lock.
> 
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---

Applied to vfio next branch for v5.20.  Thanks,

Alex

> v2:
> - Remove Fixes tag (Kevin)
> - Add detailed description in commit message (Matthew, Jason)
> - Fix patch format (Jason)
> - Add r-b from Matthew
>  
> v1:
> https://lore.kernel.org/kvm/20220620085459.200015-2-yi.l.liu@intel.com/
> ---
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..44c3bf8023ac 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1146,10 +1146,10 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  	if (device->open_count == 1 && device->ops->close_device)
>  		device->ops->close_device(device);
>  err_undo_count:
> +	up_read(&device->group->group_rwsem);
>  	device->open_count--;
>  	if (device->open_count == 0 && device->kvm)
>  		device->kvm = NULL;
> -	up_read(&device->group->group_rwsem);
>  	mutex_unlock(&device->dev_set->lock);
>  	module_put(device->dev->driver->owner);
>  err_unassign_container:

