Return-Path: <kvm+bounces-63207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55090C5D7CE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15F113BD408
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 14:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0162320CCD;
	Fri, 14 Nov 2025 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XTjoRmIr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EA9320CAF;
	Fri, 14 Nov 2025 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763129370; cv=none; b=EcC63oSf5melu/xnfER977D4w3Ol8aszPCEFYnjwAJKUB2mGW5DDR48dSjSA5lajT3fkT5En2HvAf2O18T38RQGihcflMoLQ43IDHPYGkWdARXHYlvbz5sA5TLTMa/Bkf2muByR3Duy6E0Gy5PjYH9/L0/WN3OlfbiPtIjpTIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763129370; c=relaxed/simple;
	bh=QqSd3FodRWev3T+P0IxwcQyY1VKMNzXWoC4VfSXWsII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BtYM9uUz1xjq21saqvd4dP98VbI1NRzIPHxOurtW9Zqjof5AzSA8AZ6RA8GsCqnj/xdYZL/BoBGeJPN7ITeHNED/i16AHK38Svtk19wsOekd976IDWMRBGnFTmfsgayPD1XYpoqfNgu34eoVn5jzm+SW7JSU8GdVsXVdFLzLgk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XTjoRmIr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEDr0re022140;
	Fri, 14 Nov 2025 14:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YWNsAE
	t7zisYsqupom70mKZLsroN/yMnquzTBctJMto=; b=XTjoRmIrRrlNfpRGRpdE/3
	OP8tWeeK/SYGCQLxj6CL8AWZIiYvBsLo7CY2TsTv0ezQIUsPB7vg2E78suLgpYTx
	NrCiiiFAFAz5EfNxRXwkDnWP4ijKvQvdJrEY5dWWFuNvC0UahyOLMAhHPcx7ZNhX
	4eAqC3yOFheWbgWXCA4GPq/VOzL8GcM39xwVLVmk9Rx28kZ5E/4fLnM5ktHLKHSs
	QRKWNsAhWrh1G2c7fzjg0+aMVC1b6iLXVDZJ5m6Ookju5mH9ZB0ec7B4Bju18FWq
	AKHEZAypOWk/K0SDaHWpdZydM7DzWEtBmqtp7nXQ1ls+XFLfwye+AthOGVdMCqzQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4adrecty24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 14:09:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AED02iH004770;
	Fri, 14 Nov 2025 14:09:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aagjybqf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 14:09:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AEE95Hs13173190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 14:09:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBBC520040;
	Fri, 14 Nov 2025 14:09:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECB072004E;
	Fri, 14 Nov 2025 14:09:04 +0000 (GMT)
Received: from [9.111.27.148] (unknown [9.111.27.148])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Nov 2025 14:09:04 +0000 (GMT)
Message-ID: <1c5279ce-b0d6-4c08-becb-b52d7d6d48ae@linux.ibm.com>
Date: Fri, 14 Nov 2025 15:09:04 +0100
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OSBTYWx0ZWRfX6z97ZM3Mfo6X
 YKwLwT5P9Sr5WrkqNp9DcSSRdHSDWJdUVj8rEgGNXloLWO8FCPELe6gxwcl60xeZ8kVBonW/zUB
 ptAH9GxWEACiA1xyOsAlvXkynT/SZTTC4ofJA00Qn1OaznLNf+kSq9ht4oxK9oCCVHZA6AZK06y
 aNUeFPq7m/0MNDFdNJirznUEnx9sdwlsUPZG3pHTeGgkoC04A2Mi9OiV7r+LHfif8xHmoYDzxg4
 BbKOFkGnSod1VbI18E8A/ZdQ0c4MJflRonXIjUTyux/83QIsQONNtiXEbPgk1VBNNyS9qLNV1re
 O743bMs6QycHdmRV2qH4+aIcFWijXAzQb/z4lYNuu2TrL2tD70zqKJFX7JXyvbddMG2q1E14OTk
 Fr93w1z9yMpuSpFElrcqwVxmOukCxA==
X-Authority-Analysis: v=2.4 cv=E//AZKdl c=1 sm=1 tr=0 ts=69173807 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Pl2lnVEkADD1yfzgVSYA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 05kJl2r87oPEqrosMF1ZOT3419vsjl9o
X-Proofpoint-ORIG-GUID: 05kJl2r87oPEqrosMF1ZOT3419vsjl9o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511130179

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

[...]

> +enum vsie_sca_flags {
> +	VSIE_SCA_ESCA = 0,
> +	VSIE_SCA_PINNED = 1,
>   };
>   
>   struct vsie_page {
> @@ -62,7 +68,9 @@ struct vsie_page {
>   	 * looked up by other CPUs.
>   	 */
>   	unsigned long flags;			/* 0x0260 */
> -	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
> +	/* vsie system control area */
> +	struct vsie_sca *sca;			/* 0x0268 */
> +	__u8 reserved[0x0700 - 0x0270];		/* 0x0270 */
>   	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
>   	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
>   };
> @@ -72,6 +80,41 @@ struct kvm_address_pair {
>   	hpa_t hpa;
>   };
>   
> +/*
> + * Store the vsie system configuration data.
> + */
> +struct vsie_sca {
> +	/* calculated guest addresses of the sca */

Can you move the comments to the right?
Well, actually I'm not sure why we need them at all.
Aren't the variable names enough?

> +	gpa_t			sca_gpa;
> +	atomic_t		ref_count;
> +	/* defined in enum vsie_sca_flags */

Move the enum above the struct please.

> +	unsigned long		flags;
> +	unsigned long		sca_o_nr_pages;
> +	struct kvm_address_pair	sca_o_pages[KVM_S390_MAX_SCA_PAGES];
> +	u64			mcn[4];
> +	struct ssca_block	*ssca;
> +	int			page_count;
> +	int			page_next;
> +	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
> +};
> +
> +static inline bool use_vsie_sigpif(struct kvm *kvm)
> +{
> +	return kvm->arch.use_vsie_sigpif;
> +}
> +
> +static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_page *vsie_page)

