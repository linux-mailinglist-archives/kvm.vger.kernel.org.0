Return-Path: <kvm+bounces-37021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37045A24623
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC15E1889E2F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4257A2A1AA;
	Sat,  1 Feb 2025 01:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ACGAWYwY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DD4BA45
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372770; cv=none; b=N+AkdjEHIjP48s1Je8CLksO2Ivk4o3g1TRQWtTkZf+2WF2hxv5SYv9qqkz0HlaPSTIlW0NWPe4SgMwWOhgaWvGGc682mecakH1lQC988lEd76fTVPEa4sdbMT7XpvRHZIOVz0CAiBSRRGjJ23xhyF/fdjfiFioos2P52NQnCUGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372770; c=relaxed/simple;
	bh=oWCwRVX3HiltEmJ0NJfrEKkEaikudV+HxZPQ1780JTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPYMLl78o1qXjP07Hh0FG5lBkW4wBNPmsqizOZBGdj0HBY8/mSQec4WD1GhpszizmU3TfaWS4rOA9nOhm8adNQwO7qEayX3kJ0lPqu02wM5rdHEcikjQApQ/SM4Q0NxUhTS9/2aksU2Z2t1xA+lq2hq+RXlxoV5ksJvXpMkbBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ACGAWYwY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738372767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iutb+f8svSiQJQKyELECXpPORtK9MA8lQS48vaY5V1E=;
	b=ACGAWYwYztduSD9NEg2ZaFuTlD97wQ4Z5qX80gWn9AX+FmzUkFYzOAXK+CbGHZfyRGX+YP
	BlCp+DT5+wdL5M4G1emdgFcsAby+PExFyfWlDteMA1AEaFQ/evUpEerKwpN3qEQESlJZm2
	l8IC1wHltLeT5CD1yZmti0gytUKfiC0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-5yS5bSVKM6GV3QqvkoRziw-1; Fri, 31 Jan 2025 20:19:25 -0500
X-MC-Unique: 5yS5bSVKM6GV3QqvkoRziw-1
X-Mimecast-MFC-AGG-ID: 5yS5bSVKM6GV3QqvkoRziw
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7be6ccb09f9so251337085a.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:19:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372765; x=1738977565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iutb+f8svSiQJQKyELECXpPORtK9MA8lQS48vaY5V1E=;
        b=ArxqL+ivFhsUrdFCAx0vJ/uz7QlGe7d0G5JRf4ulJ7cJ1i6aSZPc0cVx0P5B3ATPag
         p9RHEAHvh3b4vdvUoXb7dN3MSwWbHtrkicJVghdY6VtsoigqFsEx8CEBBFIjXXnM1LhX
         +X24KR+77kC9rS5uue4emFuMTVXFQo+rOPwenQfUTy5jGf7tIps9bHQt6U//9qXRAN/i
         or/JzF5h63OFvUyroLeWHBSCku8dYcJ+y6QLkUn0jbsP4fRtSq6eTiE5i9vjkueQPGvw
         tyRE8hFPCRE1KHLBaa6JcvZdurfhx9J58k9FVbfPWyTvfP9encmvEqooRLUQF4Vg04yI
         IqhA==
X-Forwarded-Encrypted: i=1; AJvYcCVfsMDpm1Dvu/+HLczVrFeU6V4d47iBH9QsXA6KEWKPWUvHmSGlGsi5lY7DZB/hp/hIDlw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrmcl0g+73DAuSzFFZ3BQfJe5hUjBtpVskTL6qPVSSJbHEvSGe
	TXCfA5L+04cODoTkFsuiu5XTZqr6fzvUoiRilOW+X0aY3XnQzESdKfdV7GGgrXrbSdC2qnS8t3I
	b8jSPdMpqa+otelGifWaxanVoHW8w07juESOWhZJ2oOKDLcBF9g==
X-Gm-Gg: ASbGncvDAUwBayP0eXvRO3F4UtOcUdemHvRlEUAULHM3y5XhGI8fq2ycg5Hv8Il52uQ
	L1X71rVs+Do8s9lQ7yncZ/4Bl3hSAcSDZxvdVnlnuQGXEX6n+lb3Pta+sgAZbDrCFEKscAO9RHU
	j0t/LbMxl7YZDTfShK5BZ8Tv/qx6EPbt8Sh7cds5+jBSA5DRxF23NhITplEC9Rn7tNcRIGi1UH0
	szbYZ/vTQlykHCXArCjh/ZeYn24htU2rovaIEBY6Tre7TE7Cg7jLK2K2nFBJ6KIUIkyrn9ba/ee
	fGzMyXBM+dHmE00/PxSEJUa1Qq1Oux920NQcgZVsrcZq07Xt
