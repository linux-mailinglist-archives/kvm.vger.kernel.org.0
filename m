Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1BC50FC30
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbiDZLr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiDZLr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60C0F3B3E6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650973489;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pINpUza2yW3i1/LtapnVwHmIAIjwecqjk0Kj8K0Bres=;
        b=EsUOl/nw2yCYp/BU94lUTCMlnmt7HrE7cwp9af6vysulhGlWOJNtawre79zUlKEdbkrMvg
        GnE6If/P94gMAFL0wovkslHLhfRu/TYVEprT2JJwaiPYwQpYHVrzlGsL7Rs8buDnE71riW
        pHPRPHqd9YWaiG1Bdhy6h7aif5b7dls=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-qaCIAdLZPK6uSSc-n0Eung-1; Tue, 26 Apr 2022 07:44:48 -0400
X-MC-Unique: qaCIAdLZPK6uSSc-n0Eung-1
Received: by mail-wr1-f70.google.com with SMTP id o11-20020adfca0b000000b0020adc114131so122191wrh.8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=pINpUza2yW3i1/LtapnVwHmIAIjwecqjk0Kj8K0Bres=;
        b=k8VETKUQPAZc3wYfzs4Fqzc7q4+RPNo74NIZHrwba89e00oxW7i8T2m+w3ELR4Zz6A
         jTnN/KpSVRArib6A3eRNrMTfXc0aA4pBvSiK5NPDhF3hH10z8of0L3qaEAu8ANQuIed8
         wILwzCVf7S//ZeJP+ZSslDUNRwiJsjWUGo/WZ7xeUlq8Mv0H4KqJigP4atqOpxxQH9wY
         cN/PfaYszxBNHQSrbNi/NBdKjtOX+1Tb5aTHT5a7wOYNtXz1ixB8mHXJRiELoJ/r5bBO
         eE6zJxjx8bYzix7EbgMxvx/4FHvWoWwnRgKPnKVCcYIZUZIvrMaesLoX71GsK1HShPrj
         I2hg==
X-Gm-Message-State: AOAM5315+HhbYSAZsZ6OOvgiEgF8ioZKtfEYqV+gV0iBUd60LIP3C4aC
        yhfbX6Z6fntEyXglXtBwJswqVTSfI1xezr17v7sS64V10X95nKJQxN7nyI/1VozjgZUVnkpl/Z3
        aUrH+7XXkHlnF
X-Received: by 2002:a05:600c:2d93:b0:393:fbf7:5a58 with SMTP id i19-20020a05600c2d9300b00393fbf75a58mr634754wmg.101.1650973485289;
        Tue, 26 Apr 2022 04:44:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb7okn8/fEZmEufRhvsiAQWIxugxvRL7RUwXysB9UTYFMGYvZsKTIeUlhVkcgCO2fK8gn5cA==
X-Received: by 2002:a05:600c:2d93:b0:393:fbf7:5a58 with SMTP id i19-20020a05600c2d9300b00393fbf75a58mr634725wmg.101.1650973485017;
        Tue, 26 Apr 2022 04:44:45 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm12920958wmq.35.2022.04.26.04.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 04:44:44 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
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
        "peterx@redhat.com" <peterx@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