The "for" in the name is weird.

Also, why are we allocating fenced on use_vsie_sigpif() but then shadow 
on the EC bits and sigpif? If neither extcall nor SRS are interpreted, 
why shadow via vsigpif at all?

> +{
> +	return use_vsie_sigpif(kvm) &&
> +	       (vsie_page->scb_o->eca & ECA_SIGPI) &&
> +	       (vsie_page->scb_o->ecb & ECB_SRSI);

Is SIGPI a prereq for SRSI and vice versa for vsigpif?
If no, then this should not be anded.

> +}
> +
> +static inline bool sie_uses_esca(struct kvm_s390_sie_block *scb)
> +{
> +	return (scb->ecb2 & ECB2_ESCA);
> +}
> +
>   /**
>    * gmap_shadow_valid() - check if a shadow guest address space matches the
>    *                       given properties and is still valid
> @@ -630,6 +673,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   		scb_s->ictl |= ICTL_ISKE | ICTL_SSKE | ICTL_RRBE;
>   
>   	scb_s->icpua = scb_o->icpua;
> +	write_scao(scb_s, virt_to_phys(vsie_page->sca->ssca));
> +	scb_s->osda = virt_to_phys(scb_o);
>   
>   	if (!(atomic_read(&scb_s->cpuflags) & CPUSTAT_SM))
>   		new_mso = READ_ONCE(scb_o->mso) & 0xfffffffffff00000UL;
> @@ -681,6 +726,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	/* Instruction Execution Prevention */
>   	if (test_kvm_facility(vcpu->kvm, 130))
>   		scb_s->ecb2 |= scb_o->ecb2 & ECB2_IEP;
> +	/* extended SCA */
> +	scb_s->ecb2 |= scb_o->ecb2 & ECB2_ESCA;
>   	/* Guarded Storage */
>   	if (test_kvm_facility(vcpu->kvm, 133)) {
>   		scb_s->ecb |= scb_o->ecb & ECB_GS;
> @@ -713,12 +760,250 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	return rc;
>   }
>   
> +/* Called with ssca_lock held. */
> +static void unpin_sca(struct kvm *kvm, struct vsie_sca *sca)
> +{
> +	if (!test_bit(VSIE_SCA_PINNED, &sca->flags))
> +		return;
> +
> +	unpin_guest_pages(kvm, sca->sca_o_pages, sca->sca_o_nr_pages);
> +	sca->sca_o_nr_pages = 0;
> +
> +	__clear_bit(VSIE_SCA_PINNED, &sca->flags);
> +}
> +
> +/* pin g2s original sca in g1 memory */
> +static int pin_sca(struct kvm *kvm, struct vsie_page *vsie_page, struct vsie_sca *sca)
> +{
> +	bool is_esca = sie_uses_esca(vsie_page->scb_o);
> +	int nr_pages = KVM_S390_MAX_SCA_PAGES;
> +
> +	if (test_bit(VSIE_SCA_PINNED, &sca->flags))
> +		return 0;
> +
> +	if (!is_esca) {
> +		nr_pages = 1;
> +		if ((sca->sca_gpa & ~PAGE_MASK) + sizeof(struct bsca_block) > PAGE_SIZE)
> +			nr_pages = 2;
> +	}
> +
> +	sca->sca_o_nr_pages = pin_guest_pages(kvm, sca->sca_gpa, nr_pages, sca->sca_o_pages);
> +	if (WARN_ON_ONCE(sca->sca_o_nr_pages != nr_pages)) {
> +		set_validity_icpt(&vsie_page->scb_s, 0x0034U);
> +		return -EIO;

Any idea when this would happen?
gpa translate to last page and following pages would be over the guests 
allowed memory?

> +	}
> +	__set_bit(VSIE_SCA_PINNED, &sca->flags);
> +
> +	return 0;
> +}
> +
> +static void get_sca_entry_addr(struct kvm *kvm, struct vsie_page *vsie_page, struct vsie_sca *sca,
> +			       u16 cpu_nr, gpa_t *gpa, hpa_t *hpa)
> +{
> +	hpa_t offset;
> +	int pn;
> +
> +	/*
> +	 * We cannot simply access the hva since the esca_block has typically
> +	 * 4 pages (arch max 5 pages) that might not be continuous in g1 memory.
> +	 * The bsca_block may also be stretched over two pages. Only the header
> +	 * is guaranteed to be on the same page.
> +	 */
> +	if (test_bit(VSIE_SCA_ESCA, &sca->flags))
> +		offset = offsetof(struct esca_block, cpu[cpu_nr]);
> +	else
> +		offset = offsetof(struct bsca_block, cpu[cpu_nr]);
> +	pn = ((vsie_page->sca->sca_gpa & ~PAGE_MASK) + offset) >> PAGE_SHIFT;
> +	if (WARN_ON_ONCE(pn > sca->sca_o_nr_pages))
> +		return;
> +
> +	if (gpa)
> +		*gpa = sca->sca_o_pages[pn].gpa + offset;
> +	if (hpa)
> +		*hpa = sca->sca_o_pages[pn].hpa + offset;
> +}

