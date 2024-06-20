Return-Path: <kvm+bounces-20137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE21910E10
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36EC21F224F4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E4B1B3F2F;
	Thu, 20 Jun 2024 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tmoFFeuU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D251B3F04;
	Thu, 20 Jun 2024 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903195; cv=none; b=BvvoeRwlUPFXc5U6hwf8dRKNtpguuKu3vDB1DUWc1WcvVAISgJkySqfdKGa0YLw5MAwu3SXWjX9HKXegUSGCjAsD0VtM7zHoKH3H7Q3+JSHgMTUPucsvfx3wKSeI/hPOETuWxozSSxCo6svXG4fyC9EyZ951qN29SLtl6HcrAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903195; c=relaxed/simple;
	bh=D8GNszom3gfSinVxUUAd+HaAnGPLUQb3yGJik8CU6aY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NonFitNotTg6x7oVYoqBUBUEPeLO/xKdAJUjuYXgg4AF6WXzF4T5SsaXVjpDoSkjPDSkjvitCpx26/Q0ToONJ6H/QOj7cyU1FPKGFCCFwllp517p+TKkkFeHXdow3XpY+3KVRNk87bd+m4QFITUkt4p8EHEI2DtPNL6G3UPWT3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tmoFFeuU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KGaInX028217;
	Thu, 20 Jun 2024 17:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	63fApaAvxT9C25rFVU9vTgfVye3/NVOon9MKbMNaE1E=; b=tmoFFeuUXLn6r3jW
	hd4Sx8aIyDwZ2AX+AeaPBNMAIJ3rg1N/RN/r+ee5Rw6s6tFlz9abEQ7Qo3P8feNY
	Mhp0KcMZeyblS2JVSOf5BNY914sKngThWCy93ODKAGWh7CsIWONJVs923PXlXjgn
	EE+I6Eu7NR12n4wvaboRJxMgXlz3QVweNxj6rblc0sTL4uwhzDeKpozqiTzHZyL9
	l5KKEVmsPMEGE3JzH5K5qQTBEO8qTxCg/Seeu8V0OYmrNV3jZhCQKsL/UwsR5bQY
	yOpcTKGbin9sgg1xa7Hym9+l/q3qC38OcEPK/Yp59lcwqk5K4yfLEJN1SSu+4Rz6
	UiPhfQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp8jkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:29 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KH3KgO008037;
	Thu, 20 Jun 2024 17:06:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp8jkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KFPrd9019646;
	Thu, 20 Jun 2024 17:06:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysnp1rect-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KH6MV552888024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:06:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0EC520040;
	Thu, 20 Jun 2024 17:06:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A59320065;
	Thu, 20 Jun 2024 17:06:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:06:21 +0000 (GMT)
Date: Thu, 20 Jun 2024 18:41:25 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin
 <npiggin@gmail.com>, kvm@vger.kernel.org,
        David Hildenbrand
 <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth
 <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/7] s390x: Add sie_is_pv
Message-ID: <20240620184125.12a1d908@p-imbrenda>
In-Reply-To: <20240620141700.4124157-4-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-4-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M1sqy55d0kXvyYkrrlAHvGJweeQFMMr0
X-Proofpoint-ORIG-GUID: 6dBXVpTbaShXT7gHETfTiIxhzQvLhl8D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=949 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200122

On Thu, 20 Jun 2024 16:16:56 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Add a function to check if a guest VM is currently running protected.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.h | 6 ++++++
>  lib/s390x/sie.c | 4 ++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index c1724cf2..53cd767f 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -281,6 +281,12 @@ void sie_expect_validity(struct vm *vm);
>  uint16_t sie_get_validity(struct vm *vm);
>  void sie_check_validity(struct vm *vm, uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
> +
> +static inline bool sie_is_pv(struct vm *vm)
> +{
> +	return vm->sblk->sdf == 2;
> +}
> +
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
>  void sie_guest_destroy(struct vm *vm);
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 40936bd2..0fa915cf 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -59,7 +59,7 @@ void sie(struct vm *vm)
>  	/* When a pgm int code is set, we'll never enter SIE below. */
>  	assert(!read_pgm_int_code());
>  
> -	if (vm->sblk->sdf == 2)
> +	if (sie_is_pv(vm))
>  		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
>  		       sizeof(vm->save_area.guest.grs));
>  
> @@ -98,7 +98,7 @@ void sie(struct vm *vm)
>  	/* restore the old CR 13 */
>  	lctlg(13, old_cr13);
>  
> -	if (vm->sblk->sdf == 2)
> +	if (sie_is_pv(vm))
>  		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
>  		       sizeof(vm->save_area.guest.grs));
>  }


