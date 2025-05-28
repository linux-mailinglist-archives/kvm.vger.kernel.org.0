Return-Path: <kvm+bounces-47864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A8FAC6629
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C22D1BC320B
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15FD27814C;
	Wed, 28 May 2025 09:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Lt2MYp0N"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9849F20B806;
	Wed, 28 May 2025 09:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748425342; cv=none; b=XaMe0mC+gUSYUl6uLwFQtvTIHs7WyINd2tngHcHY/SPDLFvj2mYUUMcgHmSC7+Fvx0OzRJiEy2hFKrS9vMcTNp/9UQtdQn6scOc3/MdtRxm7JahgyxuhbVlC1J/Lh/Onl2Ubzr12xZtmt6/VOVREg6flR67bFnYEqA4o/GF8Oz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748425342; c=relaxed/simple;
	bh=ubmhBTTSJ96i8Pq3nY3vnYj4fDuVrUwZvFqbuvoAuRE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXcVR/ihMHB+mmzwJv9Qirs6HWsosaF7pr3fz5QYds0AVWpkmxG+0VgC3d7W5lLGaB6Ut2ZLNGX8anuP6MYmWSwo3JSnVeX5FzAqIHm+yMNGtMO0wILJnTdolLQE5m+w1ofH6QAnZJSTlYNPeGo3aCxIezWassBkC0k9BjJRPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Lt2MYp0N; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S2JHfW017246;
	Wed, 28 May 2025 09:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0LqAah
	1v6nMJnyXaK+Q7i/okwyc8LQwBW9IFG/hrQL8=; b=Lt2MYp0NLW75wHAPAcVcpF
	BKSAccru8xD1ZdVASzRgCVudRW1VwpfnAsnOWuOtnATEkBVF2A5VnmvGNK28zxko
	MXh/wlusG/NrEI5PO/auuwDyx9tNUfIm9yGiQ5ECHHEeWY1Kq8YLqDuKoHbbrROt
	GFw6MhZYec3Tk00v9Gj5eJdQa7/lm26FZ4kJsX+SagpvTzAEcvFQSBPmEljas2rz
	lKCnurRdQRIpCPdVzLtxSZd8218cEkgsVUpsBHVni355p+yEJbwT+OKvJCIBTsRR
	Rt/Ibo2ftvqdQ9LqGzRMOkRuIjN9lJxzcE6JQmdYemHJuet1S+nvJ/s2rHLf7+dA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wgsgm0fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:42:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S65uT2016126;
	Wed, 28 May 2025 09:42:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46ureuf4ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:42:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9gDJu45089146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:42:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90D7E20040;
	Wed, 28 May 2025 09:42:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23CEB20043;
	Wed, 28 May 2025 09:42:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.56.81])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 28 May 2025 09:42:13 +0000 (GMT)
Date: Wed, 28 May 2025 11:42:07 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: diag10: Check page clear
Message-ID: <20250528114207.4808e8a6@p-imbrenda>
In-Reply-To: <20250528091412.19483-3-frankja@linux.ibm.com>
References: <20250528091412.19483-1-frankja@linux.ibm.com>
	<20250528091412.19483-3-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: UKJWpMj3gbgLUoxPS5lVlP2ufiwB_tWs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfX/J+22+sEXtMW NoYLbkEUnSmnouXaSmd680cFDnqGwmZxyxvynoUecW/1LL5cIzdLm9OyIaPN9QiVQC5zf90AngR TZcx2wrleCgiPOFqW5pQgPt9LH1oaIpNQvSYC5KUyf6+eetLvblHpwTIzCZGKDdLmI+7RZt8dwa
 Pvo5bI3zoTu1ZtTUfK8VcRmGwCrut1Np+w3Juyj29FB2xFiOeTAPF6uzGqDLcqAEv5eYymL7A91 MqybsXBlbc+BFEJDojeQ4EyepfOp7FtbeW1y2KsvmKJFSYI8UNhexHGbW4IHWp+W9rg8pV7UXFx 9y1sbqd4Z0JP2Etdu2aSjpLo4aQstBoZRNog66p7u1z5FP1dFFLOqhBJimjkohNHvn+2HZfoYft
 aFq3j8gho5wohqljW2HNH79xFiqJhKhWhG0D5ifWEtjt3yZIaSSrWeO3nrPbXlbV1JU8TRWh
X-Authority-Analysis: v=2.4 cv=bZRrUPPB c=1 sm=1 tr=0 ts=6836da79 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=n2lIeGq32Eqf8qbOsJUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: UKJWpMj3gbgLUoxPS5lVlP2ufiwB_tWs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

On Wed, 28 May 2025 09:13:50 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We should get a new page after we discarded the page.
> So let's check for that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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
>  
> +static void test_content(void)
> +{
> +	report_prefix_push("content");
> +	memset((void *)page0, 0x42, PAGE_SIZE);
> +	memset((void *)page1, 0, PAGE_SIZE);
> +	diag10(page0, page0);
> +	report(!memcmp((void *)page0, (void *)page1, PAGE_SIZE), "Page cleared");
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("diag10");
> @@ -110,6 +120,7 @@ int main(void)
>  	test_prefix();
>  	test_params();
>  	test_priv();
> +	test_content();
>  
>  out:
>  	report_prefix_pop();


