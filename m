Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD13F1237
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 06:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhHSEKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 00:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhHSEKl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 00:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629346205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAKFB523upMxo0+DwG+qMEdFT9ki0LjoFpTj11Nr6RM=;
        b=Wu7SXpef2vcMAJEdoS1nD2VnDcJjkT2f60CPOEyUT1TrNq1bD6C+OMWOth84tJPnGXaMRE
        fN7QOMwRHANE7hy3tM/tluhvDSa/hJsfAizcguUofqWmijwEn/Ij6r9bvMkq06L+oDv+CC
        0+l1+NSJh1TtVllCoAEdTuZeY8ZDsJY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-ZDpbguyMO1OT4KFR7vUxuw-1; Thu, 19 Aug 2021 00:10:03 -0400
X-MC-Unique: ZDpbguyMO1OT4KFR7vUxuw-1
Received: by mail-pg1-f197.google.com with SMTP id y9-20020a655b09000000b0025259fdb7e7so2739136pgq.6
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 21:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mAKFB523upMxo0+DwG+qMEdFT9ki0LjoFpTj11Nr6RM=;
        b=I8e1EKKd8doPM08eAqHNBko8XrIgBCeybDS991MMOFmRxvlmlhzst/Em+byUHFNzKk
         GgDcGi2g6kYrD5jU7WcK8+nY0/As4KMAJejNJkussN3tUd7TlBnh0jimD7ULHgONCXkg
         SW8ImSll3VuxB0Y1Vqq/RNCT0lyjNNtj2iGVRvB6PrNkqaL3r/mac1oPDZCntULNtSHK
         2C0ShCd4mNlZIDL3lWw8meGxrFabo1gtP8xdziWzir9OUFS0q09dfoO672U4ZiiijTy6
         2OdcSB94ngx+PH21bhCTcNmnFS/3ahATnjMYpzgD/F5r4i7/m/7Ao/5657r0adgU8AiI
         nTZQ==
X-Gm-Message-State: AOAM533Ss9SD0kCby7dir0s6fX30Sn/qcMVMxKGetMNaLPWCAtVdEZfb
        SXMOkmwNbggdta6M04XL2imd5rYrXbrd9v3kp0VbUer1P21KcZas/m5KwY8ng52h3aqDvv9Vckl
        +qIhzQK7Mb3KdKBoGJZy70/ni36OZOUkgWO/NgtZwP5ze+8VBHGInLYjiN9YPj1XJ
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr9934352plq.59.1629346202163;
        Wed, 18 Aug 2021 21:10:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvJvKxjGvDP16m5jvYKL6UB/rB3oLFvT92PakF4jUj1koqC+slPZsHsy5c/+Dx1bYU8TY/Nw==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr9934329plq.59.1629346201878;
        Wed, 18 Aug 2021 21:10:01 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6sm1336541pfv.156.2021.08.18.21.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 21:10:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] vDPA/ifcvf: enable multiqueue and control vq
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
 <20210818095714.3220-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ecb03725-ecae-89bf-e8bc-b47859b75d4e@redhat.com>
Date:   Thu, 19 Aug 2021 12:09:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818095714.3220-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç5:57, Zhu Lingshan Ð´µÀ:
> This commit enbales multi-queue and control vq
> features for ifcvf
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  9 ---------
>   drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++--------
>   2 files changed, 3 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 97d9019a3ec0..09918af3ecf8 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -22,15 +22,6 @@
>   #define N3000_DEVICE_ID		0x1041
>   #define N3000_SUBSYS_DEVICE_ID	0x001A
>   
> -#define IFCVF_NET_SUPPORTED_FEATURES \
> -		((1ULL << VIRTIO_NET_F_MAC)			| \
> -		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> -		 (1ULL << VIRTIO_F_VERSION_1)			| \
> -		 (1ULL << VIRTIO_NET_F_STATUS)			| \
> -		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
> -		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
> -		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
> -
>   /* Max 8 data queue pairs(16 queues) and one control vq for now. */
>   #define IFCVF_MAX_QUEUES	17
>   
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index e34c2ec2b69b..b99283a98177 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -174,17 +174,12 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>   	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   	struct pci_dev *pdev = adapter->pdev;
> -
> +	u32 type = vf->dev_type;
>   	u64 features;
>   
> -	switch (vf->dev_type) {
> -	case VIRTIO_ID_NET:
> -		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
> -		break;
> -	case VIRTIO_ID_BLOCK:
> +	if (type == VIRTIO_ID_NET || type == VIRTIO_ID_BLOCK)
>   		features = ifcvf_get_features(vf);
> -		break;
> -	default:
> +	else {
>   		features = 0;
>   		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>   	}

