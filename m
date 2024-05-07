Return-Path: <kvm+bounces-16884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4758BE950
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8258D291AF4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF4716D9B5;
	Tue,  7 May 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nr7sLE9O"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E3116D304;
	Tue,  7 May 2024 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099707; cv=none; b=Lq4iR2kpuIWnfI/QWYLohZ/BWK8SFmxPvz77BqCa9p0ptwt/tRSlqiW4wMwZRzMYTvlKzjjJu77/fs/VhvBWM1RQs6bZQ0IsWfC0o6VKMrhWbf3R5PQUIjmUl/a5mlTFifZ4mIo/ZJ4fSyMuLPDbs4/ZrvMqVo9oItVGgnx8gOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099707; c=relaxed/simple;
	bh=3zMNh/O1NvS66HKRoTqlD9Jh9hBzUu4UaBBr6ynZF3M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmd3MLgeAqu1YaHiqGY6sr8NUq4oG5HdS11yAKd7VUPc36hmqp9QPyy9/c2tS29NaSYSJprCOoJqF++g6qgY78+NhA3QZb8O+KAT3xK+MpiEC8K3lq/8YFjoyULj/Rg18IOC3av8AxsbKk9cMB0WnqID/ogvC1EG0QFvX9QN4IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nr7sLE9O; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447GSxEn011653;
	Tue, 7 May 2024 16:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2JWGsGzPG9xj8K85LWOxfi5vbVOu4GgVaaG+8IQyXuA=;
 b=nr7sLE9Oa+QdhhpHcRhc/cKv7BvVOH+kW6o9LJfP1S8ZnjifgpuggLi47POyg1nAIRbz
 J1E84RROEuo92drfSoQxPHQJWvB84g9i4VXV7sIjGZat9fpOBPyZ208e5wq0BOfNfhAe
 1CSq6LFFjzTN65gWjk0dLYgLd72i4H286/6NHGTppjyHZeI6l6pX5IvgVLzxgSsGJvbj
 YT+sUMAl+Jnm+GVt3rhph/0FZqJIWIvw63lbaeDo9Eg4C/Ux8MGUrGOxlLGsdkaKCSo2
 uGziJll+eCQ3qZJHWkRimx+oReG/rkolnHxcljNbdGpBEHnvMJfgRZC695DhkViI9tuq Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqup80fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:00 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ0mk021759;
	Tue, 7 May 2024 16:35:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqup80fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447Fh7YY010635;
	Tue, 7 May 2024 16:34:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp7ad0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYr4U52560292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C58822004B;
	Tue,  7 May 2024 16:34:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F9D420043;
	Tue,  7 May 2024 16:34:53 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:53 +0000 (GMT)
Date: Tue, 7 May 2024 18:34:30 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox
 <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
Message-ID: <20240507183430.4e956c45@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240506083830.28332-B-hca@linux.ibm.com>
References: <20240412142120.220087-1-david@redhat.com>
	<f53a87ed-c3fe-4a60-8723-3eea25189553@redhat.com>
	<20240506083830.28332-B-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vc6hztu4I8AzPgN9plqRzhWW84EkSdue
X-Proofpoint-GUID: sjrGchoLm2-zoo3bStpdk6fL4JIWnN0c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=989 priorityscore=1501 adultscore=0 clxscore=1015
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070112

On Mon, 6 May 2024 10:38:30 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Apr 30, 2024 at 08:49:31PM +0200, David Hildenbrand wrote:
> > On 12.04.24 16:21, David Hildenbrand wrote:  
> > > This is v2 of [1] with changed subject:
> > >   "[PATCH v1 0/5] s390: page_mapcount(), page_has_private() and PG_arch_1"
> > > 
> > > Rebased on s390x/features which contains the page_mapcount() and
> > > page_has_private() cleanups, and some PG_arch_1 cleanups from Willy. To
> > > compensate, I added some more cleanups ;)
> > > 
> > > One "easy" fix upfront. Another issue I spotted is documented in [1].
> > > 
> > > Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> > > from core-mm and s390x, so only the folio variant will remain.  
> > 
> > Ping.  
> 
> Claudio, Janosch, this series requires your review.

oops! I had started reviewing it, but then other things got in the
way...


