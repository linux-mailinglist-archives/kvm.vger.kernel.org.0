Return-Path: <kvm+bounces-3388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1AB803B0C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EEDD2810E1
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988F72E631;
	Mon,  4 Dec 2023 17:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DISm5HVS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F733CA
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 09:00:58 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d1b2153ba1so61828937b3.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 09:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701709257; x=1702314057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WYdbFfqQVc4k25YSG4S3L8dDRO2OtAWhg6g/c/qnL28=;
        b=DISm5HVSTDHWxWsx9pJMw1fLI8xspxvb/i9Q29kkAKwu7u7goaWa1Xb2NeOH2MEG1q
         atyghplHoyw3ibKcNJoN3oOw8m2dDjoYXzlynZlT1Oe0olU+P3ZjA/AkkE8oQz9Emaot
         P5oWgB5i41HDmr5e0e0YMiYTSi0UVlKqnJt286w69OegqaFUV2PEHRSSrzBXChtZ0oqU
         Qvo/1I/Zc7Ebj1EcFDJHgfR4auv9/SVlMPIlmRng/Gr65g6KpeycoRDEOwm1e32RckoW
         jpZPwRvh4C+7T6AGq57hZQ6wvS3QzIrq1Ao0bUac3K1vMpX3UvIzCXruWxZp9SPHo53K
         N3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701709257; x=1702314057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WYdbFfqQVc4k25YSG4S3L8dDRO2OtAWhg6g/c/qnL28=;
        b=PHUzfy3RJ2u9YGPCRz8dSXHT0CSh4b1ChtFpoVRdY6bu3VWIE/myptIEX/pBAuiFu2
         GGqQouOYdy0Z13qCbGUA/d9xHGvs4oQyb5h/KKa2BAxeoljnUopoOXf03vI1iQqrRFtS
         lSgsbRd7aUy89zszMI8Whb9Y4fIJrrQ59Ky/Zouseg7ZAYEe6jewNW6CnQoNw6LBe/Wr
         /RMK5E47kOpjWXLiz8AtWxNRSlKT6eW3YU27aXfFJ/taAtjv1xvLfeBYP/Q9nJFvd3OR
         nARR+VqTE5FYOn1VjIqXUSXvtZ1aZKVT5G9JZN1k+dMtld6ChNgO3iw0DCyWbEuNWUWf
         MyxQ==
X-Gm-Message-State: AOJu0YzRTQdDc20l7RJGOguNoqQ+D94jawCVXqaQ9eJo3mcfExiZnVIk
	CsPTaApW7cFEH3u/uwS/5JGxbEWYoAw=
X-Google-Smtp-Source: AGHT+IEPCfmM37uwj/R0nZjh6f3LmvLyxTh2BlKFePY0Bda+oPcSkY5OKZC+FPUtCahZN6LQsjl4BmkVlA8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:300d:b0:5d3:a348:b0b7 with SMTP id
 ey13-20020a05690c300d00b005d3a348b0b7mr314719ywb.7.1701709257595; Mon, 04 Dec
 2023 09:00:57 -0800 (PST)
Date: Mon, 4 Dec 2023 09:00:55 -0800
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Message-ID: <ZW4Fx2U80L1PJKlh@google.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alex.williamson@redhat.com, jgg@nvidia.com, pbonzini@redhat.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com, 
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 02, 2023, Yan Zhao wrote:
> This RFC series proposes a framework to resolve IOPF by sharing KVM TDP
> (Two Dimensional Paging) page table to IOMMU as its stage 2 paging
> structure to support IOPF (IO page fault) on IOMMU's stage 2 paging
> structure.
> 
> Previously, all guest pages have to be pinned and mapped in IOMMU stage 2 
> paging structures after pass-through devices attached, even if the device
> has IOPF capability. Such all-guest-memory pinning can be avoided when IOPF
> handling for stage 2 paging structure is supported and if there are only
> IOPF-capable devices attached to a VM.
> 
> There are 2 approaches to support IOPF on IOMMU stage 2 paging structures:
> - Supporting by IOMMUFD/IOMMU alone
>   IOMMUFD handles IO page faults on stage-2 HWPT by calling GUPs and then
>   iommu_map() to setup IOVA mappings. (IOAS is required to keep info of GPA
>   to HVA, but page pinning/unpinning needs to be skipped.)
>   Then upon MMU notifiers on host primary MMU, iommu_unmap() is called to
>   adjust IOVA mappings accordingly.
>   IOMMU driver needs to support unmapping sub-ranges of a previous mapped
>   range and take care of huge page merge and split in atomic way. [1][2].
> 
> - Sharing KVM TDP
>   IOMMUFD sets the root of KVM TDP page table (EPT/NPT in x86) as the root
>   of IOMMU stage 2 paging structure, and routes IO page faults to KVM.
>   (This assumes that the iommu hw supports the same stage-2 page table
>   format as CPU.)
>   In this model the page table is centrally managed by KVM (mmu notifier,
>   page mapping, subpage unmapping, atomic huge page split/merge, etc.),
>   while IOMMUFD only needs to invalidate iotlb/devtlb properly.

There are more approaches beyond having IOMMUFD and KVM be completely separate
entities.  E.g. extract the bulk of KVM's "TDP MMU" implementation to common code
so that IOMMUFD doesn't need to reinvent the wheel.

> Currently, there's no upstream code available to support stage 2 IOPF yet.
> 
> This RFC chooses to implement "Sharing KVM TDP" approach which has below
> main benefits:

Please list out the pros and cons for each.  In the cons column for piggybacking
KVM's page tables:

 - *Significantly* increases the complexity in KVM
 - Puts constraints on what KVM can/can't do in the future (see the movement
   of SPTE_MMU_PRESENT).
 - Subjects IOMMUFD to all of KVM's historical baggage, e.g. the memslot deletion
   mess, the truly nasty MTRR emulation (which I still hope to delete), the NX
   hugepage mitigation, etc.

Please also explain the intended/expected/targeted use cases.  E.g. if the main
use case is for device passthrough to slice-of-hardware VMs that aren't memory
oversubscribed, 

> - Unified page table management
>   The complexity of allocating guest pages per GPAs, registering to MMU
>   notifier on host primary MMU, sub-page unmapping, atomic page merge/split

Please find different terminology than "sub-page".  With Sub-Page Protection, Intel
has more or less established "sub-page" to mean "less than 4KiB granularity".  But
that can't possibly what you mean here because KVM doesn't support (un)mapping
memory at <4KiB granularity.  Based on context above, I assume you mean "unmapping
arbitrary pages within a given range".

>   are only required to by handled in KVM side, which has been doing that
>   well for a long time.
> 
> - Reduced page faults:
>   Only one page fault is triggered on a single GPA, either caused by IO
>   access or by vCPU access. (compared to one IO page fault for DMA and one
>   CPU page fault for vCPUs in the non-shared approach.)

This would be relatively easy to solve with bi-directional notifiers, i.e. KVM
notifies IOMMUFD when a vCPU faults in a page, and vice versa.
 
> - Reduced memory consumption:
>   Memory of one page table are saved.

I'm not convinced that memory consumption is all that interesting.  If a VM is
mapping the majority of memory into a device, then odds are good that the guest
is backed with at least 2MiB page, if not 1GiB pages, at which point the memory
overhead for pages tables is quite small, especially relative to the total amount
of memory overheads for such systems.

If a VM is mapping only a small subset of its memory into devices, then the IOMMU
page tables should be sparsely populated, i.e. won't consume much memory.

