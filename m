Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456B757C732
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiGUJOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiGUJOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2E5C3F338
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 02:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658394868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppSpnW8bYqIzLlwJTJe7LMpqbChLBLEyuLzj0jwDOCg=;
        b=WyHko746P7lcR8CnAiYWKxoGvgKZoqCHP0hYKSkvkwrU+6becw37tcPL5FkYhukfZSlCnl
        z/EUdrQ1shu6sv2mbsXg+zCz0iVRVL57J97dfs5Us8iHr413ezBIrjphhGRTBiuSiyOgOA
        xR0sj6iCVincOu6ZjKqyOTFC3R+sCuw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-xKWXLXtbOvyJ1OkaBpmd_Q-1; Thu, 21 Jul 2022 05:14:23 -0400
X-MC-Unique: xKWXLXtbOvyJ1OkaBpmd_Q-1
Received: by mail-pl1-f200.google.com with SMTP id p10-20020a170902e74a00b0016c3f3acb51so851243plf.16
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 02:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ppSpnW8bYqIzLlwJTJe7LMpqbChLBLEyuLzj0jwDOCg=;
        b=BZhQfma1G/AhtgCnqMaXpjwaKwQWWty1IuJN77YhiZm9U6PRlji/34Z3mfTp5N7W1T
         gcbg2mdMFXnPBnWJ1RxzLo9jjWO+xFNGRuAAodlbQGMmu1/9ap70/b52NrCcWxDI0gdj
         2imFs1qr+OG9yADe6x7jK3sT3JgJQtBTCi4IK9uJlSxp+2dYdn/3UudK3XKTlO74uhTP
         akTSR7Vnn1aAwnFsrJ0I1f7cKl6nQYlNrU9/MZ2ucw/s8sEU/51SAPn+SGLQxPtqxUYo
         GqbKBzMyhkY4FzonmONlgct+GpSFk6z2lpbxI7jyQCATfbJmOZG/4LTrrfWokQOgAPOb
         9cNA==
X-Gm-Message-State: AJIora/eeqqMq8zwjb6mrYhwTliXSLtVF3SV50SHckey41KzI+VXxiDE
        q4Bu3j09XX5Kt3mapYpsH1P7Gzp0NLVN9eUPCjyy8FdcD/m8+ylveNeFjEj5yk+jNIVjuzJJJa4
        0wyu8VNZqaVmJ
X-Received: by 2002:a17:902:ab0e:b0:16d:e87:ce8d with SMTP id ik14-20020a170902ab0e00b0016d0e87ce8dmr12288647plb.53.1658394861558;
        Thu, 21 Jul 2022 02:14:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tdQQvXxoAsILo5kGUhAyFtFd7+hyXAVcy5eO+xsnDpHiLynC44NTrLJew4cMcMMUejlOtfhg==
X-Received: by 2002:a17:902:ab0e:b0:16d:e87:ce8d with SMTP id ik14-20020a170902ab0e00b0016d0e87ce8dmr12288621plb.53.1658394861264;
        Thu, 21 Jul 2022 02:14:21 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l4-20020a170903244400b0016c454598b5sm1116942pls.167.2022.07.21.02.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:14:20 -0700 (PDT)
Message-ID: <da5ddf3b-3db7-7f25-a0f6-63a39e6af2a2@redhat.com>
Date:   Thu, 21 Jul 2022 17:14:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 24/40] virtio: allow to unbreak/break virtqueue
 individually
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
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-25-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-25-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> This patch allows the new introduced
> __virtqueue_break()/__virtqueue_unbreak() to break/unbreak the
> virtqueue.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 24 ++++++++++++++++++++++++
>   include/linux/virtio.h       |  3 +++
>   2 files changed, 27 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index cf4379175163..bf666dad9904 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2730,6 +2730,30 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *_vq)
>   }
>   EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
>   
> +/*
> + * This function should only be called by the core, not directly by the driver.
> + */
> +void __virtqueue_break(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> +	WRITE_ONCE(vq->broken, true);
> +}
> +EXPORT_SYMBOL_GPL(__virtqueue_break);
> +
> +/*
> + * This function should only be called by the core, not directly by the driver.
> + */
> +void __virtqueue_unbreak(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> +	WRITE_ONCE(vq->broken, false);
> +}
> +EXPORT_SYMBOL_GPL(__virtqueue_unbreak);
> +
>   bool virtqueue_is_broken(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 62e31bca5602..d45ee82a4470 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -138,6 +138,9 @@ bool is_virtio_device(struct device *dev);
>   void virtio_break_device(struct virtio_device *dev);
>   void __virtio_unbreak_device(struct virtio_device *dev);
>   
> +void __virtqueue_break(struct virtqueue *_vq);
> +void __virtqueue_unbreak(struct virtqueue *_vq);
> +
>   void virtio_config_changed(struct virtio_device *dev);
>   #ifdef CONFIG_PM_SLEEP
>   int virtio_device_freeze(struct virtio_device *dev);

