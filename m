Return-Path: <kvm+bounces-17125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A454E8C119E
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 17:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33E641F221B4
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 15:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BE01581E1;
	Thu,  9 May 2024 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mAnfqiCx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC6439AC9;
	Thu,  9 May 2024 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267125; cv=none; b=PGdFz+oSlJyLZN3E2+G62oZm/EOuX2i5aLp+haZjnIVDfmrVs9qJPdD53ZnR1O9dLA5lCnaSaJ7x5cXij5TsfRMqTyKzjXgCYxUVGJLCh28wHwCQFOdLVyFd0haCJLibl6VcjnmTlNTuSULQ2mpGmP+PrUdrsmMClIDBXBgXzBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267125; c=relaxed/simple;
	bh=fDDk+OytCDgLeiBOfAWSUC4PwjJtsWMWHyWSbnMu3Wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E2H/PptuJw2tmqH8F5SqZggD2sJIrA7d/62FSYaTXahTN2N4GU8Jd20nJO2wdbu2piw1fFd0f+7xDhM+ggIWxke5uyyMFCaTDEHKfjK45Zup6pGCEHE4iSPHt7GrqcfxDuadoFH1S2KYED/FuWwGywUej4C75Z8R4Gb2vHA6EyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mAnfqiCx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 449EgXMq010803;
	Thu, 9 May 2024 15:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=0BoWS1URMndnGijkXUpbozrc7xc/t2T7Orm5y+7rPRM=;
 b=mAnfqiCxK77z9C9sOBWZDa0elFLPIW+LjuoEkSKh11EGStGeEVs3dXX9sq1oxbIUeOfp
 SdFLmVBlC2OdwK7YpQ+CodJDhpRe8XcBbigzLl5a+Wf0pc4sFsNBa9Kye7BOZfNQB//T
 +pEZs0gWEE+dtIioUK4fORFOMnd3oipxfFEkUd0hTm3EXRFOXvy6N67JFW+TiXwot7oG
 ng7kaSYOzCUsYx07axkdpXcRKdJySVHeXzYq3oXOHbT+3eOBuS3t0ZFWGPZz6EzZGxAy
 WBErbVOdJoRjuqqAXLpR5RAO3mHr5qJzd4moylwsUnNVtwyBywIOh06DIJdCSNLX+Sgs bA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y10fx02d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 May 2024 15:05:10 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 449F5ARU019220;
	Thu, 9 May 2024 15:05:10 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y10fx02d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 May 2024 15:05:10 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 449F4vwn009327;
	Thu, 9 May 2024 15:05:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xyshuugxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 May 2024 15:05:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 449F533930409332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 May 2024 15:05:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B12792006E;
	Thu,  9 May 2024 15:05:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0B432004E;
	Thu,  9 May 2024 15:05:00 +0000 (GMT)
Received: from osiris (unknown [9.171.33.183])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  9 May 2024 15:05:00 +0000 (GMT)
Date: Thu, 9 May 2024 17:04:59 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v3 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
Message-ID: <20240509150459.12056-A-hca@linux.ibm.com>
References: <20240508182955.358628-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508182955.358628-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2GicvU8MHc_i4sl9SPrSTpMXuetyH1lT
X-Proofpoint-GUID: VI2Q2YeRd-Lr97pq3VMV0JYa0QdW1vpY
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-09_08,2024-05-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2405090101

On Wed, May 08, 2024 at 08:29:45PM +0200, David Hildenbrand wrote:
> Rebased on 390x/features. Cleanups around PG_arch_1 and folio handling
> in UV and hugetlb code.
> 
> One "easy" fix upfront. Another issue I spotted is documented in [1].
> 
> Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> from core-mm and s390x, so only the folio variant will remain.
> 
> Compile tested, but not runtime tested with UV, I'll appreciate some
> testing help from people with UV access and experience.
> 
> [1] https://lkml.kernel.org/r/20240404163642.1125529-1-david@redhat.com
> 
> v2 -> v3:
> * "s390/uv: split large folios in gmap_make_secure()"
>  -> Spelling fix
> * "s390/hugetlb: convert PG_arch_1 code to work on folio->flags"
>  -> Extended patch description

Added Claudio's Reviewed-by from v2 to the third patch, and fixed a
typo in the commit message of patch 9.

Applied, thanks!

