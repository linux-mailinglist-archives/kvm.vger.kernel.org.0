Return-Path: <kvm+bounces-23036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B5E945DF3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB34A1C21F23
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E1E1E3CC4;
	Fri,  2 Aug 2024 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fk1du2fL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244561E3CA8;
	Fri,  2 Aug 2024 12:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722602428; cv=none; b=d3WqMmbta5+BdUmL7VtfvcSAa1RDtUhZ/gAmwLZKhxAqWs8cgXeG8SdCwreH9VYJVfc/WP6RZ9D0E+VAgakJ2QOAWx3CKqxKGWmxnr0B0hPyavR0CSPV7l2UBoeHa06l8SUw4kP9NJkewuouU1q1d3vY8S+DNnLnRniVtFXex4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722602428; c=relaxed/simple;
	bh=U8MMlzk89Z3SW73G9T94CJ47z505jMvWq8xQMCAPf74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdgfLzREnAsji3ZnJibFN1z9e544A0yaqPZEOR/3q4/6J8+PiL+X3iEs6hBjDzJJP+m3dPsbBZ4pq6mT/oUdkV4fMO/jaHtpprFIbUFbY45ELt12Diie8H6dCosPfIlPhfGuOXfD5HHQScEb9vQXNKJgmR/JI92Lb2glafEIdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fk1du2fL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472ASgnQ012379;
	Fri, 2 Aug 2024 12:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=T
	avorW6hh6S+jBvUAKi6eOdaXlh3TmdakA8/GiObTws=; b=fk1du2fLS4vIMIAGm
	bEmMAEfbRlkGOnmdX/4zFqQE0wGjVG8q5BWE8I5VhHqYfwSpPxjl3ufdJDVPCv84
	LA7SpJJ73HMjLxayhmhw2DfTsYjSmwCJrNcBEvwsP8Z7gdImrmQUm539gMfrx2Ir
	t+8VxXYQ3JLNr53E5WPwIOY14ywvpTctCPCc0qU3GzLHxVjOoZCqwuJb99Q/Q9eS
	EDHJ7q1km3QTsh6cGZu7aH+/5JZdTWOQYkhL7HFkHjXQl/iR0l8udqnp9+/HOqKI
	YQjy7ZVlnBtqF2RL6fS+LGo33WWfk0rMj+Akdku/BZXbik5uNL0WW2PpDGlN8XBA
	Ef3hA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40rwqw88m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 12:40:25 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 472A02NZ007682;
	Fri, 2 Aug 2024 12:40:24 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40nb7uqfpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 12:40:24 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 472CeKs946530898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Aug 2024 12:40:22 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D509758059;
	Fri,  2 Aug 2024 12:40:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B80FD58043;
	Fri,  2 Aug 2024 12:40:18 +0000 (GMT)
Received: from [9.179.14.7] (unknown [9.179.14.7])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Aug 2024 12:40:18 +0000 (GMT)
Message-ID: <4d5d5368-88c1-4eff-b0fa-8b0e47957b89@linux.ibm.com>
Date: Fri, 2 Aug 2024 14:40:17 +0200
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
        agordeev@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
References: <20240801112548.85303-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20240801112548.85303-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7mQCUslHwYU6ZCxA-yA4MLQMPYoXnLbl
X-Proofpoint-ORIG-GUID: 7mQCUslHwYU6ZCxA-yA4MLQMPYoXnLbl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_08,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1011 priorityscore=1501 malwarescore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=580 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408020084



On 8/1/24 1:25 PM, Claudio Imbrenda wrote:
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
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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

