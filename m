Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E5053378E
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 09:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiEYHmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiEYHmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 03:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39A8637A0C
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653464567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ys9N/aStuUczJG1d59vIuu5WRFG0fOE8qpuySSttVig=;
        b=Y1Mq76RnixPrGz4G/DcEquxLEzxIHFQLAlvQLNSpDoQqsZO+DfxTtIc7db024C+bBBHzev
        zhX6tFzOKNzSq1HVKFxP0qWWgZL/THbP3jHxXgYx36wLR1uyiteMFagvqyB8hKub3X+HSZ
        kd4JOpLO53+1qi16aV6hQ4+OGGuppFE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-cc1hxuXaPluPwx7h-JzQXg-1; Wed, 25 May 2022 03:42:45 -0400
X-MC-Unique: cc1hxuXaPluPwx7h-JzQXg-1
Received: by mail-qk1-f199.google.com with SMTP id c16-20020ae9e210000000b006a32c6a3830so13133032qkc.12
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ys9N/aStuUczJG1d59vIuu5WRFG0fOE8qpuySSttVig=;
        b=v2B3thnGn8JMThyfbAFORCUrhbYgmwP5ygKTamw3zvJoZHg7QtPYcpeN0symJrRULR
         ZF3vEsm1abapBYhXXhtJrEBP2/d69i3+Yx1fHIXbysUBRSCuPXlHOQr4wVDRZW+foBp0
         hZalYChLrMohXCFQs0swyVgBswS0P5lXFum1BIpaUJuzXo0CF04zZdd5sOV5A9csDsSF
         MwWnQEUybqmZwtB88fcL3vcZlqDNMqfazhZ3pZ0ewFP7nesbbyn4bAMn8tHQrJ9LAdXD
         x0aNpV8J5lFM5uNvDPmlj29FLaS1T4DbvGfA5d5bLFqYnf8QoLdM5RlpKV9Zw1wVfW7T
         ZuCQ==
X-Gm-Message-State: AOAM530gZv1cV3GgLLbK/JKgF/lBs3hgDOwiGabxGF06D3G+jVxYniAO
        KGUBXns9Q0faZveD7TpWxpXDHTnl1zsYOlihz/jN6MR1GnFAFoia4UbJNyJo9Py9Oj2CVoaSvxi
        IspRGo+d/Muf3
X-Received: by 2002:ac8:5813:0:b0:2fa:a441:ba8a with SMTP id g19-20020ac85813000000b002faa441ba8amr2204485qtg.162.1653464565026;
        Wed, 25 May 2022 00:42:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8/milkg51+yfBQTz/8OhX1w5WPXtXVRPuIhObK5HHUAywQzfC8MVhw6rZ751qf/C+5s+Uqg==
X-Received: by 2002:ac8:5813:0:b0:2fa:a441:ba8a with SMTP id g19-20020ac85813000000b002faa441ba8amr2204464qtg.162.1653464564785;
        Wed, 25 May 2022 00:42:44 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id b14-20020ac84f0e000000b002f96db4519csm922248qte.37.2022.05.25.00.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 00:42:44 -0700 (PDT)
Date:   Wed, 25 May 2022 09:41:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>, hanand@xilinx.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        gautam.dawar@amd.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, dinang@xilinx.com,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        pabloc@xilinx.com, lvivier@redhat.com,
        Dan Carpenter <dan.carpenter@oracle.com>, lulu@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, Piotr.Uminski@intel.com,
        martinpo@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>, martinh@xilinx.com
Subject: Re: [PATCH v2 4/4] vdpa_sim: Implement stop vdpa op
Message-ID: <20220525074156.rwyesinlzrza72cn@sgarzare-redhat>
References: <20220524170610.2255608-1-eperezma@redhat.com>
 <20220524170610.2255608-5-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524170610.2255608-5-eperezma@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 07:06:10PM +0200, Eugenio Pérez wrote:
>Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
>that backend feature and userspace can effectively stop the device.
>
>This is a must before get virtqueue indexes (base) for live migration,
>since the device could modify them after userland gets them. There are
>individual ways to perform that action for some devices
>(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
>way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
>After the return of ioctl with stop != 0, the device MUST finish any
>pending operations like in flight requests. It must also preserve all
>the necessary state (the virtqueue vring base plus the possible device
>specific states) that is required for restoring in the future. The
>device must not change its configuration after that point.
>
>After the return of ioctl with stop == 0, the device can continue
>processing buffers as long as typical conditions are met (vq is enabled,
>DRIVER_OK status bit is enabled, etc).
>
>In the future, we will provide features similar to
>VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
> drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> 4 files changed, 28 insertions(+)
>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>index 50d721072beb..0515cf314bed 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
> 	for (i = 0; i < vdpasim->dev_attr.nas; i++)
> 		vhost_iotlb_reset(&vdpasim->iommu[i]);
>
>+	vdpasim->running = true;
> 	spin_unlock(&vdpasim->iommu_lock);
>
> 	vdpasim->features = 0;
>@@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
> 	return 0;
> }
>
>+static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
>+{
>+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>+	int i;
>+
>+	spin_lock(&vdpasim->lock);
>+	vdpasim->running = !stop;
>+	if (vdpasim->running) {
>+		/* Check for missed buffers */
>+		for (i = 0; i < vdpasim->dev_attr.nvqs; ++i)
>+			vdpasim_kick_vq(vdpa, i);
>+
>+	}
>+	spin_unlock(&vdpasim->lock);
>+
>+	return 0;
>+}
>+
> static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> {
> 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>@@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>index 622782e92239..061986f30911 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>@@ -66,6 +66,7 @@ struct vdpasim {
> 	u32 generation;
> 	u64 features;
> 	u32 groups;
>+	bool running;
> 	/* spinlock to synchronize iommu table */
> 	spinlock_t iommu_lock;
> };
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>index 42d401d43911..bcdb1982c378 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>@@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *work)
> 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		goto out;
>
>+	if (!vdpasim->running)
>+		goto out;
>+

Not related to this series, but I think in vdpa_sim_blk.c we should 
implement something similar to what we already do in vdpa_sim_net.c and 
re-schedule the work after X requests handled, otherwise we risk never 
stopping if there are always requests to handle.

Also for supporting multiple queues, that could be a problem, but for 
now we only support one, so there should be no problem.

I have other patches to send for vdpa_sim_blk.c, so if you want I can do 
that in my series.

Thanks,
Stefano

> 	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
> 		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>index 5125976a4df8..886449e88502 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>@@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work)
>
> 	spin_lock(&vdpasim->lock);
>
>+	if (!vdpasim->running)
>+		goto out;
>+
> 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		goto out;
>
>-- 
>2.27.0
>

