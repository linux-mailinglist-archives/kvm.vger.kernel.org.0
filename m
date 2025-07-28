Return-Path: <kvm+bounces-53543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC7DB13CB7
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C003BFACD
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE8A26658F;
	Mon, 28 Jul 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hvn+ruiH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7857F43147;
	Mon, 28 Jul 2025 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711668; cv=none; b=fIEK3Pu5TI5NXP3fa6PG1neNbimZTVpilAZlIrwxmL8wbv/9uFxQQb+7cxwUxw1C31Tb2a+AEZEFhDoI1xzi+HRlOdPfoWutNmdHxB7WrrrpplXFCBmKkD6g5r/uS9bc5jMHZF/cCHYeIg3OyIPU8FSMfzFv7Li0Vb176jE38Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711668; c=relaxed/simple;
	bh=RYHGAHuORfvULLqyeEf3S1U+2f2+Klyx/Brp6uiuuAg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUVvDqlAzzzo5RNaESfAXrbghOAxEUrKy38nM7yEAc5g78QC7anuhn9gCXUopE8RvIAdd4In6dreQJssPp755Dg94NROz+DjUd1pRvNfSx8KZSYSqTP8SC1TBSeSxRpNui+wt+KsaOgRC7R/Mak88EqboyL4eWW6w2V4iN3Gv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hvn+ruiH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56S8DLSY019248;
	Mon, 28 Jul 2025 14:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iAn8eU
	pz3Vslio4Sr1C9AjEgW4Kp7XjQzX3LrvFqWHQ=; b=Hvn+ruiHZR+oex92NCSxeh
	gzmf6stq3al4wfHfWB4kmxUlymM2BAq8SPDp0II3+jkyWNIzqc+LWIiwM/UKGe1X
	IwRQMfP7rOoXO2yRsJTDnYmq41wsa54MwmtywOzbRBelWQlvL+zK+1YjKq0cu2Mr
	HXuq/oBN8HHU6myu1CaQ58bzXOtjrTSEQVCrAheNtTPThK02MUiUuq5xA+fLcniL
	OEgmoBshrncHAEDQ/YAvlmJ2VhZtMMFPLfr0598Kut1t69afUC19yHkh5tD246zA
	MAEId4z9pbzvQZSKLLQnXYc0V68s8gJ7QmZw8pAhQf4TgTtdT3CpZffOfsS+sncQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qcfse8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56SA6q1u018275;
	Mon, 28 Jul 2025 14:07:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abnx2yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 14:07:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SE7dDI53543258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:07:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18F0320043;
	Mon, 28 Jul 2025 14:07:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBF5420040;
	Mon, 28 Jul 2025 14:07:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 14:07:38 +0000 (GMT)
Date: Mon, 28 Jul 2025 16:00:29 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/3] .gitlab-ci.yml: Add the s390x
 panic-loop tests to the CI
Message-ID: <20250728160029.464217f1@p-imbrenda>
In-Reply-To: <20250724133051.44045-3-thuth@redhat.com>
References: <20250724133051.44045-1-thuth@redhat.com>
	<20250724133051.44045-3-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDEwMSBTYWx0ZWRfX+3bSWXNvK25X
 7Og4E9c7aJTQz/BdlQUyKP8XMYa4WnYqY6e7e6NdJcJaOm3dZNjOZq8HDEyzV9e9/fUrmMe2JH8
 QWX9MCZiT8ok8wlLj2HW0JDHClggodriWyK08KGpWPkn1DxISAVtmE0cA9ZOFcDUP2u7NpaaOC4
 IWr4orkg0Ai537HUNqXBIDQxa5oWFtErvxsmRv3a6mvp880SgVKPdTWwJCxUTw4DsXiSW56JSZy
 +IxAOleIhMgt0qmQM2iyYO8mb+2plp6W0eGaS/sgr98w9M3S2bdGqcdcEqe0+5pCO3lmhc1ojHx
 lC2Fv2QtCoSsrE37I1pfTj4T+0QEHsCcLzyWIx3SawCE6LmHsSQfjOod60dn0xCj8nR7ppwBDeI
 osuDfznhpq3LO7MA2jSoQ0AaK3c5T8WMjrl3uZ/LkgH0HkMh6NOd8u2r2J+Im4fTRlxd2JOF
X-Proofpoint-ORIG-GUID: Aqmw3Iv63IaMPn6RtCnLwH6XUE-clVqo
X-Authority-Analysis: v=2.4 cv=Lp2Symdc c=1 sm=1 tr=0 ts=6887842f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=RGakUqBCiD64rD5L_YgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Aqmw3Iv63IaMPn6RtCnLwH6XUE-clVqo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280101

On Thu, 24 Jul 2025 15:30:50 +0200
Thomas Huth <thuth@redhat.com> wrote:

> From: Thomas Huth <thuth@redhat.com>
> 
> Now that these tests should work reliable, we should also run them
> in our CI.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .gitlab-ci.yml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index aa69ca59..7e3d4661 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -517,6 +517,8 @@ s390x-kvm:
>        migration-sck
>        migration-skey-parallel
>        migration-skey-sequential
> +      panic-loop-extint
> +      panic-loop-pgm
>        pfmf
>        sclp-1g
>        sclp-3g


