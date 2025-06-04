Return-Path: <kvm+bounces-48432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B64ACE3A5
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 19:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE4C1894D02
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D0D1EA7CE;
	Wed,  4 Jun 2025 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hQYdw7lA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CC31624C5;
	Wed,  4 Jun 2025 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749058183; cv=none; b=oU1zSpwUJhRUBW6laclMHSF2CF9W/fi6EGXz5lmDw9K7Ey6INqT7iEuxDt+fYatZSqZemCcE3COrhCR2iov1v3hzAIMfP96ZOoa8nGUExXe5sc3KefAYCldvVmiNk8+eo3kadDbEq4q5/NnOAMPk5SSsu207eKSt40dg4N3hNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749058183; c=relaxed/simple;
	bh=XzZe6OOeeDNRioBftXUcmPJ+uulMqlqV40mme1XLHCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM6wvFQO4fSwIQJCAy3g/EX0MRgTiofMdDanIaXvwAzcVtUt0OrbJq84NAK+rhuak1DD/v/aQK21ns63IOv480lmf/5+bgBz3A9GRB7jUxVxM45covSDSMaWSdc5YZdZBzDbu3ytM+pDdV1epGt6RU9aottEKoJr4DW0F1u8+YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hQYdw7lA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554Co0hF024220;
	Wed, 4 Jun 2025 17:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=U1Rh8hSr2JGOrgxgvwJ65HXvRaSDZT
	Wj5VRhM0KpukQ=; b=hQYdw7lAp7zgpTAOOt2O/x38dPQej0s7gU/wKaPmtrcueo
	CLS4sd4XHXU1HjfH8lSJsi/M9nSiiBlCCHNroY5wFG+gUBUzZl/+VBL9L4pZi003
	qy4hnuZuu9O4YQPte4UCwpJXJXRwjUNe2aYjscftz7B2pU37jyRbzX5AnEkDQvOn
	Ujm3exvZ3Qc9z58a9uEDbl3CF6c9ep9CRQXcm3149snq5caZ1eeijthzLMaM2WXT
	+R844LCIdW8FzS5+y0LdKiYwhLVWryrCAM5+Wimb5E83yScaD5QvKnQRZ1Pu8th2
	ZIX6/NLMQqdtNS/VQqzW+ISdDk5qlaIFfiThIgLw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyv9vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 17:29:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554FNqxd031650;
	Wed, 4 Jun 2025 17:29:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470cg011np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 17:29:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554HTX4I20251000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 17:29:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B1C520049;
	Wed,  4 Jun 2025 17:29:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 255F720040;
	Wed,  4 Jun 2025 17:29:33 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  4 Jun 2025 17:29:33 +0000 (GMT)
Date: Wed, 4 Jun 2025 19:29:31 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
Message-ID: <aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
 <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604184855.44793208@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604184855.44793208@p-imbrenda>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=68408282 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=-A1ZjbFOm4VmdGGBjvIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEzMSBTYWx0ZWRfX7BIsRoynUm5d /Tso7FE2J2zVrk3CrqhjYugwPE5KzauvECsYpM+XsH1/0xc0ItxZpB9eCAKpY486FdRH6QO6/Lx Wkir/E0IfaeTJexwwAZCxdJm+Vv10XyPoMDnEM4fyPVBDrxvzkOv1ppFOe4cUy4UiuLgyYRZnV7
 dBe3kiEYv/WlyaLoTbI3hrQhgEcyLv1BlhP1/kViwEamR7fbURYOvsJyb5HRS9cLXLrtBXTEWa8 8khVQYqxNR9zA8zaUIiuApwqPQNaRJSTNZQ/DTbP3JKWIPTMl4zIwFCRNgrt0+UPjMDGDlepydc IUiojjuXbQZB3d4IsYRjTMpnzJuFKCM6EMKqA9sZKpoL1K8xxVyJhpJ/AXk547CcP4Ly7Z894Er
 VqVOABp2iU3iRpD50ZUW38+4VHciFXXEA5QOXkZ3e2oryenOQNOSlyi//E50O4JO3LyaeTl5
X-Proofpoint-GUID: eqfojr6jxJoD4kQQUvoEJuKk5GB4e-eG
X-Proofpoint-ORIG-GUID: eqfojr6jxJoD4kQQUvoEJuKk5GB4e-eG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=594
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040131

On Wed, Jun 04, 2025 at 06:48:55PM +0200, Claudio Imbrenda wrote:
> > > @@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
> > >  		if (rc)
> > >  			BUG();
> > >  	} else {
> > > +		if (faulthandler_disabled())
> > > +			return handle_fault_error_nolock(regs, 0);
> > >  
> > 
> > This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
> > 
> > 		if (WARN_ON_ONCE(!si_code))
> > 			si_code = SEGV_MAPERR;
> > 
> > Would this warning be justified in this case (aka user_mode(regs) ==
> > true)?
> 
> I think so, because if we are in usermode, we should never trigger
> faulthandler_disabled()

I think I do not get you. We are in a system call and also in_atomic(),
so faulthandler_disabled() is true and handle_fault_error_nolock(regs, 0)
is called (above).

> 
> > 
> > >  		mm = current->mm;
> > >  		mmap_read_lock(mm);
> > >  		vma = find_vma(mm, addr);  

