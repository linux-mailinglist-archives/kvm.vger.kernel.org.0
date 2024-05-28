Return-Path: <kvm+bounces-18234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BDB8D235B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 20:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 122391F23B80
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 18:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5ED16D4FC;
	Tue, 28 May 2024 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czboGkmi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877F1C6A5
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 18:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716921779; cv=none; b=CW0LZ4ei11dikKTE0I1mvq9FYMvMQ2JXtaiXCx/9JNPucVzOMq5HaJ9Bp6IPARE5VkXlTlv3OEgJs7HKMA15kaT2HAxOoZz22hqUk7p0ENQnWhZQZZRQnikiBnhr8CeNzGsxuubi7FWyp2xuJBfAQLrF3Wd3t3snWVPAknh9rEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716921779; c=relaxed/simple;
	bh=cuzWl4p1dgcX9rpAmO18y4ZhXaYWa8YOK62YyIjj3+0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gui+8pHdWRMttA7SesDDDp/RYnRWQcMdpL6+0mFnBe9m+8Lt7OypCTIC3MndlQIQJo04ssXw/8v4DVDSaWpYe3khDxM6dznCngJg1wwB3a17UZenYAe/DQ2V729JdPKhTC1LmUrtguTuh/pzRY6Yizin6mpapndV/o7AdipNrAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czboGkmi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716921776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQJSlbygfAYZXEQwuyM1FB4RBJG+zbsu5xfgtQXaTMk=;
	b=czboGkmityCtB3UxDe1xN+6g27eChEtas1ZIMBZIhP6YN8Ngzn+13RbLsxClTSFfeeDmqn
	mV+2vwPbiCIy3VDDKx0GFyhBQDxUIqNSiCt48rap3WRDJ4p2edjN9ZiEiKbgMjr8KlYqV7
	KWVvJJiiJvJGX8v823ezCPnpVN1DHdE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-UIoKnNwRPN6epl7l15iuUw-1; Tue, 28 May 2024 14:42:55 -0400
X-MC-Unique: UIoKnNwRPN6epl7l15iuUw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-37456dcde30so11327155ab.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 11:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716921774; x=1717526574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQJSlbygfAYZXEQwuyM1FB4RBJG+zbsu5xfgtQXaTMk=;
        b=I6JsUuqdO4rpjYhqbLhohRjO148l2uLIH7GwT9qwJED70SKqmojPEPYg8FiGlWJ7t+
         eVc5yF5aRzrEPLHEz1MCtkrrBTc9OZc9SP+EmodKL5pNj4+mIkDfzNm8jIBEm7IHv/q9
         FyuVyfWSV37SwAocjvYWaJePVJFtSjt0AZfLcn41puMHZhQHWIhZKexeWSg6cydiUy12
         rxdxD04OY66zIaL7xQnNJbNrlj51tEUI8kaN1zAc90t1fdrshq6VVOjhhNF2tQ6KyIY9
         6QjB8lI3c5iyUBLNth2GD1O/kfBxAvWTDxK1Z/I8vGbOWOSTY6gOK6ezYUGQhQeWM8KX
         1CmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXce8NsYqRFvsnAvf0TZO0+oEn+/IHsSvm2zOex62dkoNRKDl0JPAsJE+kpHeuKi5+ssncNaTP4YBczoINroBR8nFtI
X-Gm-Message-State: AOJu0YyqgKY1wkauUwLtw6PjVFp2CDWJHqBUvvrLIoFxJbMnhtUjA6UX
	x+TpWfrmE02tiosGvP4UBv4s5iJQtWxqhqPMfC3vNzTgpylw/Uol0Ov+r92dZNtpBXuVJFdAr6I
	ItwO2KASCbhWGOZ1ydPvme8jy12I3Y3wll2CWkM8IEuh7L0oI4A==
X-Received: by 2002:a05:6e02:1a84:b0:374:5641:bb8f with SMTP id e9e14a558f8ab-3745641be1emr75563985ab.27.1716921774312;
        Tue, 28 May 2024 11:42:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaU/zRAeXJ2LyHBGjCFh4fLUqJ9164ighhCyGDJxOwCOu9pgoeBcg44g9d/rGkbA3Xv3Ch9w==
X-Received: by 2002:a05:6e02:1a84:b0:374:5641:bb8f with SMTP id e9e14a558f8ab-3745641be1emr75563765ab.27.1716921773552;
        Tue, 28 May 2024 11:42:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b107766667sm290672173.79.2024.05.28.11.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 11:42:52 -0700 (PDT)
Date: Tue, 28 May 2024 12:42:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
 <ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240528124251.3c3dcfe4.alex.williamson@redhat.com>
In-Reply-To: <Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
	<20240523195629.218043-3-alex.williamson@redhat.com>
	<Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
	<Zk_j_zVp_0j75Zxr@x1n>
	<Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 May 2024 09:47:03 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:
> > Hi, Yan,
> > 
> > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:  
> > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:  
> > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > device BARs, which removes our vma_list and all the complicated lock
> > > > ordering necessary to manually zap each related vma.
> > > > 
> > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > corresponding to BAR mappings.
> > > > 
> > > > This also converts our mmap fault handler to use vmf_insert_pfn()  
> > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > 
> > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > the result from this lookup, which might not prevent others from reserving the
> > > PFN to other memory types.  
> > 
> > I didn't worry too much on others reserving the same pfn range, as that
> > should be the mmio region for this device, and this device should be owned
> > by vfio driver.
> > 
> > However I share the same question, see:
> > 
> > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > 
> > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > that's also the default.  But I do also feel like there's something we can  
> Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> (or the variant driver) opts to use WC for certain BAR as mem type in future.
> Not sure if it will be true though :)

Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
needs to make sure the PCI BAR region is requested before the mmap,
which is tracked via the barmap.  Therefore the barmap is always setup
via pci_iomap() which will call memtype_reserve() with UC- attribute.

If there are any additional comments required to make this more clear
or outline steps for WC support in the future, please provide
suggestions.  Thanks,

Alex

[1]https://lore.kernel.org/all/BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com/

> > > Does that matter?  
> > > > because we no longer have a vma_list to avoid the concurrency problem
> > > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > > huge_fault handler to avoid the additional faulting overhead, but
> > > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > > >
> > > > Also, Jason notes that a race exists between unmap_mapping_range() and
> > > > the fops mmap callback if we were to call io_remap_pfn_range() to
> > > > populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> > > > before it does vma_link_file() which gives a window where the vma is
> > > > populated but invisible to unmap_mapping_range().
> > > >   
> > >   
> > 
> > -- 
> > Peter Xu
> >   
> 


