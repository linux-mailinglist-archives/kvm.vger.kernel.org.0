Return-Path: <kvm+bounces-61428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCABAC1D6B6
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB504248DA
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C23D31AF2D;
	Wed, 29 Oct 2025 21:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="kapBewHb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E531A577
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761773025; cv=none; b=bo4sPRTIOFbURbztJBzJy7WnGbxXllV4UvFmAcKqtDsoSJF2Yx3T5Ag/eqOQEeAwSl8jDbT1akf8KKgFKkgJ5hC+0pbOvApdRE0Tu3BaaBTriBE5+EGCUO8CHG3YafeSoqdEUFkWBrPp1PFa1lzeHsiVxGbBb6Q2tMSB0BU4GDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761773025; c=relaxed/simple;
	bh=ehgfTYPPDlsusZMBOPSQ1VgmMj1ez7+siAFBL0GrCb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jfrk9mRwAz1SyHZ/82u4rALW7i58NQDuYytg2ho3JzVDdscF/gA5aqCW+DCiHtwy7rpS5afto6CkhRtWkspkH373JWVw2zMc+KKXPUxvmx3tli9nBpUnw3av0dMh/fVFauCQC9ayVyjbBXKC5cXWJag30ykHa0PH2sE7GmVqwH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=kapBewHb; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-89ec7919a62so28724785a.2
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 14:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761773022; x=1762377822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRjtLU1r2HfZv4PRAYf6oYIopT/Rmxw6gRmhQBXOWjA=;
        b=kapBewHb6dSh/ptT//a51gk1TGTcazKjTHRFueGiQDPd5O7n6qW3dv9oomw74wvDu6
         JwYB8vB5m/h/8osiroNMK8oqsJGSJbxHw2r5tPRWPxSRi4ed7TDcZPDwMiFPi+ELtkNQ
         hGjxmHj10dNk1CPOz2oob7bZ47ae6s7lqo+bIJpq5uhqyV/7xPA8LpTdNo/VW/o4p4AF
         745l4hmuH8wAWXPzhAwqEj3qOZaz7EMepbM6t/AGf4pcBVchWbXqKUgDHmHCf+rbG8IS
         hPhJ+/petaX3RoL500AKYSltpyxcY+iIMEAusD9wC6LPCd93eskVGzsnE7hDeKpAb05y
         752g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761773023; x=1762377823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRjtLU1r2HfZv4PRAYf6oYIopT/Rmxw6gRmhQBXOWjA=;
        b=NE592x+qIZfNPpO+KnyNQoEInQcq8Oz13e9tKwJ7IWHu/rx9+zudueNjfWBCsB0CnI
         oprV8uYhRxiIVOpJfhLYgwHpDrRU/IjXt5ujFX4yaovKxvISvRigaElOg8PXr9MIzuL+
         ngJeyPsu8fCXUZuUHEBDdrhjx/+ZIBP8Z2drfpiiCLcdgLKOJYvoFjjo/bRVolMgl/no
         YrFXU9dAtMS55T/IkiQQnTLXWZDqlGcahnICDeMJ260jEZCCC3ygUtY/CSntL48N46R1
         lBpFAJjPB7wPa043unTrGvyRv+B1pPhth+HBlKdCgSvizliJxCwq+0JDQpAcBOCCz9Tl
         mApA==
X-Forwarded-Encrypted: i=1; AJvYcCV5YYQdJ6NEzubCJ2eFClbuBGEJmnZKv+O3uN/rGbcONNAee4jHDW7m2u0LDBcLjJylJ+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YySfZjMtwmQjEf7n3Dto31hXX4CP9ExRGjvEBPwRzBKIKNCTN9/
	hGMjBlHumRmFrh1HnYKly3XTbtppFVR+blcr1iWooyxeQb8q9ob5KSOgc+dlQ+o4hlg=
X-Gm-Gg: ASbGnctHKdR7jINm22l6YkVC+t6CTmCovfXf8mRFy3IeT6hWslZB7v5yfL6eUUGjL1x
	Ym94jzMyPEB/YTv0NsyGguzmZMJOK12LTxJz27K048Ht4ebCdjCh2q2uMCuk1OkxLUPHUZkGV8B
	nASLowkNeDkLaICUB7TcEvdVbPM5t8cWPAcZziR8BiKBhtaaoqxPRHSwyUsdqHIkOMel7lZpXIR
	4imiC37f0TnweHs88t4J1S6cYH0l1c35jJuUjOoQG44IiyjKuJiWtZiKULIMfaer3xb2jaW+O6c
	rVRvE9kId5NP2nNckDM89avJ+dWiIF1U/Hm2HCRafNIX8bjpb03Tx+ZqTVUqnXp4D41gvrGp5yC
	kw6VdM79PJ0GG3+h7x/wOoMdCiNcbsmqrQmBLDXyj8J5JHaPTO26P5EWo/GzPnEVc9vpv/g6JyN
	VZMIXRwu2NJf2srCW6U86LtBbKFXbv8H/4plXOwpDxth3zzzenfNL0YjurlfY=
X-Google-Smtp-Source: AGHT+IHIvemppeW4VU2bcQtfcjjrB/a+ZhJ9fpfDcYpqh7YEbBY+IwMLRkdQTC8NbNXnWXScRwyJQw==
X-Received: by 2002:a05:620a:29c4:b0:82e:ce61:f840 with SMTP id af79cd13be357-8aa2ea07948mr164184685a.84.1761773022583;
        Wed, 29 Oct 2025 14:23:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421fc6fsm1114391785a.9.2025.10.29.14.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 14:23:42 -0700 (PDT)
Date: Wed, 29 Oct 2025 17:23:39 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <aQKF2y7YI9SUBLKo@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
 <20251028124817.GH760669@ziepe.ca>
 <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
 <20251029141048.GN760669@ziepe.ca>
 <4fd565b5-1540-40bc-9cbb-29724f93a4d2@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd565b5-1540-40bc-9cbb-29724f93a4d2@lucifer.local>

On Wed, Oct 29, 2025 at 07:09:59PM +0000, Lorenzo Stoakes wrote:
> >
> > pmd_is_leaf_or_leafent()
> >
> > In the PTE API we are calling present entries that are address, not
> > tables, leafs.
> 
> Hmm I think pmd_is_present_or_leafent() is clearer actually on second
> thoughts :)
> 

apologies if misunderstanding, but I like short names :]

#define pmd_exists(entry) (pmd_is_present() || pmd_is_leafent())

If you care about what that entry is, you'll have to spell out these
checks in your code anyway, so no need to explode the naming to include
everything that might be there.

~Gregory

