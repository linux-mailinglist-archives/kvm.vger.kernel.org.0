Return-Path: <kvm+bounces-64657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C711FC89C88
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A3AB34ED282
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F897327214;
	Wed, 26 Nov 2025 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PE4bVLYr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68531195B;
	Wed, 26 Nov 2025 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764160314; cv=none; b=r0A7sYhjM8Y5ZTREOU1NQOk7JWyVsDK+eFdReLHNwQuR7NNh+HfzKRr4/rHGmaXRbAgUIufj3rEslWaPFgXq25J5ZVsmlILZQ6ExsNwnUK/fbBs/I+W5rwrU0/+eMSTQdw1zr3ZDDDmajk0Z000LL6937qngRvcNvGPx92J/fDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764160314; c=relaxed/simple;
	bh=p+GBjkaSpWnHadaVNmoqW3obGAcDGpHJ5DR8QphrQjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ls4LN+HgG3sjNpxR9gMIM6VDOxdcXsGoO8vJcP4UrLnO7dwC7QLyghjlJINKgWmAs+jJeOBR/iu0oWwHjhxDm6/4KCb8TSkgwSC/mhMB5pEgXAcpMn83j8Wwj+Ck3R4ThWHV9MLwEX9vZtljxRBDK1OctNkC3o8lKdSqTz/uXLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PE4bVLYr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ2pVgR019516;
	Wed, 26 Nov 2025 12:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=X7isIC
	BlGRh2WtLNyBuUcYq9+0hXV9ozBuin60w+mWw=; b=PE4bVLYrp7jzRHgYNJ/5qm
	BsrbF5mJGrFeIlMBEGhm1iitXQQCewGHu6cgfhUo3O3Rm0DAQggHw79rDHlHBxdM
	pHSxcuvTYXlfWXHYNXqEjr32memGElN5G3uRJVW+hOQTxgHETocwVKcsJEeN70h0
	fSlsv3MGVsZxT6NtnxBmslW1Ev1aharUukn1EGOiFyd/8Try72BB0a51ePt0SuIi
	NSSd+SKhlzqnI9tfzRTNQXkHGnTZmwi+VRsGN/S3A0o+YMj/6B58JA1tBMcI8i5x
	/1EDRotFZHHcTr9Y9+3rdDFpepPXH1yNlui4Y5LiyIBhMWAyYRjKVm9JvKOkNE0A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w9m2v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 12:31:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQC7vUo016418;
	Wed, 26 Nov 2025 12:31:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aks0ka9d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 12:31:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQCVX1Q43057606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 12:31:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B71120040;
	Wed, 26 Nov 2025 12:31:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C2562004B;
	Wed, 26 Nov 2025 12:31:30 +0000 (GMT)
Received: from [9.111.66.134] (unknown [9.111.66.134])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 12:31:30 +0000 (GMT)
Message-ID: <6a717d9b-3771-41f2-9964-442fb6f68fb2@linux.ibm.com>
Date: Wed, 26 Nov 2025 13:31:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: s390: Enable and disable interrupts in entry
 code
To: Andrew Donnellan <ajd@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
References: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
 <20251126-s390-kvm-xfer-to-guest-work-v2-2-1b8767879235@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251126-s390-kvm-xfer-to-guest-work-v2-2-1b8767879235@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX6qZGY5Tc65O6
 lKKoMc+fLrGUPx7g969+lRiB8hWb0xGwVUbMHLWN8Dhzwnv5+GEJIWVpRwKyRULjunKsFc8kNKY
 wKB/0L0Mio/HzDCS5uS9F6FjqFec9zzGRwti3mZuZGPAARIXSiG830eZo8qGJMTLKRXM1V9vy8Z
 XPplbQEtmA/z3cWca+HwTQLkakJz96kvRz8Q9ZzTMU1CNj1oH8LvAQze+vTcrAAaHcWupyfwvIV
 ZxYObCbslgsa/ACnzfy1iuyFMTqmtMwTG9xXxXXWGCYvpkImdVBxyrfdDSbhik3Ol8VeQblccLe
 syGXZl9sRE7Trl5cr9uFfZMJF/O7J9/WHbBNHaa0W99cDju96LakRn2i767FP25ry3JHa9nIdqA
 zN4Uc+clYmH1/Wdp2tkTI0x7q8vZhA==
X-Proofpoint-ORIG-GUID: 46FxQu0SCT_BAl1SthDUfVaTmYPp2ZXg
X-Proofpoint-GUID: 46FxQu0SCT_BAl1SthDUfVaTmYPp2ZXg
X-Authority-Analysis: v=2.4 cv=TMJIilla c=1 sm=1 tr=0 ts=6926f32d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=5oxjjmwJqIIfr6gTb_cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

