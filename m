Return-Path: <kvm+bounces-48279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D67DBACC261
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 10:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09CE218919B2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43D61917ED;
	Tue,  3 Jun 2025 08:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kj4C9eWc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEA426ADD;
	Tue,  3 Jun 2025 08:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748940500; cv=none; b=ReFGPKIV9sYG4CMHgnNkiDVKfN5d1QTL+OsJ8HRDslypDvDRIMiB+nj7fyBGkro2KT28qK+JPBLE/PdzWbxc0UOZfoL9ye3kVcqA9CLrOECVAtIBCV1DFWpcpZXa80BNNmPVQ1zQFvykC/LHYhFHZ3eAUA0HjBzjQsUJYH7oKRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748940500; c=relaxed/simple;
	bh=yaZR3tuQixU0UHqFOOf0bigijIaN27fn690ctCKTkFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtRYHIZP3o2Lg8tjr5O27hnBkBj8C9nW5g9YRrsadLZtSXucWIuqwxq8kpM4F8LQR5vpVSpmOe3+0wotiSEt1ScAh8T6sZtae9mkf3iNFRqJZcrobW7U3SvDFnlYBrmSehduq2Efqxfu1EOo8tjEB/Xyfj6FovJhL51dk648bV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kj4C9eWc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5535f8Mf020238;
	Tue, 3 Jun 2025 08:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=27xia/
	7nl+MOoJN3RGOCYnVmlNQBCCZEDjNeoa/FPAk=; b=kj4C9eWcy5Adx3TpiKAMr2
	t81fwhgDLaIUiF9cMkgDjIrbuU8KiqWc8FhBWraLveIJhcz4Vs31IB3ddM+w2w9i
	R4RI4BpzvKVGz11yrxD0uaqOkeeXo4tNZJnjhXyF7At6cY+hFaWThJCTERp1If0l
	zEmhDW/WRsiuWeRWExDJ5m4qVQUpO1z4cHzt4d/wWWlcjDmFKkRW8vIzak2KmWY2
	vkEsHLk+D5bvuCg2BGK7ijwXtDmu023THikTlw2bGf/6U7UM8LHn0iv7cq506LlO
	9kAAL0+ti7rTIcleXEqlBdIIP3a+7fsmkLfdw1dchZsL16hsV8RPQwJnQVm8ZGLQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyk822-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 08:48:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5535ZmOd028431;
	Tue, 3 Jun 2025 08:48:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 470eak9q7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 08:48:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5538m9Ud43122976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 08:48:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC6AB20049;
	Tue,  3 Jun 2025 08:48:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 701EA20040;
	Tue,  3 Jun 2025 08:48:09 +0000 (GMT)
Received: from [9.111.36.10] (unknown [9.111.36.10])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 08:48:09 +0000 (GMT)
Message-ID: <9ad4aabc-45cb-413f-9899-9b7ffab8f4fe@linux.ibm.com>
Date: Tue, 3 Jun 2025 10:48:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: s390: Use ESCA instead of BSCA at VM init
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lD2kIGYQd_2rmP6PSW8k1LyXhR6SHTWo
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=683eb6ce cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=JobuCeQLhHgRNSiRUEsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lD2kIGYQd_2rmP6PSW8k1LyXhR6SHTWo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDA3NCBTYWx0ZWRfX1mghxl8x0/zv CMtPtPQEZkjTLQYbHg++gkNxwUqZhxW+fiCPsAJdrWs2IqoOOIYcuisD8DtPkqGe99QW+ruTBQc aUd26rytQzJ4BmwSj6I2om9/70ON+1yNZglTJxL6zBkNu2UMucDt7eHOIhINtdPhDHke14IO/JC
 89OSNolvgWM58lwD6DLDIWdGZlV6CAaG37PQQh3+W9nHbA48nKDYllZhgiQapDazRnSGJyc7FyV /gCErT55IOVVKWPTM9pgzRnwArNYQGptFc1nWt34t0GcfLhjoFJjuMSLivYxr8S8k5ohbuCQbxB V0k97URQzboRb7+saPuM948abYrPJbhG69KfgSFFDVNhJmfu6EqSWst572/4rsllbbZqOWdDgGm
 ZB9mkiEd9EDm8ngMZppIFYBG8WSF6oUQqthSDG2pd5fu2bEB3nE1LjSCM45Bc9iggUbfWIvK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030074

