Return-Path: <kvm+bounces-49887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9547ADF334
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 18:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6641BC3A83
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 16:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726D82DBF4C;
	Wed, 18 Jun 2025 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qa/S0mlj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD02FEE1D
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750265775; cv=none; b=XajjwCPS+rRBJ8sWiCCpUwG9P4wCgYR7RP4Pr8rntyGuCgopYXTcq24JIIxE8bbKF/KXW+KzXAzI9THKfhyUngoln80XaclfKd5w+XYn1es5xKY3SIXDoZPbS26QheF4mKtZWaYTPHidZudSNLDFhsyhgwXAHo/+wKE5FWVzbyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750265775; c=relaxed/simple;
	bh=ZQ7TZDVrBgNtqQuxb0S8bzpBJPAqpK2vYsj6v9u8ekI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tubQ6R6vrFUUH3Wb1MfIWHXWcEP4rlLtytBLRgU3eWOuyApkdYc7WhlXPf0UBEPMPT/4wSfR17HKfqJYqboDtkSeoIDjnvIKp+O5PRVKQf/oGzWXVRbW7gxM6ggjFjo2CawdK4bUvTNOI9BF5WWSXEtODF90cPek5yzl7tO0c3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qa/S0mlj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750265772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fIqJPx+hVdZ6VMZuVeGfPGA+dF/0vqGtCkRLpRZfMd8=;
	b=Qa/S0mljL8XEIroa97GmknigcqxW6CT+KkVVwjuS5rsPneV6o50WaK+9ZvzuTmHxPBUUJ8
	ABGvQ5zIJxVXaaN9MH3maOCCLu1ok50dRU30YIMl5iM4MTsegwidhPYB2XHKEyxcQ1zJ8P
	STRoSQLgFBi0yc5+l930Uf+XTNWKSz4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-ONZcLyoZMgGfmrpOc1ZMzg-1; Wed, 18 Jun 2025 12:56:08 -0400
X-MC-Unique: ONZcLyoZMgGfmrpOc1ZMzg-1
X-Mimecast-MFC-AGG-ID: ONZcLyoZMgGfmrpOc1ZMzg_1750265768
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-748475d2a79so5277062b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 09:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750265768; x=1750870568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIqJPx+hVdZ6VMZuVeGfPGA+dF/0vqGtCkRLpRZfMd8=;
        b=CToJ7izsk7GE2BkfOzvJtZTEA/WT2EuxyjJlQGBrnoQImDt8xy3aW8T0TBeu4o3daG
         lQ2diwmfj6ct9nQB6vQjSu+cRj0IeryBY2+XkG9us6g/Mznde9zs7Ij/wqw4LgBdEZIN
         Z00v2dSH8wU0CcfQwJ50KJ5sEEdNZAa4ThYxZTEoXOEVjr3Ro1RRdu46huv/ih/fuXrJ
         JipU9TM4gmD2fo4xeeghB5puzrIaBj+iRdjak5GDP1NAyh95NROTgzTu0qoLRufQ0x8z
         NcsxHzPDd+DmiMEdb1yrmBRNzumG4RJjjBn6aJQ9uZgVJWneyTbqh2LnCpyPpPCuHddT
         6n4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUb/qsmA4y3HmncFIxMozfhbx+hSe5jlAdnfgMKL8dgu+e2WSLY+2RZEo16PrLgat5CXLI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0oPpKLN3XHvoSIoAMqxTmS16fVaMOT8ZzenLVKVo9d8Y5lKE8
	fBsbRN46KUEzotgUBmWytDSlRybtpNQwNyeXOVvk1lz8QuB/ahlDKsgD9enpX+dfaYUjSAMSsQi
	7NP/DIa2Unk8TY034qeZ1PVGebTFivt3heR5hGseSg5nA3Z/mDyBsxg==
X-Gm-Gg: ASbGncv3ftq67ip7dV2Qydgct5eoEdshbTwrBfXaZTh/d1OHqMJhJUod/IusO5luptv
	Xm1gnx6QJ7qld2AxdD8ZE/aRNq1qmqiuZGg8aPYIGCjLRgPO4QDSsjSgMciaPEZlD6Unc1lLNfN
	+ey5xw4FherNfAAb3hzmZPwNAZ+EfIyDgpiLyu+KTGE9XvAKhw6iN9GXI+VooRehDb4EvLLwmkF
	mjymlgn04L091u1QnrIcA9ucEce/bOeDguIniAu8iDrrTXeb6N5HA2Xpj/sdfvI4+LBTY30M3x6
	ElGHWktQkePYLA==
X-Received: by 2002:a05:6a00:ac9:b0:748:2d1d:f7b7 with SMTP id d2e1a72fcca58-7489cffa98cmr25566529b3a.21.1750265767692;
        Wed, 18 Jun 2025 09:56:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIZUhEBIr4xiQwMA9O2tUbBgljMCpveJ7muzyq6G0/d5NeOKpjfbruv0BtTaIQsdL6oXmf/A==
X-Received: by 2002:a05:6a00:ac9:b0:748:2d1d:f7b7 with SMTP id d2e1a72fcca58-7489cffa98cmr25566487b3a.21.1750265767230;
        Wed, 18 Jun 2025 09:56:07 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7488ffec9c6sm11280298b3a.9.2025.06.18.09.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 09:56:06 -0700 (PDT)
