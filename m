Return-Path: <kvm+bounces-28065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16DE8992ED9
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 16:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A1531C236DD
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 14:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73CC1D88DF;
	Mon,  7 Oct 2024 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="en9pM/JD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569371D799E
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310762; cv=none; b=Kcx938yTf2i2N7T6SQfvHUkyYLRXWO76FY0tE87ZgZqheeRacCTmkuKk6chpVYqg8YnAusgUtVModNSRN5VzzIlBUZwyif5XZF/rog934dxmthBDwGHcQAv1KuwWCuD+wRu4ih+52VJqd8EahpFKSHM7JEf39hUZL7/hpIhrUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310762; c=relaxed/simple;
	bh=fPpRhAkOlLyr7I5GWfCVLmcMUp2CHa8v4oEGbZ9nCQg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CNNwnyoEyPNY+IsNVqDkrUf6wrYSGs4Y143pSO0i4gz6yrdGdoY2PkN83UIG9a0HT1UhJENHM3P81MKHHSe5wuq/5kadmwskE6v5n80vWmgNdii21nrm6OjHL3Ke5KZ2FBY9xp951PGjy9bK+OK6T7Gf9x/9BGCioLKsa/nCbZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=en9pM/JD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728310759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kPk7t5vf7Zw0tZf27l+JYytji+SaN7OikNPmFvip+c=;
	b=en9pM/JDPcXzG01BLKoyi+Wl2d5bc1nxbMWCK3KwcVRb1cVJnYExwppt9NzvRMz57oAkxE
	dEpmtUZA6A7XzG9PdUCjKbnk06u1/faoxbbgiKujqn8hi60UpVsq3DVbMriPnyTSDRYxM2
	DyLQEevD93at8CKFlhUQG5H6EWPKcgc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-YcBOvX1-PxefTCj49MLtPQ-1; Mon, 07 Oct 2024 10:19:18 -0400
X-MC-Unique: YcBOvX1-PxefTCj49MLtPQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-834a9a3223aso64310139f.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 07:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728310757; x=1728915557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1kPk7t5vf7Zw0tZf27l+JYytji+SaN7OikNPmFvip+c=;
        b=d4YB/CNrsK3DzDRbvohrygHDkMhRp/23MhbBCOoOVVGV+zX1W1u379smMn6d0h9r3a
         lSt2xpMx2fmf61tS+NaftMH8jBW+KrBEHxDR1nkUe0SpgcTGd3+2JIcUywZTDbXyhUEv
         iGX+PV0ZLjMkOCEOPGW+FbpArd+uzRcjlDqOwv1rVPletUpAIk4tfQfobawtmZ3SgdiU
         zY3bwXl78TRXWLSmkkWPtOOyP2BJubGV3GMJy9+svTZJwhrz6AchCnaOW034Nqw+Uwm5
         5nOZyDiVNQFYJkduZgWS/y9F9EM6KTgtLvorVK85qNiTMQbvuiKiWQczU3IxEBSm7PX1
         6+vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW+0iKEDw245mc0BAEreBrDbuuC114OLSkhuLI3bGIw39QpFgAtuu19OOUtZFVdaiOIu0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw46ihhrErWIpaadFLXba8wOv88dgQ6ch8qtjPZ0VjLdRhkx8CB
	vpHPrvvjMpncWjy/zfhOa63RaFTRFOhNqisa39FfShqx6ZZnCmaUh8T6KcahJNk28jFhAQgTwgN
	8a5rSrEpoLo1bzhEN8qBP/NZ0/NJM24rs6ZkIXHtpELDttjSqCA==
X-Received: by 2002:a05:6e02:1fc8:b0:3a2:57d2:3489 with SMTP id e9e14a558f8ab-3a375be37d2mr28439585ab.3.1728310757364;
        Mon, 07 Oct 2024 07:19:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLWUg4d6eCvTKO1CP5bCnvIo2LY6WKj6iaBq4rEUA4pzdXrjH5RxquxJO/p3ji7vOzKVrjxQ==
X-Received: by 2002:a05:6e02:1fc8:b0:3a2:57d2:3489 with SMTP id e9e14a558f8ab-3a375be37d2mr28439335ab.3.1728310756968;
        Mon, 07 Oct 2024 07:19:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db71114d91sm1080564173.130.2024.10.07.07.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 07:19:16 -0700 (PDT)
Date: Mon, 7 Oct 2024 08:19:13 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Message-ID: <20241007081913.74b3deed.alex.williamson@redhat.com>
In-Reply-To: <20241006102722.3991-1-ankita@nvidia.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 6 Oct 2024 10:27:19 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's recently introduced Grace Blackwell (GB) Superchip in
> continuation with the Grace Hopper (GH) superchip that provides a
> cache coherent access to CPU and GPU to each other's memory with
> an internal proprietary chip-to-chip (C2C) cache coherent interconnect.
> The in-tree nvgrace-gpu driver manages the GH devices. The intention
> is to extend the support to the new Grace Blackwell boards.

Where do we stand on QEMU enablement of GH, or the GB support here?
IIRC, the nvgrace-gpu variant driver was initially proposed with QEMU
being the means through which the community could make use of this
driver, but there seem to be a number of pieces missing for that
support.  Thanks,

Alex

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
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
> Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]
> 
> Applied over next-20241003.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> 
> Ankit Agrawal (3):
>   vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
>     resmem
>   vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
>   vfio/nvgrace-gpu: Check the HBM training and C2C link status
> 
>  drivers/vfio/pci/nvgrace-gpu/main.c | 115 ++++++++++++++++++++++++++--
>  1 file changed, 107 insertions(+), 8 deletions(-)
> 


