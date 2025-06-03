Return-Path: <kvm+bounces-48304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FE5ACC9ED
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D8B1167FB1
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACE3239E9A;
	Tue,  3 Jun 2025 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ccTWJo/f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26030231858;
	Tue,  3 Jun 2025 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748963764; cv=none; b=FvbLdwlDfn93AtDU9vhH4/k2s56HgidgpTWYV88wAeD35r1Xm+p9ezlOG6kBiPLdspUOBC0ngg7sv2iJfQqJlDv2wr6Etuq5xnnWnUtS7pd/uJSyqlzFlr522m1h5dU9jZASa+meGIRzp8TRIM8uTdtVlO4+p9RJyCJJR7yiZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748963764; c=relaxed/simple;
	bh=hWxKhp/QZ+g5JaMXxpj6QglF6pPm1MdLwa0y6VsruH4=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=hD7Rs4l5nyidFqL1F5tGHibSSvcPUg9cguUZz+JDNq29X8p+jNaM0ASPP640OFFkV9856QhpHsBheI/XIrOPB+LOsT7Y7i5slXM3+Rx6L7caBUQ4IiEzPCjbTQjndgTjVmAP56YHebWVwwag2Kxs4skJMTHGqkh2jJks3e4tgl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ccTWJo/f; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553EbbT5021901;
	Tue, 3 Jun 2025 15:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DlGsjX
	vxHesb9jjqEX+Dxtje4bTp5Nz06XlwkQyRZ34=; b=ccTWJo/fEY60alyOhJAlDg
	toEJwo28gPh++7I9OdlrIwLsT7hN1tMmVYDsrpxOajj6kUOleiLHt4CzHqpW4PeR
	0zwkUFZipyqepjvJNrbxnvH+iZGckVvsvYridZxIJqbxWsO0rxnTj+iMDYxopW4f
	I5OPLRk3b3mrQvwuNAJvb/ixqR3CzNEyE4MN9YmZRyLQAi82rUAy6mWH00hbn9ts
	OCy91EMv9Ck/nNL+2Vw6myFi7ra3v3ZxLOdDEaF3D/I3+f4bGk+NIGjs4VrSnZ1A
	j1o/Ba0oovcCFwvF2ordjn+KbjlpE9I7jT/rIsCC8s/ca+wrmgUBVHVX/povg5rA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geynbt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 15:15:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553DodV5019937;
	Tue, 3 Jun 2025 15:15:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3nue6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 15:15:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553FFsLT45220306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 15:15:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7207720043;
	Tue,  3 Jun 2025 15:15:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4852820040;
	Tue,  3 Jun 2025 15:15:54 +0000 (GMT)
Received: from darkmoore (unknown [9.111.76.199])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 15:15:54 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jun 2025 17:15:48 +0200
Message-Id: <DACZWMCFS5UU.1V5UZ9VOIW0ZI@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Thomas Huth" <thuth@redhat.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: s390: Use ESCA instead of BSCA at VM init
X-Mailer: aerc 0.20.1
References: <20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com>
 <9ad4aabc-45cb-413f-9899-9b7ffab8f4fe@linux.ibm.com>
In-Reply-To: <9ad4aabc-45cb-413f-9899-9b7ffab8f4fe@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=683f11af cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=_JrKV18gpX0JAoxt0bQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDEzMSBTYWx0ZWRfX7mcPqOtdL9kH W3zA52jJkdM9qlNS9ltyY8FCTOH6Tt2Iaf8ud53WSH/I/YsuGHS6nyckQfznO6ucJI0K8osrrKX HX8vetfVbwTBAcAYGj7MKNodVx4KMMaLhstHw6EjyCpLbqvseI2di3NSaSDDuOuNE3dqDRnwVX1
 bFIS4kwucLmMGVhE/XNow1kssEjDuGCAsW8XRPXVLhMvc0/l99Jf3wvmqrwtVLUY2AHLThnyurT mBvewxD1+8FUhCFDBpWJRiPLyFVdEyJ5v/P2poISwHuptvzNh0bJJiFbMVhiE0K87WhITHqaIFj G83ccnaObFALYf7VbH98H7FCUQSA5ClXi9tRlo0dDAx9etqJ/nWqexuDUUAxIRX2XmMML1YS7Ix
 EoxuINiivTSGbJkzNSVVsrMaW5NgFxi3P1RClpUovXAcf8YLKXE5gV35XwWADPnOBEU2Nvqw
X-Proofpoint-GUID: Bltw_ciIuSMWMJj3fUSUJ9IxsRFxNVRl
X-Proofpoint-ORIG-GUID: Bltw_ciIuSMWMJj3fUSUJ9IxsRFxNVRl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030131

