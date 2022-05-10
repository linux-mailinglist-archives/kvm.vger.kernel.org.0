Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA5E520E26
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 08:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiEJGzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 02:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiEJGzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 02:55:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8808047AE0
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 23:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652165509;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DP2piwxUgQrunPRJKq8MgqTTTot5/VOKK/aVg2H9TDc=;
        b=hzznR8obI0yK9iXwCpA56pWWISPi1WiH4C/l5GQUeJQZ0dA+Ewi7nrnt2HKAabgYbS46Ql
        OPaIxMM3dHxAU3oP6luqVYe/smjbR/oOvtI9b0uKIbFMkFLpJ9yZ+gHQHuS6SOwSjryRtV
        cPJ+hnRiiThQfcoiu5xIK42BwTIm2+U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-sFbtxh1zOTCFled18vVXSQ-1; Tue, 10 May 2022 02:51:48 -0400
X-MC-Unique: sFbtxh1zOTCFled18vVXSQ-1
Received: by mail-wr1-f71.google.com with SMTP id u26-20020adfb21a000000b0020ac48a9aa4so6659657wra.5
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 23:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DP2piwxUgQrunPRJKq8MgqTTTot5/VOKK/aVg2H9TDc=;
        b=x5mxnDum/XZvHJxr66IvG69U3Ts09aX9vZowmOpCQALxZ/5Sl2i7C9mO/7ZY1+bnh/
         3fQ3j8j1hcLqDD6h9r4h7vjBes42WDGKy3L2oaimfd5tt2HrVGK2u7XrHXg0mQ/IQ7sU
         ccjsJeGqprhZjYhu1zYgcUf8eH520m+5GNv6RJbRNqclsMBE4SFpV6WqzPZhjsDvPF2N
         PmmSOkWCVdtPTc0CY0JZU5aouzLaJipFNcCXZoLOa8NXfewjb0ZpvH+kwkvEyWd4Lu4M
         H1KZExXOl73/A0FBx6sDXMxGz1E49+k8SWV3qeVL4/WWndJdns0iqIlJXH48RWfnvh2i
         WZ/A==
X-Gm-Message-State: AOAM532VG+1cq9ecNcNa5mF8gEDoYKVexJKFh+Bu4P6CslrDGH9o08Ec
        GGdaY4vwUcIMIC351sHqkI9CI6joyrhhOc7w81MwCVzWZEMr7QPOMRGCXDrrKsVaRBNeXebswlQ
        HEBZw6/Ad7s/z
X-Received: by 2002:a05:600c:4e05:b0:394:8955:839a with SMTP id b5-20020a05600c4e0500b003948955839amr11668665wmq.28.1652165506752;
        Mon, 09 May 2022 23:51:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLkKWIzsFygKuwcetfNYenSE7NwJJluGTLLeDEm3O52poU+xby0OLO3xZ0oMzX/PvC0iTcrg==
X-Received: by 2002:a05:600c:4e05:b0:394:8955:839a with SMTP id b5-20020a05600c4e0500b003948955839amr11668652wmq.28.1652165506569;
        Mon, 09 May 2022 23:51:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d6912000000b0020c5253d913sm12928292wru.95.2022.05.09.23.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 23:51:45 -0700 (PDT)
Message-ID: <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
Date:   Tue, 10 May 2022 08:51:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Hi, Zhangfei,

