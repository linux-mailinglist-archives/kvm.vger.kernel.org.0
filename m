Return-Path: <kvm+bounces-61298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44706C14C5E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 14:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE3CA1B25582
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 13:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1736C331A42;
	Tue, 28 Oct 2025 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="iti0ydl9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D52330B1F
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761656949; cv=none; b=pUf/FqxYb1X9fEAwG4kCeDtp2OZx4IsIz0YBs2poku8IBlGw8EmTgc4GhWx/EZYQHRqtudIC9obrWbdRkzAZzyDYRdJSoCAQZYeiGZaNfKz19X/ULFkzjwy86iqYdGF3iJ4YscATK8x1cdlCVPphzSGxyjOOL+sisbromMcU6Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761656949; c=relaxed/simple;
	bh=GYhA9Iy3/9/Ee+jnl+wXccAoqjQ72aXNdQ/Z7T9pA1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTBLBFYkLjx0dkJrkAMZ6/OcFhNckQT3irmTG4K+aMUulm0h11c/4STn1j4iEU9h6vuKkS1Za60O9Qw8EuZQIoEkHEq4ZeYWyBJLVxmOBHjELq/utq5x8yav7Eo/UxEJvimdKhEwy9uxVMm1FXJjz+0lIqkj2T8AUrKfnGlDYyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=iti0ydl9; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b109c6b9fcso53734801cf.3
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 06:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761656946; x=1762261746; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCGJuNdSiDHSbgE1dTHIFDy3cujeZVBX/ZxNKRqqViA=;
        b=iti0ydl9RPgT1+rOMGa7fKebSxzZ81u7N14kwlJzu5uRUDmZbPW+tGbASCk+XXvRwU
         3DkxfpY9BRxdfJ67wcRt1kiNB9jxq9QtSFb272lGIQ7kWPWRvUs9PMmImYnfy4r3+yTN
         KsXR8cfl7FqQKXXEA+O1e0FjU/FZ73eJiEZBIvrerCSuFTu2IutUaosQeQ9TTgivg+ay
         n8Q8jKL8KKjOGEJHfPcAPfe/uiYjyGlNfmzGu/agS/soO6Q6ZUU+TgmPDQZxicUU9F76
         HZAcaugdfQ1xnGONKzQmuOZtXRIULbBI7QzSFBY/1/Ke7dpJF2F3DYwINFlLU2aGy7D/
         aVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761656946; x=1762261746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCGJuNdSiDHSbgE1dTHIFDy3cujeZVBX/ZxNKRqqViA=;
        b=Y5kMTj2y4VONnsdePvwmz28s4k+u5SJomlM8ic6HtDs+8uGqE6G1DszZ6Jo4aE2Dbs
         K0MAp5SL61dkTArnj1b7afKz3VYjjps7NOCtJ4Y/bu0mZwmVP/QNFs2D4S+yzyY1CJPH
         Ktz3K8KqRpKbwB4fmpOYDLWw1l5lGphGgLGkWdxhKGwxVDuxhjgBZRrBV2lWLuNRUZVR
         MZ6jq+MliIiSnMgMqJTo5euIuroMiVrQK3LCUXLJs8kIpf+grpszBJ6k4+pIgzb8Ckfi
         ualcWVdoPEXMTSiH3Z3BXNsz82fMjG1ID6PhZwWVXKpd50urDFjEhVGRGKuPvBZ+SIsG
         CL/g==
X-Forwarded-Encrypted: i=1; AJvYcCXikvMoS0l5kE4KkXAWZ23yB4lxpd4TO4u7yw6W0IHck189jgPzu/UvAJYmy/8IW2Oo2Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrMzgHTgsi24frSICR1wTQJ23JZaG1DmHxf33Po4o8lxpqggch
	vl3j5GRka/Zyv5KTt8GbZx6cRZchwcagEYW79ehR52QrLKcwUsiUk0NVJ8WzhyR6dvY=
X-Gm-Gg: ASbGnctWN++9zgkUphi6aB1XfE6oH52InlvkdhZAEm2s4oHI56uMChODd9SM/YmhGjL
	WFSiE6yaHb7x3+mqnHvswD18hz7R8m0RvSWNZ9UqK1qJ/Zq+NtSjXMH1L0M7aUcEWam9d8HOekE
	gaHbpPuToM4RvHmicpoZDqjgQZAWYriakXV0EJrzNzFKYvh4i1AthV4fG2MQG9mqUp6Lrzjf7yv
	ekRet1UwCMi9HWcvdYexDE/WBwtm+Mi1Xnxktj9hsj2vkmnQysVE+/DHInuPKn/0ty3Spvu3GbL
	cIhDVhWVijVtMi77jj8H/59+0Sy/yyl4Ler1lXufAUxD71RDbB/mSPbTf+5OJ5e19YrmibUEtpQ
	DJjtxB5585I7RoKiTEtaqP2FnWNKAf1x6GSPpkCdYIzhflAwJOLicWIkC3Rqt9vu0GbnAz2XU91
	3tqA/oOfUMc38dQJkM28MsqSE30xCpYSvj+Ol0q/MgD0ncT0KOS2XBY1E8+BY=
X-Google-Smtp-Source: AGHT+IH98kqIm4OLBZ9BxTzNh4SoN+f3UCMEHEUjHueEIBmZ3ZFACR4imRWFssU1iLJ7HaKse0MxjQ==
X-Received: by 2002:a05:622a:261b:b0:4db:db96:15d3 with SMTP id d75a77b69052e-4ed074df11dmr43296561cf.31.1761656944848;
        Tue, 28 Oct 2025 06:09:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba386b6b9sm71298341cf.33.2025.10.28.06.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:09:04 -0700 (PDT)
Date: Tue, 28 Oct 2025 09:09:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
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
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aQDAbcpO8_SeDh_c@gourry-fedora-PF4VCD3F>
References: <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
 <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
 <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
 <20251028125244.GI760669@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028125244.GI760669@ziepe.ca>

On Tue, Oct 28, 2025 at 09:52:44AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 27, 2025 at 04:38:05PM +0000, Lorenzo Stoakes wrote:
> 
> The union helps encode in the type system what code is operating on
> what type of the leaf entry.
> 
> It seems pretty simple.
>

My recommendation of a union was a joke and is anything but simple.

Switching to a union now means every current toucher of a swp_entry_t
needs functions to do conversions to/from that thing as it gets passed
around to various subsystems. It increases overall complexity for no
value, i.e. "for negative value".

Please do not do this, I regret making the joke.

Regards,
Gregory

