Return-Path: <kvm+bounces-30018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF58F9B642E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 611EA1F212B6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 13:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167D81EABAF;
	Wed, 30 Oct 2024 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XMksxIRK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD201401B;
	Wed, 30 Oct 2024 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730295228; cv=none; b=dziqmEpDSqomr57br6obYjLYkipCD4IRlls6O0dx4PkcjTP21CVywo83HQ7eEGsKUBzjDOdxq7tJNVeoR02/1hTNtlva2Zt5v256xF7EF54D2Efq1xxjoVV9jqErNkaKVvo8av1yLEykH+ISxk6jiPWivkgrPg3rZEfK3oRk89k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730295228; c=relaxed/simple;
	bh=fA4Vc4kMl+nKRo8aRDn5Rp/ZNNJK2iXiS9et+ri6ATc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFq78gZhTtR1wvtR4wwQzweBzwYYXj4xpunmTrzJP0v+L4w2GELOCihBTlOkyo4pPdV02l7X16bqIHj8aipCf/AXqceE62/EmBh0COinwA14I8HzVvh+PbT8qQEqvxNK1/bkb+hVK/1KJLpABrMU07IkY6Yk6Pr9ssHC65HV5FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XMksxIRK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2d5dh030110;
	Wed, 30 Oct 2024 13:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rIN9NEJdpGA1ijQ9VvtPh7aO1g5PzQ
	xogRMddlUsnUg=; b=XMksxIRKpVClldO1sswFvm3W7qEYoC1DZC4u9Xot5yssHh
	0xwhxxn1xYCq/jHdUbH/ZcWFVKsVbr7fT8V75KJKD08DJLd9BDTcz/8CKi/9+1Fv
	y2z3oYKeG5tF09/9WDw4rLlHGXeAfNIosAtWFe1Y+MAr9IpOTognso/Kqqwkw5Q1
	KMU/jMwHcWVwqo2IWPpslVGUyzieYEbJy+jSEFI9LoYsAeZSXJPJkRLGjLWC2zCa
	XIFL4tuxxC0607O8yX9qj0aL4HYsIYGBbpN+A30epyVz7wq/XEbYJS610/wg/rJP
	a8tHp94xwLI77Zg2zhrr/FDRUbzlSYq2aHhYjnFA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42js0h8yq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 13:33:31 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49UDXUxF014422;
	Wed, 30 Oct 2024 13:33:30 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42js0h8yq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 13:33:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDLV3u024535;
	Wed, 30 Oct 2024 13:33:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hcyjfxm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 13:33:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UDXSH257868608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 13:33:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E5752004B;
	Wed, 30 Oct 2024 13:33:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69A382004D;
	Wed, 30 Oct 2024 13:33:26 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.39.21.224])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 13:33:26 +0000 (GMT)
Date: Wed, 30 Oct 2024 19:03:13 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: mpe@ellerman.id.au, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] arch/powerpc/kvm: Fix doorbells for nested KVM
 guests on PowerNV
Message-ID: <rbx6n7cqmslnj4re44hb6hdqcuhfbqvmxo5ebsrk2dqia3hj2w@jljlwne2nzvf>
References: <20240627180342.110238-1-gautam@linux.ibm.com>
 <20240627180342.110238-3-gautam@linux.ibm.com>
 <D2GQSGNWNGX4.2R8TH3M64POGJ@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D2GQSGNWNGX4.2R8TH3M64POGJ@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OsRhtwN3hjjbeoIWhQDmj4n-gf4gJK2B
X-Proofpoint-ORIG-GUID: q9JbYBXF1S6NMphUjl4TMaGARfrZW6cO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300103

