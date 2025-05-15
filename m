Return-Path: <kvm+bounces-46682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7BEAB84C8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D409E20CC
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457872989A1;
	Thu, 15 May 2025 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XTd7qGos"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7703F29825E;
	Thu, 15 May 2025 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747308414; cv=none; b=MT2KTkJYtKc/m7JYqGmByXlo20+gWr2CYdkfih2UmMEQRMLNSf+JLc56blQoVvYkhgD3sY9/75CvWiIyJPEM0AGvaRp6wfTsGvRfA9+F0mNkjzLWoCc1Lx+GRhoFenrlfuSQg1r7LFjC4kYnFfv9jfhfE/Xs4YtHXRUn0suyXbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747308414; c=relaxed/simple;
	bh=sCSqye1CMbIlwwAWHQR6doyLo8uJzgF3ORQJM4wh5Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SPfnhX+cTlJDy7JgxhGkEQ1ATAe5WNvJN3qFuIjkoDsBX+6063469Nz2xAOEF1J7doxLNz25fkgkF57sNG7vnDsrPDRgDw5k0GgRBqyJUum0W5C0r9kSFW9KFpUrxV5JeXoY+5OGgTz1YB2+dVs6ConVD0O7hMm1smm2XjY0S2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XTd7qGos; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F7ev79031031;
	Thu, 15 May 2025 11:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EQBfZY
	Pb9R0eMZN+Iw9qTGVR1bht+hZ8qopoxyiBDcQ=; b=XTd7qGosQcZ6zuFpyL4ksF
	iluhY10AwoM76ScksnxtXTsFtD9WDko19ArjI2OTH7gi67uL7pXU6nOH8nvfyimc
	Wa5MEVWQWNlWqSXTHpDoYhNWmwg6zLZosJZllUj1o8CQUUOolkaw9z+hkGSQlVL6
	Z2aCjGm+g308vqKAFeI8IhsJ4PSYQi54Gj76BevYOOl9K5P5SutvqovbXmT8J4ob
	UOsU40RjtM3SbwhRd9EA7F3hQt6EnlRJpxzIIHRQNXMq5aaQ67HOMdCihQI6PSmx
	mPAJ+lr5z9s7bFw5a1Ku8UyJPIg1rSoEsZzmrQGQL2PQCNRu+0+gdhoYSti79KNQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46n0t9c39b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:49 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FAXj4C024288;
	Thu, 15 May 2025 11:26:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfs9w10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FBQixR54198600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 11:26:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9138B20085;
	Thu, 15 May 2025 11:26:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D81120083;
	Thu, 15 May 2025 11:26:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 11:26:44 +0000 (GMT)
Date: Thu, 15 May 2025 13:24:48 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: s390: Always allocate esca_block
Message-ID: <20250515132448.5c03956d@p-imbrenda>
In-Reply-To: <20250514-rm-bsca-v1-2-6c2b065a8680@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
	<20250514-rm-bsca-v1-2-6c2b065a8680@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=etzfzppX c=1 sm=1 tr=0 ts=6825cf7a cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=3Qaq3o0QIONBCY1I0B8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEwOSBTYWx0ZWRfXxX+AsjBAGfZu ZvBF1pY7+QC9milwhmwlUmCg6LmD4ShPt4hpihRQzatN2kO3tCc8KNnG7sB8wvYBKQJo/lX/gIT RBhtWYFmqBFVerfUbn/ZDCU+q5G+5uBFE/Vkc1skD0TMbx/WS/l89Wbwx/RcSyGtiSmzV+HmNyt
 IAPkgYrbM/mE9YHvqEZiRXMktY86HnFftnpPempvguFQlErhYC8vaIwgI8Clietu6sAYjfYMsf7 Vj1JcR/hutzkcBj+bE0TLm+OdurFeettzQ3obsYEavj//LyLCD10mh7EEzSfANGwPOfbS0foeiM YqGvN2x2bLSNsXW8OSF4nsUssR/OrObi3gNQtVeOK9sULifORv8JaA4oHr98kVrYsr9+laKH9b+
 gar7hpAqn576hcsKNiCoVCSSPHraPHKs6i5UNKiOijUiEG3CSOGC6RLpcZBbZxxIqZgxYw/g
