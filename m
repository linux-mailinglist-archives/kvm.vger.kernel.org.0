Return-Path: <kvm+bounces-66077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 195E3CC4062
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3D4D3042834
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4032B369970;
	Tue, 16 Dec 2025 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfJlJkg2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwMzBvMq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D77436921B
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765899777; cv=none; b=km2nyCDE8YYmdm5+/w+Yj79WymTICa3kGve+bi3Fr0ce9G1mP9FzQfgITMn3Snj8h07FFMphRFguBAqf92oNx7GsjygCO3kIca1a8utHgXn9lwFXXSuZ2IPulNONnsPnVPukalCkvo6XjbhopowUi1QCZJAuLXJCFac27ANB3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765899777; c=relaxed/simple;
	bh=vcO6HszvwJxaLe/TLAMxB7qkLbIRFDw6Qyk1sxR8iy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwFWbSJdV/Zln5fIDSlxCoxwgO5CsuaY4sM4JiUUR7xVb71cCZdKT9Kn/1Qwj7eQNjQaKFGpPfcmOxKANWajJNpbu8ekfbKfIg1LOY8EKYZFPImGcLzaSZavQP++Q9pyLJn5JSF19ZqPtTXXEALtg5OHEFKn0pB03vtqDabKdRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfJlJkg2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QwMzBvMq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765899774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
	b=PfJlJkg2WEErTavn4vJ7ROusSpZ2urA2588iH95X3BBQ35C5YXl6yh1FIX3WYs48QCyfjC
	0Orz/pD+KUgF2CjXRKfMnS/4X5+CbKwz9Spp422wdfpmMsyOZAi+0orjPOCmu/1DfostPD
	AwmZeos+Kol92knMmxuiCf9pL0zyrf4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-dN8ny-CJNNSRW4u1Lqjw4Q-1; Tue, 16 Dec 2025 10:42:52 -0500
X-MC-Unique: dN8ny-CJNNSRW4u1Lqjw4Q-1
X-Mimecast-MFC-AGG-ID: dN8ny-CJNNSRW4u1Lqjw4Q_1765899771
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7ae3e3e0d06so3973721b3a.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 07:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765899771; x=1766504571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
        b=QwMzBvMqJuZ+4YBPJysefAwOXenrC5Pn1lDgB3XLmjquaJiLJjEfTJQJlyVK2iUif+
         8Dh1/wZU1CLV1Kvq+zqT22vPYGuPFDw6R9aEr3bpOkfviE/sb4LPT9X4+sHK0LhSjCq2
         hcm73bqza4IXE0BZEEBDQWbsC/Gs7ZmMyfQJuLAOZ4lMUAhKZWBxpxWZFYqrqYSRTvsr
         Bsa/AIq3B/IXrq1nwW0XZvduunYx5PEXC5Z2E5nt/2dE1ZNVoBYBqxI8HjWBMJxeZVFZ
         ijAmIH820Tt9XBewv17IOXV3yAUWdU3JINFDEDK0igCh62o1Ji0/p8vi35SxD4jGmVbh
         UizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765899771; x=1766504571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
        b=Pd3tCTx0Dw+4vmpIrnKBS+k/Q6PMcCQ4IrGJvfXNdxScb3ShbUtK6MmmqxD5LL4IOB
         KEJ1GQsQHZ/EoyOZ1AviijvvsWT7eekJLj2fRllTr0dAJiiHPeMrV4dwx6Nx6NujNuhj
         GQaJ5CdNdjVsYDDKUFubHNd60Q4/qMrrzqMp8FDsd5lbT0IRtiFu1SPzcu3/XbD5xGvr
         pU7oj7c9f2gGmzAxvnivSh7CHGS0SrElQgyQYmnZ6kpHj0l2GUbkBkr0x9cmVsZLBE/9
         jMi9Op/I5PkWKAdd8xKbZ8Q5bZt6gTO7Zp4ahRzDAptseFKgEExa9FemvCAGVn1YIvyw
         vMJQ==
X-Gm-Message-State: AOJu0YzNW27zH5mJwk/65BkMm0YVSml6gimAZ6YligReQvXAblxcIg8c
	9gmMMoEXuDsdYU9ifKLtYkqandPAE91JX750eYDJvUVSOydFDWChiUu9Gc046zzvTXT0ywb9Or/
	g5AXepRHuUc2UAA07rYbZUKvX4nzHdDNW/M4yzoL5yiTw+SQseLc/7w==
X-Gm-Gg: AY/fxX7VHvkkfT/o6DldYKe55K1qXbB2PMIRWML+Dd8QVnCZi+kgyjRGq/qIbave7WZ
	lYepHT/q5vC0/dg3NSA7VuOPQFwKlQNin4DLd5NYO1Qo57jyhnk31FWl+MsoMM9BsnsZHlFRkXE
	n6X2LP19oPCyGwTf/+wEgaDXMAACZitMJr/I79j2sA2C5hvZbf00Bg93U+lN/LiYV00Qo/g+pUN
	dm7r7qmtk+qC9hRsURFTGGU6wDdWBuSx8fzO566WrmTxfGHK1XQ5TL55gM+BZbH2or9r/a51f7k
	Ra+33jLUc4IikRP4owOn7QRm3B3MpwhW2oJ9j3ZVV0UmwsefD/xrzifighr0UWfPanmcW6hAQNh
	dEj8=
