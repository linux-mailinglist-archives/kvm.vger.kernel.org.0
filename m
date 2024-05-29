Return-Path: <kvm+bounces-18260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CA48D2B52
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 05:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB2AB1C211E0
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4AD15B109;
	Wed, 29 May 2024 03:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICcQEVGz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9C3207
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 03:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716952331; cv=none; b=U2xGrKm2Bq/Y1OaxVDT0aMO3ruYzBDr3RAL8zurugjas6X0xXA0Ccpx/+kn4GBaXtbtfpJmNkgNanEi9XW9gYFW4yfwZZ0sgWAs10EdJjn3HuP3jJTO7BjFfdrdfqenh9L3r2j9jqYxVnakVWYV58+F8kLBkXVYtySwXp89rUFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716952331; c=relaxed/simple;
	bh=snEM6wyY9Yl4nQADGqgRE+Bvao+3uvSDtiIY6FiK3vk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyFm8j6/IuzrBo+w6MkNaOQg3JpAM0/GF3B8ZelCHhj2nKGVbnrDH04/VCty3+7hBQt+kJFSJ1rFdd+pTXW4Jjf37jMtWaP+1B9eOi0T3rtUeS9HYq1WrT7lKiaJYLMPyGknJcjX7oI1vocijD8G89g4t/dk/Oe/PhlXHodm68A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICcQEVGz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716952328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEk1SkkqvkiermeG3nX5dEz86ifq6bb7v7WXol9RkwE=;
	b=ICcQEVGzhYQjEXEQlJoxeeHsfgY1AR6B4lbAAAk/7q1ZCRT+M0NMk4opiNxhLxu69IHjNC
	ngrgTeMDg78v2dfRGprRjeTktMCLN35/xFwwZgPJQie1T8njjwcAE1zAYi48Yk+IMPLKjU
	jtxJ2JMQEIWQTlJ8gcICnkDzytnjA7Q=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-5Z-EPKeDPZuVAwMELQ0XwA-1; Tue, 28 May 2024 23:12:03 -0400
X-MC-Unique: 5Z-EPKeDPZuVAwMELQ0XwA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3746677c8e2so4304975ab.1
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 20:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716952323; x=1717557123;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qEk1SkkqvkiermeG3nX5dEz86ifq6bb7v7WXol9RkwE=;
        b=VUXq3AHqNSonX0PMZvZPvnv3aNV9BeAsozNZcQXcPg7jpCJPzP0KWVoOvL0lSWw5kK
         tWoGPBxF2rhW4xHzvsLMCZwvgKFPxN0uT+CUYjUVrOHR+fqCMS3x7at+TDBsp76snpWI
         ViLBnNH3Ey2ggXFTQqM77O5shCfOqroDvrtcd8MP2Nez3sh9y+ja9X/PxEGEquAJi+pF
         sDa8N8XOzrqj0bpj4W0NTt9vUYceXaw5LtOg59z9VfA+5Dby3jHPkinFSboIAhXwfKtA
         k9qQjncJaBswlAEnLMXf/v8qzZJofBm6gePQTudWAZ5wzXaXcHBdKfmbGt0ElMC8mJTH
         43cQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2Tw0xhMCe0OAl/SeVkHgDNamC39fx58RsVB0zxm+58Lgb/AK/jAYTYZWD2FS4L3Ufpx5N8D8hSm+uZztU+CndPznr
X-Gm-Message-State: AOJu0YxdmZ9vNzwdFUppwU9vzVx12l1T2pOa0Hz9C3OjKHLdvlxtdSDQ
	pVgwgE9ujzEc2PdO3rRgKeYN4ntZEc345qCX3pdPwAddvvq88OZ78zYCYHc2oqYAlxWIdEXCW0M
	PvJc5o2wERURpNFnvD2cZhFA8i/0a+rAcuq6xHbkK3uptZRGenA==
