Return-Path: <kvm+bounces-23576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6AB94B046
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 21:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 005B71F219DC
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943A9143751;
	Wed,  7 Aug 2024 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="pgV0Rcfg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DF3163;
	Wed,  7 Aug 2024 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057610; cv=none; b=fXR1ZEa2dEu+u9QWA1Ps8it1HdmIUmAZgX2QStE8gYcUpunbcmY9iC/AJ2XOz3QpI/8p0FqGgGAzQlvlgZ/LoKxzpH+8dAFDt61kTOeSVxwTFCiqa76zKS/BTjwzcDBHjNd2cJFopuwCT28Vg3l5uUn6r2ibx2h87acHhY2QI08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057610; c=relaxed/simple;
	bh=QV4okSaccRWcRE49CsnAiqUVEQzJ6afgsIO66PBkrr8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OD5z5fuRSZ+UFAld4LKRRilxejAHJkCac2JvI4qttup8UQO04W3pOORHS+XJws4MS+JGwEX0IRdp6lWlwxXtqBmFlbBNoepMw2XSE+0c7DdYU3qoT5Y9eZJOQ90vKU9SOCqKboPc2WzLje61ze+yejb4a1HRcwly7q188wCIXmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=pgV0Rcfg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477GtTw2021105;
	Wed, 7 Aug 2024 19:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=gnIFbIG5CD7fK6i4Dz95/VkR
	QX0gELSsUGtfIoB+cuU=; b=pgV0RcfgCDDeQslMpGGZVS3nkiAAcRID3QBnM1d+
	ptxJCrb327/hf0NUK0l2x8zmQAovCamTBEMVJXSw7nk+eFL1aY+iE6GTY1L9eJYN
	Iy7I1oaSQNzd64I85TY7FBTXYXeslOBGEFDd8qq91DSUv+S2eDsiYHkeygbplnFf
	thLEfnTgLtiDWtXfCtDYhGuMT0fHdUBgzONB0ulwul2eFfI+TEEXJlaWS/p2fmJG
	Hu3zTQ5FBPuQdcdB+cH65c+BElOHHnZnfSZ4Z9LbQWghc8e1O2NVoEp0sg4Q2oJC
	tjmnWqAUONmwXdxBDK+436vkFwlCcVgqfdRYbNcfXzwEnQ==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40v4t9hsd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 19:06:35 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 477J6Y4d012174
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 7 Aug 2024 19:06:34 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 7 Aug 2024 12:06:33 -0700
Date: Wed, 7 Aug 2024 12:06:33 -0700
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
Message-ID: <20240807113514068-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <3fc11402-53e1-4325-a3ee-5ebd616b5b63@amazon.co.uk>
 <20240806104702482-0700.eberman@hu-eberman-lv.qualcomm.com>
 <a43ae745-9907-425f-b09d-a49405d6bc2d@amazon.co.uk>
 <90886a03-ad62-4e98-bc05-63875faa9ccc@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <90886a03-ad62-4e98-bc05-63875faa9ccc@amazon.co.uk>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HcbGN0qtOuy157I9A7aBqbmyd4x8GfyT
X-Proofpoint-ORIG-GUID: HcbGN0qtOuy157I9A7aBqbmyd4x8GfyT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0 clxscore=1015
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408070133

