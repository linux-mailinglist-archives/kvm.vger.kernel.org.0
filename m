Return-Path: <kvm+bounces-32431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B02EF9D8538
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75A62286483
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85270194AD5;
	Mon, 25 Nov 2024 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="quRr04JF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8736C;
	Mon, 25 Nov 2024 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732536989; cv=none; b=GKXiKx/0GMuWIXmQrchDgZ+0khEItb9Rq0svMzvDnKwf6T/77qnPRHX+ua+gUXm7J1wBQUt6mJ3l1LbU9aSjSgzn2WFvH86zLNjXALQzgQjQrK6CwGrugKX16jVQXjkkjWpbZ6klZKJznccd0Ae6uXaqpYl9H50ouQ7P6L0c5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732536989; c=relaxed/simple;
	bh=CddVCt6X3oZZOXUXm3Ro9R0niwq+cgguOVz8k5r1+Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=br1zKmJV8D9xdsyr4G+jnrIUcjG3gi0pgySH/CmGXsWj6Xp+m/+mgOKHzAFIsuDVU6jPLFkLhsWmVOd3YwAhcFVm2KIHyziOFWMHz0+EpGmpI9cRCQKpue0HNlbO8Sew1mITbJsD6p/O83Hox2J9dR1YFYQV8WgP1K4suyGrAng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=quRr04JF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APAJkFS022178;
	Mon, 25 Nov 2024 12:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qS1k0n
	LO9bIsIEXtYxH5+TGXz6QMQV7zowJXOZlda7w=; b=quRr04JFqkOYeqxGWSNG9B
	+NQyJ6Y3OZK0tLKETuhjtDuKEr8CASdbYBdbHZngXMaT4V+CbP3jozYn7eP9Qd/O
	moL1zmWJpulQUtIrEqZ2/1IuOxotwNe8eT9N+ivmoL5MF4FokohcMLJh7xmj627W
	VulEFOJ2MgkOPM/YUrIDXvskAsporeNdF0MRIob0uUleQOFqib8gL2NmfOTPV5jP
	SmsrVJwPfqpirGrRh9Uu2ifPkWmqy7zD2JLxq7m+BDIuL8P8zVfYAApAgmMciGkc
	4k8vwgXcIwf9uh7cORMQy/gwKYyqjA0rJvQXFfULgU7FGs5orD7xQRrnT4yP1IbA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386n88tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:16:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP50CK2002590;
	Mon, 25 Nov 2024 12:16:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmafmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:16:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APCGKgV55443916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 12:16:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6906920043;
	Mon, 25 Nov 2024 12:16:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8716E2004B;
	Mon, 25 Nov 2024 12:16:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 12:16:19 +0000 (GMT)
Date: Mon, 25 Nov 2024 13:16:17 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: s390: Remove one byte cmpxchg() usage
Message-ID: <20241125131617.13be742d@p-imbrenda>
In-Reply-To: <20241125115039.1809353-3-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
	<20241125115039.1809353-3-hca@linux.ibm.com>
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
X-Proofpoint-GUID: Lp7lmMxM1hkBQ25r7tmmnYhlYQK6AKBJ
X-Proofpoint-ORIG-GUID: Lp7lmMxM1hkBQ25r7tmmnYhlYQK6AKBJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=933 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411250103

On Mon, 25 Nov 2024 12:50:38 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> Within sca_clear_ext_call() cmpxchg() is used to clear one or two bytes
> (depending on sca format). The cmpxchg() calls are not supposed to fail; if
> so that would be a bug. Given that cmpxchg() usage on one and two byte
> areas generates very inefficient code, replace them with block concurrent
> WRITE_ONCE() calls, and remove the WARN_ON().
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index eff69018cbeb..3fd21037479f 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -118,8 +118,6 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  
>  static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  {
> -	int rc, expect;
> -
>  	if (!kvm_s390_use_sca_entries())
>  		return;
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
> @@ -128,23 +126,16 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  		struct esca_block *sca = vcpu->kvm->arch.sca;
>  		union esca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl old;
>  
> -		old = READ_ONCE(*sigp_ctrl);
> -		expect = old.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
> +		WRITE_ONCE(sigp_ctrl->value, 9);

that's supposed to be a 0, right?

>  	} else {
>  		struct bsca_block *sca = vcpu->kvm->arch.sca;
>  		union bsca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl old;
>  
> -		old = READ_ONCE(*sigp_ctrl);
> -		expect = old.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
> +		WRITE_ONCE(sigp_ctrl->value, 0);
>  	}
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
> -	WARN_ON(rc != expect); /* cannot clear? */
>  }
>  
>  int psw_extint_disabled(struct kvm_vcpu *vcpu)


