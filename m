Return-Path: <kvm+bounces-15754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D318B0123
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 07:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF071C227A9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE1D1553A9;
	Wed, 24 Apr 2024 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LhIO3Qsr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C0815687C;
	Wed, 24 Apr 2024 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713937146; cv=none; b=WUKDnJA1/wDr5b7iM7QPhPyffnJVI19wBfL4nfRVGRL9vGrI20zQVXd51v4MHtv0GeyJoDTD5rM4k8Kim6Cw7Bg2IU2f5vJK481pr9prx2YAd27mKRVx2HyfyCpWDzVr0EV36z5cTRp4QFy2dwYC1XcqR2B8vBTcXDE5wrm6RBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713937146; c=relaxed/simple;
	bh=lfdebmdIMRnh3+omiSo2vAVILbzSMdSCuN/osoq+hTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SH7lrH+bXf7DidNVC7bRir6j77GfB5dP76hf+6BIf3ETWPfqdJvMcGhVPFkgUzCcesz/rhq9ouTfiEWR6LspNesSJerV/mqttKVUayMSlkVahM53gYVFLKv+bgtgfDLRilmNjB1YsouacQq2gsEpXq7oYctQS9GlzU5C8Bl3dKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LhIO3Qsr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O5C4HZ004258;
	Wed, 24 Apr 2024 05:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=OQ8VcKyqDQzL8Pv4aSijrwhZ0hp3rwmuIEGuu7Q6/FU=;
 b=LhIO3QsrMebgYbxyDbx/Nq5fSFas5QyFNzQ/B35wN069qQGJil4nhfIfhfezHMzJOvjr
 wSelh7p4NhD9FNESjXG5cdp7vf72Edj7/twlDbrK7Wd8ToTP8plNpM5HQdgsDYH4P1dq
 TIH7npjaQdI8NKXJTxZN35G7VKjD7O4yKLg/DvcjDe+AsuiDYIVjetW9NQRCzIqqF28g
 TmKw1PhmYqHq0c5xiB18qcX14d6FTpRxIdANwEPjMAUj5/UhZSq6VfJG8xsBMhZATUm0
 iGrAnZPoDmyCpCJ+p1GVmYp3EdwnZFemIsH3AcJ5RBwt/F/THcOpomUeeRO2nko5xyIP yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpuqkr1mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 05:38:48 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43O5cmoW014610;
	Wed, 24 Apr 2024 05:38:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpuqkr1m9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 05:38:48 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O57oq7015289;
	Wed, 24 Apr 2024 05:38:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshm9sat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 05:38:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43O5cg3831130236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 05:38:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C977320049;
	Wed, 24 Apr 2024 05:38:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4C1B2004D;
	Wed, 24 Apr 2024 05:38:40 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.43.36.209])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 24 Apr 2024 05:38:40 +0000 (GMT)
Date: Wed, 24 Apr 2024 11:08:38 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 RESEND] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
Message-ID: <ualscagnpj54rvn33ncaznp7ibvvqulhrmq46qsg73wokgswxy@naopf7leuk66>
References: <20240402070656.28441-1-gautam@linux.ibm.com>
 <aauzmvtbpgxbr4aa3s4k33cdi7fljs5q4ifn5x2swncz7dtvam@gclohylavkpl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aauzmvtbpgxbr4aa3s4k33cdi7fljs5q4ifn5x2swncz7dtvam@gclohylavkpl>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C7zi8zjiqxMi8-SH39XPWTItqN_jKMMM
X-Proofpoint-GUID: SxTmKj8RKq4IEvFNJv9m-MOtNAsaP0SY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_03,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1011 adultscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240023

