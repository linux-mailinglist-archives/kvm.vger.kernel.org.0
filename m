Return-Path: <kvm+bounces-48410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BB6ACE050
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FCC4189A6FF
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1CF290BD2;
	Wed,  4 Jun 2025 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PPeu9FpP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC2BE67;
	Wed,  4 Jun 2025 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749047529; cv=none; b=Ca3pnJeStk3PpNQ4xGbFlyh3CiXlMLqHddkW2/S8CqP7Cznb9vlzlZm9mIpcdxNtpHSZWigDh1O/MXYCiBXY1hVBIbR0/V8mpIkoDzRM1ngDXn5eKr3SO0zu/vH2t9cHk/eZTR5KS+nx1Uy3hk9mbYHTvCof7j2m6pH/6X7/3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749047529; c=relaxed/simple;
	bh=JG2zNqDlXJmA8nGR+UV80727OLA7TFr1cYIv/6hX7jA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9IkDV2q9mcklkug6okvm2y28U4r1Ou2zQniUf4mS9dxFkjY8fgtzivgb1E8w/Rsv+GAgWDLpNxqsh0gPEI7pHKniFDVYkh0qGpbAJ0XbSS0U6uzIYFYlbDIn4zvm2OL6KuHEAkBtfOmyRBuPUzL33WZcFZPuaKt5IkJnyiAdxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PPeu9FpP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554CsJC5022824;
	Wed, 4 Jun 2025 14:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RD36AZ
	6O+NyH2BE78jm6a6gNDHOVGjSKIZ6reJoX/1o=; b=PPeu9FpPjJIj/fIAgJ3UHn
	n0R58W7XEsDiWs+QPJtUCkvfqaX8NpA9s4ORbRPV1gHosytFE0GVvMByzDWTfssQ
	FWjbksDFDiyXRgim/CiRiLNI14/jjjm4WsZCLRPlbsY8gJFqulvwL7M8taeos0n/
	QVmjXgKw5D/3LVEFMIG0ZADQgCTdFQGOeRLj6eJqePp9eBVNBGJK1Y512Q/T21ip
	ucS2zVkLvYte6CJPi2PK4PuMW1j2R2bI+KgW8SuWK9oCkDZGNlVW3eHIDCrwVoVE
	VAdZLUQe/CiKoo7VsIx/r71+En/PWmO+UE77N3iDFsq376nfBekCefzNuEgSj0rA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyu8kw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 14:32:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554BSpfw019898;
	Wed, 4 Jun 2025 14:31:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3p05am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 14:31:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554EVnti57278920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 14:31:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AD6920043;
	Wed,  4 Jun 2025 14:31:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD00F20040;
	Wed,  4 Jun 2025 14:31:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Jun 2025 14:31:48 +0000 (GMT)
Date: Wed, 4 Jun 2025 16:31:46 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v5] KVM: s390: Use ESCA instead of BSCA at VM init
Message-ID: <20250604163146.21dd9334@p-imbrenda>
In-Reply-To: <20250603-rm-bsca-v5-1-f691288ada5c@linux.ibm.com>
References: <20250603-rm-bsca-v5-1-f691288ada5c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=684058e3 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=MXesND9z0vXNllD8JNgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDExMCBTYWx0ZWRfXxvFWW+YHv6jh UHTi9ST2j/vn91ta7u3isx+Q061dIZ9KeiKWa3MKg5OjZYqzb1B3+VUvPdf1u+i40t3UQ3G+m5L J+HqcR+FvS7EbJFZCdIrog0+xs0wHGE2pDPs17xpQR0a0ggA/RqtuJv4Ji/Il1a/x1dkMgkzXUH
 IZu0izi18xtwwRVHva5LMG+sGVQoXZJA1w/9RvyG1MHJHw08LaDK8XK7DSjmbSD97bz54ba01um sIQG38uvl62L6CmfXtuvFsgyo9+Xn4kzPx/M8QnREyWINcnLjIJXCcddD0NxrfQjOmT/PdX5bk7 XfHm0bW1qIa/n5pudU3DtLWtQWfTWoExIaRela0vu6/C6KUkpGxT8TErcYjSY9uS5+iboJjmsoz
 Zc6KbMBOtz6tJD29nPG+Wxxnx3pXoRrSkMDFIG00W+yM/ouBhWZgQD+98GqhF7nSLm1IEGU6
X-Proofpoint-GUID: PNhog90wIJtjMGESaqBdlfSOIyWbgpXY
X-Proofpoint-ORIG-GUID: PNhog90wIJtjMGESaqBdlfSOIyWbgpXY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=960
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040110

On Tue, 03 Jun 2025 18:35:42 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

[...]

> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 60c360c18690f6b94e8483dab2c25f016451204b..95a876ff7aca9c632c3e361275da6781ec070c07 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -51,21 +51,11 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
>  
>  	BUG_ON(!kvm_s390_use_sca_entries());
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl sigp_ctrl =
> -			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;

those variables can now be declared at the top of the function, no need
to declare them in the middle.

>  
> -		c = sigp_ctrl.c;
> -		scn = sigp_ctrl.scn;
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		union bsca_sigp_ctrl sigp_ctrl =
> -			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> -
> -		c = sigp_ctrl.c;
> -		scn = sigp_ctrl.scn;
> -	}
> +	c = sigp_ctrl.c;
> +	scn = sigp_ctrl.scn;
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  
>  	if (src_id)
> @@ -80,33 +70,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  
>  	BUG_ON(!kvm_s390_use_sca_entries());
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl new_val = {0}, old_val;
> -
> -		old_val = READ_ONCE(*sigp_ctrl);
> -		new_val.scn = src_id;
> -		new_val.c = 1;
> -		old_val.c = 0;
> -
> -		expect = old_val.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		union bsca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl new_val = {0}, old_val;
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> +	union esca_sigp_ctrl new_val = {0}, old_val;

..same here..

also, since you're touching this anyway, can you rewrite the
declaration so that the initialisation is at the end?

	union esca_sigp_ctrl old_val, new_val = {0};

>  
> -		old_val = READ_ONCE(*sigp_ctrl);
> -		new_val.scn = src_id;
> -		new_val.c = 1;
> -		old_val.c = 0;
> +	old_val = READ_ONCE(*sigp_ctrl);
> +	new_val.scn = src_id;
> +	new_val.c = 1;
> +	old_val.c = 0;
>  
> -		expect = old_val.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
> -	}
> +	expect = old_val.value;
> +	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  
>  	if (rc != expect) {
> @@ -123,19 +97,10 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  		return;
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;

..and here..

>  
> -		WRITE_ONCE(sigp_ctrl->value, 0);
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		union bsca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -
> -		WRITE_ONCE(sigp_ctrl->value, 0);
> -	}
> +	WRITE_ONCE(sigp_ctrl->value, 0);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  

[...]

> @@ -3573,105 +3548,23 @@ static void sca_add_vcpu(struct kvm_vcpu *vcpu)
>  		return;
>  	}
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		phys_addr_t sca_phys = virt_to_phys(sca);
> -
> -		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
> -		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> -		vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
> -		vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
> -		set_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		phys_addr_t sca_phys = virt_to_phys(sca);
> -
> -		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
> -		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> -		vcpu->arch.sie_block->scaol = sca_phys;
> -		set_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
> -	}
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	phys_addr_t sca_phys = virt_to_phys(sca);

..and here

> +
> +	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
> +	vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> +	vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
> +	set_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  

[...]



