Return-Path: <kvm+bounces-48560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C286CACF3F7
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7E8F3AE55B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15726266B46;
	Thu,  5 Jun 2025 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ew0/i292"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDC21F5820;
	Thu,  5 Jun 2025 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140239; cv=none; b=jUPYr7Ak1q3WBS2l9KpH65Ae+hZpCBl8BzFFo+nAPRQCnfhKDXVCktUhv5iBMGU3TEHEVDM71PFnEg9XqicjJmwcck8Ab5CZG90BAbhkaB3pWy0dPvQsfcPlbXm7PuK+ysVNDDyeXrKHwS7ZAY2i14he+Bd9z+3bFoG59OKyotw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140239; c=relaxed/simple;
	bh=a+5CBEd0YPRZimQ9ms38R8g3r3/O29i2/UV0PmoSIkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3bC8k6lwD68Eop1ZZrSvSwwY4747TsTe4Jgn6aVOCnh+8u+A2bmDhroFzycNXp2OygiP9ftvyHBpJUKD5z097CKKaUW698nnUag99g3CF7HW6Lb4eGoVW26TvUsgHVucDBG9SLKeHbd4PxcYvQRf8fsZgw5OwZpc4443xdbnzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ew0/i292; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555FlheK027919;
	Thu, 5 Jun 2025 16:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oRdufP
	0BglRM0t3EOGt6HuKx16e6UkiKVvx1vFagvpc=; b=ew0/i292c/G4EmDe5UcV1s
	MmiKyH7yl0ibUCvGHo2MtnkCaqjCJGfaVawGiLFOyGmDZvx8sqZGeK+bE2YqsEHq
	iCi0jwtXQeyuo7qnE+UOjf4Jji9s+HMLAfRF2XupLS3Drv+IEA2zjTfGaMkGJhlo
	JpSq2T+MvK/NF1IudnBYk9G8cgXmY0C/z/IgV+uYr2blpXLp2bLCvHXq1+yUWyHv
	r12nkAMuP+mWzpjIQlRWD/4rDn30PYYg/QG66C3g5hXC4Y5GVVBMDkraJCJdF30N
	K3qlA6fNhCBVqwD+gF2bRyxA5fptlCNkrrYwSWzeG1FmKtJ3Ep1/+DTR2sxvIq7g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyhukb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 16:17:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 555CZRjJ019898;
	Thu, 5 Jun 2025 16:17:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3p5ftt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 16:17:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555GH77N51708228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 16:17:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5824620043;
	Thu,  5 Jun 2025 16:17:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F282720040;
	Thu,  5 Jun 2025 16:17:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 16:17:06 +0000 (GMT)
Date: Thu, 5 Jun 2025 18:17:05 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v7] KVM: s390: Use ESCA instead of BSCA at VM init
Message-ID: <20250605181705.09f8a6a4@p-imbrenda>
In-Reply-To: <20250605-rm-bsca-v7-1-ed745b8bbec5@linux.ibm.com>
References: <20250605-rm-bsca-v7-1-ed745b8bbec5@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=ea09f6EH c=1 sm=1 tr=0 ts=6841c308 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=End42GNo6ReAM-s5ObYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: f4uVEEiIxUWpthgnN1TIH76tWfx2_Bc9
X-Proofpoint-ORIG-GUID: f4uVEEiIxUWpthgnN1TIH76tWfx2_Bc9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDE0MCBTYWx0ZWRfX5G8C1mJywHdI TSfcJ8LCRQn/9uiFsHk0mBSZkyOTWfLlN20zYXjO3F0TzWvJaeCQKwhIWj4IcZa9J7eYLyWqaCi TyiELRBDWqqCekG6dbHqG5fRQJfKi7rGaNefSQdC0McI0hlfjb+iwvXouPLfYLqXJdbKpkl1fzm
 koHehgOld8KyM4wKcNzx0z+jwSeHZt6QvaMZRPu1bYVhgGisAo4k1dHp/oe+UUDTO/yAmazxXeW biN9Zy+ZNhVwSVFXBm6i+DiZpEV/Q6bzzmPfFjJqlTXbhx4cRa9YnMBnEWOXlS6UU01q6bFl18V mm+XpKMePSoQLhs9FxQpfp23LFKcBt5AguVh7X8gTcReHS1VIGd6/ApywyhhszwNe6zDyKqlRWx
 tCGs5ZDdCwMZmxVw++8rnZyGxaj86pmajAReisSODHga2JrvXkX44Bb2PrO+4X1Ck2aeeYKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_04,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050140

