Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D814396F98
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhFAIzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:55:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233182AbhFAIzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 04:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aOcgj4/7/8wJi908yQhoCZVNaJnSsE8zNAKFi7tF3U=;
        b=iQ1pqNhqYP9esawQPF47WkxU1Bbki/hnZ6kD8A3FrTIiAZVHDZKNqS/nvAxYzu9ovQSlS/
        WEWr9lvChgks1+kCl06f3q8He0s1PamTAT/rPhBzXvyG8vZ+aGz/uYqf6QZvemsTl7t4bZ
        d3jeptc3SBIM3xb486e+1i8EPXdY1Ug=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-GIu0TSoqMRuTSXlLAr95rA-1; Tue, 01 Jun 2021 04:53:18 -0400
X-MC-Unique: GIu0TSoqMRuTSXlLAr95rA-1
Received: by mail-pj1-f69.google.com with SMTP id ot13-20020a17090b3b4db029015d9ead4bc5so8460754pjb.7
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 01:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5aOcgj4/7/8wJi908yQhoCZVNaJnSsE8zNAKFi7tF3U=;
        b=uoeQE50RIn74M286FSsvi91/0ItdSHLQZT0SgSmywODfGPk98Frni2YtcpsvXR7+aX
         HPJLjrwx1GjlUyAZdynFi95LjX3x18vxvEwFA5w75qSjpFZqJx5O9Ey8utKJXDsJeHDj
         mXh8LyYYClQrx5baEGTbzYzN9VvHHSU+g8jFi5cMOUWcAq1RP3Q0ctyCcFcWHxwYHFSj
         xHdo3R9YcmAThuGDMWU8kiDWnNA8Q65JHMdXSgrtBGyyLNkJ7hU4dFRxITGzossS247S
         HPYPi9Rc5lXIOHWzavsMJRsKEdFLtCSRH6LJdt7v6JlbtFBQM11Jg6nkhfgy9T7BTqUC
         73qQ==
X-Gm-Message-State: AOAM5327+zAEemeRKn0/zKz4nSnKpnY2LtZELwlKaUhtkwQzXFdQA3Nc
        0BqsK4xnsSc5/B6pbXzQQuO3aE4weLDozwCeb/MgboSFip1jQNOBLyndpNrbjL9mpnFwKiHxbbY
        1hDehnVb4HwDyz6NX52cUrC3SdSxRbj2gehUz2JjFBaGtucVxDHvneA02VfgGjS/i
X-Received: by 2002:aa7:801a:0:b029:2e0:c3db:15a2 with SMTP id j26-20020aa7801a0000b02902e0c3db15a2mr21386822pfi.42.1622537597193;
        Tue, 01 Jun 2021 01:53:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYDHHGpH9/a6mLp3/nIDpF5g4JSP7vmJEL9FSrm7dg3eB9KGd67RXSUkJ2HsSU3cvFP8NNPA==
X-Received: by 2002:aa7:801a:0:b029:2e0:c3db:15a2 with SMTP id j26-20020aa7801a0000b02902e0c3db15a2mr21386795pfi.42.1622537596866;
        Tue, 01 Jun 2021 01:53:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k70sm1625715pgd.41.2021.06.01.01.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:53:16 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] vDPA/ifcvf: record virtio notify base
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <63a73aab-964d-344f-d66b-e8e6224af687@redhat.com>
Date:   Tue, 1 Jun 2021 16:53:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601062850.4547-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/1 ÏÂÎç2:28, Zhu Lingshan Ð´µÀ:
> This commit records virtio notify base physical addr and
> calculate doorbell physical address for vqs.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 4 ++++
>   drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
>   2 files changed, 6 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 1a661ab45af5..6e197fe0fcf9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -133,6 +133,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   					      &hw->notify_off_multiplier);
>   			hw->notify_bar = cap.bar;
>   			hw->notify_base = get_cap_addr(hw, &cap);
> +			hw->notify_base_pa = pci_resource_start(pdev, cap.bar) +
> +					le32_to_cpu(cap.offset);
>   			IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>   				  hw->notify_base);
>   			break;
> @@ -161,6 +163,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
>   		hw->vring[i].notify_addr = hw->notify_base +
>   			notify_off * hw->notify_off_multiplier;
> +		hw->vring[i].notify_pa = hw->notify_base_pa +
> +			notify_off * hw->notify_off_multiplier;
>   	}
>   
>   	hw->lm_cfg = hw->base[IFCVF_LM_BAR];
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 0111bfdeb342..447f4ad9c0bf 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -73,6 +73,7 @@ struct vring_info {
>   	u16 last_avail_idx;
>   	bool ready;
>   	void __iomem *notify_addr;
> +	phys_addr_t notify_pa;
>   	u32 irq;
>   	struct vdpa_callback cb;
>   	char msix_name[256];
> @@ -87,6 +88,7 @@ struct ifcvf_hw {
>   	u8 notify_bar;
>   	/* Notificaiton bar address */
>   	void __iomem *notify_base;
> +	phys_addr_t notify_base_pa;
>   	u32 notify_off_multiplier;
>   	u64 req_features;
>   	u64 hw_features;

