Return-Path: <kvm+bounces-14247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD008A14B8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5A5628129E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 12:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41D81426E;
	Thu, 11 Apr 2024 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jh2Xyfiw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2428FD;
	Thu, 11 Apr 2024 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712838846; cv=none; b=BVhzKSsfcEAMVReMBZdDnm3amf8dtFx4XAy22bJMeBbpMNDSGaQ3wuIuiQQ7md7OpvSkkIwJVxLDvN+TTBT8D9olzQjm0nLu4TgfgkctQxoXUsxFfi+qxb07sJI4XAQQcz5Knx8khNlpgyDyl94bE0wFOqxpIS/bnhlJ4UqlI+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712838846; c=relaxed/simple;
	bh=ln1Vg7MHH6aZ0MYozzx3TrJLr2NDzcPwHXMqWLMD2cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhxAiZbfXuBYjR9yq39Smay5H4396Ri7fDWyzZZUCXdO6sMp4zwwNsvehxgizwcSwhGLZynzRJ09B0GKVvGODq/YPnNQSf7e1kwhGLG8zQSfa7fPWmwJsE+s2yIulT9pbuGr/J0rSdLK1YeEcMeBpJWiVKKYpAHC+EPI+HG4n8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jh2Xyfiw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BCEVaN017214;
	Thu, 11 Apr 2024 12:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=1dvEKifc/6rjfPv87TCeivcl34rgLSFFL0Es/GR19sM=;
 b=jh2XyfiwfNZMK/vuSpTH9vY1vdtVAvBslEk5SmyBbgTAfi7+Z9AbNOLhykLE4izGpsEP
 EOzFtutOa03UHU79e1q0X0sTCXGO081Sf5Eh0or/wOPW8x9q1SFJc3FzIdByglt5IDm7
 b1rvqKkjFvTC4o2hTu99tlnlAF3S6aPzkmCamgQfO21TVSKPN2TlyJI3O57CNM8NcOEi
 ra/ZUYK9Zz57LCTYSCbeeuPIjzrKarL5FEWishbpFUJJ/K0OGGDCgRoATw4ZGa7oxSTV
 /dyms425e0seVmUY8fnUvjI3WcHQJQUu93844jl+q2SDpA0s5ZlN3RYexPhr0J2HdBcm bA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xefpa01kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:33:57 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43BCXvxQ015676;
	Thu, 11 Apr 2024 12:33:57 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xefpa01k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:33:57 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43BC7dDZ013594;
	Thu, 11 Apr 2024 12:33:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbgqtuc6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:33:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43BCXpeh47776178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 12:33:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBC8A2004F;
	Thu, 11 Apr 2024 12:33:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52C6D2004B;
	Thu, 11 Apr 2024 12:33:50 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Apr 2024 12:33:50 +0000 (GMT)
Date: Thu, 11 Apr 2024 14:33:49 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 2/2] s390/mm: re-enable the shared zeropage for !PV
 and !skeys KVM guests
Message-ID: <ZhfYrVERxUijQbAL@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240327171737.919590-1-david@redhat.com>
 <20240327171737.919590-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327171737.919590-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VvoeM2zbgaE9iYEfuc8Pes94oyOAiZCy
X-Proofpoint-GUID: ZK1sTw26AJ2j9lBujMNsARBlnd4_Mdln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_06,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=414 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110091

On Wed, Mar 27, 2024 at 06:17:37PM +0100, David Hildenbrand wrote:
> index 60950e7a25f5..1a71cb19c089 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -566,10 +566,19 @@ static inline pud_t set_pud_bit(pud_t pud, pgprot_t prot)
>  }
>  
>  /*
> - * In the case that a guest uses storage keys
> - * faults should no longer be backed by zero pages
> + * As soon as the guest uses storage keys or enables PV, we deduplicate all
> + * mapped shared zeropages and prevent new shared zeropages from getting
> + * mapped.
>   */
> -#define mm_forbids_zeropage mm_has_pgste

Should it be the below insted?

#define mm_forbids_zeropage mm_forbids_zeropage

Once I add it, it fails to compile, due to the issue in patch #1.

But then I guess this series was tested with the generic
mm_forbids_zeropage() which always returns 0:

#define mm_forbids_zeropage(X)	(0)

> +static inline int mm_forbids_zeropage(struct mm_struct *mm)
> +{
> +#ifdef CONFIG_PGSTE
> +	if (!mm->context.allow_cow_sharing)
> +		return 1;
> +#endif
> +	return 0;
> +}
> +

Thanks!

