Return-Path: <kvm+bounces-18148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1428CECA3
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 01:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6D7EB21E9F
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 23:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF21153BEF;
	Fri, 24 May 2024 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQN21GXE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDADE153821
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 23:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716592571; cv=none; b=XEcgTxmYhqLNxVleqYh6+KHsmI3+/Nef8v+Y1HPhukgi8fqWSnOgQIQU0s0j5L7H0VKhSnLLoIx61HxH2htLdIe57pgEoj1bjj9T/YZTikbhAIs6jaedjHz/k8LXjVTD440ReveJi0cC3V3TO4+CtobHnJssyUwUQb7l+mC4Eeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716592571; c=relaxed/simple;
	bh=LVX/JWWRL++CygDPTDbK8pxHcpTTUsLJCIZLDAK5SYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdnvN7aIMl+7Gb5XF75+TUh+NJT0O0/epl486L8mG284PMrof7zCQLgBEU2k6U5cLj977+p5LyO1xEEdqIuoRtLt+WeeEqCFbvwmj6cRjiHyxjlYhLIxmTqneoADJpM5pO0pC9NKybm3+j6WGeoaH8dQJBZBcMWMVfIGHvIU2eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQN21GXE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716592568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0o5W35MPhyoJxQNySvvNjq+6LL68vU2lEicM90G3FLg=;
	b=cQN21GXElGj8+PEkcw7j/nwunKhDCgBYtiVAyTjHK5K/RZCFneFd5uCS7ko2pGoAnh42X+
	uPcflNxBUoP+H751q8tsfRApxMRk1NuXJmZglDerqhzaFtx8Yo3WGS7JSfPeGuRYqViWcH
	bdkWVlKU6W3LloA3w4rrJK+w1KI2GSs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-y903Iw0VONy-Vr4Eq6LDTQ-1; Fri, 24 May 2024 19:16:07 -0400
X-MC-Unique: y903Iw0VONy-Vr4Eq6LDTQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ab8ec745e6so5155626d6.2
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 16:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716592566; x=1717197366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o5W35MPhyoJxQNySvvNjq+6LL68vU2lEicM90G3FLg=;
        b=ux7X/C2DQWSk1keVBjicTZbxlhaEkB8sMs7UZxMl2Hj8PANKRMnfY7Wov/d2u6/KlV
         W6j7Jh2V32E8WEogOgtazGBuEMuEeLrUsVJnGwsFAWjip7kq/6NbNffAJQWsfx6ClgW/
         9lnHvqtDmCNRwMGLWWdEsR8Y/fqz1FWDR/+sxBaVHhrKK+MN8mlpaCmvsaDsv3tLYpR3
         Q0zkJvphgJWcXmE4nfJsM+nnGR0g1zVhQJJfRl68/tjpgdjItgYpEQmx1Tvx4iLSk2+i
         DuaaXLxnnpgkPP/I11wn0ocaebi7em2gQAdKChB50VoW5sDTI/gxnQRqW2NNJcBOlKaV
         r7eA==
X-Forwarded-Encrypted: i=1; AJvYcCVir4cTUsWaIJwDa7B76lxgGM6f2BSpzf9oIPzS4XuJgZgrPvjnTyeFeH7WHPtxk7PnBs1WUOLipKfHOzioGQxnAO10
X-Gm-Message-State: AOJu0Yy9KWnlGETG2cTXxV4qKgUkLarSA7DcTeO+wOh4q7M8anq6YANf
	w8Su6feXOicb++ipNyojF9sxPdH4uSY5uRHnjWkh0PACVx5L9R2rG1QqpxuzWFQCzzl3UpBFW2P
	VyjMv1osNbZb2uX+OIlcGjZWae0bbIr5vpc7IVlwxd/3OKiBFJg==
X-Received: by 2002:a05:6214:528a:b0:6ab:9583:3b75 with SMTP id 6a1803df08f44-6abcd1343damr36382656d6.4.1716592566210;
        Fri, 24 May 2024 16:16:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrypfc88l+pSYgwpy4WVmUNImo3yScJ21hZW0SDjKRws2LVPZ2O/QMYO98FWfVZnM/YEx3rA==
X-Received: by 2002:a05:6214:528a:b0:6ab:9583:3b75 with SMTP id 6a1803df08f44-6abcd1343damr36382396d6.4.1716592565575;
        Fri, 24 May 2024 16:16:05 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac162ef85asm11294136d6.102.2024.05.24.16.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 16:16:05 -0700 (PDT)
Date: Fri, 24 May 2024 19:15:58 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <ZlEfrvWnb7c2ZXVV@x1n>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
 <BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240524132240.GV20229@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240524132240.GV20229@nvidia.com>

On Fri, May 24, 2024 at 10:22:40AM -0300, Jason Gunthorpe wrote:
> On Fri, May 24, 2024 at 08:40:26AM +0000, Tian, Kevin wrote:
> > > From: Peter Xu <peterx@redhat.com>
> > > Sent: Friday, May 24, 2024 8:49 AM
> > > 
> > > Hi, Yan,
> > > 
> > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:
> > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > ordering necessary to manually zap each related vma.
> > > > >
> > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > corresponding to BAR mappings.
> > > > >
> > > > > This also converts our mmap fault handler to use vmf_insert_pfn()
> > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve
> > > memory type
> > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > >
> > > > Instead, it just calls lookup_memtype() and determine the final prot based
> > > on
> > > > the result from this lookup, which might not prevent others from reserving
> > > the
> > > > PFN to other memory types.
> > > 
> > > I didn't worry too much on others reserving the same pfn range, as that
> > > should be the mmio region for this device, and this device should be owned
> > > by vfio driver.
> > 
> > and the earliest point doing memtype_reserve() is here:
> > 
> > vfio_pci_core_mmap()
> > 	vdev->barmap[index] = pci_iomap(pdev, index, 0);
> > 
> > > 
> > > However I share the same question, see:
> > > 
> > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > 
> > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > that's also the default.  But I do also feel like there's something we can
> > > do better, and I'll keep you copied too if I'll resend the series.
> > > 
> > 
> > vfio-nvgrace uses WC. But it directly does remap_pfn_range() in its
> > nvgrace_gpu_mmap() so not suffering from the issue here.
> 
> People keep asking for WC on normal VFIO PCI as well, we shouldn't
> rule out, or at least provide a big warning comment what needs to be
> fixed to allow it.

Maybe we can have a comment indeed.  Or as long as that pat series can get
merged before adding WC support we should also be good, and that's also the
hope..

Thanks,

-- 
Peter Xu


