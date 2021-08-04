Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD43E050D
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhHDP7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:59:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232793AbhHDP7i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628092764;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYN3eTdnLX+rRcmcin2gJoLGkQL/Eh09P+sRl6kbPog=;
        b=Fo3pP7TNRqy2TsfOp8REZxcrcGX9APB6AtuAsj9epT5GAaboAsn3NeJGXd5bb3BUiIL/O8
        b4lp9iBKPQpo6rs7yTy3+DlHfp2gigm+8bSdeitqQ+g7SYwJFK0BOWHy8ZVSxM5Ao1hJoT
        JVJ+ckeA2iYdE8UynkZhwlR2hChYICQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-QkeTCZD-PAmlupDvjbUaEQ-1; Wed, 04 Aug 2021 11:59:23 -0400
X-MC-Unique: QkeTCZD-PAmlupDvjbUaEQ-1
Received: by mail-wr1-f70.google.com with SMTP id p2-20020a5d48c20000b0290150e4a5e7e0so971603wrs.13
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 08:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=rYN3eTdnLX+rRcmcin2gJoLGkQL/Eh09P+sRl6kbPog=;
        b=OCGyFgBA3BilczQvojB7KfMnhEV9Fu1lhQZSYA69PKIyt7g1PqBER4Bi0n8FnC7+Ag
         Q5w/JfH6VNycFgJIEL7DLnCiE5NuPeO9DhNhkjO4Z7BhdeKHmdi/j/hL34hq6B5jE0+w
         JFTBQpfTqcg/3uDzrLd7+8KZwh1K8zsjr6PJDW6uY/ULjJHUh7YSlJdJG7ItMYNvwRgM
         k9iJLPZpahWLFRPcEkAhlkeR+vSuyaaKCqRTj04pUkrY5CdBH7vMh2g78r75/5dpCiWt
         nEBU3TqH6qY9EGI0DfD1bUZsmYufiFW+aSh/po3SM0KYG8whw8p8+8Rtwv1ErE31HP+W
         K1yg==
X-Gm-Message-State: AOAM531hqdIhnDNFeMyKNkbknnZ7CnYQlk9wSyb3WdrKGBctkMkOKD6x
        4eThIo15xDGxRup0/FtPyL159cH6hNyuhcXlP5cOvn9xq50+Pd1/i6giw3P53T9c+7bLWWSvknv
        4hhXb8gkBs8Ma
X-Received: by 2002:adf:f046:: with SMTP id t6mr81350wro.266.1628092762248;
        Wed, 04 Aug 2021 08:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjoZybgmIWhD8m7dKmjy1eZombYaFTAyBLNeAAOJnBt6YGIkegb/E8jAAQxGR/W2vFx8kRDQ==
X-Received: by 2002:adf:f046:: with SMTP id t6mr81228wro.266.1628092760710;
        Wed, 04 Aug 2021 08:59:20 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 104sm2976750wrc.4.2021.08.04.08.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 08:59:20 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b83a25de-7c32-42c4-d99d-f7242cc9e2da@redhat.com>
Date:   Wed, 4 Aug 2021 17:59:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

Few comments/questions below.

On 7/9/21 9:48 AM, Tian, Kevin wrote:
> /dev/iommu provides an unified interface for managing I/O page tables for 
> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA, 
> etc.) are expected to use this interface instead of creating their own logic to 
> isolate untrusted device DMAs initiated by userspace. 
>
> This proposal describes the uAPI of /dev/iommu and also sample sequences 
> with VFIO as example in typical usages. The driver-facing kernel API provided 
> by the iommu layer is still TBD, which can be discussed after consensus is 
> made on this uAPI.
>
> It's based on a lengthy discussion starting from here:
> 	https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/ 
>
> v1 can be found here:
> 	https://lore.kernel.org/linux-iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com/T/
>
> This doc is also tracked on github, though it's not very useful for v1->v2 
> given dramatic refactoring:
> 	https://github.com/luxis1999/dev_iommu_uapi 
>
> Changelog (v1->v2):
> - Rename /dev/ioasid to /dev/iommu (Jason);
> - Add a section for device-centric vs. group-centric design (many);
> - Add a section for handling no-snoop DMA (Jason/Alex/Paolo);
> - Add definition of user/kernel/shared I/O page tables (Baolu/Jason);
> - Allow one device bound to multiple iommu fd's (Jason);
> - No need to track user I/O page tables in kernel on ARM/AMD (Jean/Jason);
> - Add a device cookie for iotlb invalidation and fault handling (Jean/Jason);
> - Add capability/format query interface per device cookie (Jason);
> - Specify format/attribute when creating an IOASID, leading to several v1
>   uAPI commands removed (Jason);
> - Explain the value of software nesting (Jean);
> - Replace IOASID_REGISTER_VIRTUAL_MEMORY with software nesting (David/Jason);
> - Cover software mdev usage (Jason);
> - No restriction on map/unmap vs. bind/invalidate (Jason/David);
> - Report permitted IOVA range instead of reserved range (David);
> - Refine the sample structures and helper functions (Jason);
> - Add definition of default and non-default I/O address spaces;
> - Expand and clarify the design for PASID virtualization;
> - and lots of subtle refinement according to above changes;
>
> TOC
> ====
> 1. Terminologies and Concepts
>     1.1. Manage I/O address space
>     1.2. Attach device to I/O address space
>     1.3. Group isolation
>     1.4. PASID virtualization
>         1.4.1. Devices which don't support DMWr
>         1.4.2. Devices which support DMWr
>         1.4.3. Mix different types together
>         1.4.4. User sequence
>     1.5. No-snoop DMA
> 2. uAPI Proposal
>     2.1. /dev/iommu uAPI
>     2.2. /dev/vfio device uAPI
>     2.3. /dev/kvm uAPI
> 3. Sample Structures and Helper Functions
> 4. Use Cases and Flows
>     4.1. A simple example
>     4.2. Multiple IOASIDs (no nesting)
>     4.3. IOASID nesting (software)
>     4.4. IOASID nesting (hardware)
>     4.5. Guest SVA (vSVA)
>     4.6. I/O page fault
> ====
>
> 1. Terminologies and Concepts
> -----------------------------------------
>
> IOMMU fd is the container holding multiple I/O address spaces. User 
> manages those address spaces through fd operations. Multiple fd's are 
> allowed per process, but with this proposal one fd should be sufficient for 
> all intended usages.
>
> IOASID is the fd-local software handle representing an I/O address space. 
> Each IOASID is associated with a single I/O page table. IOASIDs can be 
> nested together, implying the output address from one I/O page table 
> (represented by child IOASID) must be further translated by another I/O 
> page table (represented by parent IOASID).
>
> An I/O address space takes effect only after it is attached by a device. 
> One device is allowed to attach to multiple I/O address spaces. One I/O 
> address space can be attached by multiple devices.
>
> Device must be bound to an IOMMU fd before attach operation can be
> conducted. Though not necessary, user could bind one device to multiple
> IOMMU FD's. But no cross-FD IOASID nesting is allowed.
>
> The format of an I/O page table must be compatible to the attached 
> devices (or more specifically to the IOMMU which serves the DMA from
> the attached devices). User is responsible for specifying the format
> when allocating an IOASID, according to one or multiple devices which
> will be attached right after. Attaching a device to an IOASID with 
> incompatible format is simply rejected.
>
> Relationship between IOMMU fd, VFIO fd and KVM fd:
>
> -   IOMMU fd provides uAPI for managing IOASIDs and I/O page tables. 
>     It also provides an unified capability/format reporting interface for
>     each bound device. 
>
> -   VFIO fd provides uAPI for device binding and attaching. In this proposal 
>     VFIO is used as the example of device passthrough frameworks. The
>     routing information that identifies an I/O address space in the wire is 
>     per-device and registered to IOMMU fd via VFIO uAPI.
>
> -   KVM fd provides uAPI for handling no-snoop DMA and PASID virtualization
>     in CPU (when PASID is carried in instruction payload).
>
> 1.1. Manage I/O address space
> +++++++++++++++++++++++++++++
>
> An I/O address space can be created in three ways, according to how
> the corresponding I/O page table is managed:
>
> -   kernel-managed I/O page table which is created via IOMMU fd, e.g. 
>     for IOVA space (dpdk), GPA space (Qemu), GIOVA space (vIOMMU), etc.
>
> -   user-managed I/O page table which is created by the user, e.g. for 
>     GIOVA/GVA space (vIOMMU), etc.
>
> -   shared kernel-managed CPU page table which is created by another 
>     subsystem, e.g. for process VA space (mm), GPA space (kvm), etc.
>
> The first category is managed via a dma mapping protocol (similar to 
> existing VFIO iommu type1), which allows the user to explicitly specify 
> which range in the I/O address space should be mapped.
>
> The second category is managed via an iotlb protocol (similar to the
> underlying IOMMU semantics). Once the user-managed page table is
> bound to the IOMMU, the user can invoke an invalidation command
> to update the kernel-side cache (either in software or in physical IOMMU).
> In the meantime, a fault reporting/completion mechanism is also provided 
> for the user to fixup potential I/O page faults.
>
> The last category is supposed to be managed via the subsystem which
> actually owns the shared address space. Likely what's minimally required 
> in /dev/iommu uAPI is to build the connection with the address space 
> owner when allocating the IOASID, so an in-kernel interface (e.g. mmu_
> notifer) is activated for any required synchronization between IOMMU fd 
> and the space owner.
>
> This proposal focuses on how to manage the first two categories, as 
> they are existing and more urgent requirements. Support of the last
> category can be discussed when a real usage comes in the future. 
>
> The user needs to specify the desired management protocol and page 
> table format when creating a new I/O address space. Before allocating 
> the IOASID, the user should already know at least one device that will be 
> attached to this space. It is expected to first query (via IOMMU fd) the
> supported capabilities and page table format information of the to-be-
> attached device (or a common set between multiple devices) and then 
> choose a compatible format to set on the IOASID.
>
> I/O address spaces can be nested together, called IOASID nesting. IOASID
> nesting can be implemented in two ways: hardware nesting and software 
> nesting. With hardware support the child and parent I/O page tables are 
> walked consecutively by the IOMMU to form a nested translation. When 
> it's implemented in software, /dev/iommu is responsible for merging the 
> two-level mappings into a single-level shadow I/O page table. 
>
> An user-managed I/O page table can be setup only on the child IOASID, 
> implying IOASID nesting must be enabled. This is because the kernel 
> doesn't trust userspace. Nesting allows the kernel to enforce its DMA 
> isolation policy through the parent IOASID. 
>
> Software nesting is useful in several scenarios. First, it allows 
> centralized accounting on locked pages between multiple root IOASIDs
> (no parent). In this case a 'dummy' IOASID can be created with an 
> identity mapping (HVA->HVA), dedicated for page pinning/accounting and 
> nested by all root IOASIDs. Second, it's also useful for mdev drivers 
> (e.g. kvmgt) to write-protect guest structures when vIOMMU is enabled. 
> In this case the protected addresses are in GIOVA space while KVM 
> write-protection API is based on GPA. Software nesting allows finding 
> GPA according to GIOVA in the kernel.
>
> 1.2. Attach Device to I/O address space
> +++++++++++++++++++++++++++++++++++++++
>
> Device attach/bind is initiated through passthrough framework uAPI.
>
> Device attaching is allowed only after a device is successfully bound to
> the IOMMU fd. User should provide a device cookie when binding the 
> device through VFIO uAPI. This cookie is used when the user queries 
> device capability/format, issues per-device iotlb invalidation and 
> receives per-device I/O page fault data via IOMMU fd.
>
> Successful binding puts the device into a security context which isolates 
> its DMA from the rest system. VFIO should not allow user to access the 
s/from the rest system/from the rest of the system
> device before binding is completed. Similarly, VFIO should prevent the 
> user from unbinding the device before user access is withdrawn.
With Intel scalable IOV, I understand you could assign an RID/PASID to
one VM and another one to another VM (which is not the case for ARM). Is
it a targetted use case?How would it be handled? Is it related to the
sub-groups evoked hereafter?

