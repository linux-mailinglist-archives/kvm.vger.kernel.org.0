Return-Path: <kvm+bounces-5833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964CB8272FB
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29551282E17
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB3F524C7;
	Mon,  8 Jan 2024 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="EIAl8B2B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7751C47
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-50e4e36c09cso134117e87.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 07:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1704727505; x=1705332305; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJ3EIRKSn5X0NGN+Lowl9P7K2Ny+tJ4mGNydRmUvWrU=;
        b=EIAl8B2B0plV+Fd4CRAObep5/NzHmfzHghjvMvOOv5g3NFWGHvyqE1/8mPM6nCD3P+
         1U0inDAvFfqky7fRmiQ6t5rHCZa/ufGtCl0km5FodIYqbSnNitPHdWBxeSiSAf9OCS7a
         8W6iBx5uYdWowVS5mbjky2Aif2BtM9CTNExCg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704727505; x=1705332305;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJ3EIRKSn5X0NGN+Lowl9P7K2Ny+tJ4mGNydRmUvWrU=;
        b=CWdiAXihHKu2O153NLFI5U1dDARiCtG7TrAN3jOWcdS9GvZm82KoVnFW3cjVnc0V54
         1IUecFyLM3AbM4tprRNch4y82kxcairt8ZbZmqSNZ6ASZ+crfnnGCJdBr7N4EnEH4Tty
         b9NF9S5sdpU42njvFnAl64HaHRUu0aEK1ZS/q/GicdO3WEK5ogGqubhzFGqGCzo8ob1b
         h++Ub7zxf3wig9SoMmiiG52L1LA07+XGEGiv4fiWvsW3zBl2PCtRTKm0G56SpINFxU46
         6Hcbhy+B4uaIOwHctAodEM4FGYT+hriF4r2TU9HyapELVuL/CRTgW9TpKKfVl6cv0Ye/
         s0bA==
X-Gm-Message-State: AOJu0YyF3P3fxh3t/RURs/+PbGvPLmBOs2pQ0AWWV+JaQ2EN9kWmIbdY
	OW2VdXPcsn8xk+qFDb6+0eeIVA2vfVAP2w==
X-Google-Smtp-Source: AGHT+IFEZmb84ZsP7WndigoWhVfLIJmu7Z3cqw2RTpxB6wKa9AmlpaVhv3E1Czp2+q+7kFveVkRA7Q==
X-Received: by 2002:a05:6512:2212:b0:50e:9e95:5290 with SMTP id h18-20020a056512221200b0050e9e955290mr3890677lfu.1.1704727505082;
        Mon, 08 Jan 2024 07:25:05 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id i16-20020a5d5230000000b00333404e9935sm8075814wra.54.2024.01.08.07.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 07:25:04 -0800 (PST)
Date: Mon, 8 Jan 2024 16:25:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, wanpengli@tencent.com,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kraxel@redhat.com, maz@kernel.org,
	joro@8bytes.org, zzyiwei@google.com, yuzenghui@huawei.com,
	olvaffe@gmail.com, kevin.tian@intel.com, suzuki.poulose@arm.com,
	alex.williamson@redhat.com, yongwei.ma@intel.com,
	zhiyuan.lv@intel.com, gurchetansingh@chromium.org,
	jmattson@google.com, zhenyu.z.wang@intel.com, seanjc@google.com,
	ankita@nvidia.com, oliver.upton@linux.dev, james.morse@arm.com,
	pbonzini@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 0/4] KVM: Honor guest memory types for virtio GPU devices
Message-ID: <ZZwTzsZqx-XSTKma@phenom.ffwll.local>
Mail-Followup-To: Jason Gunthorpe <jgg@nvidia.com>,
	Yan Zhao <yan.y.zhao@intel.com>, wanpengli@tencent.com,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kraxel@redhat.com, maz@kernel.org,
	joro@8bytes.org, zzyiwei@google.com, yuzenghui@huawei.com,
	olvaffe@gmail.com, kevin.tian@intel.com, suzuki.poulose@arm.com,
	alex.williamson@redhat.com, yongwei.ma@intel.com,
	zhiyuan.lv@intel.com, gurchetansingh@chromium.org,
	jmattson@google.com, zhenyu.z.wang@intel.com, seanjc@google.com,
	ankita@nvidia.com, oliver.upton@linux.dev, james.morse@arm.com,
	pbonzini@redhat.com, vkuznets@redhat.com