On Mon, Apr 22, 2024 at 09:15:02PM +0530, Naveen N Rao wrote:
> On Tue, Apr 02, 2024 at 12:36:54PM +0530, Gautam Menghani wrote:
> > PAPR hypervisor has introduced three new counters in the VPA area of
> > LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> > for context switches from host to guest and vice versa, and 1 counter
> > for getting the total time spent inside the KVM guest. Add a tracepoint
> > that enables reading the counters for use by ftrace/perf. Note that this
> > tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
> > 
> > Also maintain an aggregation of the context switch times in vcpu->arch.
> > This will be useful in getting the aggregate times with a pmu driver
> > which will be upstreamed in the near future.
> 
> It would be better to add code to maintain aggregate times as part of 
> that pmu driver.
> 
> > 
> > [1] Terminology:
> > a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
> > b. L2 refers to the KVM guest booted on top of L1.
> > 
> > Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> > Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> > ---
> > v5 RESEND: 
> > 1. Add the changelog
> > 
> > v4 -> v5:
> > 1. Define helper functions for getting/setting the accumulation counter
> > in L2's VPA
> > 
> > v3 -> v4:
> > 1. After vcpu_run, check the VPA flag instead of checking for tracepoint
> > being enabled for disabling the cs time accumulation.
> > 
> > v2 -> v3:
> > 1. Move the counter disabling and zeroing code to a different function.
> > 2. Move the get_lppaca() inside the tracepoint_enabled() branch.
> > 3. Add the aggregation logic to maintain total context switch time.
> > 
> > v1 -> v2:
> > 1. Fix the build error due to invalid struct member reference.
> > 
> >  arch/powerpc/include/asm/kvm_host.h |  5 ++++
> >  arch/powerpc/include/asm/lppaca.h   | 11 +++++---
> >  arch/powerpc/kvm/book3s_hv.c        | 40 +++++++++++++++++++++++++++++
> >  arch/powerpc/kvm/trace_hv.h         | 25 ++++++++++++++++++
> >  4 files changed, 78 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> > index 8abac532146e..d953b32dd68a 100644
> > --- a/arch/powerpc/include/asm/kvm_host.h
> > +++ b/arch/powerpc/include/asm/kvm_host.h
> > @@ -847,6 +847,11 @@ struct kvm_vcpu_arch {
> >  	gpa_t nested_io_gpr;
> >  	/* For nested APIv2 guests*/
> >  	struct kvmhv_nestedv2_io nestedv2_io;
> > +
> > +	/* Aggregate context switch and guest run time info (in ns) */
> > +	u64 l1_to_l2_cs_agg;
> > +	u64 l2_to_l1_cs_agg;
> > +	u64 l2_runtime_agg;
> 
> Can be dropped from this patch.
> 
> >  #endif
> >  
> >  #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
> > diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
> > index 61ec2447dabf..bda6b86b9f13 100644
> > --- a/arch/powerpc/include/asm/lppaca.h
> > +++ b/arch/powerpc/include/asm/lppaca.h
> > @@ -62,7 +62,8 @@ struct lppaca {
> >  	u8	donate_dedicated_cpu;	/* Donate dedicated CPU cycles */
> >  	u8	fpregs_in_use;
> >  	u8	pmcregs_in_use;
> > -	u8	reserved8[28];
> > +	u8	l2_accumul_cntrs_enable;  /* Enable usage of counters for KVM guest */
> 
> A simpler name - l2_counters_enable or such?
> 
> > +	u8	reserved8[27];
> >  	__be64	wait_state_cycles;	/* Wait cycles for this proc */
> >  	u8	reserved9[28];
> >  	__be16	slb_count;		/* # of SLBs to maintain */
> > @@ -92,9 +93,13 @@ struct lppaca {
> >  	/* cacheline 4-5 */
> >  
> >  	__be32	page_ins;		/* CMO Hint - # page ins by OS */
> > -	u8	reserved12[148];
> > +	u8	reserved12[28];
> > +	volatile __be64 l1_to_l2_cs_tb;
> > +	volatile __be64 l2_to_l1_cs_tb;
> > +	volatile __be64 l2_runtime_tb;
> > +	u8 reserved13[96];
> >  	volatile __be64 dtl_idx;	/* Dispatch Trace Log head index */
> > -	u8	reserved13[96];
> > +	u8	reserved14[96];
> >  } ____cacheline_aligned;
> >  
> >  #define lppaca_of(cpu)	(*paca_ptrs[cpu]->lppaca_ptr)
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 8e86eb577eb8..fea1c1429975 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -4108,6 +4108,37 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >  
> > +static inline int kvmhv_get_l2_accumul(void)
> > +{
> > +	return get_lppaca()->l2_accumul_cntrs_enable;
> > +}
> > +
> > +static inline void kvmhv_set_l2_accumul(int val)
> 					   ^^^
> 					   bool?
> 
> > +{
> > +	get_lppaca()->l2_accumul_cntrs_enable = val;
> > +}
> > +
> > +static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
> > +{
> > +	struct lppaca *lp = get_lppaca();
> > +	u64 l1_to_l2_ns, l2_to_l1_ns, l2_runtime_ns;
> > +
> > +	l1_to_l2_ns = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
> > +	l2_to_l1_ns = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
> > +	l2_runtime_ns = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
> > +	trace_kvmppc_vcpu_exit_cs_time(vcpu, l1_to_l2_ns, l2_to_l1_ns,
> > +					l2_runtime_ns);
> > +	lp->l1_to_l2_cs_tb = 0;
> > +	lp->l2_to_l1_cs_tb = 0;
> > +	lp->l2_runtime_tb = 0;
> > +	kvmhv_set_l2_accumul(0);
> > +
> > +	// Maintain an aggregate of context switch times
> > +	vcpu->arch.l1_to_l2_cs_agg += l1_to_l2_ns;
> > +	vcpu->arch.l2_to_l1_cs_agg += l2_to_l1_ns;
> > +	vcpu->arch.l2_runtime_agg += l2_runtime_ns;
> > +}
> > +
> >  static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> >  				     unsigned long lpcr, u64 *tb)
> >  {
> > @@ -4130,6 +4161,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> >  	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
> >  
> >  	accumulate_time(vcpu, &vcpu->arch.in_guest);
> > +
> > +	/* Enable the guest host context switch time tracking */
> > +	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
> > +		kvmhv_set_l2_accumul(1);
> > +
> >  	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
> >  				  &trap, &i);
> >  
> > @@ -4156,6 +4192,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> >  
> >  	timer_rearm_host_dec(*tb);
> >  
> > +	/* Record context switch and guest_run_time data */
> > +	if (kvmhv_get_l2_accumul())
> > +		do_trace_nested_cs_time(vcpu);
> > +
> >  	return trap;
> >  }
> 
> I'm assuming the counters in VPA are cumulative, since you are zero'ing 
> them out on exit. If so, I think a better way to implement this is to 
> use TRACE_EVENT_FN() and provide tracepoint registration and 
> unregistration functions. You can then enable the counters once during 
> registration and avoid repeated writes to the VPA area. With that, you 
> also won't need to do anything before vcpu entry. If you maintain 
> previous values, you can calculate the delta and emit the trace on vcpu 
> exit. The values in VPA area can then serve as the cumulative values.
> 

This approach will have a problem. The context switch times are reported
in the L1 LPAR's CPU's VPA area. Consider the following scenario:

1. L1 has 2 cpus, and L2 has 1 cpu
2. L2 runs on L1's cpu0 for a few seconds, and the counter values go to
1 million
3. We are maintaining a copy of values of VPA in separate variables, so
those variables also have 1 million.
4. Now if L2's vcpu is migrated to another L1 cpu, that L1 cpu's VPA
counters will start from 0, so if we try to get delta value, we will end
up doing 0 - 1 million, which would be wrong.

The aggregation logic in this patch works as we zero out the VPA after
every switch, and maintain aggregation in a vcpu->arch

Thanks, 
Gautam

