Return-Path: <kvm+bounces-29049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7409A1BC9
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 09:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1092128A0D1
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 07:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE301CFED8;
	Thu, 17 Oct 2024 07:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UjTR6QP5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461DB18784A;
	Thu, 17 Oct 2024 07:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150636; cv=none; b=gLEp6VXWzrusGqTj7LxYdDH6BWWcTq3OE75vIXuYQwE+JA8Xb4LUL34BJ8Ar/sD+trW1ID6om12H6LPNah+TtOeQU56gjnbaBkotnv8wESdR/WTcPgVDiN8kKCWfgs6LdSXiP0afy8nRzC1nkqXQ1hHDdDEUvMz95fd+16FuiJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150636; c=relaxed/simple;
	bh=ULpWoA+MsrzVpR2MlRuFWV7zX9hHcTjhDUqYHtMGPMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M482eM+NgMkOotQMD3nCQpXRX0vmf490KA3a2ezXvAHdPytqiznKJgA8QDXhPKa/d4U1CAX4jMeoXRX4I00R7hu6/tEpFQ2AowRf2OiQ5XR2rnZFjQXNmx3OSqJE0RserdSADQM/zG8KErjFuG6B1rtF7g6KWDIrsCCyxwoPIQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UjTR6QP5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H1tltB028414;
	Thu, 17 Oct 2024 07:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=CCockiiMIdzXFF10k9ecjz3T/PBTZF
	sqm9mtgI58+4o=; b=UjTR6QP5gdttKteJTjOOPX61PMn5doVH66+queNczgz/vK
	YOZb36GRkMUBNOrjzE8wt4kakW4grWrRi+8NFe9UwJFqGe8OzbS1y48PNu/uDu4Y
	FFf8XFchFn+bJ8MS5AgeqG4KS8K252VShEjBHc/sZobnNM+zRTIS6xioyVJWXHME
	gQPjwAun2y2bU2wABSIrWHGWktprvkSvDA2bDTid20KRK32jXYULZ8rcQ6eqtKum
	9toCtOb2X30ovGnILNh3+uuf+WM2y/VgQ9XH+IXXqJkdDkcpGtJo/wfGXrl5ZqJv
	Egqgvz/Rd3G+zEpZudT/lsspmRxWWycaWbHctrrw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd16cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 07:37:07 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49H7b6Bg020668;
	Thu, 17 Oct 2024 07:37:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd16c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 07:37:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49H6AHRq006401;
	Thu, 17 Oct 2024 07:37:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xkde73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 07:37:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49H7b06D18809164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 07:37:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 870CD2004B;
	Thu, 17 Oct 2024 07:37:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 804AE20040;
	Thu, 17 Oct 2024 07:36:59 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.26.155])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 17 Oct 2024 07:36:59 +0000 (GMT)
Date: Thu, 17 Oct 2024 09:36:58 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-5-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I8XjFklzuWznK3cD6E4X0sa9LCHD5Rtg
X-Proofpoint-GUID: bnb60nF_oPjDqifw1vM7LX54XpsdFO6s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 clxscore=1011 adultscore=0 priorityscore=1501 mlxlogscore=535
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410170048

On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:

Hi David!

> @@ -157,7 +189,9 @@ unsigned long detect_max_physmem_end(void)
>  {
>  	unsigned long max_physmem_end = 0;
>  
> -	if (!sclp_early_get_memsize(&max_physmem_end)) {
> +	if (!diag500_storage_limit(&max_physmem_end)) {
> +		physmem_info.info_source = MEM_DETECT_DIAG500_STOR_LIMIT;
> +	} else if (!sclp_early_get_memsize(&max_physmem_end)) {
>  		physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
>  	} else {
>  		max_physmem_end = search_mem_end();
> @@ -170,11 +204,17 @@ void detect_physmem_online_ranges(unsigned long max_physmem_end)
>  {
>  	if (!sclp_early_read_storage_info()) {
>  		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
> +		return;
>  	} else if (!diag260()) {
>  		physmem_info.info_source = MEM_DETECT_DIAG260;
> -	} else if (max_physmem_end) {
> -		add_physmem_online_range(0, max_physmem_end);
> +		return;
> +	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
> +		max_physmem_end = 0;
> +		if (!sclp_early_get_memsize(&max_physmem_end))
> +			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;

Why search_mem_end() is not tried in case sclp_early_get_memsize() failed?

>  	}
> +	if (max_physmem_end)
> +		add_physmem_online_range(0, max_physmem_end);
>  }
>  
>  void physmem_set_usable_limit(unsigned long limit)
> diff --git a/arch/s390/include/asm/physmem_info.h b/arch/s390/include/asm/physmem_info.h
> index f45cfc8bc233..51b68a43e195 100644
> --- a/arch/s390/include/asm/physmem_info.h
> +++ b/arch/s390/include/asm/physmem_info.h
> @@ -9,6 +9,7 @@ enum physmem_info_source {
>  	MEM_DETECT_NONE = 0,
>  	MEM_DETECT_SCLP_STOR_INFO,
>  	MEM_DETECT_DIAG260,
> +	MEM_DETECT_DIAG500_STOR_LIMIT,
>  	MEM_DETECT_SCLP_READ_INFO,
>  	MEM_DETECT_BIN_SEARCH
>  };
> @@ -107,6 +108,8 @@ static inline const char *get_physmem_info_source(void)
>  		return "sclp storage info";
>  	case MEM_DETECT_DIAG260:
>  		return "diag260";
> +	case MEM_DETECT_DIAG500_STOR_LIMIT:
> +		return "diag500 storage limit";

AFAIU you want to always override MEM_DETECT_DIAG500_STOR_LIMIT method
with an online memory detection method. In that case this code is dead.

>  	case MEM_DETECT_SCLP_READ_INFO:
>  		return "sclp read info";
>  	case MEM_DETECT_BIN_SEARCH:

Thanks!

