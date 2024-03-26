Return-Path: <kvm+bounces-12662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A023C88BB9D
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1F561C2E34A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 07:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B9A13281B;
	Tue, 26 Mar 2024 07:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="INdaDbHP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C24CB2E;
	Tue, 26 Mar 2024 07:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711439247; cv=none; b=jxbaKsbbDSwTIcRfEQhp2iR6DomWiNZvjkeG1v7n/5x+E+TtYUFnbvBeOLEQ93m9UBbNvP1gxgOL1IIFM2nY9ZKyOhdkiDW0LwkkqeSYnUB5JLxhkC08KUg5zD3faZbnc+KXLX7aTLAff3wkH9bH2i3Ki8gK8ln1SxCl+f7QgYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711439247; c=relaxed/simple;
	bh=d5uVWB5omXFzH/9lQAppLxcXO8IDXnKpI8b31IMNmVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsB7hOVEjkWfTYLWSrkvTGWfZ/wQvMQ5BLaADC5h00KE1AChTnwBe38Zwy3IcQKJbzSsNLx6LWpaZsJqBnwmgqghwnFZx4/cxsa8WTzNsaIdfyhyvsP1IwJhC4z0lL/3bJiQp4Z5Hhy04BvFnuCRpyiH6wyHl59NCbxTf6jBSh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=INdaDbHP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q5CR5f028966;
	Tue, 26 Mar 2024 07:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=eh6YWin4ixIRlQKZhkJaK+gt1fOR8Sruq8BTre+DvX4=;
 b=INdaDbHPtQmyBuX1tZ1m1DYNfH2BxAXTDyvYkZfi8dJywOagtoEhhMkvPV1PvyRVn1hL
 Wqyow3rpDF/kDRel7qV1BQprSuXOTJg3hO7hhR9f7K5vYAsYlIEumyIVvvldX4E6QbXm
 Jwe/yZG/ysPYV54qp8MWPEKg69KxHVDsUxa6MN+jn8mowsc35QftvpCkJzi3qzwGOaSd
 wivFdkI18icHFlE6zXRUCqvne2mSw0EAwgAW/9ILbwCgiROirB1C6GP398jp4X7ScHgi
 5t9rTUuoazqaj4wJdnCZz0SfDIowbnzCcldHnrWj/1h0cLkHV8YjI99P6rx7UoRGYN7S Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3r0nrcr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:47:05 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q7l4nS012588;
	Tue, 26 Mar 2024 07:47:05 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3r0nrcr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:47:04 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q54JOd003767;
	Tue, 26 Mar 2024 07:47:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x2c42nve8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:47:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42Q7kwd253019068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 07:47:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 820542004D;
	Tue, 26 Mar 2024 07:46:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F3B82004B;
	Tue, 26 Mar 2024 07:46:58 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 Mar 2024 07:46:58 +0000 (GMT)
Date: Tue, 26 Mar 2024 08:46:56 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: akpm@linux-foundation.org, vishal.moola@gmail.com, hughd@google.com,
        david@redhat.com, rppt@kernel.org, willy@infradead.org,
        muchun.song@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 3/3] s390: supplement for ptdesc conversion
Message-ID: <20240326074656.6078-C-hca@linux.ibm.com>
References: <04beaf3255056ffe131a5ea595736066c1e84756.1709541697.git.zhengqi.arch@bytedance.com>
 <20240305072154.26168-1-zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305072154.26168-1-zhengqi.arch@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ju8ifvxWc2aeJahBllXnpXcsnT2z65ij
X-Proofpoint-GUID: IArssar9KmfzzvMUCAa5e8JZkKunr0L3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_04,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 spamscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=292 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403260052

On Tue, Mar 05, 2024 at 03:21:54PM +0800, Qi Zheng wrote:
> After commit 6326c26c1514 ("s390: convert various pgalloc functions to use
> ptdescs"), there are still some positions that use page->{lru, index}
> instead of ptdesc->{pt_list, pt_index}. In order to make the use of
> ptdesc->{pt_list, pt_index} clearer, it would be better to convert them
> as well.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> ---
> v1 -> v2: fix build failure (cross compilation successful)
> 
>  arch/s390/include/asm/pgalloc.h |  4 ++--
>  arch/s390/mm/gmap.c             | 38 +++++++++++++++++----------------
>  arch/s390/mm/pgalloc.c          |  8 +++----
>  3 files changed, 26 insertions(+), 24 deletions(-)

Same here: Christian, Janosch, or Claudio, please have a look and
provide an ACK if this is ok with you.

