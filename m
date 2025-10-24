Return-Path: <kvm+bounces-61042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E9503C078DB
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7EEB54F32A4
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB93B345CAC;
	Fri, 24 Oct 2025 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YIxKOjvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D0324B34
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 17:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761327155; cv=none; b=DY2ve++hHPU3JhBLMzWZazsGrSR+PM7N7NpHoCvJTkxvM/xQQ7pSkmC0eYSaJeWfZ1nW9/I7VXvrze/O5vIrTOiHdjgAUM1rsYX8XqmQr5q9MWF6aiMJfn+69TtzkoJ2krvCME+r+6lhlwEFzRi/+pwj2m6ssP2xDwOGKbhbDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761327155; c=relaxed/simple;
	bh=UpAvej523gjBWiVNLg/BeJTlpEBeruOMQsLrtxPGcjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zwh626us30fdL4EzGSG6XthgmJgFvmz1O6HZ2os27peIgjoP6SHtsC/Cr5iuOFLKcfTixG8tBHjiOHGvlHo/4mcOe+Ngiw9jmFCj7xAqS/xOpmLPbj1GvScwFxR5Azvs6vtofuFd9v+kUPMmrJEr9ulWLSpxnJHwGRMhp7Ke3QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YIxKOjvZ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-89ed2ee36b0so25548585a.2
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 10:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761327152; x=1761931952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=68b/g5DOQEfyTkIlrk7BVq23q9O97J8PIirLY9E/558=;
        b=YIxKOjvZzvpj/k7qXRAnRBWIDBkC/oznFiyvfaOIcKDF07U4AepP8Nw5JcmEvUqde0
         EpwUflB25Mqv2Qcmi2nBiaTOMRSWH0j/9ytlAAZvOj8G10xETo30J0fsc/Ufxr4Qq5Lw
         ss3WOe/xkm9fpVGq7mxny2WXlW0I+zqosNr/aoTeggYRJcNxwWQiUA55f2kLuKroABjY
         QpHt014/fVwnwiuMxCtbU40diHYDYXIyk3cXX7XI4lABcUbrJmR33t80rayU5kdJS3tW
         Mcmn6LcPyc0L9Wlsn+bH40VQHBM2oHPU+p11Liq2TsD0eV4DmWnJdI6TDpfN1idM27fP
         WmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761327152; x=1761931952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68b/g5DOQEfyTkIlrk7BVq23q9O97J8PIirLY9E/558=;
        b=M/7ChwmK+NKSrEP7YlbRSVfYH99i6RJXHvOkSrJvGAGzR/Ye46xXrg4JfD/yhlcxrb
         N4tU0rWWcOiThXRjLuG6j1lHmc5EmyfVshZkCsQP2OwHU+cXyJQ3kKqRb6zlex6BVeP3
         fZg/yfcwzHCD2uLuNrdb+mF6MAOG9UAVvc1XWTp9Npqi9pCnzshIKqK6SDpcT8yJtwwG
         1JXh/oZF2cz4LGKfhdv9Tbs2XspSH+bdsH2nieIF1VN+3ih9nW3ws5xN6jFEDc2so+FZ
         7Mf957eVazgDcWZ7/giH5XW7tufRbjlhznG69yJWashNh+P6L68CkS6QRHWdvbRh+Xne
         CpvA==
X-Forwarded-Encrypted: i=1; AJvYcCW7Gstd8hsFmggS1PdDZKabjDeWmnoYrm4VeQPhCus6yCWEpxYA83Vd+3QsLB46mGi2R94=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLAku356m+dA2DW1ZC5D7TiPCicgqxLNQxVQAPckT4ekT5NNR8
	jIhna+IZ9cZCiOxHs+zUmtkVflEo+6HMd8QQThpNdrlYuyBUx8EiDsjz2kZ3wilShMo=
X-Gm-Gg: ASbGnctVtNytYM9jyVi4+CFpYWRSrsDgLsVey/lvzdo3z2XiKBWNitb+pcQcjs2Ou9W
	tmdd2nPlIsqS1BjmFxcWyhf6OGd3IGgUDdfROZApJkZqAeOjHo2DahOLm8/OOzjRDS6HHBzG0TJ
	nQfy3IykLCAVpApbWeryEs42PSKJY/IIASkTwsT39dEwFk+Qc2agYbVXh2/8jlTOi2QE28Wqi3Q
	gJfUA1kbG9HtC2X/m2LVurAbjdF09TEit+e1Jt+2FWj9qXC4BzCvaO08R7NxMiaSAPrYFkWIfCO
	qICPXBaBuplM1IzvvNsJIMiIcc6jSP5q6W9F7rsUU5gAtedlDTaX4kA7Tlg5dh+5qIoVqbJ3KnK
	2DhZfdHM9HIWXRMbaMIMY904PYlztvCqP4xPiJfSWZDWhhyfUgb3HvlrS/yG2D/1U2PnMow6r57
	dP+fgAA9+ZFpQxi2W7b5XaiC0CVASQqh8kWzM+VR4NfbEIEXCcZ1d6ilUJ3VrZWQ7s8VkZ+A==
X-Google-Smtp-Source: AGHT+IHmBN0+9+r5KY4AyoghUj0jEXWjqZKGqzuPjvXeVNzt6iAcmzIlgz93IE1ZHjH55zZ3g6T32Q==
X-Received: by 2002:a05:620a:2950:b0:88e:aae4:9599 with SMTP id af79cd13be357-89dbfc9f46cmr377281085a.10.1761327152303;
        Fri, 24 Oct 2025 10:32:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89eadc0ab82sm58312485a.53.2025.10.24.10.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:32:31 -0700 (PDT)
Date: Fri, 24 Oct 2025 13:32:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>

On Fri, Oct 24, 2025 at 08:41:21AM +0100, Lorenzo Stoakes wrote:
> Separate out THP logic so we can drop an indentation level and reduce the
> amount of noise in this function.
> 
> We add pagemap_pmd_range_thp() for this purpose.
> 
> While we're here, convert the VM_BUG_ON() to a VM_WARN_ON_ONCE() at the
> same time.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
... >8
> +static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
> +			     struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +	struct pagemapread *pm = walk->private;
> +	spinlock_t *ptl;
> +	pte_t *pte, *orig_pte;
> +	int err = 0;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	ptl = pmd_trans_huge_lock(pmdp, vma);
> +	if (ptl)
> +		return pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
> +#endif

Maybe something like...

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
ptl = pmd_trans_huge_lock(pmdp, vma);
if (ptl) {
	err = pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
	spin_unlock(ptl);
	return err;
}
#endif

and drop the spin_unlock(ptl) calls from pagemap_pmd_range_thp?

Makes it easier to understand the locking semantics.

Might be worth adding a comment to pagemap_pmd_range_thp that callers
must hold the ptl lock.

~Gregory

P.S. This patch set made my day, the whole non-swap-swap thing has
always broken my brain.  <3