X-Received: by 2002:a05:620a:4304:b0:7b6:6bff:d13f with SMTP id af79cd13be357-7bffcd901abmr1890779485a.42.1738372764909;
        Fri, 31 Jan 2025 17:19:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1bH00mv1WK4WNu1gZToSc4hfDszMAYhLI2X7IUvKosEz+tCfK4Su+RxkyQl3oxUQfYV1vGw==
X-Received: by 2002:a05:620a:4304:b0:7b6:6bff:d13f with SMTP id af79cd13be357-7bffcd901abmr1890776885a.42.1738372764552;
        Fri, 31 Jan 2025 17:19:24 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a9047c0sm248232585a.86.2025.01.31.17.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 17:19:23 -0800 (PST)
Date: Fri, 31 Jan 2025 20:19:22 -0500
From: Peter Xu <peterx@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults
 for files with pre content watches
Message-ID: <Z512mt1hmX5Jg7iH@x1.local>
References: <cover.1731684329.git.josef@toxicpanda.com>
 <9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
 <20250131121703.1e4d00a7.alex.williamson@redhat.com>
 <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>

On Fri, Jan 31, 2025 at 11:59:56AM -0800, Linus Torvalds wrote:
> On Fri, 31 Jan 2025 at 11:17, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > 20bf82a898b6 ("mm: don't allow huge faults for files with pre content watches")
> >
> > This breaks huge_fault support for PFNMAPs that was recently added in
> > v6.12 and is used by vfio-pci to fault device memory using PMD and PUD
> > order mappings.
> 
> Surely only for content watches?
> 
> Which shouldn't be a valid situation *anyway*.
> 
> IOW, there must be some unrelated bug somewhere: either somebody is
> allowed to set a pre-content match on a special device.
> 
> That should be disabled by the whole
> 
>         /*
>          * If there are permission event watchers but no pre-content event
>          * watchers, set FMODE_NONOTIFY | FMODE_NONOTIFY_PERM to indicate that.
>          */
> 
> thing in file_set_fsnotify_mode() which only allows regular files and
> directories to be notified on.
> 
> Or, alternatively, that check for huge-fault disabling is just
> checking the wrong bits.
> 
> Or - quite possibly - I am missing something obvious?

Is it possible that we have some paths got overlooked in setting up the
fsnotify bits in f_mode? Meanwhile since the default is "no bit set" on
those bits, I think it means FMODE_FSNOTIFY_HSM() can always return true on
those if overlooked..

One thing to mention is, /dev/vfio/* are chardevs, however the PCI bars are
not mmap()ed from these fds - whatever under /dev/vfio/* represents IOMMU
groups rather than the device fd itself.

The app normally needs to first open the IOMMU group fd under /dev/vfio/*,
then using VFIO ioctl(VFIO_GROUP_GET_DEVICE_FD) to get the device fd, which
will be the mmap() target, instead of the ones under /dev.

I checked, those device fds were allocated from vfio_device_open_file()
within the ioctl, which internally uses anon_inode_getfile().  I don't see
anywhere in that path that will set the fanotify bits..

Further, I'm not sure whether some callers of alloc_file() can also suffer
from similar issue, because at least memfd_create() syscall also uses the
API, which (hopefully?) would used to allow THPs for shmem backed memfds on
aligned mmap()s, but not sure whether it'll also wrongly trigger the
FALLBACK path similarly in create_huge_pmd() just like vfio's VMAs.  I
didn't verify it though, nor did I yet check more users.

So I wonder whether we should setup the fanotify bits in at least
alloc_file() too (to FMODE_NONOTIFY?).

I'm totally not familiar with fanotify, and it's a bit late to try verify
anything (I cannot quickly find my previous huge pfnmap setup, so setup
those will also take time..). but maybe above can provide some clues for
others..

Thanks,

-- 
Peter Xu


