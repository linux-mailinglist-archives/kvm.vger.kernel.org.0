Return-Path: <kvm+bounces-22247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A068793C48E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8181F21093
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDA119D881;
	Thu, 25 Jul 2024 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mwNozpe7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D4419AA5F;
	Thu, 25 Jul 2024 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918452; cv=none; b=P8kqNPmtotlTksBSSfxVI8+2lDsiBC3wu6QwmzmAZxJrLyKiGKvI1pInR5JG7ADhYK4D1czNHKVF5zUnEUNZrjZeet9ezc7RcuncZAXemp7SI3E/ciskSIFTKodfLo56z+nIyuXGiLzYC4BbRH0C0Cz6ka2GCzdxNDXVcNVtJ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918452; c=relaxed/simple;
	bh=bg2nE6Nop9iCAVE/Rf3cgmkDHj7vUdjrWON45a7+72s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=keOXSFXUmnTbyMvx2wwi36UJSKQizRmD9fO58IWl6gN1PWO51EOfpvFNrbkfnvInb5CP9Cm9Fq3U76Z7aS1WJ9KFMfROJTJRsgoB1ZuPzguDXn52uxo+u/HRgLZDi8eMBZiUDj9aAS7PLIeX591N3EIBnKrwD7LoB+vR4afgLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mwNozpe7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PCmYfS023553;
	Thu, 25 Jul 2024 14:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	fNfevtvfjiC/VMwjJEVKjse9KgFHhclnDiYuwxeAyyU=; b=mwNozpe7g4p6yTPz
	HChgNHIHe2KhMdKko7nEjPHyC/n+uzj/HPYWpy9ZC/ErzW8JbesWy+qGZs13jDcu
	H771ausG4MWLhUdVikyLn0pQQ2wdMbE8Fe7NXf1o0393v8h6fgC34AZr9XqExcJU
	+DS5gDQLpvbmWEJDcQ5hBiECqH9dz/tKGDFYaY9oEijPq5kumpY+Up+VGS2UBmBf
	ATtR+KdER3V5cub522RIUlt629ZE0+Ckrmk+X8eCDYgrnalOSrjGEIolboeSjwWA
	xOKFJHd3ftBQP9NHcIbjoyxBQ5PZzSCnFH4U2GWmLqImz2audn+kBv/O7KZwqOYh
	p3xFzQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kjbggyby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:48 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEelvx025671;
	Thu, 25 Jul 2024 14:40:47 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kjbggybv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PC1BiA006242;
	Thu, 25 Jul 2024 14:40:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gqjuqkub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEef9t31261388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:40:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 312E62004D;
	Thu, 25 Jul 2024 14:40:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB25820040;
	Thu, 25 Jul 2024 14:40:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.15.236])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:40:40 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:36:34 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: Move SIE assembly into new
 file
Message-ID: <20240725163634.5b1025e4@p-imbrenda>
In-Reply-To: <20240718105104.34154-4-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-4-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: pXrmgOP5pWJFUhjlAg-_UnQV66w5aE1I
X-Proofpoint-GUID: yjrKlpF1ErkL_WW0peFaJ21gb72o59A2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_13,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407250099

