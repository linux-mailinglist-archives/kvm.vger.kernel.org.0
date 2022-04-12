Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BDE4FEB6F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiDLX0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiDLX0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:26:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A538E995D
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649803221;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EoTkodGmTU1+tJZgbXkA3tP7XKzNOjOQ2bLCDimVkQA=;
        b=cNA7ZlqRRsi5OSOwHUioaA9sRr8m3jv1yn7qsdtxaaZCHXvQ8fhwUrQlVPuUCYFQ/+tYQI
        T3rAMe2dn9o2R4zVNPkU3Tl5eo0hzevEvZsCHC4U56ALlHGyCQug4dhoSxja6q+gDTENF9
        JBjzUL4MhVuSw8L8xt6gPSzD21Xnpgk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-Jzv5tlCYNh6WImUNQBmDXg-1; Tue, 12 Apr 2022 16:13:37 -0400
X-MC-Unique: Jzv5tlCYNh6WImUNQBmDXg-1
Received: by mail-wm1-f71.google.com with SMTP id bg8-20020a05600c3c8800b0038e6a989925so6227573wmb.3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=EoTkodGmTU1+tJZgbXkA3tP7XKzNOjOQ2bLCDimVkQA=;
        b=Q0DhmAQdloNn/5bOps8ftCldDzuGDMdZfuPSDST8/XlJFYb0vOa/67Rk2gOAvvXB8s
         hrw2xQR8RJ0kwCrMUnNpljZvwnrFzj+/dHmqaAK0ikGF7A12AfurdniEPekpxUfkacAH
         Jj0wrpSKlZd2GjDZQnm73cADnYwK0qNaUoZ9WWmMnDgPs1RwhusC57mF7CZJAqzM0qDd
         vyEmyE3nJcorbagcqWBZTRmYCSNAPvjhMg+8ULuYGkOvfAM25qpmxntRQ+m5LaOa6acB
         Q6xVJQNWrdbPUX+ofxcfodm5LSnenVflJiq0EU2cInE2Wm7OTPYbk0zFSS5MtnQouL3k
         jbbQ==
X-Gm-Message-State: AOAM530C5uzPViKBA7XcBn5BTvpYBuGpwbKOWqZm6u2M0JV9Z99FQ1Fd
        h4AxynkgSPoPHc1y5sUB8uRqTLUiSUkMmFrZxvFnJUeA3SyLM85R5JasEuScSC8Nza1pg+W5Wkr
        wYQbOEa/vALgC
X-Received: by 2002:a05:600c:1e17:b0:38e:ba41:2465 with SMTP id ay23-20020a05600c1e1700b0038eba412465mr5500754wmb.132.1649794415686;
        Tue, 12 Apr 2022 13:13:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuvpIudWqzfkPLFtrREp/V1SPbwn+OxDh3VdDXo20THEqWm9qcIEf5Ptz3Ekw3WUtH4dHkGw==
X-Received: by 2002:a05:600c:1e17:b0:38e:ba41:2465 with SMTP id ay23-20020a05600c1e1700b0038eba412465mr5500722wmb.132.1649794415455;
        Tue, 12 Apr 2022 13:13:35 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c4f5200b0038e8f9d7b57sm395024wmq.42.2022.04.12.13.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:13:34 -0700 (PDT)
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
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <17084696-4b85-8fe7-47e0-b15d4c56d403@redhat.com>
Date:   Tue, 12 Apr 2022 22:13:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/18/22 6:27 PM, Jason Gunthorpe wrote:
> iommufd is the user API to control the IOMMU subsystem as it relates to
> managing IO page tables that point at user space memory.
>
> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
> container) which is the VFIO specific interface for a similar idea.
>
> We see a broad need for extended features, some being highly IOMMU device
> specific:
>  - Binding iommu_domain's to PASID/SSID
>  - Userspace page tables, for ARM, x86 and S390
>  - Kernel bypass'd invalidation of user page tables
>  - Re-use of the KVM page table in the IOMMU
>  - Dirty page tracking in the IOMMU
>  - Runtime Increase/Decrease of IOPTE size
>  - PRI support with faults resolved in userspace

