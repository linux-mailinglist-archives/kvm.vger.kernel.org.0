Return-Path: <kvm+bounces-47885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A00AC6C57
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55A791716DC
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE8A28B4FD;
	Wed, 28 May 2025 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ewSQBIPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B31C1B043C;
	Wed, 28 May 2025 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444202; cv=none; b=Dw4lt+pmf6rJDQ6utIhv7+bXfyqVdmEfOhNtyB+9HgyV7KtR4lD+D12jKopJmMC4Csu8IynlNjRLfCTzWaqAVcfylt3Am4DqjHJ9GEjNWMpSOo0QcYlqBT3xgAd5ByQSXs/BDDGjSSG3eaBxWmP8GxZMs+qtdd7KouJsFtftOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444202; c=relaxed/simple;
	bh=SCjFxV7DRhYT96XnLNL4doQAQylPnnal991GszSA+uo=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=KUBvJP8pOV/9TT4MLxYhUsoC59BiwPut+3enInSf932VYKJ8V4S6F3BhhTciBhXGMBHrBO9yTPhGW8l1Ox0+VIiyeqWF6Cry9TWaOeqg0BGGVsGXTd0UL6b9gCwJofSrgKhT7y07qKcdLlNDNs8FsohWohVgCIjwFH5ftrTwvkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ewSQBIPJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9JCo032092;
	Wed, 28 May 2025 14:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eq85do
	RDjRzy/Cw0PdNFOEyNJqv98vYq1aKo8ImVJnk=; b=ewSQBIPJNXBHx+SpCWwXv8
	rCUGg18owxsM97zqTSHyu1CD2WnOmqrBTObMoMMa82l36VSae3u9lY+95j32T12t
	KMwEKLnMH8pbLRK2K4dw5ORAPYPwPJz6aOBsV/e/gnzjqnWs8nnS8lAWTnkHP13c
	rWOPlka4TCH3oU1OJzE7W6VSXhuuqN7xT3V+4aa5a0PhG+Ekkt6ER/1folRwQG1h
	2bkB7Ob6r6n7+1Esg931WvsNqtXKErvwq/Q3uKk0QEhOZIQLS8aT2xFTrAPVqPRn
	xw7MHRjvuoK/z65Zxjrkt4oK577aSWClc1zguHpnT3CPZevDZq2/w2fEYepWZI1w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40gg9ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 14:56:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SAlHPL026424;
	Wed, 28 May 2025 14:56:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxmyx4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 14:56:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SEuXIG52691220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 14:56:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75ADF20049;
	Wed, 28 May 2025 14:56:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A4A720040;
	Wed, 28 May 2025 14:56:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.43])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 14:56:33 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 May 2025 16:56:33 +0200
Message-Id: <DA7VQLOWWTUJ.P37SCGP032T3@linux.ibm.com>
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Cc: <linux-s390@vger.kernel.org>, <imbrenda@linux.ibm.com>, <thuth@redhat.com>,
        <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: diag10: Check page clear
X-Mailer: aerc 0.20.1
References: <20250528091412.19483-1-frankja@linux.ibm.com>
 <20250528091412.19483-3-frankja@linux.ibm.com>
In-Reply-To: <20250528091412.19483-3-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zQuP73n3wxLvxjO3YBhD0q4fr-eRXa9S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEyNyBTYWx0ZWRfX6P9sy2iZpRgT NwTRBR/NvqfnDjMF3pZD3dL1cZ9G6OwjTLONdv3BxlEEhUG2QIaBRL7oOW5AoWEG5tRMLrg5ps3 l359PsN7uvlMng5PFNNIb1bjuTkOVy1Kvx6/giCfvGnD+YOpItuxdGBqUy9R4vwOiZEPvWCIpnf
 SbyE3Ae15vVISlA2/K/v58BZtLHfTFqv/CzNxRRqEQ5w+9PGenau5JC+/omSpiRWOiuBtb4MIll K3xE2YsFpJ5eG97MZ5YwE/5awF1feu76njGpOSj0kbA+03ZDSi7Y1PqlrAUIaMmYm44BEHaoW6J q+Cs0FSmiaV+RuVe7hYkRzfRRD/hzXZ9SJ9UIAjiCXWygBJgWGtJMveQRp84dVQKHTxDEtc0kL7
 cVmNMB06KWbfU4HiWgvysui6WHJfdTzHMuna6JBj0MRRSpIac5L+PG5Zb94LIhd5HfBC1fPz
X-Proofpoint-ORIG-GUID: zQuP73n3wxLvxjO3YBhD0q4fr-eRXa9S
X-Authority-Analysis: v=2.4 cv=UflRSLSN c=1 sm=1 tr=0 ts=68372425 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=icPLxu_JyErhSN4pVxMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280127

On Wed May 28, 2025 at 11:13 AM CEST, Janosch Frank wrote:
> We should get a new page after we discarded the page.
> So let's check for that.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/diag10.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/s390x/diag10.c b/s390x/diag10.c
> index 00725f58..b68481ad 100644
> --- a/s390x/diag10.c
> +++ b/s390x/diag10.c
> @@ -94,6 +94,16 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
> =20
> +static void test_content(void)
> +{
> +	report_prefix_push("content");
> +	memset((void *)page0, 0x42, PAGE_SIZE);
> +	memset((void *)page1, 0, PAGE_SIZE);
> +	diag10(page0, page0);
> +	report(!memcmp((void *)page0, (void *)page1, PAGE_SIZE), "Page cleared"=
);
> +	report_prefix_pop();
> +}

Would be nice to test that we don't clear too much, but this is clearly bet=
ter
than what we had before so:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

