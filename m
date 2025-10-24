Return-Path: <kvm+bounces-61050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 251B8C07CB4
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 157C63BBB57
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696B234B19A;
	Fri, 24 Oct 2025 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BGyX8JeR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41D4334370
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761331269; cv=none; b=crhFpZWg2+VwSTP8i57G5/MDzrmpAvl/6laX79q8yEY112ne7SULcagR7td7/pJ5Mw2M2G3helkJkuK7CuS/EX23aiSqHPgCJJtp12wf1a914agCXWjYqE03kE+d+UgsqGAY7xF6OqzgxGs2AJCrl+KnvTu+m8PMTnx80Ka/LwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761331269; c=relaxed/simple;
	bh=0nC8tJfsbUxYAiM3oB8e/6iPoDpwQx4IwD1lKsUxMmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5GHzhcFoYqSmVJskDRBJI3RROzUoEOELW7CD5dXU7QWtsUvf4DIdF6FwbENwFPzux+5VgfCUZ7hCoHWnNDW4qsln84syWy1pgWWlJ7irbsO7b7WTYp/k1zCxg6u98vVg54qiKsMVmkSm7XeMC2WTq+AYc0UORFI5t4GeogFjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BGyX8JeR; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-88e51cf965dso315735785a.2
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 11:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761331266; x=1761936066; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pKqOWG1gpzHwxwYl3SQC/dTHK3GeimTlZWo8wLiUVXY=;
        b=BGyX8JeRXEcu4pr63rHWRLPkb+MIPvJk1pfjW/kGtqHWCx/l7kobKlb6qKNA4J5LvK
         6yTqO4lbvILYPnhvyamfWOyygZkULwde22ElPZcvDjAbrZf35Bjbuvr0uF5pAlYUuliX
         45Ypq8+gYGFk0DNuaJE/5KuPXKhupuGY2eyZSnuR2TLUIahRmhs6v1k1GHZpWOUuolPH
         Ch+Hzyquuq1vwUzB6sjGuFajYHxKZb6M5gB9GPXEaqIWpOKXltFC/7q4SYswK3eAvp23
         TWoo/Kb5dx+2BSk4k8QoWyX8gC+bEhTY+UoGX6YtShx3Ph4ag4IQPGzlIpm4FJ4R2xof
         CsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761331266; x=1761936066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKqOWG1gpzHwxwYl3SQC/dTHK3GeimTlZWo8wLiUVXY=;
        b=jJeRb2P5XiQaw7s9v86WB7SMlNzcm6zwB3qZ+a5hiedZsdPMVVI2Lo7f5Zjizbk1sa
         HE+aJyL19SuAcLimLAUQ3yMy+dVikUUCjlwxoiHclEpSuGNV9Za7asEq1NtDI/f6RK9n
         2qTS085CS7c0auFKPL6Qt0Ex4uu2zTX90RDcghDO1Al0X4Ghfze+HQ9INhidtU18/9MY
         rxFUgb4ZjC4TQ8LcronCxHKzz0Cf4aSbnto9U7t/3tI+5SITM6uVgl6VAKKuDUklRIco
         MHXZG8hKdLwE5bC6nWreqJRsU+BCK7nCieX6hw6uJZGVYYFaNfEtIXFwfQAfDGMsO7a6
         m26Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKLo2thLxoFDMmSmnjeHMthksHyuKNVjUtFbkIbwMOwA0Enn8Fnagfr0BR4BfcRkpsrkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YztEHFpBi5bapCWU43KiwbYBYLwCUg+4B+jJd/e+FBeu6un/63a
	SrP30/jT5HQO+3fdwfUSwBmV4QrNa+Fs8JJ02esFbGkSIE2niW6l8xA9oUYiv2irprE=
X-Gm-Gg: ASbGncs88hTuPhjMhxirUmvUHC+/zOAPI2BDgULAhfYN1Iqlp78/Wvj8k6JddkbxYde
	K9FslZPSbMZ8Yz9MNMgTFoq5xLKHVOJEMX1WoivF/JEpE3IxuM6+t+r9gnu3tBd6Iky5sGAZwru
	+zo7zxDCsLMbdJvnG2hzdYi9FsGRvL0eWBSf7H3SyHdkK3T35Ap75WBufxjTGwF+OARAuQ3nI0d
	MeRX+ZJ+RZn3k4JWO2/cWruPOVm/EUkzIFOsULuujdA0hy7WPOqjj5YEBJLA3PvN+tjLdDxQVKU
	BzWWfBk+YHeeebJqenIu4wCNthsXz7a1YQ9Djh/6nzE0dFp2FSHaZegK1UHc3YVM1Zo7GuXW/Kk
	5tTcOVmtmj9jTaIMcklELW3dhAK/2PmSrq5kJElAO72UGYdBbmBUC0pcGs6hrIlaqqQt4ro1b0y
	/PgnaJ3Czfy3kHbrrkvMTi4A8dYmKUNQlNk8cTHdWsWnW7/cyDGmSTMoVrP8F8KW8Fiy2AJTr6R
	UDS9Yt9
X-Google-Smtp-Source: AGHT+IGnY4R12t5EHq14eSTeJNU2ADxULRmUNWe43hSkC8AnH74fLNRTNtzJmefk6NfxewScJ3xiIw==
X-Received: by 2002:a05:620a:190e:b0:883:5640:b0da with SMTP id af79cd13be357-8906e2cf39dmr3403918985a.3.1761331265598;
        Fri, 24 Oct 2025 11:41:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c0dbcd225sm441582885a.12.2025.10.24.11.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 11:41:05 -0700 (PDT)
Date: Fri, 24 Oct 2025 14:41:02 -0400
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
Message-ID: <aPvIPqEfnxxQ7duJ@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>

On Fri, Oct 24, 2025 at 08:41:25AM +0100, Lorenzo Stoakes wrote:
> Similar to copy_huge_pmd(), there is a large mass of open-coded logic for
> the CONFIG_ARCH_ENABLE_THP_MIGRATION non-present entry case that does not
> use thp_migration_supported() consistently.
> 
> Resolve this by separating out this logic and introduce
> change_non_present_huge_pmd().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
--- >8

> +	if (thp_migration_supported() && is_swap_pmd(*pmd)) {
> +		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
> +					    uffd_wp_resolve);

You point out the original code doesn't have thp_migration_supported()

is this a bug? or is it benign and just leads to it failing (nicely)
deeper in the stack?

If it's a bug, maybe this patch should be pulled out ahead of the rest?

~Gregory

