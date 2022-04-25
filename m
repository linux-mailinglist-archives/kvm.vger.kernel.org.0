Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEBF50EC49
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiDYW4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiDYW4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 18:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BB8D107822
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650927218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KYvTG6fHslGLTAEOj7E7ypkGRqTXSPQpyoWIpPfwOQ=;
        b=AGMmA53HNEtYR8FUD+CD7BV76bh66ocpchKTuSde0xX2htMCotItAykYjPyd8fk0jVrV84
        mYLvXRwHakg9qetxRloCqHdMTAa6/EMHnVyuHSvifL4aaTtfKrzgQdlaE6T81KROzTAKLh
        ih87+B9CkVICzS4+eqIQ244CMT1Dle4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-hIoT_lfWNnWZm9IEc8dyYw-1; Mon, 25 Apr 2022 18:53:37 -0400
X-MC-Unique: hIoT_lfWNnWZm9IEc8dyYw-1
Received: by mail-io1-f70.google.com with SMTP id q5-20020a0566022f0500b00654a56b1dfbso12478677iow.8
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 15:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8KYvTG6fHslGLTAEOj7E7ypkGRqTXSPQpyoWIpPfwOQ=;
        b=uRVuPqeYmLw8GoBwquSn9t+nCndxpREwdoCyppJKfjEyKQfglJO/+9nSfp2RCquCdq
         /yk+cR9Z1K732uXF5OIrIOrNmakgcMt2ZFTlT7qpWpjux2zHiYwcyNf3E033dMZmOLI4
         BV493aalyeRgwkYTLQnJP7cjsZ5UPdzv7L3I1HkIGRSjIMQHVXmm7JcLx5CLx706+8RI
         y2N9rKgLHo4yYIggDNmzsEnuJNndYf1sZAiCNU3giuxaAkXjpUGRmdZPUlHX7aAgpKIR
         CjLLzBymAkSBMmazwYsF3PkRYTx8LU67H/S1gt3MxpZ2A6yDmHOCSdasPo5dwb/kNdon
         iJZw==
X-Gm-Message-State: AOAM531DfcTVGk3BK8MVijuwg7oEiQT2VqSh3f9KuJIRNJF+EThgbin9
        SfWwQBytShr+mjnY1UqOK3/HIuoNGDLAGD3vMdvZpxdGJcEAnxMiJWMswtPcPnx55rLfXMGqeu9
        JV34XvoqG/rRM
X-Received: by 2002:a05:6e02:1608:b0:2cc:1bf8:bf2f with SMTP id t8-20020a056e02160800b002cc1bf8bf2fmr8105867ilu.219.1650927216163;
        Mon, 25 Apr 2022 15:53:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGcyC03xq2TvlmJYcMx22EPxDF94K5SeUE/sXwrixAbxujdIriJqkWIKd0w2OhVivFjXAlNg==
X-Received: by 2002:a05:6e02:1608:b0:2cc:1bf8:bf2f with SMTP id t8-20020a056e02160800b002cc1bf8bf2fmr8105855ilu.219.1650927215849;
        Mon, 25 Apr 2022 15:53:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s7-20020a5eaa07000000b00654bf640320sm8127085ioe.55.2022.04.25.15.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 15:53:34 -0700 (PDT)
Date:   Mon, 25 Apr 2022 16:53:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, cohuck@redhat.com,
        qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        thuth@redhat.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220425165333.034bb2c8.alex.williamson@redhat.com>
