Return-Path: <kvm+bounces-32798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE129DF6D9
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 18:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B76AB22E14
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 17:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B50D1D86C7;
	Sun,  1 Dec 2024 17:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxYV8dg3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B778D1BC094
	for <kvm@vger.kernel.org>; Sun,  1 Dec 2024 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733075746; cv=none; b=WXUcnsKFca57pG0EXMRdvCI67avJ/+3xuEK1qRCX+6hX+WQHvin5c6qBLUeyGG9G6L4h4pqDQm+YhVHdQ8SfQ0hbsMeBzDibO7ZOr8JrPX3SKHMWdCeq4IbtfOafRQpCdxnmVx9jD06m6kzIg05hH1nk6iUGyT37MWS2E0OyTZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733075746; c=relaxed/simple;
	bh=pDh3sxIXjSiOmi/2YmBJfp6Dv4l2bH2RMTYOFvdjOCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkJ7s1ZXE7yPauXfpy73n9qAgaCyqlRAzscjlSgHD67ujDMobjvm7lX2byAP18stEOlwXy15ZPhvYdyWIRoKgMgz7gwXvU2wIUynl+WIP+Ak+etC+BY38palFgNWhqZSMQPVcG5fsCsKpsTwE0KYKp6XShmJKrNzovSdYoPiduA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxYV8dg3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733075743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj/FRfspWv/DskWdu4ezgBxsZYrptmYDnGDs7cuKhHc=;
	b=XxYV8dg3yjgCkLiuu/0iTorsX3EAXWBI6ufO6OEhhqnH8bWsZ1N4nIF2/B8XJ02lkfdjoC
	NVbbK8mKV24xaCqpvfwCawdC9KuTjFvZNFhXXeuq+KAy2D1DcRDOv7ipFIkQrpSRocE/Ag
	1LyTadmgxFoF0SgdG003DV7jCyFbgKY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-_9RH2G3RMyCAelbW6keKEQ-1; Sun, 01 Dec 2024 12:55:42 -0500
X-MC-Unique: _9RH2G3RMyCAelbW6keKEQ-1
X-Mimecast-MFC-AGG-ID: _9RH2G3RMyCAelbW6keKEQ
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84181157edbso262519039f.2
        for <kvm@vger.kernel.org>; Sun, 01 Dec 2024 09:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733075742; x=1733680542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bj/FRfspWv/DskWdu4ezgBxsZYrptmYDnGDs7cuKhHc=;
        b=hoJmkdJu2DIYP2mpQGMb3PwlcHoIlQ7BSxuOtrJQQHWQDCcsutm/UCkSGba7gVCx8/
         Gys5T8eYoP3l7S/C6iRu23+/X7HffKeL2woGIhiZIkUpNiNiTepl/ymUh4RNqkLDsWmg
         jTP9IBb7ARbb2o45Dathw40aSbrg4vOTTin7nGI0zDU42HSaUOPASF3VUae5diGcXza3
         VMrB5Bt2S6kUsRK/f1uZ1aQbkDzkE3Ny/S+ng2hu0RYNITq/xuXlC0aAkmOr3OTWz9tK
         /CZ1Z1CnaSIdjl9GvbCKwQVDAUm/FQtyRPW8NdV99QhpPcNMslaEuWfH66KBguQi4KBG
         BFIg==
X-Forwarded-Encrypted: i=1; AJvYcCWvgirsz0dvzQzkY3p02+RlsWapJ+QwIe34eLJWmTITRZ2j7mGeizXv42pr7qFSWjx6iQo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/YyBEf47v986/mh6sclX7QLbxW20O9tW1QZ4t6XfOU4lpmvtb
	d84J3rZ3eYjWbWpJjbNXx/4m7K4QvNHe4wsdBKIP8nE4ShSanc/rVOo2vZXF3iBZavXKbgug7x/
	n2OUBF7KH9/7OWVNPS3r9SFTq7CpoHXEO94UOnoW4C5DW68gkBg==
X-Gm-Gg: ASbGncvsdK4sDqGiwn4lN20oAjirzKt9QLdvwdpoFTTWjpOQ1r7Ti9Pu/btNTSAPl+g
	krcr0nR24VQVf5aHqFKG3q6Z1IhOz6mpBfqts9c5WM2Wc3WLN/lgEYOYJqxUpN97kuQx9Tv8BM5
	HHAI0MxOiNEtjv5tdealhUg1mFiHXKoZ780bDcXbCKtWt2p3IacodrnGrNsSS1oYkwP5rvpFVmj
	zztfyN4bGd3RFApQiqojgqkzwjEgNIys6iacGRssUJ1UwAWEeWssI1VlozKICuiwy7jXZ5QSrHd
	W0vNVLkTMmY=
