Return-Path: <kvm+bounces-17155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1E58C1FFF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 10:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 620AF1C215F8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 08:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43B31607B2;
	Fri, 10 May 2024 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c1Z1PbAi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119F377119;
	Fri, 10 May 2024 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715330750; cv=none; b=N3513MAyZOQfsSAV8uGpKiLp+r492dzBOn1FCA1Jp5lzwDbvWBhFo/AfgiV0H4AgZZvMvva2uPyKA9h57Ryuk26k8xRz+S8z7bq1lCQ5Stabi9wUmVmIU3LRFjH3nj80ocwjuaPblP8Op0BbfbS0t00+0MzNWULOQ5CIJ6Thfag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715330750; c=relaxed/simple;
	bh=mtf4M6QHGLU2mdvuYjnmJR1Z668vvViE62vcSrsirHY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkEA4tt6FWoTB3SX5ZwmdRP2e65XEnnJ/xqFwzqxG4zlOadCQHiazK9qm6rvXK+t18BGkiky99fqm09BH2YySqPylHdP+MdT5RMFqLknbnlLFhEogT91GQURQo88hgiUYYDDhIAo1VLcqu77T3r/jNUHFkz3+uOf1A4M7475ctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c1Z1PbAi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44A8WSdR021726;
	Fri, 10 May 2024 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+Z0ovvhQJtmJaRWOeUf86VOrNKt/1WQyF/jJNP+F8Co=;
 b=c1Z1PbAia1nYJGopwOgQbu4EURch9CQ0H1nfQ9st98QX7bNvtKUWYr4JwEY1rzTp3FwS
 McSAsxiWxXV78BHvjUHYrsq7Jm9aD7pcPBiXK2YKzjKDcH9/XZTPYyuG2EdFctyrUvA/
 nHdSbMGIqdEh3hCi/lD6yJfXiKph9WQXQQTqZP+8nZUfmB6vRLqNDPaSfHP0pMfos7nD
 d+ddk+/LmxWBXJKjdJA7c89zhoKM/M657x0jpIYv+SYXHBMIcBDcc1yGNGOcWiZaZYbI
 Qk1Vsj0ldwDXsigLTdibdRmlm3Hl2ycTvfZ1o0z/y/7gqz18KwFYaRbsUkzHqdXP/dlk Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y1edbrarm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 May 2024 08:45:39 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44A8jdnl008664;
	Fri, 10 May 2024 08:45:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y1edbrarf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 May 2024 08:45:39 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44A77EQl009449;
	Fri, 10 May 2024 08:45:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xysfxr742-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 May 2024 08:45:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44A8jWMY51184066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 08:45:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 771D42004E;
	Fri, 10 May 2024 08:45:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F2DC2004D;
	Fri, 10 May 2024 08:45:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.0.171])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 10 May 2024 08:45:31 +0000 (GMT)
Date: Fri, 10 May 2024 10:45:29 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox
 <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 10/10] s390/hugetlb: convert PG_arch_1 code to work
 on folio->flags
Message-ID: <20240510104529.26f68fd8@p-imbrenda>
In-Reply-To: <36c6bdd3-b010-4b58-b358-395462d8765b@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-11-david@redhat.com>
	<20240507183307.3336dabc@p-imbrenda.boeblingen.de.ibm.com>
	<36c6bdd3-b010-4b58-b358-395462d8765b@redhat.com>
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
X-Proofpoint-ORIG-GUID: 855y7kWyZVhWhXV1CI38E4Dj2f_TUtmv
X-Proofpoint-GUID: EpPFmLPUYHFm3vqW3A0A4a34i8NNfmcK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_06,2024-05-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=991
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405100062

On Wed, 8 May 2024 20:08:07 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 07.05.24 18:33, Claudio Imbrenda wrote:
> > On Fri, 12 Apr 2024 16:21:20 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> Let's make it clearer that we are always working on folio flags and
> >> never page flags of tail pages.  
> > 
> > please be a little more verbose, and explain what you are doing (i.e.
> > converting usages of page flags to folio flags), not just why.
> >   
> >>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>  
> > 
> > with a few extra words in the description:  
> 
>      Let's make it clearer that we are always working on folio flags and
>      never page flags of tail pages by converting remaining PG_arch_1 users
>      that modify page->flags to modify folio->flags instead.
>      
>      No functional change intended, because we would always have worked with
>      the head page (where page->flags corresponds to folio->flags) and never
>      with tail pages.

this works, thanks!

> 
> 
> > 
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Thanks for all the review!
> 


