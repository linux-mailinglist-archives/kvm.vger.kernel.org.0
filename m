Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522C5623BDB
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiKJGaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJGaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:30:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3967F22BF0
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668061753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXL488ZlRihLJDGsyo7LynfcXA9LIsju9BjG5bCePW0=;
        b=Dd4mumQXwVlcTn10spNGkf9ORk96nFMPsJZOjsiKGl75pYiLC7wJcSMP0ocIbhtZN4L15N
        RHmRo5bfg6n7gr5w1Kv3c2CknN3GslJVIrV5bxLzgoa88vjSdZwR+QdFX5EXeJmtWsLriS
        Bk1y00OQXxz2WvafCRVdIZJCOW+sVGk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-41-FEcV1GiwM3eFl42cI9j5-w-1; Thu, 10 Nov 2022 01:29:11 -0500
X-MC-Unique: FEcV1GiwM3eFl42cI9j5-w-1
Received: by mail-pj1-f71.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so625457pjm.0
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 22:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXL488ZlRihLJDGsyo7LynfcXA9LIsju9BjG5bCePW0=;
        b=sj/yCOwo5Ge6EYeHvMn64iFrB9xpgcQtxr8ja0vPEMhSlal3i+yowY48LO52UR6MSs
         g92MCLxWCIyC6m7GHaJ448GN4sBiPGyl8OS1NF+QKeSfHmdTPYnQgpGwzTLBcMoCQN5J
         zJmyYIFrCGpjxE+9ffoaitRGZpN1bpH11DkKUMmLf3VIuMLwUoZiQ9Cu8UwK8vlCpUFY
         CLyac9+8XGDoAsTFPiDMbzqCw7sKK03uNopVld0EoEH9bUkd4VTwdiE8UXI8dNawUaWU
         12kBjQZF+kT2foSQDHaHJKFHZEj8zraG5Vbg9KAiJnjlmT/Unm69c1d/l5+5XqtxI95G
         u46g==
X-Gm-Message-State: ACrzQf1Ka5yJAi7rPE/WhYExZmijQDxjY6mJJSVE2sYyTjpKw5dosu62
        zYqd7yRuuB3Apjuc4uEhjj0CdH7GUM6tFDy9jajj+sV1IXdIlKC/AOkjfVa8MW37Uu+fy6gACEk
        pm3EWxBwd39M9
X-Received: by 2002:a17:903:1112:b0:179:ce23:dd57 with SMTP id n18-20020a170903111200b00179ce23dd57mr65794248plh.114.1668061750384;
        Wed, 09 Nov 2022 22:29:10 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4mf9RY6PyttgDBnKdDNRbK5f5baxgGmhqkMWLWgVsRnQr/d90cG17GYrXFcDpLBVwNcGLcfg==
X-Received: by 2002:a17:903:1112:b0:179:ce23:dd57 with SMTP id n18-20020a170903111200b00179ce23dd57mr65794233plh.114.1668061750057;
        Wed, 09 Nov 2022 22:29:10 -0800 (PST)
Received: from [10.72.13.112] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b00176acd80f69sm10312943plh.102.2022.11.09.22.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 22:29:07 -0800 (PST)
Message-ID: <d59c311f-ba9f-4c00-28f8-c50e099adb9f@redhat.com>
Date:   Thu, 10 Nov 2022 14:29:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH 0/4] ifcvf/vDPA implement features provisioning
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
 <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com>
 <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com>
 <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
 <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com>
 <CACGkMEu-5TbA3Ky2qgn-ivfhgfJ2b12mDJgq8iNgHce8qu3ApA@mail.gmail.com>
 <03657084-98ab-93bc-614a-e6cc7297d93e@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <03657084-98ab-93bc-614a-e6cc7297d93e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/10 14:20, Zhu, Lingshan 写道:
>
>
> On 11/10/2022 11:49 AM, Jason Wang wrote:
>> On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan <lingshan.zhu@intel.com> 
>> wrote:
>>>
>>>
>>> On 11/9/2022 4:59 PM, Jason Wang wrote:
>>>> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan 
>>>> <lingshan.zhu@intel.com> wrote:
>>>>>
>>>>> On 11/9/2022 2:51 PM, Jason Wang wrote:
>>>>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan 
>>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>> This series implements features provisioning for ifcvf.
>>>>>>> By applying this series, we allow userspace to create
>>>>>>> a vDPA device with selected (management device supported)
>>>>>>> feature bits and mask out others.
>>>>>> I don't see a direct relationship between the first 3 and the last.
>>>>>> Maybe you can state the reason why the restructure is a must for the
>>>>>> feature provisioning. Otherwise, we'd better split the series.
>>>>> When introducing features provisioning ability to ifcvf, there is 
>>>>> a need
>>>>> to re-create vDPA devices
>>>>> on a VF with different feature bits.
>>>> This seems a requirement even without feature provisioning? Device
>>>> could be deleted from the management device anyhow.
>>> Yes, we need this to delete and re-create a vDPA device.
>> I wonder if we need something that works for -stable.
> I can add a fix tag, so these three patches could apply to stable


It's too huge for -stable.


>>
>> AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
>> and it seems to work?
> Yes and this is done in this series and that's why we need these
> refactoring code.


I meant there's probably no need to change the association of existing 
structure but just do the allocation in dev_add(), then we will have a 
patch with much more small changeset that fit for -stable.

Thanks


>
> By the way, do you have any comments to the patches?
>
> Thanks,
> Zhu Lingshan
>>
>> Thanks
>>
>>> We create vDPA device from a VF, so without features provisioning
>>> requirements,
>>> we don't need to re-create the vDPA device. But with features 
>>> provisioning,
>>> it is a must now.
>>>
>>> Thanks
>>>
>>>
>>>> Thakns
>>>>
>>>>> When remove a vDPA device, the container of struct vdpa_device 
>>>>> (here is
>>>>> ifcvf_adapter) is free-ed in
>>>>> dev_del() interface, so we need to allocate ifcvf_adapter in 
>>>>> dev_add()
>>>>> than in probe(). That's
>>>>> why I have re-factored the adapter/mgmt_dev code.
>>>>>
>>>>> For re-factoring the irq related code and ifcvf_base, let them 
>>>>> work on
>>>>> struct ifcvf_hw, the
>>>>> reason is that the adapter is allocated in dev_add(), if we want 
>>>>> theses
>>>>> functions to work
>>>>> before dev_add(), like in probe, we need them work on ifcvf_hw 
>>>>> than the
>>>>> adapter.
>>>>>
>>>>> Thanks
>>>>> Zhu Lingshan
>>>>>> Thanks
>>>>>>
>>>>>>> Please help review
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>> Zhu Lingshan (4):
>>>>>>>      vDPA/ifcvf: ifcvf base layer interfaces work on struct 
>>>>>>> ifcvf_hw
>>>>>>>      vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>>>>>>>      vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>>>>>>>      vDPA/ifcvf: implement features provisioning
>>>>>>>
>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>>>>>>     drivers/vdpa/ifcvf/ifcvf_main.c | 156 
>>>>>>> +++++++++++++++-----------------
>>>>>>>     3 files changed, 89 insertions(+), 109 deletions(-)
>>>>>>>
>>>>>>> -- 
>>>>>>> 2.31.1
>>>>>>>
>