Actually all devices bound to an IOMMU fd should have the same parent
I/O address space or root address space, am I correct? If so, maybe add
this comment explicitly?
> When a device is in an iommu group which contains multiple devices,
> all devices within the group must enter/exit the security context
> together. Please check {1.3} for more info about group isolation via
> this device-centric design.
>
> Successful attaching activates an I/O address space in the IOMMU,
> if the device is not purely software mediated. VFIO must provide device
> specific routing information for where to install the I/O page table in 
> the IOMMU for this device. VFIO must also guarantee that the attached 
> device is configured to compose DMAs with the routing information that 
> is provided in the attaching call. When handling DMA requests, IOMMU 
> identifies the target I/O address space according to the routing 
> information carried in the request. Misconfiguration breaks DMA
> isolation thus could lead to severe security vulnerability.
>
> Routing information is per-device and bus specific. For PCI, it is 
> Requester ID (RID) identifying the device plus optional Process Address 
> Space ID (PASID). For ARM, it is Stream ID (SID) plus optional Sub-Stream 
> ID (SSID). PASID or SSID is used when multiple I/O address spaces are 
> enabled on a single device. For simplicity and continuity reason the 
> following context uses RID+PASID though SID+SSID may sound a clearer 
> naming from device p.o.v. We can decide the actual naming when coding.
>
> Because one I/O address space can be attached by multiple devices, 
> per-device routing information (plus device cookie) is tracked under 
> each IOASID and is used respectively when activating the I/O address 
> space in the IOMMU for each attached device.
>
> The device in the /dev/iommu context always refers to a physical one 
> (pdev) which is identifiable via RID. Physically each pdev can support 
> one default I/O address space (routed via RID) and optionally multiple 
> non-default I/O address spaces (via RID+PASID).
>
> The device in VFIO context is a logic concept, being either a physical
> device (pdev) or mediated device (mdev or subdev). Each vfio device
> is represented by RID+cookie in IOMMU fd. User is allowed to create 
> one default I/O address space (routed by vRID from user p.o.v) per 
> each vfio_device. 
The concept of default address space is not fully clear for me. I
currently understand this is a
root address space (not nesting). Is that coorect.This may need
clarification.
> VFIO decides the routing information for this default
> space based on device type:
>
> 1)  pdev, routed via RID;
>
> 2)  mdev/subdev with IOMMU-enforced DMA isolation, routed via 
>     the parent's RID plus the PASID marking this mdev;
>
> 3)  a purely sw-mediated device (sw mdev), no routing required i.e. no
>     need to install the I/O page table in the IOMMU. sw mdev just uses 
>     the metadata to assist its internal DMA isolation logic on top of 
>     the parent's IOMMU page table;
Maybe you should introduce this concept of SW mediated device earlier
because it seems to special case the way the attach behaves. I am
especially refering to

"Successful attaching activates an I/O address space in the IOMMU, if the device is not purely software mediated"

