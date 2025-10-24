Return-Path: <kvm+bounces-61055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2687FC07DB0
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA1EA3BAD49
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFAA357A44;
	Fri, 24 Oct 2025 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="djkYqlQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20871357A24
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761333134; cv=none; b=geY+estTwabSJv31gZqjN60Cl5YyxjBfqkW/ljD8or87kKVvL4ULVPmR/ZVmL1Fk/MWE7T0ida+s4Tofzg0u9sfoKl/90gnNcgYzv8ukXp4WZh2Hpv/VBoBFVhPgkq5EzbLAbe4p3hKRnzb1hUrQ53jE6HVnIbYUIp4hldM587c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761333134; c=relaxed/simple;
	bh=1HPzzMYQqxXuYn0hH8eWdbKEvenGvJhB7Md6BvkK5BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSxFnF8hiTUWdhjEtHswDQepfmLyboyLr7TfQvktHdTU/Nyw9wq2Lp6m4EEQpB+E6eOzHR8kaR5wbighVhwMTJOX5QoanMlIRRDUk00O8hy5o937ENuvg9s7nhx2m2deq9pah4Vn71rEND/JZ7tTeddHB+wfYukyfjahE/ksYL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=djkYqlQ2; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8901a7d171bso237676585a.1
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761333132; x=1761937932; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BCR40IXSwb8+XBgjln+OQr+nWcDb8wZGch2v8uE7uTg=;
        b=djkYqlQ2uBE1MVPYP1auCvtzMJ0Wu2EtdfpvkXLGD90SupS9f9s9/4rdKlaMhfEJox
         DX/90A+NeF8nW1jkcJ3QJFRXNWojxQIuy6d97DSYvgLqJLVlDYpn0GN6Fo0WgvyM4pH8
         Do0eRekndgYnh3AbtIMo0dTPH5EaHXWzEFzHMt3jiqHF5oFC2dS27VmhFEggEA5KM5xM
         B5BT2gQH81z4fIfWm8uW8m/1Id4k3mjfbTaD9gvQUr+TESeom1DF+ui2wUjr/CgaY4+P
         T16BZt1efnbfpsmkhUb4PW6+F3Fh55DVIgQNJJeehyKgzH6KB2UkkUuOSU0AjqDlm1V6
         ebqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761333132; x=1761937932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCR40IXSwb8+XBgjln+OQr+nWcDb8wZGch2v8uE7uTg=;
        b=p12XfUatOPSD3tEQLYi3Pf+aqVcxmJdq2IjpJ3jIw9WSAFE29ZmpngAuKR/m17fa4L
         z1HdKJeFlFqpAllkREWsHKHrFOPrCXiLAWiyEAqyfrxoOTi97p/NCsp9R2jCYtftSukB
         k5wS5/RYaeyrbndLlBQXZkQL/PE/vrG+u+oSB6ae/en61ML8055Ybc1rdyNZte58GKu+
         fpICe3cdAZcAEMuMZ7zhsbEfhdYWI9wg2xsRLY+njnnsTLAFvGEjEt6Npfo0F4hfUAyG
         ta1dJFqHL1V4Z2+TacCIOz4OkVygS/D2O8M7plkrlzWiRj5JyJ5k8htZzQrwt556ZK9G
         z2og==
X-Forwarded-Encrypted: i=1; AJvYcCXXfUWRzpkNv+eauWfjj2D6zcPAslZ6KqLWLFZQpNnR1KowryrlOqZgsOLNUZKebCGqHe4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp5DX2y+m1ao5NmpJaRBJ8hl00zj4DFpdM231JKcKsTtuSG0Oc
	U20KgpRp4/VQDNswRXT7SXhiZhKNKvpaEzcHjz+vx8z2I+UTxGqVwVEabf9gvPd0/bc=
X-Gm-Gg: ASbGncu0z6YJcegCV0TeMw6bfpbnNg74SajYglSu8zKCSb5gYrU9ih8h0kJy068g/u8
	ac2GOjz+jp7Qq6ubfhSv87KNMEh1tvkCD030Zk6c2WkNGbYTFiGwKDiR1EDM6xfJq66p30EHgeQ
	HbleGGWrN7NawNJcPG/NzrpOBUPAVmTcUJbJvQx8KOwUScsvNeIh7EYM14iFrVdVGeP1nIDWsTt
	qoz0fYsz6nwVBse2cN74U1+YcWT5HCCmlIY/Au/MtOYR6rq0nCDWmNVPKOmylJRYeNzLXPuHpIS
	PCwWXr33K5H2bOZ/yG0NRBdMBPwNjaztNwVyQaUg5FbjALo0L0uHg4i3Zd5QsWv3bDekhFjJlua
	Iw6IzzXXuibr8Td9Mk6PQDeO9698Wmf1aiqex8cYOsxGTPRMDxJPAw+P2GzzeejJcwONADjdb2a
	wm1/IYboQMwV7GpHRjSMe/7L+SNpfT5cOAYcGUKCSbt9HiBy3FvznGVkH87LE=
X-Google-Smtp-Source: AGHT+IE/iLPq0l1+7yrz/BbyhVyC9k5N0OQCI/Q9HFSHISzKMdQEsDIOj6nKXRkCdZrjDczCxThRnw==
X-Received: by 2002:a05:620a:178c:b0:892:eb85:53cd with SMTP id af79cd13be357-892eb855743mr2482012485a.42.1761333131934;
        Fri, 24 Oct 2025 12:12:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eb805e0869sm40330861cf.1.2025.10.24.12.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:12:11 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:12:08 -0400
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
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>

On Fri, Oct 24, 2025 at 07:19:11PM +0100, Lorenzo Stoakes wrote:
> On Fri, Oct 24, 2025 at 01:32:29PM -0400, Gregory Price wrote:
> 
> A next step will be to at least rename swp_entry_t to something else, because
> every last remnant of this 'swap entries but not really' needs to be dealt
> with...
>

hah, was just complaining about this on the other patch.

ptleaf_entry_t?

:shrug:

keep fighting the good fight
~Gregory

