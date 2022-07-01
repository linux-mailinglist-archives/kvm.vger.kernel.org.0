Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7374356302C
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiGAJdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiGAJdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF4A41054F
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656667996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5mtGmTe8EOGM3d6UvtPR8foUzN0Vd8FdOhETeQJNPM=;
        b=MReX2+Xlzcs8C5oKn9ZuHZ6QFf6aPTcoSbiUuAHB8mwcZz/w36GrqfX45skiZ36HZgDcGz
        N87XzzZA48s1qzGmzrzpRqCGVlmu0CnN953nQFQ3aiiPPHEUxAUINKC6BoC/R26gElrO+3
        9D9KFV6Tx7vAs/NYHnKFlGc/1ouGzXQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-jaAopuqMOiy9KEIbhh1s0g-1; Fri, 01 Jul 2022 05:33:12 -0400
X-MC-Unique: jaAopuqMOiy9KEIbhh1s0g-1
Received: by mail-pg1-f199.google.com with SMTP id r142-20020a632b94000000b0040c978aef47so1060053pgr.10
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 02:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f5mtGmTe8EOGM3d6UvtPR8foUzN0Vd8FdOhETeQJNPM=;
        b=sz5NPvEdvBZUhcDXBKKEN2qN0AUHEkbA73U9RVc9xUlf2RK7akhsXKERJ7m3VOSRVS
         Qucjc91tP4nryGL6OeJf8bS9JiT6/Ik5R4djamLtc0x/qRmpVCZGW3J5FuwUTP/OsNSn
         d0i24TmNrgyTC39B0chKFbibRRUm76f/SRQAF5wyf4/y5aBvXED8vUDY++FO2bqaYLhA
         rUCaWh5mXHJEEkCWWrdDk7i9KeLSVBWhlKdmMtKD8tyn3Gt39dR8aV5YvTL3twOFLU/c
         K0zW55VZB8vdouuFivdlNxB8XwShzVPMjQ3WVzUnFzy540Q50OnDxizFs+m/ID4VkvyG
         qkaA==
X-Gm-Message-State: AJIora/sgcoJkWzAhZv99Urhw+95wlFP7t5aKC7Lrc8QZxMaNDgouoO/
        hrDA/zyfb0zptl9ENpnkOool+o0gTYZA6HItn5zQKviRo+2SJqZRdFpZ9pgiG+WQQT27H/1gMkU
        vAPouaaH1Rsfm
X-Received: by 2002:a17:90b:4a0c:b0:1ec:d90c:601d with SMTP id kk12-20020a17090b4a0c00b001ecd90c601dmr15636512pjb.154.1656667991668;
        Fri, 01 Jul 2022 02:33:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tVe2pzm2DqVb3UijAovoeTNBz5xv7L4VqCc/Ur/3iGdxZa8PDpPNxiGPMy4N7soHRJKb82Vw==
X-Received: by 2002:a17:90b:4a0c:b0:1ec:d90c:601d with SMTP id kk12-20020a17090b4a0c00b001ecd90c601dmr15636485pjb.154.1656667991387;
        Fri, 01 Jul 2022 02:33:11 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902714400b0015e8d4eb28fsm15068862plm.217.2022.07.01.02.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:33:10 -0700 (PDT)
Message-ID: <f35fdd60-8f69-6004-dd00-62e5fe8a8856@redhat.com>
Date:   Fri, 1 Jul 2022 17:33:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 23/40] virtio_pci: move struct virtio_pci_common_cfg
 to virtio_pci_modern.h
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-24-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-24-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
> In order to facilitate the expansion of virtio_pci_common_cfg in the
> future, move it from uapi to virtio_pci_modern.h. In this way, we can
> freely expand virtio_pci_common_cfg in the future.
>
> Other projects using virtio_pci_common_cfg in uapi need to maintain a
> separate virtio_pci_common_cfg or use the offset macro defined in uapi.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   include/linux/virtio_pci_modern.h | 26 ++++++++++++++++++++++++++
>   include/uapi/linux/virtio_pci.h   | 26 --------------------------
>   2 files changed, 26 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index eb2bd9b4077d..c4f7ffbacb4e 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -5,6 +5,32 @@
>   #include <linux/pci.h>
>   #include <linux/virtio_pci.h>
>   
> +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> +struct virtio_pci_common_cfg {
> +	/* About the whole device. */
> +	__le32 device_feature_select;	/* read-write */
> +	__le32 device_feature;		/* read-only */
> +	__le32 guest_feature_select;	/* read-write */
> +	__le32 guest_feature;		/* read-write */
> +	__le16 msix_config;		/* read-write */
> +	__le16 num_queues;		/* read-only */
> +	__u8 device_status;		/* read-write */
> +	__u8 config_generation;		/* read-only */
> +
> +	/* About a specific virtqueue. */
> +	__le16 queue_select;		/* read-write */
> +	__le16 queue_size;		/* read-write, power of 2. */
> +	__le16 queue_msix_vector;	/* read-write */
> +	__le16 queue_enable;		/* read-write */
> +	__le16 queue_notify_off;	/* read-only */
> +	__le32 queue_desc_lo;		/* read-write */
> +	__le32 queue_desc_hi;		/* read-write */
> +	__le32 queue_avail_lo;		/* read-write */
> +	__le32 queue_avail_hi;		/* read-write */
> +	__le32 queue_used_lo;		/* read-write */
> +	__le32 queue_used_hi;		/* read-write */
> +};
> +
>   struct virtio_pci_modern_device {
>   	struct pci_dev *pci_dev;
>   
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index 3a86f36d7e3d..247ec42af2c8 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -140,32 +140,6 @@ struct virtio_pci_notify_cap {
>   	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
>   };
>   
> -/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> -struct virtio_pci_common_cfg {
> -	/* About the whole device. */
> -	__le32 device_feature_select;	/* read-write */
> -	__le32 device_feature;		/* read-only */
> -	__le32 guest_feature_select;	/* read-write */
> -	__le32 guest_feature;		/* read-write */
> -	__le16 msix_config;		/* read-write */
> -	__le16 num_queues;		/* read-only */
> -	__u8 device_status;		/* read-write */
> -	__u8 config_generation;		/* read-only */
> -
> -	/* About a specific virtqueue. */
> -	__le16 queue_select;		/* read-write */
> -	__le16 queue_size;		/* read-write, power of 2. */
> -	__le16 queue_msix_vector;	/* read-write */
> -	__le16 queue_enable;		/* read-write */
> -	__le16 queue_notify_off;	/* read-only */
> -	__le32 queue_desc_lo;		/* read-write */
> -	__le32 queue_desc_hi;		/* read-write */
> -	__le32 queue_avail_lo;		/* read-write */
> -	__le32 queue_avail_hi;		/* read-write */
> -	__le32 queue_used_lo;		/* read-write */
> -	__le32 queue_used_hi;		/* read-write */
> -};
> -


I think it's better not delete those from uAPI. We can embed this struct 
in the private virito_pci_moden.h anyhow.

Thanks


>   /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
>   struct virtio_pci_cfg_cap {
>   	struct virtio_pci_cap cap;

