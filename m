Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94CD3BB6A6
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 07:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhGEFML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 01:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhGEFMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 01:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625461773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GKsids3f945YQDF5Oen93rLvMd+sZCBgdX5IUN3ZQHE=;
        b=X2ttzcBAagBgxA3kPq+jmHuglmdO3DidUgxa0NiDTiRRaJbxZwYlDchnNkIqX80iJ/x4ad
        IbZ/3O4MnEjhnDDZcHSvXJx8NFTHOD228MaGwl2YbN7TuJqjDrN5eV0l4F5C0rx5dm+5Pn
        DfwBzVEIExZcePIC84lmGMLlAFcF8sQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Iedl3MJNNaiF_JWfWZyDuA-1; Mon, 05 Jul 2021 01:09:31 -0400
X-MC-Unique: Iedl3MJNNaiF_JWfWZyDuA-1
Received: by mail-pf1-f198.google.com with SMTP id p42-20020a056a000a2ab02902f33d81f23fso11237485pfh.9
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 22:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GKsids3f945YQDF5Oen93rLvMd+sZCBgdX5IUN3ZQHE=;
        b=fVygE7ycxe6OIfKlab5Q198inCzJQztrwe6OCXKHR41h0V82ATpwMaiCADreDo4t0A
         wlAu6QHoDHfmKKS2+pmjcMHG2vNQCmrX53YBI//WZO0Lv/Zvc2KQ+57QIaARd9oM4jej
         AR1DjtLa4HadZyc7rR+LiewZqIVYCQRErw1hzICxtLnyTGep0W1ueomLOWa8/jtAyxKr
         1+t5S1vTk7eHdGP/bgI765TMet5sk3B+MKKgfqNzZVv7qUQ29+uQ4kh8lFKZ+4vWvUcA
         ySHVd7VMMbzwkBOyS1gZd8ah9fXfMQ0SwiuTn4eO5L8cKJZuR7+MDM2X8UQ1WW+7p75R
         LaEQ==
X-Gm-Message-State: AOAM530fWX+962rdMBvnbsWVaOO4S0S+6SydVuyOXtyMvRlwaDtgX3Di
        Bud7z+2rZZmBYDYLtG7DqZBePLtftq1zfv4grood9h4P5KDE+LUKA7PXXt5j+BWo+CdMuMA8o4l
        3U1h2PVluHOCBeup4vuHb0lwC5HgpKGhfplCWGzzBDewjKnbSOTWJrK1fAm53KnQQ
X-Received: by 2002:a17:902:7403:b029:129:5f48:dc37 with SMTP id g3-20020a1709027403b02901295f48dc37mr9523545pll.58.1625461770016;
        Sun, 04 Jul 2021 22:09:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYKuL/vTytNEw3Xxr1NKzCafhtSD+dri4UUFdqvBeHMdSNzzAMluRD5YRZoC8KMP8WxfzvsA==
X-Received: by 2002:a17:902:7403:b029:129:5f48:dc37 with SMTP id g3-20020a1709027403b02901295f48dc37mr9523505pll.58.1625461769424;
        Sun, 04 Jul 2021 22:09:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d1sm10341887pfu.6.2021.07.04.22.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 22:09:28 -0700 (PDT)
Subject: Re: [PATCH 3/3] vDPA/ifcvf: set_status() should get a adapter from
 the mgmt dev
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <81d8aaed-f2e8-bbf8-a7d5-71e41837d866@redhat.com>
Date:   Mon, 5 Jul 2021 13:09:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630082145.5729-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/30 ÏÂÎç4:21, Zhu Lingshan Ð´µÀ:
> ifcvf_vdpa_set_status() should get a adapter from the
> management device
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 7c2f64ca2163..28c71eef1d2b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -212,13 +212,15 @@ static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
>   
>   static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   {
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>   	struct ifcvf_adapter *adapter;
>   	struct ifcvf_hw *vf;
>   	u8 status_old;
>   	int ret;
>   
>   	vf  = vdpa_to_vf(vdpa_dev);
> -	adapter = dev_get_drvdata(vdpa_dev->dev.parent);


If this is a fix for patch 2, you need to squash this into that one.

Any reason that vdpa_to_adapter() can't work?

And I see:

+struct ifcvf_vdpa_mgmt_dev {
+	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_adapter *adapter;
+	struct pci_dev *pdev;
+};

What's the reason for having a adapter pointer here?

Thanks


> +	ifcvf_mgmt_dev = dev_get_drvdata(vdpa_dev->dev.parent);
> +	adapter = ifcvf_mgmt_dev->adapter;
>   	status_old = ifcvf_get_status(vf);
>   
>   	if (status_old == status)