On Thu, 05 Jun 2025 18:02:45 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> All modern IBM Z and Linux One machines do offer support for the
> Extended System Control Area (ESCA). The ESCA is available since the
> z114/z196 released in 2010.
> KVM needs to allocate and manage the SCA for guest VMs. Prior to this
> change the SCA was setup as Basic SCA only supporting a maximum of 64
> vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
> was needed to be converted to a ESCA.
> 
> Instead of allocating a BSCA and upgrading it for PV or when adding the
> 65th cpu we can always allocate the ESCA directly upon VM creation
> simplifying the code in multiple places as well as completely removing
> the need to convert an existing SCA.
> 
> In cases where the ESCA is not supported (z10 and earlier) the use of
> the SCA entries and with that SIGP interpretation are disabled for VMs.
> This increases the number of exits from the VM in multiprocessor
> scenarios and thus decreases performance.
> The same is true for VSIE where SIGP is currently disabled and thus no
> SCA entries are used.
> 
> The only downside of the change is that we will always allocate 4 pages
> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
> In return we can delete a bunch of checks and special handling depending
> on the SCA type as well as the whole BSCA to ESCA conversion.
> 
> With that behavior change we are no longer referencing a bsca_block in
> kvm->arch.sca. This will always be esca_block instead.
> By specifying the type of the sca as esca_block we can simplify access
> to the sca and get rid of some helpers while making the code clearer.
> 
> KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
> future type definitions.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> Changes in v7:
> - Move the previously missed variable declaration to the top of the
>   function (Thanks Claudio)
> - Link to v6: https://lore.kernel.org/r/20250605-rm-bsca-v6-1-21902b8bd579@linux.ibm.com
> 
> Changes in v6:
> - Move variable declarations to top of functions
> - Link to v5: https://lore.kernel.org/r/20250603-rm-bsca-v5-1-f691288ada5c@linux.ibm.com
> 
> Changes in v5:
> - Revert changes to KVM_MAX_VCPUS
> - Correct comments
> - Link to v4: https://lore.kernel.org/r/20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com
> 
> Changes in v4:
> - Squash patches into single patch
> - Revert KVM_CAP_MAX_VCPUS to return KVM_CAP_MAX_VCPU_ID (255) again
> - Link to v3: https://lore.kernel.org/r/20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com
> 
> Changes in v3:
> - do not enable sigp for guests when kvm_s390_use_sca_entries() is false
>   - consistently use kvm_s390_use_sca_entries() instead of sclp.has_sigpif
> - Link to v2: https://lore.kernel.org/r/20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com
> 
> Changes in v2:
> - properly apply checkpatch --strict (Thanks Claudio)
> - some small comment wording changes
> - rebased
> - Link to v1: https://lore.kernel.org/r/20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com
> ---
>  arch/s390/include/asm/kvm_host.h |   5 +-
>  arch/s390/kvm/gaccess.c          |  10 +--
>  arch/s390/kvm/interrupt.c        |  78 ++++++------------
>  arch/s390/kvm/kvm-s390.c         | 172 ++++++++-------------------------------
>  arch/s390/kvm/kvm-s390.h         |   9 +-
>  5 files changed, 68 insertions(+), 206 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..4d651e6e8b12ecd7796070e9da659b0b2b94d302 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -631,9 +631,8 @@ struct kvm_s390_pv {
>  	struct mmu_notifier mmu_notifier;
>  };
>  
> -struct kvm_arch{
> -	void *sca;
> -	int use_esca;
> +struct kvm_arch {
> +	struct esca_block *sca;
>  	rwlock_t sca_lock;
>  	debug_info_t *dbf;
>  	struct kvm_s390_float_interrupt float_int;
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index e23670e1949cfe3b2b3f54fe68c4c1b642f56e60..586c0c5ecf131c2298e662aa85d4c9ae127738d9 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -113,7 +113,7 @@ int ipte_lock_held(struct kvm *kvm)
>  		int rc;
>  
>  		read_lock(&kvm->arch.sca_lock);
> -		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
> +		rc = kvm->arch.sca->ipte_control.kh != 0;
>  		read_unlock(&kvm->arch.sca_lock);
>  		return rc;
>  	}
> @@ -130,7 +130,7 @@ static void ipte_lock_simple(struct kvm *kvm)
>  		goto out;
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		if (old.k) {
> @@ -155,7 +155,7 @@ static void ipte_unlock_simple(struct kvm *kvm)
>  	if (kvm->arch.ipte_lock_count)
>  		goto out;
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		new = old;
> @@ -173,7 +173,7 @@ static void ipte_lock_siif(struct kvm *kvm)
>  
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		if (old.kg) {
> @@ -193,7 +193,7 @@ static void ipte_unlock_siif(struct kvm *kvm)
>  	union ipte_control old, new, *ic;
>  
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		new = old;
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 60c360c18690f6b94e8483dab2c25f016451204b..f2d29c99253b6f2e804ebc9055ac5447efb9a427 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -44,6 +44,8 @@ static struct kvm_s390_gib *gib;
>  /* handle external calls via sigp interpretation facility */
>  static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
>  {
> +	union esca_sigp_ctrl sigp_ctrl;
> +	struct esca_block *sca;
>  	int c, scn;
>  
>  	if (!kvm_s390_test_cpuflags(vcpu, CPUSTAT_ECALL_PEND))
> @@ -51,21 +53,11 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
>  
>  	BUG_ON(!kvm_s390_use_sca_entries());
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl sigp_ctrl =
> -			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> +	sca = vcpu->kvm->arch.sca;
> +	sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
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
> @@ -76,37 +68,23 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
>  
>  static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  {
> +	union esca_sigp_ctrl old_val, new_val = {0};
> +	union esca_sigp_ctrl *sigp_ctrl;
> +	struct esca_block *sca;
>  	int expect, rc;
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
> +	sca = vcpu->kvm->arch.sca;
> +	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
>  
> -		old_val = READ_ONCE(*sigp_ctrl);
> -		new_val.scn = src_id;
> -		new_val.c = 1;
> -		old_val.c = 0;
> +	old_val = READ_ONCE(*sigp_ctrl);
> +	new_val.scn = src_id;
> +	new_val.c = 1;
> +	old_val.c = 0;
>  
> -		expect = old_val.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
> -	}
> +	expect = old_val.value;
> +	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  
>  	if (rc != expect) {
> @@ -119,23 +97,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  
>  static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
>  {
> +	union esca_sigp_ctrl *sigp_ctrl;
> +	struct esca_block *sca;
> +
>  	if (!kvm_s390_use_sca_entries())
>  		return;
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
>  	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -
> -		WRITE_ONCE(sigp_ctrl->value, 0);
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		union bsca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> +	sca = vcpu->kvm->arch.sca;
> +	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
>  
> -		WRITE_ONCE(sigp_ctrl->value, 0);
> -	}
> +	WRITE_ONCE(sigp_ctrl->value, 0);
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  
> @@ -1223,7 +1195,7 @@ int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
>  
> -	if (!sclp.has_sigpif)
> +	if (!kvm_s390_use_sca_entries())
>  		return test_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs);
>  
>  	return sca_ext_call_pending(vcpu, NULL);
> @@ -1547,7 +1519,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
>  	if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) == NULL)
>  		return -EINVAL;
>  
> -	if (sclp.has_sigpif && !kvm_s390_pv_cpu_get_handle(vcpu))
> +	if (kvm_s390_use_sca_entries() && !kvm_s390_pv_cpu_get_handle(vcpu))
>  		return sca_inject_ext_call(vcpu, src_id);
>  
>  	if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d5ad10791c25fa0939d61b3c4187a108b1ded1b1..93b0497c7618e34009b15d291e33dc425e46992f 100644
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
> @@ -631,11 +630,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_NR_VCPUS:
>  	case KVM_CAP_MAX_VCPUS:
>  	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_S390_BSCA_CPU_SLOTS;
> +		/*
> +		 * Return the same value for KVM_CAP_MAX_VCPUS and
> +		 * KVM_CAP_MAX_VCPU_ID to conform with the KVM API.
> +		 */
> +		r = KVM_S390_ESCA_CPU_SLOTS;
>  		if (!kvm_s390_use_sca_entries())
>  			r = KVM_MAX_VCPUS;
> -		else if (sclp.has_esca && sclp.has_64bscao)
> -			r = KVM_S390_ESCA_CPU_SLOTS;
>  		if (ext == KVM_CAP_NR_VCPUS)
>  			r = min_t(unsigned int, num_online_cpus(), r);
>  		break;
> @@ -1930,13 +1931,11 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
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
> @@ -1967,7 +1966,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
>  		return -ENXIO;
>  
>  	read_lock(&kvm->arch.sca_lock);
> -	topo = ((struct bsca_block *)kvm->arch.sca)->utility.mtcr;
> +	topo = kvm->arch.sca->utility.mtcr;
>  	read_unlock(&kvm->arch.sca_lock);
>  
>  	return put_user(topo, (u8 __user *)attr->addr);
> @@ -2666,14 +2665,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
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
>  		mmap_write_lock(kvm->mm);
>  		r = gmap_helper_disable_cow_sharing();
>  		mmap_write_unlock(kvm->mm);
> @@ -3316,10 +3307,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
>  
>  static void sca_dispose(struct kvm *kvm)
>  {
> -	if (kvm->arch.use_esca)
> -		free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
> -	else
> -		free_page((unsigned long)(kvm->arch.sca));
> +	free_pages_exact(kvm->arch.sca, sizeof(*kvm->arch.sca));
>  	kvm->arch.sca = NULL;
>  }
>  
> @@ -3333,10 +3321,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
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
> @@ -3358,17 +3345,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
> @@ -3547,27 +3529,25 @@ static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  static void sca_del_vcpu(struct kvm_vcpu *vcpu)
>  {
> +	struct esca_block *sca;
> +
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
> +	sca = vcpu->kvm->arch.sca;
>  
> -		clear_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
> -		sca->cpu[vcpu->vcpu_id].sda = 0;
> -	}
> +	clear_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
> +	sca->cpu[vcpu->vcpu_id].sda = 0;
>  	read_unlock(&vcpu->kvm->arch.sca_lock);
>  }
>  
>  static void sca_add_vcpu(struct kvm_vcpu *vcpu)
>  {
> +	struct esca_block *sca;
> +	phys_addr_t sca_phys;
> +
>  	if (!kvm_s390_use_sca_entries()) {
> -		phys_addr_t sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
> +		sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
>  
>  		/* we still need the basic sca for the ipte control */
>  		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> @@ -3575,105 +3555,23 @@ static void sca_add_vcpu(struct kvm_vcpu *vcpu)
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
> +	sca = vcpu->kvm->arch.sca;
> +	sca_phys = virt_to_phys(sca);
> +
> +	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
> +	vcpu->arch.sie_block->scaoh = sca_phys >> 32;
> +	vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
> +	set_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
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
> @@ -3919,7 +3817,7 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->eca |= ECA_IB;
>  	if (sclp.has_siif)
>  		vcpu->arch.sie_block->eca |= ECA_SII;
> -	if (sclp.has_sigpif)
> +	if (kvm_s390_use_sca_entries())
>  		vcpu->arch.sie_block->eca |= ECA_SIGPI;
>  	if (test_kvm_facility(vcpu->kvm, 129)) {
>  		vcpu->arch.sie_block->eca |= ECA_VX;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c44fe0c3a097cf12af23fa2293411110d957e136..65c950760993467398b68f3763d6f81f52c52385 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -570,13 +570,6 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_per_ifetch_icpt(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
>  
> -/* support for Basic/Extended SCA handling */
> -static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
> -{
> -	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> -
> -	return &sca->ipte_control;
> -}
>  static inline int kvm_s390_use_sca_entries(void)
>  {
>  	/*
> @@ -584,7 +577,7 @@ static inline int kvm_s390_use_sca_entries(void)
>  	 * might use the entries. By not setting the entries and keeping them
>  	 * invalid, hardware will not access them but intercept.
>  	 */
> -	return sclp.has_sigpif;
> +	return sclp.has_sigpif && sclp.has_esca;
>  }
>  void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>  				     struct mcck_volatile_info *mcck_info);
> 
> ---
> base-commit: ec7714e4947909190ffb3041a03311a975350fe0
> change-id: 20250513-rm-bsca-ab1e8649aca7
> 
> Best regards,


