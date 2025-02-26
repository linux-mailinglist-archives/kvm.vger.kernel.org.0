Return-Path: <kvm+bounces-39306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 021E4A46803
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3E5C16FD0C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AEAB21E096;
	Wed, 26 Feb 2025 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RWjGE6Jy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E221B1B5;
	Wed, 26 Feb 2025 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740590782; cv=none; b=ttuSzhk57+760k7hB/NaRm3dxAwPxdooHpoUNrszJcf+M2OfVRp4zQ1owMvjLeZmgf8jp4JpYiRlhiULMQ8fJT9lt4mg9FNFbAEiMzu2et2xlVJzj8uN6j4a79+5HltoJTvY9IBCIMQNPQGDgxfWaMIm2bRG55pzVqOkLUrFUQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740590782; c=relaxed/simple;
	bh=dsO8NMmnq2s9Xdtb5VTgRKSzzLQ15hONi/n5gK0tuZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZ89F9/rdwgokX8euRGMnbjLlGMOY1F1YYzdXHI4SYDA9SqFN1kCniVcATiBOFug1foXiZaMuDNfhIvmWtt1mSucWduwc4JD7qbw6xkyPUzgLDimJ/hbpAGiYeLp3X6vL22d6DhLDsg9+JoYOTccIeZ2WvRwVZRGE+84i73V2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RWjGE6Jy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QDZ5TY029108;
	Wed, 26 Feb 2025 17:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EkZGV1
	6l4vKYQHNM1i4geUg5iJU2btMvixnAYOrtzEo=; b=RWjGE6Jyq2k9ygZt4KNInz
	pTC0AUZzYF9kmuYuU24+mm7ANpK2lbQ8jE3mYn9+tLNMPJDe9ijDE4of1/RM1h3Y
	AUmSGMbbUs+6WKm66vV2+qlzRyYgWFORqJe9KNXELeWzYPnROx+72DgG8vUOpuT/
	Mf4FakiYjl3Lbih7SfOiTj924OMAd8UK9FcWwlMhmPEM3Xn9alTbve3bCgJ6k3zt
	+4pTYObNmx/OZcddBHHJuuaJ2fGh/mvrXzhtrmRwse4GVexbCtUrkoVkukfElXOL
	wKzAgNbv7bR4y8m8e218ypHXYrcM9fLoxAnfeNLMuHxDb7OOuifDiXFsKoAGl4Tg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451q5jcntk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 17:26:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QGsnkS027328;
	Wed, 26 Feb 2025 17:26:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum23g4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 17:26:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QHQDuM34537992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 17:26:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EF5920043;
	Wed, 26 Feb 2025 17:26:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7459820040;
	Wed, 26 Feb 2025 17:26:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.9.246])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 26 Feb 2025 17:26:12 +0000 (GMT)
Date: Wed, 26 Feb 2025 18:26:10 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250226182610.7f5313ca@p-imbrenda>
In-Reply-To: <bab79dbd-64cc-4a58-aba9-bc5fd4d6beca@redhat.com>
References: <20250226123725.247578-1-imbrenda@linux.ibm.com>
	<20250226123725.247578-2-imbrenda@linux.ibm.com>
	<0dfeabca-5c41-4555-a43b-341a54096036@redhat.com>
	<20250226175833.16a7a970@p-imbrenda>
	<bab79dbd-64cc-4a58-aba9-bc5fd4d6beca@redhat.com>
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
X-Proofpoint-GUID: 5OyKm02NnWNxEvgMIiXTeCrhjixIc5mN
X-Proofpoint-ORIG-GUID: 5OyKm02NnWNxEvgMIiXTeCrhjixIc5mN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=960 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260134

On Wed, 26 Feb 2025 18:01:04 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 26.02.25 17:58, Claudio Imbrenda wrote:
> > On Wed, 26 Feb 2025 16:05:11 +0100
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >>> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
> >>> +{
> >>> +	struct folio *folio;
> >>> +	spinlock_t *ptelock;
> >>> +	pte_t *ptep;
> >>> +	int rc;
> >>> +
> >>> +	ptep = get_locked_valid_pte(mm, hva, &ptelock);
> >>> +	if (!ptep)
> >>> +		return -ENXIO;  
> >>
> >> You very likely need a pte_write() check we had there before, as you
> >> might effectively modify page content by clearing the page.  
> > 
> > it's not really needed, but it doesn't hurt either, I'll add a check  
> 
> Can you elaborate why it is not needed? Would the HW enforce that 
> writability check already?

as I have discovered the hard way while working on this v2, yes

but as I said, it looks better with the check, so I'll add it