Date:   Tue, 26 Apr 2022 13:44:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4f920d463ebf414caa96419b625632d5@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 4/26/22 11:47 AM, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Yi Liu [mailto:yi.l.liu@intel.com]
>> Sent: 14 April 2022 11:47
>> To: alex.williamson@redhat.com; cohuck@redhat.com;
>> qemu-devel@nongnu.org
>> Cc: david@gibson.dropbear.id.au; thuth@redhat.com; farman@linux.ibm.com;
>> mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
>> jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
>> jgg@nvidia.com; nicolinc@nvidia.com; eric.auger@redhat.com;
>> eric.auger.pro@gmail.com; kevin.tian@intel.com; yi.l.liu@intel.com;
>> chao.p.peng@intel.com; yi.y.sun@intel.com; peterx@redhat.com
>> Subject: [RFC 00/18] vfio: Adopt iommufd
>>
>> With the introduction of iommufd[1], the linux kernel provides a generic
>> interface for userspace drivers to propagate their DMA mappings to kernel
>> for assigned devices. This series does the porting of the VFIO devices
>> onto the /dev/iommu uapi and let it coexist with the legacy implementation.
>> Other devices like vpda, vfio mdev and etc. are not considered yet.
>>
>> For vfio devices, the new interface is tied with device fd and iommufd
>> as the iommufd solution is device-centric. This is different from legacy
>> vfio which is group-centric. To support both interfaces in QEMU, this
>> series introduces the iommu backend concept in the form of different
>> container classes. The existing vfio container is named legacy container
>> (equivalent with legacy iommu backend in this series), while the new
>> iommufd based container is named as iommufd container (may also be
>> mentioned
>> as iommufd backend in this series). The two backend types have their own
>> way to setup secure context and dma management interface. Below diagram
>> shows how it looks like with both BEs.
>>
>>                     VFIO
>> AddressSpace/Memory
>>     +-------+  +----------+  +-----+  +-----+
>>     |  pci  |  | platform |  |  ap |  | ccw |
>>     +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
>>         |           |           |        |        |   AddressSpace
>> |
>>         |           |           |        |        +------------+---------+
>>     +---V-----------V-----------V--------V----+               /
>>     |           VFIOAddressSpace              | <------------+
>>     |                  |                      |  MemoryListener
>>     |          VFIOContainer list             |
>>     +-------+----------------------------+----+
>>             |                            |
>>             |                            |
>>     +-------V------+            +--------V----------+
>>     |   iommufd    |            |    vfio legacy    |
>>     |  container   |            |     container     |
>>     +-------+------+            +--------+----------+
>>             |                            |
>>             | /dev/iommu                 | /dev/vfio/vfio
>>             | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
>>  Userspace  |                            |
>>
>> ===========+============================+==========================
>> ======
>>  Kernel     |  device fd                 |
>>             +---------------+            | group/container fd
>>             | (BIND_IOMMUFD |            |
>> (SET_CONTAINER/SET_IOMMU)
>>             |  ATTACH_IOAS) |            | device fd
>>             |               |            |
>>             |       +-------V------------V-----------------+
>>     iommufd |       |                vfio                  |
>> (map/unmap  |       +---------+--------------------+-------+
>>  ioas_copy) |                 |                    | map/unmap
>>             |                 |                    |
>>      +------V------+    +-----V------+      +------V--------+
>>      | iommfd core |    |  device    |      |  vfio iommu   |
>>      +-------------+    +------------+      +---------------+
>>
>> [Secure Context setup]
>> - iommufd BE: uses device fd and iommufd to setup secure context
>>               (bind_iommufd, attach_ioas)
>> - vfio legacy BE: uses group fd and container fd to setup secure context
>>                   (set_container, set_iommu)
>> [Device access]
>> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
>> - vfio legacy BE: device fd is retrieved from group fd ioctl
>> [DMA Mapping flow]
>> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
>> - VFIO populates DMA map/unmap via the container BEs
>>   *) iommufd BE: uses iommufd
>>   *) vfio legacy BE: uses container fd
>>
>> This series qomifies the VFIOContainer object which acts as a base class
>> for a container. This base class is derived into the legacy VFIO container
>> and the new iommufd based container. The base class implements generic
>> code
>> such as code related to memory_listener and address space management
>> whereas
>> the derived class implements callbacks that depend on the kernel user space
>> being used.
>>
>> The selection of the backend is made on a device basis using the new
>> iommufd option (on/off/auto). By default the iommufd backend is selected
>> if supported by the host and by QEMU (iommufd KConfig). This option is
>> currently available only for the vfio-pci device. For other types of
>> devices, it does not yet exist and the legacy BE is chosen by default.
>>
>> Test done:
>> - PCI and Platform device were tested
>> - ccw and ap were only compile-tested
>> - limited device hotplug test
>> - vIOMMU test run for both legacy and iommufd backends (limited tests)
>>
>> This series was co-developed by Eric Auger and me based on the exploration
>> iommufd kernel[2], complete code of this series is available in[3]. As
>> iommufd kernel is in the early step (only iommufd generic interface is in
>> mailing list), so this series hasn't made the iommufd backend fully on par
>> with legacy backend w.r.t. features like p2p mappings, coherency tracking,
>> live migration, etc. This series hasn't supported PCI devices without FLR
>> neither as the kernel doesn't support VFIO_DEVICE_PCI_HOT_RESET when
>> userspace
>> is using iommufd. The kernel needs to be updated to accept device fd list for
>> reset when userspace is using iommufd. Related work is in progress by
>> Jason[4].
>>
>> TODOs:
>> - Add DMA alias check for iommufd BE (group level)
>> - Make pci.c to be BE agnostic. Needs kernel change as well to fix the
>>   VFIO_DEVICE_PCI_HOT_RESET gap
>> - Cleanup the VFIODevice fields as it's used in both BEs
>> - Add locks
>> - Replace list with g_tree
>> - More tests
>>
>> Patch Overview:
>>
>> - Preparation:
>>   0001-scripts-update-linux-headers-Add-iommufd.h.patch
>>   0002-linux-headers-Import-latest-vfio.h-and-iommufd.h.patch
>>   0003-hw-vfio-pci-fix-vfio_pci_hot_reset_result-trace-poin.patch
>>   0004-vfio-pci-Use-vbasedev-local-variable-in-vfio_realize.patch
>>
>> 0005-vfio-common-Rename-VFIOGuestIOMMU-iommu-into-iommu_m.patch
>>   0006-vfio-common-Split-common.c-into-common.c-container.c.patch
>>
>> - Introduce container object and covert existing vfio to use it:
>>   0007-vfio-Add-base-object-for-VFIOContainer.patch
>>   0008-vfio-container-Introduce-vfio_attach-detach_device.patch
>>   0009-vfio-platform-Use-vfio_-attach-detach-_device.patch
>>   0010-vfio-ap-Use-vfio_-attach-detach-_device.patch
>>   0011-vfio-ccw-Use-vfio_-attach-detach-_device.patch
>>   0012-vfio-container-obj-Introduce-attach-detach-_device-c.patch
>>   0013-vfio-container-obj-Introduce-VFIOContainer-reset-cal.patch
>>
>> - Introduce iommufd based container:
>>   0014-hw-iommufd-Creation.patch
>>   0015-vfio-iommufd-Implement-iommufd-backend.patch
>>   0016-vfio-iommufd-Add-IOAS_COPY_DMA-support.patch
>>
>> - Add backend selection for vfio-pci:
>>   0017-vfio-as-Allow-the-selection-of-a-given-iommu-backend.patch
>>   0018-vfio-pci-Add-an-iommufd-option.patch
>>
>> [1]
>> https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com
>> /
>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
> Hi,
>
> I had a go with the above branches on our ARM64 platform trying to pass-through
> a VF dev, but Qemu reports an error as below,
>
> [    0.444728] hisi_sec2 0000:00:01.0: enabling device (0000 -> 0002)
> qemu-system-aarch64-iommufd: IOMMU_IOAS_MAP failed: Bad address
> qemu-system-aarch64-iommufd: vfio_container_dma_map(0xaaaafeb40ce0, 0x8000000000, 0x10000, 0xffffb40ef000) = -14 (Bad address)
>
> I think this happens for the dev BAR addr range. I haven't debugged the kernel
> yet to see where it actually reports that. 
Does it prevent your assigned device from working? I have such errors
too but this is a known issue. This is due to the fact P2P DMA is not
supported yet.

Thanks

Eric

>
> Maybe I am missing something. Please let me know.
>
> Thanks,
> Shameer
>

