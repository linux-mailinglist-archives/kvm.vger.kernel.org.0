Return-Path: <kvm+bounces-36277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF26A196C7
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64A41188DCA0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCC4215074;
	Wed, 22 Jan 2025 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYVa0uMO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4702A215048
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737564188; cv=none; b=Z2P/fbB8rq7YlTi2Q9IkIuy0EXE9soRAVSnkldFe4Bdugncc2AjqW8sRlwbndNYfzg6DruiQjBt6HycAy/kZ8qJ8eGNF88dSrATzdNxbRYvsZd3vzX0vsLpJh2Rv2uNGCTHltqAfjUFaGnlEELYm8gHg3qZyvPE6wGElorhRsWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737564188; c=relaxed/simple;
	bh=yWi4FXbD11PvYaHHMRAHbvxxV68FSQtTNOXx5gSMVHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFssOeur2t2XnOr4FZGR1TUjPS7OHyYnTfQTU7G4gecca6ycopuQJYqxmwxPcGTv0QROmgxL2RKz3xHyubuZo4i20AYgafHx9Bnhoy7xmkc3rVC3+ScR/HnExXvVnC5aLOg75levg1NAdBIFKXBTk+S7DK3Qa/gQFD/xvnjaYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LYVa0uMO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737564186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3y0fMZSE7a+ty4qcm/cQWGtpuEjSKpLOhWLAcuXU2f0=;
	b=LYVa0uMOeruWKGr4VIHW0uEvmLut/1P554HlzZCAHeyAuXN1C7lF+o62ABTf+atih1XTT3
	CE9VHuou5FXdV6Z74UoaDeVIna55cEWtUw6MXom9KeuBEtgF42fwQTJFAy16xehKWD4Zsq
	BGrygCuNPkJ4/BA+BkEVqY17HF/yHzc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-x6PHo_mnOeCMQS7U0D9KOg-1; Wed, 22 Jan 2025 11:43:04 -0500
X-MC-Unique: x6PHo_mnOeCMQS7U0D9KOg-1
X-Mimecast-MFC-AGG-ID: x6PHo_mnOeCMQS7U0D9KOg
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4675749a982so121065811cf.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:43:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737564184; x=1738168984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3y0fMZSE7a+ty4qcm/cQWGtpuEjSKpLOhWLAcuXU2f0=;
        b=szpktO4Ccyan1AHuPakudwVmrbIeo0MlejZfvFcQVapg6NOLP5ukSjfsQrLI4ryOxU
         M0uFkHzG0Q2he19m3Oijk+ebpePI5SZsuFc8Z2vPItbiiJZ/YH56uVob5H8vLeWohmt+
         OWJBsfZkJeZV4K6PIH3DyByus8YnLlFe9kWcEjTScFdLHwQQu+RdBdlvD6VeLIb7rxZi
         XnRk0gC7jpYt9l4Td2xj1t4luSgXuFFQh7HZXD+21gOB5pe6ejRzhf/jZmmmeph2M0n7
         FyUDWYTrOxElrYXdHmkRH/H6EbESAN656VB8fkqGZodtpsC+SrCPEVF+Bz3rK+aResql
         xtqg==
X-Forwarded-Encrypted: i=1; AJvYcCVWVixh941SGJTdEZk+qswon9XHWNAsTiCx6UG1f6eZT4fm4XFM7mPSupq3l4zZL14BdaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjOSUPiZU3O69o/l/a1XLGwD0wQCg2KfPtNwirjDo2qWtsiHN3
	bes2QwXoqn5KaQDv8jMfG3FsNbvBQsFkoB8DURpBFy9sLRX4qNBa5y1wRovnR3tI1z6IhpAZnp7
	xGfKMuLercKJXhEZtwFnQ3WwLytkz0C7bp3MJulUrwE+lCSZr6w==
X-Gm-Gg: ASbGncubsKqbFAwuo2/i6MH+62KXrzOO/xypzXc1J6/1MrZmwfhQ+LrsPK3t6QONetw
	4el6p0ddxuZZYgKVjaCLIv1RuiL6aXNC9pAFj2jxc1266ekwgGhd7lhVGH0EA5B+hge3JsTwoEk
	yOChY9J5gv7ZjV9hvyVMvHPNT1TCRRT2/Gx/eCzuwnhHCTHTtOfVgLreEu/p0pvx8tmbN6wiG7a
	QCipp7PJiZkMDFW96vwwmHKjJy0Xzlw0EHLcoDvvKOek8qGfffXBa9CWPOQmUkNcw/nEF8CZ9lp
	Ao7m0hG2PXgnsQmmjiVw3zhw5BqbxSE=
X-Received: by 2002:ac8:7f83:0:b0:467:681c:425f with SMTP id d75a77b69052e-46e12a1e89amr335229501cf.4.1737564184264;
        Wed, 22 Jan 2025 08:43:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETxltspJm2hV7oT91UaMx+gaN/Hy/EpGHdI43Wk+riEdrbGMvExnVUyAvjtxygRe6Mo7vWDQ==
X-Received: by 2002:ac8:7f83:0:b0:467:681c:425f with SMTP id d75a77b69052e-46e12a1e89amr335229041cf.4.1737564183924;
        Wed, 22 Jan 2025 08:43:03 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e102ec205sm65385351cf.11.2025.01.22.08.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 08:43:03 -0800 (PST)
Date: Wed, 22 Jan 2025 11:43:01 -0500
From: Peter Xu <peterx@redhat.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5EgFaWIyjIiOZnv@x1n>
References: <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n>
 <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050>

On Wed, Jan 22, 2025 at 05:41:31PM +0800, Xu Yilun wrote:
> On Wed, Jan 22, 2025 at 03:30:05PM +1100, Alexey Kardashevskiy wrote:
> > 
> > 
> > On 22/1/25 02:18, Peter Xu wrote:
> > > On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> > > > On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > > > > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > > > > is the private MMIO would also create a memory region with
> > > > > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > > > > listener.
> > > > > > 
> > > > > > My current working approach is to leave it as is in QEMU and VFIO.
> > > > > 
> > > > > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> > > > 
> > > > The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> > > > normal assigned MMIO is always set ram=true,
> > > > 
> > > > void memory_region_init_ram_device_ptr(MemoryRegion *mr,
> > > >                                         Object *owner,
> > > >                                         const char *name,
> > > >                                         uint64_t size,
> > > >                                         void *ptr)

[1]

> > > > {
> > > >      memory_region_init(mr, owner, name, size);
> > > >      mr->ram = true;
> > > > 
> > > > 
> > > > So I don't think ram=true is a problem here.
> > > 
> > > I see.  If there's always a host pointer then it looks valid.  So it means
> > > the device private MMIOs are always mappable since the start?
> > 
> > Yes. VFIO owns the mapping and does not treat shared/private MMIO any
> > different at the moment. Thanks,
> 
> mm.. I'm actually expecting private MMIO not have a host pointer, just
> as private memory do.
> 
> But I'm not sure why having host pointer correlates mr->ram == true.

If there is no host pointer, what would you pass into "ptr" as referenced
at [1] above when creating the private MMIO memory region?

OTOH, IIUC guest private memory finally can also have a host pointer (aka,
mmap()-able), it's just that even if it exists, accessing it may crash QEMU
if it's private.

Thanks,

-- 
Peter Xu


