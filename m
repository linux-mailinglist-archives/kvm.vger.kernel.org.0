Return-Path: <kvm+bounces-20593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E724291A293
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92E2E1F21F57
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B745139D0C;
	Thu, 27 Jun 2024 09:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pt3tz0Wm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD16D46421;
	Thu, 27 Jun 2024 09:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480251; cv=none; b=tAI5hG/WxM+Iq3uTE62MaqJ9WOeB3lw2LqzPYmZm6/DVwb5+IIjUaK5uGj8A/XFtXcJcKi61u3ALyf63WpTud72iFOU3ZFS5VeAiyzOJa3hJRn0eqoXjSOrZVWx7JyngsshHSCTMHH4pLK3hjEhyxV/5fF4yV3s4Ja9MH1JCnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480251; c=relaxed/simple;
	bh=xtjU2FimtAA9HrLZ6cbQWvBxDyoQ6viJ8ymsK2A/ZZk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t16+9t25evpTQdaofSDtV/1OLOoo3QnDuLi2P/b1k2ckgoR5FaX1GrYVVhi22jlRs+m7sdzqjivmYrW3jODRE3ulvzxwBsOUUbsQhPDevnPyU6w5HDSZGf9b7YuSEJhJFKRkbgRdPJqxAOBj5vlMPR3Z97q7v0sBEf+R0eIERtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pt3tz0Wm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R7pm6m024743;
	Thu, 27 Jun 2024 09:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	C/CRX3sYxMOxYYka3tJ5atBAouVEaB1rs5CcMhWpWhw=; b=pt3tz0Wmh2Z4vkIh
	B408p+jLLlCy7VDR7sPjk6WjgTbYfI7Aa6lI+zsyvDqBfdhclg4OBpB00CRK8W2u
	dw48eMZ33rIzgQJltIya18JEHrTfU0IYjMcpOvjhrGV+O/PnnUaSnE0/DHSXBMlK
	PmlPNus6Sfqc8ZBqOCDZBBBsJMp7JicXVHg5kKGzbSExWGi1hwvBUNyzotDnN6U+
	zukVYR3V54J7sDGkwfBf1gyH9RKhCO5TdZzyalg6LKq7ZzLkIbgFy+hvZx4utFB3
	so3cUIyrUTY2w1FIBbs0DnsfVnFX9p5G6TkhsKmwQtsSM/G1prne3euUlAP44Ycf
	oYmzyw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4010n2grbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:24:08 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45R9O8Lq007599;
	Thu, 27 Jun 2024 09:24:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4010n2grb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:24:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45R7GvZG008229;
	Thu, 27 Jun 2024 09:24:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9b124r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:24:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45R9O1CT47907166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 09:24:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2A2120049;
	Thu, 27 Jun 2024 09:24:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 663C520040;
	Thu, 27 Jun 2024 09:24:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 09:24:01 +0000 (GMT)
Date: Thu, 27 Jun 2024 11:23:59 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
Message-ID: <20240627112359.474cbd95@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240627090520.4667-1-borntraeger@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RNqeFIp_HIBuA50yU67dNkpB7H9oW7EF
X-Proofpoint-GUID: kFqQugn60dWNSHnyH0DZBPMzarV_ahh3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=821 malwarescore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406270070

On Thu, 27 Jun 2024 11:05:20 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> in rare cases, e.g. for injecting a machine check we do intercept all
> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> LPSWEY was added. KVM needs to handle that as well.
> 
> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

[...]

> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> +{
> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
> +
> +	/* The displacement is a 20bit _SIGNED_ value */
> +	if (disp1 & 0x80000)
> +		disp1+=0xfff00000;
> +
> +	if (ar)
> +		*ar = base1;
> +
> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
> +}
> +
>  static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
>  					      u64 *address1, u64 *address2,
>  					      u8 *ar_b1, u8 *ar_b2)
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1be19cc9d73c..1a49b89706f8 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_lpswey(struct kvm_vcpu *vcpu)
> +{
> +	psw_t new_psw;
> +	u64 addr;
> +	int rc;
> +	u8 ar;
> +
> +	vcpu->stat.instruction_lpswey++;
> +
> +	if (!test_kvm_facility(vcpu->kvm, 193))
> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +
> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
> +	if (addr & 7)
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> +	if (rc)
> +		return kvm_s390_inject_prog_cond(vcpu, rc);
> +
> +	vcpu->arch.sie_block->gpsw = new_psw;
> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	return 0;
> +}

looks quite straightforward, but you duplicated most of handle_lpswe.
it would probably be cleaner to abstract the "load psw" logic, and
convert handle_lpswe{,y} to be wrappers around it, something like

static int _handle_load_psw(struct kvm_vcpu *vcpu, unsigned long
pswaddr)

which can then contain the old code from the "if (addr & 7)" to the end
of the function.



I think it would look cleaner, but I don't have a super strong opinion
about it

