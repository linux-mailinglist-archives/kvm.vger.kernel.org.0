Return-Path: <kvm+bounces-27814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC6898DFF6
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 17:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23B73288B15
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 15:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D1E1D0DC4;
	Wed,  2 Oct 2024 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V/JUgAhr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676D51D0BAE;
	Wed,  2 Oct 2024 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884664; cv=none; b=N0aUGPrWV4OLhu1UptceEU5O/4j3K8j08XribYfY+svoDpmjx6aGH8nMSyyy47cCoC1xPqiyTNocjRYdgfUDeE68xpgtccC9dmyhDMh9UNNh/g+2a2g9RNPVsToq2rJjGO7utA01InE6q562XtB9+VEPIx8LqUYw86YGto6G6vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884664; c=relaxed/simple;
	bh=HFyoN1KB22kjcksERl9V5QekGNZ3SHOYyFOCdgKSE6I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LWT/jokUHYs1TaIT4nc4MfWx44x4wLahrnf6/eTTP5QyJiuc/NtOGx23/VoWdsVI7WIW+Fv+VSxMpMv7pZn4EbxAb/Ogi+yx3XNbDPTv04yhX6BYYGDI8EHoipp48kkku6sX/KlobthI4RIT96WQPD7vtSxA7HPLFNOfqAGcO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V/JUgAhr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492FsKij007576;
	Wed, 2 Oct 2024 15:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	IvUgEAPXlN8mmSnwURHqLu1CXZH/xygxVenqyXJdm3M=; b=V/JUgAhrOvaxmRA2
	OVh32PWpBdOqcxgr+/xixKSrEjp4OD6IyR1BPwv6Q6tYumRmdK7l4Pyn5l4mf9Z+
	QXCTf7eeQ+Smr/p5ElSZxzFe+StQB4bI5Gm16kU4sr9z42IVrNazozibx0Fg1kR4
	+qi+8Y4We2S6aBCc2MQde4COHCb0XMvDGq6zMFT7rOs/Yg8x+BWNBpqtgoycdPVo
	rF3xIQiU0pJOGmXRr8DdUu9cP3aF75rysWt4eJUQLMzTXN9gJ0Yq6sFOJl/1Artj
	PCgA8p3WS5Y+6dRGUrLGyOIqhH0MNrIJVjqwgxST556qHKCo6lgfPoyBjFpY7mjC
	0oflTQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42197t80p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:57:40 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492FudPf013835;
	Wed, 2 Oct 2024 15:57:40 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42197t80p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:57:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492FnwZQ007923;
	Wed, 2 Oct 2024 15:57:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xvgy3ah4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 15:57:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492FvZDI56689128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 15:57:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D3D92004B;
	Wed,  2 Oct 2024 15:57:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF01420043;
	Wed,  2 Oct 2024 15:57:34 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 15:57:34 +0000 (GMT)
Date: Wed, 2 Oct 2024 16:52:34 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: edat: move LC_SIZE to
 arch_def.h
Message-ID: <20241002165234.3cb737fd@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20241002141616.357618-2-nrb@linux.ibm.com>
References: <20241002141616.357618-1-nrb@linux.ibm.com>
	<20241002141616.357618-2-nrb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: jMkIUYrOyTewguZZpKCxgOfNWyIBbdn6
X-Proofpoint-GUID: 8XwiG88QYJmW0hShBz-SiyODPub01BsG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_15,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2410020114

On Wed,  2 Oct 2024 16:15:54 +0200
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


