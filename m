Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11A94D2C5D
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiCIJmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiCIJmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 503A91617F8
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 01:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646818896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9ocX7htY9ba2tFChckZrvAN3geRIS+/uGpDxNIPVbs=;
        b=OXSKJXUg5w9FU8TIj13tdtVuaDR25aYMjDqerJvOL2HbhkzNeWb3ptNz1U84YjBiB3eP7d
        yO9mAisVxlup9w4gLo44M28KF/dQAdFTy0Yi3dcl7ZPwoHCzjbAK3e8aOdCt7crT0ZAfh4
        hOQLxhSmJFdoJrGVERtvbtGzw1hC9zM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-33-GjjhIA1mO5SRY_AUB9AU5Q-1; Wed, 09 Mar 2022 04:29:42 -0500
X-MC-Unique: GjjhIA1mO5SRY_AUB9AU5Q-1
Received: by mail-pj1-f72.google.com with SMTP id l14-20020a17090a660e00b001bf496be6d0so1229149pjj.7
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 01:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W9ocX7htY9ba2tFChckZrvAN3geRIS+/uGpDxNIPVbs=;
        b=G8EdBR0bUCXVr/vufIC2BQ1HUsN+1yL40u/epTgsnC4hNisURc57+Ccfvmo5LlNQfa
         OHSC8a0rrZCjQz5wWD9hzePYHjiAjMHhL+Nx49aw9+e2IDh2wzSqbFkeEh8mxU3Ux+/7
         kBGndQ1afzsPpzhutDFQHm/i6UCATogdyhvt/eJm2EPG92Uhf7HJuIo3oIKa0IK474kF
         uxMK9sHPd2oNGPcYr3Dy4IzdL+vAFmdKBu6Ny2RSru71eoUP6P9fHRDzeTanCHNYRT7w
         ou1/Ef7gOgU3pKBxzd43yB7e2pxxnA44A34tpU9OSbz8sB84ejTC+1302SpJZBz7AR7P
         UB5A==
X-Gm-Message-State: AOAM5318O6PxrJKI/2FI/+GDMtoMg/fPzY6kI7u6a74pTBjRqZ1hzfqN
        libIxW+Vnw10OWds0moZqX1081sBu2mN6tuW0SWYHfp11KMpy2WODDeSHvI6g9EB/zum6YnYO5V
        rB1NF0NedsN1F
X-Received: by 2002:a05:6a00:3011:b0:4f6:dca6:ece1 with SMTP id ay17-20020a056a00301100b004f6dca6ece1mr20189425pfb.75.1646818179709;
        Wed, 09 Mar 2022 01:29:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxL+3sp7OJuCEahtHTbhOxVlCpFQIqW2Pb0J6gPCFuY6dSoVpGjvXAebQz9lHsTjjuvBf4aOg==
X-Received: by 2002:a05:6a00:3011:b0:4f6:dca6:ece1 with SMTP id ay17-20020a056a00301100b004f6dca6ece1mr20189408pfb.75.1646818179436;
        Wed, 09 Mar 2022 01:29:39 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm2297184pfu.202.2022.03.09.01.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:29:38 -0800 (PST)
Message-ID: <bd27898f-59bc-215b-bb84-14582b12cb16@redhat.com>
Date:   Wed, 9 Mar 2022 17:29:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 26/26] virtio_net: support set_ringparam
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-27-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-27-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/3/8 下午8:35, Xuan Zhuo 写道:
> Support set_ringparam based on virtio queue reset.
>
> The rx,tx_pending required to be passed must be power of 2.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f1bdc6ce21c3..1fa2d632a994 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2290,6 +2290,52 @@ static void virtnet_get_ringparam(struct net_device *dev,
>   	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
>   }
>   
> +static int virtnet_set_ringparam(struct net_device *dev,
> +				 struct ethtool_ringparam *ring,
> +				 struct kernel_ethtool_ringparam *kernel_ring,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u32 rx_pending, tx_pending;
> +	struct receive_queue *rq;
> +	struct send_queue *sq;
> +	int i, err;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;


Any chance that we may hit this EINVAL?

Thanks


> +
> +	rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
> +	tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
> +
> +	if (ring->rx_pending == rx_pending &&
> +	    ring->tx_pending == tx_pending)
> +		return 0;
> +
> +	if (ring->rx_pending > virtqueue_get_vring_max_size(vi->rq[0].vq))
> +		return -EINVAL;
> +
> +	if (ring->tx_pending > virtqueue_get_vring_max_size(vi->sq[0].vq))
> +		return -EINVAL;
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		rq = vi->rq + i;
> +		sq = vi->sq + i;
> +
> +		if (ring->tx_pending != tx_pending) {
> +			err = virtnet_tx_vq_reset(vi, sq, ring->tx_pending);
> +			if (err)
> +				return err;
> +		}
> +
> +		if (ring->rx_pending != rx_pending) {
> +			err = virtnet_rx_vq_reset(vi, rq, ring->rx_pending);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
>   
>   static void virtnet_get_drvinfo(struct net_device *dev,
>   				struct ethtool_drvinfo *info)
> @@ -2523,6 +2569,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.get_drvinfo = virtnet_get_drvinfo,
>   	.get_link = ethtool_op_get_link,
>   	.get_ringparam = virtnet_get_ringparam,
> +	.set_ringparam = virtnet_set_ringparam,
>   	.get_strings = virtnet_get_strings,
>   	.get_sset_count = virtnet_get_sset_count,
>   	.get_ethtool_stats = virtnet_get_ethtool_stats,