On 5/10/22 05:17, Yi Liu wrote:
> Hi Zhangfei,
>
> On 2022/5/9 22:24, Zhangfei Gao wrote:
>> Hi, Alex
>>
>> On 2022/4/27 上午12:35, Alex Williamson wrote:
>>> On Tue, 26 Apr 2022 12:43:35 +0000
>>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>>>
>>>>> -----Original Message-----
>>>>> From: Eric Auger [mailto:eric.auger@redhat.com]
>>>>> Sent: 26 April 2022 12:45
>>>>> To: Shameerali Kolothum Thodi
>>>>> <shameerali.kolothum.thodi@huawei.com>; Yi
>>>>> Liu <yi.l.liu@intel.com>; alex.williamson@redhat.com;
>>>>> cohuck@redhat.com;
>>>>> qemu-devel@nongnu.org
>>>>> Cc: david@gibson.dropbear.id.au; thuth@redhat.com;
>>>>> farman@linux.ibm.com;
>>>>> mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
>>>>> jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
>>>>> jgg@nvidia.com; nicolinc@nvidia.com; eric.auger.pro@gmail.com;
>>>>> kevin.tian@intel.com; chao.p.peng@intel.com; yi.y.sun@intel.com;
>>>>> peterx@redhat.com; Zhangfei Gao <zhangfei.gao@linaro.org>
>>>>> Subject: Re: [RFC 00/18] vfio: Adopt iommufd
>>>> [...]
>>>>> https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com
>>>>>
>>>>>>> /
>>>>>>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>>>>>>> [3]
>>>>>>> https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
>>>>>> Hi,
>>>>>>
>>>>>> I had a go with the above branches on our ARM64 platform trying to
>>>>> pass-through
>>>>>> a VF dev, but Qemu reports an error as below,
>>>>>>
>>>>>> [    0.444728] hisi_sec2 0000:00:01.0: enabling device (0000 ->
>>>>>> 0002)
>>>>>> qemu-system-aarch64-iommufd: IOMMU_IOAS_MAP failed: Bad address
>>>>>> qemu-system-aarch64-iommufd: vfio_container_dma_map(0xaaaafeb40ce0,
>>>>> 0x8000000000, 0x10000, 0xffffb40ef000) = -14 (Bad address)
>>>>>> I think this happens for the dev BAR addr range. I haven't
>>>>>> debugged the
>>>>> kernel
>>>>>> yet to see where it actually reports that.
>>>>> Does it prevent your assigned device from working? I have such errors
>>>>> too but this is a known issue. This is due to the fact P2P DMA is not
>>>>> supported yet.
>>>> Yes, the basic tests all good so far. I am still not very clear how
>>>> it works if
>>>> the map() fails though. It looks like it fails in,
>>>>
>>>> iommufd_ioas_map()
>>>>    iopt_map_user_pages()
>>>>     iopt_map_pages()
>>>>     ..
>>>>       pfn_reader_pin_pages()
>>>>
>>>> So does it mean it just works because the page is resident()?
>>> No, it just means that you're not triggering any accesses that require
>>> peer-to-peer DMA support.  Any sort of test where the device is only
>>> performing DMA to guest RAM, which is by far the standard use case,
>>> will work fine.  This also doesn't affect vCPU access to BAR space.
>>> It's only a failure of the mappings of the BAR space into the IOAS,
>>> which is only used when a device tries to directly target another
>>> device's BAR space via DMA.  Thanks,
>>
>> I also get this issue when trying adding prereg listenner
>>
>> +    container->prereg_listener = vfio_memory_prereg_listener;
>> +    memory_listener_register(&container->prereg_listener,
>> +                            &address_space_memory);
>>
>> host kernel log:
>> iommufd_ioas_map 1 iova=8000000000, iova1=8000000000,
>> cmd->iova=8000000000, cmd->user_va=9c495000, cmd->length=10000
>> iopt_alloc_area input area=859a2d00 iova=8000000000
>> iopt_alloc_area area=859a2d00 iova=8000000000
>> pin_user_pages_remote rc=-14
>>
>> qemu log:
>> vfio_prereg_listener_region_add
>> iommufd_map iova=0x8000000000
>> qemu-system-aarch64: IOMMU_IOAS_MAP failed: Bad address
>> qemu-system-aarch64: vfio_dma_map(0xaaaafb96a930, 0x8000000000,
>> 0x10000, 0xffff9c495000) = -14 (Bad address)
>> qemu-system-aarch64: (null)
>> double free or corruption (fasttop)
>> Aborted (core dumped)
>>
>> With hack of ignoring address 0x8000000000 in map and unmap, kernel
>> can boot.
>
> do you know if the iova 0x8000000000 guest RAM or MMIO? Currently,
> iommufd kernel part doesn't support mapping device BAR MMIO. This is a
> known gap.
In qemu arm virt machine this indeed matches the PCI MMIO region.

Thanks

Eric

