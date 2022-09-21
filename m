Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8605E564A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiIUWgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 18:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiIUWgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 18:36:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEC89AFBA
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663799791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLSyYLHiY+VNwMQYaxWFu5v3xL7RsNBFdyNkMnW+s54=;
        b=D+HtzeDPyH2GlaoZMR4CxyQZTZnS3mVV4Iyp3tbPMR+vQKpSwyF1JmjCFlwRNEeUtynsL/
        qz6TmBU4NhPkhEw9rkd1HfGqy2lpXp0QDHtaFOeFYqwqW9v8HHS1Ys46oQfuN6hQe3GGUl
        W5rD8rj4PNyZICMY/fk/psa23UiPoqc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-rDZQprHIN0-Ta4R9AOhjPw-1; Wed, 21 Sep 2022 18:36:30 -0400
X-MC-Unique: rDZQprHIN0-Ta4R9AOhjPw-1
Received: by mail-qk1-f199.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso5270648qkp.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=pLSyYLHiY+VNwMQYaxWFu5v3xL7RsNBFdyNkMnW+s54=;
        b=xuLYgqibhBdUnopG32doApCBTXgv2RExCgkZoJTnvO7KXzBZXNLCC9wSKjprjAZuDs
         8Tiotveif80k6iYiP8q3bRpigsjkiK/eD66N9P/cdxg+QwZBl3/215CaxHPlscOoKwE3
         fOTy818Gt2tkOZkWC5JBWXsEb1rfIbW+J1Y9KGTPbXGLDE9aVgghRGSYx/5DI1AY4ceE
         UfWlLW2Sn8KwXFSiNpxGAPM91qQLFt54IhCr94D8OVBLY3Ev8qSTPJv/ck/9Md0nNZuN
         qbpklEy6o+stBkXMFd1wxWAE+6ZMZmsB3tuFor6+jmD9uZjyAMZ5HetZJRX4Ym6amvFg
         CBfA==
X-Gm-Message-State: ACrzQf3XdrNz52l8JwTEdbrtGGoOPxKUy1Y5aHMtIK2TaShDfvSFNjTC
        Q8Ciyv9kXaROn/6vqMBsQStB4KJ2YbO+WdnENptq1J67psHLfO871VE+BKT34qclWrjFt4ML7D0
        BmcqcU9IaDnye
X-Received: by 2002:a05:622a:14d4:b0:35c:db96:8d71 with SMTP id u20-20020a05622a14d400b0035cdb968d71mr530172qtx.327.1663799789464;
        Wed, 21 Sep 2022 15:36:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7bXT2DDzhMBaBuiXz0t9E12+xhzSl9gqDWJ0OwwtO97MDY7PygY6XLt1S3rdo4OUToNYUKwg==
X-Received: by 2002:a05:622a:14d4:b0:35c:db96:8d71 with SMTP id u20-20020a05622a14d400b0035cdb968d71mr530153qtx.327.1663799789162;
        Wed, 21 Sep 2022 15:36:29 -0700 (PDT)
Received: from ?IPV6:2600:8805:3a00:3:3b4f:6d3c:92c4:a5c7? ([2600:8805:3a00:3:3b4f:6d3c:92c4:a5c7])
        by smtp.gmail.com with ESMTPSA id e7-20020ac80647000000b0035bb0cd479csm2249384qth.40.2022.09.21.15.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 15:36:28 -0700 (PDT)
