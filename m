Return-Path: <kvm+bounces-36580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D29A1BE44
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 23:05:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8477188E81C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 22:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872EB1EE028;
	Fri, 24 Jan 2025 22:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRvSB8v9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D991E9913
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 22:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737756310; cv=none; b=qeqEAjPz/cyo6yRKte2uXTOcTnhdbKK+SAa0odSjoyzyGUJBRWLrLpvhuc8RbuodC4TyVL28lIy4AYedQWAjIF7Q8KBr3nTNZCRnq/8uvNp83BMgAm6vSlo+qxXkmSRs0cqMEnA+sY5a/G56GtJRGNojtaoFG+x//oC46jDImqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737756310; c=relaxed/simple;
	bh=iaP/+3er8DGfdIcFksPz1XPEa/DXz0n7J2i6z2jhHD0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVCRFW6ATm28OmPBkgEgrC0/o5/fkl+h2NMVbFGi/IDC8DnEyirJKDmegy10RjeQc2M91o+eXJgLeQbkUXzSaUdUsfMdegVUJjXK1tqSeUSyzQIXzy9A3urlFX/6Ecqh8Pp5bBJmgtZfHRWvzJ9EV1spBDGIQ1MGRUv0nNXpjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRvSB8v9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737756307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BzPE5HLtsNThgWwwLQzJK1+f2P0M9LXMVhz4OZk1S9A=;
	b=VRvSB8v9RS3FHnevYEWteNcETd5XepBIA06wHKccPHBQOAmbpXFuZwow/t3WtK0uh4Lwl6
	MRmTM31V2P2eE0GsxdU3CB+yACrhcQFEY4DKGzgxrYrCMA/S0ofZJOeAQ3acEC5HAmDj9F
	nEtOEq5bvFa/Apl6dqxOJfoR6kuG1AE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-q6JkEvBEOm-aaXt_NMFlSA-1; Fri, 24 Jan 2025 17:05:06 -0500
X-MC-Unique: q6JkEvBEOm-aaXt_NMFlSA-1
X-Mimecast-MFC-AGG-ID: q6JkEvBEOm-aaXt_NMFlSA
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-844d68dbe60so28671139f.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 14:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737756306; x=1738361106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzPE5HLtsNThgWwwLQzJK1+f2P0M9LXMVhz4OZk1S9A=;
        b=NGtDAOWorGq2c4JKRIPsKDaQgzdOZwlboDXfKYnVFRL8cPA37rdNlngcwpwCWMDCeC
         kzyW2j9rODMmKeFbWnO4X6LJZDTJ5q/ztHKd0YFT/pDBiQw/oh+nn3cBkRbyElLl+dv8
         ZUYCOZT7s5DBM85P5dR8bf0A6zvIZeuSMQ6LzXdadwEothy2WTE5KhFoY0/J+UkueJvl
         owA92rWUWriqRnjA9trVEXBmESZV2irY8lFmxSkwhTKw638qRgoxKSZI6hUdbB306WI5
         QdYVRh1uU1qSEMBoDjNIC2wBb+FLYFwI0vfIvk4SE+ab4iqQZ4R3SNGHvB1l5EA5ejH0
         XuSg==
X-Forwarded-Encrypted: i=1; AJvYcCWLG048uR9nPJbw7GAKfRSfjCVqFVcjMLc/QgpHd9PEoSCrU+t2dhT9g0wiz+XVBaWILLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwq2dKHRCHOnBudtmvRFDq1fKu7sp3BcR6xGqf0InN8jEN8a3R
	0jTYrtHNwwtm/5ZgoikuNlB1D8PbMO9tfUE67kdpsy9SUNc+/hInVKjvjttck6NNHEZXvOy75Kp
	njGMiNo1uH30khTTo3UZ0ajIQlPi5IR010Z68oCTCGqP24KjDDg==
X-Gm-Gg: ASbGncuRTfSgN0ClsmT8JaHRxx+rd+8GuWoQr8jJDXxdRuJ76Fq+o2A8QXimwcCom9j
	p925bDvSUtFx4zH/duG1o2UXFqLoFscDsGCc+tqLFmwZqWLx5rFmb0Vv/ZcKSt4L5cMn5FKYwT1
	jsCZUbnRB/8gVTmLUjZLpFH6t6efTz9h467VK7qC+E25uwpF1KGvLLP9VU92caaEOheyqk+NEzn
	o8orRXp75O8qoYH6bnlilOHQjrWwxvBUyGpAIAR06eVyTMakTdI//zS6Er0f0+IxGGoNkTeBM29
	1rOlimNt
X-Received: by 2002:a92:cdaf:0:b0:3cb:f2e6:55a6 with SMTP id e9e14a558f8ab-3cfb1273e5dmr33819875ab.0.1737756305747;
        Fri, 24 Jan 2025 14:05:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5w9xrS5PTSDNP1aKKfYLET4Qdwk3FlXV2mw2SWK96tUHSAN0wHwBeYR/FM3EsAkg9f8obow==
