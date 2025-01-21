Return-Path: <kvm+bounces-36125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEC7A180F6
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EE8C1888D36
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BA51F426A;
	Tue, 21 Jan 2025 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H14gDJVX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD20327702
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737472708; cv=none; b=c6JOM+tj9+wNq8xt+m+iOw9jd1xgRqA5txs8nDiVTdHKux/EE4rVou9tDwlktz6TXrm1pIQ9UplnpzhqHTheJlslZTR5qV25XY4kZplQtfWMc/vozWWphtIpJoLxmntuujtDzZAdf6DAv+VTYxXMyjraTg8Z14IdWkje0ZF4rEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737472708; c=relaxed/simple;
	bh=LXHUO55R7lnHMUNPyRWx22voW7dKc9OiZa4tqcSMf7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ukr2CFjSKIOgJh+9vY+2XPKkBNASZS+dvj3GFHWaltkwABprvrLsW2eQaVHVPiv1DZB+1kwkpbasXiF2MkLwTskJtFgmfhcFTEHMID6Iy9j6R1fROo0B7oGcgAmes+YgjQ08tfjfxmZ6P7sDjPox1lTXHFNgeGPI5V5V9hbwjdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H14gDJVX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737472705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=09GfAX0PUsqH9rTv7k7skURbGxqO6nInp65k5nhUxV8=;
	b=H14gDJVXD4jhykF9ujgsaye5WPE4iC9jzYJrwJJggmffiv9uTjzTBsj8JD6MmtpB2E1pP8
	LYBgBbFaVZSxKjLnNJ5ZcARnO28o/Sc8eC5JfwoGo/rJkDbHEi5cOW/MyNL0je8Fe5+DZ6
	BMwtW4hXHBaB+qlMt+2/HLyDr71zDNw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-1wSOuCeSMAyxKEg8ApJgeA-1; Tue, 21 Jan 2025 10:18:23 -0500
X-MC-Unique: 1wSOuCeSMAyxKEg8ApJgeA-1
X-Mimecast-MFC-AGG-ID: 1wSOuCeSMAyxKEg8ApJgeA
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-467a4f0b53bso192604511cf.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737472703; x=1738077503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09GfAX0PUsqH9rTv7k7skURbGxqO6nInp65k5nhUxV8=;
        b=Ae/ldeqtKTQWZNpYHHjIpMRntr2SCQl8yjt1mXykplu8l+estrfAIMkHwGin71I8ux
         iUYPc35kNJNGBwuqWlhPg6UoCvTKfsgS3K9bNp7YBGOHcfHJjsF8lV8kbxW8XuXvt3r9
         H8SIEn82h4wUNRNg9NJyOlRbEvFLHZu/jGZPmL/5J1CjMsUX9+tawbbZlOGgeYexjvwn
         9RSmfu8ebSUq9ATk2AC2wAr/ukRs3F5KrcTtnzbOux9Bh6hTBxTY8zKGprSfeG8laC1U
         JKdilm0I+2Ui8AMLcX65qNXVN/N3tPzGJS5IBkqgQtARRre/cTv+PBHWckmOFQp+wbAA
         400w==
X-Forwarded-Encrypted: i=1; AJvYcCVNWiP9f99NUcESWkvrkoqvFP1CrI0Nne3DzWQRr6khgVZumRB1Qi6O5QHUitUPbfgi4Mo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxako/sFzyoAepsR8PyNvhC+7xdHLuwd/L4CI3wg5QNx7/474Ny
	RWjH+QGa03FQj3aLhsdTDCLUcheH5dKQJ0xMN3LC3EXzng2gNHY+ttLCv9glmOUaXS3rnvBKp+F
	a6tp04c7SPHiCMRIkwLOwkjUBmqkVmTzkAYBlSQeE5wKpOkQAuw==
X-Gm-Gg: ASbGnctBn5j4+o6f598ZdykFZ38X3M6aZCi1ZQMRMc+0ixk2svEF5WIefM/uIlusQaI
	dluVdEYNrot6mvbW2I1D1oqptZpgSUETv7JAEt87d7jaL4H+hCn4ZqrOzJ8EjKcoUgMe5mjbXzo
	gIFC6HGQ18ff9AfgHvdZahE6sbpvmbF/4al3v/AdNBvByHbseOQtm6jLpsURO9uFzc+eq8UIsN6
	o/Uj2flL3eSusbLfB+atCzBBIAMbhuhJ9LgoXWF16Z8YYF4gFWokz2G75tLqtyH3EZPbwh0AZG4
	Vv3qpgLN++R1Zi5S0hRxonrD6jOm3vU=
X-Received: by 2002:a05:622a:38b:b0:46c:7646:4a1e with SMTP id d75a77b69052e-46e12a62966mr286440831cf.13.1737472702841;
        Tue, 21 Jan 2025 07:18:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxR1uZcCuwoW2aFPUCORzZ6dwwEYoPsh6uPawIkQwwYuCSVsklLlGV/S//6f3s7+8ge5e9jA==
X-Received: by 2002:a05:622a:38b:b0:46c:7646:4a1e with SMTP id d75a77b69052e-46e12a62966mr286440391cf.13.1737472702548;
        Tue, 21 Jan 2025 07:18:22 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e1030df9csm53752851cf.36.2025.01.21.07.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 07:18:21 -0800 (PST)
Date: Tue, 21 Jan 2025 10:18:19 -0500
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
Message-ID: <Z4-6u5_9NChu_KZq@x1n>
References: <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>

On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
> On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
> > On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > > > It is still uncertain how to implement the private MMIO. Our assumption
> > > > is the private MMIO would also create a memory region with
> > > > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > > > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > > > listener.
> > > 
> > > My current working approach is to leave it as is in QEMU and VFIO.
> > 
> > Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
> 
> The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
> normal assigned MMIO is always set ram=true,
> 
> void memory_region_init_ram_device_ptr(MemoryRegion *mr,
>                                        Object *owner,
>                                        const char *name,
>                                        uint64_t size,
>                                        void *ptr)
> {
>     memory_region_init(mr, owner, name, size);
>     mr->ram = true;
> 
> 
> So I don't think ram=true is a problem here.

I see.  If there's always a host pointer then it looks valid.  So it means
the device private MMIOs are always mappable since the start?

Thanks,

-- 
Peter Xu


