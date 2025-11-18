Return-Path: <kvm+bounces-63528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCBFC688BA
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C7C7935C5F8
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9170730F53E;
	Tue, 18 Nov 2025 09:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H70eudze"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D001A9F82;
	Tue, 18 Nov 2025 09:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763458101; cv=none; b=byz3s5p64LQQsZdr9ZIIWHnw1q0Z673GbC4yqXXXIXI3UZzxNge1e3CbCccz28zz1aCjik+IrkM/4eb6hPdibXLGmXfoieT12V698ZcBSGqRfN0lE0DpamPkzqmgfoLcZlkeP5FxkQFBhbYnfl6zm/RSOI5oPAcIwffujdOz26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763458101; c=relaxed/simple;
	bh=cLxvvsfV/1XbHl54x/Qo2fSDuf+WuPbBTOiSsUfgGF0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=FaSaMgr4/ReInI8Sl8NCoVdFWuAmbkzu9M05KxvNHe3rd5Da8lzzHalIJ5wtTJDLXnjkwRzKeb9Oiy9nY2F85DKKPTkHwbNUP9dIMSjT9TxtOsH1M4bskY/JV9OipDXoa4UDuN/zZMZToT1RdZ0yqKvvfCWSDKrx5GpzMFnHBXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H70eudze; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI0beae019792;
	Tue, 18 Nov 2025 09:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Y+SQwd
	uh6HeXbY/5DAV7/pEvpQhX4VkpBaB/S/bgUvM=; b=H70eudzeEJJRTwNTSKr8dD
	oEINzfCSNX9gz1ZbebonKsZbtTC+jRJ3tvO4T8uOj+1NV9cuLwW9Ak7UK5H6Na3I
	3KKHbUDARYTVT9qRKY0m8/iT8fBeBVwBKKdjlAtwhA/0SKzSi83/l1rRWtBFdrAo
	uM39rCi9TkE3QB80Q030OsKx/MnfISJiWY4CWUtmmq9x5SE6qBY9T3cTs0f/IMtl
	rLaa6kZZTMHMzC3QehfO3kxpeooPEeMxyMkceqL1akHU8TWzjSvWt890owtGr84z
	DdhPpMzUElhTdB4rM/he2qAMshs6TcLhJzLA0bl6qGqhV4BXu2ZA6G1XozZVFvBA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk19yyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 09:28:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI8cmcO006959;
	Tue, 18 Nov 2025 09:28:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62ja5fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 09:28:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AI9RuIh51118564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 09:27:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C65222004B;
	Tue, 18 Nov 2025 09:27:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 900A420040;
	Tue, 18 Nov 2025 09:27:56 +0000 (GMT)
Received: from darkmoore (unknown [9.87.157.154])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Nov 2025 09:27:56 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Nov 2025 10:27:51 +0100
Message-Id: <DEBPPQ1YH6TY.3W3PLCBFCYOAG@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev"
 <agordeev@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Nico Boehr" <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>,
        "Shuah Khan" <shuah@kernel.org>
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Christoph Schlameuss"
 <schlameuss@linux.ibm.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 07/11] KVM: s390: Shadow VSIE SCA in guest-1
X-Mailer: aerc 0.21.0
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
 <c92235d2-cee0-40c8-9a86-1334aaba4875@linux.ibm.com>
In-Reply-To: <c92235d2-cee0-40c8-9a86-1334aaba4875@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=691c3c21 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=QLEIjbz6RcEJkl_6hsIA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: Xqk8LaYZzqxF1dVgI7h2ThoexouWhtAo
X-Proofpoint-ORIG-GUID: Xqk8LaYZzqxF1dVgI7h2ThoexouWhtAo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX6uUFLKostIGh
 5jjTBAfp+Da9jeUKhVD52qMV7b0d21JVBGltef9si/gSsQnTMiJsmiWNHBecAQc9AQ5q6ZGod+F
 8I0kwlaps13U7asGZ5FjqlCJXRu9NGGIwM8XTfrsPxLeq2z3lw8S1Y07WVSNSRe4bthxf+vsZvK
 BT5qfNcrs2+V82EpLjxpBy4dvKZZRxwiv/tN/oR4QbAEJ+KaEbnbEhQlSp87OZJsA5WABknvB2H
 g2rq4lqMLS7M3++TjYoEwSnRPzYmS5epUhDZ//s3yhKW/jjzNdHcfLEdaS43HStI5S14ptICAsn
 zACdKOtfMDOgA7/F3BAvD89pBXtjvSsznMp3d87eldD4na1RYCv1QPd/VKDRtA4IhATEDZgOd2b
 9J0Rj3EqGzPFYWziCkWCumuGsviiWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Mon Nov 17, 2025 at 4:22 PM CET, Janosch Frank wrote:
