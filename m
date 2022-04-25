Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4267250EA8B
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 22:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245537AbiDYUaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245540AbiDYUaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 16:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DB5B1444EC
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 13:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650918192;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReceZit4jM7lU67Zk++Iig/sz0gzGrt/dvrPPSUwbfo=;
        b=cj7TqJNHlaQjBSJHhqUwNiCauELg1kcg9XcXlt70QP8+o2rP48d7k5pOhK4FKXTBlhVLFM
        xGvMWYIyRRr3DBmu0SYVqULIzNNFqD6H8OA6yrysSnlEiz7TFx6rPGpEslYw5OJ/2oEdbh
        1/jwHimWD/0mjwFqMQNPVzVDcC0Wovs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-XdQ7quCjNVytS5Wuc3oCYA-1; Mon, 25 Apr 2022 16:23:10 -0400
X-MC-Unique: XdQ7quCjNVytS5Wuc3oCYA-1
Received: by mail-wr1-f71.google.com with SMTP id e21-20020adfa455000000b0020ae075cf35so690190wra.11
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 13:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=ReceZit4jM7lU67Zk++Iig/sz0gzGrt/dvrPPSUwbfo=;
        b=roB3inElL+njrj7cNgQvY1qtpwP7SRw/ZMXVnWH5Xq/JL7Y8cRQkjHlRpngBpcbD2/
         7JSG+ZyKyrgHd0PKJVIJe+6KdS7EBZ5LcZrp3QVZv9sLi9UftuwJO3y0N/7zKbvv/sla
         IkVpZLXX3MK6ITyoA96E41WhWivJC/VNctv1BKm/wPam9yoOZmkSyuOF3AcFAtfEUd3s
         UCNNMrNTZw70J8aDVRXF5pPWnTS/AlRpDZ94RUwS2ULND7wLS7wPHabGA7dK09EeZsWN
         +VrprtdvNB5qWEBRDSDRVPnzJ8xSNZlaWoCAysf0W/7N0+8kNTwFTAnzUfXgLRtUXrob
         rfyA==
X-Gm-Message-State: AOAM533xZMvs+TMWNG0nFWCB942NMSaUb4hAvWECObMXc0wMeHvkE4JC
        M64rPSVmVPlGu9v9BB71d/cETs1BDj8ozupCN17zXDrLdd3miUNVDhbiBScGwsk8/AB78ooqd0a
        Bp4mvtd07qGvC
X-Received: by 2002:a05:6000:1888:b0:20a:9644:ab9d with SMTP id a8-20020a056000188800b0020a9644ab9dmr15214720wri.197.1650918189616;
        Mon, 25 Apr 2022 13:23:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+oUGJbhE5dxQ/jaLvwrka1WaE2Z7/8fYK+rizX4C5pG42StYXZu0GpJHU48lo7wfyol3YzQ==
X-Received: by 2002:a05:6000:1888:b0:20a:9644:ab9d with SMTP id a8-20020a056000188800b0020a9644ab9dmr15214694wri.197.1650918189342;
        Mon, 25 Apr 2022 13:23:09 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u16-20020a05600c441000b0038ebcbadcedsm14303931wmn.2.2022.04.25.13.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 13:23:08 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>
Cc:     cohuck@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <fbe4728a-da58-e7de-aa36-97af48cbca0a@redhat.com>
Date:   Mon, 25 Apr 2022 22:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220422160943.6ff4f330.alex.williamson@redhat.com>
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

Hi Alex,

On 4/23/22 12:09 AM, Alex Williamson wrote:
> [Cc +libvirt folks]
>
> On Thu, 14 Apr 2022 03:46:52 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>
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
>> iommufd based container is named as iommufd container (may also be mentioned
>> as iommufd backend in this series). The two backend types have their own
>> way to setup secure context and dma management interface. Below diagram
>> shows how it looks like with both BEs.
>>
>>                     VFIO                           AddressSpace/Memory
>>     +-------+  +----------+  +-----+  +-----+
>>     |  pci  |  | platform |  |  ap |  | ccw |
>>     +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
>>         |           |           |        |        |   AddressSpace       |
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
>>  ===========+============================+================================
>>  Kernel     |  device fd                 |
>>             +---------------+            | group/container fd
>>             | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
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
>> and the new iommufd based container. The base class implements generic code
>> such as code related to memory_listener and address space management whereas
>> the derived class implements callbacks that depend on the kernel user space
>> being used.
>>
>> The selection of the backend is made on a device basis using the new
>> iommufd option (on/off/auto). By default the iommufd backend is selected
>> if supported by the host and by QEMU (iommufd KConfig). This option is
>> currently available only for the vfio-pci device. For other types of
>> devices, it does not yet exist and the legacy BE is chosen by default.
> I've discussed this a bit with Eric, but let me propose a different
> command line interface.  Libvirt generally likes to pass file
> descriptors to QEMU rather than grant it access to those files
> directly.  This was problematic with vfio-pci because libvirt can't
> easily know when QEMU will want to grab another /dev/vfio/vfio
> container.  Therefore we abandoned this approach and instead libvirt
> grants file permissions.
>
> However, with iommufd there's no reason that QEMU ever needs more than
> a single instance of /dev/iommufd and we're using per device vfio file
> descriptors, so it seems like a good time to revisit this.
>
> The interface I was considering would be to add an iommufd object to
> QEMU, so we might have a:
>
> -device iommufd[,fd=#][,id=foo]
>
> For non-libivrt usage this would have the ability to open /dev/iommufd
> itself if an fd is not provided.  This object could be shared with
> other iommufd users in the VM and maybe we'd allow multiple instances
> for more esoteric use cases.  [NB, maybe this should be a -object rather than
> -device since the iommufd is not a guest visible device?]
>
> The vfio-pci device might then become:
>
> -device vfio-pci[,host=DDDD:BB:DD.f][,sysfsdev=/sys/path/to/device][,fd=#][,iommufd=foo]
>
> So essentially we can specify the device via host, sysfsdev, or passing
> an fd to the vfio device file.  When an iommufd object is specified,
> "foo" in the example above, each of those options would use the
> vfio-device access mechanism, essentially the same as iommufd=on in
> your example.  With the fd passing option, an iommufd object would be
> required and necessarily use device level access.
What is the use case you foresee for the "fd=#" option?
>
> In your example, the iommufd=auto seems especially troublesome for
> libvirt because QEMU is going to have different locked memory
> requirements based on whether we're using type1 or iommufd, where the
> latter resolves the duplicate accounting issues.  libvirt needs to know
> deterministically which backed is being used, which this proposal seems
> to provide, while at the same time bringing us more in line with fd
> passing.  Thoughts?  Thanks,
I like your proposal (based on the -object iommufd). The only thing that
may be missing I think is for a qemu end-user who actually does not care
about the iommu backend being used but just wishes to use the most
recent available one it adds some extra complexity. But this is not the
most important use case ;)

Thanks

Eric
>
> Alex
>

