Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB6589723
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 06:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiHDEqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 00:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiHDEqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 00:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1FE45072D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 21:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659588367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/FplmZWKJi7jCa4WMVnhT7v6YiodusOAXNyZ4pUZ8s=;
        b=MWqIpkQT/TC35/UP0JbxbTdaRpRFxdnBW3vasxPYKFZVkWY6IoM0fXwGSvvyI6CENeCoCt
        Yzs8jeDruBKed3ZngWFWXdw8dRfzaYrl4bJYcF+ofNPd/TJK5nFxK5KxwhOFEUHkL6oXK0
        84TOtlE7fFHya7WvQoMfzP4XOBwtfOk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-BMSbZyDtNvODeiGeaNKLvA-1; Thu, 04 Aug 2022 00:46:06 -0400
X-MC-Unique: BMSbZyDtNvODeiGeaNKLvA-1
Received: by mail-pg1-f197.google.com with SMTP id q82-20020a632a55000000b0041bafd16728so5448146pgq.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 21:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W/FplmZWKJi7jCa4WMVnhT7v6YiodusOAXNyZ4pUZ8s=;
        b=41oqXD4Xe0Pk681Vn0FDNHHIoCjV0PiaFgyyl1Jtf7g9pfmq2UTK+KIsQN1pfCxMh+
         zN1jp8kBL0NLI2ysOJ6kcybfgHmVT7Wnc4Wg2jMUy/65Xuzi69rqu+LxLLM3eQ1f1BVt
         VyZO8J9/8eKHiOw+Ey60APvALpfQUdsxfQPKIq4eqQQuitCgd/n6PpSlF6E10JU2JimI
         lZLMnF+hG3YDa9sN7WrKrqJQiTjDzCiidbGuUDBmqf4jekdg8KLca8adxReBHEOkzjIm
         xn0hTwHVU13Vj3/sMry7MRTu+RvBwJjItuvomMXGlI8I6ptwSdeQnLytAnfzfqx17Gd3
         L5sg==
X-Gm-Message-State: ACgBeo2ZxJYV2sUQmVvt7c4uPcracFPvPZMhMIWrGb+lp5BJSkVPEjTW
        p4eeh8Lv9p9u3mHB7PtpWWt8P6o4I8BFMazh7iENeqbsmcHsscAUIn+3+3ah/l6QPy8z1IWF6li
        DuDsWzey9m/EF
X-Received: by 2002:a63:ef54:0:b0:41a:56e7:aeb3 with SMTP id c20-20020a63ef54000000b0041a56e7aeb3mr163236pgk.49.1659588364914;
        Wed, 03 Aug 2022 21:46:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR67lbl9gOzodFx50CBqYTj4fBH69ihDvcfpKXfPtbBwkZTObfdsYhbxijIlbXYaK6hz8fLPfQ==
X-Received: by 2002:a63:ef54:0:b0:41a:56e7:aeb3 with SMTP id c20-20020a63ef54000000b0041a56e7aeb3mr163208pgk.49.1659588364623;
        Wed, 03 Aug 2022 21:46:04 -0700 (PDT)
Received: from [10.72.12.192] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b001f200eabc65sm2504494pji.41.2022.08.03.21.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 21:46:03 -0700 (PDT)
Message-ID: <c25c142f-ad9d-a5cf-9837-5570d563ad07@redhat.com>
Date:   Thu, 4 Aug 2022 12:45:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 6/7] vhost_net: Add NetClientInfo prepare callback
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
References: <20220803171821.481336-1-eperezma@redhat.com>
 <20220803171821.481336-7-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220803171821.481336-7-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/8/4 01:18, Eugenio Pérez 写道:
> This is used by the backend to perform actions before the device is
> started.
>
> In particular, vdpa will use it to isolate CVQ in its own ASID if
> possible, and start SVQ unconditionally only in CVQ.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>   include/net/net.h  | 2 ++
>   hw/net/vhost_net.c | 4 ++++
>   2 files changed, 6 insertions(+)
>
> diff --git a/include/net/net.h b/include/net/net.h
> index a8d47309cd..efa6448886 100644
> --- a/include/net/net.h
> +++ b/include/net/net.h
> @@ -44,6 +44,7 @@ typedef struct NICConf {
>   
>   typedef void (NetPoll)(NetClientState *, bool enable);
>   typedef bool (NetCanReceive)(NetClientState *);
> +typedef void (NetPrepare)(NetClientState *);
>   typedef int (NetLoad)(NetClientState *);
>   typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, size_t);
>   typedef ssize_t (NetReceiveIOV)(NetClientState *, const struct iovec *, int);
> @@ -72,6 +73,7 @@ typedef struct NetClientInfo {
>       NetReceive *receive_raw;
>       NetReceiveIOV *receive_iov;
>       NetCanReceive *can_receive;
> +    NetPrepare *prepare;
>       NetLoad *load;
>       NetCleanup *cleanup;
>       LinkStatusChanged *link_status_changed;
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index a9bf72dcda..bbbb6d759b 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -244,6 +244,10 @@ static int vhost_net_start_one(struct vhost_net *net,
>       struct vhost_vring_file file = { };
>       int r;
>   
> +    if (net->nc->info->prepare) {
> +        net->nc->info->prepare(net->nc);
> +    }


Any chance we can reuse load()?

Thanks


> +
>       r = vhost_dev_enable_notifiers(&net->dev, dev);
>       if (r < 0) {
>           goto fail_notifiers;

