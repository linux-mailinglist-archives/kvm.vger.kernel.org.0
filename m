Return-Path: <kvm+bounces-17976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE8E8CC5D8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 678A9B216CA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E831142E6A;
	Wed, 22 May 2024 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vr13/J4Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C340657C8E
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400251; cv=none; b=tNdH6EQFiGGkjmjUM8nqzyCIqyRadqEm7Pqsc3yDAPbpbljARaOxM8b2mU6dM+EiAEl1FpgUPW+37FXjqsBSxjLgqH+eD81xgV3kKQuJ4xUGH7DZkqEXfkRpLG2yttbE1VMfxqFmZmPMK70nIC0tXjsBg64iXiWf5L12YDbrbOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400251; c=relaxed/simple;
	bh=QfISmEkAy2UikSDxMwxpFJ3XyRJv0rSWJAgpnmIP9Qo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyd082uvMOh7U1tOrqkqBa0NHmK0g0Pe88q8ThiQNAZq6dcjCVpxDD0xBSaTygdBj1lyjUsT/ANjyKk18xIxY4G7hPuH8AiBgg4xcS5kVa5TMN/nVjaibsVQmpfjQvKDT03AGtGhHM54mFFsdVF2OWehcdUE/IuzLUSjEo6ANFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vr13/J4Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716400248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilubpRsLuYr8UKrq5eND7D3nU7JKeM0zywpTQB+SWd0=;
	b=Vr13/J4ZWImX5RLN0ejXAA/bKzlfy4L/ud+Q8JYRe5Wrph+Ckb1SLt7T7ERcNrV8texVp3
	m4aglNJodZcjY6hL0H/pG924g0EHGPWrPVZsKCCt88u/XkWLgzwxsMg+Wka+m8aWJd1rcg
	UWL17ifgAza4l3ckIdBrCXSPqqZrwcY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-i3kESDNdP8y3TnjvBPxCmw-1; Wed, 22 May 2024 13:50:40 -0400
X-MC-Unique: i3kESDNdP8y3TnjvBPxCmw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36eb89514a7so10082615ab.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 10:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716400209; x=1717005009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilubpRsLuYr8UKrq5eND7D3nU7JKeM0zywpTQB+SWd0=;
        b=TUo8l94UlDRrVk2Gb/yzjq2YpF/h4QwGPebExgv1+5T+Z0VyuLJCn/b7KNDgKsH6Vd
         y2L3IKWbdQ2UXMtP8gJiiyrZ2EKXxLRPq2iTT/e9QLkM2ZEQ5AGeDN4rKZ/DGrZYvLGE
         JxcIL+CTaNt9SqGk9C6vEcwT4vzpHD892UrxKmIq/2ntJR/sflyqMH4eciPT05Zrjjrz
         Hw7/aA6OaOgs5DwhKz0zl1mpmBSecDglFYVkyJIkQI5Lwrwj9w95NfxmwW0d30nPLclN
         MwsOyGLArbcSovPuJ3WfShKvQAvDkyPsTUahXh7Qtd/sPFihXs+/KH+blHjPj8XsdzNe
         mWIA==
X-Forwarded-Encrypted: i=1; AJvYcCU6tXguzlgEYWryHa3R4lyGQE0SKJmRwIp7FGU7m0YPNz6UxCAVDwlWvR+ntNzNxnu29VZE6neTDdHyR+qT6CN9t9jC
X-Gm-Message-State: AOJu0YykmtDMQPUOwQmjVqWFLLftBA0kuLBNSGY7I0+SLwfAkmdMJFPZ
	YWfD+wMR/Hwe3Q6rNJ0MlCJ3/+V7G6CXKxq3Q1S5meSi3uTVdokwCdSKIyLUcRRpF+pi7fLdMEt
	NLzX4l4hsrEjp1iGPw/zFu2tV4WGE9kJG8aGui8Pf025kz03iKQ==
X-Received: by 2002:a05:6e02:1486:b0:36c:4c10:dc7a with SMTP id e9e14a558f8ab-371fa87e4demr29589845ab.17.1716400209192;
        Wed, 22 May 2024 10:50:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGO+onMVdyztjpr4/wGLfPQtx+lVEcSNXWuRgpWs1ZeH4h9AxTzdY5RVM/INjlUGv+knRs70g==
X-Received: by 2002:a05:6e02:1486:b0:36c:4c10:dc7a with SMTP id e9e14a558f8ab-371fa87e4demr29589615ab.17.1716400208811;
        Wed, 22 May 2024 10:50:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-48a2d42c8cesm4578870173.50.2024.05.22.10.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 10:50:08 -0700 (PDT)
Date: Wed, 22 May 2024 11:50:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, jgg@nvidia.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com, Peter Xu
 <peterx@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20240522115006.7746f8c8.alex.williamson@redhat.com>
In-Reply-To: <20240522-b1ef260c9d6944362c14c246@orel>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
	<20240522-b1ef260c9d6944362c14c246@orel>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hey Drew,

On Wed, 22 May 2024 18:56:29 +0200
Andrew Jones <ajones@ventanamicro.com> wrote:

> On Mon, May 08, 2023 at 08:58:42PM GMT, Yan Zhao wrote:
> > In VFIO type1, vaddr_get_pfns() will try fault in MMIO PFNs after
> > pin_user_pages_remote() returns -EFAULT.
> > 
> > follow_fault_pfn
> >  fixup_user_fault
> >   handle_mm_fault
> >    handle_mm_fault
> >     do_fault
> >      do_shared_fault
> >       do_fault
> >        __do_fault
> >         vfio_pci_mmap_fault
> >          io_remap_pfn_range
> >           remap_pfn_range
> >            track_pfn_remap
> >             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> >            remap_pfn_range_notrack
> >             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> > 
> > As io_remap_pfn_range() will call vm_flags_set() to update vm_flags [1],
> > holding of mmap write lock is required.
> > So, update vfio_pci_mmap_fault() to drop mmap read lock and take mmap
> > write lock.
> > 
> > [1] https://lkml.kernel.org/r/20230126193752.297968-3-surenb@google.com
> > commit bc292ab00f6c ("mm: introduce vma->vm_flags wrapper functions")
> > commit 1c71222e5f23
> > ("mm: replace vma->vm_flags direct modifications with modifier calls")
> >  
> 
> With linux-next I started noticing traces similar to the above without
> lockdep, since it has ba168b52bf8e ("mm: use rwsem assertion macros for
> mmap_lock"). Were there any follow ups to this? Sorry if my quick
> searching missed it.

We've been working on it in the background, but we're not there yet.  I
have a branch[1] that converts to an address space on the vfio device,
making unmap_mapping_range() available to easily zap mappings to the
BARs without all the ugly vma tracking, but that still leaves us with
the problem that the remap_pfn_range() shouldn't be called from the
fault handler resulting in this lockdep warning.  We can switch to
vmf_insert_pfn() in the fault handler, but that's a noticeable
performance penalty.

The angle I've been working recently is to try taking advantage of
huge_fault support because we do have vmf_insert_pfn_{pmd,pud}, but
these don't currently support pfnmap pfns.  I've been working with
Peter Xu as this aligns with some other work of his.  It's working and
resolves the performance issue, especially with a little alignment
tweaking in userspace to take advantage of pud mappings.

I'm not sure if there are any outstanding blockers on Peter's side, but
this seems like a good route from the vfio side.  If we're seeing this
now without lockdep, we might need to bite the bullet and take the hit
with vmf_insert_pfn() while the pmd/pud path learn about pfnmaps.
Thanks,

Alex

[1]https://github.com/awilliam/linux-vfio/commits/vfio-address-space/


