Return-Path: <kvm+bounces-39108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE02A44030
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60EA21887EC6
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A04F2690C4;
	Tue, 25 Feb 2025 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ilycD+hK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C0F20C01A;
	Tue, 25 Feb 2025 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740488897; cv=none; b=iUjEDpZPaiaNrxGFRF8tJ1x0ircsZpjs1JU1XbDRlsE14zqzFFD2+dHwsNVLYWJ1NOSDm3FKK0/s4ciaC5a4VHD1fVqVdBAr2jGY9l5hFjGxcQd7VCWwOMKFDiWlWdZ63PO4q6ik3nkeCkSjlYCaZPnpOY60Rgjpl2HxkUcdQJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740488897; c=relaxed/simple;
	bh=99rOgsYmtxJ2T5rqMM/Ztjfgx7KuJRuns+c60HqCCwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=olWutMrDs2K7tDoynzk8zwDYHsTog7J68t9d6tQQiEr/2dThExgvpn+brzbU32m1jfZMUSj66ZhODRpw9EUZ7EVamuH6d6UDjYidcqxe71dkz4XvpCIMh9Eo5oh4pXXFxCid36RaGtbDe0DG1UP+DFFxsRFcQnmDy/snbH/dIaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ilycD+hK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PBPWMs011423;
	Tue, 25 Feb 2025 13:08:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mBEFsS
	/88ZtLdQox7D5tTupoUIMxzZwHoC8VeKMOMIU=; b=ilycD+hKwrTyReIwhMYpcu
	uwmx9OmVvXoauqF3yjWEKDlA+bG8diBWONDjcXwM1ZxZdryjja38qiKS4CeAl/JU
	BDMziDt1jlxXQ2a4UFU4+jioLSrKSRHmqS8lU2uNUUizZ3yjT8eyfm/9w0ngSUDc
	uHTnnbfeByD4+xKJboqqtXiAYaJJhOTsZrgxDisivu/rUJONfUp08kSHz3pSZGIf
	9H6TQmK4p0FjNd0NRwUzvu6TwqAr1/a1UYK5rCXSJtC691jkOZE4p3ItM6WSubRw
	DpjTcy/9amdBs1X7qxpQOK/WBQ0jgKjB3ECTiwBn26+ed0hzy30A+SdHyVkVvlLw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4513x9tyjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 13:08:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51PAogif026961;
	Tue, 25 Feb 2025 13:08:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ytdkcvuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 13:08:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51PD854L58524128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 13:08:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E09C2004B;
	Tue, 25 Feb 2025 13:08:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E6C020043;
	Tue, 25 Feb 2025 13:08:05 +0000 (GMT)
Received: from [9.152.224.140] (unknown [9.152.224.140])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 13:08:05 +0000 (GMT)
Message-ID: <8d51c268-aef2-469d-bfd7-a269422803a3@linux.ibm.com>
Date: Tue, 25 Feb 2025 14:08:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: s390: Don't use %pK through tracepoints
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
 <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
From: Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W8k0KDZ0WjSHGxeYS2x6WirWGr2TKaWo
X-Proofpoint-GUID: W8k0KDZ0WjSHGxeYS2x6WirWGr2TKaWo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_04,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=748 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502100000 definitions=main-2502250090



On 17.02.25 14:13, Thomas Weißschuh wrote:
> Restricted pointers ("%pK") are not meant to be used through TP_format().
> It can unintentionally expose security sensitive, raw pointer values.
> 
> Use regular pointer formatting instead.
> 
> Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/kvm/trace-s390.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
> index 9ac92dbf680dbbe7703dd63945968b1cda46cf13..9e28f165c114caab99857ed3b53edc6ed5045dfa 100644
> --- a/arch/s390/kvm/trace-s390.h
> +++ b/arch/s390/kvm/trace-s390.h
> @@ -56,7 +56,7 @@ TRACE_EVENT(kvm_s390_create_vcpu,
>   		    __entry->sie_block = sie_block;
>   		    ),
>   
> -	    TP_printk("create cpu %d at 0x%pK, sie block at 0x%pK",
> +	    TP_printk("create cpu %d at 0x%p, sie block at 0x%p",
>   		      __entry->id, __entry->vcpu, __entry->sie_block)
>   	);
>   
> @@ -255,7 +255,7 @@ TRACE_EVENT(kvm_s390_enable_css,
>   		    __entry->kvm = kvm;
>   		    ),
>   
> -	    TP_printk("enabling channel I/O support (kvm @ %pK)\n",
> +	    TP_printk("enabling channel I/O support (kvm @ %p)\n",
>   		      __entry->kvm)
>   	);
>   
> 


