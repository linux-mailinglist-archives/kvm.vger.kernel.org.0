Return-Path: <kvm+bounces-62091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A97A5C37126
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 18:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6298F4FD56A
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 17:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC703370E8;
	Wed,  5 Nov 2025 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="SH8jp2DI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CAF31353C
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762363279; cv=none; b=KbFrEU5ovaN4vexdlW/zJuU2omCCQo+NKOdZarZJR0X8vfvTLNVqQ+XQYbSZEW4KVEECIEPuBodE8e8ri4mJdPj1DWYgU7ldMwrTDkOMXGZPc9LAInMdOUD8Po/DPuwcsijT8z4mZOAdLa8ISkUZ0SejqtFku3h9qWaZrZ/MutE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762363279; c=relaxed/simple;
	bh=R+scxNFIJ7A2QKHZGih1Ehc3wdUpOLgJ/krGtFdCacU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dn0nKN0yTvwbVZqco0P35lnzOigeaA1tZpcq8sGD5cP1QJNJW3m889pBNgn394rbuUCpEXY3DcGwig5SU0OPpNMLdtNoK+k32SjJtkpF3zFqiuwg4HY8nHMGEQHI0/7bOI+U2jkZ/Cm2D+BAnmk8PAuemOVgbfA+0FTdrrXqWLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=SH8jp2DI; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87bb66dd224so1173436d6.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 09:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762363277; x=1762968077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cq2mS+yWhZev0zm4YEm/j+lSP0FbcQSTW4gUm6tSNU=;
        b=SH8jp2DIufEX3vRN+bltek/lJi75b+p+z6AIN9nyUDWTVYCvATPDIaqoM3LESvI4FD
         8nquf5IVH6r6cI33uAXnizUpTqbHvleYQT9kAAY4b0ZbCwQlwYzE3GQuW2Y6sut/vNOW
         o3iLPOiHZJM+c3dlQjap/e5ySWpcEqF+1Rfwrb/26DtOzWcSjuSoveArv3xqAA9c56eX
         Wf8nxoHDCzeCmeLzkzXWAQ7WhGjvqn8Wk7ZgL3TfZvDJRS8xIeJ2VQMyPMS2Q/xKQqPz
         hHDtgt+7wOO5Flg+YPcQTR+oqDeKyusFE0U4bnVdqJ4pi9l3rGcyGzEmTGvr1ZnLdMkg
         U/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363277; x=1762968077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cq2mS+yWhZev0zm4YEm/j+lSP0FbcQSTW4gUm6tSNU=;
        b=MUDEKKooPZZkoNupzeXPwyhbrnwUBJemEJzoXlVglf221bRDdqXXnSyJt6ZcW+8YrX
         DyQf7MT1jowosKJl1Zq2MyvPX5RGRZvJgVSVi0iCuyiOfCWCqK/viijzZjn2WHBZW54a
         hZk0BgushmhRdKI+gdAcRf8ELuopkanEwcngqHVlStDofGfehl8H2CCpM2/0sb9PgxUk
         7tRi+PkUjO/c6uBqNLW50M/OSw0rokq6vOPw3rt+oar1cP/TZgX/tO/f8c0WtbC2/ylB
         sVcLSW0pEwKyBRl1guuKZ0R7s8PRWngXVVsGMzX0opLxyI0chL0jK2ROhUG37nrzDr5/
         a3RA==
X-Forwarded-Encrypted: i=1; AJvYcCVv7+JGXIWcfITAMsjkGdQ9H0sPe7zbdys3sFrAd8x3j/0AcoxVADBUtvBP4n+okgRziFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZEBeDJRImE2EGnWTiG1oX+YzoCkan/McNi3zq0Nzjg3uRIkAw
	z68J03E3DV6F44l3uxeAg0um7HJH05hxz93tjE8lFmu28My7fjsMFXJ9D4zxojCUVEc=
X-Gm-Gg: ASbGncsII2XUcbo28bxulqUwxO5TA77h7/Mk64lNuY9pZNjd1UDUL6LFcjhTX4Xvwi1
	zTgWlxuBRztqjTRJpARiCVDBQvMRe4m07m9lq2ypnrhHu4IIAYNhAo8Xa5NKU21LBYFbae5gZwC
	r7SGIIoayCz5dFAAHEVM+DPptgPNfOUNhZafyZxnyrhppsDJoFXD10+0JOWXk/Tp2bGnuiTpbuH
	DktQe+E4bGcknLKjn0IXP2GU+tm6svBeUgrGW5/8uad/HSsF9BcigOydThddRT2noYBvKMZKqOT
	Gpli/VfpBNFWyBWuOvEih+aeoXXEbeYj37P80STv60vvCo95OUoqBJtXspnrycPaRRkPNgTJRJ2
	mdLPnd8PZUcUJvUOgdGvWVUr8TMNhgAtn2wRvao4n9wagz3pQuAoh2DDmPF4MWNAEcoW3+Ig76k
	opzwE9KnfE7YJp1bOfUOXHNf7wZIpGealLZ+poaQWMndr4VA==
X-Google-Smtp-Source: AGHT+IGCK5Ht7P6eoqM7YgVZ6ef4jlofMTj5LlbxF9x0JfdkYp0y/H774e8UOGf7CmqXFow5BgQdlA==
X-Received: by 2002:ad4:576e:0:b0:880:5779:d489 with SMTP id 6a1803df08f44-88071095623mr52524556d6.3.1762363276490;
        Wed, 05 Nov 2025 09:21:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880828c457bsm996916d6.5.2025.11.05.09.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:21:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGhC7-00000007Bv7-1e20;
	Wed, 05 Nov 2025 13:21:15 -0400
Date: Wed, 5 Nov 2025 13:21:15 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gregory Price <gourry@gourry.net>
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
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
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
Message-ID: <20251105172115.GQ1204670@ziepe.ca>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>

On Wed, Nov 05, 2025 at 09:42:24AM -0500, Gregory Price wrote:
> On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> > +typedef swp_entry_t leaf_entry_t;
> > +
> > +#ifdef CONFIG_MMU
> > +
> > +/* Temporary until swp_entry_t eliminated. */
> > +#define LEAF_TYPE_SHIFT SWP_TYPE_SHIFT
> > +
> > +enum leaf_entry_type {
> > +	/* Fundamental types. */
> > +	LEAFENT_NONE,
> > +	LEAFENT_SWAP,
> > +	/* Migration types. */
> > +	LEAFENT_MIGRATION_READ,
> > +	LEAFENT_MIGRATION_READ_EXCLUSIVE,
> > +	LEAFENT_MIGRATION_WRITE,
> > +	/* Device types. */
> > +	LEAFENT_DEVICE_PRIVATE_READ,
> > +	LEAFENT_DEVICE_PRIVATE_WRITE,
> > +	LEAFENT_DEVICE_EXCLUSIVE,
> > +	/* H/W posion types. */
> > +	LEAFENT_HWPOISON,
> > +	/* Marker types. */
> > +	LEAFENT_MARKER,
> > +};
> > +
> 
> Have been browsing the patch set again, will get around a deeper review,
> but just wanted to say this is a thing of beauty :]

+1 I thought the same thing. So much clearer what is going on here,
and I didn't realize we had so many types already..

Jason

