Return-Path: <kvm+bounces-61235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD84FC1211E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA3ED3B0328
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBBED32ED3F;
	Mon, 27 Oct 2025 23:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XPfEVKpA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824C732D0FA
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607984; cv=none; b=bSLWRJCreww6+VE6YJ7hwbNEqAT+Rm9riZEAEYSbHdfAQIQzw8aoH32EXn+mULc0bv+6J3jSCQFleWkTuEXrcsnGVH6b2qfbHVo7KUI+wBTG7Z/nj/a6reE/YRY5xluCRgL2g9+hStCuv+oFLinYUxloxbJNoVFPfc8u41HUvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607984; c=relaxed/simple;
	bh=ya34dnXBkVMZ4acUVB749ZaVXuLYyX25Ei5hDiCldOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8U5RxEX2hNy+nhxccupXOPEjfphmu5Ea+i9qV+cZCKk/o6THrSIoCYMNRrbcpB1dO1uMC5/ZFaUX1DnkcMVxUETofXLtsBAvPW8y52JaTfezVueLe2HuoxJxPa+kLZe4qChjSGvR9wh3M/4BJ+hjawk2kYdh1mHjfaFK6kxopU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XPfEVKpA; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-78ea15d3489so47147856d6.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761607981; x=1762212781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SeBkBGZ09M3QB76OpujQtXgjWBBtrpYzqcpEmFvCTi4=;
        b=XPfEVKpAkz0EqqJlblUgrQ2PbfAJJwC+FFil/Vd5htXfHTtIAt0AcJCsl4NmBxKXRJ
         eIW5UeA7107giYfaQifJ5a/gcKAR8VZ9z0golFJy5Hb23kycJSDDiGo9zpEv9kL7Qk7s
         w7zRqTxUMrIW23T1nvKpH2c36Y7Gmc+zKGLLJpUtGCt5fPfRM1WTsbfA/tTdW9nn2aUs
         ftNj7HpeKguvAOHG0jEjFwpWYouZrm59oAzF2CNPOw8w7oeCkLSrBScDF73Fz4cxKAC8
         hjTanLd8/LkCYdg+DpDtdHCnEdUb1gxr4DzFdHDnJdW+eZ6Z/hxItchsfPdz1TLQ2R8w
         4aIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607981; x=1762212781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeBkBGZ09M3QB76OpujQtXgjWBBtrpYzqcpEmFvCTi4=;
        b=dyvVi16PHX7uyNFuCVSJFP6nv/gxkqcygBnC+aF25z4nwA/oRnvOn9sd1nM5oc+p8C
         3M1yYzlKgidnTz4lz1GTmh65h4IZ6WhS5Setirw8bU436K6ziP7jl2uySo8j1BPQ+OCx
         BGYt78z4Z7Sdsj/TuVPB7ErqnZb3g521YWSp87+vxMsQBoLW+O49qCzgi2yYkIfrfySB
         iAdy/hP4uGzQQex1Fsaj2hRoJdG1+ANbUEA99rWE2iheBdTWpYVO6WAMKCwmOFH2AFhY
         N1uWY3RRKKRg2mYioai6UUSQEghOSBCS3dwZvyZTe5tM1VswP6V60/1MpwXjdo8m94Nh
         nmqw==
X-Forwarded-Encrypted: i=1; AJvYcCWGWnajspQFbTr1Q/HIsvh+1SYuDd+LHdiancw3s4A+b/jZvKe3p6hvXtH4xeZyJs5MiJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvMO7kv5KYePp2ZAQZrBZAi0zjiDqhl2VSc7bhrzBYDEVPYWcE
	OytVGq1j73Ur+PVMDaTEwzJF1MUTGqRwmaHySQPzU7/oDyNlQYDNBmVlqpqXIVA03MI=
X-Gm-Gg: ASbGncsoVzU0f5SBbZfnhgpJ+rewrD0nhEGDkUh1wb84HZrJa13MwuqdmuIp1Pwe38g
	ZXCFUJ6o7FMMQZrhXUhfzwWZVYpu+i3eCr5L8BGkF2/vejgiRocbRlKuReNL+/B2OlxtAQX01hN
	8pSwV97t845f9T49t3q1Yjw9529M4TuhC6o2on+cM7e4LqPA9G3P1tPCos8KSJKGC2LkosroUbE
	KHsSVpLNgPOe72xhoLunlUfzzsCuKl1tVY4y8dmPuM/PbR4K7cRoZ4eEmn3e2St0KHo1FkM0GCj
	UT9htovxOjIF/RvJS2uYtsND1eJzhe1UqmHs7v29OWMJPWZp1PCl7sEg7007RvlAtF/xbaWCPLn
	Vh6MVQOz9pLs2M5Yz9l80nKqZ7z0+RQItHbsxSZoM6e23qTFKkiQ3sQMGE5rCpp+j3ymcE2ssfe
	tYNf9cJ5KxDZPaK01AIlIIClEHR3bD3mgFjlGTn5G6872DH00h+ceH0IuxEyk=
X-Google-Smtp-Source: AGHT+IGY0mnN3CFDP7vaLRad7aeAt7RbVIUmDhfxoFPsiCMHR/zS0q6YLuuynQuqtuF/1igQEZd8Tg==
X-Received: by 2002:ad4:5cad:0:b0:87c:2b03:c776 with SMTP id 6a1803df08f44-87ffb0f3094mr20891046d6.47.1761607981318;
        Mon, 27 Oct 2025 16:33:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48ea92fsm64277606d6.24.2025.10.27.16.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:33:00 -0700 (PDT)
Date: Mon, 27 Oct 2025 19:32:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <aQABKgQYfVkO7n9m@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027160923.GF760669@ziepe.ca>

On Mon, Oct 27, 2025 at 01:09:23PM -0300, Jason Gunthorpe wrote:
> 
> I'm not keen on is_non_present_entry(), it seems confusing again.
> 

The confusion stems from `present` referring to the state of the hardware
PTE bits, instead of referring to the state of the entry.

But even if we're stuck with "non-present entry", it's still infinitely
more understandable (and teachable) than "non_swap_swap_entry".

So even if we never get to the point of replacing swp_entry_t, this is a
clear and obvious improvement.
~Gregory

