Return-Path: <kvm+bounces-23660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7764A94C6F7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 00:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 019C31F24B84
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 22:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0522115EFB8;
	Thu,  8 Aug 2024 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="iDe+91GT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE8715A85E;
	Thu,  8 Aug 2024 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155988; cv=none; b=ALygsZv/QwoPP0Fu0bzre7kM9J+tCXKR7yYUz/9QOU0LNJlHg13oGD4iamozO/CHOyiLkcjrdEZDYwlqZtDCcqA5sZh3v+wQXpQSYLhc5uaqHK/EURPbUYNzHKmMdzm4uPARq9ka8qaNxocqHkepf6tDF+lWuUkOFpQxwUxaSOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155988; c=relaxed/simple;
	bh=aQKPko7oyNxXCPgEAztG4lUMdjyzE531e4ugA7Yiask=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aT1UamiaAqPIt0JlkXz3ZdbL3NFfUGhaYslxhzvEpLXr89/tSVjd4WI2NKpuCoETvIFhbqxLPIX7jvUFsHQT1bJv4s+2YEWROM23fZQlESxZHbEHuWI0iMtzdvKCH1290bF7+BY2IVhoyO7SSpEEJn5Tr75i9nKuvoIq7E4daI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=iDe+91GT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478LZi8e016208;
	Thu, 8 Aug 2024 22:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=EK1i03qsYytFn0u1BrmUqL3n
	sZybCV3ZW6JZjdd6FcE=; b=iDe+91GTFIL0MHmpbWPrL/r1ykxcJfmTanra2ZhK
	0AF2xvVPmuiZKrnKlpOZRi+M+/srLeaFkSboZS3PJ6TmzPe3KG9Z9jPeN3YHJqik
	LK8xLRTKltyoOpYW/ot9udek9FsF5st9FnyH8+eClISOSfGX1xZhNsnFE5eqrnrm
	EvhfqQ5yW26v7eAkscdODD9xLZJm1TUPjyy0on67lZT7sdAwtePG4Cthmhy8kz7R
	KB8If1Vbc9UFXTLsOFdDmVptbDf6lpgBGaxILzw8c1JHvYKmHVLEWUwPpap6WTJm
	uWOoPMHSJsqLu+NBzCXVeLByERTFQyvBWaTZF2+2QLBo2g==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40vue3sy7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 22:26:14 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 478MQCci019345
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 Aug 2024 22:26:12 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 8 Aug 2024 15:26:12 -0700
Date: Thu, 8 Aug 2024 15:26:12 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: David Hildenbrand <david@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, Patrick Roy <roypat@amazon.co.uk>,
        <qperret@google.com>, Ackerley Tng <ackerleytng@google.com>,
        <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
Message-ID: <20240808151910630-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <20240806093625007-0700.eberman@hu-eberman-lv.qualcomm.com>
 <a7c5bfc0-1648-4ae1-ba08-e706596e014b@redhat.com>
 <20240808101944778-0700.eberman@hu-eberman-lv.qualcomm.com>
 <6f3b5c38-fc33-43cd-8ab7-5b0f49169d5c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6f3b5c38-fc33-43cd-8ab7-5b0f49169d5c@redhat.com>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 33CsOkwwEsaxHOqmdCGwMzUMEIrCS5Lo
X-Proofpoint-ORIG-GUID: 33CsOkwwEsaxHOqmdCGwMzUMEIrCS5Lo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_22,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxlogscore=915
 malwarescore=0 impostorscore=0 bulkscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080160