Date: Wed, 18 Jun 2025 12:56:01 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aFLvodROFN9QwvPp@x1.local>
References: <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aFH76GjnWfeHI5fA@x1.local>

On Tue, Jun 17, 2025 at 07:36:08PM -0400, Peter Xu wrote:
> On Tue, Jun 17, 2025 at 08:18:07PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 17, 2025 at 04:56:13PM -0400, Peter Xu wrote:
> > > On Mon, Jun 16, 2025 at 08:00:11PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Jun 16, 2025 at 06:06:23PM -0400, Peter Xu wrote:
> > > > 
> > > > > Can I understand it as a suggestion to pass in a bitmask into the core mm
> > > > > API (e.g. keep the name of mm_get_unmapped_area_aligned()), instead of a
> > > > > constant "align", so that core mm would try to allocate from the largest
> > > > > size to smaller until it finds some working VA to use?
> > > > 
> > > > I don't think you need a bitmask.
> > > > 
> > > > Split the concerns, the caller knows what is inside it's FD. It only
> > > > needs to provide the highest pgoff aligned folio/pfn within the FD.
> > > 
> > > Ultimately I even dropped this hint.  I found that it's not really
> > > get_unmapped_area()'s job to detect over-sized pgoffs.  It's mmap()'s job.
> > > So I decided to avoid this parameter as of now.
> > 
> > Well, the point of the pgoff is only what you said earlier, to adjust
> > the starting alignment so the pgoff aligned high order folios/pfns
> > line up properly.
> 
> I meant "highest pgoff" that I dropped.
> 
> We definitely need the pgoff to make it work.  So here I dropped "highest
> pgoff" passed from the caller because I decided to leave such check to the
> mmap() hook later.
> 
> > 
> > > > The mm knows what leaf page tables options exist. It should try to
> > > > align to the closest leaf page table size that is <= the FD's max
> > > > aligned folio.
> > > 
> > > So again IMHO this is also not per-FD information, but needs to be passed
> > > over from the driver for each call.
> > 
> > It is per-FD in the sense that each FD is unique and each range of
> > pgoff could have a unique maximum.
> >  
> > > Likely the "order" parameter appeared in other discussions to imply a
> > > maximum supported size from the driver side (or, for a folio, but that is
> > > definitely another user after this series can land).
> > 
> > Yes, it is the only information the driver can actually provide and
> > comes directly from what it will install in the VMA.
> > 
> > > So far I didn't yet add the "order", because currently VFIO definitely
> > > supports all max orders the system supports.  Maybe we can add the order
> > > when there's a real need, but maybe it won't happen in the near
> > > future?
> > 
> > The purpose of the order is to prevent over alignment and waste of
> > VMA. Your technique to use the length to limit alignment instead is
> > good enough for VFIO but not very general.
> 
> Yes that's also something I didn't like.  I think I'll just go ahead and
> add the order parameter, then use it in previous patch too.

So I changed my mind, slightly.  I can still have the "order" parameter to
make the API cleaner (even if it'll be a pure overhead.. because all
existing caller will pass in PUD_SIZE as of now), but I think I'll still
stick with the ifdef in patch 4, as I mentioned here:

https://lore.kernel.org/all/aFGMG3763eSv9l8b@x1.local/

The problem is I just noticed yet again that exporting
huge_mapping_get_va_aligned() for all configs doesn't make sense.  At least
it'll need something like this to make !MMU compile for VFIO, while this is
definitely some ugliness I also want to avoid..

===8<===
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 59fdafb1034b..f40a8fb64eaa 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -548,7 +548,11 @@ static inline unsigned long
 huge_mapping_get_va_aligned(struct file *filp, unsigned long addr,
                unsigned long len, unsigned long pgoff, unsigned long flags)
 {
+#ifdef CONFIG_MMU
        return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+#else
+       return 0;
+#endif
 }

 static inline bool
===8<===

The issue is still mm_get_unmapped_area() is only exported on CONFIG_MMU,
so we need to special case that for huge_mapping_get_va_aligned(), and here
for !THP && !MMU.

Besides the ugliness, it's also about how to choose a default value to
return when mm_get_unmapped_area() isn't available.

I gave it a defalut value (0) as example, but I don't even thnk that 0
makes sense.  It would (if ever triggerable from any caller on !MMU) mean
it will return 0 directly to __get_unmapped_area() and further do_mmap()
(of !MMU code, which will come down from ksys_mmap_pgoff() of nommu.c) will
take that addr=0 to be the addr to mmap.. that sounds wrong.

There's just no way to provide a sane default value for !MMU.

So going one step back: huge_mapping_get_va_aligned() (or whatever name we
prefer) doesn't make sense to be exported always, but only when CONFIG_MMU.
It should follow the same way we treat mm_get_unmapped_area().

Here it also goes back to the question on why !MMU even support mmap():

https://www.kernel.org/doc/Documentation/nommu-mmap.txt

So, for the case of v4l driver (v4l2_m2m_get_unmapped_area that I used to
quote, which only defines in !MMU and I used to misread..), for example,
it's really a minimal mmap() support on ucLinux and that's all about that.
My gut feeling is the noMMU use case more or less abused the current
get_unmapped_area() hook to provide the physical addresses, so as to make
mmap() work even on ucLinux.

It's for sure not a proof that we should have huge_mapping_get_va_aligned()
or mm_get_unmapped_area() availalbe even for !MMU.  That's all about VAs
and that do not exist in !MMU as a concept.

Thanks,

-- 
Peter Xu


