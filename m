Return-Path: <kvm+bounces-41498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CC2A6944E
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F08C818953AA
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 16:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1CA1D88C3;
	Wed, 19 Mar 2025 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cnb9IzTx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607751CAA8E;
	Wed, 19 Mar 2025 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742400166; cv=none; b=FKh3rL6mK+Jv3y+E79wUsOHI7iWz1xuOh7iqXlv8bLhtUQMmXxRcdNx1K7RgeR9no16KdOZkvuWPeSV+HaJ5lmiZVEk6iJawZkaDeFCkBv3SthtsaDY9CJCKMtJ3jCpnY0Gk/tC2Em14HXsRVADhpEwO+7rjnQXa5dN9q3AqJmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742400166; c=relaxed/simple;
	bh=9wVePQAtTFTA3zPNCJDvgyVA8TQMoXEtTT4LwlvUk+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uheocWnk2vGWakE5dbwLmEgQVJSytY9pkdI19b9L6BaLI0MjyzNrTslMCIRA6kVKm4USfxZSVYo0tL1oY0ZwVPhGzGj7Wk9q4gUuPbSKFlHwN9+sxAiolek3q+urIlpWqXckfiQr81LknARdbpSi07mbrnsiuY7p9LrTEBlnsLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cnb9IzTx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52J8I2i5004206;
	Wed, 19 Mar 2025 16:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Oytdah
	MN4JMH90LJzdENdVeIrZEBKPAZzLmsQJpoiBs=; b=cnb9IzTxh075dErrio7o9j
	WZ+5+zVfneJVscw/6PCi43h87IkT/2BUrhVV0eQ+DNQsJ+stG810Dy45UIVDYy8p
	Re9RSTAkOsNZe8oW3ir0yWvb5NccpRDztp4bukukW+rcpsKNRqe8j1BOy24j7D5K
	SdCFIzD4WTuee9vAIctXX2qseU9wucjLu4ZM7CSiKLdbCtOhxADPp6QfDWtcypXy
	bx0fDRIZXAJglfWyJHY9T1od59ox1gfodajNSNuEa7czuVLWJcSHdXsxu4UdCpv8
	RflKOUYH8S2ghl6J+YQoFyi9Jk3RaRfiab99JL8Qu/GWK+EVYypkHVs+RY/i5GbQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45ft9vtcv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 16:02:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52JCuEaq024417;
	Wed, 19 Mar 2025 16:02:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dncmacm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 16:02:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52JG2V6S52756764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 16:02:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAD5320043;
	Wed, 19 Mar 2025 16:02:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7757020040;
	Wed, 19 Mar 2025 16:02:31 +0000 (GMT)
Received: from [9.171.30.147] (unknown [9.171.30.147])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Mar 2025 16:02:31 +0000 (GMT)
Message-ID: <1c7fbb34-648b-42de-9d9a-44e6f304f8fd@linux.ibm.com>
Date: Wed, 19 Mar 2025 17:02:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/5] KVM: s390: Shadow VSIE SCA in guest-1
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
 <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
 <47c6f4b7-b8a6-4b20-b915-1c4c2d9e7c74@linux.ibm.com>
 <D8KBKS9B7SHE.3AL1L7RDLM0IP@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <D8KBKS9B7SHE.3AL1L7RDLM0IP@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xyUGZ1NgpUzM4872TAcvM-bchSCcAVTn
X-Proofpoint-GUID: xyUGZ1NgpUzM4872TAcvM-bchSCcAVTn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_06,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=790 spamscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503190108

