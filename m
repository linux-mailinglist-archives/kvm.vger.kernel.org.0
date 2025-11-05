Return-Path: <kvm+bounces-62054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA373C362CB
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 15:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD8676278D8
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 14:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3882032ED24;
	Wed,  5 Nov 2025 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="gCDf5z05"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77528322C67
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353751; cv=none; b=d1LXFWaQDKSAfu7EVP3EFdhJCXGyqlfdPRS68s0mBg0EhmzEhJjVuhu3iCK1b89VI1hLmrZWMNNE6xnBD+gW94LuV54o+gvUcBSa0TksBHECkjHj7qHJDMwmUSD2pH9yeD/5QU+5P9mEsgG3MVDRmqhD2UdcOMJyo9NZYflFxsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353751; c=relaxed/simple;
	bh=ij2iHrslX/5yNAV81WvwyiP5ZRrrhcDqQSgtHEa9ZoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrobb3pDFGpIjxtRmqqUZrYscLHFGtr5w2XuNgpA42b8PtJXhnxaDgSUJD5NMVvhh67YysERw1FEUpWgDtubLdCKVF6hxZEaEkNyf1udN8cPoAzx8hxeTyJ4deGmS4ovHMt8zoc8TSaLCfxHE/Pg+XQKUMpic2Z73f6j/CX65HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=gCDf5z05; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2148ca40eso198256285a.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 06:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762353748; x=1762958548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCP0hsq/q40gFxNmjoVFcp0QbOx89aTWebuusBQgCaY=;
        b=gCDf5z05uYtlJggKnF95ezS3J3umvz7sQMNDZDnGK8dtKLvayu7kdaLUtT1vMZ6cHs
         1GrwbtfIe7scOFlP2tQeblKFtqfnBbDDvWuaerJCvF4fbX4Iuw1jMMO5qNBS6ZY5ORf7
         wlXA8FlARkhwl3/zBiBwJU4aOeCxfoymxp+HA7s9/gBrOxzS0LNRs3+Mbv6zW6wrbKgS
         Vw1NtjBOiZPKJ476QYp/x9lkuvghR476RYKYUJr6/ygsD+kVyEil9ToZF0qbl82FpAPl
         jncikulGE0TeNC1J/5fCUZfNhIKnf6FldJa+Hdi7S90irvpaNARjjyogJGnYymejeFSJ
         J/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353748; x=1762958548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCP0hsq/q40gFxNmjoVFcp0QbOx89aTWebuusBQgCaY=;
        b=ne8ZbsBtpLtHxX+fc1Tqkf7otjj8SjEhh0WWlBnp/KBqRC4cM0pz1ZIwrEucsifzNb
         oT6rK51e5FJONzROFpMpKYBGvRq6v5VMD3TGACU538c985yxKZ2LFjjygGjlC+as7PjG
         aU3VezXjx7zDdnzddlvkH8ts9NsnpiPTCqTBHftTjuqVI3OSflAgmD/W5YP/Svlb10Q8
         2nxu+dYVTPMCyEe1YYXfVD8tq+1WbPHFrH4xbsDQnFrTrvkBuHjDClOf/vPJervbgo1C
         jgxUU3ivJL7+KqJZilU4/T2pGYId0bU/hJgE6vyMnOMf9ySRvOPQ35e6ZZhsF93CMAF3
         xIOA==
X-Forwarded-Encrypted: i=1; AJvYcCUEOzhVHpURdsEO5l6a6v/FLoNtsGcHu59rlz51JqRkr1O3SqXcPdwenb/SdbGQ5rXMp08=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXLOFw8D8Ole4cBH4pKYUoLXRO8GgMWnK7x3+3Uzbj0IlE6Vse
	4tq6/l19eEnt+zArac+nV8Y0n1DG2IbO8lB69cvLxDB7U7JKGRt2L413HuQT4tsy7xU=
X-Gm-Gg: ASbGncupFR3GBEuwZiSEerj1V0JVZzZqr8M6whY762lGWjy9CG8oAm/FiCaHGb3256U
	ewnNpPE5P/YzmUF5+AoDWHgw4GF/IBWAbiRDIUWh4dM98eejDW0MMhT17l9mD7WqTmRx+IIq7BO
	e1fG05W2Dj11lk1GIb7UOLs0fcFx41o77RjlScD6UjLbTuxQNeuAVr+a8CF9VaedNTvMivMK0rC
	Cz1cDN/kwesrVST6zz3oqUYMT11fE9lZA8FY2V6VtAG3Xscn3Mvf+kvh48x1dtbmz4nHieUW9kE
	UQwa6U5pA/o8vRECT+yOqly92W5frJmTurfsycvWNWwhHM5Zv6mamZE5JNzi//8SrMiNkHM2lMI
	efBCLad6XVLa1I/Fs+lMHTXANxrUqs4jpHVLpivVSk8sb0VsXZaWhyE+/dKXYFOOO/1Rw94HWrI
	VrRREpTfXL9+V2CLxeG1coZHgZrqmp5m1eC5nbF+41b9h6pt/dyvpjdNkYa9mMkCN9+68vlA==
X-Google-Smtp-Source: AGHT+IFOPmymxkVWTStAmI1fSxsEHrX8n+cH3NR2hrKHNMeSwi6zTbwFsDY5mjtR5/Zbzi6pU1fUXg==
X-Received: by 2002:a05:620a:4416:b0:8ab:4ada:9b2f with SMTP id af79cd13be357-8b220b7f441mr375892585a.56.1762353748298;
        Wed, 05 Nov 2025 06:42:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b21fc36dbasm239867985a.19.2025.11.05.06.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:42:27 -0800 (PST)
Date: Wed, 5 Nov 2025 09:42:24 -0500
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
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>

On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> +typedef swp_entry_t leaf_entry_t;
> +
> +#ifdef CONFIG_MMU
> +
> +/* Temporary until swp_entry_t eliminated. */
> +#define LEAF_TYPE_SHIFT SWP_TYPE_SHIFT
> +
> +enum leaf_entry_type {
> +	/* Fundamental types. */
> +	LEAFENT_NONE,
> +	LEAFENT_SWAP,
> +	/* Migration types. */
> +	LEAFENT_MIGRATION_READ,
> +	LEAFENT_MIGRATION_READ_EXCLUSIVE,
> +	LEAFENT_MIGRATION_WRITE,
> +	/* Device types. */
> +	LEAFENT_DEVICE_PRIVATE_READ,
> +	LEAFENT_DEVICE_PRIVATE_WRITE,
> +	LEAFENT_DEVICE_EXCLUSIVE,
> +	/* H/W posion types. */
> +	LEAFENT_HWPOISON,
> +	/* Marker types. */
> +	LEAFENT_MARKER,
> +};
> +

Have been browsing the patch set again, will get around a deeper review,
but just wanted to say this is a thing of beauty :]

~Gregory

