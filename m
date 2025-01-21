Return-Path: <kvm+bounces-36122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 553ACA18058
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A07E27A1D2A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 14:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649431F3FFF;
	Tue, 21 Jan 2025 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Odrk3fnM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105CB1F3FF7;
	Tue, 21 Jan 2025 14:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737470930; cv=none; b=BVWgxdegLdPxQ6fiDnTDLKl38mKPIMaDiFeahayYx0G7fe7zbh+oPqXZGbiwfQNQVy+gAe1a6y+VFBMLdLPpK9oxhAs+LjaZO6Uegm6xHQ3m3PkD2xlQ7Daw1C37xOLZw8GISGMTE1sdgoom6u2b88P3ja6gPFIjgtNFCBxKn9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737470930; c=relaxed/simple;
	bh=lkbKhdlE75wZ1Y0fD8A7PCv0p3QLzCcl2P17GWl/MeY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtR3sGtO3Mo7bH2w6IEK6u1f0u+IfLXWOs+WFVnvgagVqIwbxLX43Y3mbo+wkyYGsTYGekLlCTjXFr7veKMYPigOkk7v7CmG8AuOSd2acxBfayBCW3q7v8bkDzOeVxVPwUwjnMdQwUZEESZNgJ/ZaNYfWZCf3nyNXgEdwIoFyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Odrk3fnM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50L5OKkg011302;
	Tue, 21 Jan 2025 14:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hQeAEP
	LSo3JUGrvICcqmTJ52EOzwmuFDTuIWY+2crng=; b=Odrk3fnMiNwA7Xdf88xmBe
	Ls4d4OylLkPLnyS7QYYlD4Q5c6gq3N3yGCLocx0cojEBlP1ACcH3mPd3UABVkWM5
	t5ivby6StN4R6oiXJkfqq43eLKswBnWqfUK4ZtOyD/C0vXp53Mg5YbKUz0yVW856
	8z8B8Dh7alPO0lK4oTSzAd1r4h3s1kCQ3f5mCBT02Dk4cuAnTyyx+hM7NqEAErdP
	gGFJ1oYWpsB+w1W0p+llDV6Tm8ziFFa/nwtqK6pbuWDIvt3/+I+H4Bwywf0ZA+Q1
	f5TO+U+24YPKZWrvxxkvIOzPx13LXuWSlGyZgdgR4NGTpMy8N6jjKN5CjngIG5fQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a5d7jhmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 14:48:41 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LELprR007039;
	Tue, 21 Jan 2025 14:48:41 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a5d7jhmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 14:48:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50LBF6K0021002;
	Tue, 21 Jan 2025 14:48:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1b8mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 14:48:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LEmadj50659658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 14:48:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 721CF2004D;
	Tue, 21 Jan 2025 14:48:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C35422004B;
	Tue, 21 Jan 2025 14:48:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.11.211])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 21 Jan 2025 14:48:35 +0000 (GMT)
Date: Tue, 21 Jan 2025 15:48:33 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: Re: [PATCH v3 15/15] KVM: s390: remove the last user of page->index
Message-ID: <20250121154833.44bbbdc9@p-imbrenda>
In-Reply-To: <9402c203-f4d5-47d1-962d-fd7387daea16@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
	<20250117190938.93793-16-imbrenda@linux.ibm.com>
	<9402c203-f4d5-47d1-962d-fd7387daea16@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vSVCLSvadPFliBj9l2zaeKZt-FLFscZD
X-Proofpoint-ORIG-GUID: 8FtWBRQ9rQNQAIQ18y7DSOcKy4G48V5l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_06,2025-01-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501210118

On Tue, 21 Jan 2025 15:44:37 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/17/25 8:09 PM, Claudio Imbrenda wrote:
> > Shadow page tables use page->index to keep the g2 address of the guest
> > page table being shadowed.
> > 
> > Instead of keeping the information in page->index, split the address
> > and smear it over the 16-bit softbits areas of 4 PGSTEs.
> > 
> > This removes the last s390 user of page->index.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
> >   arch/s390/kvm/gaccess.c         |  6 ++++--
> >   arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
> >   3 files changed, 39 insertions(+), 4 deletions(-)  
> 
> s/index/paddr/ or pgaddr?
> 
> I get that you're replacing index but you now have the opportunity to 
> choose an expressive name for this field/variable.

yes, makes sense

