Return-Path: <kvm+bounces-46688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B25EAB88B8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 144821BC119C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3980C1FCCEB;
	Thu, 15 May 2025 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pzqyLD5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0F71F8724;
	Thu, 15 May 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747317419; cv=none; b=Vi17HEHldnkixa4fpxBgcbbBc684nzFeAKaL8UdD0/QKZk1ezmUiDnTBieOt9zGR43Pnvgt/fnbmbZ63E+4NbsL6siFxNcF8PHtSgsYg4dSuHgUNapkgOlfzh6F1avHiNo5rQfthNAFuVLfP/sI0B0WUdwlkt1msG2PS77U1BSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747317419; c=relaxed/simple;
	bh=2nDDcWCR3N/EKcokAfj1m0YytBCSC2Ha6IQczrqfI+0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=CCYzqynQ3qOU/ZGKobJVXsJ8zRcgtDg8H+S9hfVMY/59F+UANPtEsuz9WjjfVVm7LCjUMN2cRyFzdhAlQSwDUCMwlg6Ivq6fVsaiBsPxiYGA42SkfCtBgQBZ/8cSR5DgvoiYUNqWAZD8MvSKoseLNRcNRVQzmtv1j76hJ0HIYh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pzqyLD5Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FCg7sT004932;
	Thu, 15 May 2025 13:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pr39dD
	2yVBnwoDwzLfmx1XI5RKAQ+i72fWH/VVZv6qA=; b=pzqyLD5YUX7cUFAZAu3x86
	kmlj40H6i/drvVeNzF6PGhK+tOm23/sgbOCjWddIHL/GSV+YbODx6KiBNyQBZqx8
	cZ85osZC2judbRbvBDU5PLSSZOykxIWlMl7hjO1zlHHEbR/HNQgLZECdQA+wSuYs
	QtyLQIPXpst6JwJNPcybMuKn3dHkgTk2Z7Ld1NPNJ78dj74bY4PTEvPNQLJg3cxB
	4dcM9vTMU6dGA7fm2aK6BV7xbeDf5rRmy67up/QV1EdaJFDBxMviHnzbumACbe71
	PwnGh6tJvkWZWoljCJUU+9QXBBxKsK22Bdg9Frx/yuwoig7RrPJcX+Qidwyg5nnA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46navu28q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:56:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FAasY2021809;
	Thu, 15 May 2025 13:56:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpthej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:56:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FDunCL56557852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 13:56:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7C3E200DA;
	Thu, 15 May 2025 13:56:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90620200D9;
	Thu, 15 May 2025 13:56:49 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 13:56:49 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 May 2025 15:56:44 +0200
Message-Id: <D9WSBQ41MJ2M.1KMCYVAHP1JFF@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/5] s390: remove unneeded includes
X-Mailer: aerc 0.20.1
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
 <20250514163855.124471-2-imbrenda@linux.ibm.com>
In-Reply-To: <20250514163855.124471-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A6hc7nsUSQuFPFwMmveKVF8tce6Uo9XM
X-Authority-Analysis: v=2.4 cv=XK4wSRhE c=1 sm=1 tr=0 ts=6825f2a7 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=G8SUIm368mfTC3sML14A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: A6hc7nsUSQuFPFwMmveKVF8tce6Uo9XM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEzNCBTYWx0ZWRfX6tndEkttQfgL OCjj1NhC5HVRqugOBJYp2pdWm3RGwgbQz504zR2fM6P4e47NTShALW4FPsLL6TwIjvdJ8m+OAhd cxGVrhabyfVJR6DmoT1R0rnGVzQrLLTyo7kcvOO4qwfF1euPIBMHu1xSLoE23cHYDtvU0wHC1+h
 +Qll/SfqEgw/GnOBv5+ZX92NIPWWkfOVcizUCg1QSgV5Er1INq+nwAJPw3zcYh4vsJm87iSt6eL myrfq+DgR9GWHSr5jW90NaayM78NooKi21yzKZZtmqxkfH5RScC8YdwTrjZu5jY0bL3nxz4sObf hOSsTvNVxA2P/AGvA/7CJPddgSS+Xzxe2Bgp/TCq/bxhojjCq14LUhNRgP33kcluyOOpohOprwh
 VUYfE78ZrZBKyVGA4bWUFTYSNNN6JreoUWkcsd6Y+IzLYYM1zuCnMmHQTTetNQ30GPzFUEur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_06,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150134