X-Received: by 2002:a92:cdaf:0:b0:3cb:f2e6:55a6 with SMTP id e9e14a558f8ab-3cfb1273e5dmr33819655ab.0.1737756305236;
        Fri, 24 Jan 2025 14:05:05 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da4ba29sm888534173.70.2025.01.24.14.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 14:05:04 -0800 (PST)
Date: Fri, 24 Jan 2025 15:05:03 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <kjaju@nvidia.com>, <udhoke@nvidia.com>,
 <dnigam@nvidia.com>, <nandinid@nvidia.com>, <anuaggarwal@nvidia.com>,
 <mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Message-ID: <20250124150503.24a39cea.alex.williamson@redhat.com>
In-Reply-To: <20250124183102.3976-1-ankita@nvidia.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jan 2025 18:30:58 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's recently introduced Grace Blackwell (GB) Superchip in
> continuation with the Grace Hopper (GH) superchip that provides a
> cache coherent access to CPU and GPU to each other's memory with
> an internal proprietary chip-to-chip (C2C) cache coherent interconnect.
> The in-tree nvgrace-gpu driver manages the GH devices. The intention
> is to extend the support to the new Grace Blackwell boards.
> 
> There is a HW defect on GH to support the Multi-Instance GPU (MIG)
> feature [1] that necessiated the presence of a 1G carved out from
> the device memory and mapped uncached. The 1G region is shown as a
> fake BAR (comprising region 2 and 3) to workaround the issue.
> 
> The GB systems differ from GH systems in the following aspects.
> 1. The aforementioned HW defect is fixed on GB systems.
> 2. There is a usable BAR1 (region 2 and 3) on GB systems for the
> GPUdirect RDMA feature [2].
> 
> This patch series accommodate those GB changes by showing the real
> physical device BAR1 (region2 and 3) to the VM instead of the fake
> one. This takes care of both the differences.
> 
> The presence of the fix for the HW defect is communicated by the
> firmware through a DVSEC PCI config register. The module reads
> this to take a different codepath on GB vs GH.
> 
> To improve system bootup time, HBM training is moved out of UEFI
> in GB system. Poll for the register indicating the training state.
> Also check the C2C link status if it is ready. Fail the probe if
> either fails.
> 
> Applied over next-20241220 and the required KVM patch (under review
> on the mailing list) to map the GPU device memory as cacheable [3].
> Tested on the Grace Blackwell platform by booting up VM, loading
> NVIDIA module [4] and running nvidia-smi in the VM.
> 
> To run CUDA workloads, there is a dependency on the IOMMUFD and the
> Nested Page Table patches being worked on separately by Nicolin Chen.
> (nicolinc@nvidia.com). NVIDIA has provided git repositories which
> includes all the requisite kernel [5] and Qemu [6] patches in case
> one wants to try.
> 
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
> Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]
> Link: https://lore.kernel.org/all/20241118131958.4609-2-ankita@nvidia.com/ [3]
> Link: https://github.com/NVIDIA/open-gpu-kernel-modules [4]
> Link: https://github.com/NVIDIA/NV-Kernels/tree/6.8_ghvirt [5]
> Link: https://github.com/NVIDIA/QEMU/tree/6.8_ghvirt_iommufd_vcmdq [6]
> 
> v5 -> v6

LGTM.  I'll give others who have reviewed this a short opportunity to
take a final look.  We're already in the merge window but I think we're
just wrapping up some loose ends and I don't see any benefit to holding
it back, so pending comments from others, I'll plan to include it early
next week.  Thanks,

Alex

> * Updated the code based on Alex Williamson's suggestion to move the
>   device id enablement to a new patch and using KBUILD_MODNAME
>   in place of "vfio-pci"
> 
> v4 -> v5
> * Added code to enable the BAR0 region as per Alex Williamson's suggestion.
> * Updated code based on Kevin Tian's suggestion to replace the variable
>   with the semantic representing the presence of MIG bug. Also reorg the
>   code to return early for blackwell without any resmem processing.
> * Code comments updates.
> 
> v3 -> v4
> * Added code to enable and restore device memory regions before reading
>   BAR0 registers as per Alex Williamson's suggestion.
> 
> v2 -> v3
> * Incorporated Alex Williamson's suggestion to simplify patch 2/3.
> * Updated the code in 3/3 to use time_after() and other miscellaneous
>   suggestions from Alex Williamson.
> 
> v1 -> v2
> * Rebased to next-20241220.
> 
> v5:
> Link: https://lore.kernel.org/all/20250123174854.3338-1-ankita@nvidia.com/
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> 
> Ankit Agrawal (4):
>   vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
>     resmem
>   vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
>   vfio/nvgrace-gpu: Check the HBM training and C2C link status
>   vfio/nvgrace-gpu: Add GB200 SKU to the devid table
> 
>  drivers/vfio/pci/nvgrace-gpu/main.c | 169 ++++++++++++++++++++++++----
>  1 file changed, 147 insertions(+), 22 deletions(-)
> 


