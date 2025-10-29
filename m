Return-Path: <kvm+bounces-61399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46EA5C1B566
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E09276E1F16
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32913246BB8;
	Wed, 29 Oct 2025 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XtYF3cBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7E1B4257
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761747053; cv=none; b=Guox0tyAH8MdT9BtWf1JelJpy+iRy4b3hECciXEee0OF6L2gj8HWIXwSGmVZ89NcGvkUKrf5QTY4YyyvQZpbQq9++UmFnbOpnBmvP1gRU9RPtzbr0TyFzOpkIDp0ngrlBzyIQc8pPerJoHbX3ar1bFG5Wg1IeIILPvVGVj5TJyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761747053; c=relaxed/simple;
	bh=FtkXBRR1i74hdYvMHxT8SXn72fikHIr5QYRX/FKzjvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ranJotoDOxFfz/aHh1pmf9EZboNypt+HNKDUfpqVUY4OOpbmwgjcNqIBONj+YyzMEYnWWBtVsy9IeS04g+wZkX8sEE5U6lr9L6PNdfwlSsIpw9rgy20nn5hdGF2v9GViepuWdp2ASfs6nNtWzvtw6CZ925uqCDD+aGCBCBksyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XtYF3cBQ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-87c1f61ba98so105479036d6.0
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761747050; x=1762351850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3gCBuq56/59adr8Ol0O4W3+IsGMOD3y6s+9TcTsiPOY=;
        b=XtYF3cBQ/iUolTaq0Qh4Wu/3nUIzHeTXQKWw3P1uEJ7RX5J/q+NHSZ90s2g+2F7tak
         5b0nlI5yabJThUBrmRjLTa1MrbtK2boO52QUqXpoG6pvXqItN1ByTDfFCk4wvSnbwVII
         UHKzqgWf/eR154V2f2iL1FBzr4RYaiE8Nxtrvpdwrlak7AmslIVYFSHLhJwSPdN0tmSU
         qUi6Iy2fUwbuXQPhaIkM/RLKVJXdsQOuUjUZZqz2Dy/XIrEkzLae8amIgt4NXfgy2Lnj
         AVKHykL6FOst8ffgc7l9mWVm9m8WEj3JTFjJAAE/YvzZmx03GvBm0xnVYzF5tmSl4PLV
         V6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747050; x=1762351850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gCBuq56/59adr8Ol0O4W3+IsGMOD3y6s+9TcTsiPOY=;
        b=tBPtQVJtY1l0KcCZQRaD8TYPjJhe4bCBg0PhJL1ai1BFNoHzcC0r8ES3Bk0hno2gbv
         0VBFLF2IBv0EaAK7RR2IgawOvcbHjbzK5JmIKgT+Z5BbhN9+wumXMDRgNRqtheBgkaGm
         F1EMF5fGmbu594kPO1TSEd2zXfIouyXhrQRVyHm3MG40K1AuDimTActEBqB/nzxiBF84
         z84dLPgw8DqQus6jTJzg+G5pFHRtRHPofK1jK6OM5GupZ85LeHlKy/9In+SxJwSiYNZi
         Kw6LvBCy/cGmDsHBY++LsMoUjCvnEto4lFtkvZluh86clED6Yr47Uo6k8OtRoBR4R+gI
         CWag==
X-Forwarded-Encrypted: i=1; AJvYcCXJBIMADcuTKbj31srwTR/C39YLsRU3WBtjlpO86taNy/DfQ9U/G9Wvcxl4pBLb006EDek=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOaS5A/WOhFhK7cvZ9T/dRAU/5q2zkMTKHaw6KktPcQahX1t3c
	3G0ujF6uJou5Tc15pAXLxlGHu4vlMqNq9w4NXdq+rs/CQyphp+oVkdTN/jEt9l3+eBU=
X-Gm-Gg: ASbGncsynpIdr3Gp3I/eObPQbnSjg+itX7pfQYZA6ZWsurYn6cOVTPrZ5SufTNpdeEb
	08WjFJ5U8tzsQnjrfRxxyx7kOo9N1lqTdsexfLEfUdZWLux+p85CRl6HXvo3HLxyelOG4TtutIJ
	3IEpFTJDsDuhdMILl5m1j9GTKxniXxWdGklCrjYJcQEBot/6tX1pZ17ywv+vxHeZvNrD0pCMoWp
	orlgJPMxz5m6awYgTQQxQ099N6TRkWxmDTkzNIqiiHXHAz2nNuHZV/Kz5AxUhA/KcBMq+e4u/kD
	xYGhr4HbwwZCha3Kd+bt5XTQQxAJe9rX2wfDM2QPps62vhgYyh2G3/5vt4H72c+c6TN5EYapkq0
	xV9gkkaeJEu5bCsAHTEbiHkN0jB/BIU1BSkO0G2JXZButw/+bIEKVgXvxsHr1Bj9BdaWp2VYYkA
	g9Yxx1/txNClesPzGttz2DUxKAMLDpnNgcCaaibFIyU4FaWF83bba3p2KH
X-Google-Smtp-Source: AGHT+IFN9EEFBAzfjpvQnmAHpqKEJbqdqdrZ9KL1PtSYGMem5wdE9qnodevFJl+GDHD76k8KE97qmg==
X-Received: by 2002:a05:6214:23cb:b0:70d:fa79:baf0 with SMTP id 6a1803df08f44-88009be5c01mr41077486d6.38.1761747050399;
        Wed, 29 Oct 2025 07:10:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc494ab16sm98679066d6.39.2025.10.29.07.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:10:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vE6sy-00000004etU-2Jns;
	Wed, 29 Oct 2025 11:10:48 -0300
Date: Wed, 29 Oct 2025 11:10:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
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
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
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
Message-ID: <20251029141048.GN760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
 <20251028124817.GH760669@ziepe.ca>
 <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>

On Tue, Oct 28, 2025 at 06:20:54PM +0000, Lorenzo Stoakes wrote:
> > > And use the new type right away.
> >
> > Then the followup series is cleaning away swap_entry_t as a name.
> 
> OK so you're good with the typedef? This would be quite nice actually as we
> could then use leaf_entry_t in all the core leafent_xxx() logic ahead of
> time and reduce confusion _there_ and effectively document that swp_entry_t
> is just badly named.

Yeah, I think so, a commit message explaining it is temporary and a
future series will mechanically rename it away and this is
preparation.

> I mean I'm not so sure that's all that useful, you often want to skip over
> things that are 'none' entries without doing this conversion.

Maybe go directly from a pte to the leaf entry type for this check?

#define __swp_type(x) ((x).val >> (64 - SWP_TYPE_BITS))

That's basically free on most arches..

> We could use the concept of 'none is an empty leaf_entry_t' more thoroughly
> internally in functions though.
> 
> I will see what I can do.

Sure, maybe something works out

Though if we want to keep them seperate then maybe pte_is_leafent() is
the right name for pte_none(). Reads so much better like this:

if (pte_is_leafent(pte)) {
    leafent_t leaf = leafent_from_pte(pte)

     if (leafent_is_swap(leaf)) {..}
}

> > Then this:
> >
> >   pmd_is_present_or_leafent(pmd)
> 
> A PMD can be present and contain an entry pointing at a PTE table so I'm
> not sure that helps... naming is hard :)

pmd_is_leaf_or_leafent()

In the PTE API we are calling present entries that are address, not
tables, leafs.

Jason