X-Received: by 2002:a05:6602:1485:b0:83a:bd82:78e with SMTP id ca18e2360f4ac-843ed0d5db1mr1823655239f.13.1733075741834;
        Sun, 01 Dec 2024 09:55:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/C29sEt8k4hWcQ9UZmsHjRNvozdtx0q9RcLM88/BVqTagSmnFuAl4NtUM6pK3J/5zeSzg2A==
X-Received: by 2002:a05:6602:1485:b0:83a:bd82:78e with SMTP id ca18e2360f4ac-843ed0d5db1mr1823651239f.13.1733075741502;
        Sun, 01 Dec 2024 09:55:41 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84405faf14fsm171115139f.42.2024.12.01.09.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2024 09:55:40 -0800 (PST)
Date: Sun, 1 Dec 2024 12:55:36 -0500
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
Subject: Re: [RFC PATCH 15/39] KVM: guest_memfd: hugetlb: allocate and
 truncate from hugetlb
Message-ID: <Z0yjGA25b8TfLMnd@x1n>
References: <cover.1726009989.git.ackerleytng@google.com>
 <768488c67540aa18c200d7ee16e75a3a087022d4.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <768488c67540aa18c200d7ee16e75a3a087022d4.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:46PM +0000, Ackerley Tng wrote:
> +static struct folio *kvm_gmem_hugetlb_alloc_folio(struct hstate *h,
> +						  struct hugepage_subpool *spool)
> +{
> +	bool memcg_charge_was_prepared;
> +	struct mem_cgroup *memcg;
> +	struct mempolicy *mpol;
> +	nodemask_t *nodemask;
> +	struct folio *folio;
> +	gfp_t gfp_mask;
> +	int ret;
> +	int nid;
> +
> +	gfp_mask = htlb_alloc_mask(h);
> +
> +	memcg = get_mem_cgroup_from_current();
> +	ret = mem_cgroup_hugetlb_try_charge(memcg,
> +					    gfp_mask | __GFP_RETRY_MAYFAIL,
> +					    pages_per_huge_page(h));
> +	if (ret == -ENOMEM)
> +		goto err;
> +
> +	memcg_charge_was_prepared = ret != -EOPNOTSUPP;
> +
> +	/* Pages are only to be taken from guest_memfd subpool and nowhere else. */
> +	if (hugepage_subpool_get_pages(spool, 1))
> +		goto err_cancel_charge;
> +
> +	nid = kvm_gmem_get_mpol_node_nodemask(htlb_alloc_mask(h), &mpol,
> +					      &nodemask);
> +	/*
> +	 * charge_cgroup_reservation is false because we didn't make any cgroup
> +	 * reservations when creating the guest_memfd subpool.

Hmm.. isn't this the exact reason to set charge_cgroup_reservation==true
instead?

IIUC gmem hugetlb pages should participate in the hugetlb cgroup resv
charge as well.  It is already involved in the rest cgroup charges, and I
wonder whether it's intended that the patch treated the resv accounting
specially.

Thanks,

> +	 *
> +	 * use_hstate_resv is true because we reserved from global hstate when
> +	 * creating the guest_memfd subpool.
> +	 */
> +	folio = hugetlb_alloc_folio(h, mpol, nid, nodemask, false, true);
> +	mpol_cond_put(mpol);
> +
> +	if (!folio)
> +		goto err_put_pages;
> +
> +	hugetlb_set_folio_subpool(folio, spool);
> +
> +	if (memcg_charge_was_prepared)
> +		mem_cgroup_commit_charge(folio, memcg);
> +
> +out:
> +	mem_cgroup_put(memcg);
> +
> +	return folio;
> +
> +err_put_pages:
> +	hugepage_subpool_put_pages(spool, 1);
> +
> +err_cancel_charge:
> +	if (memcg_charge_was_prepared)
> +		mem_cgroup_cancel_charge(memcg, pages_per_huge_page(h));
> +
> +err:
> +	folio = ERR_PTR(-ENOMEM);
> +	goto out;
> +}

-- 
Peter Xu


