Return-Path: <kvm+bounces-17982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4628CC76C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05BF0B213CC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F99B146A8F;
	Wed, 22 May 2024 19:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWClwu1Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF312145B1F
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716406996; cv=none; b=ouDEzjOq/+UPHz9Y/noBlhNLise7Ro6/Sl8qAbdFR9cXa3DHm14L/wobU9XpofyxqsYAMrxiohLqr+x4TC4SwgXbf5TIGTsLaMMLmexlwiXlGMH0yeIr+ieiRIVxqi/ZhcBdGYK7rRD32UJZcMRWZzgDTXacRg3EXfk49uM/RP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716406996; c=relaxed/simple;
	bh=3gnbJKlJ+lpkI6N28w+IG+DueXgPDUc6asyf6klnIPM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUOh7DNfybiPsoJalTpri51d5bKSicTPFwBwSPqFmDeoXcUe1Rk1OtDxMv/G32eQpMjSUqYzRhyk374hqp9nghCU+t0LSkUuBznPCGJJZPa9RzIRRQBW6+dYshB4SU3YyW6wHjhLnzCAHhSB8Q37NEeKH/H4XjYUN9peRuQ7Fno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWClwu1Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716406993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqtiRpqfQv73C5Zwn5wS3bvroEy21cCrfxMP439njVk=;
	b=VWClwu1QSAcr9UmbddhH4th7mGMx/yjAg6JjeZmIASlmrxGu3ZcqAHnS26Bug7Ui2BPP8o
	VupLweMMOYXzQMvOW1PSnE+M+Cad+rsuj7C+R6cGc0lSdoH1m1ZoXJIysmq3RzbRKGdw05
	TPaYPu/+WFZNtuybLT9wiHcGGrzjraU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-RbapFNjQMHes26hVd9tu6Q-1; Wed, 22 May 2024 15:43:11 -0400
X-MC-Unique: RbapFNjQMHes26hVd9tu6Q-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36c80ee383eso8650885ab.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 12:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716406990; x=1717011790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqtiRpqfQv73C5Zwn5wS3bvroEy21cCrfxMP439njVk=;
        b=RLy0v59E0XeHkEppd67QWCvmkQ/LUhQ/ATX2mEYIEhqGm4MyzmcyVJYzVPEN0rX5rB
         Saw3Cjmo+7GXmUXu00ZgPhQyn6GpwOQ5CBiwaSshH2m0Nnk/LIba1PiXCRiE5WLt4Bjt
         N5DO/Db8IOX8Cq2+XzVk06UR66WC2krH6+lvM4fz9yRZpA0ZmwqfzOXnEHIgPydgfUOm
         ltBFx4nRKMu5hnS/7QIDqr9eQjXM8cKLh4+7N6I7q8TKtpgMABMlBmY8NtUvGdnS0VnO
         Vh3kwa3MQv2y84fIdktYj/kB9lEPdz6uN8AgxQ3x08CLTIRJW3BwoXuvaVtM9DhC0PaU
         yt4A==
X-Forwarded-Encrypted: i=1; AJvYcCVWm50AhOH15Qzs9kELYYQWB0GIxzBC2syZSnsxMN+vRnKP+cP1fhWy7chMw0QlKBF/32C67lXQtu8LRiH3218beExX
X-Gm-Message-State: AOJu0YxOfW2wjFmcUv5nzmOpuu4CYhCaPVxHx2sJBrNF6mepTQ5BO3Zx
	woOr56uOgw1Y/UN+YKiy8VGS/DCwImWLH4PhWTDi0HdR369YR2TNbBO8uCQjuKIiSChryTiuEJn
	iokGQ+2s4OuPMdrHWjV5GrG4WaX3YPLRlf1InECsI7o+6Xmkqfw==
X-Received: by 2002:a05:6e02:2145:b0:371:9d75:ac27 with SMTP id e9e14a558f8ab-371f664df6amr34301555ab.0.1716406988981;
        Wed, 22 May 2024 12:43:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtjLm3yGleRwm+mBJukESjCnsEgk5gm1vxnO69ba+V7MWwAirl7eW+fiWVXhmemQycDH2big==
