Return-Path: <kvm+bounces-23041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24473945E68
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A16F4284EDE
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9B01E4855;
	Fri,  2 Aug 2024 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cOrRXp8O"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE3D14B09F;
	Fri,  2 Aug 2024 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604289; cv=none; b=ap3pf9xWT7KLe43+85gGVBded6FfWz6yq/l5Ps3PRK4+C/CmZCisOsxHUSStSUmsr08TCQH4m0VaLqRZabdz9jDmJaperibR2JX1GVkQKv10w+2BszzZDGM7oN84UqjqPKOLFm9lnW5t6JQMWyBxPKaF6Bzzdd4S5e1cKUjZ+gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604289; c=relaxed/simple;
	bh=caP1ibl0Zvsa2n6kNCMBMi9Foope+/rT+Q9LahFpIF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q56TqjnYv3/j6/oUdTTw9i2NE8CFP5dflpW/Ec1SLeaSIJmKzs4wYscj2A7RVl3jkO1aN8/5hHIKKeukAG8hWI32KRNN1hEWokc04o60EX5KhShyIEgJZGaAzXJGW23ywEffnQAB2PG0pEU0xs+PQWsPV78FgJ7z6LAh4Rgoc0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cOrRXp8O; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472CuADj005689;
	Fri, 2 Aug 2024 13:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=j
	Ia3YbowzVgCqbLSETwsfI70sjuOU78N5o218XYXPCw=; b=cOrRXp8OIRLbiegDh
	ORtjzlJeAEPbQkxuKUfZA5wudZWO5YwuDK2t3h+PbfbtakLW78WyQDBlU/IPSbz/
	1ZW+oudIFoxNRrKJdvE0hkeZ6G8rDwfmwQW2hxj4ZnFp7FUdYbYdDb9e8vPn3fSa
	JIA+lVmJu7MjCJSuuSigtSEC/tNOM3m4yt3VcPuLJ+GvyoGcyKSmJ7TJ01qT1uAs
	uNPmrSfgwzZWrBDrL2exsv3eWCrl9NRRoTQhYFVWplHeffnGzBTp9I8jty793EWS
	YNM8dloRoFvW5Umfdjt2Nh5Qjq64ss5ZB6j5VNpCSmGzmFa0dsjcpIf9621aLAf8
	jX+Ag==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ru3grp8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 13:11:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 472BOYkD011295;
	Fri, 2 Aug 2024 13:11:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40ncqn78jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 13:11:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 472DBHF951773854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Aug 2024 13:11:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF09220040;
	Fri,  2 Aug 2024 13:11:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E6A420049;
	Fri,  2 Aug 2024 13:11:17 +0000 (GMT)
Received: from [9.152.224.131] (unknown [9.152.224.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Aug 2024 13:11:17 +0000 (GMT)
Message-ID: <f0ec44d4-2169-477c-941a-b08e28a4ded2@de.ibm.com>
Date: Fri, 2 Aug 2024 15:11:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] s390/uv: Panic if the security of the system
 cannot be guaranteed.
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
References: <20240801112548.85303-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20240801112548.85303-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rzQ4YkLu9AMfRsJw_YcI1qCeXt64r5VL
X-Proofpoint-ORIG-GUID: rzQ4YkLu9AMfRsJw_YcI1qCeXt64r5VL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_08,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=507 malwarescore=0 mlxscore=0 clxscore=1011 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408020088



Am 01.08.24 um 13:25 schrieb Claudio Imbrenda:
> The return value uv_set_shared() and uv_remove_shared() (which are
> wrappers around the share() function) is not always checked. The system
> integrity of a protected guest depends on the Share and Unshare UVCs
> being successful. This means that any caller that fails to check the
> return value will compromise the security of the protected guest.
> 
> No code path that would lead to such violation of the security
> guarantees is currently exercised, since all the areas that are shared
> never get unshared during the lifetime of the system. This might
> change and become an issue in the future.
> 
> The Share and Unshare UVCs can only fail in case of hypervisor
> misbehaviour (either a bug or malicious behaviour). In such cases there
> is no reasonable way forward, and the system needs to panic.
> 
> This patch replaces the return at the end of the share() function with
> a panic, to guarantee system integrity.
> 
> Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0b5f8f3e84f1..153d93468b77 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -441,7 +441,10 @@ static inline int share(unsigned long addr, u16 cmd)
>   
>   	if (!uv_call(0, (u64)&uvcb))
>   		return 0;
> -	return -EINVAL;
> +	pr_err("%s UVC failed (rc: 0x%x, rrc: 0x%x), possible hypervisor bug.\n",
> +	       uvcb.header.cmd == UVC_CMD_SET_SHARED_ACCESS ? "Share" : "Unshare",
> +	       uvcb.header.rc, uvcb.header.rrc);
> +	panic("System security cannot be guaranteed unless the system panics now.\n");
>   }
>   
>   /*