X-Received: by 2002:a05:6a00:f0d:b0:7aa:ac12:2c2e with SMTP id d2e1a72fcca58-7f667d17b97mr13569092b3a.25.1765899771114;
        Tue, 16 Dec 2025 07:42:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLCCVgc3/X1w3LsrtnhDoEJCb55PbVIq0LxCDKAJ9JaT01nvcCM+COudpJkrEncaDLaUIQCQ==
X-Received: by 2002:a05:6a00:f0d:b0:7aa:ac12:2c2e with SMTP id d2e1a72fcca58-7f667d17b97mr13569056b3a.25.1765899770643;
        Tue, 16 Dec 2025 07:42:50 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5481289sm15994024b3a.64.2025.12.16.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 07:42:50 -0800 (PST)
Date: Tue, 16 Dec 2025 10:42:39 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUF97-BQ8X45IDqE@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251216144427.GF6079@nvidia.com>

On Tue, Dec 16, 2025 at 10:44:27AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 10, 2025 at 03:23:02PM -0500, Peter Xu wrote:
> > On Sun, Dec 07, 2025 at 12:21:32PM -0400, Jason Gunthorpe wrote:
> > > On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> > > > Add one new file operation, get_mapping_order().  It can be used by file
> > > > backends to report mapping order hints.
> > > > 
> > > > By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> > > > the driver can report the possibility of mapping chunks that are larger
> > > > than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> > > > when allocating the VA ranges.
> > > > 
> > > > This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> > > > VA alignment matters and it needs to be aligned with the size of the chunk
> > > > to be mapped.
> > > > 
> > > > Said that, no matter what is the alignment used for the VA allocation, the
> > > > driver can still decide which size to map the chunks.  It is also not an
> > > > issue if it keeps mapping in PAGE_SIZE.
> > > > 
> > > > get_mapping_order() is defined to take three parameters.  Besides the 1st
> > > > parameter which will be the file object pointer, the 2nd + 3rd parameters
> > > > being the pgoff + size of the mmap() request.  Its retval is defined as the
> > > > order, which must be non-negative to enable the alignment.  When zero is
> > > > returned, it should behave like when the hint is not provided, IOW,
> > > > alignment will still be PAGE_SIZE.
> > > 
> > > This should explain how it works when the incoming pgoff is not
> > > aligned..
> > 
> > Hmm, I thought the charm of this new proposal (based on suggestions of your
> > v1 reviews) is to not need to worry on this..  Or maybe you meant I should
> > add some doc comments in the commit message?
> 
> It can't be ignored, I don't think I ever said that. I said the driver
> shouldn't have to worry about it, the core MM should deal with this.
> 
> > > I think for dpdk we want to support mapping around the MSI hole so
> > > something like
> > > 
> > >  pgoff 0 -> 2M
> > >  skip 4k
> > >  2m + 4k -> 64M
> > > 
> > > Should setup the last VMA to align to 2M + 4k so the first PMD is
> > > fragmented to 4k pages but the remaning part is 2M sized or better.
> > > 
> > > We just noticed a bug very similer to this in qemu around it's manual
> > > alignment scheme where it would de-align things around the MSI window
> > > and spoil the PMDs.
> > 
> > Right, IIUC this series should work all fine exactly as you said.
> 
> Are you sure? I did not see code doing this. The second mapping needs
> to select a VA such that
> 
>   VA % 2M == 4k
> 
> And I don't see it doing that.

I have an old program tested this, I ran it but I didn't mention it in the
cover letter.  I'm 99% sure it works like it, unless I'm seriously wrong
somewhere.

See:

https://github.com/xzpeter/clibs/blob/master/misc/vfio-pci-nofix.c

mmap BAR with memory ENABLED and read (offset=0x0, size=0x8000000)
mmap()=0x7f4395a00000 - 0.000117s
read(32768) - 0.085376s
mmap BAR with memory ENABLED and read (offset=0x1000, size=0x7fff000)
mmap()=0x7f4395a01000 - 0.000012s
read(32767) - 0.088642s
mmap BAR with memory ENABLED and read (offset=0x0, size=0x7fff000)
mmap()=0x7f4395a00000 - 0.000015s
read(32767) - 0.093850s
mmap BAR with memory ENABLED and read (offset=0x1000, size=0x7ffe000)
mmap()=0x7f4395a01000 - 0.000011s
read(32766) - 0.093248s

Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
with len_pad (not len), and pad the retval at last.

Please let me know if it didn't work like it, then it might be a bug.

Thanks,

-- 
Peter Xu


