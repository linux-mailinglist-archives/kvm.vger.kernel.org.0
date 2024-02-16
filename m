Return-Path: <kvm+bounces-8906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2123B8585FE
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 20:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 572331C212B8
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B14D135A64;
	Fri, 16 Feb 2024 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HYRKv2rr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95BA149DF2;
	Fri, 16 Feb 2024 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708110492; cv=none; b=ueD90etpaUO1N5k9lWJeuxF72RO14pNcJ5elroWFSeIOzKauGV3g3eikq0Si3UhYA0JSJE9X3wEfHAL1+B2lnB/xTu6Do/gD5yFSNyaxZ0taJbo6oOKaOAjoFRkMC3XvjBD1LLsTB4TLa6UQVSXJnNaL3+tLSCJ9GrZ9vHDnKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708110492; c=relaxed/simple;
	bh=1Lzk/qLUqo85syLXWWX90eY+tE6yR2Lqoi9ZQhJpHb4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8Co74qOruZPvHkoSu+0+9eiYXXtVSUpzv3lm49utMKq23x8gDcjG5cmp7HBvL+vKkbnjAFvLn9pREX2KTG09baWcJA3p3RBipHhz1FQbXkCp57LSN+fbU+wuAtHA9HQgZt6RpFXKSf155cr/Rf04gRbSCnFmI0/vjWEpIyfV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HYRKv2rr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GJ0nPP024522;
	Fri, 16 Feb 2024 19:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KGQChMAbXdLKziD1hj/y+lLvgF4ERGCjgxQfyeNgNsw=;
 b=HYRKv2rrBNqZCrpmoMRPO81jYmKughPI7C6i6OKb9OW0/CKothjca1B8Kt5ZQcwZ1O3H
 KurS3j96oYP0/Apsc0WSao8bKWxtf/ixm3k+Ifapukz4wXCQkwHbGVl4DOmCsiQN2+tP
 pcrHqs/8xqRrqtHkz5iZlS+QQfOJjS2HaZmG8WEzD4EPERbDhIHqASYDs+Xw8wvOlx7i
 NwoOrUcRIE6PQC2lzU3famscqb7sFKYStMd0x7YhT88s95+k8mQO5P5eA5JrZCN5k3u0
 VOkHRHQnwFrVbBPCp9tNN1PKBIQXmTVMyQj+cxZ12UTYhFjhVwgHkxxib5RKzssdqKuL 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wacst8vu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Feb 2024 19:08:09 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41GJ12jq025827;
	Fri, 16 Feb 2024 19:08:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wacst8vts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Feb 2024 19:08:09 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41GJ1pVQ016184;
	Fri, 16 Feb 2024 19:08:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w6myn55dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Feb 2024 19:08:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41GJ83iw15794922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Feb 2024 19:08:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 042742004F;
	Fri, 16 Feb 2024 19:08:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 911BD2004E;
	Fri, 16 Feb 2024 19:08:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.26.169])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 16 Feb 2024 19:08:02 +0000 (GMT)
Date: Fri, 16 Feb 2024 20:08:01 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico
 =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        linux-s390@vger.kernel.org, David
 Hildenbrand <david@redhat.com>,
        Jan Richter <jarichte@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x/snippets/c/sie-dat: Fix compiler
 warning with GCC 11.2
Message-ID: <20240216200801.7be160d1@p-imbrenda>
In-Reply-To: <20240216190048.83801-1-thuth@redhat.com>
References: <20240216190048.83801-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DERDqV-VYFQAjyUWD5T9PsMd8N0yVJdk
X-Proofpoint-GUID: fQJFAT8YBTkdQAB5uZ8z3ZqeTxeGb42X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_18,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402160149

On Fri, 16 Feb 2024 20:00:48 +0100
Thomas Huth <thuth@redhat.com> wrote:

> GCC 11.2.1 from RHEL 9.0 complains:
>=20
>  s390x/snippets/c/sie-dat.c: In function =E2=80=98main=E2=80=99:
>  s390x/snippets/c/sie-dat.c:51:22: error: writing 1 byte into a region of=
 size 0 [-Werror=3Dstringop-overflow=3D]
>     51 |         *invalid_ptr =3D 42;
>        |         ~~~~~~~~~~~~~^~~~
>  cc1: all warnings being treated as errors
>=20
> Let's use the OPAQUE_PTR() macro here too, which we already used
> in other spots to fix similar -Wstringop-overflow warnings.
>=20
> Reported-by: Jan Richter <jarichte@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/c/sie-dat.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> index ecfcb60e..9d89801d 100644
> --- a/s390x/snippets/c/sie-dat.c
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -9,6 +9,7 @@
>   */
>  #include <libcflat.h>
>  #include <asm-generic/page.h>
> +#include <asm/mem.h>
>  #include "sie-dat.h"
> =20
>  static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute=
__((__aligned__(PAGE_SIZE)));
> @@ -47,7 +48,7 @@ int main(void)
>  	force_exit();
> =20
>  	/* the first unmapped address */
> -	invalid_ptr =3D (uint8_t *)(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
> +	invalid_ptr =3D OPAQUE_PTR(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
>  	*invalid_ptr =3D 42;
> =20
>  	/* indicate we've written the non-allowed page (should never get here) =
*/


