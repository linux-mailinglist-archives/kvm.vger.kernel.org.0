Return-Path: <kvm+bounces-48425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B54ACE236
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBF30174F57
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276EB1DFDBB;
	Wed,  4 Jun 2025 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GGDTKJDd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B52339A1;
	Wed,  4 Jun 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749054481; cv=none; b=QAXyggpiP8zzhH1Y2jaMd1geg0irfAjBAGIMMxCEl8Z6bIFDsRXabo3EAKTsMqaD9TlvUz+mEoi88RKmt4AYwbY0dJ708iaG8PUWlFBN6QjxUWH7iJFzg4Hf53ocWOGtZPSlKbUufPCBwEDL4CAjdaDPzxDmjMAYc/oPJYgv4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749054481; c=relaxed/simple;
	bh=M5CwoT9fT6WRXkVfDF7hfLXgzn+49k9G+Q1xlBia7Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCtwYVxTIP8R7gzv3upjjA0g4rNd9lPWNP0jGl+htZ6k7nVtep7UnFqhX51LtmGVnjXBg8xQKtJJOcl0Yz6dq4pknOIwknFQtaDVgq7DDayxLh7tfcFVUaMvROfFFgnVcvJ9lKOnwqv5KXfaU19WghA85lyCjRUuTxAiFTp72eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GGDTKJDd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554C8Fku031727;
	Wed, 4 Jun 2025 16:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=odV9eqRZtddxv8cXsVKaJfeGVY72dp
	B5o5Jyqa1hHPg=; b=GGDTKJDdyFUUgdnHT8bHLAcvAeBZC4sdD4sUduWm8Ix9pZ
	BQqhb8GrMiPX7KIGcZGd5Jvzsy6GYWVKN9YlLeMInYeSwVR/5vwHKG5zC8Odi00X
	crkOyaKJNd7h8L5IZYpHjjRUTAlVzzlzk6Zk8E43zUp4q8KFsjxgf1JDZRQPnqrE
	F/dL59kjCNkCDsRY5gC0jxMHBfws3dNaIc8vw+TOs5juMtnOHp4U54UjFTzXU44u
	mHeeLuWLmT/yI9On8PDHLRB6aOSpBXunQUeovxITEHxVeKm57MiLTUv31VtuJ1pj
	761wnilUJPkjhFn/c3DYQdJGFiXnBNBft5JnJMoQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyushx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 16:27:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554FgW7s024914;
	Wed, 4 Jun 2025 16:27:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkmgjc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 16:27:55 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554GRpRZ48234854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 16:27:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A2182004E;
	Wed,  4 Jun 2025 16:27:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0EED20040;
	Wed,  4 Jun 2025 16:27:50 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  4 Jun 2025 16:27:50 +0000 (GMT)
Date: Wed, 4 Jun 2025 18:27:49 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
Message-ID: <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603134936.1314139-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XXR5RXs-nmhHCVi5aTsnkL_WPjZgyPqb
X-Proofpoint-ORIG-GUID: XXR5RXs-nmhHCVi5aTsnkL_WPjZgyPqb
X-Authority-Analysis: v=2.4 cv=X4dSKHTe c=1 sm=1 tr=0 ts=6840740b cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=kcu79PlnQnCj__8gWF0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEyMiBTYWx0ZWRfXxreFWSEaAFdM Kw0yp+1C5a0AEsyRQYizXnAiu+q38eNgrMQQ2PUS0RKCGgd4C7fc3rsHaGA9DePfqQLwfpzECXV zAxTy6cf2i5VLAL74qupbQUbV6NwUXV6QS/uNgcffN2LPCUq/YHWtWbFq7IP3mjI3yT8fKnKhnt
 EhDrSmG9B++U55a4YudEJSBQFCb7exFxa5m1xQwvBJTynvBVnMm7nmGe+WxaCl/8UBECCQlfPau dYfbJM1sGI5XUN55AQpdMCYhB+fvQzeDbxcIJp9u1FkvmiIS4PkXKJ5f9K1efGCT8+SzohJ4LsE tRwPZFuZ579S7lQdgSByQmHy3lLH3d+jkZS7Vd+V/PbtKNy4jMI2iv4cZwGP8GQj6M4wXRJhhe/
 2GAyXj/Q1cW5GRt9G//o8Ma8stXgit0BhErvd3IZbdZnSK5OhOC1Tgn9whdaA3+7wW+O23Gg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=627 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040122

On Tue, Jun 03, 2025 at 03:49:36PM +0200, Heiko Carstens wrote:
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 3829521450dd..e1ad05bfd28a 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
>  		if (rc)
>  			BUG();
>  	} else {
> +		if (faulthandler_disabled())
> +			return handle_fault_error_nolock(regs, 0);

This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():

		if (WARN_ON_ONCE(!si_code))
			si_code = SEGV_MAPERR;

Would this warning be justified in this case (aka user_mode(regs) == true)?

>  		mm = current->mm;
>  		mmap_read_lock(mm);
>  		vma = find_vma(mm, addr);