You added one unnecessary import to arch/s390/kvm/intercept.c

With that removed:
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


On Wed May 14, 2025 at 6:38 PM CEST, Claudio Imbrenda wrote:
> Many files don't need to include asm/tlb.h or asm/gmap.h.
> On the other hand, asm/tlb.h does need to include asm/gmap.h.
>
> Remove all unneeded includes so that asm/tlb.h is not directly used by
> s390 arch code anymore. Remove asm/gmap.h from a few other files as
> well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/tlb.h | 1 +
>  arch/s390/include/asm/uv.h  | 1 -
>  arch/s390/kvm/intercept.c   | 1 +
>  arch/s390/mm/fault.c        | 1 -
>  arch/s390/mm/gmap.c         | 1 -
>  arch/s390/mm/init.c         | 1 -
>  arch/s390/mm/pgalloc.c      | 2 --
>  arch/s390/mm/pgtable.c      | 1 -
>  8 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> index f20601995bb0..56d5f9e0eb2e 100644
> --- a/arch/s390/include/asm/tlb.h
> +++ b/arch/s390/include/asm/tlb.h
> @@ -36,6 +36,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_=
gather *tlb,
> =20
>  #include <asm/tlbflush.h>
>  #include <asm-generic/tlb.h>
> +#include <asm/gmap.h>
> =20
>  /*
>   * Release the page cache reference for a pte removed by
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 46fb0ef6f984..eeb2db4783e6 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -16,7 +16,6 @@
>  #include <linux/bug.h>
>  #include <linux/sched.h>
>  #include <asm/page.h>
> -#include <asm/gmap.h>
>  #include <asm/asm.h>
> =20
>  #define UVC_CC_OK	0
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a06a000f196c..b4834bd4d216 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -16,6 +16,7 @@
>  #include <asm/irq.h>
>  #include <asm/sysinfo.h>
>  #include <asm/uv.h>
> +#include <asm/gmap.h>

This import is not needed.

> =20
>  #include "kvm-s390.h"
>  #include "gaccess.h"
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index da84ff6770de..3829521450dd 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -40,7 +40,6 @@
>  #include <asm/ptrace.h>
>  #include <asm/fault.h>
>  #include <asm/diag.h>
> -#include <asm/gmap.h>
>  #include <asm/irq.h>
>  #include <asm/facility.h>
>  #include <asm/uv.h>
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index a94bd4870c65..4869555ff403 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -24,7 +24,6 @@
>  #include <asm/machine.h>
>  #include <asm/gmap.h>
>  #include <asm/page.h>
> -#include <asm/tlb.h>
> =20
>  /*
>   * The address is saved in a radix tree directly; NULL would be ambiguou=
s,
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index afa085e8186c..074bf4fb4ce2 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -40,7 +40,6 @@
>  #include <asm/kfence.h>
>  #include <asm/dma.h>
>  #include <asm/abs_lowcore.h>
> -#include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/sections.h>
>  #include <asm/sclp.h>
> diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
> index e3a6f8ae156c..ddab36875370 100644
> --- a/arch/s390/mm/pgalloc.c
> +++ b/arch/s390/mm/pgalloc.c
> @@ -12,8 +12,6 @@
>  #include <asm/mmu_context.h>
>  #include <asm/page-states.h>
>  #include <asm/pgalloc.h>
> -#include <asm/gmap.h>
> -#include <asm/tlb.h>
>  #include <asm/tlbflush.h>
> =20
>  unsigned long *crst_table_alloc(struct mm_struct *mm)
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 9901934284ec..7df70cd8f739 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -20,7 +20,6 @@
>  #include <linux/ksm.h>
>  #include <linux/mman.h>
> =20
> -#include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
>  #include <asm/page-states.h>


