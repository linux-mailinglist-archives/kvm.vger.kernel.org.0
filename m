Return-Path: <kvm+bounces-32799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C34E9DF6E3
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 18:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01E05281923
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 17:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9A41D86CE;
	Sun,  1 Dec 2024 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGWhUhDD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5537A1D7E54
	for <kvm@vger.kernel.org>; Sun,  1 Dec 2024 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733075981; cv=none; b=aj2rZ+3VF51JJZEZj1mWNYkezfeNtK2Xo/7MOSLf/9mHjm2ey7N+RMefgjlpq4uo/6nAaC7BG5OmB8YFEDs0gHpJ2S75tdRFzMxlykYIR4nYSXJq/0Chy90IFfpS1PUzTnNBBNTO1Y0kNgdOglb0z/DqcepXoUZ00lmLrS5ewNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733075981; c=relaxed/simple;
	bh=aCcFCSZJUXI54+bKPh/05TzVJL4t5c3nMnUzxLQ+3Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQ0dJeXjH2oalrIfbKppABRFulailM961pNlVKKUs36LS9KwnLGducJFKkO9t1PjokHYyJKkdPgfe9xuE9T1UsthKDsWx0D8dEWt9lpFOI88s8aLYVQf0Q6pX5hHJakw2Q2gTkXydEdBirHsZ02nw/GZqd5AIGr8ErmkicmThx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VGWhUhDD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733075979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0A+hdS0S9TZs4FCHTCUNfBMXeoZLW6DBQh4uakYhdW8=;
	b=VGWhUhDDE6m+b2rIaDPxKgBtziQo68vTQzjnol33SUi5a7WqBSAxX3J8dbcFrfOmSUwi4l
	PMReeGzgyXw9S4COcKUsPozB5lUbftasOmkYhrKSUW3pxS0iEJQ8XDFsCOkie2R4LY2MDs
	UmWTclP2zOs1LOwyZhdE3FGltIQEBBk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-cB3Z8QKhPqCCFkCeY4of_g-1; Sun, 01 Dec 2024 12:59:38 -0500
X-MC-Unique: cB3Z8QKhPqCCFkCeY4of_g-1
X-Mimecast-MFC-AGG-ID: cB3Z8QKhPqCCFkCeY4of_g
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a79afe7a0bso44562065ab.3
        for <kvm@vger.kernel.org>; Sun, 01 Dec 2024 09:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733075977; x=1733680777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A+hdS0S9TZs4FCHTCUNfBMXeoZLW6DBQh4uakYhdW8=;
        b=iZID0vKL5eryBLaKz6fh5qhjj3CTOYOhNnnq5kv2Imxmmva4sNjGijT9918B5h7od+
         W/W2+ucprDbOCin8D3f66Z6JVnJ582UTIJZ3l/lC5KbtjC8ub+uGTph8nVmlxb2+HJVo
         u91ST7EHXFicKsH2kV+BfxhRMl5U26urTD4sR1J7xEoQXBNLoIus95ZUQzt4nJDnVslL
         0HkzlCWyJsqtciUa6kj8GStgZFuzsC0YMxhhgirjc6GPbjzOXJ+Xc262hs8XJn0PDqQZ
         gs4Wz0IuSKyyXLYixhUbyMCbrimFmDUF7mtuKHfBeFuWBv0OtFjp9cd1cwo3F1TQOYDH
         qINw==
X-Forwarded-Encrypted: i=1; AJvYcCUAnS7rk+MJle68kZEbiQb6HkYviGBBJxdPxep7j/bCE4/P8/EGa59/i9wDNRvilpqfWDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaqzDRmnAfQhn4ulas4d9Y6gYX99GbTALEGjiaJVern22Ny3cd
	vToxQAtJlg7zdye9TLk9AooHeStdFRPhNDc8Nw7WOoiUPNE2IK7ojy6flzAkH4fXqEeLVA+8YyO
	2EJYbB7xhgTy2c35q0lcFRFUCjhwfs8dEVE05wJaooRmwE47hFA==
