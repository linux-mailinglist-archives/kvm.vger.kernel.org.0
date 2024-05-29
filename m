Return-Path: <kvm+bounces-18325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DA88D3D14
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 18:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0A481C2186E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD6B18412B;
	Wed, 29 May 2024 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hutSXh5E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F89181CFC
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717001421; cv=none; b=tHOo6DHgiyMC5UgoVUk8hoNlOn0n4INK8bjXLflC8zBnLmnZvHfJTTHOjKdARLrxrNuSQrJ36aL472zaUOXJcJGpyE5PORIlT2XfxiiN/843sfGNXFslIH2ux4qEBo+iIjpt5plZC6ylOAFCT2qZJCjE217It7/S97aPdD9xy4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717001421; c=relaxed/simple;
	bh=pAIs9A4CcqScaSN+s22zk5A9Go/L+WcbQ6tlBt0U5d0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9YVXWeTJQyyjuUv/XOxwVJRj/Wj6gnjlMXLd8DV5J9W5ErxGZZJZXsUw+vjMGx8q/eoZ7f2+LEeP575Zvp+5mNvg4R+TGQeAxR4AaPmXSRDX3qlMFA85gCVUP2o82RwZ+ua27RK5ZABmpR1qAWHglVTaSvApz6r61/BHfyrh+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hutSXh5E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717001418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N5Nnebcy9FKWV8ob7ceU5bPcFqavtAXcBKqlmvc+Aiw=;
	b=hutSXh5EAU5s4OD8t1uouvy+MS+b9NeWw1+bxJkCVa+8cJ+HLyO/6nRnGuSHjrwI4xX51R
	hgOeWsIH45QGiNWfAK23aOff+h4ZecZjA0lh/+gyL0rQ86PxBmjiIUNBa4/6E7ovvI/x1a
	0QGdMZZrdXPU1ax9UiNYgPZrQAYCRDY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-tJSFX8tuOfCN4IcMNwp7QQ-1; Wed, 29 May 2024 12:50:17 -0400
X-MC-Unique: tJSFX8tuOfCN4IcMNwp7QQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-372f268d124so22361985ab.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 09:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717001416; x=1717606216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5Nnebcy9FKWV8ob7ceU5bPcFqavtAXcBKqlmvc+Aiw=;
        b=qvHS4OvWAGPCsTsFvM0SQ45nGY3FsOY0pY0NB83+JiHeGjevTNUE07ltyeBgB9Gvt/
         7Xg35fWjZy6GvBbTtSbl6iflfb3ECbbRTU7QfWF11L6la7CfgpcrE8fZODGuSnruZK65
         wEz4asZBB2hoZNErewtGvt7Fn9g9NmNQdrDh++JmCpBlAu+9e9sMKX0+8q7JKHikA9+u
         uUP0XZ6YjzPyYZXm+jvuexUGqdM79VMmbaTzIVr99XMNPBedSbzltV/v05SxkzI6W4nv
         f2M7maCq6ZIn2uyY2TouaauVN9SUoVZTt1p9XmeRpUSYyyieeZVJZpyDR/oIzEEJ1b93
         JEBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD1RzfmdKls92IQabvi8yagutj8mF2taCrAm0xlHtK+828WlhivfGOgzMXb6sr0lgvXaaw9RIE+csF/Ig8vocYJuhe
X-Gm-Message-State: AOJu0YwtUW5S1V7jzntdsNKok9f1Gdd4zlKfrtVdEVt2mg3+ftNSgo7+
	1bMaoX0X0lQkK0RWPlV75E6W5FjwIG31N5rIL5IZizqmHLNMIOoBibkCd7LBzjo/MkCJvwuywKQ
	heNm8te4mHThmHmTjF1KyqkUo0P0b6o0PaQ3Mn4COZ6TOBeqxTg==
X-Received: by 2002:a05:6e02:180b:b0:374:5ddc:6a27 with SMTP id e9e14a558f8ab-3745ddc6ab1mr95688035ab.28.1717001416274;
        Wed, 29 May 2024 09:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpCxDv9RrRjFTgaP2DmlXkLHGhsW//U2QzLAnhRN2bzWZ1h4PkkWdH10a5yTkBQi1KQoN+jw==
X-Received: by 2002:a05:6e02:180b:b0:374:5ddc:6a27 with SMTP id e9e14a558f8ab-3745ddc6ab1mr95687625ab.28.1717001415681;
        Wed, 29 May 2024 09:50:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3737c29e794sm25065635ab.9.2024.05.29.09.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 09:50:15 -0700 (PDT)
Date: Wed, 29 May 2024 10:50:12 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
 <ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240529105012.39756143.alex.williamson@redhat.com>
In-Reply-To: <ZlbMb9F4+vNwTUDf@yzhao56-desk.sh.intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
	<20240523195629.218043-3-alex.williamson@redhat.com>
	<Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
	<Zk_j_zVp_0j75Zxr@x1n>
	<Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
	<20240528124251.3c3dcfe4.alex.williamson@redhat.com>
	<ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
	<20240528211200.1a5074e3.alex.williamson@redhat.com>
	<ZlbMb9F4+vNwTUDf@yzhao56-desk.sh.intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 May 2024 14:34:23 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, May 28, 2024 at 09:12:00PM -0600, Alex Williamson wrote:
> > On Wed, 29 May 2024 10:29:33 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Tue, May 28, 2024 at 12:42:51PM -0600, Alex Williamson wrote:  
> > > > On Fri, 24 May 2024 09:47:03 +0800
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:    
> > > > > > Hi, Yan,
> > > > > > 
> > > > > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:      
> > > > > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:      
> > > > > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > > > > ordering necessary to manually zap each related vma.
> > > > > > > > 
> > > > > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > > > > corresponding to BAR mappings.
> > > > > > > > 
> > > > > > > > This also converts our mmap fault handler to use vmf_insert_pfn()      
> > > > > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > > > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > > > > > 
> > > > > > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > > > > > the result from this lookup, which might not prevent others from reserving the
> > > > > > > PFN to other memory types.      
> > > > > > 
> > > > > > I didn't worry too much on others reserving the same pfn range, as that
> > > > > > should be the mmio region for this device, and this device should be owned
> > > > > > by vfio driver.
> > > > > > 
> > > > > > However I share the same question, see:
> > > > > > 
> > > > > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > > > > 
> > > > > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > > > > that's also the default.  But I do also feel like there's something we can      
> > > > > Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> > > > > (or the variant driver) opts to use WC for certain BAR as mem type in future.
> > > > > Not sure if it will be true though :)    
> > > > 
> > > > Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
> > > > needs to make sure the PCI BAR region is requested before the mmap,
> > > > which is tracked via the barmap.  Therefore the barmap is always setup
> > > > via pci_iomap() which will call memtype_reserve() with UC- attribute.    
> > > Just a question out of curiosity.
> > > Is this a must to call pci_iomap() in vfio_pci_core_mmap()?
> > > I don't see it or ioremap*() is called before nvgrace_gpu_mmap().  
> > 
> > nvgrace-gpu is exposing a non-PCI coherent memory region as a BAR, so
> > it doesn't request the PCI BAR region and is on it's own for read/write
> > access as well.  To mmap an actual PCI BAR it's required to request the  
> Thanks for explanation!
> So, if mmap happens before read/write, where is page memtype reserved?

For nvgrace-gpu?  The device for this variant driver only exists on ARM
platforms.  memtype_reserve() only exists on x86.  Thanks,

Alex