On Thu, Jul 04, 2024 at 10:10:05PM +1000, Nicholas Piggin wrote:
> On Fri Jun 28, 2024 at 4:03 AM AEST, Gautam Menghani wrote:
> > commit 6398326b9ba1("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
> > introduced an optimization to use only vcpu->doorbell_request for SMT
> > emulation for Power9 and above guests, but the code for nested guests 
> > still relies on the old way of handling doorbells, due to which an L2
> > guest cannot be booted with XICS with SMT>1. The command to repro
> > this issue is:
> >
> > qemu-system-ppc64 \
> > 	-drive file=rhel.qcow2,format=qcow2 \
> > 	-m 20G \
> > 	-smp 8,cores=1,threads=8 \
> > 	-cpu  host \
> > 	-nographic \
> > 	-machine pseries,ic-mode=xics -accel kvm
> >
> > Fix the plumbing to utilize vcpu->doorbell_request instead of vcore->dpdes 
> > on P9 and above.
> >
> > Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
> > Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> > ---
> >  arch/powerpc/kvm/book3s_hv.c        |  9 ++++++++-
> >  arch/powerpc/kvm/book3s_hv_nested.c | 20 ++++++++++++++++----
> >  2 files changed, 24 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index cea28ac05923..0586fa636707 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -4178,6 +4178,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
> >  	}
> >  	hvregs.hdec_expiry = time_limit;
> >  
> > +	// clear doorbell bit as hvregs already has the info
> > +	vcpu->arch.doorbell_request = 0;
> > +
> >  	/*
> >  	 * When setting DEC, we must always deal with irq_work_raise
> >  	 * via NMI vs setting DEC. The problem occurs right as we
> > @@ -4694,6 +4697,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
> >  	struct kvm_nested_guest *nested = vcpu->arch.nested;
> >  	unsigned long flags;
> >  	u64 tb;
> > +	bool doorbell_pending;
> >  
> >  	trace_kvmppc_run_vcpu_enter(vcpu);
> >  
> > @@ -4752,6 +4756,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
> >  	 */
> >  	smp_mb();
> >  
> > +	doorbell_pending = !cpu_has_feature(CPU_FTR_ARCH_300) &&
> > +				vcpu->arch.doorbell_request;
> 
> Hmm... is the feature test flipped here?

Sorry for responding late, I got involved in some other things. 
Yes I think I got that part wrong, I guess it should've been

doorbell_pending = !cpu_has_feature(CPU_FTR_HVMODE) &&
                        vcpu->arch.doorbell_request;

The objective of introducing this is to avoid returning to L1 midway
when L0 is about to run L2. The issue is that if L1 does H_ENTER_NESTED
and there is a doorbell for L2, this condition in kvmhv_run_single_vcpu
will cause L0 to abort and go back to L1:

	} else if (vcpu->arch.pending_exceptions ||
		   vcpu->arch.doorbell_request ||
		   xive_interrupt_pending(vcpu)) {
		vcpu->arch.ret = RESUME_HOST;
		goto out;
	}

Earlier, vc->dpdes was used to pass around doorbell state, that's why
this condition did not cause problems, until 
6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")

> 
> > +
> >  	if (!nested) {
> >  		kvmppc_core_prepare_to_enter(vcpu);
> >  		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
> > @@ -4769,7 +4776,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
> >  				lpcr |= LPCR_MER;
> >  		}
> >  	} else if (vcpu->arch.pending_exceptions ||
> > -		   vcpu->arch.doorbell_request ||
> > +		   doorbell_pending ||
> >  		   xive_interrupt_pending(vcpu)) {
> >  		vcpu->arch.ret = RESUME_HOST;
> >  		goto out;
> > diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> > index 05f5220960c6..b34eefa6b268 100644
> > --- a/arch/powerpc/kvm/book3s_hv_nested.c
> > +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> > @@ -32,7 +32,10 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
> >  	struct kvmppc_vcore *vc = vcpu->arch.vcore;
> >  
> >  	hr->pcr = vc->pcr | PCR_MASK;
> > -	hr->dpdes = vc->dpdes;
> > +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> > +		hr->dpdes = vcpu->arch.doorbell_request;
> > +	else
> > +		hr->dpdes = vc->dpdes;
> >  	hr->hfscr = vcpu->arch.hfscr;
> >  	hr->tb_offset = vc->tb_offset;
> >  	hr->dawr0 = vcpu->arch.dawr0;
> 
> Great find.
> 
> Nested is all POWER9 and later only, so I think you can just
> change to using doorbell_request always.

Noted.

> 
> And probably don't have to do anything for book3s_hv.c unless
> I'm mistaken about the feature test.
>

As pointed out above, the intention was to avoid the "else if" part in
kvmhv_run_single_vcpu(). Please do  point out if I missed something here.

Thanks,
Gautam