X-Gm-Gg: ASbGncv85ll48r45aUZDTwOape7F+9mOBFL+enA6enGei6LQg+d4CrihR4wK80I3OV5
	VAUwg/KCTE8Fep9JP+o1IbmZt1vErQ+93mquwpOh2+tgG0sT7VJDyOyHnviOiF0aSco61QqQBbv
	KS0zNBpmNIW+kEOTQm4D4wyjHKubDlIgEY7+10fdFHYvqUGxhUiHq9JyW5IGNoHMEi2JSaZ0urH
	S0jwzMlXR4nMa5QWXMas0h4Tz0nTm5yR1X7DRyeA4gkA1225zIHbMDBo6m1Y9b0lZcaYK7GACHL
	NA3pR3P9TFg=
X-Received: by 2002:a05:6e02:2192:b0:3a7:dd45:bca1 with SMTP id e9e14a558f8ab-3a7dd45c5e2mr85506425ab.17.1733075977437;
        Sun, 01 Dec 2024 09:59:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHry52UnkIwNHPlxMfjuNJbz0kuNzIn+XivMrF6Q+kiRWIeU+o9LVgyCqSYZICKYohcFcyI2w==
X-Received: by 2002:a05:6e02:2192:b0:3a7:dd45:bca1 with SMTP id e9e14a558f8ab-3a7dd45c5e2mr85506025ab.17.1733075977146;
        Sun, 01 Dec 2024 09:59:37 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a7ccc0b987sm18690775ab.34.2024.12.01.09.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2024 09:59:36 -0800 (PST)
Date: Sun, 1 Dec 2024 12:59:33 -0500
From: Peter Xu <peterx@redhat.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
	jgg@nvidia.com, david@redhat.com, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	mike.kravetz@oracle.com, erdemaktas@google.com,
	vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
	willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
	bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
	rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
	haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
	maciej.wieczor-retman@intel.com, pgonda@google.com,
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Subject: Re: [RFC PATCH 14/39] KVM: guest_memfd: hugetlb: initialization and
 cleanup
Message-ID: <Z0ykBZAOZUdf8GbB@x1n>
References: <cover.1726009989.git.ackerleytng@google.com>
 <3fec11d8a007505405eadcf2b3e10ec9051cf6bf.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3fec11d8a007505405eadcf2b3e10ec9051cf6bf.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:45PM +0000, Ackerley Tng wrote:
> +/**
> + * Removes folios in range [@lstart, @lend) from page cache of inode, updates
> + * inode metadata and hugetlb reservations.
> + */
> +static void kvm_gmem_hugetlb_truncate_folios_range(struct inode *inode,
> +						   loff_t lstart, loff_t lend)
> +{
> +	struct kvm_gmem_hugetlb *hgmem;
> +	struct hstate *h;
> +	int gbl_reserve;
> +	int num_freed;
> +
> +	hgmem = kvm_gmem_hgmem(inode);
> +	h = hgmem->h;
> +
> +	num_freed = kvm_gmem_hugetlb_filemap_remove_folios(inode->i_mapping,
> +							   h, lstart, lend);
> +
> +	gbl_reserve = hugepage_subpool_put_pages(hgmem->spool, num_freed);
> +	hugetlb_acct_memory(h, -gbl_reserve);

I wonder whether this is needed, and whether hugetlb_acct_memory() needs to
be exported in the other patch.

IIUC subpools manages the global reservation on its own when min_pages is
set (which should be gmem's case, where both max/min set to gmem size).
That's in hugepage_put_subpool() -> unlock_or_release_subpool().

> +
> +	spin_lock(&inode->i_lock);
> +	inode->i_blocks -= blocks_per_huge_page(h) * num_freed;
> +	spin_unlock(&inode->i_lock);
> +}

-- 
Peter Xu