X-Received: by 2002:a05:6e02:20c2:b0:374:4ee5:cf7b with SMTP id e9e14a558f8ab-3747367f4f2mr8264895ab.1.1716952322960;
        Tue, 28 May 2024 20:12:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBMbsCAU0RuYYPe3QQ4vGxStrUJplXKcWTHhGQ0QHqwOobbt7gm0J0/uePdAx5+oFp+wUbZg==
X-Received: by 2002:a05:6e02:20c2:b0:374:4ee5:cf7b with SMTP id e9e14a558f8ab-3747367f4f2mr8264785ab.1.1716952322542;
        Tue, 28 May 2024 20:12:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b09717cf47sm2058965173.39.2024.05.28.20.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 20:12:02 -0700 (PDT)
Date: Tue, 28 May 2024 21:12:00 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
 <ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240528211200.1a5074e3.alex.williamson@redhat.com>
In-Reply-To: <ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
	<20240523195629.218043-3-alex.williamson@redhat.com>
	<Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
	<Zk_j_zVp_0j75Zxr@x1n>
	<Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
	<20240528124251.3c3dcfe4.alex.williamson@redhat.com>
	<ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 May 2024 10:29:33 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, May 28, 2024 at 12:42:51PM -0600, Alex Williamson wrote:
> > On Fri, 24 May 2024 09:47:03 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:  
> > > > Hi, Yan,
> > > > 
> > > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:    
> > > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:    
> > > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > > ordering necessary to manually zap each related vma.
> > > > > > 
> > > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > > corresponding to BAR mappings.
> > > > > > 
> > > > > > This also converts our mmap fault handler to use vmf_insert_pfn()    
> > > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > > > 
> > > > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > > > the result from this lookup, which might not prevent others from reserving the
> > > > > PFN to other memory types.    
> > > > 
> > > > I didn't worry too much on others reserving the same pfn range, as that
> > > > should be the mmio region for this device, and this device should be owned
> > > > by vfio driver.
> > > > 
> > > > However I share the same question, see:
> > > > 
> > > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > > 
> > > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > > that's also the default.  But I do also feel like there's something we can    
> > > Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> > > (or the variant driver) opts to use WC for certain BAR as mem type in future.
> > > Not sure if it will be true though :)  
> > 
> > Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
> > needs to make sure the PCI BAR region is requested before the mmap,
> > which is tracked via the barmap.  Therefore the barmap is always setup
> > via pci_iomap() which will call memtype_reserve() with UC- attribute.  
> Just a question out of curiosity.
> Is this a must to call pci_iomap() in vfio_pci_core_mmap()?
> I don't see it or ioremap*() is called before nvgrace_gpu_mmap().

nvgrace-gpu is exposing a non-PCI coherent memory region as a BAR, so
it doesn't request the PCI BAR region and is on it's own for read/write
access as well.  To mmap an actual PCI BAR it's required to request the
region and vfio-pci-core uses the barmap to track which BARs have been
requested.  Thanks,

Alex

> > If there are any additional comments required to make this more clear
> > or outline steps for WC support in the future, please provide
> > suggestions.  Thanks,
> > 
> > Alex
> > 
> > [1]https://lore.kernel.org/all/BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com/
> >   
> > > > > Does that matter?    
> > > > > > because we no longer have a vma_list to avoid the concurrency problem
> > > > > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > > > > huge_fault handler to avoid the additional faulting overhead, but
> > > > > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > > > > >
> > > > > > Also, Jason notes that a race exists between unmap_mapping_range() and
> > > > > > the fops mmap callback if we were to call io_remap_pfn_range() to
> > > > > > populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> > > > > > before it does vma_link_file() which gives a window where the vma is
> > > > > > populated but invisible to unmap_mapping_range().
> > > > > >     
> > > > >     
> > > > 
> > > > -- 
> > > > Peter Xu
> > > >     
> > >   
> >   
> 


