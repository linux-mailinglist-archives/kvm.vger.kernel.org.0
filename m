Return-Path: <kvm+bounces-27807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D12498DC1F
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C54A71C241B9
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A21C1D049A;
	Wed,  2 Oct 2024 14:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="INW8vPKD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D761D3584;
	Wed,  2 Oct 2024 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879505; cv=none; b=mEnoAjaFeD1brYzOTHWpz57bYX0tRDb4MtMs/eN+CdfG0+V27dvsAic4b/fo2eQNNydTqRd9okGpiFrRwriWZARvGojZRRYKdOhJXIiLBH7SXALPS3pokbZnp8f+lFyRNQRuPxMvpMrNdKk+4DGdnBijVjdh0x8v9LvqqPDmGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879505; c=relaxed/simple;
	bh=bLdavYcahwKB+ncT13ZkYmJ39EcdTUJjmHNCXMfaG7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+/De5QsnE2kd1MDOXi0kzkhT+kFNhNXve/ozbpi33Kgs1Xm8VXNzvccFA0oAQuADlaG9X6nsGg+VXDiWWoGeoLFh+wsh4Hk836xWG8VtxDpjywwijKkZaWiEd7iVZrwdGeMdHwEC17r+eUTlgsfrzBXQN1CoFey0qpMo2bxNH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=INW8vPKD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492EP15u004952;
	Wed, 2 Oct 2024 14:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	S34rieSNApgLu+8+MyooR7CocM8zKeGmBz1E9GSm0lw=; b=INW8vPKDmUUgK7TX
	li7Ib1FhqwDooYFUVKmW7gz5oWOjzj9jmOyzYuKKQ1UrSKx2eEtjBOG+y5as+qLV
	6M6620tJcUl/sPQqIT2z/CTDZ27l0O9WYHT7nPKi5QBWnJoRBKD+aqCQt7WeQajt
	MZJZaMLzNoDVwEl0hUoikAxHDYNQHggvwJiiz1F06B2H1FolTle2AiDSOXlG/mju
	QoQIkbfvDfQo1tPgNR6e1M/BopB9jYuh5puG/Er8aTiGHZ7EPPEzDCXYHxSIcKG3
	gUvnreTxj8Gfbl2bWFLK4eqf6mzbYcgGcTiWZ0+ID8ta78r6ZCtFDjerAZEkbmBh
	sgPCWg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wvr107-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:31:42 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EVgfb021582;
	Wed, 2 Oct 2024 14:31:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wvr106-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:31:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492CgH75007989;
	Wed, 2 Oct 2024 14:31:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xvgy2y1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:31:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492EVZPV57016602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:31:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FC5420040;
	Wed,  2 Oct 2024 14:31:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AF3520043;
	Wed,  2 Oct 2024 14:31:35 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:31:34 +0000 (GMT)
Date: Wed, 2 Oct 2024 16:31:33 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        david@redhat.com, thuth@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: edat: test 2G large page
 spanning end of memory
Message-ID: <20241002163133.3ade7537@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <172787913947.65827.12438423086547383920@t14-nrb.local>
References: <20241001113640.55210-1-imbrenda@linux.ibm.com>
	<172787913947.65827.12438423086547383920@t14-nrb.local>
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
X-Proofpoint-ORIG-GUID: 0Od3_cZtDJ4C_J8ubq4ddXwXaRACoXB3
X-Proofpoint-GUID: kfRnsQKOTd2SBf2oSjkE_apNtYMInyR6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2408220000 definitions=main-2410020106

On Wed, 02 Oct 2024 16:25:39 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2024-10-01 13:36:40)
> [...]
> > diff --git a/s390x/edat.c b/s390x/edat.c
> > index 16138397..1f582efc 100644
> > --- a/s390x/edat.c
> > +++ b/s390x/edat.c
> > @@ -196,6 +196,8 @@ static void test_edat1(void)
> >  
> >  static void test_edat2(void)
> >  {  
> [...]
> > @@ -206,7 +208,21 @@ static void test_edat2(void)
> >         /* Prefixing should not work with huge pages, just like large pages */
> >         report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
> >                 !memcmp(prefix_buf, VIRT(0), LC_SIZE),
> > -               "pmd, large, prefixing");
> > +               "pud, large, prefixing");
> > +
> > +       mem_end = get_ram_size();
> > +       if (mem_end >= BIT_ULL(REGION3_SHIFT)) {
> > +               report_skip("pud spanning end of memory");  
> 
> Does it make sense to explicitly add a mem parameter in unittests.cfg so
> this will never be the case?

hmmm, I did not consider this case; I kinda assumed we would never
increase the default guest size

I do not have any strong opinions

