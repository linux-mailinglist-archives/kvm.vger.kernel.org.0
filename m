Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C344A521584
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 14:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiEJMjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbiEJMjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:39:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC02A83D6
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 05:35:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w17-20020a17090a529100b001db302efed6so2015439pjh.4
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Erx9sTjRTj3xK1tZIzEyCrNiFbrsMrmyJiPvcO76NII=;
        b=zQsTSXGbmssxzxqFF+vtOTyvdbx+hKoDVOXdXbyeB3DKXYgc9CxPzZaxTGvxjGXPBQ
         Bq+SCmaWX8pWP8BLnd/wYphCntO624ncqyu7bHLOlxYPRjsw8B1no44niLtRLuR9TVqL
         Hwu5Ao0KA1n4v9QNMj+5axuYuX6tB5bbLZTg9cxGudR8iL8Zh5knKZDLpXIfGXo2A5qg
         /zpWXzi3b0OSivBbdqQ9eobLDI76NLGAVYJTWypu847STaqaLFjBYfkI1NgTeuFMK7rZ
         uZdW6v7mljwNC50XERNelVdv7H7nZVV4vsFUUpReTOgj8PEVNVOANmfhlfwVN4aOf1xq
         TsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Erx9sTjRTj3xK1tZIzEyCrNiFbrsMrmyJiPvcO76NII=;
        b=GxwFQPR7H/ATu5QC5KWmYHyDgzky4PzWdeupBSGh/X5dwTEkLnQsLgI8LTykFbMh7v
         F+v5i6DbigBJ1SsKNTC9MUqYYDdN19ZiBXuZNEr8SYHb1toQZL7Djy14mxGovm2Mowh6
         gc1FlSrTvLfQwwD9AZ+TnLIku3XZRN0GP2sz/dEn1gojLu6dXMDV9GDhkxaufhSB6kFJ
         W0dgnCU6x0a95kqC9Vs0+rhr3ghx7h7Q3inOwddWP9ThsZyO0XC6NjM5ISS3it6vK1Sr
         2HH0xU9qe2w60sHGJDkB4dJKfrW3CtdIj6Jro/YCcdIOduYHi/LcDH98eI3gKwm6Exmu
         OCQA==
X-Gm-Message-State: AOAM530U1rkhn/5mgjw5fYupkM0AvrK/nLlPN2kp4zC0mZe2oafb+bRE
        zdF/TgBFoXBpyMAvUmicBa5knQ==
X-Google-Smtp-Source: ABdhPJx8cyJ9jOtfPFwhsFbPqtDy0SpW+WCWhqWJHPKOeBeFpqjjH9PaIDeH1VyOwd4Gmzk04j2ZUQ==
X-Received: by 2002:a17:90b:4b01:b0:1dc:7405:dd62 with SMTP id lx1-20020a17090b4b0100b001dc7405dd62mr23299547pjb.160.1652186116233;
        Tue, 10 May 2022 05:35:16 -0700 (PDT)
