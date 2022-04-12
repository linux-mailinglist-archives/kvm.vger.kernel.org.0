Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804F14FE9C3
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 23:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiDLVDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 17:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiDLVDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 17:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ECE4C6268
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649796637;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VTclCY2PTi8CSDgKlOSlZc3QOg3fg6Ez1f25r7u5uXA=;
        b=cJvAz0dStEskVLvEuMEWKc/J178PL4CXa5iALCcSluT48CtQfUH/0GBZ6CF93oyAdZjPwE
        Bwiy6EzxiPln6+S7A4GlP+VMC+VuxQJJ/3NcheMwz5Nrg13sTa1femM5gSI3ty481BFbhF
        NxVkDuf2knStlNLN7BCGI8yjOnLUBrI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-h-798xQiM7qVsgMBHqgKxA-1; Tue, 12 Apr 2022 16:50:36 -0400
X-MC-Unique: h-798xQiM7qVsgMBHqgKxA-1
Received: by mail-wm1-f69.google.com with SMTP id g13-20020a1c4e0d000000b0038eba16aa46so1742280wmh.7
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=VTclCY2PTi8CSDgKlOSlZc3QOg3fg6Ez1f25r7u5uXA=;
        b=skql1c6ByfVsHGkTkW1EX4gcpU0noJZ+tHrrBCqHYrQT9EwAQjr+yEiR4S29OdGagm
         hPqciPeGmKUaVppiXwUtCYfkJ6CafBI8so9lrkI8VHGOR9g6AD8QTK15K4PXBYM28Lvo
         EDVGLQFJ4KvHCpnADz6/Jhke2Zhwqd5scqUGQNxUL0S1q0f3u3R+a5F1sNQpZY9tx3X1
         7HLbNpuRQExX9gqYg2fxUyyRxmhTh7oXEI0d9LKn0CEFxUtv4Pijz8T+hiC8BujllFk9
         U+kR3e/xuWJnsdA6xRHSojkmL6g4yYZbFdFlHbGRQUc+T+QOT9qcUD+LlodTDanK5Sk/
         fEqg==
X-Gm-Message-State: AOAM530rYi6OkVzFhKbyK56rcHmsXHhffXeHwYPcpF3De10fCI/mrm5U
        T3BGDMunt9LwNV6bFBbp28WaFl7UOdownPnbRKoLAEDAX9XEagv4aylULtuqqBF4FmhZw7SSsPo
        eqc/Ri87mzS7r
X-Received: by 2002:adf:c10b:0:b0:1ed:c40f:7f91 with SMTP id r11-20020adfc10b000000b001edc40f7f91mr29804508wre.276.1649796635544;
        Tue, 12 Apr 2022 13:50:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmJKPemp0S1viyNeeGB5SVWz2K1HYl+erdOjRDV3JLEfZWouYnHyc+zRQG1SoY56CZE5J71w==
X-Received: by 2002:adf:c10b:0:b0:1ed:c40f:7f91 with SMTP id r11-20020adfc10b000000b001edc40f7f91mr29804494wre.276.1649796635277;
        Tue, 12 Apr 2022 13:50:35 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b0038e5ca446bcsm484112wmp.5.2022.04.12.13.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:50:34 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFC 00/12] IOMMUFD Generic interface
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <17084696-4b85-8fe7-47e0-b15d4c56d403@redhat.com>
 <20220412202239.GL2120790@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <80cceffd-6213-7c85-e50a-71b931bd0b80@redhat.com>
Date:   Tue, 12 Apr 2022 22:50:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220412202239.GL2120790@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/12/22 10:22 PM, Jason Gunthorpe wrote:
> On Tue, Apr 12, 2022 at 10:13:32PM +0200, Eric Auger wrote:
>> Hi,
>>
>> On 3/18/22 6:27 PM, Jason Gunthorpe wrote:
>>> iommufd is the user API to control the IOMMU subsystem as it relates to
>>> managing IO page tables that point at user space memory.
>>>
>>> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
>>> container) which is the VFIO specific interface for a similar idea.
>>>
>>> We see a broad need for extended features, some being highly IOMMU device
>>> specific:
>>>  - Binding iommu_domain's to PASID/SSID
>>>  - Userspace page tables, for ARM, x86 and S390
>>>  - Kernel bypass'd invalidation of user page tables
>>>  - Re-use of the KVM page table in the IOMMU
>>>  - Dirty page tracking in the IOMMU
>>>  - Runtime Increase/Decrease of IOPTE size
>>>  - PRI support with faults resolved in userspace
>> This series does not have any concept of group fds anymore and the API
>> is device oriented.
>> I have a question wrt pci bus reset capability.
>>
>> 8b27ee60bfd6 ("vfio-pci: PCI hot reset interface")
>> introduced VFIO_DEVICE_PCI_GET_HOT_RESET_INFO and VFIO_DEVICE_PCI_HOT_RESET
>>
>> Maybe we can reuse VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to retrieve the devices and iommu groups that need to be checked and involved in the bus reset. If I understand correctly we now need to make sure the devices are handled in the same security context (bound to the same iommufd)
>>
>> however VFIO_DEVICE_PCI_HOT_RESET operate on a collection of group fds.
>>
>> How do you see the porting of this functionality onto /dev/iommu?
> I already made a patch that converts VFIO_DEVICE_PCI_HOT_RESET to work
> on a generic notion of a file and the underlying infrastructure to
> allow it to accept either a device or group fd.
>
> Same for the similar issue in KVM.
>
> It is part of three VFIO series I will be posting. First is up here:
>
> https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com/
>
> Overall the strategy is to contain the vfio_group as an internal detail
> of vfio.ko and external interfaces use either a struct vfio_device *
> or a struct file *
Thank you for the quick reply. Yi and I will look at this series. I
guess we won't support the bus reset functionality in our first QEMU
porting onto /dev/iommu until that code stabilizes.

Eric
>
> Jason
>