On 11/26/25 06:33, Andrew Donnellan wrote:
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> Move enabling and disabling of interrupts around the SIE instruction to
> entry code. Enabling interrupts only after the __TI_sie flag has been set
> guarantees that the SIE instruction is not executed if an interrupt happens
> between enabling interrupts and the execution of the SIE instruction.
> Interrupt handlers and machine check handler forward the PSW to the
> sie_exit label in such cases.
> 
> This is a prerequisite for VIRT_XFER_TO_GUEST_WORK to prevent that guest
> context is entered when e.g. a scheduler IPI, indicating that a reschedule
> is required, happens right before the SIE instruction, which could lead to
> long delays.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Tested-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>


Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/stacktrace.h | 1 +
>   arch/s390/kernel/asm-offsets.c     | 1 +
>   arch/s390/kernel/entry.S           | 2 ++
>   arch/s390/kvm/kvm-s390.c           | 5 -----
>   4 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
> index 810a6b9d96280f73311de873ad180c59a0cfbd5f..c9ae680a28af910c4703eee179be4db6c1ec9ad1 100644
> --- a/arch/s390/include/asm/stacktrace.h
> +++ b/arch/s390/include/asm/stacktrace.h
> @@ -66,6 +66,7 @@ struct stack_frame {
>   			unsigned long sie_flags;
>   			unsigned long sie_control_block_phys;
>   			unsigned long sie_guest_asce;
> +			unsigned long sie_irq;
>   		};
>   	};
>   	unsigned long gprs[10];
> diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
> index a8915663e917faed4551276b64013ee073662cc9..730449f464aff25761264b00d63d92e907f17f78 100644
> --- a/arch/s390/kernel/asm-offsets.c
> +++ b/arch/s390/kernel/asm-offsets.c
> @@ -64,6 +64,7 @@ int main(void)
>   	OFFSET(__SF_SIE_FLAGS, stack_frame, sie_flags);
>   	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
>   	OFFSET(__SF_SIE_GUEST_ASCE, stack_frame, sie_guest_asce);
> +	OFFSET(__SF_SIE_IRQ, stack_frame, sie_irq);
>   	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
>   	BLANK();
>   	OFFSET(__SFUSER_BACKCHAIN, stack_frame_user, back_chain);
> diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
> index 75b0fbb236d05f420b20cac6bac925e8ac36fa68..e906f4ab6cf35e53061a27192911629c10c347ed 100644
> --- a/arch/s390/kernel/entry.S
> +++ b/arch/s390/kernel/entry.S
> @@ -189,6 +189,7 @@ SYM_FUNC_START(__sie64a)
>   	mvc	__SF_SIE_FLAGS(8,%r15),__TI_flags(%r14) # copy thread flags
>   	lmg	%r0,%r13,0(%r4)			# load guest gprs 0-13
>   	mvi	__TI_sie(%r14),1
> +	stosm	__SF_SIE_IRQ(%r15),0x03		# enable interrupts
>   	lctlg	%c1,%c1,__SF_SIE_GUEST_ASCE(%r15) # load primary asce
>   	lg	%r14,__SF_SIE_CONTROL(%r15)	# get control block pointer
>   	oi	__SIE_PROG0C+3(%r14),1		# we are going into SIE now
> @@ -212,6 +213,7 @@ SYM_FUNC_START(__sie64a)
>   	lg	%r14,__LC_CURRENT(%r14)
>   	mvi	__TI_sie(%r14),0
>   SYM_INNER_LABEL(sie_exit, SYM_L_GLOBAL)
> +	stnsm	__SF_SIE_IRQ(%r15),0xfc		# disable interrupts
>   	lg	%r14,__SF_SIE_SAVEAREA(%r15)	# load guest register save area
>   	stmg	%r0,%r13,0(%r14)		# save guest gprs 0-13
>   	xgr	%r0,%r0				# clear guest registers to
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index fa6b5150ca31e4d9f0bdafabc1fb1d90ef3f3d0d..3cad08662b3d80aaf6f5f8891fc08b383c3c44d4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5075,13 +5075,8 @@ int noinstr kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
>   	 * The guest_state_{enter,exit}_irqoff() functions inform lockdep and
>   	 * tracing that entry to the guest will enable host IRQs, and exit from
>   	 * the guest will disable host IRQs.
> -	 *
> -	 * We must not use lockdep/tracing/RCU in this critical section, so we
> -	 * use the low-level arch_local_irq_*() helpers to enable/disable IRQs.
>   	 */
> -	arch_local_irq_enable();
>   	ret = sie64a(scb, gprs, gasce);
> -	arch_local_irq_disable();
>   
>   	guest_state_exit_irqoff();
>   
> 