On 3/19/25 3:41 PM, Christoph Schlameuss wrote:
> On Wed Mar 19, 2025 at 2:41 PM CET, Janosch Frank wrote:
>> On 3/18/25 7:59 PM, Christoph Schlameuss wrote:
>>> Introduce a new shadow_sca function into kvm_s390_handle_vsie.
>>> kvm_s390_handle_vsie is called within guest-1 when guest-2 initiates the
>>> VSIE.
>>>
>>> shadow_sca and unshadow_sca create and manage ssca_block structs in
>>> guest-1 memory. References to the created ssca_blocks are kept within an
>>> array and limited to the number of cpus. This ensures each VSIE in
>>> execution can have its own SCA. Having the amount of shadowed SCAs
>>> configurable above this is left to another patch.
>>>
>>> SCAOL/H in the VSIE control block are overwritten with references to the
>>> shadow SCA. The original SCA pointer is saved in the vsie_page and
>>> restored on VSIE exit. This limits the amount of change in the
>>> preexisting VSIE pin and shadow functions.
>>>
>>> The shadow SCA contains the addresses of the original guest-3 SCA as
>>> well as the original VSIE control blocks. With these addresses the
>>> machine can directly monitor the intervention bits within the original
>>> SCA entries.
>>>
>>> The ssca_blocks are also kept within a radix tree to reuse already
>>> existing ssca_blocks efficiently. While the radix tree and array with
>>> references to the ssca_blocks are held in kvm_s390_vsie.
>>> The use of the ssca_blocks is tracked using an ref_count on the block
>>> itself.
>>>
>>> No strict mapping between the guest-1 vcpu and guest-3 vcpu is enforced.
>>> Instead each VSIE entry updates the shadow SCA creating a valid mapping
>>> for all cpus currently in VSIE.
>>>
>>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/kvm_host.h |  22 +++-
>>>    arch/s390/kvm/vsie.c             | 264 ++++++++++++++++++++++++++++++++++++++-
>>>    2 files changed, 281 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>> index 0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22..4ab196caa9e79e4c4d295d23fed65e1a142e6ab1 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -29,6 +29,7 @@
>>>    #define KVM_S390_BSCA_CPU_SLOTS 64
>>>    #define KVM_S390_ESCA_CPU_SLOTS 248
>>>    #define KVM_MAX_VCPUS 255
>>> +#define KVM_S390_MAX_VCPUS 256
>>
>> #define KVM_S390_SSCA_CPU_SLOTS 256
>>
>> Yes, I'm aware, that ESCA and MAX_VCPUS are pretty confusing.
>> I'm searching for solutions but they might take a while.
>>
>>>    
>>>    #define KVM_INTERNAL_MEM_SLOTS 1
>>>    
>>> @@ -137,13 +138,23 @@ struct esca_block {
>>>    
>>>    /*
>>>     * The shadow sca / ssca needs to cover both bsca and esca depending on what the
>>> - * guest uses so we use KVM_S390_ESCA_CPU_SLOTS.
>>> + * guest uses so we allocate space for 256 entries that are defined in the
>>> + * architecture.
>>>     * The header part of the struct must not cross page boundaries.
>>>     */
>>>    struct ssca_block {
>>>    	__u64	osca;
>>>    	__u64	reserved08[7];
>>> -	struct ssca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>>> +	struct ssca_entry cpu[KVM_S390_MAX_VCPUS];
>>
>> This should have been resolved in the previous patch, no?
>>
> 
> Oops, yes, exactly.
> 
>>> +};
>>> +
>>> +/*
>>> + * Store the vsie ssca block and accompanied management data.
>>> + */
>>> +struct ssca_vsie {
>>> +	struct ssca_block ssca;			/* 0x0000 */
>>> +	__u8	reserved[0x2200 - 0x2040];	/* 0x2040 */
>>> +	atomic_t ref_count;			/* 0x2200 */
>>>    };
>>>    
>>
>> [...]
>>
>>>    void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
>>>    				 unsigned long end)
>>>    {
>>> @@ -699,6 +932,9 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>>    
>>>    	hpa = (u64) scb_s->scaoh << 32 | scb_s->scaol;
>>>    	if (hpa) {
>>> +		/* with vsie_sigpif scaoh/l was pointing to g1 ssca_block but
>>> +		 * should have been reset in unshadow_sca()
>>> +		 */
>>
>> There shouldn't be text in the first or last line of multi-line comments.
>>
> 
> Will fix. Thx. (checkpatch seems to be fine with this, so I assume just in not
> desired?)

Might either be a personal preference as well or something that we don't 
really do in s390 KVM code.

