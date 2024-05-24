Return-Path: <kvm+bounces-18094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 503EE8CDF00
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BEB5282F0E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 00:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D9F63B8;
	Fri, 24 May 2024 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKREuStW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8579481F
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716511752; cv=none; b=lKkjdKHO7kHwfgDLutUYWbWVzSfEjEw1Uw9pRfOx4kXlyCCnqY46JSc5plJ8U9AZ1Ds8PxMot+esflr4ZxMgJb8t7SjM4i0bdaOGU5ABUd3CKCzAWVB4mCyFD9TGfGBgXasj79m2PuqeaO0gHVkJPHvUIE2+FUdoVmiCVGo3Cbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716511752; c=relaxed/simple;
	bh=/XRfHj/v7ZW6Y2oJMiEjINl3Pru8jblNkmFUEXfNTqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/fdE/oq6Hnw+vHBDugcl5djN3+lGs+UgpnbS2E1UDqWr3f0koim9UJlI+o79WqPJxHIulo+vU6MyvMWm68RvaiUtLE37t+v9aHV4UE6grKOoMAE2awbtzYovZrrcTMl7/fYDdT4KodsxH44vZm30R/XHgtE33U+2fE/znsjuss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKREuStW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716511749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+tJyD1G7R1LDWqF2vksqfwEkPJJVpDhROz7enDnsS8=;
	b=eKREuStW+arB9/44fWOtlmSSPczads8mIDNupzVZe/P/1vbtcUHPEMur/ZlESfZVFlet3M
	YI7zh665sZxPMCRCf/eQzB1sacOa0gNKc1m/8zcuB0QLkL6g6NL2TvPLo7hZu6w1BtA9c7
	FUZm6p1ZkRCn9Zl3P2yiqckyXMBhY5I=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-oZtRE_Y2P4iVDQ2S7FB9GA-1; Thu, 23 May 2024 20:49:07 -0400
X-MC-Unique: oZtRE_Y2P4iVDQ2S7FB9GA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ab89f69cd8so1787906d6.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 17:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716511747; x=1717116547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+tJyD1G7R1LDWqF2vksqfwEkPJJVpDhROz7enDnsS8=;
        b=MT8qc+pOkuafpqKAV1zqTXM8Uwf21PIl6oa+yPfXFCwtO77kToDB1zyPkW0xQD6Wjd
         HoseZ0tDvkHmBk8ZJrIqSHmAyAojkBLI8mijvqBT/V9lFHUyHop3K7xoC77tlB13tu0X
         SRcmLq24rMbLFGjGUWG+C/1wbD6JeVaUbHtQ3SmOs/29R1/yyCDop2ZTSY6e6PnWmZQF
         MyQPouYcV8KMvHv7Jf8P7QmnTImEcJd6ujIFjb3WZZCzvSdjfbN8NcKIgVwP7nUEkQdC
         6K197OBjfF3WalzpMyQ4Eng0UkAT66KtgPMKICUzqZmeA6p94NKDxHR3brSG32TWGPu/
         xFSg==
X-Forwarded-Encrypted: i=1; AJvYcCUsKdon+o+GcBz7vPgEWp0JXSBILPQMFkesuWfpx/G0a01bPPQ6xZ/4x12QY5NaGH23iQ1aSuPh45o8tGGcG8Jmre31
X-Gm-Message-State: AOJu0YyXG01Z2747qNsr4EjJPnlWUyTIPntvR1osILLmK4Vmw5J4r6n3
	cunxgsyHlKry6blYoXFedNjpKj0TGAlYY4pPu7P3FFnaw77caxgAFRhJ4OwHdypdH0Ol1l8f0rb
	rcBUHSV01VyK2m0dZOwe5tPzHG5plM/xg4diFBmWhH1yv/YwMbA==
X-Received: by 2002:ad4:5f4e:0:b0:6a3:3d77:f7d8 with SMTP id 6a1803df08f44-6abe29451e2mr6787036d6.6.1716511746471;
        Thu, 23 May 2024 17:49:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0oi1VcW5MkPeiV3hYIlm5yGOBXWu7URsUlEM+htwW1fI2fx7IkjY9MS0kr9Bz4GBTT3ahTw==
X-Received: by 2002:ad4:5f4e:0:b0:6a3:3d77:f7d8 with SMTP id 6a1803df08f44-6abe29451e2mr6786786d6.6.1716511745519;
        Thu, 23 May 2024 17:49:05 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac070c5d99sm2036436d6.15.2024.05.23.17.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 17:49:05 -0700 (PDT)
Date: Thu, 23 May 2024 20:49:03 -0400
From: Peter Xu <peterx@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	ajones@ventanamicro.com, kevin.tian@intel.com, jgg@nvidia.com
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zk_j_zVp_0j75Zxr@x1n>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>

Hi, Yan,

On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:
> On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> > With the vfio device fd tied to the address space of the pseudo fs
> > inode, we can use the mm to track all vmas that might be mmap'ing
> > device BARs, which removes our vma_list and all the complicated lock
> > ordering necessary to manually zap each related vma.
> > 
> > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > unmap_mapping_range() to zap a selective portion of the device fd
> > corresponding to BAR mappings.
> > 
> > This also converts our mmap fault handler to use vmf_insert_pfn()
> Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> for the PFN on x86 as what's done in io_remap_pfn_range().
> 
> Instead, it just calls lookup_memtype() and determine the final prot based on
> the result from this lookup, which might not prevent others from reserving the
> PFN to other memory types.

I didn't worry too much on others reserving the same pfn range, as that
should be the mmio region for this device, and this device should be owned
by vfio driver.

However I share the same question, see:

https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com

So far I think it's not a major issue as VFIO always use UC- mem type, and
that's also the default.  But I do also feel like there's something we can
do better, and I'll keep you copied too if I'll resend the series.

Thanks,

> 
> Does that matter?
> > because we no longer have a vma_list to avoid the concurrency problem
> > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > huge_fault handler to avoid the additional faulting overhead, but
> > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> >
> > Also, Jason notes that a race exists between unmap_mapping_range() and
> > the fops mmap callback if we were to call io_remap_pfn_range() to
> > populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> > before it does vma_link_file() which gives a window where the vma is
> > populated but invisible to unmap_mapping_range().
> > 
> 

-- 
Peter Xu