On Wed, Aug 07, 2024 at 11:57:35AM +0100, Patrick Roy wrote:
> On Wed, 2024-08-07 at 07:48 +0100, Patrick Roy wrote:
> > On Tue, 2024-08-06 at 21:13 +0100, Elliot Berman wrote:
> >> On Tue, Aug 06, 2024 at 04:39:24PM +0100, Patrick Roy wrote:
> >>> On the other hand, as Paolo pointed out in my patches [1], just using a
> >>> page flag to track direct map presence for gmem is not enough. We
> >>> actually need to keep a refcount in folio->private to keep track of how
> >>> many different actors request a folio's direct map presence (in the
> >>> specific case in my patch series, it was different pfn_to_gfn_caches for
> >>> the kvm-clock structures of different vcpus, which the guest can place
> >>> into the same gfn). While this might not be a concern for the the
> >>> pKVM/Gunyah case, where the guest dictates memory state, it's required
> >>> for the non-CoCo case where KVM/userspace can set arbitrary guest gfns
> >>> to shared if it needs/wants to access them for whatever reason. So for
> >>> this we'd need to have PG_private=1 mean "direct map entry restored" (as
> >>> if PG_private=0, there is no folio->private).
> >>>
> >>> [1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#m0608c4b6a069b3953d7ee97f48577d32688a3315
> >>>
> >>
> >> I wonder if we can use the folio refcount itself, assuming we can rely
> >> on refcount == 1 means we can do shared->private conversion.
> >>
> >> In gpc_map_gmem, we convert private->shared. There's no problem here in
> >> the non-CoCo case.
> >>
> >> In gpc_unmap, we *try* to convert back from shared->private. If
> >> refcount>2, then the conversion would fail. The last gpc_unmap would be
> >> able to successfully convert back to private.
> >>
> >> Do you see any concerns with this approach?
> > 
> > The gfn_to_pfn_cache does not keep an elevated refcount on the cached
> > page, and instead responds to MMU notifiers to detect whether the cached
> > translation has been invalidated, iirc. So the folio refcount will
> > not reflect the number of gpcs holding that folio.
> > 

Ah, fair enough. This is kinda like a GUP pin which would prevent us
from making page private, but without the pin part.

[...]

> >>>>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
> >>>>  {
> >>>> +       unsigned long gmem_flags = (unsigned long)file->private_data;
> >>>>         struct inode *inode = file_inode(file);
> >>>>         struct guest_memfd_operations *ops = inode->i_private;
> >>>>         struct folio *folio;
> >>>> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >>>>                         goto out_err;
> >>>>         }
> >>>>
> >>>> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> >>>> +               r = guest_memfd_folio_private(folio);
> >>>> +               if (r)
> >>>> +                       goto out_err;
> >>>> +       }
> >>>> +
> >>>
> >>> How does a caller of guest_memfd_grab_folio know whether a folio needs
> >>> to be removed from the direct map? E.g. how can a caller know ahead of
> >>> time whether guest_memfd_grab_folio will return a freshly allocated
> >>> folio (which thus needs to be removed from the direct map), vs a folio
> >>> that already exists and has been removed from the direct map (probably
> >>> fine to remove from direct map again), vs a folio that already exists
> >>> and is currently re-inserted into the direct map for whatever reason
> >>> (must not remove these from the direct map, as other parts of
> >>> KVM/userspace probably don't expect the direct map entries to disappear
> >>> from underneath them). I couldn't figure this one out for my series,
> >>> which is why I went with hooking into the PG_uptodate logic to always
> >>> remove direct map entries on freshly allocated folios.
> >>>
> >>
> >> gmem_flags come from the owner. If the caller (in non-CoCo case) wants
> 
> Ah, oops, I got it mixed up with the new `flags` parameter. 
> 
> >> to restore the direct map right away, it'd have to be a direct
> >> operation. As an optimization, we could add option that asks for page in
> >> "shared" state. If allocating new page, we can return it right away
> >> without removing from direct map. If grabbing existing folio, it would
> >> try to do the private->shared conversion.
> 
> My concern is more with the implicit shared->private conversion that
> happens on every call to guest_memfd_grab_folio (and thus
> kvm_gmem_get_pfn) when grabbing existing folios. If something else
> marked the folio as shared, then we cannot punch it out of the direct
> map again until that something is done using the folio (when working on
> my RFC, kvm_gmem_get_pfn was indeed called on existing folios that were
> temporarily marked shared, as I was seeing panics because of this). And
> if the folio is currently private, there's nothing to do. So either way,
> guest_memfd_grab_folio shouldn't touch the direct map entry for existing
> folios.
> 

What I did could be documented/commented better.

If ops->accessible() is *not* provided, all guest_memfd allocations will
immediately remove from direct map and treat them immediately like guest
private (goal is to match what KVM does today on tip). 

If ops->accessible() is provided, then guest_memfd allocations start
as "shared" and KVM/Gunyah need to do the shared->private conversion
when they want to do the private conversion on the folio. "Shared" is
the default because that is effectively a no-op.

For the non-CoCo case you're interested in, we'd have the
ops->accessible() provided and we wouldn't pull out the direct map from
gpc.

Thanks,
Elliot

