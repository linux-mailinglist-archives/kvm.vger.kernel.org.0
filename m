Return-Path: <kvm+bounces-23409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFC2949679
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F891C22D83
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64504AEF4;
	Tue,  6 Aug 2024 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="WhUE7rvU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A853A267;
	Tue,  6 Aug 2024 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722964487; cv=none; b=lJRJvRwLVqZP48NEEExeBBRQh6Bor2kGGU4o8ca/xzV8wKIbpyhjeKoqJUSre0nuKVTW1PMOn8hKeq2jUKH/PC1EeTHB+Y77HJd1awpZvdol0zVEt+XiK9G8yQJdksl2/uTOnAX1skcGr2RaRCxfMbrmrMDgCZXAr5s3eMsTZkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722964487; c=relaxed/simple;
	bh=xhS+H7iQiaDB12Ynm2FdXOxJMbniRh+wjTAQWI2WEfo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDL5IBnpVrdSuY1AvzczufdpIztiYhf4VWgSum4BmI5QQCohPaCgQO0UEFxTeZvqoD2HfMnx24VEExX1+Db3jGDO2xj06vcH2RjFV6AaSj4Wot1c7QEP0Pz7R5rJrF4aJl5cKVUnemo13syp3Z0UmJCYy4dNgzJbEbFhlzxTdvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=WhUE7rvU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 476H6cpp018995;
	Tue, 6 Aug 2024 17:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=T+n7dvh64qYrN/shgqY+idk4
	1vC5DMbfjHSVqiAN9yc=; b=WhUE7rvUUoNPuWvxRyP4CZsScWKjmalCjsHGAE2N
	kRGTHkuk7l9OjwKqFV0HTsxUhvYLXIdRsH78hlg9jmdDt6so6Txmwcg5MaiDF9tF
	qAPY2W+n9lf5Cv9vmy/KNIEWAgbaWepwP0Y/GJzjsBGee9tLDCzafVUp3OWWFsjr
	ZJaIjgCCSDNPObNV0ageWipmuTMv4eTl6LYWYq9slF85BHfxuK2qzoXenCj0CLJx
	xBjLUSv0RlrGd/c47RtOt2njOvegNHPan4B4nuQHFlhiL6DL4MZlU6h3+ChKULBx
	okImzB0822Dktd1MkZvuzmTZYN+Q1pxvZ7gHaoI0WgZjqw==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40u4cpk51q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 17:14:27 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 476HEQC6024565
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 6 Aug 2024 17:14:26 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 6 Aug 2024 10:14:26 -0700
Date: Tue, 6 Aug 2024 10:14:25 -0700
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
Message-ID: <20240806093625007-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: IXdqrJVxXSKqBhFXqNY1RdXvAtHONbC5
X-Proofpoint-GUID: IXdqrJVxXSKqBhFXqNY1RdXvAtHONbC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_13,2024-08-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408060121

On Tue, Aug 06, 2024 at 03:51:22PM +0200, David Hildenbrand wrote:
> > -	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > +	if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
> >   		r = guest_memfd_folio_private(folio);
> >   		if (r)
> >   			goto out_err;
> > @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >   }
> >   EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> > +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> > +{
> > +	unsigned long gmem_flags = (unsigned long)file->private_data;
> > +	unsigned long i;
> > +	int r;
> > +
> > +	unmap_mapping_folio(folio);
> > +
> > +	/**
> > +	 * We can't use the refcount. It might be elevated due to
> > +	 * guest/vcpu trying to access same folio as another vcpu
> > +	 * or because userspace is trying to access folio for same reason
> 
> As discussed, that's insufficient. We really have to drive the refcount to 1
> -- the single reference we expect.
> 
> What is the exact problem you are running into here? Who can just grab a
> reference and maybe do nasty things with it?
> 

Right, I remember we had discussed it. The problem I faced was if 2
vcpus fault on same page, they would race to look up the folio in
filemap, increment refcount, then try to lock the folio. One of the
vcpus wins the lock, while the other waits. The vcpu that gets the
lock vcpu will see the elevated refcount.

I was in middle of writing an explanation why I think this is best
approach and realized I think it should be possible to do
shared->private conversion and actually have single reference. There
would be some cost to walk through the allocated folios and convert them
to private before any vcpu runs. The approach I had gone with was to
do conversions as late as possible.

Thanks,
Elliot