X-Proofpoint-ORIG-GUID: vRRh2uTT1xnuDNfoWFWaXOG_iFr0y1Zk
X-Proofpoint-GUID: vRRh2uTT1xnuDNfoWFWaXOG_iFr0y1Zk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150109

On Wed, 14 May 2025 18:34:50 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> Instead of allocating a BSCA and upgrading it for PV or when adding the
> 65th cpu we can always use the ESCA.
> 
> The only downside of the change is that we will always allocate 4 pages
> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
> In return we can delete a bunch of checks and special handling depending
> on the SCA type as well as the whole BSCA to ESCA conversion.
> 
> As a fallback we can still run without SCA entries when the SIGP
> interpretation facility is not available.

s/is/or BSCA are/

> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |   1 -
>  arch/s390/kvm/interrupt.c        |  74 ++++++------------
>  arch/s390/kvm/kvm-s390.c         | 159 ++++++---------------------------------
>  arch/s390/kvm/kvm-s390.h         |   4 +-
>  4 files changed, 47 insertions(+), 191 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f51bac835260f562eaf4bbfd373a24bfdbc43834..d03e354a63d9c931522c1a1607eba8685c24527f 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -631,7 +631,6 @@ struct kvm_s390_pv {
>  
>  struct kvm_arch{
>  	void *sca;
> -	int use_esca;
>  	rwlock_t sca_lock;
>  	debug_info_t *dbf;
>  	struct kvm_s390_float_interrupt float_int;
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 60c360c18690f6b94e8483dab2c25f016451204b..f0aaa234c6c36d70dad477c53840ead1c99d33f5 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -51,21 +51,12 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
>  
>  	BUG_ON(!kvm_s390_use_sca_entries());
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl sigp_ctrl =
> -			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl sigp_ctrl =
> +		sca->cpu[vcpu->vcpu_id].sigp_ctrl;

this ^ fits easily in one line

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
> @@ -80,33 +71,18 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
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
> -
> -		old_val = READ_ONCE(*sigp_ctrl);
> -		new_val.scn = src_id;
> -		new_val.c = 1;
> -		old_val.c = 0;
> -
> -		expect = old_val.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
> -	}
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl *sigp_ctrl =
> +		&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);

this also fits in one line ^ 

> +	union esca_sigp_ctrl new_val = {0}, old_val;
> +
> +	old_val = READ_ONCE(*sigp_ctrl);
> +	new_val.scn = src_id;
> +	new_val.c = 1;
> +	old_val.c = 0;
> +
> +	expect = old_val.value;
> +	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  
>  	if (rc != expect) {
> @@ -123,19 +99,11 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  		return;
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl *sigp_ctrl =
> +		&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);