Received: from [10.124.0.6] ([94.177.118.95])
        by smtp.gmail.com with ESMTPSA id y4-20020aa79e04000000b0050dc762814fsm10586893pfq.41.2022.05.10.05.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:35:15 -0700 (PDT)
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     eric.auger@redhat.com, Yi Liu <yi.l.liu@intel.com>,
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
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
Date:   Tue, 10 May 2022 20:35:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/5/10 下午2:51, Eric Auger wrote:
> Hi Hi, Zhangfei,
>
> On 5/10/22 05:17, Yi Liu wrote:
>> Hi Zhangfei,
>>
>> On 2022/5/9 22:24, Zhangfei Gao wrote:
>>> Hi, Alex
>>>
>>> On 2022/4/27 上午12:35, Alex Williamson wrote:
>>>> On Tue, 26 Apr 2022 12:43:35 +0000
>>>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>>>>
>>>>>> -----Original Message-----
>>>>>> From: Eric Auger [mailto:eric.auger@redhat.com]
>>>>>> Sent: 26 April 2022 12:45
>>>>>> To: Shameerali Kolothum Thodi
>>>>>> <shameerali.kolothum.thodi@huawei.com>; Yi
>>>>>> Liu <yi.l.liu@intel.com>; alex.williamson@redhat.com;
>>>>>> cohuck@redhat.com;
>>>>>> qemu-devel@nongnu.org
>>>>>> Cc: david@gibson.dropbear.id.au; thuth@redhat.com;
>>>>>> farman@linux.ibm.com;
>>>>>> mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
>>>>>> jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
>>>>>> jgg@nvidia.com; nicolinc@nvidia.com; eric.auger.pro@gmail.com;
>>>>>> kevin.tian@intel.com; chao.p.peng@intel.com; yi.y.sun@intel.com;
>>>>>> peterx@redhat.com; Zhangfei Gao <zhangfei.gao@linaro.org>
>>>>>> Subject: Re: [RFC 00/18] vfio: Adopt iommufd
>>>>> [...]
>>>>>> https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com
>>>>>>
>>>>>>>> /
>>>>>>>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>>>>>>>> [3]
>>>>>>>> https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
>>>>>>> Hi,
>>>>>>>
>>>>>>> I had a go with the above branches on our ARM64 platform trying to
>>>>>> pass-through
>>>>>>> a VF dev, but Qemu reports an error as below,
>>>>>>>
>>>>>>> [    0.444728] hisi_sec2 0000:00:01.0: enabling device (0000 ->
>>>>>>> 0002)
>>>>>>> qemu-system-aarch64-iommufd: IOMMU_IOAS_MAP failed: Bad address
>>>>>>> qemu-system-aarch64-iommufd: vfio_container_dma_map(0xaaaafeb40ce0,
>>>>>> 0x8000000000, 0x10000, 0xffffb40ef000) = -14 (Bad address)
>>>>>>> I think this happens for the dev BAR addr range. I haven't
>>>>>>> debugged the
>>>>>> kernel
>>>>>>> yet to see where it actually reports that.
>>>>>> Does it prevent your assigned device from working? I have such errors
>>>>>> too but this is a known issue. This is due to the fact P2P DMA is not
>>>>>> supported yet.
>>>>> Yes, the basic tests all good so far. I am still not very clear how
>>>>> it works if
>>>>> the map() fails though. It looks like it fails in,
>>>>>
>>>>> iommufd_ioas_map()
>>>>>     iopt_map_user_pages()
>>>>>      iopt_map_pages()
>>>>>      ..
>>>>>        pfn_reader_pin_pages()
>>>>>
>>>>> So does it mean it just works because the page is resident()?
>>>> No, it just means that you're not triggering any accesses that require
>>>> peer-to-peer DMA support.  Any sort of test where the device is only
>>>> performing DMA to guest RAM, which is by far the standard use case,
>>>> will work fine.  This also doesn't affect vCPU access to BAR space.
>>>> It's only a failure of the mappings of the BAR space into the IOAS,
>>>> which is only used when a device tries to directly target another
>>>> device's BAR space via DMA.  Thanks,
>>> I also get this issue when trying adding prereg listenner
>>>
>>> +    container->prereg_listener = vfio_memory_prereg_listener;
>>> +    memory_listener_register(&container->prereg_listener,
>>> +                            &address_space_memory);
>>>
>>> host kernel log:
>>> iommufd_ioas_map 1 iova=8000000000, iova1=8000000000,
>>> cmd->iova=8000000000, cmd->user_va=9c495000, cmd->length=10000
>>> iopt_alloc_area input area=859a2d00 iova=8000000000
>>> iopt_alloc_area area=859a2d00 iova=8000000000
>>> pin_user_pages_remote rc=-14
>>>
>>> qemu log:
>>> vfio_prereg_listener_region_add
>>> iommufd_map iova=0x8000000000
>>> qemu-system-aarch64: IOMMU_IOAS_MAP failed: Bad address
>>> qemu-system-aarch64: vfio_dma_map(0xaaaafb96a930, 0x8000000000,
>>> 0x10000, 0xffff9c495000) = -14 (Bad address)
>>> qemu-system-aarch64: (null)
>>> double free or corruption (fasttop)
>>> Aborted (core dumped)
>>>
>>> With hack of ignoring address 0x8000000000 in map and unmap, kernel
>>> can boot.
>> do you know if the iova 0x8000000000 guest RAM or MMIO? Currently,
>> iommufd kernel part doesn't support mapping device BAR MMIO. This is a
>> known gap.
> In qemu arm virt machine this indeed matches the PCI MMIO region.

Thanks Yi and Eric,
Then will wait for the updated iommufd kernel for the PCI MMIO region.

Another question,
How to get the iommu_domain in the ioctl.

qemu can get container->ioas_id.

kernel can get ioas via the ioas_id.
But how to get the domain?
Currently I am hacking with ioas->iopt.next_domain_id, which is increasing.
domain = xa_load(&ioas->iopt.domains, ioas->iopt.next_domain_id-1);

Any idea?

Thanks
