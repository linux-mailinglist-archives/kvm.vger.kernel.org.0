Return-Path: <kvm+bounces-28984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F1E9A068E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 12:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E95011F21B77
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 10:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E0A206966;
	Wed, 16 Oct 2024 10:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gMYSf2I8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A621E3DC;
	Wed, 16 Oct 2024 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729073124; cv=none; b=hOYURwBxAjali7XaNWM3PzfGWCpmWsz2rKCm5/ix3uPxUVSSrttugAANZcks/EGRaHNKqms244ovnFjQZjR3N/Q1IrsoOvTZk8u0UHgHTHm9OzwW9a2pguKA+4qOyMJunMumxWm7QOZdYhLyzl9ch4pY7wM6HgLJp4SANYl6uJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729073124; c=relaxed/simple;
	bh=1a3YbKxKN8xZ4R280960LWXYvm1GuJ7vvD01BJ4IeGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbbA3dLNcFPoLe5irIY+8QUAekVrzvCVepy4zc14CqNVnQj3gEC85iGBYh+s6ErwDRriXu04fa8wm6H8Lmojxx3lVZ+wDA8RiwxvqqwqDqjMxkeSCmMNkp9Z4eJG9xAPtYAW38IwOD2apfKq0lKo6/AQmdifSdH2KPEuYiVKFdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gMYSf2I8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G8OhF0031609;
	Wed, 16 Oct 2024 10:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HOc3lwyAJWdnbQuXAehqH3n4qi0/6t
	M7GRfqEH5I4GQ=; b=gMYSf2I8PP/y/I9a3e6j+FDr8TwxMENmgppdrogY0AvyvH
	FPV4G43aUUs1iQ9Z4EmLjZHcGgttHTQMI5cQL88YwVV09MHEnmDO+AiNCSCYIFdk
	oStDRK9+gWMca6vL0SZxgzx/hgr+3uHJhBxC0voeQVhCbqEEfsRFTVinfp5Qu0qU
	d2HoiaJ71K5CXM+BZdLiLLUmESi3hGTrwAHtROu0daYQnzSPsQ+CzwFhPdr1EkgF
	ZDwhbJ+eOTyNaYVbxY6dx3zkvigOQjej2ZAZz1FPeswgwztPV2vtwfXamBnQ07o1
	MvwHLnyGPfme4Mxs4QcRJdoWoZNfoBaY3pI3V+aQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42a9xt0hex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:05:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49G9UZmc006674;
	Wed, 16 Oct 2024 10:05:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4283es0w75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:05:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GA5GR019399076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 10:05:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72A322006A;
	Wed, 16 Oct 2024 10:05:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCC6820065;
	Wed, 16 Oct 2024 10:05:15 +0000 (GMT)
Received: from osiris (unknown [9.179.27.227])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Oct 2024 10:05:15 +0000 (GMT)
Date: Wed, 16 Oct 2024 12:05:14 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 05/11] s390/mm/fault: Handle guest-related program
 interrupts in KVM
Message-ID: <20241016100514.16801-B-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
 <20241015164326.124987-6-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015164326.124987-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: feadpziJOXHdwTnQjoRkx69PpfrEMUhP
X-Proofpoint-GUID: feadpziJOXHdwTnQjoRkx69PpfrEMUhP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=604 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160063

On Tue, Oct 15, 2024 at 06:43:20PM +0200, Claudio Imbrenda wrote:
> Any program interrupt that happens in the host during the execution of
> a KVM guest will now short circuit the fault handler and return to KVM
> immediately. Guest fault handling (including pfault) will happen
> entirely inside KVM.
> 
> When sie64a() returns zero, current->thread.gmap_int_code will contain
> the program interrupt number that caused the exit, or zero if the exit
> was not caused by a host program interrupt.
> 
> KVM will now take care of handling all guest faults in vcpu_post_run().
> 
> Since gmap faults will not be visible by the rest of the kernel, remove
> GMAP_FAULT, the linux fault handlers for secure execution faults, the
> exception table entries for the sie instruction, the nop padding after
> the sie instruction, and all other references to guest faults from the
> s390 code.

...

> diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
...
> @@ -317,9 +318,23 @@ void noinstr __do_pgm_check(struct pt_regs *regs)
>  	struct lowcore *lc = get_lowcore();
>  	irqentry_state_t state;
>  	unsigned int trapnr;
> +	union teid teid = { .val = lc->trans_exc_code };
>  
>  	regs->int_code = lc->pgm_int_code;
> -	regs->int_parm_long = lc->trans_exc_code;
> +	regs->int_parm_long = teid.val;
> +
> +	/*
> +	 * In case of a guest fault, short-circuit the fault handler and return.
> +	 * This way the sie64a() function will return 0; fault address and
> +	 * other relevant bits are saved in current->thread.gmap_teid, and
> +	 * the fault number in current->thread.gmap_int_code. KVM will be
> +	 * able to use this information to handle the fault.
> +	 */
> +	if (test_pt_regs_flag(regs, PIF_GUEST_FAULT) && (teid.as == PSW_BITS_AS_PRIMARY)) {
> +		current->thread.gmap_teid.val = regs->int_parm_long;
> +		current->thread.gmap_int_code = regs->int_code & 0xffff;
> +		return;
> +	}

This check looks suboptimal to me for two reasons:

- if PIF_GUEST_FAULT is set it should never happen that the normal
  exception handling code is executed; it is clearly a bug if that
  would happen, and with the above check this may or may not be
  recognized with a kernel crash, if I'm not mistaken.

- __do_pgm_check() is executed for all program interruptions. This
  includes those interruptions which do not write a teid. Therefore
  the above check may do something unexpected depending on what teid a
  previous program interruption wrote. I think the teid.as check
  should be moved to kvm as well, and only be done for those cases
  where it is known that the teid contains a valid value.