In-Reply-To: <fbe4728a-da58-e7de-aa36-97af48cbca0a@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <fbe4728a-da58-e7de-aa36-97af48cbca0a@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 22:23:05 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 4/23/22 12:09 AM, Alex Williamson wrote:
> > [Cc +libvirt folks]
> >
> > On Thu, 14 Apr 2022 03:46:52 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >  
> >> With the introduction of iommufd[1], the linux kernel provides a generic
> >> interface for userspace drivers to propagate their DMA mappings to kernel
> >> for assigned devices. This series does the porting of the VFIO devices
> >> onto the /dev/iommu uapi and let it coexist with the legacy implementation.
> >> Other devices like vpda, vfio mdev and etc. are not considered yet.
> >>
> >> For vfio devices, the new interface is tied with device fd and iommufd
> >> as the iommufd solution is device-centric. This is different from legacy
> >> vfio which is group-centric. To support both interfaces in QEMU, this
> >> series introduces the iommu backend concept in the form of different
> >> container classes. The existing vfio container is named legacy container
> >> (equivalent with legacy iommu backend in this series), while the new
> >> iommufd based container is named as iommufd container (may also be mentioned
> >> as iommufd backend in this series). The two backend types have their own
> >> way to setup secure context and dma management interface. Below diagram
> >> shows how it looks like with both BEs.
> >>
> >>                     VFIO                           AddressSpace/Memory
> >>     +-------+  +----------+  +-----+  +-----+
> >>     |  pci  |  | platform |  |  ap |  | ccw |
> >>     +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
> >>         |           |           |        |        |   AddressSpace       |
> >>         |           |           |        |        +------------+---------+
> >>     +---V-----------V-----------V--------V----+               /
> >>     |           VFIOAddressSpace              | <------------+
> >>     |                  |                      |  MemoryListener
> >>     |          VFIOContainer list             |
> >>     +-------+----------------------------+----+
> >>             |                            |
> >>             |                            |
> >>     +-------V------+            +--------V----------+
> >>     |   iommufd    |            |    vfio legacy    |
> >>     |  container   |            |     container     |
> >>     +-------+------+            +--------+----------+
> >>             |                            |
> >>             | /dev/iommu                 | /dev/vfio/vfio
> >>             | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
> >>  Userspace  |                            |
> >>  ===========+============================+================================
> >>  Kernel     |  device fd                 |
> >>             +---------------+            | group/container fd
> >>             | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
> >>             |  ATTACH_IOAS) |            | device fd
> >>             |               |            |
> >>             |       +-------V------------V-----------------+
> >>     iommufd |       |                vfio                  |
> >> (map/unmap  |       +---------+--------------------+-------+
> >>  ioas_copy) |                 |                    | map/unmap
> >>             |                 |                    |
> >>      +------V------+    +-----V------+      +------V--------+
> >>      | iommfd core |    |  device    |      |  vfio iommu   |
> >>      +-------------+    +------------+      +---------------+
> >>
> >> [Secure Context setup]
> >> - iommufd BE: uses device fd and iommufd to setup secure context
> >>               (bind_iommufd, attach_ioas)
> >> - vfio legacy BE: uses group fd and container fd to setup secure context
> >>                   (set_container, set_iommu)
> >> [Device access]
> >> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
> >> - vfio legacy BE: device fd is retrieved from group fd ioctl
> >> [DMA Mapping flow]
> >> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
> >> - VFIO populates DMA map/unmap via the container BEs
> >>   *) iommufd BE: uses iommufd
> >>   *) vfio legacy BE: uses container fd
> >>
> >> This series qomifies the VFIOContainer object which acts as a base class
> >> for a container. This base class is derived into the legacy VFIO container
> >> and the new iommufd based container. The base class implements generic code
> >> such as code related to memory_listener and address space management whereas
> >> the derived class implements callbacks that depend on the kernel user space
> >> being used.
> >>
> >> The selection of the backend is made on a device basis using the new
> >> iommufd option (on/off/auto). By default the iommufd backend is selected
> >> if supported by the host and by QEMU (iommufd KConfig). This option is
> >> currently available only for the vfio-pci device. For other types of
> >> devices, it does not yet exist and the legacy BE is chosen by default.  
> > I've discussed this a bit with Eric, but let me propose a different
> > command line interface.  Libvirt generally likes to pass file
> > descriptors to QEMU rather than grant it access to those files
> > directly.  This was problematic with vfio-pci because libvirt can't
> > easily know when QEMU will want to grab another /dev/vfio/vfio
> > container.  Therefore we abandoned this approach and instead libvirt
> > grants file permissions.
> >
> > However, with iommufd there's no reason that QEMU ever needs more than
> > a single instance of /dev/iommufd and we're using per device vfio file
> > descriptors, so it seems like a good time to revisit this.
> >
> > The interface I was considering would be to add an iommufd object to
> > QEMU, so we might have a:
> >
> > -device iommufd[,fd=#][,id=foo]
> >
> > For non-libivrt usage this would have the ability to open /dev/iommufd
> > itself if an fd is not provided.  This object could be shared with
> > other iommufd users in the VM and maybe we'd allow multiple instances
> > for more esoteric use cases.  [NB, maybe this should be a -object rather than
> > -device since the iommufd is not a guest visible device?]
> >
> > The vfio-pci device might then become:
> >
> > -device vfio-pci[,host=DDDD:BB:DD.f][,sysfsdev=/sys/path/to/device][,fd=#][,iommufd=foo]
> >
> > So essentially we can specify the device via host, sysfsdev, or passing
> > an fd to the vfio device file.  When an iommufd object is specified,
> > "foo" in the example above, each of those options would use the
> > vfio-device access mechanism, essentially the same as iommufd=on in
> > your example.  With the fd passing option, an iommufd object would be
> > required and necessarily use device level access.  
> What is the use case you foresee for the "fd=#" option?

On the vfio-pci device this was intended to be the actual vfio device
file descriptor.  Once we have a file per device, QEMU doesn't really
have any need to navigate through sysfs to determine which fd to use
other than for user convenience on the command line.  For libvirt usage,
I assume QEMU could accept the device fd, without ever really knowing
anything about the host address or sysfs path of the device.

> >
> > In your example, the iommufd=auto seems especially troublesome for
> > libvirt because QEMU is going to have different locked memory
> > requirements based on whether we're using type1 or iommufd, where the
> > latter resolves the duplicate accounting issues.  libvirt needs to know
> > deterministically which backed is being used, which this proposal seems
> > to provide, while at the same time bringing us more in line with fd
> > passing.  Thoughts?  Thanks,  
> I like your proposal (based on the -object iommufd). The only thing that
> may be missing I think is for a qemu end-user who actually does not care
> about the iommu backend being used but just wishes to use the most
> recent available one it adds some extra complexity. But this is not the
> most important use case ;)

Yeah, I can sympathize with that, but isn't that also why we're pursing
a vfio compatibility interface at the kernel level?  Eventually, once
the native vfio IOMMU backends go away, the vfio "container" device
file will be provided by iommufd and that transition to the new
interface can be both seamless to the user and apparent to tools like
libvirt.

An end-user with a fixed command line should continue to work and will
eventually get iommufd via compatibility, but taking care of an
end-user that "does not care" and "wishes to use the most recent" is a
non-goal for me.  That would be more troublesome for tools and use cases
that we do care about imo.  Thanks,

Alex

