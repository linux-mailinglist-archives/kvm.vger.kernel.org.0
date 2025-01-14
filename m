Return-Path: <kvm+bounces-35412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0FBA10E80
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 365973AD2B0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59D81F9415;
	Tue, 14 Jan 2025 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n9j9lStj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA181E3DCC;
	Tue, 14 Jan 2025 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736877381; cv=none; b=qIJn8L/Zu8BGJo9kNGDFx/BEQZGyaLlMR/hS/rCmt9EfReA31N9jlaOocxoGZ5pdesMT5FdWQXy9pR+zXySURIUUbenG4pIAWXGlXdHwm9CNFsYaXupa8KW3f9p20Pa1vLbU/TaEauOa5huL3O8bTru//IN0BJTLq6aWvWpZf8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736877381; c=relaxed/simple;
	bh=ik2Aj+Yp2na9xeeNQolDsviEnf4v9NEK7GCREAN9EBI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qu/XIEEjXyE5/5KSpo5Lba37h/95jK4HUN3MJtX1XGZNy6mllJubz0EtKVGbiZrE2G1+Q/VAu0BY33DVeK15auKkNnScXpSrgaCl5r2F64j+9Yx4QWMVmIaV9ecoFwkgXPdcq68G5mfBFLAHMBv3Vv9gVcNHII9gbALWCHMNGwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n9j9lStj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EGlaG4004790;
	Tue, 14 Jan 2025 17:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gaJaWv
	LIE1FnyC6yQ1fz4UHjE41IcgxpE1WDEye4bt0=; b=n9j9lStjsvxQCiL2QLWT50
	qLuAieQyRtWhxGxslB+SW4ygyHes7IdJbKilZTflqI5plSlUacCaoNZKPLpf3ovJ
	JFtaCiCmhv4OaKyeBtBU49+GB2BsnDXK4bzYSG4NzSQgaIM/QcoRK72ivdN5TcKm
	uY0onajp49oWcSqM7+3rOQLbb9v/4GpNfSGyDtopYJbmcVoBymooxGcr0QyHlPWx
	MOr9nlNVGTI5dglo3hfr0P8m4lKwOgKQkppSyvY3DrjQh+BuRb3qXN3YieFahyg3
	wIsTNuk1L8jm5psnfgmwyoztOGd/v2CjmnsOzQmNslpi18XWsUFY95SfQKJ5L3Lw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445gdjk88y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 17:56:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50EE51dR016991;
	Tue, 14 Jan 2025 17:56:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk48bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 17:56:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50EHu75e30671436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:56:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A658820040;
	Tue, 14 Jan 2025 17:56:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74AC220043;
	Tue, 14 Jan 2025 17:56:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Jan 2025 17:56:07 +0000 (GMT)
Date: Tue, 14 Jan 2025 18:56:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>, <david@redhat.com>,
        <willy@infradead.org>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <nrb@linux.ibm.com>,
        <nsg@linux.ibm.com>
Subject: Re: [PATCH v1 03/13] KVM: s390: use __kvm_faultin_pfn()
Message-ID: <20250114185605.24262ca3@p-imbrenda>
In-Reply-To: <D71Z6BW4A19F.3OQIPSERFIUCH@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-4-imbrenda@linux.ibm.com>
	<D71Z6BW4A19F.3OQIPSERFIUCH@linux.ibm.com>
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
X-Proofpoint-GUID: xDPWe0jCz3zkTJRZl0sYVMrEkuJgVz29
X-Proofpoint-ORIG-GUID: xDPWe0jCz3zkTJRZl0sYVMrEkuJgVz29
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=964
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140134

On Tue, 14 Jan 2025 18:34:13 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Wed Jan 8, 2025 at 7:14 PM CET, Claudio Imbrenda wrote:
> > Refactor the existing page fault handling code to use __kvm_faultin_pfn().
> >
> > This possible now that memslots are always present.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 92 +++++++++++++++++++++++++++++++---------
> >  arch/s390/mm/gmap.c      |  1 +
> >  2 files changed, 73 insertions(+), 20 deletions(-)  
> 
> With nits resolved:
> 
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

I'll send a v2 with some more substantial differences, so maybe you
will want to look at that first :) 

[...]

> > +		gfn = gpa_to_gfn(gaddr);
> > +		if (kvm_is_ucontrol(vcpu->kvm)) {
> > +			/*
> > +			 * This translates the per-vCPU guest address into a
> > +			 * fake guest address, which can then be used with the
> > +			 * fake memslots that are identity mapping userspace.
> > +			 * This allows ucontrol VMs to use the normal fault
> > +			 * resolution path, like normal VMs.
> > +			 */
> > +			gaddr_tmp = gmap_translate(vcpu->arch.gmap, gaddr);
> > +			if (gaddr_tmp == -EFAULT) {
> >  				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
> >  				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
> >  				vcpu->run->s390_ucontrol.pgm_code = 0x10;  
> 
> nit: s/0x10/PGM_SEGMENT_TRANSLATION/

the original code has 0x10, I wanted to keep it as it is, but I'll
change it, since I'm refactoring more code in v2

> 
> >  				return -EREMOTE;
> >  			}
> > -			return vcpu_post_run_addressing_exception(vcpu);
> > +			gfn = gpa_to_gfn(gaddr_tmp);
> >  		}
> > +		return kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
> >  		break;  
> 
> nit: Remove the break after the return here?

yes

> 
> >  	default:
> >  		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
> > @@ -4880,7 +4932,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> >  		send_sig(SIGSEGV, current, 0);
> >  		break;
> >  	}
> > -	return rc;
> > +	return 0;
> >  }
> >  
> >  static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index 16b8a36c56de..3aacef77c174 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -605,6 +605,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
> >  	radix_tree_preload_end();
> >  	return rc;
> >  }
> > +EXPORT_SYMBOL(__gmap_link);
> >  
> >  /**
> >   * fixup_user_fault_nowait - manually resolve a user page fault without waiting  
> 


