Return-Path: <kvm+bounces-24659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43571958CA0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 18:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE905285DA2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA411BB6BF;
	Tue, 20 Aug 2024 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Q4GwamGV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2947B7E59A;
	Tue, 20 Aug 2024 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724172989; cv=none; b=GzDtPQ7bKC8KhdHhB+tqAaKmZAs2Kyuyrpymo74b2y9eGX6SQ73AZz1/fdG3tx6xVVi8onthdeEOIqFSw2NegUW+WA6QRlOGuBgKV2TdqBd3ulWAxH/J3xB5ES5mr9uoSpOtQFjde2atF8UjgwdbiMlx6tsjd6P99GQv3evYpFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724172989; c=relaxed/simple;
	bh=3IWBNMxVlkA05qY1CDuZJnnXqlmH8EbjZGUMVsHm/+U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mSYRNowRWFeKpvZhZpYnnsmCV6PZB/cDhXy1nncqJAhQNJfUAjlljCcyIzymfxYpB9wm4WVYY+Ui2J4Cm6aidFbNzq2duKhn7eG6AnxPEC37MQW5uhC9JrUjUb9R79T2q6azbAKMiv7VUI9D7wUZCLwGP2ZjkBLnObtKvvsfUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Q4GwamGV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47KEYqTD022348;
	Tue, 20 Aug 2024 16:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=jzY5T8RZv1PP7op27sD8n0SO
	NGxQfSzjHm+fnS2Ly20=; b=Q4GwamGVnUYHezWuHUjtjza6A/lLhwDxn1B0wORk
	bTlnIlWzNfi+wdhxzaABCNC/EMT3P7WJx6vG6pV1Fwn5PVyJfdT53/ZOpvsxCh+x
	yRRMs/d5cYjyhzv1WRhQYp6A20O8lgMVpsicruTmmAgl5STF1ExdY9JD5rLzcptl
	OB9oWUcGUEINslDeow42p7Z9UJLQH3+HKEI15Zq8UVGnNQvk4XaLi16dJ4zRtuEX
	PU9LejQ20kkidZ0OSAwhbBsd/qS3WT2NmyjJdtJyhxXbWsqaupLPxecTuE6SkdVb
	XB7+CPgBlSpH/P156LOeoP6utSCQjj5j7lq1U40Zb9BwRA==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 414pdm9ngv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Aug 2024 16:56:12 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47KGuBDx007487
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Aug 2024 16:56:11 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 20 Aug 2024 09:56:10 -0700
Date: Tue, 20 Aug 2024 09:56:10 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Mike Rapoport <rppt@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>, <linux-coco@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
Message-ID: <20240820094213541-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <ZsMZ8C2lnpMW+BT5@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZsMZ8C2lnpMW+BT5@kernel.org>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: BsZBnYdjUKxH8zs16Q3X3BsOufoDwHwH
X-Proofpoint-ORIG-GUID: BsZBnYdjUKxH8zs16Q3X3BsOufoDwHwH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-20_12,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=850 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408200125

On Mon, Aug 19, 2024 at 01:09:52PM +0300, Mike Rapoport wrote:
> On Mon, Aug 05, 2024 at 11:34:49AM -0700, Elliot Berman wrote:
> > This patch was reworked from Patrick's patch:
> > https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/
> > 
> > While guest_memfd is not available to be mapped by userspace, it is
> > still accessible through the kernel's direct map. This means that in
> > scenarios where guest-private memory is not hardware protected, it can
> > be speculatively read and its contents potentially leaked through
> > hardware side-channels. Removing guest-private memory from the direct
> > map, thus mitigates a large class of speculative execution issues
> > [1, Table 1].
> > 
> > Direct map removal do not reuse the `.prepare` machinery, since
> > `prepare` can be called multiple time, and it is the responsibility of
> > the preparation routine to not "prepare" the same folio twice [2]. Thus,
> > instead explicitly check if `filemap_grab_folio` allocated a new folio,
> > and remove the returned folio from the direct map only if this was the
> > case.
> > 
> > The patch uses release_folio instead of free_folio to reinsert pages
> > back into the direct map as by the time free_folio is called,
> > folio->mapping can already be NULL. This means that a call to
> > folio_inode inside free_folio might deference a NULL pointer, leaving no
> > way to access the inode which stores the flags that allow determining
> > whether the page was removed from the direct map in the first place.
> > 
> > [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> > 
> > Cc: Patrick Roy <roypat@amazon.co.uk>
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > ---
> >  include/linux/guest_memfd.h |  8 ++++++
> >  mm/guest_memfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 72 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> > index be56d9d53067..f9e4a27aed67 100644
> > --- a/include/linux/guest_memfd.h
> > +++ b/include/linux/guest_memfd.h
> > @@ -25,6 +25,14 @@ struct guest_memfd_operations {
> >  	int (*release)(struct inode *inode);
> >  };
> >  
> > +/**
> > + * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
> > + *                                  remove them from the kernel's direct map.
> > + */
> > +enum {
> 
> please name this enum, otherwise kernel-doc wont' be happy
> 
> > +	GUEST_MEMFD_FLAG_NO_DIRECT_MAP		= BIT(0),
> > +};
> > +
> >  /**
> >   * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
> >   *                             If trusted hyp will do it, can ommit this flag
> > diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> > index 580138b0f9d4..e9d8cab72b28 100644
> > --- a/mm/guest_memfd.c
> > +++ b/mm/guest_memfd.c
> > @@ -7,9 +7,55 @@
> >  #include <linux/falloc.h>
> >  #include <linux/guest_memfd.h>
> >  #include <linux/pagemap.h>
> > +#include <linux/set_memory.h>
> > +
> > +static inline int guest_memfd_folio_private(struct folio *folio)
> > +{
> > +	unsigned long nr_pages = folio_nr_pages(folio);
> > +	unsigned long i;
> > +	int r;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		struct page *page = folio_page(folio, i);
> > +
> > +		r = set_direct_map_invalid_noflush(page);
> > +		if (r < 0)
> > +			goto out_remap;
> > +	}
> > +
> > +	folio_set_private(folio);
> > +	return 0;
> > +out_remap:
> > +	for (; i > 0; i--) {
> > +		struct page *page = folio_page(folio, i - 1);
> > +
> > +		BUG_ON(set_direct_map_default_noflush(page));
> > +	}
> > +	return r;
> > +}
> > +
> > +static inline void guest_memfd_folio_clear_private(struct folio *folio)
> > +{
> > +	unsigned long start = (unsigned long)folio_address(folio);
> > +	unsigned long nr = folio_nr_pages(folio);
> > +	unsigned long i;
> > +
> > +	if (!folio_test_private(folio))
> > +		return;
> > +
> > +	for (i = 0; i < nr; i++) {
> > +		struct page *page = folio_page(folio, i);
> > +
> > +		BUG_ON(set_direct_map_default_noflush(page));
> > +	}
> > +	flush_tlb_kernel_range(start, start + folio_size(folio));
> 
> I think that TLB flush should come after removing pages from the direct map
> rather than after adding them back.
> 

Gunyah flushes the tlb when it removes the stage 2 mapping, so we
skipped it on removal as a performance optimization. I remember seeing
that pKVM does the same (tlb flush for the stage 2 unmap & the
equivalent for x86). Patrick had also done the same in their patches.

Thanks,
Elliot


