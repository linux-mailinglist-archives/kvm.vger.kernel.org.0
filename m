Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE99455C63C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242244AbiF1I6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiF1I6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27DE7C66
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656406727;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VpeCbsArzQqWwSTbVAKR1IJL1iNT7iTbnKRmPlVeCE4=;
        b=LPro0bI/ZV/2HXp4oe/sah0beOAvbJ1voLa3sbueWdx8+pXR6J3c97Jptv3fbyNaz729N8
        Evfv9eZQPR1WeLx4nwN+MIqWm+tFzxXqWGJJWcNc+RraBbACkmNcxBeVL26Q+E6ywZhgcg
        mIfYTDBqghXht4P9IM2LkmC0AQ63HCA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-gVBwIrvpMyOqspkS_s7n5Q-1; Tue, 28 Jun 2022 04:58:45 -0400
X-MC-Unique: gVBwIrvpMyOqspkS_s7n5Q-1
Received: by mail-wm1-f70.google.com with SMTP id az40-20020a05600c602800b003a048edf007so2426699wmb.5
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VpeCbsArzQqWwSTbVAKR1IJL1iNT7iTbnKRmPlVeCE4=;
        b=NkEDshvNqS72JvDD8hWPiz1efHBk78YDymtpMcTcxiEOep4hjT0TkedJ1Ip3FlsSer
         W6yvL98LO5vDfklD8ZM3czeFcF8bwbBCSQbO78IelrWnG4i4AZpbGFy+UQvtCDpT/DWA
         f+q4Ihq63lwV6/yj2DIoaxLcMNVxVhCfnQOz65W5u78z1N6ENqztk+HcBJHPO6apxMAX
         d1VvG50WB1iJ9Yf3LQqv6BmKAaojY5yAgVhuSKDR6mllgu2Hns2+X93KNNYwjx15fMSq
         h16Gpx3hY67LVRK6dFyUNPS+IEaFpV2Z7KelmulVt0OkVJPagMcJ6Ya2WtTVEqFifvHn
         yvIg==
X-Gm-Message-State: AJIora+56ZFg5DINyL5hI/E91R/vBysejiJv6pSS5IZ8RGcrEV48/53b
        8KlLV0DkrU0lMhy2iFlpDZtzsbm5SyBT+/b7gjfbR1ZQrFQC4KaunUevTHLDohqVRrgZ/f62Tvk
        PWgLtQjMpd45U
X-Received: by 2002:adf:e752:0:b0:21b:80ae:9d7a with SMTP id c18-20020adfe752000000b0021b80ae9d7amr16459103wrn.362.1656406724477;
        Tue, 28 Jun 2022 01:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vnMWyLgVmpPdfheZLiOHjzA0U6ngGkTJ7I4E70o3qbHTCxvd7F8znytYzeFWU+ClBMuhaawQ==
X-Received: by 2002:adf:e752:0:b0:21b:80ae:9d7a with SMTP id c18-20020adfe752000000b0021b80ae9d7amr16459081wrn.362.1656406724204;
        Tue, 28 Jun 2022 01:58:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5-20020a05600c230500b0039c8a22554bsm16152199wmo.27.2022.06.28.01.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 01:58:43 -0700 (PDT)
Message-ID: <25ba2a75-9db6-9160-9ed4-2563c8f27d46@redhat.com>
Date:   Tue, 28 Jun 2022 10:58:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>,
        "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
 <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
 <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
 <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
 <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
 <tencent_C3C342C7F0605284FB368A1A63534B5A4806@qq.com>
 <24cb7ff5-dec8-3c84-b23e-4170d331a4d2@intel.com>
 <c1ee978d787b4e43af4619fb4ef0bfc1@huawei.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <c1ee978d787b4e43af4619fb4ef0bfc1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 6/28/22 10:14, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Yi Liu [mailto:yi.l.liu@intel.com]
