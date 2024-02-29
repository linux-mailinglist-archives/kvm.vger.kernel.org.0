Return-Path: <kvm+bounces-10520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C59886CEBA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C99AF1F2667A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E1B14405C;
	Thu, 29 Feb 2024 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWLTvtLP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF30144046
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222844; cv=none; b=ij9BAWdHnYm7ZR8WAiUfm/nNQ54wLol0NiUALEHgQvPA2zTizSYh979ihdO+L/Dmiu8AG51Ne+79ra2ju6MrqnDAXfUS3yD7EkKYbsoRlWI9sA4ZgRAHaG2R6B4+HiqzIcCEmFJqer6Ftypb1udigpSQv6JtvzySopowuRxgom4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222844; c=relaxed/simple;
	bh=oJjVQZLvxekcGxdoGVMwciCbVERzfKt7cZaMwXpDveg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvlxiBm0XYFE0fROsWpi1afPq37mpffQeR+gdIPfsXuL0Oc9nemlJL7s+kNCiL9xnSZ6+m5iwrPMjkMlF00UFIVVVstxUDI87bglMt24B6AMUO+R17r942+EENuLZcJ3D/G3Ff0TngkmYTQJ23GXuicvL8CoSv93hm0eKoseXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWLTvtLP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709222841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8bQnZ9imU+nwZ//MA01KB7E1yvf5nk+3DJwyDxiwG0=;
	b=HWLTvtLPofIQzZRlU6ccYuPUvX+/5OiHXl9J/pwJc6si04xnrsQODnYVbeXkjSshMfJzx0
	tI6B0gqiZr0nky+t+1tBfRArKz3fsrGkd5ouhEIafDA97VkQn1XsvyjqU0gGMvgRKAbUem
	/hiSCPGHpoyZGBpBLNa5H4QEde46Yaw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-yAx9LS0RMPGGsNbtVl1dDw-1; Thu, 29 Feb 2024 11:07:19 -0500
X-MC-Unique: yAx9LS0RMPGGsNbtVl1dDw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3650bfcb2bfso8869475ab.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709222839; x=1709827639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8bQnZ9imU+nwZ//MA01KB7E1yvf5nk+3DJwyDxiwG0=;
        b=Rfz2p32BjQKni7tYCMB7aH3U6X94BfDO7s2MmIQbHj6kM9AHWv4soNYXzdFLqkwL9b
         MLN0ZYa0uVGp0ieRCSe1VOVKEIKtBfAb0CW2zAWv7ORCvZpvRihIs2R0AwRk02asW6fy
         khMBMVrTJoPoptXd9PG4ttD2v5by+DK3o9klLD685dlkXgBB2NcwM+fsXZUQgDnb0rVO
         7CY68BiNcvji/qJcvyoonBNKpL3O3RxtakzycsPNBpFMUgzXxziOsEzO/1v5WXmV5EIP
         I70JBuBW/5pygm8eDNHPQ98aOd83DmdZFHMKtlxPTTdXtAuaRLrRUMaGcGUMKB6MNxXI
         SMYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJEUAk89rCqxLEewINkWqES1WXowbBdPzRxBehXeoHYkNnsQME9TFqGOXF+JBHgJLIFJd2wsQghI5/uaEh6gtbNACp
X-Gm-Message-State: AOJu0YytJZnLSuN8mGVKTsu1IqbRSMW5hDD6WO/EyNzpX1is/53GFu1L
	t1noMc7Gn2BKoOQPEcZqz3JxvDf/9BYxkEpIES9TuJAFob7xd0yNF5TttBhwaGcMkHZAdd52c+J
	B+gPCLnYcYFHyEXhaODk8QqVAxZH/ZqBvPk6I2DXDRwq94toWDA==
X-Received: by 2002:a92:cda6:0:b0:365:30c7:8181 with SMTP id g6-20020a92cda6000000b0036530c78181mr1167387ild.1.1709222839074;
        Thu, 29 Feb 2024 08:07:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmKwLIRCBrsuk01+0F73reM+lx3n4TrjDC66AwrezJTHexhJYb09dOtzda1jogb/vbf65o4Q==
X-Received: by 2002:a92:cda6:0:b0:365:30c7:8181 with SMTP id g6-20020a92cda6000000b0036530c78181mr1167354ild.1.1709222838778;
        Thu, 29 Feb 2024 08:07:18 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id z60-20020a0293c2000000b0047423189e7dsm379875jah.113.2024.02.29.08.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 08:07:18 -0800 (PST)
