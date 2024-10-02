Return-Path: <kvm+bounces-27811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9F398DF34
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 17:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DBDAB279AE
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 15:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A28B1D0E1B;
	Wed,  2 Oct 2024 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j5oW9u09"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2851D0DDD;
	Wed,  2 Oct 2024 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882856; cv=none; b=quMD5fc/srNF7frS6KDNnvxEzRgHZVQXd8qzjZBbLABoVGIzGxBDZR+dKqIB1YN/Vq/cR2z+ONjNrK+mNjcWBWFWnXz810z0p0iyPMS8TK8L5shlCcA9SEGo0KxEGoDmIwzVFqP2dj4n4RbtwdjcTU6zHqMEZCu+HnwTwZX7pS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882856; c=relaxed/simple;
	bh=gF0LNo6VaA21WNn5gsVFmUNn8h6ziDWmDXH7txSWGsE=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=uw7cb75uewjv7dxKqWFqYnaI4n2rVXdGDMUfHQlqM8E+TcZivCO8K+ROdAXZx7XTe1MgjvSdi3PVXYcwbrHdPWtqjCgLLDak8+S4TcGkRDKDJhCKATU+4t2tNAQ4JTY+CpIvrM04bbc+FE408ru4t9U1sx7omsOuaUYD83tpvjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j5oW9u09; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492EP98F026879;
	Wed, 2 Oct 2024 15:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=N7TZr/
	cro3WJJ4MdF4MbjrVtPA14Uj5HFV/VVMpbPBU=; b=j5oW9u09ZDWUME9PXVrVnd
	/NtvwN18SdiFGyRRv9qribISQrWCXOJZqSfpjrvdDBWv+T1n/IgzpcxJ1bScCBXk
	mrSP/oIYK+XJhjjZLrr+zRUw8n6LqXnRe7qd0cPHn8SbaWdnuC1HTgc0MyV+Tyw5
	h90mrIBoKWHr4mgOf4yrbVnlAFevCnvqddYMovVUlxfLDRo1QKJSpVjEzJUL74kM
	Ke9b7y72j9L+lN71BVLzNs1UZA6OE9zzycPdr6ilAQMPKhUU0ifwLWVd9Vfmxfim
	8/ERDQAk3LUAtMY0yoAf/YV6yL5NSi77Rj1tXYCB3+qqaEYTb2YRg26IFvg5vG8w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wx08yu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:27:32 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492FR3nZ015936;
	Wed, 2 Oct 2024 15:27:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217wx08yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:27:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492CgHNT007989;
	Wed, 2 Oct 2024 15:27:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xvgy36q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:27:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492FRPCu54133130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 15:27:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F0022004B;
	Wed,  2 Oct 2024 15:27:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0CF920043;
	Wed,  2 Oct 2024 15:27:24 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.111])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 15:27:24 +0000 (GMT)
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
Date: Wed, 02 Oct 2024 17:27:22 +0200
Message-ID: <172788284289.78915.13149730018195904612@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TPRHHbK-UYrqtxrR_CLsmCOGvWVQNC5f
X-Proofpoint-GUID: RMdZzrl-V5h2oqB6GxRgp8unQb12dj-s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_15,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410020110

Quoting Claudio Imbrenda (2024-10-01 13:36:40)
[...]
> diff --git a/s390x/edat.c b/s390x/edat.c
> index 16138397..1f582efc 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
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

Do you mind introducting REGION3_SIZE like the kernel has?


> +               report_skip("pud spanning end of memory");
> +       } else {
> +               for (i =3D 0; i < mem_end; i +=3D PAGE_SIZE)
> +                       READ_ONCE(*(uint64_t *)VIRT(i));
> +               for (i =3D mem_end; i < BIT_ULL(REGION3_SHIFT); i +=3D PA=
GE_SIZE) {
> +                       expect_pgm_int();
> +                       READ_ONCE(*(uint64_t *)VIRT(i));

Would a write behave any different here?

With or without the suggestions above:
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

