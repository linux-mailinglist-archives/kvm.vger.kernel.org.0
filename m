Return-Path: <kvm+bounces-61053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7BCC07D86
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 019293B6436
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979CB355810;
	Fri, 24 Oct 2025 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="r4EKg749"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2173F3557F5
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761332866; cv=none; b=EIG6c+Q5vglnjfsh3A8F7pMpqJE1NmSQAK4CGeytUuaJn4MkSgg9co4qYBAKknu6sdmX2RuEdfD7dT5QnIcKC7bYvya2mswjP8PaI9U9Bv5ussgjl1hq+6x3uA0unwm98g2juuFM2nWhZdpNeTSR9WWVEBtZkJPFImNi61/eXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761332866; c=relaxed/simple;
	bh=BLEG6QVxINnxGSV9PP3rHj14LkkUoRrxiY/LRA160IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3v8e6GmbD2CA83unHqzoir08upyN9Ixrx6qJsA6TR1JfxPwYey5svz+xyafj1H47W1ES08wb4wK8+suKA7ymiDgXGlnjVvt+8hClsJ30ziyXA3uZsukivaIQi1tW7xY2H7ZBRV6V6J7X2h2b7zXxMY2RDbWwyLmDA62IHTfpnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=r4EKg749; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4e8b4e4ce70so27174531cf.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 12:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761332864; x=1761937664; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5Dh5pou/PyGHQeCBr0c/6aApj2l3K41F6GbY+zS02k=;
        b=r4EKg749YYSw/kYQOx6FLdlqv/KCYEmMkRbKABtyYYMzpnnKTBzACCD3qguUm0bn/a
         gubeqPMkAo9DJuDdXd0tUyt/A7h55itwwf7TuTBFFc98FMmjE/gR03WHZ8i9LaV5VGFu
         6X2azELy+Y/wwlZCq9OrZPV3ruYPh+nHZv6VzZVE1wrGR8kdae2ngo2s0SnTUSk0WfhN
         QkbvJx4cls7kMjSZbKBhawEZTngmEdpy0yPX3PjNvQ1B4iUtXeTTEg9WRBiXF0LR6yD8
         ubxo+T3y1k2KUnUzfkVBiZbf71rGL1rF+gBNetTDC6FofBKqXwv1C8fuwpR7Umnm2yXr
         Twqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761332864; x=1761937664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5Dh5pou/PyGHQeCBr0c/6aApj2l3K41F6GbY+zS02k=;
        b=dmC0x/fLo6PMjPoIAynZS5Vv5zFsFtXHo9R6ymPZYpcZO8hPg3V3/YhRYZcpWE6nug
         7i59R7q4+eRARxfoqsYEEfcCbYqtkwOmBHf1KFM/pp2WduCpiO4JewHGF1uijRspT23N
         J03PT/NjGkbGI18Yy3TLkJIvnQP0rXH/oavH9xDprxqxrsyNYyZKG/88FKjEobmS0HW0
         J0ufNcB7uQ74Is1k8/xCfTH0ptfvqKW1bOBQj/6OybtuR82ipFluGkv8tkb2Xs42GwO6
         zwL4fWicH9bv3JdxN7B/1JYsqIuv7mp6KTl2f8NxCiFQ96CZy6vkma1rGk0YNDJjClTn
         UFug==
X-Forwarded-Encrypted: i=1; AJvYcCU4g5QNwokPdF6Bl1AkLMZlBcGvNzdtoVSW9huYTas+aIiRhMDQH7dWZyj6ccie/nYjlVE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn/4PIEXBtfCpELHK6npZ1ylbz1ys8wSYYWV0TED1Ffzw9EFAb
	o3eQj5Wb6ZXiolnTT9DCI/yFNX/Z70CWESo0TP7xCR+E2iNntcWfB9iMgi4BJCVwhKs=
X-Gm-Gg: ASbGncvAGmh9R5YiR+pwrisNwnVDPiVtfOJhEcPfo0Nm/PIcITkIqhqzEyt7NomcsFw
	tUYd6DCbzcUKgGOsNxXfV+9XLCP0gmNKESLxh4D3RJ24+snarvTgfiXrgF37ONQfeeaIoT9f/9w
	JQkrsUZastWyt1N8zoZcCZrzbA/k/2b6jPy997W5001PNGtP3wEquLAmnyzE0iMSaTwHM+gqkPN
	HUQSnN851N66yiUEcQAJOWaTI47t1F3EUggxtNnqozziEQgHyHhfDWIBKbMgRJnhcEjYeDxZo1e
	TJDRT2H4Xw3AqeNNhmRBuz31llqHpfcwZ0gUIIte691t8qK+gaZk8XNm7MMVG7eR82B9r0zyMQr
	EpZAXqD291zx1m1z4Pc4nN0pnXwD+IROv/nldmXR9kmHDTgDHUIshC/ZEArVGpX77ThoHnPST8M
	diS8O86Ss0S/tlBkU5Z1nCM7mWeCQiEyQUVh+9yvRTvMAGEX/xUSKEKrOvxX2JRzob1ouzRstFf
	8eE/5XA
X-Google-Smtp-Source: AGHT+IGJ10HVaocsCEydg4aVTizi/vMPamVub9HiazMH0e97AeDKtQcVhgmZnH66d5WlxZIy8Zx0/A==
X-Received: by 2002:a05:622a:1453:b0:4e8:a967:953e with SMTP id d75a77b69052e-4eb940ecd89mr41100001cf.24.1761332863649;
        Fri, 24 Oct 2025 12:07:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eb85e917c5sm35169951cf.24.2025.10.24.12.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:07:43 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:07:40 -0400
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
Subject: Re: [RFC PATCH 11/12] mm: rename non_swap_entry() to
 is_non_present_entry()
Message-ID: <aPvOfIfcRM0X_RaK@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <a4d5b41bd96d7a066962693fd2e29eb7db6e5c8d.1761288179.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d5b41bd96d7a066962693fd2e29eb7db6e5c8d.1761288179.git.lorenzo.stoakes@oracle.com>

On Fri, Oct 24, 2025 at 08:41:27AM +0100, Lorenzo Stoakes wrote:
> Referring to non-swap swap entries is simply confusing. While we store
> non-present entries unrelated to swap itself, in swp_entry_t fields, we can
> avoid referring to them as 'non-swap' entries.
> 
--- >8
>  static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
>  {
> -	if (!non_swap_entry(entry))
> +	if (!is_non_present_entry(entry))
>  		dec_mm_counter(mm, MM_SWAPENTS);

I guess the question I have here is whether it's feasible to invert the
logic to avoid the double-negative not-logic.

Anyway, naming is hard. In general I appreciate the additional clarity,
even if we still have some `!is_non_*` logic sprinkled about.

--- addt'l aside semi-unrelated to your patches

I can see where this is going in the long run, but the name of this
function (ptep_zap_swap_entry) is as frustrating as the check for
non_swap_entry(entry).

may as well call it `ptep_zap_leaf_thingy` if it's handling multiple
special entry types.

but renaming even more functions in strange places outside scope here.

---

~Gregory

