Return-Path: <kvm+bounces-11079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C358D872ADD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520B428B4FA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 23:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF7012E1E0;
	Tue,  5 Mar 2024 23:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzNiGEzu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B31612D779
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 23:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709680405; cv=none; b=EJ6vU/f2Yk6hYg5/oV4ibdC3xoFFMfUswMMXByqQAEvaE0AqMdqJxHFjqafYF+RWuKqST0aOMa3TB3BoiXN/o5oOVor4T/YkG7zWGy7xIQfmnlG81lVh7lQ5Hwu8iRlwuDnd4uyV3QmOzxpVTAKv9KvXpICQ5wPlqa5rovlCB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709680405; c=relaxed/simple;
	bh=cLhW8+AnPXF+x0lQb/dnv/o/Sf8sk08keva7j4YfP4M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBAkwvHl71nW8RNlBswWA9aJcUY/1hAaAjG5gneQbGQATTJr/nFWliRtGCX4kCEelYXW9IsZGD+D4iubUZnH4HT2BunumVAXDEg+ACAH51JuHtBvg89CLY7D0ngP5X0j4/cN1SpHe38hG+1YEer8SrFf46NEal8AV2cMltfshCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzNiGEzu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709680402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A+hfIOAS3CirjTR2TDkQQzoNgn7WBbQgBJrbYh4eZAU=;
	b=IzNiGEzuKmOopKbyTc143xoAaOL9oxCEQQeYzeGnDZFm1oSgO6pAqhTfGqQKFOTavjvi6N
	4a9EoguIXR4bjJ2hlv3BmiFT/6BSOPqqyOtMMqSZkBHSGLC/Qn1ySoPyg10RLkyTsiWoZa
	sWFiZKrVyKgW7wh1g3TPtDDiO/4ByEk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-jSg-f-dhNkOi5jENeP8MGA-1; Tue, 05 Mar 2024 18:13:21 -0500
X-MC-Unique: jSg-f-dhNkOi5jENeP8MGA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3650bfcb2bfso2212655ab.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 15:13:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709680400; x=1710285200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+hfIOAS3CirjTR2TDkQQzoNgn7WBbQgBJrbYh4eZAU=;
        b=dno7ld/fVLNCbiLFi9s5iAjZTc9q+EnPDmmTU9YMvMkercsF7aetEmdQJK99CFSZrq
         nsuznnERgoFskvpO7zRopqaP18Sl77P66rtGvUgx6mnZDtzHR0xvc0lHgLZH2WL1Mqj8
         jcTAGxJQyeBWFBUs/OAQcko1gjkUVHsqBKbnUPyFQO9olUYfKMb6pC67ktUSHWckZxo9
         pdRdT5GM0AlkiOUSr4tLIbW0qFfOWpxws4CgaC8t2xeUjhOPh/8UXadD+N3E/wMmMCF5
         rhEJ4bs42M66lF3pi0QFXC508edfW/2m/Nww4Pik0iNJnb/Aaq8QL/m3wpYuSt02Nklx
         LbuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5KoZ1bAmnFCzKwxXwt1U3sGc0EJATjfYuA+JAkkwipoBXtuJp58Nkpww4rDjfhMLxPMGEZMt+JZ3QBrmwCHk4mwur
X-Gm-Message-State: AOJu0YzPHmFnRtwQa+0oafesnQlj4RGWHE0iZB/8QKmyTXC2OG63FVhV
	rRlbyZYPz7VaxjhwaZt6ftDY13aL3vr+QsbLEi5VRg4p1f0tr8KmFkVIOezHz/sicmNQysuBm1S
	s6CKxqR1d2IX449gC82e7jOSvYi+FwsYlDsyIbOQPCfrQgQ2drQ==
X-Received: by 2002:a05:6e02:20ea:b0:361:933c:3b04 with SMTP id q10-20020a056e0220ea00b00361933c3b04mr3503351ilv.7.1709680400442;
        Tue, 05 Mar 2024 15:13:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2nNbJIhVFGias1huSm3/yhiAERbq5Ckc+7Kk03yYzrJLJ0gi6XO6zCth4naFRvHkOeLYHrw==
X-Received: by 2002:a05:6e02:20ea:b0:361:933c:3b04 with SMTP id q10-20020a056e0220ea00b00361933c3b04mr3503335ilv.7.1709680400167;
        Tue, 05 Mar 2024 15:13:20 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id c26-20020a02c9da000000b00474b48a629csm3084467jap.46.2024.03.05.15.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 15:13:18 -0800 (PST)
Date: Tue, 5 Mar 2024 16:12:56 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <rrameshbabu@nvidia.com>, <zhiw@nvidia.com>, <anuaggarwal@nvidia.com>,
 <mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/1] vfio/nvgrace-gpu: Convey kvm to map device
 memory region as noncached
Message-ID: <20240305161256.09bda6c4.alex.williamson@redhat.com>
In-Reply-To: <20240229193934.2417-1-ankita@nvidia.com>
References: <20240229193934.2417-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Feb 2024 19:39:34 +0000
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
> NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
> NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE
> 
> Recently a change was added that modifies this default behavior and
> make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
> VM_ALLOW_ANY_UNCACHED is set [4]. Setting S2 as MT_S2_FWB_NORMAL_NC
> provides the desired behavior (uncached, unaligned access) for resmem.
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
> Link: https://lore.kernel.org/all/20240224150546.368-1-ankita@nvidia.com/ [4]
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Cc: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Applied to vfio next branch for v6.9.

Oliver, FYI I did merge the branch you provided in [1] for this, thanks
for the foresight in providing that.

Alex

[1]https://lore.kernel.org/all/170899100569.1405597.5047894183843333522.b4-ty@linux.dev/

> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 25814006352d..a7fd018aa548 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -160,8 +160,17 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  	 * The carved out region of the device memory needs the NORMAL_NC
>  	 * property. Communicate as such to the hypervisor.
>  	 */
> -	if (index == RESMEM_REGION_INDEX)
> +	if (index == RESMEM_REGION_INDEX) {
> +		/*
> +		 * The nvgrace-gpu module has no issues with uncontained
> +		 * failures on NORMAL_NC accesses. VM_ALLOW_ANY_UNCACHED is
> +		 * set to communicate to the KVM to S2 map as NORMAL_NC.
> +		 * This opens up guest usage of NORMAL_NC for this mapping.
> +		 */
> +		vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
> +
>  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	}
>  
>  	/*
>  	 * Perform a PFN map to the memory and back the device BAR by the