X-Received: by 2002:a05:6e02:2145:b0:371:9d75:ac27 with SMTP id e9e14a558f8ab-371f664df6amr34301375ab.0.1716406988632;
        Wed, 22 May 2024 12:43:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9db0a02sm71839685ab.51.2024.05.22.12.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 12:43:07 -0700 (PDT)
Date: Wed, 22 May 2024 13:43:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, Yan Zhao <yan.y.zhao@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kevin.tian@intel.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com, Peter Xu
 <peterx@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20240522134306.11350e13.alex.williamson@redhat.com>
In-Reply-To: <20240522183046.GG20229@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
	<20240522-b1ef260c9d6944362c14c246@orel>
	<20240522115006.7746f8c8.alex.williamson@redhat.com>
	<20240522183046.GG20229@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 15:30:46 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, May 22, 2024 at 11:50:06AM -0600, Alex Williamson wrote:
> > I'm not sure if there are any outstanding blockers on Peter's side, but
> > this seems like a good route from the vfio side.  If we're seeing this
> > now without lockdep, we might need to bite the bullet and take the hit
> > with vmf_insert_pfn() while the pmd/pud path learn about pfnmaps.  
> 
> There is another alternative...
> 
> Ideally we wouldn't use the fault handler.
> 
> Instead when the MMIO becomes available again we'd iterate over all
> the VMA's and do remap_pfn_range(). When the MMIO becomes unavailable
> we do unmap_mapping_range() and remove it. This whole thing is
> synchronous and the fault handler should simply trigger SIGBUS if
> userspace races things.
> 
> unmap_mapping_range() is easy, but the remap side doesn't have a
> helper today..
> 
> Something grotesque like this perhaps?
> 
> 	while (1) {
> 		struct mm_struct *cur_mm = NULL;
> 
> 		i_mmap_lock_read(mapping);
> 		vma_interval_tree_foreach(vma, mapping->i_mmap, 0, ULONG_MAX) {
> 			if (vma_populated(vma))
> 				continue;
> 
> 			cur_mm = vm->mm_struct;
> 			mmgrab(cur_mm);
> 		}
> 		i_mmap_unlock_read(mapping);
> 
> 		if (!cur_mm)
> 			return;
> 
> 		mmap_write_lock(cur_mm);
> 		i_mmap_lock_read(mapping);
> 		vma_interval_tree_foreach(vma, mapping->i_mmap, 0, ULONG_MAX) {
> 			if (vma->mm_struct == mm)
> 				vfio_remap_vma(vma);
> 		}
> 		i_mmap_unlock_read(mapping);
> 		mmap_write_unlock(cur_mm);
> 		mmdrop(cur_mm);
> 	}

Yes, I've played with similar it's a pretty ugly and painful path
versus lazily faulting.

> I'm pretty sure we need to hold the mmap_write lock to do the
> remap_pfn..
> 
> vma_populated() would have to do a RCU read of the page table to check
> if the page 0 is present.
> 
> Also there is a race in mmap if you call remap_pfn_range() from the
> mmap fops and also use unmap_mapping_range(). mmap_region() does
> call_mmap() before it does vma_link_file() which gives a window where
> the VMA is populated but invisible to unmap_mapping_range(). We'd need
> to add another fop to call after vma_link_file() to populate the mmap
> or rely exclusively on the fault handler to populate.

Thanks, the branch I linked added back remap_pfn_range() on mmap,
conditional on locking/enabled, but I've predominantly been testing
with that disabled to exercise the pmd/pud faults.  I would have missed
the gap vs unmap_mapping_range().

It's hard to beat the faulting mechanism from a simplicity standpoint,
so long as the mm folks don't balk at pfnmap faults.  I think the vma
address space walking ends up with tracking flags to avoid redundant
mappings that get complicated and add to the ugliness.  The mm handles
all that if we only use faulting and we get a simple test on fault to
proceed or trigger a SIGBUS.  Using pmd/pud faults should have some
efficiency benefits as well.  Thanks,

Alex