This series does not have any concept of group fds anymore and the API
is device oriented.
I have a question wrt pci bus reset capability.

8b27ee60bfd6 ("vfio-pci: PCI hot reset interface")
introduced VFIO_DEVICE_PCI_GET_HOT_RESET_INFO and VFIO_DEVICE_PCI_HOT_RESET

Maybe we can reuse VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to retrieve the devices and iommu groups that need to be checked and involved in the bus reset. If I understand correctly we now need to make sure the devices are handled in the same security context (bound to the same iommufd)

however VFIO_DEVICE_PCI_HOT_RESET operate on a collection of group fds.

How do you see the porting of this functionality onto /dev/iommu?

Thanks

Eric




>
> As well as a need to access these features beyond just VFIO, VDPA for
> instance, but other classes of accelerator HW are touching on these areas
> now too.
>
> The v1 series proposed re-using the VFIO type 1 data structure, however it
> was suggested that if we are doing this big update then we should also
> come with a data structure that solves the limitations that VFIO type1
> has. Notably this addresses:
>
>  - Multiple IOAS/'containers' and multiple domains inside a single FD
>
>  - Single-pin operation no matter how many domains and containers use
>    a page
>
>  - A fine grained locking scheme supporting user managed concurrency for
>    multi-threaded map/unmap
>
>  - A pre-registration mechanism to optimize vIOMMU use cases by
>    pre-pinning pages
>
>  - Extended ioctl API that can manage these new objects and exposes
>    domains directly to user space
>
>  - domains are sharable between subsystems, eg VFIO and VDPA
>
> The bulk of this code is a new data structure design to track how the
> IOVAs are mapped to PFNs.
>
> iommufd intends to be general and consumable by any driver that wants to
> DMA to userspace. From a driver perspective it can largely be dropped in
> in-place of iommu_attach_device() and provides a uniform full feature set
> to all consumers.
>
> As this is a larger project this series is the first step. This series
> provides the iommfd "generic interface" which is designed to be suitable
> for applications like DPDK and VMM flows that are not optimized to
> specific HW scenarios. It is close to being a drop in replacement for the
> existing VFIO type 1.
>
> This is part two of three for an initial sequence:
>  - Move IOMMU Group security into the iommu layer
>    https://lore.kernel.org/linux-iommu/20220218005521.172832-1-baolu.lu@linux.intel.com/
>  * Generic IOMMUFD implementation
>  - VFIO ability to consume IOMMUFD
>    An early exploration of this is available here:
>     https://github.com/luxis1999/iommufd/commits/iommufd-v5.17-rc6
>
> Various parts of the above extended features are in WIP stages currently
> to define how their IOCTL interface should work.
>
> At this point, using the draft VFIO series, unmodified qemu has been
> tested to operate using iommufd on x86 and ARM systems.
>
> Several people have contributed directly to this work: Eric Auger, Kevin
> Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have participated in the
> discussions that lead here, and provided ideas. Thanks to all!
>
> This is on github: https://github.com/jgunthorpe/linux/commits/iommufd
>
> # S390 in-kernel page table walker
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> # AMD Dirty page tracking
> Cc: Joao Martins <joao.m.martins@oracle.com>
> # ARM SMMU Dirty page tracking
> Cc: Keqian Zhu <zhukeqian1@huawei.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> # ARM SMMU nesting
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> # Map/unmap performance
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> # VDPA
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> # Power
> Cc: David Gibson <david@gibson.dropbear.id.au>
> # vfio
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> # iommu
> Cc: iommu@lists.linux-foundation.org
> # Collaborators
> Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Jason Gunthorpe (11):
>   interval-tree: Add a utility to iterate over spans in an interval tree
>   iommufd: File descriptor, context, kconfig and makefiles
>   kernel/user: Allow user::locked_vm to be usable for iommufd
>   iommufd: PFN handling for iopt_pages
>   iommufd: Algorithms for PFN storage
>   iommufd: Data structure to provide IOVA to PFN mapping
>   iommufd: IOCTLs for the io_pagetable
>   iommufd: Add a HW pagetable object
>   iommufd: Add kAPI toward external drivers
>   iommufd: vfio container FD ioctl compatibility
>   iommufd: Add a selftest
>
> Kevin Tian (1):
>   iommufd: Overview documentation
>
>  Documentation/userspace-api/index.rst         |    1 +
>  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
>  Documentation/userspace-api/iommufd.rst       |  224 +++
>  MAINTAINERS                                   |   10 +
>  drivers/iommu/Kconfig                         |    1 +
>  drivers/iommu/Makefile                        |    2 +-
>  drivers/iommu/iommufd/Kconfig                 |   22 +
>  drivers/iommu/iommufd/Makefile                |   13 +
>  drivers/iommu/iommufd/device.c                |  274 ++++
>  drivers/iommu/iommufd/hw_pagetable.c          |  142 ++
>  drivers/iommu/iommufd/io_pagetable.c          |  890 +++++++++++
>  drivers/iommu/iommufd/io_pagetable.h          |  170 +++
>  drivers/iommu/iommufd/ioas.c                  |  252 ++++
>  drivers/iommu/iommufd/iommufd_private.h       |  231 +++
>  drivers/iommu/iommufd/iommufd_test.h          |   65 +
>  drivers/iommu/iommufd/main.c                  |  346 +++++
>  drivers/iommu/iommufd/pages.c                 | 1321 +++++++++++++++++
>  drivers/iommu/iommufd/selftest.c              |  495 ++++++
>  drivers/iommu/iommufd/vfio_compat.c           |  401 +++++
>  include/linux/interval_tree.h                 |   41 +
>  include/linux/iommufd.h                       |   50 +
>  include/linux/sched/user.h                    |    2 +-
>  include/uapi/linux/iommufd.h                  |  223 +++
>  kernel/user.c                                 |    1 +
>  lib/interval_tree.c                           |   98 ++
>  tools/testing/selftests/Makefile              |    1 +
>  tools/testing/selftests/iommu/.gitignore      |    2 +
>  tools/testing/selftests/iommu/Makefile        |   11 +
>  tools/testing/selftests/iommu/config          |    2 +
>  tools/testing/selftests/iommu/iommufd.c       | 1225 +++++++++++++++
>  30 files changed, 6515 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/userspace-api/iommufd.rst
>  create mode 100644 drivers/iommu/iommufd/Kconfig
>  create mode 100644 drivers/iommu/iommufd/Makefile
>  create mode 100644 drivers/iommu/iommufd/device.c
>  create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.h
>  create mode 100644 drivers/iommu/iommufd/ioas.c
>  create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>  create mode 100644 drivers/iommu/iommufd/iommufd_test.h
>  create mode 100644 drivers/iommu/iommufd/main.c
>  create mode 100644 drivers/iommu/iommufd/pages.c
>  create mode 100644 drivers/iommu/iommufd/selftest.c
>  create mode 100644 drivers/iommu/iommufd/vfio_compat.c
>  create mode 100644 include/linux/iommufd.h
>  create mode 100644 include/uapi/linux/iommufd.h
>  create mode 100644 tools/testing/selftests/iommu/.gitignore
>  create mode 100644 tools/testing/selftests/iommu/Makefile
>  create mode 100644 tools/testing/selftests/iommu/config
>  create mode 100644 tools/testing/selftests/iommu/iommufd.c
>
>
> base-commit: d1c716ed82a6bf4c35ba7be3741b9362e84cd722

