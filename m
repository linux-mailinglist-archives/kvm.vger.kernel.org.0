Return-Path: <kvm+bounces-29915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5719B407E
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D4F11F22609
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 02:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF411DF96A;
	Tue, 29 Oct 2024 02:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O3mz6qeU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0611D7E4E
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 02:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730169319; cv=none; b=XiabYGKnWV2xHkj+9rsqHo7ScgMDVEU5xHZgkoUXz3wPRIA1pZKgxxkWHhYbg2ktWolTh8enpnrCQNrLIOHJBCWOK4DIAeUEkjB9GQd5XBY3FBnA0eVn+5+GCRJakAmiBGjj6MPUBcXm54eWFdArXkFwr0q2BpCegTRHoOXkFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730169319; c=relaxed/simple;
	bh=iLhO7lh1inDfAn5x8gSirivrdOdqQvRbxDSKgqQdQBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P6wVjFcFrcSTizOCb9dXMRfsTH3cSOyPq4ZtD6x1Xtr4gILn8kVmlfmPwR5W8SZJrFE0Fa6P1uj0+Ycjfg0APpdQsm3uBTE/nflxV2JSSG+/2twId2Cii/eiHh1jp7lqkfTiWQ/UIMWopbgAwRoFb/FZBi47bcsaOtNG/9uSMl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O3mz6qeU; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so6069685e87.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 19:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730169314; x=1730774114; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QcH2vlGTspQOvxs8NozQXunlB1zGk1RfWBkXgdAueCo=;
        b=O3mz6qeUQpWPH+w0uVDeBEKQjrdgLf5kIlFqItp4EEVWl0ACChAFMzclidPcz7Tixg
         RhsjqRD6IkrZmq7wG3xAxt6ISJLbCfcdbNlF31gRFSj4FrE5Vw2McpMX7C/dQN9PS6t0
         zTYgIOjmpz2lPhkk3rTQd7Gu92CHK067BXfZpVu9NQtdB+GUtDdmMYkXm5iYlNaPmbXF
         TYve0CldKRr1+koZVjaHDz46J+vNPO97xyndSvzN5BJm7ps5Bm5XQGiVXerrlc1sAPo8
         jNYdfCaqWvy2AR3AQf6avn8V5mt2nzfidPoo6LGB9/bq/NzL+j2KacuYghLX+beFygE3
         QzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730169314; x=1730774114;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcH2vlGTspQOvxs8NozQXunlB1zGk1RfWBkXgdAueCo=;
        b=MFpbNOlz3/OlyFY4cMjONuifZwcPhYO1GnxZ1Zi3vfsEviDV08/MwQnFtEXSp41dD0
         A+t8jwPGZrO8fUbivzpwUaJSnL3Sf6ZMkOwobWvW/RgxlvQhkVgiQljyjnDIyfYoFj10
         RV5VxQvGnBWYPuvS1yhdalpRjOR1dP5DwuNGzIPP9IfAcpZFV3ElZMDY79N/UV61gWuh
         xnZ340Heg9uq1u/AkFDezNiF+yqNFPcg94uW9nxxivYUrXaJiFEmajH8DvMfE1dalfjm
         9iPqMweU3txwVFi+2CgcNuiXRqKN2aE4xozmM9e6z8PFF3r73utGCsAndI1R5knJ3g5C
         JMSg==
X-Forwarded-Encrypted: i=1; AJvYcCUMgiapHn7gVLPvfGklNG2tFDB/Vonr9bvlsnBe1ZWIGZzuHr+dt/wXW/6FO0MTVJ/gK7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAGzMvnoapbokGIZQuUq1sQirDqzTC2fbtuSHFHhAiNTKy6z94
	H2VecgSlFIjZ3/7DDajvagij9VSJItOR667skFY9xWHiJpo0Zr5sjMweMdJmSSVc40kDs1hi3/2
	Pd4LG0//MXJmYDMLmLSVNiP330cw38rh2YkWpWw==
X-Google-Smtp-Source: AGHT+IF+BVMuEQyL5P4tRyH82fESbmQ9baEgbyI5/9REi8DkcJBXwKkGGYMJErO/g4LEP/FyFYztIy7LuDxruKWh5xo=
X-Received: by 2002:a05:6512:238a:b0:535:6aa9:9868 with SMTP id
 2adb3069b0e04-53b348cb8d9mr5311681e87.19.1730169313585; Mon, 28 Oct 2024
 19:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Tue, 29 Oct 2024 10:35:02 +0800
Message-ID: <CABQgh9HN4VnL04EbadWh9cQf+YpTzvscvXBdHY8nte6CW8RVvg@mail.gmail.com>
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Joao Martins <joao.m.martins@oracle.com>
Cc: iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, Joao