> On 11/10/25 18:16, Christoph Schlameuss wrote:
>> Restructure kvm_s390_handle_vsie() to create a guest-1 shadow of the SCA
>> if guest-2 attempts to enter SIE with an SCA. If the SCA is used the
>> vsie_pages are stored in a new vsie_sca struct instead of the arch vsie
>> struct.
>>=20
>> When the VSIE-Interpretation-Extension Facility is active (minimum z17)
>> the shadow SCA (ssca_block) will be created and shadows of all CPUs
>> defined in the configuration are created.
>> SCAOL/H in the VSIE control block are overwritten with references to the
>> shadow SCA.
>>=20
>> The shadow SCA contains the addresses of the original guest-3 SCA as
>> well as the original VSIE control blocks. With these addresses the
>> machine can directly monitor the intervention bits within the original
>> SCA entries, enabling it to handle SENSE_RUNNING and EXTERNAL_CALL sigp
>> instructions without exiting VSIE.
>>=20
>> The original SCA will be pinned in guest-2 memory and only be unpinned
>> before reuse. This means some pages might still be pinned even after the
>> guest 3 VM does no longer exist.
>>=20
>> The ssca_blocks are also kept within a radix tree to reuse already
>> existing ssca_blocks efficiently. While the radix tree and array with
>> references to the ssca_blocks are held in the vsie_sca struct.
>> The use of vsie_scas is tracked using an ref_count.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>
> [...]
>
>> +/*
>> + * Try to find an currently unused ssca_vsie from the vsie struct.
>> + *
>> + * Called with ssca_lock held.
>> + */
>> +static struct vsie_sca *get_free_existing_vsie_sca(struct kvm *kvm)
>> +{
>> +	struct vsie_sca *sca;
>> +	int i, ref_count;
>> +
>> +	for (i =3D 0; i >=3D kvm->arch.vsie.sca_count; i++) {
>> +		sca =3D kvm->arch.vsie.scas[kvm->arch.vsie.sca_next];
>> +		kvm->arch.vsie.sca_next++;
>> +		kvm->arch.vsie.sca_next %=3D kvm->arch.vsie.sca_count;
>> +		ref_count =3D atomic_inc_return(&sca->ref_count);
>> +		WARN_ON_ONCE(ref_count < 1);
>> +		if (ref_count =3D=3D 1)
>> +			return sca;
>> +		atomic_dec(&sca->ref_count);
>> +	}
>> +	return ERR_PTR(-EFAULT);
>
> ENOENT?
>

Ack.

>> +}
>> +
>> +static void destroy_vsie_sca(struct kvm *kvm, struct vsie_sca *sca)
>> +{
>> +	radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
>> +	if (sca->ssca)
>> +		free_pages_exact(sca->ssca, sca->page_count);
>> +	sca->ssca =3D NULL;
>> +	free_page((unsigned long)sca);
>> +}
>> +
>> +static void put_vsie_sca(struct vsie_sca *sca)
>> +{
>> +	if (!sca)
>> +		return;
>> +
>> +	WARN_ON_ONCE(atomic_dec_return(&sca->ref_count) < 0);
>> +}
>> +
>> +/*
>> + * Pin and get an existing or new guest system control area.
>> + *
>> + * May sleep.
>> + */
>> +static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie=
_page *vsie_page,
>> +				     gpa_t sca_addr)
>> +{
>> +	struct vsie_sca *sca, *sca_new =3D NULL;
>> +	struct kvm *kvm =3D vcpu->kvm;
>> +	unsigned int max_sca;
>> +	int rc;
>> +
>> +	rc =3D validate_scao(vcpu, vsie_page->scb_o, vsie_page->sca_gpa);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>
> This is wild.
> validate_scao() returns 0/1 (once you fix the bool) and the rest of the=
=20
> function below returns -ERRNO. I think validate_scao() should return=20
> -EINVAL since the scao is clearly invalid if the function doesn't return =
0.
>

Yes, -EINVAL will be much more logical. I will also revisit the rest of the
return codes.

>> +
>> +	/* get existing sca */
>> +	down_read(&kvm->arch.vsie.ssca_lock);
>> +	sca =3D get_existing_vsie_sca(kvm, sca_addr);
>> +	up_read(&kvm->arch.vsie.ssca_lock);
>> +	if (sca)
>> +		return sca;
>> +
>> +	/*
>> +	 * Allocate new ssca, it will likely be needed below.
>> +	 * We want at least #online_vcpus shadows, so every VCPU can execute t=
he
>> +	 * VSIE in parallel. (Worst case all single core VMs.)
>> +	 */
>> +	max_sca =3D MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCP=
US);
>> +	if (kvm->arch.vsie.sca_count < max_sca) {
>> +		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
>> +		sca_new =3D (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>
> sca and sca_new are not FW structs, they are not scas that you can hand=
=20
> over to FW. As such they should not be exclusively named sca. Name them=
=20
> vsie_sca or some other name to make it clear that we're working with a=20
> KVM struct.
>

Will update the sca variables to vsie_sca.

> Is there a need for sca_new to be page allocated?
> vsie_page's size is close to a page and it is similar to sie_page so=20
> that makes sense. But vsie_sca is only a copule of DWORDs until we reach=
=20
> the "pages" member and we could dynamically allocate vsie_sca based on=20
> the actual number of max pages since pages is at the end of the struct.
>

I would rather inline member ssca (struct ssca_block) into struct vsie_sca =
and
then allocate the whole thing at once using
alloc_pages_exact(sizeof(*vsie_sca_new)). That comes out to some words over=
 2
pages.
But I would rather want to allocate the full the space to hold the ssca for=
 an
esca to not have to check and reallocate when reusing the allocation to sha=
dow
another original sca or even when upgrading from bsca to esca. Especially o=
nce
we have the change upstream to start out with the esca for new guest VMs th=
e
likelyhood of esca usages will only go up.

>> +		if (!sca_new)
>> +			return ERR_PTR(-ENOMEM);
>> +
>> +		if (use_vsie_sigpif(vcpu->kvm)) {
>> +			BUILD_BUG_ON(offsetof(struct ssca_block, cpu) !=3D 64);
>> +			sca_new->ssca =3D alloc_pages_exact(sizeof(*sca_new->ssca),
>> +							  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +			if (!sca_new->ssca) {
>> +				free_page((unsigned long)sca);
>> +				sca_new =3D NULL;
>> +				return ERR_PTR(-ENOMEM);
>> +			}
>> +		}
>> +	}
>> +
>> +	/* enter write lock and recheck to make sure ssca has not been created=
 by other cpu */
>> +	down_write(&kvm->arch.vsie.ssca_lock);
>> +	sca =3D get_existing_vsie_sca(kvm, sca_addr);
>> +	if (sca)
>> +		goto out;
>> +
>> +	/* check again under write lock if we are still under our sca_count li=
mit */
>> +	if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
>> +		/* make use of vsie_sca just created */
>> +		sca =3D sca_new;
>> +		sca_new =3D NULL;
>> +
>> +		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] =3D sca;
>> +	} else {
>> +		/* reuse previously created vsie_sca allocation for different osca */
>> +		sca =3D get_free_existing_vsie_sca(kvm);
>> +		/* with nr_vcpus scas one must be free */
>> +		if (IS_ERR(sca))
>> +			goto out;
>> +
>> +		unpin_sca(kvm, sca);
>> +		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
>> +		memset(sca, 0, sizeof(struct vsie_sca));
>> +	}
>> +
>> +	/* use ECB of shadow scb to determine SCA type */
>> +	if (sie_uses_esca(vsie_page->scb_o))
>> +		__set_bit(VSIE_SCA_ESCA, &sca->flags);
>> +	sca->sca_gpa =3D sca_addr;
>> +	sca->pages[vsie_page->scb_o->icpua] =3D vsie_page;
>> +
>> +	if (sca->sca_gpa !=3D 0) {
>> +		/*
>> +		 * The pinned original sca will only be unpinned lazily to limit the
>> +		 * required amount of pins/unpins on each vsie entry/exit.
>> +		 * The unpin is done in the reuse vsie_sca allocation path above and
>> +		 * kvm_s390_vsie_destroy().
>> +		 */
>> +		rc =3D pin_sca(kvm, vsie_page, sca);
>> +		if (rc) {
>> +			sca =3D ERR_PTR(rc);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	atomic_set(&sca->ref_count, 1);
>> +	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
>> +
>> +out:
>> +	up_write(&kvm->arch.vsie.ssca_lock);
>> +	if (sca_new)
>> +		destroy_vsie_sca(kvm, sca_new);
>> +	return sca;
>> +}


