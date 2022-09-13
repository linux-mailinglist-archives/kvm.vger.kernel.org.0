Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A55B68AA
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 09:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiIMH2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiIMH2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 03:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC3058DFA
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 00:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663054106;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iTlJ5mQQRHxbL57eg9d5GSbhHLfOoUAQCN1Y8Wmh04Q=;
        b=S1ciW7LTQYGdPQ9wQFTuxwbkEtQ74c2Y7U908yWIJFuGqtaiH+tAD5N1l8cAy3GpTE3XEG
        H1JOvO3nKi8zIuQ/8B2T/oj4ssWSwwryWjkBI5eoLchV+Rfbo9wJUxjyp+IrqvYcow2z94
        kyEb4HMiHt8GMynUnB1ZDp8rwDxdKDo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-79-2qbgeEjrOvu2sHaRY9XGYQ-1; Tue, 13 Sep 2022 03:28:25 -0400
X-MC-Unique: 2qbgeEjrOvu2sHaRY9XGYQ-1
Received: by mail-qv1-f72.google.com with SMTP id lx4-20020a0562145f0400b00496ecf45ac4so7391723qvb.7
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 00:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=iTlJ5mQQRHxbL57eg9d5GSbhHLfOoUAQCN1Y8Wmh04Q=;
        b=APMfJnJSrcTNzh4klVFYnXkRffOnKjqLnFWazr3EfyAPoKwx8NRV0ZB6dS1BIjT/Sd
         BlQkndVUCjI4rl3sXybkaWBnNWZq8vAO3UewsOxMD7qBMntJc0IEXuvi0o+wrNFgbuW6
         KO+0RFh5WSwHrRlWJUwVJWp8JY10VPZoKDimv4Qrex5+LlaIvFAHn5bVikFo3qANZ40s
         6AOkAWz++1OQ+eeB093MMJGpe3gHPJI8IjHNskCGpFoI3q7JRuiwK+rFJznURwsW8IIB
         FHWj/lawm9kDCzKHwoDSZglEFyrS7Q6jQbStHviVlg2mEcuSKOEJcvibLhlXM9wZ25oD
         EaeQ==
X-Gm-Message-State: ACgBeo2MSo6kfmzOqgwsg1Y362dH7ie/OdZEGLnMrzkNS1Qcg6NJKlHU
        Tb7sHJuh8qsoR30wRl2xBKhLJqUGvRkmpCNhNeywVHtQMjjS+FFCtaeRIYCp1LzPmrcK3vfDK2A
        jZJsx5FIdXQu1
X-Received: by 2002:ac8:5fcf:0:b0:35b:d81d:792e with SMTP id k15-20020ac85fcf000000b0035bd81d792emr1773350qta.24.1663054105052;
        Tue, 13 Sep 2022 00:28:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7JFS/Wf6bR5kdMmWSBaVHGYmccWPlQRnvENRvzTHnh+Je6jWU2QiL20UIivOR4im/TOWS5hA==
X-Received: by 2002:ac8:5fcf:0:b0:35b:d81d:792e with SMTP id k15-20020ac85fcf000000b0035bd81d792emr1773319qta.24.1663054104660;
        Tue, 13 Sep 2022 00:28:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id x12-20020ac85f0c000000b0035bb152d414sm5227049qta.94.2022.09.13.00.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 00:28:24 -0700 (PDT)
Message-ID: <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
Date:   Tue, 13 Sep 2022 09:28:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
        Keqian Zhu <zhukeqian1@huawei.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/13/22 03:55, Tian, Kevin wrote:
