Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D15535EB8
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 12:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350689AbiE0K4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 06:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348329AbiE0Kz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 06:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DFB112E307
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 03:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653648956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGQcppmnDaS/J3TRXiziyA5gL0rtQs0/Sd1uzUmYxEU=;
        b=TX/g3FXr8yz7Z4SKaqizhItgcvzPTwiWs0UnO8RLql2ZHXLrE2lKFmltLJ5ce6ogyCaDhz
        ouvtKFLXGk4YeaN6GwgYLwfU/yQCE1a5tCf2rYiwgU5NI2oGD3uAQplMj+KX0jiUH9ITDp
        5O/lrqM8QeB445XnLCX8/8ysK6lxKYQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-mICj_Q5lOJiHD-CnY87Xaw-1; Fri, 27 May 2022 06:55:55 -0400
X-MC-Unique: mICj_Q5lOJiHD-CnY87Xaw-1
Received: by mail-ed1-f72.google.com with SMTP id b7-20020aa7c6c7000000b0042d3678568dso710248eds.8
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 03:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gGQcppmnDaS/J3TRXiziyA5gL0rtQs0/Sd1uzUmYxEU=;
        b=K6ogDdSghW2MAE2rZX9JmpFEMyt6zY7r1UAGi2dgGOqzIdLWzYbWWHwO4PdKQGn0Mx
         CbI2BjO6qpk51GvGDDAYKrkKR4WQ9RJfFLaxzgE4Sva5PgIhSBFq6KRxl3GNBoRYnRLe
         iKvyGxbfwgGhQ4r5aw2nm18LEc3giAMnILR2ll+VXsSqvt7nvzzMdTmM2OCtSWH7+mh2
         7AGo7B4GrXQZyFM7weSJgAg7QUlBakf6Fcjyr/z2BIDY/MR9vbs08+hoH61gpUEzPuZs
         WzTtBDs87P7CfgoWfpWhZ+6ZTooSL41ZyRwi1JdAhKtpCYZKYMrISRUu65EeetZoer7D
         tAmg==
X-Gm-Message-State: AOAM531S2aRyql5FsWtqpmJY+IaQrj+uvIN0O3993Ch7uV0tkh8O8bhd
        e5ybVfkEGyGYepGJmS3dYXzn5EH/Xh0qCepXXPbcCeEAbm+WEtUpxvkuCGx9aKsBOmtvdOPLBoO
        12ZV6XkrEaJpv
X-Received: by 2002:a17:907:8a03:b0:6fe:c10d:4bf8 with SMTP id sc3-20020a1709078a0300b006fec10d4bf8mr27371046ejc.308.1653648953925;
        Fri, 27 May 2022 03:55:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyjSEByHUT1dN2e6dwR/wwQsgGO85W9JgRso9Wz+PFfyejclX0Yhn5dm9pxNJ4ZMKkOZKFiA==
X-Received: by 2002:a17:907:8a03:b0:6fe:c10d:4bf8 with SMTP id sc3-20020a1709078a0300b006fec10d4bf8mr27371006ejc.308.1653648953659;
        Fri, 27 May 2022 03:55:53 -0700 (PDT)
Received: from redhat.com ([2.55.130.213])
        by smtp.gmail.com with ESMTPSA id fm6-20020a1709072ac600b006fec98edf3asm1318544ejc.166.2022.05.27.03.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:55:53 -0700 (PDT)
Date:   Fri, 27 May 2022 06:55:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Message-ID: <20220527065442-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 12:54:32PM +0000, Parav Pandit wrote:
> 
> 
> > From: Eugenio Pérez <eperezma@redhat.com>
> > Sent: Thursday, May 26, 2022 8:44 AM
> 
> > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > 
> > that backend feature and userspace can effectively stop the device.
> > 
> > 
> > 
> > This is a must before get virtqueue indexes (base) for live migration,
> > 
> > since the device could modify them after userland gets them. There are
> > 
> > individual ways to perform that action for some devices
> > 
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there
> > was no
> > 
> > way to perform it for any vhost device (and, in particular, vhost-vdpa).
> > 
> > 
> > 
> > After the return of ioctl with stop != 0, the device MUST finish any
> > 
> > pending operations like in flight requests. It must also preserve all
> > 
> > the necessary state (the virtqueue vring base plus the possible device
> > 
> > specific states) that is required for restoring in the future. The
> > 
> > device must not change its configuration after that point.
> > 
> > 
> > 
> > After the return of ioctl with stop == 0, the device can continue
> > 
> > processing buffers as long as typical conditions are met (vq is enabled,
> > 
> > DRIVER_OK status bit is enabled, etc).
> 
> Just to be clear, we are adding vdpa level new ioctl() that doesn’t map to any mechanism in the virtio spec.
> 
> Why can't we use this ioctl() to indicate driver to start/stop the device instead of driving it through the driver_ok?
> This is in the context of other discussion we had in the LM series.

If there's something in the spec that does this then let's use that.
Unfortunately the LM series seems to be stuck on moving
bits around with the admin virtqueue ...

-- 
MST

