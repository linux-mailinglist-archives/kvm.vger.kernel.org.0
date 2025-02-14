Return-Path: <kvm+bounces-38144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0494A35A99
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 10:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34ECC1892ADE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 09:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EB2257439;
	Fri, 14 Feb 2025 09:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PdNx/IaB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F10245030;
	Fri, 14 Feb 2025 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526224; cv=none; b=DVZt4/CHGw+YBXk72Gjg4VWc/088IYCQ6Zbz+XveqK5Xvn54gakRD9wbxBHY9rMTJjyW7VZ8OG6W2dWBFTfNdM2WTWwfmTA2GBA0ftxUIwG2nY9wO7G1bwwgX+aC0eyTdqTOpO21Li6HM1+J2/tGMI4QH9P7hwil6GPIxTncCxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526224; c=relaxed/simple;
	bh=bR+EitM9xMeO4ilPsO7nnJll1F8pa8yA4EQ84Hrt8Wc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ro6jgstguWrjhyAVXpbeYCZqEZZm6tjqfkgNrsrGaL46GVnmibAmwlgpMdPtgx2gvi0mvBDY/bv6oXhKbZ9EBtpE7l8Byo8TmumuVRisaronlIArDwqTlhyW2VgAXzg9Mu0TBfoCoiLB7nlPwjLCo7FzATfLFqoADenfPAOvi0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PdNx/IaB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E2mM8M017021;
	Fri, 14 Feb 2025 09:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VaXU7j
	+cCekekrvpguCYcm8IKdQ46uzhM3dlVAX4zWg=; b=PdNx/IaBeUROA2QfRBczLL
	UTK7XCYy77H0v2dLI+bfYdYziUSbWx5fPa11wOMv+wb+PtSuf0mRCo8fv3g5iy/4
	3b9ApGEJRDkwa5vMBleL+bUcOyvJaQaFBUqgUnVaZO00XnqDvGab5afyz/+WDJJy
	cZMDl+B2+m9sDyUfzqqG9kGR86EStkMCZ0a/BClQlz2wPyMOWR2xPrmVW9XooXZD
	Pp9nEieNLJfu3c0etlqx1Gc2a8Zgba0pnRf8OvAqssKI4F6Dcp9rTCoIEj5pv1mN
	lCYSkCgw8TrRS0eSa1wCZNpOBm7equqoCD5Pzm0REXjrcyOm3XwBYVaTo2N1IVIw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44skjuvgjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 09:43:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51E78fwn000924;
	Fri, 14 Feb 2025 09:43:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjknjx95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 09:43:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51E9hX4e22086234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 09:43:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DDF320063;
	Fri, 14 Feb 2025 09:43:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EE942004E;
	Fri, 14 Feb 2025 09:43:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.26.252])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 14 Feb 2025 09:43:32 +0000 (GMT)
Date: Fri, 14 Feb 2025 10:43:31 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v1 1/2] KVM: s390: fix issues when splitting folios
Message-ID: <20250214104331.1865aba5@p-imbrenda>
In-Reply-To: <e58310a9-0fd7-44fa-b66b-b98502dbed30@redhat.com>
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
	<20250213200755.196832-2-imbrenda@linux.ibm.com>
	<e58310a9-0fd7-44fa-b66b-b98502dbed30@redhat.com>
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
X-Proofpoint-GUID: fc6ZKaGCZLcaAT_njmm-yKN56OgkwNye
X-Proofpoint-ORIG-GUID: fc6ZKaGCZLcaAT_njmm-yKN56OgkwNye
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_03,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=700 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502140067

On Thu, 13 Feb 2025 21:17:10 +0100
David Hildenbrand <david@redhat.com> wrote:

> > +	struct folio *folio = page_folio(page);
> >   	int rc;
> >   
> >   	lockdep_assert_not_held(&mm->mmap_lock);
> > @@ -2645,7 +2646,11 @@ int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool
> >   	lru_add_drain_all();
> >   	if (split) {
> >   		folio_lock(folio);
> > -		rc = split_folio(folio);
> > +		rc = min_order_for_split(folio);
> > +		if (rc > 0)
> > +			rc = -EINVAL;
> > +		if (!rc)
> > +			rc = split_huge_page_to_list_to_order(page, NULL, 0);  
> 
> split_huge_page() ?

ah, yes

> 
> But see my reply to #2. Likely we should just undo the refactorings you 
> added while moving the code.
> 


