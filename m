Return-Path: <kvm+bounces-40264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70642A55329
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D39E5170BCD
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513E925A652;
	Thu,  6 Mar 2025 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvOBGLps"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0019B5B4
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282401; cv=none; b=UEbItJKl6NBizjRLn8vZl/iZjQN01XVKNdWuvGkgLoD/yB0dSgSfXAirEB+wQnFb5cVKVPKJVsLvOFCgAJigsotTz8A2al8NZIlSMPeORn2pTAzx0XpIGUPnxjrLxgw+zjycQVLF+8zZyVpU45IIwDazHkF+FfVnBazl1PibxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282401; c=relaxed/simple;
	bh=yesNcmtGbNvXrMqb4l4AWjH7Uh6GoBe2YNFgTLAoU2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2T+Gn9pYUu7mlZYcswMc7ZtoqZUlpDQjLwLCpcGM93EWo8b+ALbfwQ/skMk8nVfc54e8wUflboBKl35ED7QwVXZSTyZFehBqGI9NRuztw9w+y/JoMi+6nbr9zkhuPbebl7aS5yaTTErUCVIGCanEhbtz9KXClD5w98QCSktTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvOBGLps; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741282399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hp0N3y6evf2yrWiBp62GjhkD2NyHCbEpRbyXBBPihTw=;
	b=cvOBGLps3Z02wkoofj6QYNkUUPHJN6q98NMeEvkIcQrjSLCvXh5vsWVP84FggZ2aQTi3bD
	rZfPsBE+z3H76vCZJyhT7mjPIjOpOLEuK1YH9jbcB7YvrIDjbhRmnVAHBjJsHzWiiIA9RJ
	/9XyaZUOswHIrdYhglbpjc+rUON11vs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-lxc3Lr2VNjiBjvTXLD-jKw-1; Thu, 06 Mar 2025 12:33:18 -0500
X-MC-Unique: lxc3Lr2VNjiBjvTXLD-jKw-1
X-Mimecast-MFC-AGG-ID: lxc3Lr2VNjiBjvTXLD-jKw_1741282397
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e8ea277063so24390966d6.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 09:33:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741282397; x=1741887197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hp0N3y6evf2yrWiBp62GjhkD2NyHCbEpRbyXBBPihTw=;
        b=Gz8okDxKWSiA2kGyoln29l6Tekyedr8DWqa3yEt71Ht4FidCYqcb0g46PRy5BpXAoM
         AELUHwL72qAD2M9llofSRbmpL43DexhXTg4I6W4+sF4IfbMDrMa3ucne0xLxjCciIUlu
         D+NiZe8w52EPtLfx06XTaii/n5LdKt+RvnNZnnH+GWZAkHjItoFTQ5iQn6qj/ZoZe0nu
         HNm1RRWoA+EBvFAKT21hLB7VLzl/vcjU1TxnNnhvIz6qTfYn5M9aje/6LX0NxVEavOAZ
         hys6OgmYWENkWP925crTr1wB2ACtgxWs+3ujUVVXD7RGI3iUO4IVxJ4IwCwZZImkJrLV
         dLJg==
X-Forwarded-Encrypted: i=1; AJvYcCVzFfNlgdzjfegDRFw8PmR7lWRlRnvEE20u/Ua/jrdO4OFq7f/FwCGdLKTvr2YiK1FxWI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCvAnRC9gWi66UCVtNgS/c1rXQtoRyGjt6xRreqEjMJmCMQJnA
	cE0K4ebVY6N4M4uUtb1HeUE4A6MB8eS4vaKfWt23iGaRf7GrEpLZct05J0QMzkF5C66uzKVdo4/
	rt9KOtV4u3p2f3pbdI5zR43k9Qq9hnbaZx+bbgXcVX+0NZ5NyjA==
X-Gm-Gg: ASbGncvSYqf95a9OtnOOnc1M4C7ynHgdCKtSzi+iKSuvwi8Tyc5ExjNyl/YZI/32eOy
	lJuDHGoKvFnHCr+dJqrd9g6+if/DHdVgHk+bJ7PZxFOfu8wgaOTYazHCB42iw9xpUDAFp53XqDQ
	9A/dKrh2h5jkJXjfC1q1A1O2tK5q7XALkSmYPLyhmbjx1y2ilXcb51WwcQ3tOs638Ejd3DjYpw0
	NNjlxZF5dhpJU8t+aHG7PNEIKMR5h69Wr6hQAplJp/t3C32rGB9phKF9DBrDO1qRi2m2KOrbFfr
	PoUKNSo=
X-Received: by 2002:ad4:5dcb:0:b0:6d3:f1ff:f8d6 with SMTP id 6a1803df08f44-6e8e6dd4013mr91007496d6.40.1741282397135;
        Thu, 06 Mar 2025 09:33:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXGTY2TZuxc/5qoe6G+TjInYEiN1/MY4M3Q3Wi5nBQl7XJwnFgOewPjxKsSfPGwYlCfIdGig==
X-Received: by 2002:ad4:5dcb:0:b0:6d3:f1ff:f8d6 with SMTP id 6a1803df08f44-6e8e6dd4013mr91007016d6.40.1741282396798;
        Thu, 06 Mar 2025 09:33:16 -0800 (PST)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8f70a44b8sm9395206d6.59.2025.03.06.09.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 09:33:15 -0800 (PST)
Date: Thu, 6 Mar 2025 12:33:12 -0500
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
Message-ID: <Z8ncWAP7ln1St5W-@x1.local>
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
> +static int kvm_gmem_hugetlb_filemap_remove_folios(struct address_space *mapping,
> +						  struct hstate *h,
> +						  loff_t lstart, loff_t lend)
> +{
> +	const pgoff_t end = lend >> PAGE_SHIFT;
> +	pgoff_t next = lstart >> PAGE_SHIFT;
> +	struct folio_batch fbatch;
> +	int num_freed = 0;
> +
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
> +		int i;
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio;
> +			pgoff_t hindex;
> +			u32 hash;
> +
> +			folio = fbatch.folios[i];
> +			hindex = folio->index >> huge_page_order(h);
> +			hash = hugetlb_fault_mutex_hash(mapping, hindex);
> +
> +			mutex_lock(&hugetlb_fault_mutex_table[hash]);

I'm debugging some issue and this caught my attention.  IIUC we need to
unmap the last time here with the fault mutex, right?  Something like:

        unmap_mapping_range(mapping, lstart, lend, 0);

Otherwise I don't know what protects a concurrent fault from happening when
removing the folio from the page cache simultaneously.  Could refer to
remove_inode_single_folio() for hugetlbfs.  For generic folios, it normally
needs the folio lock when unmap, iiuc, but here the mutex should be fine.

So far, even with the line added, my issue still didn't yet go away.
However I figured I should raise this up here anyway at least as a pure
question.

> +			kvm_gmem_hugetlb_filemap_remove_folio(folio);
> +			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> +
> +			num_freed++;
> +		}
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return num_freed;
> +}

-- 
Peter Xu


