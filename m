Return-Path: <kvm+bounces-63832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 043E7C73A4B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4F75035D58A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581EA32FA24;
	Thu, 20 Nov 2025 11:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sv3JTd4k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02132311C19;
	Thu, 20 Nov 2025 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763636853; cv=none; b=r9IItCctOs8MTf6pcnaCuiFqsV0iTbifY+IUF/NH3l0Ods2gZFeqthanUI7xthEVsf2HNP10DwxEROL+qoA7mgGYpWmNpQ1QyatywcUowOIONj25uZfKSdac8U2BmPua+7S7Q8ctU/BL+R4hsB1bKrOJhSvU3HjlSXUrgh+Xywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763636853; c=relaxed/simple;
	bh=C0XGW5Ef/UohOHVyLQy9AwkeAAJT5rIc4XgaxniGEsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0CJj5ODlLIxbj7ISdTn2ghy9g0ElZ2m9Fu5Wl54WAPFq5rstBk43wlirtvWFy5ahHO99NkFuunohQlFJmNv/UN3YhOhWyBmqNKZb8XC+MQ9E3Fs6fYjjQM3fZJrDEfH/k7DdqwEn89lhup/PgC/4n7tkCQhAYgvPGh9Ko1X6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sv3JTd4k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLkwjL027934;
	Thu, 20 Nov 2025 11:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1Djjoa
	4NHNvv48wg8gxT2nZD15l4CXQoidrCy1FnmOY=; b=Sv3JTd4kVjXmIPLF7lSUFg
	RFxZ1Qu7W0sfNa91F1NyyjjYYFIy5erj2DiV78TW9i2kk/1PHlQo3gyHLaZU+FCn
	aostE/Q0sdZrq7Frm7YpdV3P/0oS97DFCEOaH1dmSv+Tv7N+OlB22Fq3Gh0KRFlT
	D7Ohugj6OQzyrkE1xX3vozO3GSqpYmR2Wf/sIM9Ma0RiUdlWJU4wiLSoBOLCNCXa
	6edTb9p3DGYK3YKQtYcmh1oy+5+SuURh42IzT5cU9t/ehfLFwPD9VpoR705zAdOh
	iyuFvjFQmjvI0PNKWBQONolFWd6C/1YPiYXlNX9Dc+/H++lN6/Thrmo28dRvrDGg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka5vft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:07:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK9lwPR022347;
	Thu, 20 Nov 2025 11:07:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un60xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:07:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKB7Ml226739390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 11:07:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6257C20040;
	Thu, 20 Nov 2025 11:07:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E63A2004D;
	Thu, 20 Nov 2025 11:07:19 +0000 (GMT)
Received: from [9.111.95.204] (unknown [9.111.95.204])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 11:07:19 +0000 (GMT)
Message-ID: <c9264abb-4bcc-498b-adf9-1167d519b254@linux.ibm.com>
Date: Thu, 20 Nov 2025 12:07:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 11/11] KVM: s390: Add VSIE shadow stat counters
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-11-9e53a3618c8c@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251110-vsieie-v2-11-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8HPocnc2zawBRspAVq0x4eAq0qXh7r7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2Al11zH1IMVs
 P93x2671UU9sT1uzHmATx+nf9nqbGc/BVIWtI34YMNsaJKc28idO+W18zzyC8eni50gK6x6M+9o
 Eo8guy+j8IUke1mdRz/h/thMJMUQADQ5+SfD5vqvbOyjTl/N4gsCiChxpRM5JiI961KhI8yjVAd
 IOY9y7G/sBf+lXwuFi7EGadiIR7j9plO6YZg5Y9EkEjOYLt73HqudueA5e7Jnm76O6Jb3RFhKuN
 8gF1mfmBDj52m+Cz3ojSgrSEIP08yulsh9W+oKbktrwZTO1k1m4xSKaOZ7bU/tqxbvO7ww4+25X
 Syrxk9N9IBAC9Byl5Y+TDfSRf+li46G6T33Gwx0sPFQ03/ZmS+aJke/I15nh6thUNUpS7auj+4U
 Y4TSapYTP2g3jLWilAsk4YLQXgxV1A==