On Thu, Aug 08, 2024 at 11:55:15PM +0200, David Hildenbrand wrote:
> On 08.08.24 23:41, Elliot Berman wrote:
> > On Wed, Aug 07, 2024 at 06:12:00PM +0200, David Hildenbrand wrote:
> > > On 06.08.24 19:14, Elliot Berman wrote:
> > > > On Tue, Aug 06, 2024 at 03:51:22PM +0200, David Hildenbrand wrote:
> > > > > > -	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > > > > > +	if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
> > > > > >     		r = guest_memfd_folio_private(folio);
> > > > > >     		if (r)
> > > > > >     			goto out_err;
> > > > > > @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> > > > > >     }
> > > > > >     EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> > > > > > +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> > > > > > +{
> > > > > > +	unsigned long gmem_flags = (unsigned long)file->private_data;
> > > > > > +	unsigned long i;
> > > > > > +	int r;
> > > > > > +
> > > > > > +	unmap_mapping_folio(folio);
> > > > > > +
> > > > > > +	/**
> > > > > > +	 * We can't use the refcount. It might be elevated due to
> > > > > > +	 * guest/vcpu trying to access same folio as another vcpu
> > > > > > +	 * or because userspace is trying to access folio for same reason
> > > > > 
> > > > > As discussed, that's insufficient. We really have to drive the refcount to 1
> > > > > -- the single reference we expect.
> > > > > 
> > > > > What is the exact problem you are running into here? Who can just grab a
> > > > > reference and maybe do nasty things with it?
> > > > > 
> > > > 
> > > > Right, I remember we had discussed it. The problem I faced was if 2
> > > > vcpus fault on same page, they would race to look up the folio in
> > > > filemap, increment refcount, then try to lock the folio. One of the
> > > > vcpus wins the lock, while the other waits. The vcpu that gets the
> > > > lock vcpu will see the elevated refcount.
> > > > 
> > > > I was in middle of writing an explanation why I think this is best
> > > > approach and realized I think it should be possible to do
> > > > shared->private conversion and actually have single reference. There
> > > > would be some cost to walk through the allocated folios and convert them
> > > > to private before any vcpu runs. The approach I had gone with was to
> > > > do conversions as late as possible.
> > > 
> > > We certainly have to support conversion while the VCPUs are running.
> > > 
> > > The VCPUs might be able to avoid grabbing a folio reference for the
> > > conversion and only do the folio_lock(): as long as we have a guarantee that
> > > we will disallow freeing the folio in gmem, for example, by syncing against
> > > FALLOC_FL_PUNCH_HOLE.
> > > 
> > > So if we can rely on the "gmem" reference to the folio that cannot go away
> > > while we do what we do, we should be fine.
> > > 
> > > <random though>
> > > 
> > > Meanwhile, I was thinking if we would want to track the references we
> > > hand out to "safe" users differently.
> > > 
> > > Safe references would only be references that would survive a
> > > private<->shared conversion, like KVM MMU mappings maybe?
> > > 
> > > KVM would then have to be thought to return these gmem references
> > > differently.
> > > 
> > > The idea would be to track these "safe" references differently
> > > (page->private?) and only allow dropping *our* guest_memfd reference if all
> > > these "safe" references are gone. That is, FALLOC_FL_PUNCH_HOLE would also
> > > fail if there are any "safe" reference remaining.
> > > 
> > > <\random though>
> > > 
> > 
> > I didn't find a path in filemap where we can grab folio without
> > increasing its refcount. I liked the idea of keeping track of a "safe"
> > refcount, but I believe there is a small window to race comparing the
> > main folio refcount and the "safe" refcount.
> 
> There are various possible models. To detect unexpected references, we could
> either use
> 
> folio_ref_count(folio) == gmem_folio_safe_ref_count(folio) + 1
> 
> [we increment both ref counter]
> 
> or
> 
> folio_ref_count(folio) == 1
> 
> [we only increment the safe refcount and let other magic handle it as
> described]
> 
> A vcpu could have
> > incremented the main folio refcount and on the way to increment the safe
> > refcount. Before that happens, another thread does the comparison and
> > sees a mismatch.
> 
> Likely there won't be a way around coming up with code that is able to deal
> with such temporary, "speculative" folio references.
> 
> In the simplest case, these references will be obtained from our gmem code
> only, and we'll have to detect that it happened and retry (a seqcount would
> be a naive solution).
> 
> In the complex case, these references are temporarily obtained from other
> core-mm code -- using folio_try_get(). We can minimize some of them
> (speculative references from GUP or the pagecache), and try optimizing
> others (PFN walkers like page migration).
> 
> But likely we'll need some retry magic, at least initially.
> 

I thought retry magic would not fly. I'll try this out.

Thanks,
Elliot


