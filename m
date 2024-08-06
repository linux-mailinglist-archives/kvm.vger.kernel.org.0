Return-Path: <kvm+bounces-23437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21CAD9498DA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 22:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A40D1C21C48
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643BB155731;
	Tue,  6 Aug 2024 20:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AcvFaBE4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD67B13A26F;
	Tue,  6 Aug 2024 20:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722975233; cv=none; b=SYQlR9WLXen5GhXvPMjnbe6PzuGfvMclyBECk0FtEcOtra1erTc9upZlH7T33tR333nY5TxFHAl4BWPySGD0fZVEb883cF0/4qZ7XgKltf//cKib1kM5i4O+TN/UUnSFqtQcd71f7X+6p40M+xftTsqeq4CYTdKl2eo+rsYweJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722975233; c=relaxed/simple;
	bh=X10fW4xZ4utywBi4x8MEx4TTJKnd16OhB9fY21ZFQWk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRqenDXopT4hMoySB6d8wT0ZjuqtGfdcFDx4ToL8z4LRIIalyzexxKJtUu42iYE2k+mV/+CEbUK+qnLl5pkqWA+bx3uAF2Qt7XUeSvtylt+GQaMvO31vXwNX4QC9F8dPSc6HVYnOnuuTXghnhKMctOW4A2qy+TC/ABGzC5ZjBGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AcvFaBE4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 476H6XV0026819;
	Tue, 6 Aug 2024 20:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=UFu4ZYsrT9QeNhud/VTWF/q2
	i6wyz+VqIaCaeWJSqds=; b=AcvFaBE4PsUB+bDfxJTBmLptWCDngbDIsVLEFon0
	n0UiNjVX0Fp5m7em/hok0E1JyjxCriRwbtATHOyiqkZROrCAzt06V3XKEdwwGLcu
	7uGzJFU8+KL8bqeu7+QSE0tusKpkS9PIkRRVdWx5Vo0WBsx8vJgDYE+A1olXBwtK
	O5CYiGYZafh14OZeWOwJsFhXnkiuLH6DhIakQPHrfeSUFPz4FmmglZHMXxpW7jTh
	64nlruB0Own/+cVxYb2K4BqZZ62zezYyRohLNR4wONLULfizJ7cE4jbYykrzIRyI
	lLzxDcotd/hM9iyjVBy4s8ae3n6SoZGRoXvC4Z79woebXg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40tuhvwbrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 20:13:38 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 476KDbMc022236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 6 Aug 2024 20:13:37 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 6 Aug 2024 13:13:36 -0700
Date: Tue, 6 Aug 2024 13:13:36 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Patrick Roy <roypat@amazon.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        <qperret@google.com>, Ackerley Tng <ackerleytng@google.com>,
        <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, James Gowans <jgowans@amazon.com>,
        "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>,
        "Manwaring, Derek" <derekmn@amazon.com>,
        "Cali,
 Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
Message-ID: <20240806104702482-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <3fc11402-53e1-4325-a3ee-5ebd616b5b63@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3fc11402-53e1-4325-a3ee-5ebd616b5b63@amazon.co.uk>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: yyoslRIj78S508HeK5WVI-AlUsoICfLY
X-Proofpoint-GUID: yyoslRIj78S508HeK5WVI-AlUsoICfLY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_16,2024-08-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0 clxscore=1011
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408060142

On Tue, Aug 06, 2024 at 04:39:24PM +0100, Patrick Roy wrote:
> 
> Hi Elliot,
> 
> On Mon, 2024-08-05 at 19:34 +0100, Elliot Berman wrote:
> > This patch was reworked from Patrick's patch:
> > https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/
> 
> yaay :D
> 
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
> 
> My patch did this, but you separated the PG_uptodate logic from the
> direct map removal, right?
> 
> > The patch uses release_folio instead of free_folio to reinsert pages
> > back into the direct map as by the time free_folio is called,
> > folio->mapping can already be NULL. This means that a call to
> > folio_inode inside free_folio might deference a NULL pointer, leaving no
> > way to access the inode which stores the flags that allow determining
> > whether the page was removed from the direct map in the first place.
> 
> I thought release_folio was only called for folios with PG_private=1?
> You choose PG_private=1 to mean "this folio is in the direct map", so it
> gets called for exactly the wrong folios (more on that below, too).
> 

