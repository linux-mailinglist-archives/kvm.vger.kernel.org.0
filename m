Return-Path: <kvm+bounces-63556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DF5C6A861
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A4B6334A19E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19F936A00B;
	Tue, 18 Nov 2025 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CK3DsRNo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0945821CC79;
	Tue, 18 Nov 2025 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763481922; cv=none; b=g6qY7mv1cCq0Wg59Xcyu5ICi50k+r+oUrWcZxtiKZFcs4bYp69ccchZaBIu2wlV1288lAepUOAAqUS620GLPojevLWG4oUp3eNcdbDo5hfjEvyZ31JJPWMMt6lL1zmmfTopR/ILKM4PXlQhgdE4G1b1neJfDLgZYLFKqucIx4D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763481922; c=relaxed/simple;
	bh=cin5UPavKVB7t6PE0aD17koWdUzREkVM/VIYxa8Eyq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSYKsdzmxi822JiEMUCftGR/OczSeJemobv3+rIfnJL8abqVNwdj6svNCZaILhkgVi869mPWQG+CSI3Wuhjr8GWjOSF27iYxb+oXOzdBLBvTb8sUARaxxuMQyLMi5i3RPVDz3+cP8yWpMZrajFFlr15eukNzJDIDmXGzrTIYFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CK3DsRNo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI2iBT8029107;
	Tue, 18 Nov 2025 16:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=J3iJqN
	AT/bUft0zcNiTR3dKZ62BJ+cXhb56tYI8EB6U=; b=CK3DsRNoVBLTovx+cSxE77
	BaSlrNbqtcIsfdjczYWacSW+lDIDRiyBXm8I/QWWdFWVz0X0winV1gtm620oHuXL
	wwRJlYYD/DRLtMaqUWdq5P99+MUCuMkcxRM1aFRE4K0n0xPoT3wUQKk32XY4PX0D
	mHZWS+6rU56PrQiQ+S6QT3TNxu+JnKYirmR6rQ0WdH16zUxUse/W9NSVCeccmyL5
	B/65a4Men5l8ZyriYSBCn5ZSYxWFShhUdY+6TEjRAZ7ChT/eoXbf13UGtoZak5uh
	P5JA9pQMxpUXq3GxlTtfb89F+8IURZy+6W6opxoo6GThW7e7e64YcMwNJ8K24NhA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmske9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 16:05:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIFmNBr022386;
	Tue, 18 Nov 2025 16:05:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4umux04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 16:05:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIG50lX28311910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 16:05:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7E9920049;
	Tue, 18 Nov 2025 16:05:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01DD820040;
	Tue, 18 Nov 2025 16:05:00 +0000 (GMT)
Received: from [9.111.18.63] (unknown [9.111.18.63])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Nov 2025 16:04:59 +0000 (GMT)
Message-ID: <0bd2c3f1-211e-41b3-a3ce-8d9ccfe2b1c0@linux.ibm.com>
Date: Tue, 18 Nov 2025 17:04:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 07/11] KVM: s390: Shadow VSIE SCA in guest-1
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
 <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OP0gMDozr-tpSzE9RsEe3f1f7lhexYub
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691c9931 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=5J8erNzc6tkCVkJnpnkA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: OP0gMDozr-tpSzE9RsEe3f1f7lhexYub
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2D3l4AyCgWRC
 wYm9rLOklUcS5uDwCMdeiaDx+/zxEMp0LaWUbPxEl/2Q559mxlmCkBJXxli8iMS4iRoOYmXchV+
 Ia+MNvgZsMTs7gdozokf0Kc8N/hrDkFMvOc+81vm/rOUM6gl7hAlt1E5Ork13/1jB7cU49+izuA
 gTSxNf6dnpdn7zvrgRnK4etmJaP5lWYCnXfo/6Trdf6n0qqvTmHyPxvN4xq1bI/yflst7FDK45z
 bhG5kpYeuPUdlWUfPaiW5SFpcLRRtSX0HjzxKmFX/v4GB3xN6Z3SVD+1JyCx1clSLoFPdJuHtIw
 m5xz2y22gjZffjKouDgrUAfn5clDR4Pn9QhDqqkShJAr0iHBVjraBkKTdFrsT8UCrpD+0tbidXW
 Hiu3HikNrNXEiKl/u5DuMpnlgLzF5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On 11/10/25 18:16, Christoph Schlameuss wrote:
