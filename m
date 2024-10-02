Return-Path: <kvm+bounces-27806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B78998DB68
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C495028243A
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1F81D26EC;
	Wed,  2 Oct 2024 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MvhZ5WPP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56111CEEAF;
	Wed,  2 Oct 2024 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879150; cv=none; b=t0BZ/HyVFf6LJ1l51vYIjJcEZaGMlmXbdmFKvOQUhLYhD+VmsrpiCUpnkypJW1Bth2/xkZLqwFCiObBoAbfgfQaPjW5aRlCq71xtfHj33iSPG2QQ41BzELsD0hvHmP9tLS5ZVBB9V0/CP9gu2b8kb/DkE3OJUixfR4toiSQCzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879150; c=relaxed/simple;
	bh=R3rceRteG8fgjwgLlNJi7VzP837GAstprFERWFU60QM=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=q6qTwrWAlUhJ5Jqdti7KaEbzM8S4eBk0/lkxC82pLYUdRJ7f3fwaZBvUKcxUmP6awS3W5GK2Z7cjL83ae/ChuObA4hGBgHnE+pNDJ4LZIjc2LV495rPt8hs1YSsiRY33OF4zhu1UkCOIqDa0mNDCxeWdcl9m8gr1MJglZxTkcDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MvhZ5WPP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492EP66l026779;
	Wed, 2 Oct 2024 14:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=mPziYV
	JIuUL9desjvVrYcKa8x1g6tYrEAgthMPitYLI=; b=MvhZ5WPPuAOrl3IGF1tRRz
	eHf4Ot9osTPoMJFY9HnayOKzE7TiWyLh8GnwvOZyzw4IMcYNgWGtL2XK5f8dyYib
	NC59t3nAjZge0YyfzYIF6sFmK9VBv826XnToGhIExFtO0IlHn2IzBhIJCQoaUspy
	+lIsGPT94RYo3ct9HoctytQUClUJuzvMfUveHflg5So1ifxV8+vLKAtvNMB1VVqP
	DqqP5WJr+olchutdf5+30okljwGzpSvPrXR47kvfrNN5okws+GbnPK+kZwl+0la+
	G6UA+oiyLAmDVzZ3YMn3pw8H/vesd3eUVJdNnb374g+ruz7e8HFMnU+KUBa3jxLw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wx0036-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:25:47 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EPlJ7027679;
	Wed, 2 Oct 2024 14:25:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wx0035-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:25:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492DCThD018356;
	Wed, 2 Oct 2024 14:25:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xw4n2t0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:25:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492EPeIE54460918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:25:40 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73E5120043;
	Wed,  2 Oct 2024 14:25:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55C1B20040;
	Wed,  2 Oct 2024 14:25:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.111])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:25:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241001113640.55210-1-imbrenda@linux.ibm.com>
References: <20241001113640.55210-1-imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: edat: test 2G large page spanning end of memory
From: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        thuth@redhat.com, linux-s390@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Date: Wed, 02 Oct 2024 16:25:39 +0200
Message-ID: <172787913947.65827.12438423086547383920@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jTioX4bkMEe3tFVAGx2gDV1fo_hj38zg
X-Proofpoint-GUID: RzGXxmKH_JrxImIXbhKQhjkLkZXR2TsJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410020103

Quoting Claudio Imbrenda (2024-10-01 13:36:40)
[...]
> diff --git a/s390x/edat.c b/s390x/edat.c
> index 16138397..1f582efc 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -196,6 +196,8 @@ static void test_edat1(void)
> =20
>  static void test_edat2(void)
>  {
[...]
> @@ -206,7 +208,21 @@ static void test_edat2(void)
>         /* Prefixing should not work with huge pages, just like large pag=
es */
>         report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
>                 !memcmp(prefix_buf, VIRT(0), LC_SIZE),
> -               "pmd, large, prefixing");
> +               "pud, large, prefixing");
> +
> +       mem_end =3D get_ram_size();
> +       if (mem_end >=3D BIT_ULL(REGION3_SHIFT)) {
> +               report_skip("pud spanning end of memory");

Does it make sense to explicitly add a mem parameter in unittests.cfg so
this will never be the case?

