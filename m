Return-Path: <kvm+bounces-10517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3CE86CE86
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91307B29584
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D32470AC3;
	Thu, 29 Feb 2024 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g93ljgmK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B76CC11
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222206; cv=none; b=Mb+p/vM1STHvFA9Qq5losGbzUd04lDFJtN77+BGit/gHq/lMODeVea9dMXQn3qrca5wYZ8N5ayrf5/bPtvtIZjq1Y7MSlUfggnEm/4j5EZqQ2oDcijhsk7vCRD9Nn3k8LToHfeEvy6MMdtPUE58SgaFdxjbCvk/XAI5kGNInUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222206; c=relaxed/simple;
	bh=P2TMqG7h7dnUJpKrrocNNNzpbY0+qjivekQDfKhl2bM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVDjn9aQAij/Lpzr+eGtBgbpTo8W4hk4cyojUct3qEUV2AkKX+0Zhg9yc7xRR9Zd9elNFfLG4MHsMUYE4I1bop+MzLfYsJIgfMV/J1kEjFiZQF/AmYgoAImfcJV8I0Rwq61dQiiMtXz1+kP32P676sVVCMzCIE4y/5U24nOFiXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g93ljgmK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709222203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NK1oIanmqTW8WZH0kLEYVDI/xueTaYHkdWqNEI0DyFk=;
	b=g93ljgmKSJuEWmLCARp7p8hPt+S7A2OwH8PTChSLfjRjPI1Dx2fRANQJIKq53AOTe1thTi
	CJeOlJVpWejhtNU/EmA6lFtB8FlqVJFpYOVSkkW/KWjprUTxSqvwgDI7cmVfY4Uy3ShYSt
	AZy1IcM8NFYsQScW2U5SDvk9MgwwBuU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-UWmpCbM1MNmO-avh_Ezd_Q-1; Thu, 29 Feb 2024 10:56:42 -0500
X-MC-Unique: UWmpCbM1MNmO-avh_Ezd_Q-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c7f57fa5eeso96100439f.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 07:56:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709222201; x=1709827001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NK1oIanmqTW8WZH0kLEYVDI/xueTaYHkdWqNEI0DyFk=;
        b=wJ7gCl3ujqO1Fb0ZntRxsOFwP0ALJVyxxChSqa8I3aHoF4//dIMnCoSCN2GfTvSzKc
         tImXCaQaC0LX/GwpRa+LIxWPcGw2gaTM31U5O3hZN/T4O0gJOBQMQnK1TXm+MKcejB6+
         Oxxq9xUHWh2tpy8BKas16TmgpnigyWArfnLfTfqQng+JYsSXKDRNyEGWRLmT3AoeRyfv
         p4d/ovrrJODmQ7x/7cY0261Dr4l68GUI5o8nKznEMtmwHQSZMyPH5CV6w+JUkhtAPe9t
         0sgTHIasnnFm3yd5YrJWinJINr/3Cgme/Vg1v/PdpY/Ap1k42RnXtNnzK8Sj5wOqPAds
         aeKA==
X-Forwarded-Encrypted: i=1; AJvYcCUeQm8pv4p65Mil8wxS1bjqeffBctSewg0JSryfhPWqJ/LiqWAGf7d6RwFLghufHQMVuIm5IcfR9D8Cdc4wQSkHPi9s
X-Gm-Message-State: AOJu0YxH4MydAK1p3pdw3W5banYDTsyAJAgTK1IZmzdJwq7bvfgyLMQB
	zfyNo93pMAK+JXmYVEH91rO7JY11QV/DZB8iscDk7PnXUWNL1s1g+FfG7zCe55I6562AvwqQyFf
	dht+w3UyPklGAQ+CanNTnDaw1URmlMFO+3eVywJZz48UZEa94TA==
X-Received: by 2002:a05:6602:641d:b0:7c7:d3c6:e195 with SMTP id gn29-20020a056602641d00b007c7d3c6e195mr3443320iob.1.1709222201504;
        Thu, 29 Feb 2024 07:56:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFS3pyDQfw+9kwU2WI8G5o84elkM6/6Ot566Bp3UBg2or4p9T85U4IZrIMXeiAPk8508EZT7Q==