> Restructure kvm_s390_handle_vsie() to create a guest-1 shadow of the SCA
> if guest-2 attempts to enter SIE with an SCA. If the SCA is used the
> vsie_pages are stored in a new vsie_sca struct instead of the arch vsie
> struct.
> 
> When the VSIE-Interpretation-Extension Facility is active (minimum z17)
> the shadow SCA (ssca_block) will be created and shadows of all CPUs
> defined in the configuration are created.
> SCAOL/H in the VSIE control block are overwritten with references to the
> shadow SCA.
> 
> The shadow SCA contains the addresses of the original guest-3 SCA as
> well as the original VSIE control blocks. With these addresses the
> machine can directly monitor the intervention bits within the original
> SCA entries, enabling it to handle SENSE_RUNNING and EXTERNAL_CALL sigp
> instructions without exiting VSIE.
> 
> The original SCA will be pinned in guest-2 memory and only be unpinned
> before reuse. This means some pages might still be pinned even after the
> guest 3 VM does no longer exist.
> 
> The ssca_blocks are also kept within a radix tree to reuse already
> existing ssca_blocks efficiently. While the radix tree and array with
> references to the ssca_blocks are held in the vsie_sca struct.
> The use of vsie_scas is tracked using an ref_count.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h       |  11 +-
>   arch/s390/include/asm/kvm_host_types.h |   5 +-
>   arch/s390/kvm/kvm-s390.c               |   6 +-
>   arch/s390/kvm/kvm-s390.h               |   2 +-
>   arch/s390/kvm/vsie.c                   | 672 ++++++++++++++++++++++++++++-----
>   5 files changed, 596 insertions(+), 100 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 647014edd3de8abc15067e7203c4855c066c53ad..191b23edf0ac7e9a3e1fd9cdc6fc4c9a9e6769f8 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -597,13 +597,22 @@ struct sie_page2 {
>   };
>   
>   struct vsie_page;
> +struct vsie_sca;
>   
> +/*
> + * vsie_pages, scas and accompanied management vars
> + */
>   struct kvm_s390_vsie {
>   	struct mutex mutex;
>   	struct radix_tree_root addr_to_page;
>   	int page_count;
>   	int next;
> -	struct vsie_page *pages[KVM_MAX_VCPUS];
> +	struct vsie_page *pages[KVM_S390_MAX_VSIE_VCPUS];
> +	struct rw_semaphore ssca_lock;

Might make sense to name it sca_lock, since we're not locking sscas.

> +	struct radix_tree_root osca_to_sca;
> +	int sca_count;
> +	int sca_next;
> +	struct vsie_sca *scas[KVM_S390_MAX_VSIE_VCPUS];
>   };
>   

[...]

> +
> +/*
> + * Pin and get an existing or new guest system control area.
> + *
> + * May sleep.
> + */
> +static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
> +				     gpa_t sca_addr)
> +{
> +	struct vsie_sca *sca, *sca_new = NULL;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned int max_sca;
> +	int rc;
> +
> +	rc = validate_scao(vcpu, vsie_page->scb_o, vsie_page->sca_gpa);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	/* get existing sca */
> +	down_read(&kvm->arch.vsie.ssca_lock);
> +	sca = get_existing_vsie_sca(kvm, sca_addr);
> +	up_read(&kvm->arch.vsie.ssca_lock);
> +	if (sca)
> +		return sca;
> +
> +	/*
> +	 * Allocate new ssca, it will likely be needed below.
> +	 * We want at least #online_vcpus shadows, so every VCPU can execute the
> +	 * VSIE in parallel. (Worst case all single core VMs.)
> +	 */

We're allocating an SCA and then its SSCA.

> +	max_sca = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
> +	if (kvm->arch.vsie.sca_count < max_sca) {
> +		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
> +		sca_new = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		if (!sca_new)
> +			return ERR_PTR(-ENOMEM);
> +
> +		if (use_vsie_sigpif(vcpu->kvm)) {
> +			BUILD_BUG_ON(offsetof(struct ssca_block, cpu) != 64);
> +			sca_new->ssca = alloc_pages_exact(sizeof(*sca_new->ssca),
> +							  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +			if (!sca_new->ssca) {
> +				free_page((unsigned long)sca);

Shouldn't this be sca_new which we just allocated?
I think it might have been a mistake to have both sca and sca_new in 
this function even though I understand why you need it.

> +				sca_new = NULL;

Why?
We're returning in the next line.

> +				return ERR_PTR(-ENOMEM);
> +			}
> +		}
> +	}

How about something like:

Now we're taking the ssca lock in write mode so that we can manipulate 
the radix tree and recheck for existing scas with exclusive access.

In the next lines we try three things to get an SCA:
  - Retry getting an existing SCA
  - Using our newly allocated SCA if we're under the limit
  - Reusing an SCA with a different osca

> +
> +	/* enter write lock and recheck to make sure ssca has not been created by other cpu */
> +	down_write(&kvm->arch.vsie.ssca_lock);
> +	sca = get_existing_vsie_sca(kvm, sca_addr);
> +	if (sca)
> +		goto out;> +
> +	/* check again under write lock if we are still under our sca_count limit */
> +	if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
> +		/* make use of vsie_sca just created */
> +		sca = sca_new;
> +		sca_new = NULL;
> +
> +		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] = sca;
> +	} else {
> +		/* reuse previously created vsie_sca allocation for different osca */
> +		sca = get_free_existing_vsie_sca(kvm);
> +		/* with nr_vcpus scas one must be free */
> +		if (IS_ERR(sca))
> +			goto out;
> +
> +		unpin_sca(kvm, sca);
> +		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
> +		memset(sca, 0, sizeof(struct vsie_sca));
> +	}

