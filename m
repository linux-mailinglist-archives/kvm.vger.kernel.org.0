Return-Path: <kvm+bounces-63384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BAD4C64DD9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 24A1E34E9BB
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF86339B34;
	Mon, 17 Nov 2025 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NqZDZww/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B0B338F4D;
	Mon, 17 Nov 2025 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763392982; cv=none; b=Ih6qFDfxRrGVo3ETZloDjEU0N72zpxhGZsxNRxaUVAAUYLMrQFqMVN3HBh5IXgdDXYIanPHUZ+/LjuVN5gMEoI69n6txuwcTMXNWhS8drwBZYwB8lunybd1nsFr4mzPBZkd8j/zPcEEA2Wk7sUrG8AKnr90WHz09YSVYNxlS3Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763392982; c=relaxed/simple;
	bh=1E84NZ2OSuxJlyEb89F+hy0412ZGRsBs/gbxQGETGzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oa89M5PE4rneAARS2guxSDM28m2DErEuBdD7ZZtuU7XikzHIfp7PoZ0bCNKza6BNTElR+Mzt/1eRdag0xYM5mKSXR50604cjcAChksnOWqgW9xXzDQrNy9Of5Yi9BzkmmbsQqNDPPNNgt8ZONeJIWOzFdITm+S9NPIBr4YCffag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NqZDZww/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHDIJtF030553;
	Mon, 17 Nov 2025 15:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mrXPsE
	iyYfJbHes3/pd23TeFZy0PkMVW3/H9uoULl3I=; b=NqZDZww//Mm2KDifSyw6CJ
	spz5ZawMXnjBppvIA11x0q1TK6bBS1c3UQAfeqZAbocyt0bVpOVwmKlKUk1GpjYT
	fgOoxO57zv2O89hZ9dfgcVO3zq1suDBr77wDddXrZ9Ojx4UttQ7olU2h1nonpE93
	HRdeD8yggpqHMS8IJxKgpHmcH7aALWti22S7Qe621tLM8GlNMzoSY3LJeq54CCbw
	QO6Bsd0FQLNYhfYab5EFRCuoaS/OKWnnL4ZlcotUOWFNhPTmpIfP8qv1Y5SAZxS3
	TG/V8HG2YlsZo+FfsxvIs1axVObtk7d1BjD9OTLLPqQymaMtvSj1hHcQ7DZfmhiQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjtpn6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 15:22:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC90S7006967;
	Mon, 17 Nov 2025 15:22:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62j6ags-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 15:22:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AHFMoKu50987496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:22:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDE8F2004B;
	Mon, 17 Nov 2025 15:22:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 510BE20040;
	Mon, 17 Nov 2025 15:22:50 +0000 (GMT)
Received: from [9.111.73.112] (unknown [9.111.73.112])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Nov 2025 15:22:50 +0000 (GMT)
Message-ID: <c92235d2-cee0-40c8-9a86-1334aaba4875@linux.ibm.com>
Date: Mon, 17 Nov 2025 16:22:50 +0100
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
X-Proofpoint-GUID: N9HABT3nn5P-_BR7mqHaG8ldaoLsFppJ
X-Proofpoint-ORIG-GUID: N9HABT3nn5P-_BR7mqHaG8ldaoLsFppJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXyU6e5mwKCDf1
 wuenmKcJroDRkVpbC3s2lKngHoeYiVyD5i4m0XfZEW/h4c/dvr+wbsFtyLEEKuItEHdNzoWctOS
 qyKarkVznDqxzmLiJ+GvJh7uaeh+YUynXs1hToKrPffxYE/HNLRpAGg+sa9G3v60pdpt40yw4Ir
 nHt1fp4QIyFwm3TBrlU6y06ieBhu4TlwHG2OUDDsTVnNMPXyOuwXK+vy3STwP1UJzOJUoX46Ig+
 c44PrRgxSQtHRkMtRRt1MAamKdp9b7MAhuUp9XxZEf1hIORq6z+I6je02G0tKgiyY7bPMd2XW2o
 8YhQWjpPbAJI7qmmKfYPbX644S0qR4a+G7hrSf+GDQ47Ehs1gGyrkzWlZxYrnHiUdnrSdy2NyER
 Oiy9b45sFe6G4hYlFtznrhXGVEndFg==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691b3dcf cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=dnc6cyhX8Vf1XMBojv4A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

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

[...]