>> Sent: 18 May 2022 15:01
>> To: zhangfei.gao@foxmail.com; Jason Gunthorpe <jgg@nvidia.com>;
>> Zhangfei Gao <zhangfei.gao@linaro.org>
>> Cc: eric.auger@redhat.com; Alex Williamson <alex.williamson@redhat.com>;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> cohuck@redhat.com; qemu-devel@nongnu.org;
>> david@gibson.dropbear.id.au; thuth@redhat.com; farman@linux.ibm.com;
>> mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
>> jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
>> nicolinc@nvidia.com; eric.auger.pro@gmail.com; kevin.tian@intel.com;
>> chao.p.peng@intel.com; yi.y.sun@intel.com; peterx@redhat.com
>> Subject: Re: [RFC 00/18] vfio: Adopt iommufd
>>
>> On 2022/5/18 15:22, zhangfei.gao@foxmail.com wrote:
>>>
>>> On 2022/5/17 下午4:55, Yi Liu wrote:
>>>> Hi Zhangfei,
>>>>
>>>> On 2022/5/12 17:01, zhangfei.gao@foxmail.com wrote:
>>>>> Hi, Yi
>>>>>
>>>>> On 2022/5/11 下午10:17, zhangfei.gao@foxmail.com wrote:
>>>>>>
>>>>>> On 2022/5/10 下午10:08, Yi Liu wrote:
>>>>>>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>>>>>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>>>>>>> Thanks Yi and Eric,
>>>>>>>>> Then will wait for the updated iommufd kernel for the PCI MMIO
>> region.
>>>>>>>>> Another question,
>>>>>>>>> How to get the iommu_domain in the ioctl.
>>>>>>>> The ID of the iommu_domain (called the hwpt) it should be returned
>> by
>>>>>>>> the vfio attach ioctl.
>>>>>>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>>>>>>> qemu. You can query page table related capabilities with this id.
>>>>>>>
>>>>>>>
>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/
>>>>>> Thanks Yi,
>>>>>>
>>>>>> Do we use iommufd_hw_pagetable_from_id in kernel?
>>>>>>
>>>>>> The qemu send hwpt_id via ioctl.
>>>>>> Currently VFIOIOMMUFDContainer has hwpt_list,
>>>>>> Which member is good to save hwpt_id, IOMMUTLBEntry?
>>>>> Can VFIOIOMMUFDContainer  have multi hwpt?
>>>> yes, it is possible
>>> Then how to get hwpt_id in map/unmap_notify(IOMMUNotifier *n,
>> IOMMUTLBEntry
>>> *iotlb)
>> in map/unmap, should use ioas_id instead of hwpt_id
>>
>>>>> Since VFIOIOMMUFDContainer has hwpt_list now.
>>>>> If so, how to get specific hwpt from map/unmap_notify in hw/vfio/as.c,
>>>>> where no vbasedev can be used for compare.
>>>>>
>>>>> I am testing with a workaround, adding VFIOIOASHwpt *hwpt in
>>>>> VFIOIOMMUFDContainer.
>>>>> And save hwpt when vfio_device_attach_container.
>>>>>
>>>>>> In kernel ioctl: iommufd_vfio_ioctl
>>>>>> @dev: Device to get an iommu_domain for
>>>>>> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id,
>>>>>> struct device *dev)
>>>>>> But iommufd_vfio_ioctl seems no para dev?
>>>>> We can set dev=Null since IOMMUFD_OBJ_HW_PAGETABLE does not
>> need dev.
>>>>> iommufd_hw_pagetable_from_id(ictx, hwpt_id, NULL)
>>>> this is not good. dev is passed in to this function to allocate domain
>>>> and also check sw_msi things. If you pass in a NULL, it may even unable
>>>> to get a domain for the hwpt. It won't work I guess.
>>> The iommufd_hw_pagetable_from_id can be used for
>>> 1, allocate domain, which need para dev
>>> case IOMMUFD_OBJ_IOAS
>>> hwpt = iommufd_hw_pagetable_auto_get(ictx, ioas, dev);
>> this is used when attaching ioas.
>>
>>> 2. Just return allocated domain via hwpt_id, which does not need dev.
>>> case IOMMUFD_OBJ_HW_PAGETABLE:
>>> return container_of(obj, struct iommufd_hw_pagetable, obj);
>> yes, this would be the usage in nesting. you may check my below
>> branch. It's for nesting integration.
>>
>> https://github.com/luxis1999/iommufd/tree/iommufd-v5.18-rc4-nesting
>>
>>> By the way, any plan of the nested mode?
>> I'm working with Eric, Nic on it. Currently, I've got the above kernel
>> branch, QEMU side is also WIP.
> Hi Yi/Eric,
>
> I had a look at the above nesting kernel and Qemu branches and as mentioned
> in the cover letter it is not working on ARM yet.
>
> IIUC, to get it working via the iommufd the main thing is we need a way to configure
> the phys SMMU in nested mode and setup the mappings for the stage 2. The
> Cache/PASID related changes looks more straight forward. 
>
> I had quite a few hacks to get it working on ARM, but still a WIP. So just wondering
> do you guys have something that can be shared yet?

I am working on the respin based on latest iommufd kernel branches and
qemu RFC v2 but it is still WIP.

I will share as soon as possible.

Eric
>
> Please let me know.
>
> Thanks,
> Shameer