On Tue Jun 3, 2025 at 10:48 AM CEST, Janosch Frank wrote:
> On 6/2/25 6:34 PM, Christoph Schlameuss wrote:
>> All modern IBM Z and Linux One machines do offer support for the
>> Extended System Control Area (ESCA). The ESCA is available since the
>> z114/z196 released in 2010.
>> KVM needs to allocate and manage the SCA for guest VMs. Prior to this
>> change the SCA was setup as Basic SCA only supporting a maximum of 64
>> vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
>> was needed to be converted to a ESCA.
>>=20
>> Instead of allocating a BSCA and upgrading it for PV or when adding the
>> 65th cpu we can always allocate the ESCA directly upon VM creation
>> simplifying the code in multiple places as well as completely removing
>> the need to convert an existing SCA.
>>=20
>> In cases where the ESCA is not supported (z10 and earlier) the use of
>> the SCA entries and with that SIGP interpretation are disabled for VMs.
>> This increases the number of exits from the VM in multiprocessor
>> scenarios and thus decreases performance.
>> The same is true for VSIE where SIGP is currently disabled and thus no
>> SCA entries are used.
>>=20
>> The only downside of the change is that we will always allocate 4 pages
>> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
>> In return we can delete a bunch of checks and special handling depending
>> on the SCA type as well as the whole BSCA to ESCA conversion.
>>=20
>> With that behavior change we are no longer referencing a bsca_block in
>> kvm->arch.sca. This will always be esca_block instead.
>> By specifying the type of the sca as esca_block we can simplify access
>> to the sca and get rid of some helpers while making the code clearer.
>>=20
>> KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
>> future type definitions.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>> Changes in v4:
>> - Squash patches into single patch
>> - Revert KVM_CAP_MAX_VCPUS to return KVM_CAP_MAX_VCPU_ID (255) again
>> - Link to v3: https://lore.kernel.org/r/20250522-rm-bsca-v3-0-51d169738f=
cf@linux.ibm.com
>>=20
>> Changes in v3:
>> - do not enable sigp for guests when kvm_s390_use_sca_entries() is false
>>    - consistently use kvm_s390_use_sca_entries() instead of sclp.has_sig=
pif
>> - Link to v2: https://lore.kernel.org/r/20250519-rm-bsca-v2-0-e3ea53dd03=
94@linux.ibm.com
>>=20
>> Changes in v2:
>> - properly apply checkpatch --strict (Thanks Claudio)
>> - some small comment wording changes
>> - rebased
>> - Link to v1: https://lore.kernel.org/r/20250514-rm-bsca-v1-0-6c2b065a86=
80@linux.ibm.com
>> ---
>>   arch/s390/include/asm/kvm_host.h       |   7 +-
>>   arch/s390/include/asm/kvm_host_types.h |   2 +
>>   arch/s390/kvm/gaccess.c                |  10 +-
>>   arch/s390/kvm/interrupt.c              |  71 ++++----------
>>   arch/s390/kvm/kvm-s390.c               | 167 ++++++-------------------=
--------
>>   arch/s390/kvm/kvm-s390.h               |   9 +-
>>   6 files changed, 58 insertions(+), 208 deletions(-)
>>=20
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..2a2b557357c8e40c82022eb3=
38c3e98aa8f03a2b 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -27,8 +27,6 @@
>>   #include <asm/isc.h>
>>   #include <asm/guarded_storage.h>
>>  =20
>> -#define KVM_MAX_VCPUS 255
>> -
>>   #define KVM_INTERNAL_MEM_SLOTS 1
>>  =20
>>   /*
>> @@ -631,9 +629,8 @@ struct kvm_s390_pv {
>>   	struct mmu_notifier mmu_notifier;
>>   };
>>  =20
>> -struct kvm_arch{
>> -	void *sca;
>> -	int use_esca;
>> +struct kvm_arch {
>> +	struct esca_block *sca;
>>   	rwlock_t sca_lock;
>>   	debug_info_t *dbf;
>>   	struct kvm_s390_float_interrupt float_int;
>> diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/=
asm/kvm_host_types.h
>> index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f=
85b4b974c344769a 100644
>> --- a/arch/s390/include/asm/kvm_host_types.h
>> +++ b/arch/s390/include/asm/kvm_host_types.h
>> @@ -6,6 +6,8 @@
>>   #include <linux/atomic.h>
>>   #include <linux/types.h>
>>  =20
>> +#define KVM_MAX_VCPUS 256
>
> Why are we doing the whole 256 - 1 game?
>

I guess that was just me trying to force it to have the proper number there=
. But
you are right, that is moot. I will revert that.

>> +
>>   #define KVM_S390_BSCA_CPU_SLOTS 64
>
> Can't you remove that now?
>

Sadly no. That is still needed along with struct bsca_block to have bsca
support in vsie sigp.

>>   #define KVM_S390_ESCA_CPU_SLOTS 248
>>  =20
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index f6fded15633ad87f6b02c2c42aea35a3c9164253..ee37d397d9218a4d33c7a33b=
d877d0b974ca9003 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -112,7 +112,7 @@ int ipte_lock_held(struct kvm *kvm)
>>   		int rc;
>>  =20
>>   		read_lock(&kvm->arch.sca_lock);
>> -		rc =3D kvm_s390_get_ipte_control(kvm)->kh !=3D 0;
>> +		rc =3D kvm->arch.sca->ipte_control.kh !=3D 0;
>>   		read_unlock(&kvm->arch.sca_lock);
>>   		return rc;
>>   	}
>
> [...]
>
>> -static int sca_switch_to_extended(struct kvm *kvm);
>>  =20
>>   static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 del=
ta)
>>   {
>> @@ -631,11 +630,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
>>   	case KVM_CAP_NR_VCPUS:
>>   	case KVM_CAP_MAX_VCPUS:
>>   	case KVM_CAP_MAX_VCPU_ID:
>> -		r =3D KVM_S390_BSCA_CPU_SLOTS;
>> +		/*
>> +		 * Return the same value for KVM_CAP_MAX_VCPUS and
>> +		 * KVM_CAP_MAX_VCPU_ID to pass the kvm_create_max_vcpus selftest.
>> +		 */
>> +		r =3D KVM_S390_ESCA_CPU_SLOTS;
>
> We're not doing this to pass the test, we're doing this to adhere to the=
=20
> KVM API. Yes, the API document explains it with one indirection but it=20
> is in there.
>
> The whole KVM_CAP_MAX_VCPU_ID problem will pop up in the future since we=
=20
> can't change the caps name. We'll have to live with it.

Let me just clarify the comment then. But hopefully that comment will be he=
lpful
to the next one trying this.