On 6/2/25 6:34 PM, Christoph Schlameuss wrote:
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
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
> Changes in v4:
> - Squash patches into single patch
> - Revert KVM_CAP_MAX_VCPUS to return KVM_CAP_MAX_VCPU_ID (255) again
> - Link to v3: https://lore.kernel.org/r/20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com
> 
> Changes in v3:
> - do not enable sigp for guests when kvm_s390_use_sca_entries() is false
>    - consistently use kvm_s390_use_sca_entries() instead of sclp.has_sigpif
> - Link to v2: https://lore.kernel.org/r/20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com
> 
> Changes in v2:
> - properly apply checkpatch --strict (Thanks Claudio)
> - some small comment wording changes
> - rebased
> - Link to v1: https://lore.kernel.org/r/20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com
> ---
>   arch/s390/include/asm/kvm_host.h       |   7 +-
>   arch/s390/include/asm/kvm_host_types.h |   2 +
>   arch/s390/kvm/gaccess.c                |  10 +-
>   arch/s390/kvm/interrupt.c              |  71 ++++----------
>   arch/s390/kvm/kvm-s390.c               | 167 ++++++---------------------------
>   arch/s390/kvm/kvm-s390.h               |   9 +-
>   6 files changed, 58 insertions(+), 208 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..2a2b557357c8e40c82022eb338c3e98aa8f03a2b 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -27,8 +27,6 @@
>   #include <asm/isc.h>
>   #include <asm/guarded_storage.h>
>   
> -#define KVM_MAX_VCPUS 255
> -
>   #define KVM_INTERNAL_MEM_SLOTS 1
>   
>   /*
> @@ -631,9 +629,8 @@ struct kvm_s390_pv {
>   	struct mmu_notifier mmu_notifier;
>   };
>   
> -struct kvm_arch{
> -	void *sca;
> -	int use_esca;
> +struct kvm_arch {
> +	struct esca_block *sca;
>   	rwlock_t sca_lock;
>   	debug_info_t *dbf;
>   	struct kvm_s390_float_interrupt float_int;
> diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
> index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f85b4b974c344769a 100644
> --- a/arch/s390/include/asm/kvm_host_types.h
> +++ b/arch/s390/include/asm/kvm_host_types.h
> @@ -6,6 +6,8 @@
>   #include <linux/atomic.h>
>   #include <linux/types.h>
>   
> +#define KVM_MAX_VCPUS 256

Why are we doing the whole 256 - 1 game?

> +
>   #define KVM_S390_BSCA_CPU_SLOTS 64

Can't you remove that now?

>   #define KVM_S390_ESCA_CPU_SLOTS 248
>   
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633ad87f6b02c2c42aea35a3c9164253..ee37d397d9218a4d33c7a33bd877d0b974ca9003 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -112,7 +112,7 @@ int ipte_lock_held(struct kvm *kvm)
>   		int rc;
>   
>   		read_lock(&kvm->arch.sca_lock);
> -		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
> +		rc = kvm->arch.sca->ipte_control.kh != 0;
>   		read_unlock(&kvm->arch.sca_lock);
>   		return rc;
>   	}

[...]

> -static int sca_switch_to_extended(struct kvm *kvm);
>   
>   static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
>   {
> @@ -631,11 +630,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_NR_VCPUS:
>   	case KVM_CAP_MAX_VCPUS:
>   	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_S390_BSCA_CPU_SLOTS;
> +		/*
> +		 * Return the same value for KVM_CAP_MAX_VCPUS and
> +		 * KVM_CAP_MAX_VCPU_ID to pass the kvm_create_max_vcpus selftest.
> +		 */
> +		r = KVM_S390_ESCA_CPU_SLOTS;

We're not doing this to pass the test, we're doing this to adhere to the 
KVM API. Yes, the API document explains it with one indirection but it 
is in there.

The whole KVM_CAP_MAX_VCPU_ID problem will pop up in the future since we 
can't change the caps name. We'll have to live with it.

