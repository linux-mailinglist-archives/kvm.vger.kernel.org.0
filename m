Return-Path: <kvm+bounces-39303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1191DA4677F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6054279AD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 16:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260232236ED;
	Wed, 26 Feb 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QNYH2H2v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB521CA01;
	Wed, 26 Feb 2025 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589125; cv=none; b=ZSf6HAW9id7e++tJ46t8W6v0r8TAqnn6Cj0F2k9ZsAWbzP7z4VvfIph4lv7xMYtcsMi5MF9Uf4z82w4GGDz69f8ygNuzPvXtoyyaLXaEtWYAdpismasZhApmuWkr5tkJTy8AYuqGTxCL0n5RdEn6TLd1QAo9u1I0zbZusOjp/0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589125; c=relaxed/simple;
	bh=Fg223SHibQKgebDMBsGFZaFDHofVBllGK7dAM65Pxp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igs1vXd001Jw+N8eh5q/GFp2ziBAlEwWxkJv0WqcPChcnRKcGq+nWUUnzb76ScaovBHHIpTwfpXFlLK6QbGRSn0NuIfK/AMvxRuGsHzY9O5a6bHa9nDhIExXdhZhkWVzQ4ot8ifFXjewju9cKtKRzHbZ00i1SGDsG1MTcYR1474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QNYH2H2v; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q7WpHM005964;
	Wed, 26 Feb 2025 16:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Qqkvw5
	sVdc4OjLjsPlTA9mIkdFACVA5E9/VNX7SLR5A=; b=QNYH2H2v2uxFzuF3CLBqmI
	aDqSzrJJKnbPw+NbLv86zizCq4kQhLSKP5ND8LZb62B/Q6rqO3GdtCsvyS3mn38w
	4H3AXRIRPO/c6gYdLICeco9TRc/IgWamioOkVOqZDObqQDO/MPCzkSf3YrCB1g2z
	3oBTRAfQwFc/dGPAZwCs3S58ltICHBzx+XByYmQ/gf0CqoPTrQHg5Z8pIIJg2woW
	ICrctI3/Ttdb1ug4cXuHzRuqnG7ztuSzXv0hIfHsNf9pQyjyU9OGO4KuFInDXZr3
	J3+iabHam7lLJ0OBRtiMaqd8XU+5YdnsGT7clnYXvmLuMK7h0LmaqVOtso6mqDcg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451xnp2nat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 16:58:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QE5xIF027372;
	Wed, 26 Feb 2025 16:58:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum23amq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 16:58:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QGwadU10486202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 16:58:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE98B20040;
	Wed, 26 Feb 2025 16:58:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C62E2004D;
	Wed, 26 Feb 2025 16:58:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.9.246])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 26 Feb 2025 16:58:35 +0000 (GMT)
Date: Wed, 26 Feb 2025 17:58:33 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250226175833.16a7a970@p-imbrenda>
In-Reply-To: <0dfeabca-5c41-4555-a43b-341a54096036@redhat.com>
References: <20250226123725.247578-1-imbrenda@linux.ibm.com>
	<20250226123725.247578-2-imbrenda@linux.ibm.com>
	<0dfeabca-5c41-4555-a43b-341a54096036@redhat.com>
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
X-Proofpoint-ORIG-GUID: WrNXnQvLPCPgrc_P8En33TtwvtL5axnM
X-Proofpoint-GUID: WrNXnQvLPCPgrc_P8En33TtwvtL5axnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=827 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260131

On Wed, 26 Feb 2025 16:05:11 +0100
David Hildenbrand <david@redhat.com> wrote:

> > +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
> > +{
> > +	struct folio *folio;
> > +	spinlock_t *ptelock;
> > +	pte_t *ptep;
> > +	int rc;
> > +
> > +	ptep = get_locked_valid_pte(mm, hva, &ptelock);
> > +	if (!ptep)
> > +		return -ENXIO;  
> 
> You very likely need a pte_write() check we had there before, as you 
> might effectively modify page content by clearing the page.

it's not really needed, but it doesn't hurt either, I'll add a check