and this ^

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
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b65e4cbe67cf70a7d614607ebdd679060e7d31f4..d610447dbf2c1caa084bd98eabf19c4ca8f1e972 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -271,7 +271,6 @@ debug_info_t *kvm_s390_dbf_uv;
>  /* forward declarations */
>  static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  			      unsigned long end);
> -static int sca_switch_to_extended(struct kvm *kvm);
>  
>  static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
>  {
> @@ -631,11 +630,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_NR_VCPUS:
>  	case KVM_CAP_MAX_VCPUS:
>  	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_S390_BSCA_CPU_SLOTS;
> +		r = KVM_S390_ESCA_CPU_SLOTS;
>  		if (!kvm_s390_use_sca_entries())
>  			r = KVM_MAX_VCPUS;
> -		else if (sclp.has_esca && sclp.has_64bscao)
> -			r = KVM_S390_ESCA_CPU_SLOTS;
>  		if (ext == KVM_CAP_NR_VCPUS)
>  			r = min_t(unsigned int, num_online_cpus(), r);
>  		else if (ext == KVM_CAP_MAX_VCPU_ID)
> @@ -1932,13 +1929,11 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   * Updates the Multiprocessor Topology-Change-Report bit to signal
>   * the guest with a topology change.
>   * This is only relevant if the topology facility is present.
> - *
> - * The SCA version, bsca or esca, doesn't matter as offset is the same.
>   */
>  static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>  {
>  	union sca_utility new, old;
> -	struct bsca_block *sca;
> +	struct esca_block *sca;
>  
>  	read_lock(&kvm->arch.sca_lock);
>  	sca = kvm->arch.sca;
> @@ -1969,7 +1964,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
>  		return -ENXIO;
>  
>  	read_lock(&kvm->arch.sca_lock);
> -	topo = ((struct bsca_block *)kvm->arch.sca)->utility.mtcr;
> +	topo = ((struct esca_block *)kvm->arch.sca)->utility.mtcr;
>  	read_unlock(&kvm->arch.sca_lock);
>  
>  	return put_user(topo, (u8 __user *)attr->addr);
> @@ -2668,14 +2663,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		if (kvm_s390_pv_is_protected(kvm))
>  			break;
>  
> -		/*
> -		 *  FMT 4 SIE needs esca. As we never switch back to bsca from
> -		 *  esca, we need no cleanup in the error cases below
> -		 */
> -		r = sca_switch_to_extended(kvm);
> -		if (r)
> -			break;
> -
>  		r = s390_disable_cow_sharing();
>  		if (r)
>  			break;
> @@ -3316,10 +3303,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
>  
>  static void sca_dispose(struct kvm *kvm)
>  {
> -	if (kvm->arch.use_esca)
> -		free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
> -	else
> -		free_page((unsigned long)(kvm->arch.sca));
> +	free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
>  	kvm->arch.sca = NULL;
>  }
>  
> @@ -3333,10 +3317,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> -	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
> -	int i, rc;
> +	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
>  	char debug_name[16];
> -	static unsigned long sca_offset;
> +	int i, rc;
>  
>  	rc = -EINVAL;
>  #ifdef CONFIG_KVM_S390_UCONTROL
> @@ -3358,17 +3341,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (!sclp.has_64bscao)
>  		alloc_flags |= GFP_DMA;
>  	rwlock_init(&kvm->arch.sca_lock);
> -	/* start with basic SCA */
> -	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
> -	if (!kvm->arch.sca)
> -		goto out_err;
>  	mutex_lock(&kvm_lock);
> -	sca_offset += 16;
> -	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
> -		sca_offset = 0;
> -	kvm->arch.sca = (struct bsca_block *)
> -			((char *) kvm->arch.sca + sca_offset);
> +
> +	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
>  	mutex_unlock(&kvm_lock);
> +	if (!kvm->arch.sca)
> +		goto out_err;
>  
>  	sprintf(debug_name, "kvm-%u", current->pid);
>  
> @@ -3550,17 +3528,10 @@ static void sca_del_vcpu(struct kvm_vcpu *vcpu)
>  	if (!kvm_s390_use_sca_entries())
>  		return;
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -
> -		clear_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);
> -		sca->cpu[vcpu->vcpu_id].sda = 0;
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
>  
> -		clear_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
> -		sca->cpu[vcpu->vcpu_id].sda = 0;
> -	}
> +	clear_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);

didn't checkpatch complain about the unnecessary space ^ in the cast?

> +	sca->cpu[vcpu->vcpu_id].sda = 0;
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  
> @@ -3575,105 +3546,23 @@ static void sca_add_vcpu(struct kvm_vcpu *vcpu)
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
> +
> +	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
> +	vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> +	vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
> +	set_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);

same here                                          ^^^