> +/*
> + * Try to find an currently unused ssca_vsie from the vsie struct.
> + *
> + * Called with ssca_lock held.
> + */
> +static struct vsie_sca *get_free_existing_vsie_sca(struct kvm *kvm)
> +{
> +	struct vsie_sca *sca;
> +	int i, ref_count;
> +
> +	for (i = 0; i >= kvm->arch.vsie.sca_count; i++) {
> +		sca = kvm->arch.vsie.scas[kvm->arch.vsie.sca_next];
> +		kvm->arch.vsie.sca_next++;
> +		kvm->arch.vsie.sca_next %= kvm->arch.vsie.sca_count;
> +		ref_count = atomic_inc_return(&sca->ref_count);
> +		WARN_ON_ONCE(ref_count < 1);
> +		if (ref_count == 1)
> +			return sca;
> +		atomic_dec(&sca->ref_count);
> +	}
> +	return ERR_PTR(-EFAULT);

ENOENT?

> +}
> +
> +static void destroy_vsie_sca(struct kvm *kvm, struct vsie_sca *sca)
> +{
> +	radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
> +	if (sca->ssca)
> +		free_pages_exact(sca->ssca, sca->page_count);
> +	sca->ssca = NULL;
> +	free_page((unsigned long)sca);
> +}
> +
> +static void put_vsie_sca(struct vsie_sca *sca)
> +{
> +	if (!sca)
> +		return;
> +
> +	WARN_ON_ONCE(atomic_dec_return(&sca->ref_count) < 0);
> +}
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

This is wild.
validate_scao() returns 0/1 (once you fix the bool) and the rest of the 
function below returns -ERRNO. I think validate_scao() should return 
-EINVAL since the scao is clearly invalid if the function doesn't return 0.

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
> +	max_sca = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
> +	if (kvm->arch.vsie.sca_count < max_sca) {
> +		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
> +		sca_new = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);

sca and sca_new are not FW structs, they are not scas that you can hand 
over to FW. As such they should not be exclusively named sca. Name them 
vsie_sca or some other name to make it clear that we're working with a 
KVM struct.

Is there a need for sca_new to be page allocated?
vsie_page's size is close to a page and it is similar to sie_page so 
that makes sense. But vsie_sca is only a copule of DWORDs until we reach 
the "pages" member and we could dynamically allocate vsie_sca based on 
the actual number of max pages since pages is at the end of the struct.

> +		if (!sca_new)
> +			return ERR_PTR(-ENOMEM);
> +
> +		if (use_vsie_sigpif(vcpu->kvm)) {
> +			BUILD_BUG_ON(offsetof(struct ssca_block, cpu) != 64);
> +			sca_new->ssca = alloc_pages_exact(sizeof(*sca_new->ssca),
> +							  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +			if (!sca_new->ssca) {
> +				free_page((unsigned long)sca);
> +				sca_new = NULL;
> +				return ERR_PTR(-ENOMEM);
> +			}
> +		}
> +	}
> +
> +	/* enter write lock and recheck to make sure ssca has not been created by other cpu */
> +	down_write(&kvm->arch.vsie.ssca_lock);
> +	sca = get_existing_vsie_sca(kvm, sca_addr);
> +	if (sca)
> +		goto out;
> +
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
> +
> +	/* use ECB of shadow scb to determine SCA type */
> +	if (sie_uses_esca(vsie_page->scb_o))
> +		__set_bit(VSIE_SCA_ESCA, &sca->flags);
> +	sca->sca_gpa = sca_addr;
> +	sca->pages[vsie_page->scb_o->icpua] = vsie_page;
> +
> +	if (sca->sca_gpa != 0) {
> +		/*
> +		 * The pinned original sca will only be unpinned lazily to limit the
> +		 * required amount of pins/unpins on each vsie entry/exit.
> +		 * The unpin is done in the reuse vsie_sca allocation path above and
> +		 * kvm_s390_vsie_destroy().
> +		 */
> +		rc = pin_sca(kvm, vsie_page, sca);
> +		if (rc) {
> +			sca = ERR_PTR(rc);
> +			goto out;
> +		}
> +	}
> +
> +	atomic_set(&sca->ref_count, 1);
> +	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
> +
> +out:
> +	up_write(&kvm->arch.vsie.ssca_lock);
> +	if (sca_new)
> +		destroy_vsie_sca(kvm, sca_new);
> +	return sca;
> +}

