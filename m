Return-Path: <kvm+bounces-61054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D8450C07DA1
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5C343354380
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B44357A49;
	Fri, 24 Oct 2025 19:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YvjFzXO0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6A357A24
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761333005; cv=none; b=LSxLOhu2K1DFY5zZ+rifVNUBcYhDvXTCNm91sT9ZM936QW33zhgQFhgrCe7jQRo1jOwVNGdZhytUWR/dYi6A923DEv2Dmc/YP49sxmZK7jxL47tnroGcgJP8vaXWGU62qXKF2iH7WOW5wBBDBqlPEBZfCnVxz1Mtmaz58ujjx4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761333005; c=relaxed/simple;
	bh=eOV8n3GyeI7NGmNQOPYmpec1MI+qOKDL2up+UvX3whg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lv6Ypx8TMLDygflNN/H9lBdtD7RLaAef6Pa/2sowIst3aGz/A2KG8b17ktTS0D5k5zH/BL6WM7V/W4iTd08z5MVpp1LoYEijX7bxpcAglmad1eXbwn1HLr8nz2cLoPO0XkrRmioxHTYLwODoS89gipmPUJXc/YDalVohA+Qev2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YvjFzXO0; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8906eb94264so261912185a.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761333000; x=1761937800; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4YhT6UkULx0zY0BI31WYEg/XWXtKp76n8KPsV3vFlM=;
        b=YvjFzXO0J6h2ss5Sjx0x/YOHwNaZ4Tm+e+WqDpFH9ACMNz46aWXSiaQsQwolqekzQO
         2buiBh7TWFig/XGHuU8xyyyCnwtmRTYFFY45EsAZmWULSomAfW1N2sgkiqXHUoHo6QTR
         7CZ5LqV7OgWZGlcGb5jecQPrBWfpBrrsKfEN6nhZgnr0/mzyWb95v2Aoqltu98hD3TZk
         IOG5fzcgJua53NNBnVpecM0fDkXU6wkdxKPJBexBF6Z3DCRjfkWDwMDZqWSMFu5PvSkZ
         K75yKN3CZw31D88pNNMrUcdvvRHb3zV1rkpRutMPmDiSN1YLdM+henQF42C8jPnce2uU
         k2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761333000; x=1761937800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4YhT6UkULx0zY0BI31WYEg/XWXtKp76n8KPsV3vFlM=;
        b=PieSyPORrIfCKfze4jaNNpJe3ez44dy6HCNombxqYeibWcaabdh0DHWuoe+kHd0VoP
         Cp0cRrBwVMWTRtOUNpi3PpoP2b0uNGuAkooPbJWNROQINEAIe/1S5vaCSa/U+ghXEem6
         ssx8rOSIvYZcZYNN/6fq8B4hPyJ0BgF1KaRBoEwVGgOA+gYdeg/S5qcEH/kumEVsXVky
         lAFlgxldoA32GNZNQVgCCNeKs/W3EZQlSg4QO3CNNgHLUh+VdFfPQJ+Uf26YC2fE6puV
         9jbaHZ8vxg4DyyLh2bC0a9B6rB8ALedsMwi1/mj9WECF3sal+EXaDBsJXGRC3Le7M58F
         bEQw==
X-Forwarded-Encrypted: i=1; AJvYcCX+1HjYeqgkuz2rxu27Qhyg+n3Gfdnzjy+bGoCd9o6tS0/ww1L/XkyjkRShshVxYFMPtJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ96aWKNBQcjZUpz42BrVPmAwuzfJQwohn1fmlRameol20Oeh9
	9SOrjEfVT0aS3EuRzqfcHKnUbQFuvPhOAo1rK7Dr0/LhOGmg7FcuNYhZfvmjn+5Njak=
X-Gm-Gg: ASbGnctWzPIx1ikhDyt4GI2QR4Ah0+i3mhu+vNoZNIUkIRaPPVC0FJnI/+3kOEFE62W
	CjnsgsR6BirAmdkGdnoKnh3y0jPL7syChMcGZct6AeRFzp4nuORx7kosB0w2kJNEpWlZihRpPsL
	q1S+lCgVGivc4wxcqRu6NYIMZdBcvfpO0eDJuBfQrV1GWFX1YWMNbubcoteb5OfRTM9Tm0If+nn
	kzqEamsNnSG1734WN1by2JCJaT7jsZxY67/qWMHVcIe1xu3SKhx6x1xtBhfHBxklcmJatI+6p8A
	WOPjNFBUDMhf1EKbr/JIx1FPJaSr3c/406IJpEQr0R8G5H3FLu9lVRWov3KXOB03F3e4ITt+QGl
	wIE1qBKJd3HLpwC+GJNB8N4YxACvNo/b6ZZuBhbbgQb5WIYGnww0Pj4XMvRV6asI2DrhHSpAy1z
	ySUqWizq6LKrAelILTH//UXrdarn6sBez7v6Fd54FDuMRBU+8+/ryfIO85+xI=
X-Google-Smtp-Source: AGHT+IHrkcPaJLyTM5pJbJ/XVcfel+4u6gv+3P752b0IEbbyKeVVUPlOZ4xL4VMnAte1FxD358/CqA==
X-Received: by 2002:a05:620a:40c4:b0:85f:82c1:c8b1 with SMTP id af79cd13be357-8907011583dmr3539276185a.46.1761333000331;
        Fri, 24 Oct 2025 12:10:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c11e631e4sm442634485a.44.2025.10.24.12.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:09:59 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:09:57 -0400
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
Subject: Re: [RFC PATCH 09/12] mm/huge_memory: refactor change_huge_pmd()
 non-present logic
Message-ID: <aPvPBS5H0E9OXEo1@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPvIPqEfnxxQ7duJ@gourry-fedora-PF4VCD3F>
 <2563f7e1-347c-4e62-9c03-98805c6aa446@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2563f7e1-347c-4e62-9c03-98805c6aa446@lucifer.local>

On Fri, Oct 24, 2025 at 07:44:41PM +0100, Lorenzo Stoakes wrote:
> On Fri, Oct 24, 2025 at 02:41:02PM -0400, Gregory Price wrote:
> 
> You can see it's equivalent except we rely on compiler removing dead code when
> we use thp_migration_supported() obviously (which is fine)
> 

derp - disregard.  End of the day friday is probably not the time to
be doing core patch reviews :P.

Cheers,
~Gregory

