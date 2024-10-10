Return-Path: <kvm+bounces-28412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CC9998327
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 352491C21476
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38C91BE85C;
	Thu, 10 Oct 2024 10:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BanpF6HT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760D618C03D;
	Thu, 10 Oct 2024 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728554937; cv=none; b=SfGireK6rBpsxwcrtIOBLi2w1OZWvN1I8advoZlp88M33BqYmgAFGC/pRXxeWR3X6arqqVLKtkdiKjUaNn2019h1MBwICXngzwOzf1tX9prurmyqPmbvHnPeu+AAIcKHip9c749Yd0f99TqITftVdyFnidMXZyN2cevshF1Amp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728554937; c=relaxed/simple;
	bh=qf7nU/89BlzHddkiR5Ah6NYm8BRaW0Dkwo9DPkOtPw8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKz/DM4LNV2lY0r0Fg8W6o3vZrdiuuOX/SnyyxhcUfgq1U9cTeADaEc1qNaGoJnM1txlSI4Vsc4ERXbVmSbahKirE3AoT2Sz9/mTYGvrN2tFN0jpDucEZFU4/6/hF6NmQxrK8zE9Mw1tZbvNms24vyi1lxJO5vd0QWXLxRUiDKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BanpF6HT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A3opwW009445;
	Thu, 10 Oct 2024 10:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	aL//amxx9YdMMLbbRrJYlGUmmzOy3nusublparPcj28=; b=BanpF6HTCG9dbVeu
	2dyS4pmAUwK9OFYDowEYBFPq9NQy89KoecZ9geHIvu6jU3+Z8Q/vZdcZ9RPr5+It
	7x83jYv/7rp9r+1tFDtHtW19o/dYrzF16Y1mbUBsJynsB6wpUonWdmSi81McSy6u
	wkYCpeHGhqcxxahQZ3zSLuXH1sJMKQigiAy7i7LI9dh0wZJoqXPB+xj/1fkabWtv
	2wVaFhYuX6k0CjV7nHRVP6bU5YVuYSlxktJWRKLK0xpmS0EWTt8bIsj/tG2+DirE
	pDBtLqd+bBdeRHyfCHITAAfK7TUaQWUbHPI2VLnJ99w8tdAbiFTKGOAbHWU7vm5e
	4WCiBQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4267cmsray-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 10:08:55 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49AA8suU023460;
	Thu, 10 Oct 2024 10:08:54 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4267cmsrau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 10:08:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A7M3CU022861;
	Thu, 10 Oct 2024 10:08:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 423jg16tnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 10:08:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49AA8oUA26608174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 10:08:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7280A20079;
	Thu, 10 Oct 2024 10:08:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13A3520078;
	Thu, 10 Oct 2024 10:08:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.66.107])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 10 Oct 2024 10:08:49 +0000 (GMT)
Date: Thu, 10 Oct 2024 12:07:29 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 1/2] s390x: edat: move LC_SIZE to
 arch_def.h
Message-ID: <20241010120729.74417d7a@p-imbrenda>
In-Reply-To: <20241010071228.565038-2-nrb@linux.ibm.com>
References: <20241010071228.565038-1-nrb@linux.ibm.com>
	<20241010071228.565038-2-nrb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: QrklSppjDOa8axqHyeByuKcZTde49OXz
X-Proofpoint-GUID: cOMhPNVn8eVEnlvnyEUbZc7sMcnJdEmG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_07,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410100065

On Thu, 10 Oct 2024 09:11:51 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
> tests as well, therefore move it to arch_def.h.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 1 +
>  s390x/edat.c             | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 745a33878de5..5574a45156a9 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -119,6 +119,7 @@ enum address_space {
>  
>  #define CTL2_GUARDED_STORAGE		(63 - 59)
>  
> +#define LC_SIZE	(2 * PAGE_SIZE)
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
>  	uint32_t	ext_int_param;			/* 0x0080 */
> diff --git a/s390x/edat.c b/s390x/edat.c
> index 16138397017c..e664b09d9633 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -17,7 +17,6 @@
>  
>  #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
>  
> -#define LC_SIZE	(2 * PAGE_SIZE)
>  #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
>  
>  static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));


