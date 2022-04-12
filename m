Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9AD4FD3D5
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352471AbiDLHgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 03:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354285AbiDLHR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 03:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 016B74B869
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 23:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649746723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4c8Vusl4oEKcTcKekpVxwLN012dQSzoK0Qxc5GtiyU0=;
        b=hyFgESZ3dR3yiJCZuDeBb1Px/x76Z2LmsDYJ/OqN3Hq9CZceoXWEja4XycZlLH+B0Oxxl8
        0pnf5r6bt5H83K7HkRA/yJTGbrjEGQhmNUokoNnfJriJBUpiBKIH/z4QghiJHZ1/iTCos1
        BHYvGlJJJ7AfrWIywke/TRk0Msg3cV0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-T16O2WR1NwmRUc59QZ66Ag-1; Tue, 12 Apr 2022 02:58:33 -0400
X-MC-Unique: T16O2WR1NwmRUc59QZ66Ag-1
Received: by mail-pl1-f198.google.com with SMTP id w14-20020a1709027b8e00b0015386056d2bso7393053pll.5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 23:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4c8Vusl4oEKcTcKekpVxwLN012dQSzoK0Qxc5GtiyU0=;
        b=vzrn4oB5XwJoXhBDOPFjCHBiXDZHtTnYPbFs65rKvJD2G5iQ6xg2PODC6GOl2w4Rhf
         cTGg7XsZ0No92JNBZ6+XuQP1bMFViP61mbMUZw5RFOTsEZp97RLyfCsshUuBNkFy7anS
         PIWLSFJmx6AvRtBcQ38E7Jc1SnrXQD49iiLGhvH/2tpOUkKPnNf5dhvtqe+yOThxSPwC
         kPhglF2Bp2puHEEiiAy/QXahAnSeEJmMs6z4dNuwiPcFF7N9+QKsIVheUzpOSGdi1yep
         aJYUgj/2FavTgV211B5B14VeU1g7MQHi7takZhwFi/u3dAvlYuB80q9M0TTOMOXXdOh0
         6NOg==
X-Gm-Message-State: AOAM531Vyj8K5hTPHpJzof7uYuDBBn57VbnSef8/GbjHXje4dx7X4nPb
        I1x8XbuVRTegS5aFVKyLt46ThqAEZczol0a0O8hpMOPr8EHjPtbXoPvWZV+NOL/sY69AS2k2Z+F
        XDLzaU+FXfws0
X-Received: by 2002:a17:902:ce0a:b0:156:72e2:f191 with SMTP id k10-20020a170902ce0a00b0015672e2f191mr35096124plg.76.1649746712095;
        Mon, 11 Apr 2022 23:58:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuJbdOoWZZRPEbzGsC4VuDhXJvgnJjxW0TEadVGxwoEvQb6fSAp5kYQnQ/9zpsf7VqHx4Bsg==
X-Received: by 2002:a17:902:ce0a:b0:156:72e2:f191 with SMTP id k10-20020a170902ce0a00b0015672e2f191mr35096092plg.76.1649746711844;
        Mon, 11 Apr 2022 23:58:31 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b25-20020a637159000000b00381fda49d15sm1765570pgn.39.2022.04.11.23.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 23:58:31 -0700 (PDT)
Message-ID: <d228a41f-a3a1-029d-f259-d4fbab822e78@redhat.com>
Date:   Tue, 12 Apr 2022 14:58:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 22/32] virtio_pci: queue_reset: extract the logic of
 active vq for modern pci
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-23-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-23-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Introduce vp_active_vq() to configure vring to backend after vq attach
> vring. And configure vq vector if necessary.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_pci_modern.c | 46 ++++++++++++++++++------------
>   1 file changed, 28 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 86d301f272b8..49a4493732cf 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -176,6 +176,29 @@ static void vp_reset(struct virtio_device *vdev)
>   	vp_disable_cbs(vdev);
>   }
>   
> +static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	unsigned long index;
> +
> +	index = vq->index;
> +
> +	/* activate the queue */
> +	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> +	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> +				virtqueue_get_avail_addr(vq),
> +				virtqueue_get_used_addr(vq));
> +
> +	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
> +		msix_vec = vp_modern_queue_vector(mdev, index, msix_vec);
> +		if (msix_vec == VIRTIO_MSI_NO_VECTOR)
> +			return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
>   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>   {
>   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> @@ -220,32 +243,19 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   
>   	vq->num_max = num;
>   
> -	/* activate the queue */
> -	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> -	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> -				virtqueue_get_avail_addr(vq),
> -				virtqueue_get_used_addr(vq));
> +	err = vp_active_vq(vq, msix_vec);
> +	if (err)
> +		goto err;
>   
>   	vq->priv = (void __force *)vp_modern_map_vq_notify(mdev, index, NULL);
>   	if (!vq->priv) {
>   		err = -ENOMEM;
> -		goto err_map_notify;
> -	}
> -
> -	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
> -		msix_vec = vp_modern_queue_vector(mdev, index, msix_vec);
> -		if (msix_vec == VIRTIO_MSI_NO_VECTOR) {
> -			err = -EBUSY;
> -			goto err_assign_vector;
> -		}
> +		goto err;
>   	}
>   
>   	return vq;
>   
> -err_assign_vector:
> -	if (!mdev->notify_base)
> -		pci_iounmap(mdev->pci_dev, (void __iomem __force *)vq->priv);


We need keep this or anything I missed?

Thanks


> -err_map_notify:
> +err:
>   	vring_del_virtqueue(vq);
>   	return ERR_PTR(err);
>   }