Message-ID: <463d5e09-202f-ca2f-ffb0-c86c8f8b75c9@redhat.com>
Date:   Wed, 21 Sep 2022 18:36:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
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
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
From:   Laine Stump <laine@redhat.com>
Organization: Red Hat
In-Reply-To: <20220921120649.5d2ff778.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/22 2:06 PM, Alex Williamson wrote:
> [Cc+ Steve, libvirt, Daniel, Laine]
> 
> On Tue, 20 Sep 2022 16:56:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Sep 13, 2022 at 09:28:18AM +0200, Eric Auger wrote:
>>> Hi,
>>>
>>> On 9/13/22 03:55, Tian, Kevin wrote:
>>>> We didn't close the open of how to get this merged in LPC due to the
>>>> audio issue. Then let's use mails.
>>>>
>>>> Overall there are three options on the table:
>>>>
>>>> 1) Require vfio-compat to be 100% compatible with vfio-type1
>>>>
>>>>     Probably not a good choice given the amount of work to fix the remaining
>>>>     gaps. And this will block support of new IOMMU features for a longer time.
>>>>
>>>> 2) Leave vfio-compat as what it is in this series
>>>>
>>>>     Treat it as a vehicle to validate the iommufd logic instead of immediately
>>>>     replacing vfio-type1. Functionally most vfio applications can work w/o
>>>>     change if putting aside the difference on locked mm accounting, p2p, etc.
>>>>
>>>>     Then work on new features and 100% vfio-type1 compat. in parallel.
>>>>
>>>> 3) Focus on iommufd native uAPI first
>>>>
>>>>     Require vfio_device cdev and adoption in Qemu. Only for new vfio app.
>>>>
>>>>     Then work on new features and vfio-compat in parallel.
>>>>
>>>> I'm fine with either 2) or 3). Per a quick chat with Alex he prefers to 3).
>>>
>>> I am also inclined to pursue 3) as this was the initial Jason's guidance
>>> and pre-requisite to integrate new features. In the past we concluded
>>> vfio-compat would mostly be used for testing purpose. Our QEMU
>>> integration fully is based on device based API.
>>
>> There are some poor chicken and egg problems here.
>>
>> I had some assumptions:
>>   a - the vfio cdev model is going to be iommufd only
>>   b - any uAPI we add as we go along should be generally useful going
>>       forward
>>   c - we should try to minimize the 'minimally viable iommufd' series
>>
>> The compat as it stands now (eg #2) is threading this needle. Since it
>> can exist without cdev it means (c) is made smaller, to two series.
>>
>> Since we add something useful to some use cases, eg DPDK is deployable
>> that way, (b) is OK.
>>
>> If we focus on a strict path with 3, and avoid adding non-useful code,
>> then we have to have two more (unwritten!) series beyond where we are
>> now - vfio group compartmentalization, and cdev integration, and the
>> initial (c) will increase.
>>
>> 3 also has us merging something that currently has no usable
>> userspace, which I also do dislike alot.
>>
>> I still think the compat gaps are small. I've realized that
>> VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and since it
>> can deadlock the kernel I propose we purge it completely.
> 
> Steve won't be happy to hear that, QEMU support exists but isn't yet
> merged.
>   
>> P2P is ongoing.
>>
>> That really just leaves the accounting, and I'm still not convinced at
>> this must be a critical thing. Linus's latest remarks reported in lwn
>> at the maintainer summit on tracepoints/BPF as ABI seem to support
>> this. Let's see an actual deployed production configuration that would
>> be impacted, and we won't find that unless we move forward.
> 
> I'll try to summarize the proposed change so that we can get better
> advice from libvirt folks, or potentially anyone else managing locked
> memory limits for device assignment VMs.
> 
> Background: when a DMA range, ex. guest RAM, is mapped to a vfio device,
> we use the system IOMMU to provide GPA to HPA translation for assigned
> devices. Unlike CPU page tables, we don't generally have a means to
> demand fault these translations, therefore the memory target of the
> translation is pinned to prevent that it cannot be swapped or
> relocated, ie. to guarantee the translation is always valid.
> 
> The issue is where we account these pinned pages, where accounting is
> necessary such that a user cannot lock an arbitrary number of pages
> into RAM to generate a DoS attack.  Duplicate accounting should be
> resolved by iommufd, but is outside the scope of this discussion.
> 
> Currently, vfio tests against the mm_struct.locked_vm relative to
> rlimit(RLIMIT_MEMLOCK), which reads task->signal->rlim[limit].rlim_cur,
> where task is the current process.  This is the same limit set via the
> setrlimit syscall used by prlimit(1) and reported via 'ulimit -l'.
> 
> Note that in both cases above, we're dealing with a task, or process
> limit and both prlimit and ulimit man pages describe them as such.
> 
> iommufd supposes instead, and references existing kernel
> implementations, that despite the descriptions above these limits are
> actually meant to be user limits and therefore instead charges pinned
> pages against user_struct.locked_vm and also marks them in
> mm_struct.pinned_vm.
> 
> The proposed algorithm is to read the _task_ locked memory limit, then
> attempt to charge the _user_ locked_vm, such that user_struct.locked_vm
> cannot exceed the task locked memory limit.
> 
> This obviously has implications.  AFAICT, any management tool that
> doesn't instantiate assigned device VMs under separate users are
> essentially untenable.  For example, if we launch VM1 under userA and
> set a locked memory limit of 4GB via prlimit to account for an assigned
> device, that works fine, until we launch VM2 from userA as well.  In
> that case we can't simply set a 4GB limit on the VM2 task because
> there's already 4GB charged against user_struct.locked_vm for VM1.  So
> we'd need to set the VM2 task limit to 8GB to be able to launch VM2.
> But not only that, we'd need to go back and also set VM1's task limit
> to 8GB or else it will fail if a DMA mapped memory region is transient
> and needs to be re-mapped.
> 
> Effectively any task under the same user and requiring pinned memory
> needs to have a locked memory limit set, and updated, to account for
> all tasks using pinned memory by that user.
> 
> How does this affect known current use cases of locked memory
> management for assigned device VMs?
> 
> Does qemu://system by default sandbox into per VM uids or do they all
> use the qemu user by default.

Unless it is told otherwise in the XML for the VMs, each qemu process 
uses the same uid (which is usually "qemu", but can be changed in 
systemwide config).

>  I imagine qemu://session mode is pretty
> screwed by this, but I also don't know who/where locked limits are
> lifted for such VMs.  Boxes, who I think now supports assigned device
> VMs, could also be affected.

because qemu:///session runs an unprivileged libvirt (i.e. unable to 
raise the limits), boxes sets the limits elsewhere  beforehand (not sure 
where, as I'm not familiar with boxes source).

>   
>> So, I still like 2 because it yields the smallest next step before we
>> can bring all the parallel work onto the list, and it makes testing
>> and converting non-qemu stuff easier even going forward.
> 
> If a vfio compatible interface isn't transparently compatible, then I
> have a hard time understanding its value.  Please correct my above
> description and implications, but I suspect these are not just
> theoretical ABI compat issues.  Thanks,
> 
> Alex
> 