On Thu, 18 Jul 2024 10:50:18 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> In contrast to the other functions in cpu.S it's quite lengthy so
> let's split it off.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile             |  2 +-
>  s390x/{cpu.S => cpu-sie.S} | 59 +----------------------------------
>  s390x/cpu.S                | 64 --------------------------------------
>  3 files changed, 2 insertions(+), 123 deletions(-)
>  copy s390x/{cpu.S => cpu-sie.S} (56%)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 457b8455..ecf0bc7e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -119,7 +119,7 @@ cflatobjs += lib/s390x/fault.o
>  
>  OBJDIRS += lib/s390x
>  
> -asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
> +asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o $(TEST_DIR)/cpu-sie.o
>  
>  FLATLIBS = $(libcflat)
>  
> diff --git a/s390x/cpu.S b/s390x/cpu-sie.S
> similarity index 56%
> copy from s390x/cpu.S
> copy to s390x/cpu-sie.S
> index 9155b044..9370b5c0 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu-sie.S
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * s390x assembly library
> + * s390x SIE assembly library
>   *
>   * Copyright (c) 2019 IBM Corp.
>   *
> @@ -8,59 +8,6 @@
>   *    Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <asm/asm-offsets.h>
> -#include <asm/sigp.h>
> -
> -#include "macros.S"
> -
> -/*
> - * load_reset calling convention:
> - * %r2 subcode (0 or 1)
> - */
> -.globl diag308_load_reset
> -diag308_load_reset:
> -	SAVE_REGS_STACK
> -	/* Backup current PSW mask, as we have to restore it on success */
> -	epsw	%r0, %r1
> -	st	%r0, GEN_LC_SW_INT_PSW
> -	st	%r1, GEN_LC_SW_INT_PSW + 4
> -	/* Load reset psw mask (short psw, 64 bit) */
> -	lg	%r0, reset_psw
> -	/* Load the success label address */
> -	larl    %r1, 0f
> -	/* Or it to the mask */
> -	ogr	%r0, %r1
> -	/* Store it at the reset PSW location (real 0x0) */
> -	stg	%r0, 0
> -	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
> -	/* Do the reset */
> -	diag    %r0,%r2,0x308
> -	/* Failure path */
> -	xgr	%r2, %r2
> -	br	%r14
> -	/* Success path */
> -	/* load a cr0 that has the AFP control bit which enables all FPRs */
> -0:	larl	%r1, initial_cr0
> -	lctlg	%c0, %c0, 0(%r1)
> -	lg      %r15, GEN_LC_SW_INT_GRS + 15 * 8
> -	RESTORE_REGS_STACK
> -	lhi	%r2, 1
> -	larl	%r0, 1f
> -	stg	%r0, GEN_LC_SW_INT_PSW + 8
> -	lpswe	GEN_LC_SW_INT_PSW
> -1:	br	%r14
> -
> -/* Sets up general registers and cr0 when a new cpu is brought online. */
> -.globl smp_cpu_setup_state
> -smp_cpu_setup_state:
> -	xgr	%r1, %r1
> -	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
> -	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
> -	/* We should only go once through cpu setup and not for every restart */
> -	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
> -	larl	%r14, 0f
> -	lpswe	GEN_LC_SW_INT_PSW
> -	/* If the function returns, just loop here */
> -0:	j	0
>  
>  /*
>   * sie64a calling convention:
> @@ -125,7 +72,3 @@ sie_exit:
>  .globl sie_exit_gregs
>  sie_exit_gregs:
>  	br	%r14
> -
> -	.align	8
> -reset_psw:
> -	.quad	0x0008000180000000
> diff --git a/s390x/cpu.S b/s390x/cpu.S
> index 9155b044..2ff4b8e1 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu.S
> @@ -62,70 +62,6 @@ smp_cpu_setup_state:
>  	/* If the function returns, just loop here */
>  0:	j	0
>  
> -/*
> - * sie64a calling convention:
> - * %r2 pointer to sie control block
> - * %r3 guest register save area
> - */
> -.globl sie64a
> -sie64a:
> -	# Save host grs, fprs, fpc
> -	stmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r3)	# save kernel registers
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	std	\i, \i * 8  + SIE_SAVEAREA_HOST_FPRS(%r3)
> -	.endr
> -	stfpc	SIE_SAVEAREA_HOST_FPC(%r3)
> -
> -	stctg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r3)
> -	lctlg	%c1, %c1, SIE_SAVEAREA_GUEST_ASCE(%r3)
> -
> -	# Store scb and save_area pointer into stack frame
> -	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
> -	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
> -.globl sie_entry_gregs
> -sie_entry_gregs:
> -	# Load guest's gprs, fprs and fpc
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
> -	.endr
> -	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
> -	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
> -
> -	# Move scb ptr into r14 for the sie instruction
> -	lg	%r14,__SF_SIE_CONTROL(%r15)
> -
> -.globl sie_entry
> -sie_entry:
> -	sie	0(%r14)
> -	nopr	7
> -	nopr	7
> -	nopr	7
> -
> -.globl sie_exit
> -sie_exit:
> -	# Load guest register save area
> -	lg	%r14,__SF_SIE_SAVEAREA(%r15)
> -
> -	# Restore the host asce
> -	lctlg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r14)
> -
> -	# Store guest's gprs, fprs and fpc
> -	stmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r14)	# save guest gprs 0-13
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	std	\i, \i * 8  + SIE_SAVEAREA_GUEST_FPRS(%r14)
> -	.endr
> -	stfpc	SIE_SAVEAREA_GUEST_FPC(%r14)
> -
> -	# Restore host's gprs, fprs and fpc
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	ld	\i, \i * 8 + SIE_SAVEAREA_HOST_FPRS(%r14)
> -	.endr
> -	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
> -	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
> -.globl sie_exit_gregs
> -sie_exit_gregs:
> -	br	%r14
> -
>  	.align	8
>  reset_psw:
>  	.quad	0x0008000180000000


