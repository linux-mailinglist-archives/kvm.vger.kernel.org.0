Return-Path: <kvm+bounces-24330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A5D953ACE
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 21:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5875C1C20DF7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4A77DA73;
	Thu, 15 Aug 2024 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L9BE+/io"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D319BA53
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 19:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723749643; cv=none; b=ex4ul09SZzddXiYiD/hDbj89hG8j/EGTbNHoaosnp6AqF7HILdHUEbcv9mEiWh5+7Wm1gydhUbpXuGDNUluoBdfI7syYoYZ5HbFIKSfEfk4BERyNJpcQTIvD+LXm+RpE6gu1RojOSLDtaKF4m3ETJlnlSlxJ2cTNivPez8y8J1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723749643; c=relaxed/simple;
	bh=GE/hnbfYUn8fmUyXpMOkkkPkKY+6QjaFve5xgWbEj5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnWOdO8vVBqMN27elm32AL27I5SvLflb2mLudPQaX56xanTiqKSMBguHG+uRGJfSk3yKPH39CEpoN3t5lrab+xe722RrJBnQLGplQemOmhDHqf9HIwdU79mlCZqpaeQp55NLuSREy5sJBQ2wMU/C/pXoQ4rIFWmWM24jzQur2eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L9BE+/io; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723749641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hN3cWnGeWKQo07EqYMNPRxi9dbHHJOKA4fs/GpZzU4w=;
	b=L9BE+/ioC/FHxOhLEc6x6p0qPeF9x5FIGcKtIgkPCIv9po+JJ8r94XoQ/JHl+C5/YTwxPm
	yqaXq41RnPJJGon+BdE/cusGJoTNdKO8Td3z4AJsih2FjMVwbW8J1p6VX9jNffJDKQh28V
	jMulnB+1p3D+vOymSN5Pa117sAG8pys=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-eVwvXMd7PMS_VGVfHxnvDw-1; Thu, 15 Aug 2024 15:20:39 -0400
X-MC-Unique: eVwvXMd7PMS_VGVfHxnvDw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-44fe325cd56so1830301cf.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 12:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723749639; x=1724354439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hN3cWnGeWKQo07EqYMNPRxi9dbHHJOKA4fs/GpZzU4w=;
        b=PQoCVNbzHpXlkm+JZfpF6FCALwqgNzEmDpXUKIR1BfQvxG6Bjz3QgvcCjWYtH6Ff06
         9XnTNYdBwnCY1mBTpXYQonOCSv8pVMUzcpkF94ZFpg2QqMrDbz9CsD6104H9wcLWbVm0
         S/hNsE4VAqU9qaKyISmNDVkmEldptbK6jtW0AIvOUGXDnPRPN8UeM6pG2JLaOIf//DZ4
         DSqFhn6rrkcUKV7eY83O7juLEV9P98WYw2bquJ0xoU6L4j3SShWgfSkLAkD6MCayheWp
         /cnlGn9zMi7JZOgMzgFXgt7KdIm1v2APliSydtT5ycjchplNYdZ31/O61UN7tcPyAoHF
         OmpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEk5F6pNJAt0TmzWFqCWwooIPd6Pli8DoSPGv/1kSoXQG1ugVSqqeNEMomKJ70zK0NBPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG2n86poE9kaEMgvQPTc9L5z28FAfgBr0yuAJtd+2bFv0r9W3i
	nzxAHPLqmIDGjKfz8BvTboVL9MHCTmM9xLBXDhqrBF4JB5fgwkSqrwjIHs71pngTuBmvnzB60tY
	fpw9EmPkrmNgIeUXho1MJ3KRUbqW5zTRJJgIYoqqHO4XQb2nKtQ==
X-Received: by 2002:a05:620a:4153:b0:7a2:1c0:37b5 with SMTP id af79cd13be357-7a50693d38fmr45572285a.4.1723749639332;
        Thu, 15 Aug 2024 12:20:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFojTZh/htiiNcOeQoBS1xVpbX6xb2lxm+nPbSup4gW+eZznV4PZFeir1x4wegN1uR+lXAZRg==
X-Received: by 2002:a05:620a:4153:b0:7a2:1c0:37b5 with SMTP id af79cd13be357-7a50693d38fmr45569585a.4.1723749638927;
        Thu, 15 Aug 2024 12:20:38 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff055ae8sm90637485a.51.2024.08.15.12.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 12:20:38 -0700 (PDT)
Date: Thu, 15 Aug 2024 15:20:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <Zr5VA6QSBHO3rpS8@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814123715.GB2032816@nvidia.com>

On Wed, Aug 14, 2024 at 09:37:15AM -0300, Jason Gunthorpe wrote:
> > Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.  
> 
> There is definitely interest here in extending ARM to support the 1G
> size too, what is missing?

Currently PUD pfnmap relies on THP_PUD config option:

config ARCH_SUPPORTS_PUD_PFNMAP
	def_bool y
	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD

Arm64 unfortunately doesn't yet support dax 1G, so not applicable yet.

Ideally, pfnmap is too simple comparing to real THPs and it shouldn't
require to depend on THP at all, but we'll need things like below to land
first:

https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com

I sent that first a while ago, but I didn't collect enough inputs, and I
decided to unblock this series from that, so x86_64 shouldn't be affected,
and arm64 will at least start to have 2M.

> 
> > The other trick is how to allow gup-fast working for such huge mappings
> > even if there's no direct sign of knowing whether it's a normal page or
> > MMIO mapping.  This series chose to keep the pte_special solution, so that
> > it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
> > gup-fast will be able to identify them and fail properly.
> 
> Make sense
> 
> > More architectures / More page sizes
> > ------------------------------------
> > 
> > Currently only x86_64 (2M+1G) and arm64 (2M) are supported.
> > 
> > For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
> > on 1G will be automatically enabled.
> 
> Oh that sounds like a bigger step..

Just to mention, no real THP 1G needed here for pfnmaps.  The real gap here
is only about the pud helpers that only exists so far with CONFIG_THP_PUD
in huge_memory.c.

>  
> > VFIO is so far the only consumer for the huge pfnmaps after this series
> > applied.  Besides above remap_pfn_range() generic optimization, device
> > driver can also try to optimize its mmap() on a better VA alignment for
> > either PMD/PUD sizes.  This may, iiuc, normally require userspace changes,
> > as the driver doesn't normally decide the VA to map a bar.  But I don't
> > think I know all the drivers to know the full picture.
> 
> How does alignment work? In most caes I'm aware of the userspace does
> not use MAP_FIXED so the expectation would be for the kernel to
> automatically select a high alignment. I suppose your cases are
> working because qemu uses MAP_FIXED and naturally aligns the BAR
> addresses?
> 
> > - x86_64 + AMD GPU
> >   - Needs Alex's modified QEMU to guarantee proper VA alignment to make
> >     sure all pages to be mapped with PUDs
> 
> Oh :(

So I suppose this answers above. :) Yes, alignment needed.

-- 
Peter Xu