References: <20240105091237.24577-1-yan.y.zhao@intel.com>
 <20240105195551.GE50406@nvidia.com>
 <ZZuQEQAVX28v7p9Z@yzhao56-desk.sh.intel.com>
 <20240108140250.GJ50406@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108140250.GJ50406@nvidia.com>
X-Operating-System: Linux phenom 6.5.0-4-amd64 

On Mon, Jan 08, 2024 at 10:02:50AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 08, 2024 at 02:02:57PM +0800, Yan Zhao wrote:
> > On Fri, Jan 05, 2024 at 03:55:51PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Jan 05, 2024 at 05:12:37PM +0800, Yan Zhao wrote:
> > > > This series allow user space to notify KVM of noncoherent DMA status so as
> > > > to let KVM honor guest memory types in specified memory slot ranges.
> > > > 
> > > > Motivation
> > > > ===
> > > > A virtio GPU device may want to configure GPU hardware to work in
> > > > noncoherent mode, i.e. some of its DMAs do not snoop CPU caches.
> > > 
> > > Does this mean some DMA reads do not snoop the caches or does it
> > > include DMA writes not synchronizing the caches too?
> > Both DMA reads and writes are not snooped.
> 
> Oh that sounds really dangerous.

So if this is an issue then we might already have a problem, because with
many devices it's entirely up to the device programming whether the i/o is
snooping or not. So the moment you pass such a device to a guest, whether
there's explicit support for non-coherent or not, you have a problem.

_If_ there is a fundamental problem. I'm not sure of that, because my
assumption was that at most the guest shoots itself and the data
corruption doesn't go any further the moment the hypervisor does the
dma/iommu unmapping.

Also, there's a pile of x86 devices where this very much applies, x86
being dma-coherent is not really the true ground story.

Cheers, Sima

> > > > This is generally for performance consideration.
> > > > In certain platform, GFX performance can improve 20+% with DMAs going to
> > > > noncoherent path.
> > > > 
> > > > This noncoherent DMA mode works in below sequence:
> > > > 1. Host backend driver programs hardware not to snoop memory of target
> > > >    DMA buffer.
> > > > 2. Host backend driver indicates guest frontend driver to program guest PAT
> > > >    to WC for target DMA buffer.
> > > > 3. Guest frontend driver writes to the DMA buffer without clflush stuffs.
> > > > 4. Hardware does noncoherent DMA to the target buffer.
> > > > 
> > > > In this noncoherent DMA mode, both guest and hardware regard a DMA buffer
> > > > as not cached. So, if KVM forces the effective memory type of this DMA
> > > > buffer to be WB, hardware DMA may read incorrect data and cause misc
> > > > failures.
> > > 
> > > I don't know all the details, but a big concern would be that the
> > > caches remain fully coherent with the underlying memory at any point
> > > where kvm decides to revoke the page from the VM.
> > Ah, you mean, for page migration, the content of the page may not be copied
> > correctly, right?
> 
> Not just migration. Any point where KVM revokes the page from the
> VM. Ie just tearing down the VM still has to make the cache coherent
> with physical or there may be problems.
>  
> > Currently in x86, we have 2 ways to let KVM honor guest memory types:
> > 1. through KVM memslot flag introduced in this series, for virtio GPUs, in
> >    memslot granularity.
> > 2. through increasing noncoherent dma count, as what's done in VFIO, for
> >    Intel GPU passthrough, for all guest memory.
> 
> And where does all this fixup the coherency problem?
> 
> > This page migration issue should not be the case for virtio GPU, as both host
> > and guest are synced to use the same memory type and actually the pages
> > are not anonymous pages.
> 
> The guest isn't required to do this so it can force the cache to
> become incoherent.
> 
> > > If you allow an incoherence of cache != physical then it opens a
> > > security attack where the observed content of memory can change when
> > > it should not.
> > 
> > In this case, will this security attack impact other guests?
> 
> It impacts the hypervisor potentially. It depends..
> 
> Jason

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