Date: Thu, 29 Feb 2024 09:07:17 -0700
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
Message-ID: <20240229090717.67b9c2ca.alex.williamson@redhat.com>
In-Reply-To: <20240229085639.484b920c.alex.williamson@redhat.com>
References: <20240228194801.2299-1-ankita@nvidia.com>
	<20240229085639.484b920c.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Feb 2024 08:56:39 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 28 Feb 2024 19:48:01 +0000
> <ankita@nvidia.com> wrote:
> 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
> > used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
> > cache coherent interconnect and is present in the system physical
> > address space. The device memory is split into two regions - termed
> > as usemem and resmem - in the system physical address space,
> > with each region mapped and exposed to the VM as a separate fake
> > device BAR [1].
> > 
> > Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
> > there is a requirement - as a workaround - for the resmem BAR to
> > display uncached memory characteristics. Based on [3], on system with
> > FWB enabled such as Grace Hopper, the requisite properties
> > (uncached, unaligned access) can be achieved through a VM mapping (S1)
> > of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.
> > 
> > KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
> > default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
> > VM.
> > 
> > The following table summarizes the behavior for the various S1 and S2
> > mapping combinations for systems with FWB enabled [3].
> > S1           |  S2           | Result
> > NORMAL_WB    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_WT    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
> > NORMAL_WB    |  DEVICE_nGnRE | DEVICE_nGnRE
> > NORMAL_WT    |  DEVICE_nGnRE | DEVICE_nGnRE
> > NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE
> > 
> > Recently a change was added that modifies this default behavior and
> > make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
> > VM_ALLOW_ANY_UNCACHED is set. Setting S2 as MT_S2_FWB_NORMAL_NC
> > provides the desired behavior (uncached, unaligned access) for resmem.
> > 
> > Such setting is extended to the usemem as a middle-of-the-road
> > setting to take it closer to the desired final system memory
> > characteristics (cached, unaligned). This will eventually be
> > fixed with the ongoing proposal [4].
> > 
> > To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
> > no action taken on the MMIO mapping can trigger an uncontained
> > failure. The Grace Hopper satisfies this requirement. So set
> > the VM_ALLOW_ANY_UNCACHED flag in the VMA.
> > 
> > Applied over next-20240227.
> > base-commit: 22ba90670a51
> > 
> > Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
> > Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
> > Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
> > Link: https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/ [4]
> > 
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Vikram Sethi <vsethi@nvidia.com>
> > Cc: Zhi Wang <zhiw@nvidia.com>
> > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > ---
> >  drivers/vfio/pci/nvgrace-gpu/main.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> > index 25814006352d..5539c9057212 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> > @@ -181,6 +181,24 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
> >  
> >  	vma->vm_pgoff = start_pfn;
> >  
> > +	/*
> > +	 * The VM_ALLOW_ANY_UNCACHED VMA flag is implemented for ARM64,
> > +	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
> > +	 * rather than DEVICE_nGnRE, which allows guest mappings
> > +	 * supporting write-combining attributes (WC). This also
> > +	 * unlocks memory-like operations such as unaligned accesses.
> > +	 * This setting suits the fake BARs as they are expected to
> > +	 * demonstrate such properties within the guest.
> > +	 *
> > +	 * ARM does not architecturally guarantee this is safe, and indeed
> > +	 * some MMIO regions like the GICv2 VCPU interface can trigger
> > +	 * uncontained faults if Normal-NC is used. The nvgrace-gpu
> > +	 * however is safe in that the platform guarantees that no
> > +	 * action taken on the MMIO mapping can trigger an uncontained
> > +	 * failure. Hence VM_ALLOW_ANY_UNCACHED is set in the VMA flags.
> > +	 */
> > +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
> > +
> >  	return 0;
> >  }
> >    
> 
> The commit log sort of covers it, but this comment doesn't seem to
> cover why we're setting an uncached attribute to the usemem region
> which we're specifically mapping as coherent... did we end up giving
> this flag a really poor name if it's being used here to allow unaligned
> access?  Thanks,

Also, this is setting the vma flag *after* the call to
remap_pfn_range(), which seems quite sketchy.  Thanks,

Alex


