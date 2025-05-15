Return-Path: <kvm+bounces-46686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A923AB879F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B42F1BA3C66
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A55B53363;
	Thu, 15 May 2025 13:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TtskbbHk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF807442C;
	Thu, 15 May 2025 13:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747314922; cv=none; b=oGBFuerf+qo4BCZ7PLczfOeYgllcrhVGWptYFA22m+wRT+37IIKJFIjmCNhgOw6MXcjcJLUtvVU7tdNg+dLEUVElRiQ4AWobL05qGdmR+pOrlXqCDTRAldK4JpeFuZRKPODqq/TEczRVeBPxnkYQJzzdPlQiWrcPiPL/fu+1Ff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747314922; c=relaxed/simple;
	bh=fnDaJLyEcum1pZ5tsOxAADsunSUJQGy7UuoqvhPss9w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIz/3UrZvQY7KWqqICNW4H8uCCQZ9aq66qfJRjMOR8XsDYBculJunjcRkEYwfcWdsf+vXgE7Z6nEe7+WfOwQZYJm76H5Ry0iCkirlwuiurzr7VD//6pJ2iZgXZfMosMm533WkSocRcOSBYFhX3pZs2oUG5iMwBrpJ9gs7IIEEhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TtskbbHk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FCg5lO002277;
	Thu, 15 May 2025 13:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ieoGba
	YorN2Q1Po/oAhuPiaA3xjmjU0hOj3DmFXBYYk=; b=TtskbbHkuA+YH2Vfe31T6d
	/FB9FJJz3HxgK3yex8usuTzaxo9VGxUT2YaduDRmvCW6fgXrHdVYC/JST5XDPty6
	IX72Pcng0sFbdEbRH/48UAmsdIjJN9NvZZYUlLAKubBYZ2+aNicMhfJo/vv5RU7G
	yOWu7vDTv9xyDhn111in79ZJcCKCKP01uP9+WX7Z9lyoN+DJRIvOe+0oyzWY728h
	72pmA/OT/25LEkE3TiUnflJjes85XuK1IkL2Mi8XAPlKdQKz9fDYsD+VAyE/TyLJ
	jtMtNGDqvoO5ULYl861LRlof+Z/by6JclWmSeLQMnlYuKlU6vyCnbL/6QA+ZhkrA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46n0v6mh6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:15:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FAowf1019451;
	Thu, 15 May 2025 13:15:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfrtbwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:15:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FDFEhe49414530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 13:15:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E694D20192;
	Thu, 15 May 2025 13:15:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96E512018E;
	Thu, 15 May 2025 13:15:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 13:15:13 +0000 (GMT)
Date: Thu, 15 May 2025 15:15:11 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>, <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: s390: Always allocate esca_block
Message-ID: <20250515151511.101fd385@p-imbrenda>
In-Reply-To: <D9WR9VL90Z44.34FLLVUM55PGQ@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
	<20250514-rm-bsca-v1-2-6c2b065a8680@linux.ibm.com>
	<20250515132448.5c03956d@p-imbrenda>
	<D9WR9VL90Z44.34FLLVUM55PGQ@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=IqAecK/g c=1 sm=1 tr=0 ts=6825e8e6 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=iHkedp4cHprbyzV752oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: xywIjC12GHm7YVJLVDnCirhH9BCTGoqF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEyOSBTYWx0ZWRfXzjPoMwsmgf16 qujaXfHjK54MuBOHwfHY7z5C46UckXkWjh99EG6OrupMzUJcO5wNQhDl9j89aUkwjYpcrlvkIpN xgn5b2XvyoB4gMHa3+SlWsRnxyL8fWsvLY1oHVse98F2AYK1r9VgvIEYZquVpPZASSLju7Rh8u7
 5NvgeCbrVZZoHb+7/JBvEM0DGqX1EiRgGngCk+abTwR8/NGWNW2veyW8G8DjTt4t5z4DBNqSrPb pkUoZgmIMeMfJ25IQJ/T5vFM6DnLoFiV4U6BeNt8IcTH0ijC9i1EPAaEyR9+YqFXbj3lshJAL8U wz6lD5PtpxMCpTk6YnVwjVv3nk/T2ld8ZskzYoq/ADbVjwJdHMtpaEameuRiaHZi9s4eh2CFdFy
 if8UJYJz/EDyM5Na3KA+2vXT98UXVn/up7vD9dvzjqb4UHh56Svjv0Nkq6JAy+CGuhHcwFi/
X-Proofpoint-GUID: xywIjC12GHm7YVJLVDnCirhH9BCTGoqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxlogscore=916 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150129

On Thu, 15 May 2025 15:07:18 +0200
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Thu May 15, 2025 at 1:24 PM CEST, Claudio Imbrenda wrote:
> > On Wed, 14 May 2025 18:34:50 +0200
> > Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:
> >  
> >> Instead of allocating a BSCA and upgrading it for PV or when adding the
> >> 65th cpu we can always use the ESCA.
> >> 
> >> The only downside of the change is that we will always allocate 4 pages
> >> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
> >> In return we can delete a bunch of checks and special handling depending
> >> on the SCA type as well as the whole BSCA to ESCA conversion.
> >> 
> >> As a fallback we can still run without SCA entries when the SIGP
> >> interpretation facility is not available.  
> >
> > s/is/or BSCA are/
> >  
> 
> With this merged we do no longer care for the BSCA. So I will change this to
> s/is/or ESCA are/

that was a typo, I meant ESCA, of course :)

> 
> I will also apply the other changes for the next version. But I will wait for
> more feedback before sending that. And I will run checkpatch with the strict
> option, which I clearly did not do.
> 
> [...]