> We didn't close the open of how to get this merged in LPC due to the
> audio issue. Then let's use mails.
>
> Overall there are three options on the table:
>
> 1) Require vfio-compat to be 100% compatible with vfio-type1
>
>    Probably not a good choice given the amount of work to fix the remaining
>    gaps. And this will block support of new IOMMU features for a longer time.
>
> 2) Leave vfio-compat as what it is in this series
>
>    Treat it as a vehicle to validate the iommufd logic instead of immediately
>    replacing vfio-type1. Functionally most vfio applications can work w/o
>    change if putting aside the difference on locked mm accounting, p2p, etc.
>
>    Then work on new features and 100% vfio-type1 compat. in parallel.
>
> 3) Focus on iommufd native uAPI first
>
>    Require vfio_device cdev and adoption in Qemu. Only for new vfio app.
>
>    Then work on new features and vfio-compat in parallel.
>
> I'm fine with either 2) or 3). Per a quick chat with Alex he prefers to 3).

I am also inclined to pursue 3) as this was the initial Jason's guidance
and pre-requisite to integrate new features. In the past we concluded
vfio-compat would mostly be used for testing purpose. Our QEMU
integration fully is based on device based API.

Thanks

Eric
>
> Jason, how about your opinion?
>
> Thanks
> Kevin
>
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Saturday, September 3, 2022 3:59 AM
>>
>> iommufd is the user API to control the IOMMU subsystem as it relates to
>> managing IO page tables that point at user space memory.
>>
>> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
>> container) which is the VFIO specific interface for a similar idea.
>>
>> We see a broad need for extended features, some being highly IOMMU
>> device
>> specific:
>>  - Binding iommu_domain's to PASID/SSID
>>  - Userspace page tables, for ARM, x86 and S390
>>  - Kernel bypass'd invalidation of user page tables
>>  - Re-use of the KVM page table in the IOMMU
>>  - Dirty page tracking in the IOMMU
>>  - Runtime Increase/Decrease of IOPTE size
>>  - PRI support with faults resolved in userspace
>>
>> As well as a need to access these features beyond just VFIO, from VDPA for
>> instance. Other classes of accelerator HW are touching on these areas now
>> too.
>>
>> The pre-v1 series proposed re-using the VFIO type 1 data structure,
>> however it was suggested that if we are doing this big update then we
>> should also come with an improved data structure that solves the
>> limitations that VFIO type1 has. Notably this addresses:
>>
>>  - Multiple IOAS/'containers' and multiple domains inside a single FD
>>
>>  - Single-pin operation no matter how many domains and containers use
>>    a page
>>
>>  - A fine grained locking scheme supporting user managed concurrency for
>>    multi-threaded map/unmap
>>
>>  - A pre-registration mechanism to optimize vIOMMU use cases by
>>    pre-pinning pages
>>
>>  - Extended ioctl API that can manage these new objects and exposes
>>    domains directly to user space
>>
>>  - domains are sharable between subsystems, eg VFIO and VDPA
>>
>> The bulk of this code is a new data structure design to track how the
>> IOVAs are mapped to PFNs.
>>
>> iommufd intends to be general and consumable by any driver that wants to
>> DMA to userspace. From a driver perspective it can largely be dropped in
>> in-place of iommu_attach_device() and provides a uniform full feature set
>> to all consumers.
>>
>> As this is a larger project this series is the first step. This series
>> provides the iommfd "generic interface" which is designed to be suitable
>> for applications like DPDK and VMM flows that are not optimized to
>> specific HW scenarios. It is close to being a drop in replacement for the
>> existing VFIO type 1.
>>
>> Several follow-on series are being prepared:
>>
>> - Patches integrating with qemu in native mode:
>>   https://github.com/yiliu1765/qemu/commits/qemu-iommufd-6.0-rc2
>>
>> - A completed integration with VFIO now exists that covers "emulated" mdev
>>   use cases now, and can pass testing with qemu/etc in compatability mode:
>>   https://github.com/jgunthorpe/linux/commits/vfio_iommufd
>>
>> - A draft providing system iommu dirty tracking on top of iommufd,
>>   including iommu driver implementations:
>>   https://github.com/jpemartins/linux/commits/x86-iommufd
>>
>>   This pairs with patches for providing a similar API to support VFIO-device
>>   tracking to give a complete vfio solution:
>>   https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com/
>>
>> - Userspace page tables aka 'nested translation' for ARM and Intel iommu
>>   drivers:
>>   https://github.com/nicolinc/iommufd/commits/iommufd_nesting
>>
>> - "device centric" vfio series to expose the vfio_device FD directly as a
>>   normal cdev, and provide an extended API allowing dynamically changing
>>   the IOAS binding:
>>   https://github.com/yiliu1765/iommufd/commits/iommufd-v6.0-rc2-
>> nesting-0901
>>
>> - Drafts for PASID and PRI interfaces are included above as well
>>
>> Overall enough work is done now to show the merit of the new API design
>> and at least draft solutions to many of the main problems.
>>
>> Several people have contributed directly to this work: Eric Auger, Joao
>> Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have
>> participated in the discussions that lead here, and provided ideas. Thanks
>> to all!
>>
>> The v1 iommufd series has been used to guide a large amount of preparatory
>> work that has now been merged. The general theme is to organize things in
>> a way that makes injecting iommufd natural:
>>
>>  - VFIO live migration support with mlx5 and hisi_acc drivers.
>>    These series need a dirty tracking solution to be really usable.
>>    https://lore.kernel.org/kvm/20220224142024.147653-1-
>> yishaih@nvidia.com/
>>    https://lore.kernel.org/kvm/20220308184902.2242-1-
>> shameerali.kolothum.thodi@huawei.com/
>>
>>  - Significantly rework the VFIO gvt mdev and remove struct
>>    mdev_parent_ops
>>    https://lore.kernel.org/lkml/20220411141403.86980-1-hch@lst.de/
>>
>>  - Rework how PCIe no-snoop blocking works
>>    https://lore.kernel.org/kvm/0-v3-2cf356649677+a32-
>> intel_no_snoop_jgg@nvidia.com/
>>
>>  - Consolidate dma ownership into the iommu core code
>>    https://lore.kernel.org/linux-iommu/20220418005000.897664-1-
>> baolu.lu@linux.intel.com/
>>
>>  - Make all vfio driver interfaces use struct vfio_device consistently
>>    https://lore.kernel.org/kvm/0-v4-8045e76bf00b+13d-
>> vfio_mdev_no_group_jgg@nvidia.com/
>>
>>  - Remove the vfio_group from the kvm/vfio interface
>>    https://lore.kernel.org/kvm/0-v3-f7729924a7ea+25e33-
>> vfio_kvm_no_group_jgg@nvidia.com/
>>
>>  - Simplify locking in vfio
>>    https://lore.kernel.org/kvm/0-v2-d035a1842d81+1bf-
>> vfio_group_locking_jgg@nvidia.com/
>>
>>  - Remove the vfio notifiter scheme that faces drivers
>>    https://lore.kernel.org/kvm/0-v4-681e038e30fd+78-
>> vfio_unmap_notif_jgg@nvidia.com/
>>
>>  - Improve the driver facing API for vfio pin/unpin pages to make the
>>    presence of struct page clear
>>    https://lore.kernel.org/kvm/20220723020256.30081-1-
>> nicolinc@nvidia.com/
>>
>>  - Clean up in the Intel IOMMU driver
>>    https://lore.kernel.org/linux-iommu/20220301020159.633356-1-
>> baolu.lu@linux.intel.com/
>>    https://lore.kernel.org/linux-iommu/20220510023407.2759143-1-
>> baolu.lu@linux.intel.com/
>>    https://lore.kernel.org/linux-iommu/20220514014322.2927339-1-
>> baolu.lu@linux.intel.com/
>>    https://lore.kernel.org/linux-iommu/20220706025524.2904370-1-
>> baolu.lu@linux.intel.com/
>>    https://lore.kernel.org/linux-iommu/20220702015610.2849494-1-
>> baolu.lu@linux.intel.com/
>>
>>  - Rework s390 vfio drivers
>>    https://lore.kernel.org/kvm/20220707135737.720765-1-
>> farman@linux.ibm.com/
>>
>>  - Normalize vfio ioctl handling
>>    https://lore.kernel.org/kvm/0-v2-0f9e632d54fb+d6-
>> vfio_ioctl_split_jgg@nvidia.com/
>>
>> This is about 168 patches applied since March, thank you to everyone
>> involved in all this work!
>>
>> Currently there are a number of supporting series still in progress:
>>  - Simplify and consolidate iommu_domain/device compatability checking
>>    https://lore.kernel.org/linux-iommu/20220815181437.28127-1-
>> nicolinc@nvidia.com/
>>
>>  - Align iommu SVA support with the domain-centric model
>>    https://lore.kernel.org/linux-iommu/20220826121141.50743-1-
>> baolu.lu@linux.intel.com/
>>
>>  - VFIO API for dirty tracking (aka dma logging) managed inside a PCI
>>    device, with mlx5 implementation
>>    https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com
>>
>>  - Introduce a struct device sysfs presence for struct vfio_device
>>    https://lore.kernel.org/kvm/20220901143747.32858-1-
>> kevin.tian@intel.com/
>>
>>  - Complete restructuring the vfio mdev model
>>    https://lore.kernel.org/kvm/20220822062208.152745-1-hch@lst.de/
>>
>>  - DMABUF exporter support for VFIO to allow PCI P2P with VFIO
>>    https://lore.kernel.org/r/0-v2-472615b3877e+28f7-
>> vfio_dma_buf_jgg@nvidia.com
>>
>>  - Isolate VFIO container code in preperation for iommufd to provide an
>>    alternative implementation of it all
>>    https://lore.kernel.org/kvm/0-v1-a805b607f1fb+17b-
>> vfio_container_split_jgg@nvidia.com
>>
>>  - Start to provide iommu_domain ops for power
>>    https://lore.kernel.org/all/20220714081822.3717693-1-aik@ozlabs.ru/
>>
>> Right now there is no more preperatory work sketched out, so this is the
>> last of it.
>>
>> This series remains RFC as there are still several important FIXME's to
>> deal with first, but things are on track for non-RFC in the near future.
>>
>> This is on github: https://github.com/jgunthorpe/linux/commits/iommufd
>>
>> v2:
>>  - Rebase to v6.0-rc3
>>  - Improve comments
>>  - Change to an iterative destruction approach to avoid cycles
>>  - Near rewrite of the vfio facing implementation, supported by a complete
>>    implementation on the vfio side
>>  - New IOMMU_IOAS_ALLOW_IOVAS API as discussed. Allows userspace to
>>    assert that ranges of IOVA must always be mappable. To be used by a
>> VMM
>>    that has promised a guest a certain availability of IOVA. May help
>>    guide PPC's multi-window implementation.
>>  - Rework how unmap_iova works, user can unmap the whole ioas now
>>  - The no-snoop / wbinvd support is implemented
>>  - Bug fixes
>>  - Test suite improvements
>>  - Lots of smaller changes (the interdiff is 3k lines)
>> v1: https://lore.kernel.org/r/0-v1-e79cd8d168e8+6-
>> iommufd_jgg@nvidia.com
>>
>> # S390 in-kernel page table walker
>> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
>> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
>> # AMD Dirty page tracking
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> # ARM SMMU Dirty page tracking
>> Cc: Keqian Zhu <zhukeqian1@huawei.com>
>> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> # ARM SMMU nesting
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> # Map/unmap performance
>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>> # VDPA
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> # Power
>> Cc: David Gibson <david@gibson.dropbear.id.au>
>> # vfio
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: kvm@vger.kernel.org
>> # iommu
>> Cc: iommu@lists.linux.dev
>> # Collaborators
>> Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
>> Cc: Nicolin Chen <nicolinc@nvidia.com>
>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Yi Liu <yi.l.liu@intel.com>
>> # s390
>> Cc: Eric Farman <farman@linux.ibm.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>
>> Jason Gunthorpe (12):
>>   interval-tree: Add a utility to iterate over spans in an interval tree
>>   iommufd: File descriptor, context, kconfig and makefiles
>>   kernel/user: Allow user::locked_vm to be usable for iommufd
>>   iommufd: PFN handling for iopt_pages
>>   iommufd: Algorithms for PFN storage
>>   iommufd: Data structure to provide IOVA to PFN mapping
>>   iommufd: IOCTLs for the io_pagetable
>>   iommufd: Add a HW pagetable object
>>   iommufd: Add kAPI toward external drivers for physical devices
>>   iommufd: Add kAPI toward external drivers for kernel access
>>   iommufd: vfio container FD ioctl compatibility
>>   iommufd: Add a selftest
>>
>> Kevin Tian (1):
>>   iommufd: Overview documentation
>>
>>  .clang-format                                 |    1 +
>>  Documentation/userspace-api/index.rst         |    1 +
>>  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
>>  Documentation/userspace-api/iommufd.rst       |  224 +++
>>  MAINTAINERS                                   |   10 +
>>  drivers/iommu/Kconfig                         |    1 +
>>  drivers/iommu/Makefile                        |    2 +-
>>  drivers/iommu/iommufd/Kconfig                 |   22 +
>>  drivers/iommu/iommufd/Makefile                |   13 +
>>  drivers/iommu/iommufd/device.c                |  580 +++++++
>>  drivers/iommu/iommufd/hw_pagetable.c          |   68 +
>>  drivers/iommu/iommufd/io_pagetable.c          |  984 ++++++++++++
>>  drivers/iommu/iommufd/io_pagetable.h          |  186 +++
>>  drivers/iommu/iommufd/ioas.c                  |  338 ++++
>>  drivers/iommu/iommufd/iommufd_private.h       |  266 ++++
>>  drivers/iommu/iommufd/iommufd_test.h          |   74 +
>>  drivers/iommu/iommufd/main.c                  |  392 +++++
>>  drivers/iommu/iommufd/pages.c                 | 1301 +++++++++++++++
>>  drivers/iommu/iommufd/selftest.c              |  626 ++++++++
>>  drivers/iommu/iommufd/vfio_compat.c           |  423 +++++
>>  include/linux/interval_tree.h                 |   47 +
>>  include/linux/iommufd.h                       |  101 ++
>>  include/linux/sched/user.h                    |    2 +-
>>  include/uapi/linux/iommufd.h                  |  279 ++++
>>  kernel/user.c                                 |    1 +
>>  lib/interval_tree.c                           |   98 ++
>>  tools/testing/selftests/Makefile              |    1 +
>>  tools/testing/selftests/iommu/.gitignore      |    2 +
>>  tools/testing/selftests/iommu/Makefile        |   11 +
>>  tools/testing/selftests/iommu/config          |    2 +
>>  tools/testing/selftests/iommu/iommufd.c       | 1396 +++++++++++++++++
>>  31 files changed, 7451 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/userspace-api/iommufd.rst
>>  create mode 100644 drivers/iommu/iommufd/Kconfig
>>  create mode 100644 drivers/iommu/iommufd/Makefile
>>  create mode 100644 drivers/iommu/iommufd/device.c
>>  create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
>>  create mode 100644 drivers/iommu/iommufd/io_pagetable.c
>>  create mode 100644 drivers/iommu/iommufd/io_pagetable.h
>>  create mode 100644 drivers/iommu/iommufd/ioas.c
>>  create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>>  create mode 100644 drivers/iommu/iommufd/iommufd_test.h
>>  create mode 100644 drivers/iommu/iommufd/main.c
>>  create mode 100644 drivers/iommu/iommufd/pages.c
>>  create mode 100644 drivers/iommu/iommufd/selftest.c
>>  create mode 100644 drivers/iommu/iommufd/vfio_compat.c
>>  create mode 100644 include/linux/iommufd.h
>>  create mode 100644 include/uapi/linux/iommufd.h
>>  create mode 100644 tools/testing/selftests/iommu/.gitignore
>>  create mode 100644 tools/testing/selftests/iommu/Makefile
>>  create mode 100644 tools/testing/selftests/iommu/config
>>  create mode 100644 tools/testing/selftests/iommu/iommufd.c
>>
>>
>> base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
>> --
>> 2.37.3