>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  
> -/* Basic SCA to Extended SCA data copy routines */
> -static inline void sca_copy_entry(struct esca_entry *d, struct bsca_entry *s)
> -{
> -	d->sda = s->sda;
> -	d->sigp_ctrl.c = s->sigp_ctrl.c;
> -	d->sigp_ctrl.scn = s->sigp_ctrl.scn;
> -}
> -
> -static void sca_copy_b_to_e(struct esca_block *d, struct bsca_block *s)
> -{
> -	int i;
> -
> -	d->ipte_control = s->ipte_control;
> -	d->mcn[0] = s->mcn;
> -	for (i = 0; i < KVM_S390_BSCA_CPU_SLOTS; i++)
> -		sca_copy_entry(&d->cpu[i], &s->cpu[i]);
> -}
> -
> -static int sca_switch_to_extended(struct kvm *kvm)
> -{
> -	struct bsca_block *old_sca = kvm->arch.sca;
> -	struct esca_block *new_sca;
> -	struct kvm_vcpu *vcpu;
> -	unsigned long vcpu_idx;
> -	u32 scaol, scaoh;
> -	phys_addr_t new_sca_phys;
> -
> -	if (kvm->arch.use_esca)
> -		return 0;
> -
> -	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> -	if (!new_sca)
> -		return -ENOMEM;
> -
> -	new_sca_phys = virt_to_phys(new_sca);
> -	scaoh = new_sca_phys >> 32;
> -	scaol = new_sca_phys & ESCA_SCAOL_MASK;
> -
> -	kvm_s390_vcpu_block_all(kvm);
> -	write_lock(&kvm->arch.sca_lock);
> -
> -	sca_copy_b_to_e(new_sca, old_sca);
> -
> -	kvm_for_each_vcpu(vcpu_idx, vcpu, kvm) {
> -		vcpu->arch.sie_block->scaoh = scaoh;
> -		vcpu->arch.sie_block->scaol = scaol;
> -		vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
> -	}
> -	kvm->arch.sca = new_sca;
> -	kvm->arch.use_esca = 1;
> -
> -	write_unlock(&kvm->arch.sca_lock);
> -	kvm_s390_vcpu_unblock_all(kvm);
> -
> -	free_page((unsigned long)old_sca);
> -
> -	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
> -		 old_sca, kvm->arch.sca);
> -	return 0;
> -}
> -
>  static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
>  {
> -	int rc;
> -
> -	if (!kvm_s390_use_sca_entries()) {
> -		if (id < KVM_MAX_VCPUS)
> -			return true;
> -		return false;
> -	}
> -	if (id < KVM_S390_BSCA_CPU_SLOTS)
> -		return true;
> -	if (!sclp.has_esca || !sclp.has_64bscao)
> -		return false;
> -
> -	rc = kvm->arch.use_esca ? 0 : sca_switch_to_extended(kvm);
> +	if (!kvm_s390_use_sca_entries())
> +		return id < KVM_MAX_VCPUS;
>  
> -	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
> +	return id < KVM_S390_ESCA_CPU_SLOTS;
>  }
>  
>  /* needs disabled preemption to protect from TOD sync and vcpu_load/put */
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 8d3bbb2dd8d27802bbde2a7bd1378033ad614b8e..2c8e177e4af8f2dab07fd42a904cefdea80f6855 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -531,7 +531,7 @@ int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
>  /* support for Basic/Extended SCA handling */
>  static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
>  {
> -	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +	struct esca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>  
>  	return &sca->ipte_control;
>  }
> @@ -542,7 +542,7 @@ static inline int kvm_s390_use_sca_entries(void)
>  	 * might use the entries. By not setting the entries and keeping them
>  	 * invalid, hardware will not access them but intercept.
>  	 */
> -	return sclp.has_sigpif;
> +	return sclp.has_sigpif && sclp.has_esca;
>  }
>  void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>  				     struct mcck_volatile_info *mcck_info);
> 