X-Received: by 2002:a05:6602:641d:b0:7c7:d3c6:e195 with SMTP id gn29-20020a056602641d00b007c7d3c6e195mr3443292iob.1.1709222201221;
        Thu, 29 Feb 2024 07:56:41 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id j13-20020a02a68d000000b00474420a484esm364815jam.98.2024.02.29.07.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 07:56:40 -0800 (PST)
Date: Thu, 29 Feb 2024 08:56:39 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <rrameshbabu@nvidia.com>, <zhiw@nvidia.com>, <anuaggarwal@nvidia.com>,
 <mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: Convey kvm that the device is
 wc safe
Message-ID: <20240229085639.484b920c.alex.williamson@redhat.com>
In-Reply-To: <20240228194801.2299-1-ankita@nvidia.com>
References: <20240228194801.2299-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2024 19:48:01 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
> used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
> cache coherent interconnect and is present in the system physical
> address space. The device memory is split into two regions - termed
> as usemem and resmem - in the system physical address space,
> with each region mapped and exposed to the VM as a separate fake
> device BAR [1].
> 
> Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
> there is a requirement - as a workaround - for the resmem BAR to
> display uncached memory characteristics. Based on [3], on system with
> FWB enabled such as Grace Hopper, the requisite properties
> (uncached, unaligned access) can be achieved through a VM mapping (S1)
> of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.
> 
> KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
> default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
> VM.
> 
> The following table summarizes the behavior for the various S1 and S2
> mapping combinations for systems with FWB enabled [3].
> S1           |  S2           | Result
> NORMAL_WB    |  NORMAL_NC    | NORMAL_NC
> NORMAL_WT    |  NORMAL_NC    | NORMAL_NC
> NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
> NORMAL_WB    |  DEVICE_nGnRE | DEVICE_nGnRE
> NORMAL_WT    |  DEVICE_nGnRE | DEVICE_nGnRE
> NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE
> 
> Recently a change was added that modifies this default behavior and
> make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
> VM_ALLOW_ANY_UNCACHED is set. Setting S2 as MT_S2_FWB_NORMAL_NC
> provides the desired behavior (uncached, unaligned access) for resmem.
> 
> Such setting is extended to the usemem as a middle-of-the-road
> setting to take it closer to the desired final system memory
> characteristics (cached, unaligned). This will eventually be
> fixed with the ongoing proposal [4].
> 
> To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
> no action taken on the MMIO mapping can trigger an uncontained
> failure. The Grace Hopper satisfies this requirement. So set
> the VM_ALLOW_ANY_UNCACHED flag in the VMA.
> 
> Applied over next-20240227.
> base-commit: 22ba90670a51
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
> Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
> Link: https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/ [4]
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Cc: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 25814006352d..5539c9057212 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -181,6 +181,24 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  
>  	vma->vm_pgoff = start_pfn;
>  
> +	/*
> +	 * The VM_ALLOW_ANY_UNCACHED VMA flag is implemented for ARM64,
> +	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
> +	 * rather than DEVICE_nGnRE, which allows guest mappings
> +	 * supporting write-combining attributes (WC). This also
> +	 * unlocks memory-like operations such as unaligned accesses.
> +	 * This setting suits the fake BARs as they are expected to
> +	 * demonstrate such properties within the guest.
> +	 *
> +	 * ARM does not architecturally guarantee this is safe, and indeed
> +	 * some MMIO regions like the GICv2 VCPU interface can trigger
> +	 * uncontained faults if Normal-NC is used. The nvgrace-gpu
> +	 * however is safe in that the platform guarantees that no
> +	 * action taken on the MMIO mapping can trigger an uncontained
> +	 * failure. Hence VM_ALLOW_ANY_UNCACHED is set in the VMA flags.
> +	 */
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
> +
>  	return 0;
>  }
>  

The commit log sort of covers it, but this comment doesn't seem to
cover why we're setting an uncached attribute to the usemem region
which we're specifically mapping as coherent... did we end up giving
this flag a really poor name if it's being used here to allow unaligned
access?  Thanks,

Alex