>
> In addition, VFIO may allow user to create additional I/O address spaces
> on a vfio_device based on the hardware capability. In such case the user 
> has its own view of the virtual routing information (vPASID) when marking 
> these non-default address spaces. 
I do not catch what does mean "marking these non default address space".
> How to virtualize vPASID is platform
> specific and device specific. Some platforms allow the user to fully 
> manage the PASID space thus vPASIDs are directly used for routing and
> even hidden from the kernel. Other platforms require the user to 
> explicitly register the vPASID information to the kernel when attaching 
> the vfio_device. In this case VFIO must figure out whether vPASID should 
> be directly used (pdev) or converted to a kernel-allocated pPASID (mdev) 
> for physical routing. Detail explanation about PASID virtualization can 
> be found in {1.4}.
>
> For mdev both default and non-default I/O address spaces are routed
> via PASIDs. To better differentiate them we use "default PASID" (or 
> defPASID) when talking about the default I/O address space on mdev. When 
> vPASID or pPASID is referred in PASID virtualization it's all about the 
> non-default spaces. defPASID and pPASID are always hidden from userspace 
> and can only be indirectly referenced via IOASID.
>
> 1.3. Group isolation
> ++++++++++++++++++++
>
> Group is the minimal object when talking about DMA isolation in the 
> iommu layer. Devices which cannot be isolated from each other are 
> organized into a single group. Lack of isolation could be caused by 
> multiple reasons: no ACS capability in the upstreaming port, behind a 
> PCIe-to-PCI bridge (thus sharing RID), or DMA aliasing (multiple RIDs 
> per device), etc.
>
> All devices in the group must be put in a security context together 
> before one or more devices in the group are operated by an untrusted 
> user. Passthrough frameworks must guarantee that:
>
> 1)  No user access is granted on a device before an security context is 
>     established for the entire group (becomes viable).
>
> 2)  Group viability is not broken before the user relinquishes the device. 
>     This implies that devices in the group must be either assigned to this 
>     user, or driver-less, or bound to a driver which is known safe (not 
>     do DMA). 
>
> 3)  The security context should not be destroyed before user access
>     permission is withdrawn.
>
> Existing VFIO introduces explicit container and group semantics in its
> uAPI to meet above requirements:
>
> 1)  VFIO user can open a device fd only after:
>
>     * A container is created;
>     * The group is attached to the container (VFIO_GROUP_SET_CONTAINER);
>     * An empty I/O page table is created in the container (VFIO_SET_IOMMU);
>     * Group viability is passed and the entire group is attached to 
>       the empty I/O page table (the security context);
>
> 2)  VFIO monitors driver binding status to verify group viability
>
>     * IOMMU_GROUP_NOTIFY_BOUND_DRIVER;
>     * BUG_ON() if group viability is broken;
>
> 3)  Detach the group from the container when the last device fd in the 
>     group is closed and destroy the I/O page table only after the last 
>     group is detached from the container.
>
> With this proposal VFIO can move to a simpler device-centric model by
> directly exposeing device node under "/dev/vfio/devices" w/o using 
s/exposeing/exposing
> container and group uAPI at all. In this case group isolation is enforced
> mplicitly within IOMMU fd:
s/mplicitly/implicitly
>
> 1)  A successful binding call for the first device in the group creates 
>     the security context for the entire group, by:
>
>     * Verifying group viability in a similar way as VFIO does;
>
>     * Calling IOMMU-API to move the group into a block-dma state,
>       which makes all devices in the group attached to an block-dma
>       domain with an empty I/O page table;
this block-dma state/domain would deserve to be better defined (I know
you already evoked it in 1.1 with the dma mapping protocol though)
activates an empty I/O page table in the IOMMU (if the device is not
purely SW mediated)?
How does that relate to the default address space? Is it the same?
>
>     VFIO should not allow the user to mmap the MMIO bar of the bound
>     device until the binding call succeeds.
>
>     Binding other devices in the same group just succeeds since the
>     security context has already been established for the entire group.
>
> 2)  IOMMU fd monitors driver binding status in case group viability is
>     broken, same as VFIO does today. BUG_ON() might be eliminated if we 
>     can find a way to deny probe of non-iommu-safe drivers.
>
>     Before a device is unbound from IOMMU fd, it is always attached to a
>     security context (either the block-dma domain or an IOASID domain).
>     Switch between two domains is initiated by attaching the device to or 
>     detaching it from an IOASID. The IOMMU layer should ensure that 
>     the default domain is not implicitly re-attached in the switching
>     process, before the group is moved out of the block-dma state.
>
>     To stay on par with legacy VFIO, IOMMU fd could verify that all 
>     bound devices in the same group must be attached to a single IOASID.
>
> 3)  When a device fd is closed, VFIO automatically unbinds the device from
>     IOMMU fd before zapping the mmio mapping. Unbinding the last device
>     in the group moves the entire group out of the block-dma state and
>     re-attached to the default domain.
>
> Actual implementation may use a staging approach, e.g. only support 
> one-device group in the start (leaving multi-devices group handled via
> legacy VFIO uAPI) and then cover multi-devices group in a later stage.
>
> If necessary, devices within a group may be further allowed to be 
> attached to different IOASIDs in the same IOMMU fd, in case that the 
> source devices can be reliably identifiable (e.g. due to !ACS). This will 
> require additional sub-group logic in the iommu layer and with 
> sub-group topology exposed to userspace. But no expectation of 
> changing the device-centric semantics except introducing sub-group
> awareness within IOMMU fd.
This is a bit cryptic to me. Devices using different child IOASIDs and
same parent IOASID are allowed within the same IOMMU fd, right?
Please could you clarify?
>
> A more detailed explanation of the staging approach can be found:
>
> https://lore.kernel.org/linux-iommu/BN9PR11MB543382665D34E58155A9593C8C039@BN9PR11MB5433.namprd11.prod.outlook.com/
>
> 1.4. PASID Virtualization
> +++++++++++++++++++++++++
>
> As explained in {1.2}, PASID virtualization is required when multiple I/O
> address spaces are supported on a device. The actual policy is per-device 
> thus defined by specific VFIO device driver. 
>
> A PASID virtualization policy is defined by four aspects:
>
> 1)  Whether this device allows the user to create multiple I/O address 
>     spaces (vPASID capability). This is decided upon whether this device 
>     and its upstream IOMMU both support PASID.
>
> 2)  If yes, whether the PASID space is delegated to the user, based on
>     whether the PASID table should be managed by user or kernel.
>
> 3)  If no, the user should register vPASID to the kernel. Then the next
>     question is whether vPASID should be directly used for physical routing
>     (vPASID==pPASID or vPASID!=pPASID). The key is whether this device 
>     must share the PASID space with others (pdev vs. mdev).
>
> 4)  If vPASID!=pPASID, whether pPASID should be allocated from the 
>     per-RID space or a global space. This is about whether the device 
>     supports PCIe DMWr-type work submission (e.g. Intel ENQCMD) which 
>     requires global pPASID allocation cross multiple devices.
>
> Only vPASIDs are part of the VM state to be migrated in VM live migration.
> This is basically about the virtual PASID table state in vendor vIOMMU. If
> vPASID!=pPASID, new pPASIDs will be re-allocated on the destination and
> VFIO device driver is responsible for programming the device to use the
> new pPASID when restoring the device state.
>
> Different policies may imply different uAPI semantics for user to follow 
> when attaching a device. The semantics information is expected to be 
> reported to the user via VFIO uAPI instead of via IOMMU fd, since the 
> latter only cares about pPASID. But if there is a different thought we'd 
> like to hear it.
>
> Following sections (1.4.1 - 1.4.3) provide detail explanation on how 
> above are selected on different device types and the implication when 
> multiple types are mixed together (i.e. assigned to a single user). Last 
> section (1.4.4) then summarizes what uAPI semantics information is
> reported and how user is expected to deal with it.
>
> 1.4.1. Devices which don't support DMWr
> ***************************************
>
> This section is about following types:
>
> 1)  a pdev which doesn't issue PASID;
> 2)  a sw mdev which doesn't issue PASID;
> 3)  a mdev which is programmed a fixed defPASID (for default I/O address
>     space), but does not expose vPASID capability;
>
> 4)  a pdev which exposes vPASID and has its PASID table managed by user;
> 5)  a pdev which exposes vPASID and has its PASID table managed by kernel;
> 6)  a mdev which exposes vPASID and shares the parent's PASID table
>     with other mdev's;
>
>   +--------+---------+---------+----------+-----------+
>   |        |         |Delegated| vPASID== |  per-RID  |
>   |        |  vPASID | to user | pPASID   |  pPASID   |
>   +========+=========+=========+==========+===========+
>   | type-1 |    N/A  |   N/A   |   N/A    |    N/A    |
>   +--------+---------+---------+----------+-----------+
>   | type-2 |    N/A  |   N/A   |   N/A    |    N/A    |
>   +--------+---------+---------+----------+-----------+
>   | type-3 |    N/A  |   N/A   |   N/A    |    N/A    |
>   +--------+---------+---------+----------+-----------+
>   | type-4 |    Yes  |   Yes   |   v==p(*)| per-RID(*)|
>   +--------+---------+---------+----------+-----------+
>   | type-5 |    Yes  |   No    |   v==p   |  per-RID  |
>   +--------+---------+---------+----------+-----------+
>   | type-6 |    Yes  |   No    |   v!=p   |  per-RID  |
>   +--------+---------+---------+----------+-----------+
>   <* conceptual definition though the PASID space is fully delegated>
>
> for 1-3 there is no vPASID capability exposed and the user can create 
> only one default I/O address space on this device. Thus there is no PASID 
> virtualization at all.
>
> 4) is specific to ARM/AMD platforms where the PASID table is managed by 
> the user. In this case the entire PASID space is delegated to the user
> which just needs to create a single IOASID linked to the user-managed 
> PASID table, as placeholder covering all non-default I/O address spaces 
> on pdev. In concept this looks like a big 84bit address space (20bit 
> PASID + 64bit addr). vPASID may be carried in the uAPI data to help define 
> the operation scope when invalidating IOTLB or reporting I/O page fault. 
> IOMMU fd doesn't touch it and just acts as a channel for vIOMMU/pIOMMU to 
> exchange info.
>
> 5) is specific to Intel platforms where the PASID table is managed by 
> the kernel. In this case vPASIDs should be registered to the kernel 
> in the attaching call. This implies that every non-default I/O address 
> space on pdev is explicitly tracked by an unique IOASID in the kernel. 
> Because pdev is fully controlled by the user, its DMA request carries 
> vPASID as the routing informaiton thus requires VFIO device driver to 
s/informaiton/information
> adopt vPASID==pPASID policy. Because an IOASID already represents a
> standalone address space, there is no need to further carry vPASID in 
> the invalidation and fault paths.
>
> 6) is about mdev, as those enabled by Intel Scalable IOV. The main 
> difference from type-5) is on whether vPASID==pPASID. There is 
> only a single PASID table per the parent device, implying the per-RID 
> PASID space shared by all mdevs created on this parent. VFIO device 
> driver must use vPASID!=pPASID policy and allocate a pPASID from the 
> per-RID space for every registered vPASID to guarantee DMA isolation 
> between sibling mdev's. VFIO device driver needs to conduct vPASID->
> pPASID conversion properly in several paths:
>
> -   When VFIO device driver provides the routing information in the
>     attaching call, since IOMMU fd only cares about pPASID;
> -   When VFIO device driver updates a PASID MMIO register in the 
>     parent according to the vPASID intercepted in the mediation path;
>
> 1.4.2. Devices which support DMWr
> *********************************
>
> Modern devices may support a scalable workload submission interface 
> based on PCI Deferrable Memory Write (DMWr) capability, allowing a 
> single work queue to access multiple I/O address spaces. One example 
> using DMWr is Intel ENQCMD, having PASID saved in the CPU MSR and 
> carried in the non-posted DMWr payload when sent out to the device. 
> Then a single work queue shared by multiple processes can compose 
> DMAs toward different address spaces, by carrying the PASID value 
> retrieved from the DMWr payload. The role of DMWr is allowing the 
> shared work queue to return a retry response when the work queue
> is under pressure (due to capacity or QoS). Upon such response the 
> software could try re-submitting the descriptor.
>
> When ENQCMD is executed in the guest, the value saved in the CPU 
> MSR is vPASID (part of the xsave state). This creates another point for 
> consideration regarding to PASID virtualization.
>
> Two device types are relevant:
>
> 7)   a pdev same as 5) plus DMWr support;
> 8)   a mdev same as 6) plus DMWr support;
>
> and respective polices:
>
>   +--------+---------+---------+----------+-----------+
>   |        |         |Delegated| vPASID== |  per-RID  |
>   |        |  vPASID | to user | pPASID   |  pPASID   |
>   +========+=========+=========+==========+===========+
>   | type-7 |    Yes  |   Yes   |   v==p   |  per-RID  |
>   +--------+---------+---------+----------+-----------+
>   | type-8 |    Yes  |   Yes   |   v!=p   |  global   |
>   +--------+---------+---------+----------+-----------+
>
> DMWr or shared mode is configurable per work queue. It's completely 
> sane if an assigned device with multiple queues needs to handle both 
> DMWr (shared work queue) and normal write (dedicated work queue) 
> simultaneously. Thus the PASID virtualization policy must be consistent 
> when both paths are activated.
>
> for 7) we should use the same policy as 5), i.e. directly using vPASID 
> for physical routing on pdev. In this case ENQCMD in the guest just works 
> w/o additional work because the vPASID saved in the PASID_MSR 
> matches the routing information configured for the target I/O address
> space in the IOMMU. When receiving a DMWr request, the shared 
> work queue grabs vPASID from the payload and then tags outgoing 
> DMAs with vPASID. This is consistent with the dedicated work queue
> path where vPASID is grabbed from the MMIO register to tag DMAs.
>
> for 8) vPASID in the PASID_MSR must be converted to pPASID before 
> sent to the wire (given vPASID!=pPASID for the same reason as 6). 
> Intel CPU provides a hardware PASID translation capability for auto-
> conversion when ENQCMD is being executed. In this case the payload 
> received by the work queue contains pPASID thus outgoing DMAs are 
> tagged with pPASID. This is consistent with the dedicated work 
> queue path where pPASID is programmed to the MMIO register in the 
> mediation path and then grabbed to tag DMAs.
>
> However, the CPU translation structure is per-VM which implies
> that a same pPASID must be used cross all type-8 devices (of this VM) 
> given a vPASID. This requires the pPASID allocated from a global pool by
> the first type-8 device and then shared by the following type-8 devices
> when they are attached to the same vPASID.
>
> CPU translation capability is enabled via KVM uAPI. We need a secure 
> contract between VFIO device fd and KVM fd so VFIO device driver knows 
> when it's secure to allow guest access to the cmd portal of the type-8
> device. It's dangerous by allowing the guest to issue ENQCMD to the 
> device before CPU is ready for PASID translation. In this window the 
> vPASID is untranslated thus grants the guest to access random I/O 
> address space on the parent of this mdev.
>
> We plan to utilize existing kvm-vfio contract. It is currently used for 
> multiple purposes including propagating the kvm pointer to the VFIO
> device driver. It can be extended to further notify whether CPU PASID
> translation capability is turned on. Before receiving this notification, 
> the VFIO device driver should not allow user to access the DMWr-capable 
> work queue on type-8 device.
>
> 1.4.3. Mix different types together
> ***********************************
>
> In majority case mixing different types doesn't change the aforementioned 
> PASID virtualization policy for each type. The user just needs to handle 
> them per device basis. 
>
> There is one exception though, when mixing type 7) and 8) together,
> due to conflicting policies on how PASID_MSR should be handled. 
> For mdev (type-8) the CPU translation capability must be enabled to 
> prevent a malicious guest from doing bad things. But once per-VM 
> PASID translation is enabled, the shared work queue of pdev (type-7) 
> will also receive a pPASID allocated for mdev instead of the vPASID 
> that is expected on this pdev.
>
> Fixing this exception for pdev is not easy. There are three options.
>
> One is moving pdev to also accept pPASID. Because pdev may have both 
> shared work queue (PASID in MSR) and dedicated work queue (PASID
> in MMIO) enabled by the guest, this requires VFIO device driver to 
> mediate the dedicated work queue path so vPASIDs programmed by 
> the guest are manually translated to pPASIDs before written to the 
> pdev. This may add undesired software complexity and potential 
> performance impact if the PASID register locates alongside other 
> fast-path resources in the same 4K page. If it works it essentially 
> converts type-7 to type-8 from user p.o.v.
>
> The second option is using an enlightened approach so the guest 
> directly use the host-allocated pPASIDs instead of creating its own vPASID
> space. In this case even the dedicated work queue path uses pPASID w/o
> the need of mediation. However this requires different uAPI semantics 
> (from register-vPASID to return-pPASID) and exposes pPASID knowledge 
> to userspace which also implies breaking VM live migration.
>
> The third option is making pPASID as an alias routing info to vPASID 
> and having both linked to the same I/O page table in the IOMMU, so 
> either way can hit the desired address space. This further requires sort 
> of range split scheme to avoid conflict between vPASID and pPASID. 
> However, we haven't found a clear way to fold this trick into this uAPI 
> proposal yet. and this option may not work when PASID is also used to 
> tag the IMS entry for verifying the interrupt source. In this case there 
> is no room for aliasing.
>
> So, none of above can work cleanly based on current thoughts. We 
> decide to not support type-7/8 mix in this proposal. User could detect 
> this exception based on reported PASID flags, as outlined in next section.
>
> 1.4.4. User sequence
> ********************
>
> A new PASID capability info could be introduced to VFIO_DEVICE_GET_INFO.
> The presence indicates allowing the user to create multiple I/O address
> spaces with vPASID on the device. This capability further includes 
> following flags to help describe the desired uAPI semantics:
>
> 	-   PASID_DELEGATED;	// PASID space delegated to the user?
> 	-   PASID_CPU;		// Allow vPASID used in the CPU?
> 	-   PASID_CPU_VIRT;	// Require vPASID translation in the CPU?
>
> The last two flags together help the user to detect the unsupported 
> type 7/8 mix scenario.
>
> Take Qemu for example. It queries above flags for every vfio device at 
> initialization time, after identifying the PASID capability:
>
> 1)  If PASID_DELEGATED is set, the PASID space is fully managed by the 
>     user thus a single IOASID (linked to user-managed page table) is 
>     required as the placeholder for all non-default I/O address spaces 
>     on the device.
>
>     If not set, an IOASID must be created for every non-default I/O address 
>     space on this device and vPASID must be registered to the kernel 
>     when attaching the device to this IOASID.
>
>     User may want to sanity check on all devices with the same setting 
>     as this flag is a platform attribute though it's exported per device.
>
>     If not set, continue to step 2.
>
> 2)  If PASID_CPU is not set, done.
>
>     Otherwise check whether the PASID_CPU_VIRT flag on this device is 
>     consistent with all other devices with PASID_CPU set.
>
>     If inconsistency is found (indicating type 7/8 mix), only one type
>     of devices (all set, or all clear) should have the vPASID capability
>     exposed to the guest.
>
> 3)  If PASID_CPU_VIRT is not set, done.
>
>     If set and consistency check in 2) is passed, call KVM uAPI to 
>     enable CPU PASID translation if it is the first device with this flag 
>     set. Later when a new vPASID is identified through vIOMMU at run-time, 
>     call another KVM uAPI to update the corresponding PASID mapping.
>
> 1.5. No-snoop DMA
> ++++++++++++++++++++
>
> Snoop behavior of a DMA specifies whether the access is coherent (snoops 
> the processor caches) or not. The snoop behavior is decided by both device 
> and IOMMU. Device can set a no-snoop attribute in DMA request to force 
> the non-coherent behavior, while IOMMU may support a configuration which 
> enforces DMAs to be coherent (with the no-snoop attribute ignored).
>
> No-snoop DMA requires the driver to manually flush caches for 
> observing the latest content. When such driver is running in the guest, 
> it further requires KVM to intercept/emulate WBINVD plus favoring 
> guest cache attributes in the EPT page table.
>
> Alex helped create a matrix as below:
> (https://lore.kernel.org/linux-iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com/T/#mbfc96278b078d3ec07eabb9aa46abfe03a886dc6)
>
>              \ Device supports
> IOMMU enforces\   no-snoop
>       snoop    \  yes | no  |
> ----------------+-----+-----+
>            yes  |  1  |  2  |
> ----------------+-----+-----+
>            no   |  3  |  4  |
> ----------------+-----+-----+
>
> DMA is always coherent in boxes {1, 2, 4}. No-snoop DMA is allowed
> in {3} but whether it is actually used is a driver decision.
>
> VFIO currently adopts a simple policy - always turn on IOMMU enforce-
> snoop if available. It provides a contract via kvm-vfio fd for KVM to
> learn whether no-snoop DMA is used thus special tricks on WBINVD 
> and EPT must be enabled. However, the criteria of no-snoop DMA is 
> solely based on the fact of lacking IOMMU enforce-snoop for any vfio 
> device, i.e. both 3) and 4) are considered capable of doing no-snoop 
> DMA. This model has several limitations:
>
> -   It's impossible to move a device from 1) to 3) when no-snoop DMA
>     is a must to achieve the desired user experience;
>
> -   Unnecessary overhead in KVM side in 4) or if the driver doesn't do 
>     no-snoop DMA in 3). Although the driver doesn't use WBINVD, the 
>     guest still uses WBINVD in other places e.g. when changing cache-
>     related registers (e.g. MTRR/CR0);
>
> We want to adopt an user-driven model in /dev/iommu for more accurate
> control over the no-snoop usage. In this model the enforce-snoop format 
> is specified when an IOASID is created, while the device no-snoop usage 
> can be further clarified when it's attached to the IOASID. 
>
> IOMMU fd is expected to provide uAPIs and helper functions for:
>
> -   reporting IOMMU enforce-snoop capability to the user per device
>     cookie (device no-snoop capability is reported via VFIO).
>
> -   allowing user to specify whether an IOASID should be created in the 
>     IOMMU enforce-snoop format (enable/disable/auto):
>
>     * This allows moving a device from 1) to 3) in case of performance
>       requirement.
>
>     * 'auto' falls back to the legacy VFIO policy, i.e. always enables
>       enforce-snoop if available.
>
>     * Any device can be attached to a non-enforce-snoop IOASID, 
>       because this format is supported by all IOMMUs. In this case the
>       device belongs to {3, 4} and whether it is considered doing no-snoop
>       DMA is decided by the next interface.
>
>     * Attaching a device which cannot be forced to snoop by its IOMMU 
>       to an enforce-snoop IOASID gets a failure. Successful attaching
>       implies the device always does snoop DMA, i.e. belonging to {1,2}.
>
>     * Some platform supports page-granular enforce-snoop. One open
>       is whether a page-granular interface is necessary here.
>
> -   allowing user to further hint whether no-snoop DMA is actually used 
>     in {3, 4} on a specific IOASID, via the VFIO attaching call:
>
>     * in case the user has such intrinsic knowledge on a specific device.
>
>     * {3} can be filtered out with this hint.
>
>     * {4} can be filtered out automatically by VFIO device driver, 
>       based on device no-snoop capability.
>
>     * If no hint is provided, fall back to legacy VFIO policy, i.e. 
>       treating all devices in {3, 4} as capable of doing no-snoop.
>
> -   a new contract for KVM to learn whether any IOASID is attached by
>     devices which require no-snoop DMA:
>
>     * Once we thought existing kvm-vfio fd can be leveraged as a short
>       term approach (see above link). However kvm-vfio is centralized
>       on vfio group concept, while this proposal is moving to device-
>       centric model.
>
>     * The new contract will allows KVM to query no-snoop requirement 
>       per IOMMU fd. This will apply to all passthrough frameworks.
>
>     * A notification mechanism might be introduced to switch between
>       WBINVD emulation and no-op intercept according to device 
>       attaching status change in registered IOMMU fd.
>
>     * whether kvm-vfio will be completely deprecated is a TBD. It's 
>       still used for non-iommu related contract, e.g. notifying kvm 
>       pointer to mdev driver and pvIOMMU acceleration in PPC.
>
> -   optional bulk cache invalidation:
>
>     * Userspace driver can use clflush to invalidate cachelines for
>       buffers used for no-snoop DMA. But this may be inefficient when
>       a big buffer needs to be invalidated. In this case a bulk
>       invalidation could be provided based on WBINVD.
>
> The implementation might be a staging approach. In the start IOMMU fd
> only support devices which can be forced to snoop via the IOMMU (i.e.
> {1, 2}), while leaving {3, 4} still handled via legacy VFIO. In 
> this case no need to introduce new contract with KVM. An easy way is 
> having VFIO not expose {3, 4} devices in /dev/vfio/devices. Then we have 
> plenty of time to figure out the implementation detail of the new model 
> at a later stage.
>
> 2. uAPI Proposal
> ----------------------
>
> /dev/iommu uAPI covers everything about managing I/O address spaces.
>
> /dev/vfio device uAPI builds connection between devices and I/O address 
> spaces.
>
> /dev/kvm uAPI is optionally required as far as no-snoop DMA or ENQCMD 
> is concerned.
>
> 2.1. /dev/iommu uAPI
> ++++++++++++++++++++
>
> /*
>   * Check whether an uAPI extension is supported. 
>   *
>   * It's unlikely that all planned capabilities in IOMMU fd will be ready in
>   * one breath. User should check which uAPI extension is supported 
>   * according to its intended usage.
>   *
>   * A rough list of possible extensions may include:
>   *
>   *	- EXT_MAP_TYPE1V2 for vfio type1v2 map semantics;
>   *	- EXT_MAP_NEWTYPE for an enhanced map semantics;
>   *	- EXT_IOASID_NESTING for what the name stands;
>   *	- EXT_USER_PAGE_TABLE for user managed page table;
>   *	- EXT_USER_PASID_TABLE for user managed PASID table;
>   *	- EXT_MULTIDEV_GROUP for 1:N iommu group;
>   *	- EXT_DMA_NO_SNOOP for no-snoop DMA support;
>   *	- EXT_DIRTY_TRACKING for tracking pages dirtied by DMA;
>   *	- ...
>   *
>   * Return: 0 if not supported, 1 if supported.
>   */
> #define IOMMU_CHECK_EXTENSION	_IO(IOMMU_TYPE, IOMMU_BASE + 0)
>
>
> /*
>   * Check capabilities and format information on a bound device.
>   *
>   * It could be reported either via a capability chain as implemented in 
>   * VFIO or a per-capability query interface. The device is identified 
>   * by device cookie (registered when binding this device).
>   *
>   * Sample capability info:
>   *	- VFIO type1 map: supported page sizes, permitted IOVA ranges, etc.;
>   *	- IOASID nesting: hardware nesting vs. software nesting;
>   *	- User-managed page table: vendor specific formats;
>   *	- User-managed pasid table: vendor specific formats;
>   *	- coherency: whether IOMMU can enforce snoop for this device;
>   *	- ...
>   *
>   */
> #define IOMMU_DEVICE_GET_INFO	_IO(IOMMU_TYPE, IOMMU_BASE + 1)
>
>
> /*
>   * Allocate an IOASID. 
>   *
>   * IOASID is the FD-local software handle representing an I/O address 
>   * space. Each IOASID is associated with a single I/O page table. User 
>   * must call this ioctl to get an IOASID for every I/O address space that is
>   * intended to be tracked by the kernel.
>   *
>   * User needs to specify the attributes of the IOASID and associated
>   * I/O page table format information according to one or multiple devices
>   * which will be attached to this IOASID right after. The I/O page table 
>   * is activated in the IOMMU when it's attached by a device. Incompatible

.. if not SW mediated
>   * format between device and IOASID will lead to attaching failure.
>   *
>   * The root IOASID should always have a kernel-managed I/O page 
>   * table for safety. Locked page accounting is also conducted on the root.
The definition of root IOASID is not easily found in this spec. Maybe
this would deserve some clarification.
>   * Multiple roots are possible, e.g. when multiple I/O address spaces
>   * are created but IOASID nesting is disabled. However, one page might 
>   * be accounted multiple times in this case. The user is recommended to 
>   * instead create a 'dummy' root with identity mapping (HVA->HVA) for 
>   * centralized accounting, nested by all other IOASIDs which represent 
>   * 'real' I/O address spaces.
>   *
>   * Sample attributes:
>   *	- Ownership: kernel-managed or user-managed I/O page table;
>   *	- IOASID nesting: the parent IOASID info if enabled;
>   *	- User-managed page table: addr and vendor specific formats;
>   *	- User-managed pasid table: addr and vendor specific formats;
>   *	- coherency: enforce-snoop;
>   *	- ...
>   *
>   * Return: allocated ioasid on success, -errno on failure.
>   */
> #define IOMMU_IOASID_ALLOC		_IO(IOMMU_TYPE, IOMMU_BASE + 2)
> #define IOMMU_IOASID_FREE		_IO(IOMMU_TYPE, IOMMU_BASE + 3)
>
>
> /*
>   * Map/unmap process virtual addresses to I/O virtual addresses.
>   *
>   * Provide VFIO type1 equivalent semantics. Start with the same 
>   * restriction e.g. the unmap size should match those used in the 
>   * original mapping call. 
>   *
>   * If the specified IOASID is the root, the mapped pages are automatically
>   * pinned and accounted as locked memory. Pinning might be postponed 
>   * until the IOASID is attached by a device. Software mdev driver may 
>   * further provide a hint to skip auto-pinning at attaching time, since
>   * it does selective pinning at run-time. auto-pinning can be also 
>   * skipped when I/O page fault is enabled on the root.
>   * 
>   * When software nesting is enabled, this implies that the merged
>   * shadow mapping will also be updated accordingly. However if the
>   * change happens on the parent, it requires reverse lookup to update
>   * all relevant child mappings which is time consuming. So the user
>   * is not suggested to change the parent mapping after the software
>   * nesting is established (maybe disallow?). There is no such restriction 
>   * with hardware nesting, as the IOMMU will catch up the change 
>   * when actually walking the page table.
>   *
>   * Input parameters:
>   *	- u32 ioasid;
>   *	- refer to vfio_iommu_type1_dma_{un}map
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOMMU_MAP_DMA	_IO(IOMMU_TYPE, IOMMU_BASE + 4)
> #define IOMMU_UNMAP_DMA	_IO(IOMMU_TYPE, IOMMU_BASE + 5)
>
>
> /*
>   * Invalidate IOTLB for an user-managed I/O page table
>   *
>   * check include/uapi/linux/iommu.h for supported cache types and
>   * granularities. Device cookie and vPASID may be specified to help 
>   * decide the scope of this operation.
>   *
>   * Input parameters:
>   *	- child_ioasid;
>   *	- granularity (per-device, per-pasid, range-based);
>   *	- cache type (iotlb, devtlb, pasid cache);
>   * 
>   * Return: 0 on success, -errno on failure
>   */
> #define IOMMU_INVALIDATE_CACHE	_IO(IOMMU_TYPE, IOMMU_BASE + 6)
>
>
> /*
>   * Page fault report and response
>   *
>   * This is TBD. Can be added after other parts are cleared up. It may
>   * include a fault region to report fault data via read()), an 
>   * eventfd to notify the user and an ioctl to complete the fault.
>   *
>   * The fault data includes {IOASID, device_cookie, faulting addr, perm} 
>   * as common info. vendor specific fault info can be also included if
>   * necessary.
>   *
>   * If the IOASID represents an user-managed PASID table, the vendor
>   * fault info includes vPASID information for the user to figure out
>   * which I/O page table triggers the fault.
>   *
>   * If the IOASID represents an user-managed I/O page table, the user
>   * is expected to find out vPASID itself according to {IOASID, device_
>   * cookie}. 
>   */
>
>
> /*
>   * Dirty page tracking 
>   *
>   * Track and report memory pages dirtied in I/O address spaces. There 
>   * is an ongoing work by Kunkun Jiang by extending existing VFIO type1. 
>   * It needs be adapted to /dev/iommu later.
>   */
>
>
> 2.2. /dev/vfio device uAPI
> ++++++++++++++++++++++++++
>
> /*
>   * Bind a vfio_device to the specified IOMMU fd
>   *
>   * The user should provide a device cookie when calling this ioctl. The 
>   * cookie is later used in IOMMU fd for capability query, iotlb invalidation
>   * and I/O fault handling.
>   *
>   * User is not allowed to access the device before the binding operation
>   * is completed.
>   *
>   * Unbind is automatically conducted when device fd is closed.
>   *
>   * Input parameters:
>   *	- iommu_fd;
>   *	- cookie;
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_BIND_IOMMU_FD	_IO(VFIO_TYPE, VFIO_BASE + 22)
>
>
> /*
>   * Report vPASID info to userspace via VFIO_DEVICE_GET_INFO
>   *
>   * Add a new device capability. The presence indicates that the user
>   * is allowed to create multiple I/O address spaces on this device. The
>   * capability further includes following flags:
>   *
>   *	- PASID_DELEGATED, if clear every vPASID must be registered to 
>   *	  the kernel;
>   *	- PASID_CPU, if set vPASID is allowed to be carried in the CPU 
>   *	  instructions (e.g. ENQCMD);
>   *	- PASID_CPU_VIRT, if set require vPASID translation in the CPU; 
>   * 
>   * The user must check that all devices with PASID_CPU set have the 
>   * same setting on PASID_CPU_VIRT. If mismatching, it should enable 
>   * vPASID only in one category (all set, or all clear).
>   *
>   * When the user enables vPASID on the device with PASID_CPU_VIRT
>   * set, it must enable vPASID CPU translation via kvm fd before attempting
>   * to use ENQCMD to submit work items. The command portal is blocked 
>   * by the kernel until the CPU translation is enabled.
>   */
> #define VFIO_DEVICE_INFO_CAP_PASID		5
>
>
> /*
>   * Attach a vfio device to the specified IOASID
>   *
>   * Multiple vfio devices can be attached to the same IOASID, and vice 
>   * versa. 
>   *
>   * User may optionally provide a "virtual PASID" to mark an I/O page 
>   * table on this vfio device, if PASID_DELEGATED is not set in device info. 
>   * Whether the virtual PASID is physically used or converted to another 
>   * kernel-allocated PASID is a policy in the kernel.
>   *
>   * Because one device is allowed to bind to multiple IOMMU fd's, the
>   * user should provide both iommu_fd and ioasid for this attach operation.
>   *
>   * Input parameter:
>   *	- iommu_fd;
>   *	- ioasid;
>   *	- flag;
>   *	- vpasid (if specified);
>   * 
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_ATTACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 23)
> #define VFIO_DETACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 24)
>
>
> 2.3. KVM uAPI
> +++++++++++++
>
> /*
>   * Check/enable CPU PASID translation via KVM CAP interface
>   *
>   * This is necessary when ENQCMD will be used in the guest while the
>   * targeted device doesn't accept the vPASID saved in the CPU MSR.
>   */
> #define KVM_CAP_PASID_TRANSLATION	206
>
>
> /*
>   * Update CPU PASID mapping
>   *
>   * This command allows user to set/clear the vPASID->pPASID mapping
>   * in the CPU, by providing the IOASID (and FD) information representing
>   * the I/O address space marked by this vPASID. KVM calls iommu helper
>   * function to retrieve pPASID according to the input parameters. So the
>   * pPASID value is completely hidden from the user.
>   *
>   * Input parameters:
>   *	- user_pasid;
>   *	- iommu_fd;
>   *	- ioasid;
>   */
> #define KVM_MAP_PASID	_IO(KVMIO, 0xf0)
> #define KVM_UNMAP_PASID	_IO(KVMIO, 0xf1)
>
>
> /*
>   * and a new contract to exchange no-snoop dma status with IOMMU fd.
>   * this will be a device-centric interface, thus existing vfio-kvm contract
>   * is not suitable as it's group-centric.
>   *
>   * actual definition TBD.
>   */
>
>
> 3. Sample structures and helper functions
> --------------------------------------------------------
>
> Three helper functions are provided to support VFIO_BIND_IOMMU_FD:
>
> 	struct iommu_ctx *iommu_ctx_fdget(int fd);
> 	struct iommu_dev *iommu_register_device(struct iommu_ctx *ctx,
> 		struct device *device, u64 cookie);
> 	int iommu_unregister_device(struct iommu_dev *dev);
>
> An iommu_ctx is created for each fd:
>
> 	struct iommu_ctx {
> 		// a list of allocated IOASID data's
> 		struct xarray		ioasid_xa;
>
> 		// a list of registered devices
> 		struct xarray		dev_xa;
> 	};
>
> Later some group-tracking fields will be also introduced to support 
> multi-devices group.
>
> Each registered device is represented by iommu_dev:
>
> 	struct iommu_dev {
> 		struct iommu_ctx	*ctx;
> 		// always be the physical device
> 		struct device 		*device;
> 		u64			cookie;
> 		struct kref		kref;
> 	};
>
> A successful binding establishes a security context for the bound
> device and returns struct iommu_dev pointer to the caller. After this
> point, the user is allowed to query device capabilities via IOMMU_
> DEVICE_GET_INFO.
>
> For mdev the struct device should be the pointer to the parent device. 
>
> An ioasid_data is created when IOMMU_IOASID_ALLOC, as the main 
> object describing characteristics about an I/O page table:
>
> 	struct ioasid_data {
> 		struct iommu_ctx	*ctx;
>
> 		// the IOASID number
> 		u32			ioasid;
>
> 		// the handle for kernel-managed I/O page table
> 		struct iommu_domain *domain;
>
> 		// map metadata (vfio type1 semantics)
> 		struct rb_node		dma_list;
>
> 		// pointer to user-managed pgtable
> 		u64			user_pgd;
>
> 		// link to the parent ioasid (for nesting)
> 		struct ioasid_data	*parent;
>
> 		// IOMMU enforce-snoop
> 		bool			enforce_snoop;
>
> 		// various format information
> 		...
>
> 		// a list of device attach data (routing information)
> 		struct list_head		attach_data;
>
> 		// a list of fault_data reported from the iommu layer
> 		struct list_head		fault_data;
>
> 		...
> 	}
>
> iommu_domain is the object for operating the kernel-managed I/O 
> page tables in the IOMMU layer. ioasid_data is associated to an
> iommu_domain explicitly or implicitly:
>
> -   root IOASID (except the 'dummy' one for locked accounting)
>     must use kernel-manage I/O page table thus always linked to an 
>     iommu_domain;
>
> -   child IOASID (via software nesting) is explicitly linked to an iommu
>     domain as the shadow I/O page table is managed by the kernel;
>
> -   child IOASID (via hardware nesting) is linked to another simpler iommu
>     layer object (TBD) for tracking user-managed page table. Due to 
>     nesting it is also implicitly linked to the iommu_domain of the 
>     parent;
>
> Following link has an initial discussion on this part:
>
> https://lore.kernel.org/linux-iommu/BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com/T/#m2c19d3825cc096daf2026ea94e00cc5858cda321
>
> As Jason recommends in v1, bus-specific wrapper functions are provided
> explicitly to support VFIO_ATTACH_IOASID, e.g.
>
> 	struct iommu_attach_data * iommu_pci_device_attach(
> 		struct iommu_dev *dev, struct pci_device *pdev, 
> 		u32 ioasid);
> 	struct iommu_attach_data * iommu_pci_device_attach_pasid(
> 		struct iommu_dev *dev, struct pci_device *pdev, 
> 		u32 ioasid, u32 pasid);
>
> and variants for non-PCI devices.
>
> A helper function is provided for above wrappers:
>
> 	// flags specifies whether pasid is valid
> 	struct iommu_attach_data *__iommu_device_attach(
> 		struct ioasid_dev *dev, u32 ioasid, u32 pasid, int flags);
>
> A new object is introduced and linked to ioasid_data->attach_data for 
> each successful attach operation:
>
> 	struct iommu_attach_data {
> 		struct list_head	next;
> 		struct iommu_dev	*dev;
> 		u32 			pasid;
> 	}
>
> The helper function for VFIO_DETACH_IOASID is generic:
>
> 	int iommu_device_detach(struct iommu_attach_data *data);
>
> 4. Use Cases and Flows
> -------------------------------
>
> Here assume VFIO will support a new model where /dev/iommu capable
> devices are explicitly listed under /dev/vfio/devices thus a device fd can 
> be acquired w/o going through legacy container/group interface. They 
> maybe further categorized into sub-directories based on device types
> (e.g. pdev, mdev, etc.). For illustration purpose those devices are putting
s/putting/put
> together and just called dev[1...N]:
>
> 	device_fd[1...N] = open("/dev/vfio/devices/dev[1...N]", mode);
>
> VFIO continues to support container/group model for legacy applications
> and also for devices which are not moved to /dev/iommu in one breath
> (e.g. in a group with multiple devices, or support no-snoop DMA). In concept
> there is no problem for VFIO to support two models simultaneously, but 
> we'll wait to see any issue when reaching implementation.
>
> As explained earlier, one IOMMU fd is sufficient for all intended use cases:
>
> 	iommu_fd = open("/dev/iommu", mode);
>
> For simplicity below examples are all made for the virtualization story.
> They are representative and could be easily adapted to a non-virtualization
> scenario.
>
> Three types of IOASIDs are considered:
>
> 	gpa_ioasid[1...N]: 	GPA as the default address space
> 	giova_ioasid[1...N]:	GIOVA as the default address space (nesting)
> 	gva_ioasid[1...N]:	CPU VA as non-default address space (nesting)
>
> At least one gpa_ioasid must always be created per guest, while the other 
> two are relevant as far as vIOMMU is concerned.
>
> Examples here apply to both pdev and mdev. VFIO device driver in the 
> kernel will figure out the associated routing information in the attaching 
> operation.
>
> For illustration simplicity, IOMMU_CHECK_EXTENSION and IOMMU_DEVICE_
> GET_INFO are skipped in these examples. No-snoop DMA is also not covered here.
>
> Below examples may not apply to all platforms. For example, the PAPR IOMMU
> in PPC platform always requires a vIOMMU and blocks DMAs until the device is 
> explicitly attached to an GIOVA address space. there are even fixed 
> associations between available GIOVA spaces and devices. Those platform 
> specific variances are not covered here and will be figured out in the 
> implementation phase.
>
> 4.1. A simple example
> +++++++++++++++++++++
>
> Dev1 is assigned to the guest. A cookie has been allocated by the user
> to represent this device in the iommu_fd.
>
> One gpa_ioasid is created. The GPA address space is managed through 
> DMA mapping protocol by specifying that the I/O page table is managed
> by the kernel:
>
> 	/* Bind device to IOMMU fd */
> 	device_fd = open("/dev/vfio/devices/dev1", mode);
> 	iommu_fd = open("/dev/iommu", mode);
> 	bind_data = {.fd = iommu_fd; .cookie = cookie};
> 	ioctl(device_fd, VFIO_BIND_IOASID_FD, &bind_data);
>
> 	/* Allocate IOASID */
> 	alloc_data = {.user_pgtable = false};
> 	gpa_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach device to IOASID */
> 	at_data = { .fd = iommu_fd; .ioasid = gpa_ioasid};
> 	ioctl(device_fd, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Setup GPA mapping [0 - 1GB] */
> 	dma_map = {
> 		.ioasid	= gpa_ioasid;
> 		.iova	= 0;		// GPA
> 		.vaddr	= 0x40000000;	// HVA
> 		.size	= 1GB;
> 	};
> 	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
>
> If the guest is assigned with more than dev1, the user follows above 
> sequence to attach other devices to the same gpa_ioasid i.e. sharing 
> the GPA address space cross all assigned devices, e.g. for dev2:
>
> 	bind_data = {.fd = iommu_fd; .cookie = cookie2};
> 	ioctl(device_fd2, VFIO_BIND_IOASID_FD, &bind_data);
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>
> 4.2. Multiple IOASIDs (no nesting)
> ++++++++++++++++++++++++++++++++++
>
> Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> both devices are attached to gpa_ioasid. After boot the guest creates 
> a GIOVA address space (giova_ioasid) for dev2, leaving dev1 in pass
> through mode (gpa_ioasid).
>
> Suppose IOASID nesting is not supported in this case. Qemu needs to
> generate shadow mappings in userspace for giova_ioasid (like how
> VFIO works today). The side-effect is that duplicated locked page 
> accounting might be incurred in this example as there are two root
> IOASIDs now. It will be fixed once IOASID nesting is supported:
>
> 	device_fd1 = open("/dev/vfio/devices/dev1", mode);
> 	device_fd2 = open("/dev/vfio/devices/dev2", mode);
> 	iommu_fd = open("/dev/iommu", mode);
>
> 	/* Bind device to IOMMU fd */
> 	bind_data = {.fd = iommu_fd; .device_cookie = cookie1};
> 	ioctl(device_fd1, VFIO_BIND_IOASID_FD, &bind_data);
> 	bind_data = {.fd = iommu_fd; .device_cookie = cookie2};
> 	ioctl(device_fd2, VFIO_BIND_IOASID_FD, &bind_data);
>
> 	/* Allocate IOASID */
> 	alloc_data = {.user_pgtable = false};
> 	gpa_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach dev1 and dev2 to gpa_ioasid */
> 	at_data = { .fd = iommu_fd; .ioasid = gpa_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Setup GPA mapping [0 - 1GB] */
> 	dma_map = {
> 		.ioasid	= gpa_ioasid;
> 		.iova	= 0; 		// GPA
> 		.vaddr	= 0x40000000;	// HVA
> 		.size	= 1GB;
> 	};
> 	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
>
> 	/* After boot, guest enables a GIOVA space for dev2 via vIOMMU */
> 	alloc_data = {.user_pgtable = false};
> 	giova_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* First detach dev2 from previous address space */
> 	at_data = { .fd = iommu_fd; .ioasid = gpa_ioasid};
> 	ioctl(device_fd2, VFIO_DETACH_IOASID, &at_data);
>
> 	/* Then attach dev2 to the new address space */
> 	at_data = { .fd = iommu_fd; .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Setup a shadow DMA mapping according to vIOMMU.
> 	 *
> 	 * e.g. the vIOMMU page table adds a new 4KB mapping:
> 	 *    GIOVA [0x2000] -> GPA [0x1000]
> 	 *
> 	 * and GPA [0x1000] is mapped to HVA [0x40001000] in gpa_ioasid.
> 	 * 
> 	 * In this case the shadow mapping should be:
> 	 *    GIOVA [0x2000] -> HVA [0x40001000]
> 	 */
> 	dma_map = {
> 		.ioasid	= giova_ioasid;
> 		.iova	= 0x2000; 	// GIOVA
> 		.vaddr	= 0x40001000;	// HVA
> 		.size	= 4KB;
> 	};
> 	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
>
> 4.3. IOASID nesting (software)
> ++++++++++++++++++++++++++++++
>
> Same usage scenario as 4.2, with software-based IOASID nesting 
> available. In this mode it is the kernel instead of user to create the
> shadow mapping.
>
> The flow before guest boots is same as 4.2, except one point. Because 
> giova_ioasid is nested on gpa_ioasid, locked accounting is only 
> conducted for gpa_ioasid which becomes the only root.
>
> There could be a case where different gpa_ioasids are created due
> to incompatible format between dev1/dev2 (e.g. about IOMMU 
> enforce-snoop). In such case the user could further created a dummy
> IOASID (HVA->HVA) as the root parent for two gpa_ioasids to avoid 
> duplicated accounting. But this scenario is not covered in following 
> flows.
>
> To save space we only list the steps after boots (i.e. both dev1/dev2
s/after boots/after boot
here and below
> have been attached to gpa_ioasid before guest boots):
>
> 	/* After boots */
> 	/* Create GIOVA space nested on GPA space
> 	 * Both page tables are managed by the kernel
> 	 */
> 	alloc_data = {.user_pgtable = false; .parent = gpa_ioasid};
> 	giova_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach dev2 to the new address space (child)
> 	 * Note dev2 is still attached to gpa_ioasid (parent)
> 	 */
> 	at_data = { .fd = iommu_fd; .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Setup a GIOVA [0x2000] ->GPA [0x1000] mapping for giova_ioasid, 
> 	 * based on the vIOMMU page table. The kernel is responsible for
> 	 * creating the shadow mapping GIOVA [0x2000] -> HVA [0x40001000]
> 	 * by walking the parent's I/O page table to find out GPA [0x1000] ->
> 	 * HVA [0x40001000].
> 	 */
> 	dma_map = {
> 		.ioasid	= giova_ioasid;
> 		.iova	= 0x2000;	// GIOVA
> 		.vaddr	= 0x1000;	// GPA
> 		.size	= 4KB;
> 	};
> 	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
>
> 4.4. IOASID nesting (hardware)
> ++++++++++++++++++++++++++++++
>
> Same usage scenario as 4.2, with hardware-based IOASID nesting
> available. In this mode the I/O page table is managed by userspace
> thus an invalidation interface is used for the user to request iotlb
> invalidation.
>
> 	/* After boots */
> 	/* Create GIOVA space nested on GPA space.
> 	 * Claim it's an user-managed I/O page table.
> 	 */
> 	alloc_data = {
> 		.user_pgtable	= true;
> 		.parent		= gpa_ioasid;
> 		.addr		= giova_pgtable;
> 		// and format information;
> 	};
> 	giova_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach dev2 to the new address space (child)
> 	 * Note dev2 is still attached to gpa_ioasid (parent)
> 	 */
> 	at_data = { .fd = iommu_fd; .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Invalidate IOTLB when required */
> 	inv_data = {
> 		.ioasid	= giova_ioasid;
> 		// granular/cache type information
> 	};
> 	ioctl(iommu_fd, IOMMU_INVALIDATE_CACHE, &inv_data);
>
> 	/* See 4.6 for I/O page fault handling */
> 	
> 4.5. Guest SVA (vSVA)
> +++++++++++++++++++++
>
> After boots the guest further creates a GVA address spaces (vpasid1) on 
> dev1. Dev2 is not affected (still attached to giova_ioasid).

> As explained in section 1.4, the user should check the PASID capability
> exposed via VFIO_DEVICE_GET_INFO and follow the required uAPI
> semantics when doing the attaching call:
>
> /****** If dev1 reports PASID_DELEGATED=false **********/
> 	/* After boots */
> 	/* Create GVA space nested on GPA space.
> 	 * Claim it's an user-managed I/O page table.
> 	 */
> 	alloc_data = {
> 		.user_pgtable 	= true;
> 		.parent		= gpa_ioasid;
> 		.addr		= gva_pgtable;
> 		// and format information;
> 	};
> 	gva_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach dev1 to the new address space (child) and specify 
> 	 * vPASID. Note dev1 is still attached to gpa_ioasid (parent)
> 	 */
> 	at_data = {
> 		.fd		= iommu_fd;
> 		.ioasid		= gva_ioasid;
> 		.flag 		= IOASID_ATTACH_VPASID;
> 		.vpasid		= vpasid1;
> 	};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* Enable CPU PASID translation if required */
> 	if (PASID_CPU and PASID_CPU_VIRT are both true for dev1) {
> 		pa_data = {
> 			.iommu_fd	= iommu_fd;
> 			.ioasid		= gva_ioasid;
> 			.vpasid		= vpasid1;
> 		};
> 		ioctl(kvm_fd, KVM_MAP_PASID, &pa_data);
> 	};
>
> 	/* Invalidate IOTLB when required */
> 	...
>
> /****** If dev1 reports PASID_DELEGATED=true **********/
> 	/* Create user-managed vPASID space when it's enabled via vIOMMU */
> 	alloc_data = {
> 		.user_pasid_table	= true;
> 		.parent			= gpa_ioasid;
> 		.addr			= gpasid_tbl;
> 		// and format information;
> 	};
> 	pasidtbl_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
>
> 	/* Attach dev1 to the vPASID space */
> 	at_data = {.fd = iommu_fd; .ioasid = pasidtbl_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>
> 	/* from now on all GVA address spaces on dev1 are represented by 
> 	 * a single pasidtlb_ioasid as the placeholder in the kernel.
> 	 *
> 	 * But iotlb invalidation and fault handling are still per GVA 
> 	 * address space. They are still going through IOMMU fd in the 
> 	 * same way as PASID_DELEGATED=false scenario
> 	 */
> 	...
>
> 4.6. I/O page fault
> +++++++++++++++++++
>
> uAPI is TBD. Here is just about the high-level flow from host IOMMU driver
> to guest IOMMU driver and backwards. This flow assumes that I/O page faults
> are reported via IOMMU interrupts. Some devices report faults via device
> specific way instead of going through the IOMMU. That usage is not covered
> here:
>
> -   Host IOMMU driver receives a I/O page fault with raw fault_data {rid, 
>     pasid, addr};
>
> -   Host IOMMU driver identifies the faulting I/O page table according to
>     {rid, pasid} and calls the corresponding fault handler with an opaque
>     object (registered by the handler) and raw fault_data (rid, pasid, addr);
>
> -   IOASID fault handler identifies the corresponding ioasid and device 
>     cookie according to the opaque object, generates an user fault_data 
>     (ioasid, cookie, addr) in the fault region, and triggers eventfd to 
>     userspace;
>
>       * In case ioasid represents a pasid table, pasid is also included as
>         additional fault_data;
>
>       * the raw fault_data is also cached in ioasid_data->fault_data and
>         used when generating response;
>
> -   Upon received event, Qemu needs to find the virtual routing information 
>     (v_rid + v_pasid) of the device attached to the faulting ioasid;
>
>       * v_rid is identified according to device_cookie;
>
>       * v_pasid is either identified according to ioasid, or already carried
>         in the fault data;
>
> -   Qemu generates a virtual I/O page fault through vIOMMU into guest,
>     carrying the virtual fault data (v_rid, v_pasid, addr);
>
> -   Guest IOMMU driver fixes up the fault, updates the guest I/O page table
>     (GIOVA or GVA), and then sends a page response with virtual completion 
>     data (v_rid, v_pasid, response_code) to vIOMMU;
>
> -   Qemu finds the pending fault event, converts virtual completion data 
>     into (ioasid, cookie, response_code), and then calls a /dev/iommu ioctl to 
>     complete the pending fault;
>
> -   /dev/iommu finds out the pending fault data {rid, pasid, addr} saved in 
>     ioasid_data->fault_data, and then calls iommu api to complete it with
>     {rid, pasid, response_code};
>
Thanks

Eric

