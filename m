Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3D396FAB
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhFAI7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233160AbhFAI7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 04:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u5371KIE9OwVDsq1I2cb89rYj8W/Ec/f40mj6nTLkLc=;
        b=YiwkqwxdAkPrdsZc7rK6r74H8CenyoW5LXl4mRxKX+jzOfMkJ8pLSeyo1r3tPU7n/qf81e
        w7oeVKhmnQU406NhSJwbud49GLYs7Yp1ucr913NSVecT9Xr7rWa0sz9hLIYP7zoqM5O/WH
        FqpQjMGZNO+BkkZcs2+8nUybnu1YhoA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-mpEkkStVNPyn-9pl4FWyDQ-1; Tue, 01 Jun 2021 04:57:37 -0400
X-MC-Unique: mpEkkStVNPyn-9pl4FWyDQ-1
Received: by mail-pl1-f199.google.com with SMTP id q18-20020a170902dad2b0290106a6168b68so1434831plx.20
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 01:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u5371KIE9OwVDsq1I2cb89rYj8W/Ec/f40mj6nTLkLc=;
        b=i+cG9J007PHMaEsvqikJ02W45PYxWpd13k5/A/ZjlQG7qDKEOyMVUPJZwLlzqMBFId
         l/S4j+XeWqEqg0GYuHMMerfLngk6I6aCWyJRi4a6C0P7lFlIBtq7AXAPvQzfpwKrmFQU
         PFKSipTPhr4nhjowgfNpCbOumOL7JafgLAnrWm/eac0x43plD2QsMUtubF3lJFRMWYtj
         iUfsvBb3PQbFqpDqoXYOcr1y98q7bQbdf5a103HCcb2pnu8grXt+uhhQ5d/KZvM3N0xR
         3tYG4pcY6gniwz/SUN9mZlFTxxLwDOOfFGyUDCg0XgW+jLf+6yE/n2QcuGN/zMeQM6kh
         vAMQ==
X-Gm-Message-State: AOAM533I3zBK/O5i4+rCK85w1njkVuFQ1g+vnIY9bBWfwDaAnkBApN0Q
        K69PUDJE+8H1nY9EAnuj1SqxNDsOQkRFbJ/rQliGASe2sKcH1fgid+1fcz1EIRBpvTs/VDujmZp
        AC+v7hiJMYJ61d7iAW8nOj3CV4N0kqY1Dyn5bYbd84pQmt+rQpFWcx2aObQWSBQ1I
X-Received: by 2002:a05:6a00:1a8b:b029:28e:7b62:5118 with SMTP id e11-20020a056a001a8bb029028e7b625118mr20998355pfv.49.1622537856004;
        Tue, 01 Jun 2021 01:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5RAxna9+eiIbDEdx3jeizRawOrcnnsGMqdT3iHAvCp1MV5jdQt/byK39HONfjJ2sSpOTDBQ==
X-Received: by 2002:a05:6a00:1a8b:b029:28e:7b62:5118 with SMTP id e11-20020a056a001a8bb029028e7b625118mr20998335pfv.49.1622537855709;
        Tue, 01 Jun 2021 01:57:35 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm6254538pjf.40.2021.06.01.01.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:57:35 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-3-lingshan.zhu@intel.com>
 <d286a8f9-ac5c-ba95-777e-df926ea45292@redhat.com>
 <0e40f29a-5d37-796a-5d01-8594b3afbfdb@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5c8ebd49-59fe-31c3-71bf-44bd0bf64e2a@redhat.com>
Date:   Tue, 1 Jun 2021 16:57:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <0e40f29a-5d37-796a-5d01-8594b3afbfdb@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/1 下午4:56, Zhu, Lingshan 写道:
>
>
> On 6/1/2021 4:50 PM, Jason Wang wrote:
>>
>> 在 2021/6/1 下午2:28, Zhu Lingshan 写道:
>>> This commit implements doorbell mapping feature for ifcvf.
>>> This feature maps the notify page to userspace, to eliminate
>>> vmexit when kick a vq.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
>>>   1 file changed, 21 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index ab0ab5cf0f6e..d41db042612c 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -413,6 +413,26 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>> vdpa_device *vdpa_dev,
>>>       return vf->vring[qid].irq;
>>>   }
>>>   +static struct vdpa_notification_area 
>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>> +                                   u16 idx)
>>> +{
>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +    struct vdpa_notification_area area;
>>> +
>>> +    area.addr = vf->vring[idx].notify_pa;
>>> +    if (!vf->notify_off_multiplier)
>>> +        area.size = PAGE_SIZE;
>>> +    else
>>> +        area.size = vf->notify_off_multiplier;
>>> +
>>> +    if (area.addr % PAGE_SIZE)
>>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>>> aligned\n", idx);
>>
>>
>> I don't see the reason to keep this, or get_notification is not the 
>> proper place to do this kind of warning.
>>
>> Thanks
> some customers have ever complained have troubles to enable such 
> features with their IP,
> I think this can help them debug.


If you want to do this, the ifcvf_init_hw() is the proper place.

Note that this function is called by userspace.

Thanks


>
> Thanks
>>
>>
>>> +
>>> +    return area;
>>> +}
>>> +
>>>   /*
>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>    * implemented set_map()/dma_map()/dma_unmap()
>>> @@ -440,6 +460,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops 
>>> = {
>>>       .get_config    = ifcvf_vdpa_get_config,
>>>       .set_config    = ifcvf_vdpa_set_config,
>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>   };
>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *id)
>>
>

