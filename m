Return-Path: <kvm+bounces-29002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3152C9A0CC4
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 16:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54FA31C20D60
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 14:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0136420C031;
	Wed, 16 Oct 2024 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kJf14sRU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FDE52F76;
	Wed, 16 Oct 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089288; cv=none; b=WNpyebRcaFcRFB95GrYAhKK0Uy2Z08iIEeqEbO0vpJRx1FK6oA7MlFEe98+QsyD3o8G/tuTi8kFl+CAcsocnKm9IQbcty89wZWE1d8LOBtJ0f6FB/ik9tAqrz2I2LJUelTaDF/G3SGqR4yHRiJzTlfmPrbo7MQxTeAdganrWSm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089288; c=relaxed/simple;
	bh=9pGvOg7/zJ+sEkmg/MqTZPaUTQA12sZ3ht8GHY8VcY0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NN90fFTwh/7wgUwAAM/UJ8FtX0kGOSCGvOQ0R1f10Px9GfwzFMAqyZzblevmcwoyny3oUufg2knKEB8Yv2dRWiUI6XkIxG/0JUueG7mnexXTZk8huL79bwlITvbOkpdi8/l5gsMf10XlGWh3t/XVQuOVYO90I2Uc+1gtYKNKYJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kJf14sRU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GBtBRi026328;
	Wed, 16 Oct 2024 14:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/2qEwJ
	b8qhapWyJn4YJ9nNClV92VT537dWyiNsRXy1s=; b=kJf14sRUKzdQBrYgujn20V
	NsCSGde5d4EsVgXFQzeUwpdIBZ28TP3Bg0YtWuiN3Vug4bmiTd2hmuf1mfXqW/iC
	iGwxhDH4rg6DugbqGDXyPSWjnpOVW2V046ZVOsG9zGS3exmX0SNg1IId6K73cjLN
	/c8zdoVMH1Zn/e348KJZd2Hc5PCCvW7xbWNo5jsbPbYlWnsZkYh+TyKfPLPnVmqD
	8ZNdxbYQFuZcWAyKaZele+PXFGKHlr3qcH9Zy7PpwHId5FJpQPrxt4/M9Hjz6PPp
	vb+FEng35ouuhSjOuw0Sipya5CmAQB26pqFAw1pVG9azaT3XbYPgqP0e9mVinTpw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ad1j0u02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 14:34:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GCte5D001991;
	Wed, 16 Oct 2024 14:34:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emsxmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 14:34:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GEYdHk26936056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 14:34:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDCD720049;
	Wed, 16 Oct 2024 14:34:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C00B20040;
	Wed, 16 Oct 2024 14:34:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 14:34:39 +0000 (GMT)
Date: Wed, 16 Oct 2024 16:34:37 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 05/11] s390/mm/fault: Handle guest-related program
 interrupts in KVM
Message-ID: <20241016163437.35ae1a51@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20241016100514.16801-B-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
	<20241015164326.124987-6-imbrenda@linux.ibm.com>
	<20241016100514.16801-B-hca@linux.ibm.com>
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
X-Proofpoint-GUID: W7rY38ICAyuVKEoPNw73QewcQUa1eLic
X-Proofpoint-ORIG-GUID: W7rY38ICAyuVKEoPNw73QewcQUa1eLic
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxlogscore=813 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160089

On Wed, 16 Oct 2024 12:05:14 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Oct 15, 2024 at 06:43:20PM +0200, Claudio Imbrenda wrote:
> > Any program interrupt that happens in the host during the execution of
> > a KVM guest will now short circuit the fault handler and return to KVM
> > immediately. Guest fault handling (including pfault) will happen
> > entirely inside KVM.
> > 
> > When sie64a() returns zero, current->thread.gmap_int_code will contain
> > the program interrupt number that caused the exit, or zero if the exit
> > was not caused by a host program interrupt.
> > 
> > KVM will now take care of handling all guest faults in vcpu_post_run().
> > 
> > Since gmap faults will not be visible by the rest of the kernel, remove
> > GMAP_FAULT, the linux fault handlers for secure execution faults, the
> > exception table entries for the sie instruction, the nop padding after
> > the sie instruction, and all other references to guest faults from the
> > s390 code.  
> 
> ...
> 
> > diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c  
> ...
> > @@ -317,9 +318,23 @@ void noinstr __do_pgm_check(struct pt_regs *regs)
> >  	struct lowcore *lc = get_lowcore();
> >  	irqentry_state_t state;
> >  	unsigned int trapnr;
> > +	union teid teid = { .val = lc->trans_exc_code };
> >  
> >  	regs->int_code = lc->pgm_int_code;
> > -	regs->int_parm_long = lc->trans_exc_code;
> > +	regs->int_parm_long = teid.val;
> > +
> > +	/*
> > +	 * In case of a guest fault, short-circuit the fault handler and return.
> > +	 * This way the sie64a() function will return 0; fault address and
> > +	 * other relevant bits are saved in current->thread.gmap_teid, and
> > +	 * the fault number in current->thread.gmap_int_code. KVM will be
> > +	 * able to use this information to handle the fault.
> > +	 */
> > +	if (test_pt_regs_flag(regs, PIF_GUEST_FAULT) && (teid.as == PSW_BITS_AS_PRIMARY)) {
> > +		current->thread.gmap_teid.val = regs->int_parm_long;
> > +		current->thread.gmap_int_code = regs->int_code & 0xffff;
> > +		return;
> > +	}  
> 
> This check looks suboptimal to me for two reasons:
> 
> - if PIF_GUEST_FAULT is set it should never happen that the normal
>   exception handling code is executed; it is clearly a bug if that
>   would happen, and with the above check this may or may not be
>   recognized with a kernel crash, if I'm not mistaken.
> 
> - __do_pgm_check() is executed for all program interruptions. This
>   includes those interruptions which do not write a teid. Therefore
>   the above check may do something unexpected depending on what teid a
>   previous program interruption wrote. I think the teid.as check
>   should be moved to kvm as well, and only be done for those cases
>   where it is known that the teid contains a valid value.

makes sense

I'll move the checks into the kvm part of the code, and trigger a
KVM_BUG if things are wrong

