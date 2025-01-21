Return-Path: <kvm+bounces-36151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8A9A18206
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CBBF1882B02
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC1A1F471A;
	Tue, 21 Jan 2025 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tg5AJE8K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A793BBF2;
	Tue, 21 Jan 2025 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737477217; cv=none; b=hqmAPfhjoHRFvbmo35+G/gPzA/ork4nQ2R3qJmWozZnoOpuE0H3zbcrIG4HzgVeb7pP8n4vUKh/SsAB4Ew2029XDfD2IsMUhzIRSVYFVKPM5WiS2Mo1g6K07fRmdp+8lD/eHTbkhydvyqZz9jHMnoMijKZfb72ws5qlSdKF6Dw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737477217; c=relaxed/simple;
	bh=LnqNpn53LWInmijkGHp9IkBD6nuG9rLnV0na/UAZxYg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRUxBPCzlr3NUDrguMhIlQ3TFgHX/uuhtTK2xs9chvTZrI5A4NHhSxMg4MKkhGCDrVIPhd8j4KYvDUG5FYEDGEWu56kdEp9kzLEL9pzuwShixmBoFvJmTDRq6ZhSsD1tMBAz5XqI0R74hYMiTMlMd+GiIvvIc0l5NW46KFZgVIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tg5AJE8K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LF1QW8001329;
	Tue, 21 Jan 2025 16:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wMbbBI
	j7SfvWoKhfG2Dxkoa7tanTflOTdbHHQXTTLog=; b=Tg5AJE8KqySYNRNAXR760k
	I+1isjJxPQcnXZ/dkoODi+VV7qM4cl9akgMF1jcCmM2+7c4RQSsLjB5ifsTbSc8i
	RRCx77qm2Ym6uKOpTha9y4AQYZUCNy422oHT+TmXgjvDfsoqMMdNraPp+CQ0U5ZC
	n4mBh4MF7IJE/YikVO5wNvjoFaqTXOSUcqPWYI8RTG6/1W9ILsyOXJiqtiolZv0G
	HAdGnZoH9Qj1+rnBrJAQ4fWnSkuOG7RdJEvl75w9miMXbIxvZXxKTrrAL2R5wy2k
	oMDn1Zh3rDhvWCtyaKj2tCMmb8I/OLwecPrgTlGzo58UU1EN0+0JKLVCZuGzRCEg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44aduyrfma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:33:23 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LGTscF013737;
	Tue, 21 Jan 2025 16:33:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44aduyrfm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:33:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50LEY8Nr022378;
	Tue, 21 Jan 2025 16:33:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4k3vhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:33:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LGXH5m20906472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 16:33:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F4DB20043;
	Tue, 21 Jan 2025 16:33:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0B5720040;
	Tue, 21 Jan 2025 16:33:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.11.211])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 21 Jan 2025 16:33:16 +0000 (GMT)
Date: Tue, 21 Jan 2025 17:33:13 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>, <david@redhat.com>,
        <willy@infradead.org>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <nrb@linux.ibm.com>,
        <nsg@linux.ibm.com>, <seanjc@google.com>, <seiden@linux.ibm.com>
Subject: Re: [PATCH v3 03/15] KVM: s390: fake memslot for ucontrol VMs
Message-ID: <20250121173313.5a11d992@p-imbrenda>
In-Reply-To: <D7708V1QEO56.SR3N3BFBL4XF@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
	<20250117190938.93793-4-imbrenda@linux.ibm.com>
	<D7708V1QEO56.SR3N3BFBL4XF@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 6TeaMGW1Df4Ab-bvtMfISCaP2QxubN0J
X-Proofpoint-GUID: U6FqVeb9QwjcD58SxT0mudUxn9EnEH-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_07,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501210134

On Mon, 20 Jan 2025 16:27:53 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> > Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
> > userspace.
> >
> > Now memslots will always be present, and ucontrol is not a special case
> > anymore.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> LGTM assuming the triggered warning about the slot_lock can be resolved in
> another patch.
> Tested in G1 and G2 using the ucontrol selftests.
> 
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> 
> > ---
> >  Documentation/virt/kvm/api.rst   |  2 +-
> >  arch/s390/include/asm/kvm_host.h |  2 ++
> >  arch/s390/kvm/kvm-s390.c         | 15 ++++++++++++++-
> >  arch/s390/kvm/kvm-s390.h         |  2 ++
> >  4 files changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index f15b61317aad..cc98115a96d7 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1419,7 +1419,7 @@ fetch) is injected in the guest.
> >  S390:
> >  ^^^^^
> >  
> > -Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
> > +Returns -EINVAL or -EEXIST if the VM has the KVM_VM_S390_UCONTROL flag set.
> >  Returns -EINVAL if called on a protected VM.
> >  
> >  4.36 KVM_SET_TSS_ADDR
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 97c7c8127543..9df37361bc64 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -30,6 +30,8 @@
> >  #define KVM_S390_ESCA_CPU_SLOTS 248
> >  #define KVM_MAX_VCPUS 255
> >  
> > +#define KVM_INTERNAL_MEM_SLOTS 1
> > +
> >  /*
> >   * These seem to be used for allocating ->chip in the routing table, which we
> >   * don't use. 1 is as small as we can get to reduce the needed memory. If we
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index ecbdd7d41230..58cc7f7444e5 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -3428,8 +3428,18 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	VM_EVENT(kvm, 3, "vm created with type %lu", type);
> >  
> >  	if (type & KVM_VM_S390_UCONTROL) {
> > +		struct kvm_userspace_memory_region2 fake_memslot = {
> > +			.slot = KVM_S390_UCONTROL_MEMSLOT,
> > +			.guest_phys_addr = 0,
> > +			.userspace_addr = 0,
> > +			.memory_size = ALIGN_DOWN(TASK_SIZE, _SEGMENT_SIZE),
> > +			.flags = 0,
> > +		};
> > +
> >  		kvm->arch.gmap = NULL;
> >  		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
> > +		/* one flat fake memslot covering the whole address-space */
> > +		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);  
> 
> In the current state of kvm_set_internal_memslot this does not acquire the
> slot_lock and issues a warning. I did bring this up on Seans patch introducing

Oops, I have missed that

> the method. So I assume at this point this here is fine.

not really; I will add proper locking around the call

> 
> >  	} else {
> >  		if (sclp.hamax == U64_MAX)
> >  			kvm->arch.mem_limit = TASK_SIZE_MAX;
> > @@ -5854,7 +5864,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >  {
> >  	gpa_t size;
> >  
> > -	if (kvm_is_ucontrol(kvm))
> > +	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
> >  		return -EINVAL;
> >  
> >  	/* When we are protected, we should not change the memory slots */
> > @@ -5906,6 +5916,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  {
> >  	int rc = 0;
> >  
> > +	if (kvm_is_ucontrol(kvm))
> > +		return;
> > +
> >  	switch (change) {
> >  	case KVM_MR_DELETE:
> >  		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index 597d7a71deeb..30736ac16f84 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -20,6 +20,8 @@
> >  #include <asm/processor.h>
> >  #include <asm/sclp.h>
> >  
> > +#define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
> > +
> >  static inline void kvm_s390_fpu_store(struct kvm_run *run)
> >  {
> >  	fpu_stfpc(&run->s.regs.fpc);  
> 