PG_private=1 should be meaning "this folio is not in the direct map".

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
> >         int (*release)(struct inode *inode);
> >  };
> > 
> > +/**
> > + * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
> > + *                                  remove them from the kernel's direct map.
> > + */
> > +enum {
> > +       GUEST_MEMFD_FLAG_NO_DIRECT_MAP          = BIT(0),
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
> > +       unsigned long nr_pages = folio_nr_pages(folio);
> > +       unsigned long i;
> > +       int r;
> > +
> > +       for (i = 0; i < nr_pages; i++) {
> > +               struct page *page = folio_page(folio, i);
> > +
> > +               r = set_direct_map_invalid_noflush(page);
> > +               if (r < 0)
> > +                       goto out_remap;
> > +       }
> > +
> > +       folio_set_private(folio);
> 
> Mh, you've inverted the semantics of PG_private in the context of gmem
> here, compared to my patch. For me, PG_private=1 meant "this folio is
> back in the direct map". For you it means "this folio is removed from
> the direct map". 
> 
> Could you elaborate on why you require these different semantics for
> PG_private? Actually, I think in this patch series, you could just drop
> the PG_private stuff altogether, as the only place you do
> folio_test_private is in guest_memfd_clear_private, but iirc calling
> set_direct_map_default_noflush on a page that's already in the direct
> map is a NOOP anyway.
> 
> On the other hand, as Paolo pointed out in my patches [1], just using a
> page flag to track direct map presence for gmem is not enough. We
> actually need to keep a refcount in folio->private to keep track of how
> many different actors request a folio's direct map presence (in the
> specific case in my patch series, it was different pfn_to_gfn_caches for
> the kvm-clock structures of different vcpus, which the guest can place
> into the same gfn). While this might not be a concern for the the
> pKVM/Gunyah case, where the guest dictates memory state, it's required
> for the non-CoCo case where KVM/userspace can set arbitrary guest gfns
> to shared if it needs/wants to access them for whatever reason. So for
> this we'd need to have PG_private=1 mean "direct map entry restored" (as
> if PG_private=0, there is no folio->private).
> 
> [1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#m0608c4b6a069b3953d7ee97f48577d32688a3315
> 

I wonder if we can use the folio refcount itself, assuming we can rely
on refcount == 1 means we can do shared->private conversion.

In gpc_map_gmem, we convert private->shared. There's no problem here in
the non-CoCo case.

In gpc_unmap, we *try* to convert back from shared->private. If
refcount>2, then the conversion would fail. The last gpc_unmap would be
able to successfully convert back to private.

Do you see any concerns with this approach?

> > +       return 0;
> > +out_remap:
> > +       for (; i > 0; i--) {
> > +               struct page *page = folio_page(folio, i - 1);
> > +
> > +               BUG_ON(set_direct_map_default_noflush(page));
> > +       }
> > +       return r;
> > +}
> > +
> > +static inline void guest_memfd_folio_clear_private(struct folio *folio)
> > +{
> > +       unsigned long start = (unsigned long)folio_address(folio);
> > +       unsigned long nr = folio_nr_pages(folio);
> > +       unsigned long i;
> > +
> > +       if (!folio_test_private(folio))
> > +               return;
> > +
> > +       for (i = 0; i < nr; i++) {
> > +               struct page *page = folio_page(folio, i);
> > +
> > +               BUG_ON(set_direct_map_default_noflush(page));
> > +       }
> > +       flush_tlb_kernel_range(start, start + folio_size(folio));
> > +
> > +       folio_clear_private(folio);
> > +}
> > 
> >  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
> >  {
> > +       unsigned long gmem_flags = (unsigned long)file->private_data;
> >         struct inode *inode = file_inode(file);
> >         struct guest_memfd_operations *ops = inode->i_private;
> >         struct folio *folio;
> > @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >                         goto out_err;
> >         }
> > 
> > +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > +               r = guest_memfd_folio_private(folio);
> > +               if (r)
> > +                       goto out_err;
> > +       }
> > +
> 
> How does a caller of guest_memfd_grab_folio know whether a folio needs
> to be removed from the direct map? E.g. how can a caller know ahead of
> time whether guest_memfd_grab_folio will return a freshly allocated
> folio (which thus needs to be removed from the direct map), vs a folio
> that already exists and has been removed from the direct map (probably
> fine to remove from direct map again), vs a folio that already exists
> and is currently re-inserted into the direct map for whatever reason
> (must not remove these from the direct map, as other parts of
> KVM/userspace probably don't expect the direct map entries to disappear
> from underneath them). I couldn't figure this one out for my series,
> which is why I went with hooking into the PG_uptodate logic to always
> remove direct map entries on freshly allocated folios.
> 

gmem_flags come from the owner. If the caller (in non-CoCo case) wants
to restore the direct map right away, it'd have to be a direct
operation. As an optimization, we could add option that asks for page in
"shared" state. If allocating new page, we can return it right away
without removing from direct map. If grabbing existing folio, it would
try to do the private->shared conversion.

Thanks for the feedback, it was helpful!

- Elliot

> >         /*
> >          * Ignore accessed, referenced, and dirty flags.  The memory is
> >          * unevictable and there is no storage to write back to.
> > @@ -213,14 +265,25 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
> >         if (ops->invalidate_end)
> >                 ops->invalidate_end(inode, offset, nr);
> > 
> > +       guest_memfd_folio_clear_private(folio);
> > +
> >         return true;
> >  }
> > 
> > +static void gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
> > +{
> > +       /* not yet supported */
> > +       BUG_ON(offset || len != folio_size(folio));
> > +
> > +       BUG_ON(!gmem_release_folio(folio, 0));
> > +}
> > +
> >  static const struct address_space_operations gmem_aops = {
> >         .dirty_folio = noop_dirty_folio,
> >         .migrate_folio = gmem_migrate_folio,
> >         .error_remove_folio = gmem_error_folio,
> >         .release_folio = gmem_release_folio,
> > +       .invalidate_folio = gmem_invalidate_folio,
> >  };
> > 
> >  static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *ops)
> > @@ -241,7 +304,7 @@ struct file *guest_memfd_alloc(const char *name,
> >         if (!guest_memfd_check_ops(ops))
> >                 return ERR_PTR(-EINVAL);
> > 
> > -       if (flags)
> > +       if (flags & ~GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> >                 return ERR_PTR(-EINVAL);
> > 
> >         /*
> > 
> > --
> > 2.34.1
> > 
> 
> Best, 
> Patrick
> 

