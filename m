Return-Path: <kvm+bounces-17986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A848CC81C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E07421F222FA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB207146A67;
	Wed, 22 May 2024 21:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOaFheRZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A9E76048
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412905; cv=none; b=st2eNnaRtwE53ZGHJsNwt7QXsMQxbjDsyq7Rcq+FJC5JiLe6saMBv6/bM95RTlBrP3c5ifxTspEF4+RBaShvPzPteKVkago5UB5OVXXsA4hZ2QnfURG+t8rMawmyQDmJrc7nZISDi5CVjR+ZvPfEMWfHzpk8AhTqWiA7hQWB59Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412905; c=relaxed/simple;
	bh=Qz9tt6pR5oDF6TcAN7hxYGGPefSmU4S9CgeaMIOuHpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGzVNXvdm7hv4EDdYnMiCqkiB22KUvdoUUlIRwYwADuN29HIMepOnR27ydXES1AxebatkHJUA2UbS/YDscI+XEkBBmzGZc6dfmIjRE6eced9D04o85F9cGXxPcSBoA3li8pFpBklVvW7tIPnsMtqLGhJLzRsqFR0a473SrH2H7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOaFheRZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716412902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/BUu4duYYbCSIQnv0ATgpzH3sdluqP4G2MqncwvuYRY=;
	b=FOaFheRZj1rSbwmUDDaOyUUkRT0GfJkvDHcYhcya1SpYMtCxkcP/aliAczzrflMqW8rPOR
	mDtGhmNUia3+SIVYPQvW5oT5UI007Q5ArgwToDDs3zG2EIM9pfKXuhD1+mC7NBXFEbmsVH
	2DergJ+mhkEC6j4RPJ0GWQJvnS0S2TI=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-lJRg-21fO5iQGgNVPPfr6g-1; Wed, 22 May 2024 17:21:41 -0400
X-MC-Unique: lJRg-21fO5iQGgNVPPfr6g-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5b27bd802a7so104832eaf.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 14:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716412900; x=1717017700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BUu4duYYbCSIQnv0ATgpzH3sdluqP4G2MqncwvuYRY=;
        b=QrYOgoqLBVxtDT1kj2AnSEez8e0JYtPDqJuP37dm4FK5b2NhbRNy+XVt1syXr9zIil
         SIOYAdKSghPUcM6yNeC/3ICWJUlfmk+i7e1SCSbQrajpWpfV6mbDe33Qf+V2/6jyfWmt
         5ZhMTgITK4DXlcO2l5y0LGSYeymRL4sTqU0yVAholPgRw8sPwjxGYiWQqC4E8j7Euogd
         uTnME3wtYVepXexxxlrAUD1OM7y6ZyWIaYMB1MQolbWd3c8uFfjVTF3IykSvq09fcp0R
         3cL4WiamphDv6WEZ4x8UqShhAtrTMeenHSZq+RvySKFJzWnZiSn+ge94sdjatBXfFh2A
         6FCg==
X-Forwarded-Encrypted: i=1; AJvYcCVd2+9GBHbV64vD0/Bra06qmOWP08W0TDUD4xcewM71eHbV8ygb5VfpJpoLUzk+3QH9fcGVDSIM/t23O2duFI4raH9z
X-Gm-Message-State: AOJu0YwIxsexjixFcZT/5eFxsXcJBMTteALaevWWqcQVNzGoXEn6pbTe
	kWM8+H321LKxPgaFzQAxIQdb8kdA49cYQQoHm2teAAPNcADhlZr+gOJMkOF3nN0eVVtLZWtsRnv
	8tKFEztKyCI7agz/r2nby907yqAjUC5GXOGpK9v0E+zRZReGySfIEH7Tyog==
X-Received: by 2002:a05:6358:9489:b0:192:5236:b1d9 with SMTP id e5c5f4694b2df-1979193b80fmr316852355d.2.1716412899933;
        Wed, 22 May 2024 14:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwmCqt+xh/cZzgdi3/vI+4gv7akS2ZD5pP2sH4xzmrmjQTtwWo7DH2HtQpg4Y2yNagbT5Nkg==
X-Received: by 2002:a05:6358:9489:b0:192:5236:b1d9 with SMTP id e5c5f4694b2df-1979193b80fmr316848555d.2.1716412899113;
        Wed, 22 May 2024 14:21:39 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6aa3280f16fsm36409786d6.12.2024.05.22.14.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 14:21:38 -0700 (PDT)
Date: Wed, 22 May 2024 17:21:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, Yan Zhao <yan.y.zhao@intel.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kevin.tian@intel.com, jgg@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <Zk5h3yfuZzlo2VzN@x1n>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <20240522-b1ef260c9d6944362c14c246@orel>
 <20240522115006.7746f8c8.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240522115006.7746f8c8.alex.williamson@redhat.com>

On Wed, May 22, 2024 at 11:50:06AM -0600, Alex Williamson wrote:
> I'm not sure if there are any outstanding blockers on Peter's side, but
> this seems like a good route from the vfio side.  If we're seeing this
> now without lockdep, we might need to bite the bullet and take the hit
> with vmf_insert_pfn() while the pmd/pud path learn about pfnmaps.

No immediate blockers, it's just that there're some small details that I
may still need to look into.  The current one TBD is pfn tracking
implications on PAT.  Here I see at least two issues to be investigated.

Firstly, when vfio zap bars it can try to remove VM_PAT flag.  To be
explicit, unmap_single_vma() has:

	if (unlikely(vma->vm_flags & VM_PFNMAP))
		untrack_pfn(vma, 0, 0, mm_wr_locked);

I believe it'll also erase the entry on the memtype_rbroot.. I'm not sure
whether that's correct at all, and if that's correct how we should
re-inject that.  So far I feel like we should keep that pfn tracking stuff
alone from tearing down pgtables only, but I'll need to double check.
E.g. I at least checked MADV_DONTNEED won't allow to apply on PFNMAPs, so
vfio zapping the vma should be the 1st one can do that besides munmap().

The other thing is I just noticed very recently that the PAT bit on x86_64
is not always the same one.. on 4K it's bit 7, but it's reused as PSE on
higher levels, moving PAT to bit 12:

#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
#define _PAGE_BIT_PAT		7	/* on 4KB pages */
#define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */

We may need something like protval_4k_2_large() when injecting huge
mappings.

From the schedule POV, the plan is I'll continue work on this after I flush
the inbox for the past two weeks and when I'll get some spare time.  Now
~160 emails left.. but I'm getting there.  If there's comments for either
of above, please shoot.

Thanks,

-- 
Peter Xu


