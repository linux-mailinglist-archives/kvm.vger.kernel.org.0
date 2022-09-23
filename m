Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46B45E7EAD
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 17:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiIWPmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiIWPlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 11:41:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BC9356F2
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663947656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xp8n9BEf2cideoJzS91rRhX1GcOR1oLq3Ya8y4rm+XA=;
        b=XXLyC9b7HS3f+adqEjUElOBBHE+mzkk6GbWFLb4SZZrOSJH9i8e1WAZpFgm5wVUcGYtkci
        UsfnFhPxEExBb47dFHZ1IA4OissJDyajLVreptoZZrsU7hsHxOsLc3j3Hh9/VxkKPl1CGV
        F4n3fHH4Qq7VCR4doHWKin3U2rWrboM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-4O7eUNYKNpWzBVIqVyONVg-1; Fri, 23 Sep 2022 11:40:54 -0400
X-MC-Unique: 4O7eUNYKNpWzBVIqVyONVg-1
Received: by mail-qv1-f71.google.com with SMTP id y16-20020a0cec10000000b004a5df9e16c6so133345qvo.1
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 08:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Xp8n9BEf2cideoJzS91rRhX1GcOR1oLq3Ya8y4rm+XA=;
        b=cSGpOTPZHEzsHiI/JwJr7jWh1r6cwMGqASczRd6eCulDvsspSIci1BSrvl6Jkgk+Xn
         H+Rvj7iG2dIfTeiE0nXk+FOuh6A7EpDJOLmVbqlIdU3kc3Bxt7vMsGWXtM6ogZrsCHjW
         ClTlBAO8M1PBqyb6p6nZV6JTulQQG4olmg2RQuS71lbnK6FfI1q/IU1Q6yCzewVJo+DU
         9J7Gopzk4C/eRHuGE0pYLHlldP+uh2VGQNQK5uCJJfg/eAYgbchuKUJ4rrFFs8tfr+Hv
         /v+yn+dbhOcYwSt3QO9FUSSADg0Z80sNLFoGsFlnXGOT1lp8fOOfoOvcHKfSMjt9wxZT
         7NQQ==
X-Gm-Message-State: ACrzQf2LfXen7+5oqdTO/ni52Tpz+jT/GyPvwrYE46czUDG/jfWYjznT
        aBVCnq6Dk5aP/rGfDIQEf3wPGyWP515NHfbiEZpQjIC1diW9sZT31Nh2FZswoPQuDGPZLXQFh1q
        hKumJZN9hjpLF
X-Received: by 2002:ac8:5dca:0:b0:35c:e21f:92c3 with SMTP id e10-20020ac85dca000000b0035ce21f92c3mr7680825qtx.473.1663947653752;
        Fri, 23 Sep 2022 08:40:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7McETnyWeZqSsJy9tBmfBBxJ6KYuvTm+i4mmh6h2wmwYz+cY/0Iu/IQgWKvi4pAWDbujCD5A==
X-Received: by 2002:ac8:5dca:0:b0:35c:e21f:92c3 with SMTP id e10-20020ac85dca000000b0035ce21f92c3mr7680778qtx.473.1663947653514;
        Fri, 23 Sep 2022 08:40:53 -0700 (PDT)
Received: from ?IPV6:2600:8805:3a00:3:3b4f:6d3c:92c4:a5c7? ([2600:8805:3a00:3:3b4f:6d3c:92c4:a5c7])
        by smtp.gmail.com with ESMTPSA id x15-20020a05620a448f00b006a5d2eb58b2sm6380921qkp.33.2022.09.23.08.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 08:40:52 -0700 (PDT)
Message-ID: <5ae777d2-f95c-d8bb-5405-192a89f16e90@redhat.com>
Date:   Fri, 23 Sep 2022 11:40:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
References: <YyxFEpAOC2V1SZwk@redhat.com> <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com> <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com> <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com> <Yy20xURdYLzf0ikS@nvidia.com>
 <Yy22GFgrcyMyt3q1@redhat.com> <Yy24rX8NQkxR2KCV@nvidia.com>
 <Yy28FzEnoKo8UExU@redhat.com>
From:   Laine Stump <laine@redhat.com>
Organization: Red Hat
In-Reply-To: <Yy28FzEnoKo8UExU@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 10:00 AM, Daniel P. Berrangé wrote:
> On Fri, Sep 23, 2022 at 10:46:21AM -0300, Jason Gunthorpe wrote:
>> On Fri, Sep 23, 2022 at 02:35:20PM +0100, Daniel P. Berrangé wrote:
>>> On Fri, Sep 23, 2022 at 10:29:41AM -0300, Jason Gunthorpe wrote:
>>>> On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrangé wrote:
>>>>
>>>>> Yes, we use cgroups extensively already.
>>>>
>>>> Ok, I will try to see about this
>>>>
>>>> Can you also tell me if the selinux/seccomp will prevent qemu from
>>>> opening more than one /dev/vfio/vfio ? I suppose the answer is no?
>>>
>>> I don't believe there's any restriction on the nubmer of open attempts,
>>> its just a case of allowed or denied globally for the VM.
>>
>> Ok
>>
>> For iommufd we plan to have qemu accept a single already opened FD of
>> /dev/iommu and so the selinux/etc would block all access to the
>> chardev.
> 
> A selinux policy update would be needed to allow read()/write() for the
> inherited FD, whle keeping open() blocked
> 
>> Can you tell me if the thing invoking qmeu that will open /dev/iommu
>> will have CAP_SYS_RESOURCE ? I assume yes if it is already touching
>> ulimits..
> 
> The privileged libvirtd runs with privs equiv to root, so all
> capabilities are present.
> 
> The unprivileged libvirtd runs with same privs as your user account,
> so no capabilities. I vaguely recall there was some way to enable
> use of PCI passthrough for unpriv libvirtd, but needed a bunch of
> admin setup steps ahead of time.

It's been a few years, but my recollection is that before starting a 
libvirtd that will run a guest with a vfio device, a privileged process 
needs to

1) increase the locked memory limit for the user that will be running 
qemu (eg. by adding a file with the increased limit to 
/etc/security/limits.d)

2) bind the device to the vfio-pci driver, and

3) chown /dev/vfio/$iommu_group to the user running qemu.