On Tue, 24 Oct 2023 at 21:51, Joao Martins <joao.m.martins@oracle.com> wrote:
>
> v6 is a replacement of what's in iommufd next:
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
>
> base-commit: b5f9e63278d6f32789478acf1ed41d21d92b36cf
>
> (from the iommufd tree)
>
> =========>8=========
>
> Presented herewith is a series that extends IOMMUFD to have IOMMU
> hardware support for dirty bit in the IOPTEs.
>
> Today, AMD Milan (or more recent) supports it while ARM SMMUv3.2
> alongside VT-D rev3.x also do support.  One intended use-case (but not
> restricted!) is to support Live Migration with SR-IOV, specially useful
> for live migrateable PCI devices that can't supply its own dirty
> tracking hardware blocks amongst others.
>
> At a quick glance, IOMMUFD lets the userspace create the IOAS with a
> set of a IOVA ranges mapped to some physical memory composing an IO
> pagetable. This is then created via HWPT_ALLOC or attached to a
> particular device/hwpt, consequently creating the IOMMU domain and share
> a common IO page table representing the endporint DMA-addressable guest
> address space. In IOMMUFD Dirty tracking (since v2 of the series) it
> will require via the HWPT_ALLOC model only, as opposed to simpler
> autodomains model.
>
> The result is an hw_pagetable which represents the
> iommu_domain which will be directly manipulated. The IOMMUFD UAPI,
> and the iommu/iommufd kAPI are then extended to provide:
>
> 1) Enforcement that only devices with dirty tracking support are attached
> to an IOMMU domain, to cover the case where this isn't all homogenous in
> the platform. While initially this is more aimed at possible heterogenous nature
> of ARM while x86 gets future proofed, should any such ocasion occur.
>
> The device dirty tracking enforcement on attach_dev is made whether the
> dirty_ops are set or not. Given that attach always checks for dirty
> ops and IOMMU_CAP_DIRTY, while writing this it almost wanted this to
> move to upper layer but semantically iommu driver should do the
> checking.
>
> 2) Toggling of Dirty Tracking on the iommu_domain. We model as the most
> common case of changing hardware translation control structures dynamically
> (x86) while making it easier to have an always-enabled mode. In the
> RFCv1, the ARM specific case is suggested to be always enabled instead of
> having to enable the per-PTE DBM control bit (what I previously called
> "range tracking"). Here, setting/clearing tracking means just clearing the
> dirty bits at start. The 'real' tracking of whether dirty
> tracking is enabled is stored in the IOMMU driver, hence no new
> fields are added to iommufd pagetable structures, except for the
> iommu_domain dirty ops part via adding a dirty_ops field to
> iommu_domain. We use that too for IOMMUFD to know if dirty tracking
> is supported and toggleable without having iommu drivers replicate said
> checks.
>
> 3) Add a capability probing for dirty tracking, leveraging the
> per-device iommu_capable() and adding a IOMMU_CAP_DIRTY. It extends
> the GET_HW_INFO ioctl which takes a device ID to return some generic
> capabilities *in addition*. Possible values enumarated by `enum
> iommufd_hw_capabilities`.
>
> 4) Read the I/O PTEs and marshal its dirtyiness into a bitmap. The bitmap
> indexes on a page_size basis the IOVAs that got written by the device.
> While performing the marshalling also drivers need to clear the dirty bits
> from IOPTE and allow the kAPI caller to batch the much needed IOTLB flush.
> There's no copy of bitmaps to userspace backed memory, all is zerocopy
> based to not add more cost to the iommu driver IOPT walker. This shares
> functionality with VFIO device dirty tracking via the IOVA bitmap APIs. So
> far this is a test-and-clear kind of interface given that the IOPT walk is
> going to be expensive. In addition this also adds the ability to read dirty
> bit info without clearing the PTE info. This is meant to cover the
> unmap-and-read-dirty use-case, and avoid the second IOTLB flush.
>
> The only dependency is:
> * Have domain_alloc_user() API with flags [2] already queued (iommufd/for-next).
>
> The series is organized as follows:
>
> * Patches 1-4: Takes care of the iommu domain operations to be added.
> The idea is to abstract iommu drivers from any idea of how bitmaps are
> stored or propagated back to the caller, as well as allowing
> control/batching over IOTLB flush. So there's a data structure and an
> helper that only tells the upper layer that an IOVA range got dirty.
> This logic is shared with VFIO and it's meant to walking the bitmap
> user memory, and kmap-ing plus setting bits as needed. IOMMU driver
> just has an idea of a 'dirty bitmap state' and recording an IOVA as
> dirty.
>
> * Patches 5-9, 13-18: Adds the UAPIs for IOMMUFD, and selftests. The
> selftests cover some corner cases on boundaries handling of the bitmap
> and various bitmap sizes that exercise. I haven't included huge IOVA
> ranges to avoid risking the selftests failing to execute due to OOM
> issues of mmaping big buffers.
>
> * Patches 10-11: AMD IOMMU implementation, particularly on those having
> HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated[0]. And
> tested with live migration with VFs (but with IOMMU dirty tracking).
>
> * Patches 12: Intel IOMMU rev3.x+ implementation. Tested with a Qemu
> based intel-iommu vIOMMU with SSADS emulation support[0].
>
> On AMD/Intel I have tested this with emulation and then live migration in
> AMD hardware;
>
> The qemu iommu emulation bits are to increase coverage of this code and
> hopefully make this more broadly available for fellow contributors/devs,
> old version[1]; it uses Yi's 2 commits to have hw_info() supported (still
> needs a bit of cleanup) on top of a recent Zhenzhong series of IOMMUFD
> QEMU bringup work: see here[0]. It includes IOMMUFD dirty tracking for
> Live migration and with live migration tested. I won't be exactly
> following up a v2 of QEMU patches until IOMMUFD tracking lands.
>
> Feedback or any comments are very much appreciated.
>
> Thanks!
>         Joao

Is this patchset enough for iommufd live migration?

Just tried live migration in local machine,
reports "VFIO migration is not supported in kernel"

Thanks

