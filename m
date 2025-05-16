Return-Path: <kvm+bounces-46840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FECABA1CD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364043AAB5F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5312B274651;
	Fri, 16 May 2025 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U8cjgT5a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D22522AC;
	Fri, 16 May 2025 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415888; cv=none; b=QDT07w9Q6A0mNDD7M5IpbsaTRYYrs8IIPxMOO98SM0mIvJE9+rTOqIVw7kM0pHXSAqP9HmW4gaBTegLpTDwxacYZqOINF5M9jUE3WU7GXe79692QBOvS6uBlVKfr7YDuvIdYNrdV/6rt/NTwXUV/7QGJ9hg7gKaXCP15Y819C4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415888; c=relaxed/simple;
	bh=VjwXTw02bTW7oMykUSICj88r+C1y3UBjH7wr19qHT98=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1koL9Qp4gRvm97bBe2n147J2U7QobtPmWzJNo9AwvkbKNWmrnW3DFxHCXWaAqIJ6WgK/IWdFTNVX/2c/V9B/c/+R+K4JTvZz7uNQiYqhf0I+626kREAI/zprO9B1IcIzJt/VA5mhwotJOKD0rpS3X3/7kLqzIO88ZSUA7D8CSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U8cjgT5a; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G9FCgX007362;
	Fri, 16 May 2025 17:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4HnXo9
	7zFSTeo4UR2RpPjFZFA4eOHobpEQRGGLUD0as=; b=U8cjgT5aMFpeaDFozFdi0m
	4YeEjaPCz31R2xbMosDfJcyDHWCkqqtVvEPXdrb1pjYpklPorfq2BR4bonOh9/K8
	JKvohYNpWWD2H7lsrwECyXHYR0qFHNpP2WZ/j3OYWzV/hW1CPvrHxdak4+zTAgML
	giQLyda4pPUu/vx97+OURJY9b/dh5Xt+wlJE/Ly/IIrDQ5gzcFbCl+uVF7JSYDK9
	s6sNb11487ijmZpfoIOsY4nDPVgbOh7XILUbxilreanaL4eh/piW++2H+lvo0row
	DWofRdX+wJ99eS6+vv0sXxv+VzHd0UR4QCcz7/7SmnKKwmYG1iSrIwhsvocv11UQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46p2jja9te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 17:17:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54GEFO4W027008;
	Fri, 16 May 2025 17:17:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfprn46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 17:17:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54GHHoAd37355876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 17:17:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 851C52016D;
	Fri, 16 May 2025 17:17:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1336D2016C;
	Fri, 16 May 2025 17:17:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 May 2025 17:17:50 +0000 (GMT)
Date: Fri, 16 May 2025 19:17:48 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Zi
 Yan <ziy@nvidia.com>,
        Sebastian Mitterle <smitterl@redhat.com>
Subject: Re: [PATCH v1 0/3] s390/uv: handle folios that cannot be split
 while dirty
Message-ID: <20250516191748.3bd0861c@p-imbrenda>
In-Reply-To: <20250516123946.1648026-1-david@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE2NyBTYWx0ZWRfXy921ZyxM4lqJ VKh5LPsjX83WDJODNqRbTv1VTB4Qb1MUPhvxeVmAfqz9M+aSvpHrSYjiJPzgnU1nvHHSRNO9jxn QjTy+6dlx25qWyunoBHC+7ekD7TkQ/In83HYO6ow888yxikCQwpvWgduY3fcasRBfb0KFPDfvmp
 uhRvfZUVuGmq0FS+upt+FBuOj88QxbFLSb+Pnxuv9Or27e4iPy8YHBOrK4grAcuIIAGn+kzI9n6 TRYBTbAu2s7KuhDRLlxlduf3gl7zXfTDKEYyHf6+WYh/kfoGVefhsuTsRteuZvvOGwGnm2ycnDx yKGUm3ZdSbPPXTr0I53JLZQV9yeBuP/NoZB04TTDfDztrJ80q63S5iymYbYCYHkyqPtc878SLLo
 Pls1HoYJvVFb/5vq7I/K7Bto32UxKo3Ipm3npfUxkDDiU+d+c1wlIJtmcCpELUlGPGQW0BuV
X-Proofpoint-GUID: PLztTtZlPOf2f54DXBlrLtlad6t4TEO3
X-Authority-Analysis: v=2.4 cv=O4o5vA9W c=1 sm=1 tr=0 ts=68277343 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=Ikd4Dj_1AAAA:8
 a=bI5ggvasLi50PZegio4A:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: PLztTtZlPOf2f54DXBlrLtlad6t4TEO3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=889 suspectscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505160167

On Fri, 16 May 2025 14:39:43 +0200
David Hildenbrand <david@redhat.com> wrote:

> From patch #3:
> 
> "
> Currently, starting a PV VM on an iomap-based filesystem with large
> folio support, such as XFS, will not work. We'll be stuck in
> unpack_one()->gmap_make_secure(), because we can't seem to make progress
> splitting the large folio.
> 
> The problem is that we require a writable PTE but a writable PTE under such
> filesystems will imply a dirty folio.
> 
> So whenever we have a writable PTE, we'll have a dirty folio, and dirty
> iomap folios cannot currently get split, because
> split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
> will fail in iomap_release_folio().
> 
> So we will not make any progress splitting such large folios.
> "
> 
> Let's fix one related problem during unpack first, to then handle such
> folios by triggering writeback before immediately trying to split them
> again.
> 
> This makes it work on XFS with large folios again.
> 
> Long-term, we should cleanly supporting splitting such folios even
> without writeback, but that's a bit harder to implement and not a quick
> fix.

picked for 6.16, I think it will survive the CI without issues, since
I assume you tested this thoroughly

> 
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Sebastian Mitterle <smitterl@redhat.com>
> 
> David Hildenbrand (3):
>   s390/uv: don't return 0 from make_hva_secure() if the operation was
>     not successful
>   s390/uv: always return 0 from s390_wiggle_split_folio() if successful
>   s390/uv: improve splitting of large folios that cannot be split while
>     dirty
> 
>  arch/s390/kernel/uv.c | 85 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 72 insertions(+), 13 deletions(-)
> 
> 
> base-commit: 088d13246a4672bc03aec664675138e3f5bff68c


