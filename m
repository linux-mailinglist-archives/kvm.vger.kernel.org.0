Return-Path: <kvm+bounces-8247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F1E84CEC6
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 17:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99C0F2815F1
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12637FBD4;
	Wed,  7 Feb 2024 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IsrtsvJY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632EB7F7D2;
	Wed,  7 Feb 2024 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707322847; cv=none; b=PLglMj3egxjydtRgN+nF1m7HCEkXrxwYEBdWpOydCNODSKbw4E66KgAl2evDoK5Rokkpvvy0szNu7WKPfN65oiSG4fv6S28R2q73ErX1Kf5plsMupbqEOjk/pBMVcm7u5mAAj9fmHvTZIhWHmDzPbIqK3ocCDDSekHG2jNWnC9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707322847; c=relaxed/simple;
	bh=jyUpfru5yzyAI3WdmCD9985N1CruJpNBVQkVcdDxoxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDMSPCzvxmXnNtQ883S7n1cXUxDIZzfXdJxjlMN5auy3zoCKf1n/C3/rsms/mY782DRn8svglU8b9S+BV3nos4lHp3bLaWUTFE6KuMXTaE/VlNUW+/MIeC7zXSFL/j0olbOuwCpwceOmKTOAYUcPcPK3IzQW+jUHixZOwzrJ1yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IsrtsvJY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 417FTiKE018472;
	Wed, 7 Feb 2024 16:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JES2jhGp1yCMmmhC3WF0i/hZwneuKbQBl6nP710BJ1c=;
 b=IsrtsvJYGRc3M30uQ/5C0931XYQQO7OA5WUgbwd7mzGikfthWN4jWk3K8Z2Az4x44J9v
 IeuoCzyHxhXkwS0bjHqDCidOLPmP1g08CO/q2/Pa5qR6sIgYG0N2iPKRZhz/GODIlefY
 6GmkQ95ee9MFufGTX/yvejJyt7RbxvSpCdM1DkvNTaXo2FWBbFja3IvA+lHrTnNkCZR1
 EsaJj9k5cw3IOuH68mWLwoqRTehDajF5IpGWJoO+jpBP1LK47fpJKAYgaKmsG3tM6Ra0
 7VS+PxdALXNCU4SUsYf2bG4RZpcBwtO96s5qTbLrk+2ymCdk8uhj3Mb8HtMFISWFd36m gg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4cj6hfqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 16:20:43 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 417G1CMa028633;
	Wed, 7 Feb 2024 16:20:43 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4cj6hfpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 16:20:43 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 417G7StK020383;
	Wed, 7 Feb 2024 16:20:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w1ytt71k6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 16:20:42 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 417GKc6X27132520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Feb 2024 16:20:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 806DD2004D;
	Wed,  7 Feb 2024 16:20:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B58020049;
	Wed,  7 Feb 2024 16:20:38 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 Feb 2024 16:20:38 +0000 (GMT)
Message-ID: <044e0a7f-5718-455f-a22d-fa8dc7aaa69b@linux.ibm.com>
Date: Wed, 7 Feb 2024 17:20:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: only deliver the set service event bits
To: Eric Farman <farman@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20240205214300.1018522-1-farman@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240205214300.1018522-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rsWvlHnEGBViObLf7E0toZef-1FXjHxI
X-Proofpoint-ORIG-GUID: w4apOBmGCibCSIBStgzIUrHidXbecFXh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-07_06,2024-02-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=869 priorityscore=1501
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070120



Am 05.02.24 um 22:43 schrieb Eric Farman:
> The SCLP driver code masks off the last two bits of the parameter [1]
> to determine if a read is required, but doesn't care about the
> contents of those bits. Meanwhile, the KVM code that delivers
> event interrupts masks off those two bits but sends both to the
> guest, even if only one was specified by userspace [2].
> 
> This works for the driver code, but it means any nuances of those
> bits gets lost. Use the event pending mask as an actual mask, and
> only send the bit(s) that were specified in the pending interrupt.
> 
> [1] Linux: sclp_interrupt_handler() (drivers/s390/char/sclp.c:658)
> [2] QEMU: service_interrupt() (hw/s390x/sclp.c:360..363)
> 
> Fixes: 0890ddea1a90 ("KVM: s390: protvirt: Add SCLP interrupt handling")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

makes sense

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   arch/s390/kvm/interrupt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index fc4007cc067a..20e080e9150b 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1031,7 +1031,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
>   		return 0;
>   	}
>   	ext = fi->srv_signal;
> -	/* only clear the event bit */
> +	/* only clear the event bits */
>   	fi->srv_signal.ext_params &= ~SCCB_EVENT_PENDING;
>   	clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
>   	spin_unlock(&fi->lock);
> @@ -1041,7 +1041,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
>   	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
>   					 ext.ext_params, 0);
>   
> -	return write_sclp(vcpu, SCCB_EVENT_PENDING);
> +	return write_sclp(vcpu, ext.ext_params & SCCB_EVENT_PENDING);
>   }
>   
>   static int __must_check __deliver_pfault_done(struct kvm_vcpu *vcpu)

