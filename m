Return-Path: <kvm+bounces-29278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 707CB9A66EC
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9DF91F220FB
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC951E7C16;
	Mon, 21 Oct 2024 11:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B3iLtRPA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7957581A;
	Mon, 21 Oct 2024 11:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729511133; cv=none; b=DDJHyO+3gaw9GAaixpi/PX4ycREl4AI6Ms2bXj0PDbk13rfrRUHfpEkxxxGdYSoBylBWhQn3e/6y2+Lg8nEmD9/0kr9NFFswyzs7346nu9apxg2bGX0lqzxDa+QjxM82CSKb/93Mvf++/zy60t9/STdUBjupJ9snNdoS9ikQ1A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729511133; c=relaxed/simple;
	bh=PSlpc44J19PWt/KWtudFdIoyqLq92r+iFCX9e7ydhKo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uO1PstYHRYUvqawfrnJu8fXDT+kMAIIAAzEfeuYu4lheNa3ByBzU9bpAEXBe42rN8o7J1meDTEAkD4UAh1fuHCA8gkhbP3SxR6D1P/hZvSKz8DON9q4LD13LfhAYFTUPSOawUAcXv0xprZTP3QGvCwpTdXm1kOIKkhZfmtz/1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B3iLtRPA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KIf3026085;
	Mon, 21 Oct 2024 11:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=emfzp0
	ciJfe4UqhLMtNiThPTAzu+Ii/80Vdg7Iae/vs=; b=B3iLtRPAYHnEQkF+pFk4ca
	4Xf2y3RFzalvWUbtjEPrO3KsvWlNoe/KbZQStE5of6w/lH39Oc5g+zbNwCWhDvfj
	SsGC0C4z7xPh/FED4pnh3iOYpK3jJNJKg6rFG4F6kEZeGnrCJKDu0bX8t7IM/NhU
	dtZLvUgv6ofZOZM2La/KlevsEM8MEicqjo3wjpBtgPu7aapTCyvLba2Bg4bMXKLu
	PKe6BZOg15cB4J96PUfRReSHoYKHwVcPxvaL2P73yg7s11l61/BmvV2cl+Z5pt1n
	0DB0UT42CJE/1aF8EnWq8oYuOSzPA6acZEZyq7u4MrZCPkwvRgBmS+4CRdoq+Law
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5eu8fh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 11:45:29 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L8khJa029402;
	Mon, 21 Oct 2024 11:45:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42crkjwydj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 11:45:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49LBjPWk26542630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 11:45:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53E2920040;
	Mon, 21 Oct 2024 11:45:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EFDD20049;
	Mon, 21 Oct 2024 11:45:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.37.93])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 21 Oct 2024 11:45:24 +0000 (GMT)
Date: Mon, 21 Oct 2024 13:45:22 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 06/11] s390/kvm: Stop using gmap_{en,dis}able()
Message-ID: <20241021134522.511a141d@p-imbrenda>
In-Reply-To: <20241021095006.6950-B-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
	<20241015164326.124987-7-imbrenda@linux.ibm.com>
	<20241021095006.6950-B-hca@linux.ibm.com>
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
X-Proofpoint-GUID: vqfQLyjLVkHN2XzKkT-FIs9A9LnDGauB
X-Proofpoint-ORIG-GUID: vqfQLyjLVkHN2XzKkT-FIs9A9LnDGauB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=741 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210082

On Mon, 21 Oct 2024 11:50:06 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Oct 15, 2024 at 06:43:21PM +0200, Claudio Imbrenda wrote:
> > Stop using gmap_enable(), gmap_disable(), gmap_get_enabled().
> > 
> > The correct guest ASCE is passed as a parameter of sie64a(), there is
> > no need to save the current gmap in lowcore.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Acked-by: Steffen Eiden <seiden@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 7 +------
> >  arch/s390/kvm/vsie.c     | 4 +---
> >  2 files changed, 2 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index cfe3f8182aa5..df778a4a011d 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -3719,7 +3719,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> >  
> > -	gmap_enable(vcpu->arch.enabled_gmap);
> >  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
> >  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
> >  		__start_cpu_timer_accounting(vcpu);
> > @@ -3732,8 +3731,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
> >  		__stop_cpu_timer_accounting(vcpu);
> >  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_RUNNING);
> > -	vcpu->arch.enabled_gmap = gmap_get_enabled();
> > -	gmap_disable(vcpu->arch.enabled_gmap);  
> 
> I guess you want to get rid of enabled_gmap as well, since it becomes
> unused with this patch:

oh yeah, I had missed that.

I guess it can go in the next patch, where things are removed

> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 603b56bfccd3..51201b4ac93a 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -750,8 +750,6 @@ struct kvm_vcpu_arch {
>  	struct hrtimer    ckc_timer;
>  	struct kvm_s390_pgm_info pgm;
>  	struct gmap *gmap;
> -	/* backup location for the currently enabled gmap when scheduled out */
> -	struct gmap *enabled_gmap;
>  	struct kvm_guestdbg_info_arch guestdbg;
>  	unsigned long pfault_token;
>  	unsigned long pfault_select;
> 
> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>