X-Proofpoint-ORIG-GUID: 8HPocnc2zawBRspAVq0x4eAq0qXh7r7-
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691ef66f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=jG2FwyvNgr7Nj0ZJUgQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On 11/10/25 18:16, Christoph Schlameuss wrote:
> Add new stat counters to VSIE shadowing to be able to verify and monitor
> the functionality.
> 
> * vsie_shadow_scb shows the number of allocated SIE control block
>    shadows. Should count upwards between 0 and the max number of cpus.
> * vsie_shadow_sca shows the number of allocated system control area
>    shadows. Should count upwards between 0 and the max number of cpus.
> * vsie_shadow_sca_create shows the number of newly allocated system
>    control area shadows.
> * vsie_shadow_sca_reuse shows the number of reused system control area
>    shadows.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 4 ++++
>   arch/s390/kvm/kvm-s390.c         | 4 ++++
>   arch/s390/kvm/vsie.c             | 9 ++++++++-
>   3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 191b23edf0ac7e9a3e1fd9cdc6fc4c9a9e6769f8..ef7bf2d357f8d289b5f163ec95976c5d270d1380 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -457,6 +457,10 @@ struct kvm_vm_stat {
>   	u64 gmap_shadow_r3_entry;
>   	u64 gmap_shadow_sg_entry;
>   	u64 gmap_shadow_pg_entry;
> +	u64 vsie_shadow_scb;
> +	u64 vsie_shadow_sca;
> +	u64 vsie_shadow_sca_create;
> +	u64 vsie_shadow_sca_reuse;
>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e3fc53e33e90be7dab75f73ebd0b949c13d22939..d86bf2206c230ce25fd48610c8305326e260e590 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -79,6 +79,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	STATS_DESC_COUNTER(VM, gmap_shadow_r3_entry),
>   	STATS_DESC_COUNTER(VM, gmap_shadow_sg_entry),
>   	STATS_DESC_COUNTER(VM, gmap_shadow_pg_entry),
> +	STATS_DESC_COUNTER(VM, vsie_shadow_scb),
> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca),
> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca_create),
> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca_reuse),
>   };
>   
>   const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index cd114df5e119bd289d14037d1f1c5bfe148cf5c7..f7c1a217173cefe93d0914623df08efa14270771 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -767,6 +767,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   out:
>   	if (rc)
>   		unshadow_scb(vcpu, vsie_page);
> +	else
> +		vcpu->kvm->stat.vsie_shadow_scb++;
>   	return rc;
>   }
>   
> @@ -843,8 +845,10 @@ static struct vsie_sca *get_existing_vsie_sca(struct kvm *kvm, hpa_t sca_o_gpa)
>   {
>   	struct vsie_sca *sca = radix_tree_lookup(&kvm->arch.vsie.osca_to_sca, sca_o_gpa);
>   
> -	if (sca)
> +	if (sca) {
>   		WARN_ON_ONCE(atomic_inc_return(&sca->ref_count) < 1);
> +		kvm->stat.vsie_shadow_sca_reuse++;
> +	}
>   	return sca;
>   }
>   
> @@ -958,6 +962,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
>   		sca_new = NULL;
>   
>   		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] = sca;
> +		kvm->arch.vsie.sca_count++;

Why are you touching a non-stat variable in this patch?


> +		kvm->stat.vsie_shadow_sca++;
>   	} else {
>   		/* reuse previously created vsie_sca allocation for different osca */
>   		sca = get_free_existing_vsie_sca(kvm);
> @@ -992,6 +998,7 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
>   
>   	atomic_set(&sca->ref_count, 1);
>   	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
> +	kvm->stat.vsie_shadow_sca_create++;
>   
>   out:
>   	up_write(&kvm->arch.vsie.ssca_lock);
> 

