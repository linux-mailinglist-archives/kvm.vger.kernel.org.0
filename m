Return-Path: <kvm+bounces-63388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B118C64EB4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 707443431EC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE74F2701DA;
	Mon, 17 Nov 2025 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lyy1xye9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F12426F285;
	Mon, 17 Nov 2025 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763393987; cv=none; b=DzJDDDjemHQR7+Ta2+8n2kGAdJZQDC0U0l2QUd9xqQbZjSYKm+MJ5UEha7gQGJCuu8Ej8Qq30MBMEIY/OA2YocL4ReI+SqLDg1ZPp67zGA2de9BZuWhuLFNhvP7yeenh9n1TMo44JlhmWo0CJYBaPvIHA3tstjJcVO0KJQa5g48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763393987; c=relaxed/simple;
	bh=c5NXHJR7fGSb0xxCuZoObhb0hPY+9xF7YmYiUsBBQeA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=YC0InBq+XfaWS5ToNEWv2ZuxizQucHsYwJ29q7/V6vL4EHnv7uIW82nPFPFjuNDyq159qfnuoSx6e0wOjzU5zQoZfZ+7pSLf1oXRd1ToEB6rbfIc+FPJ/Aj6zF2xKeSjTSWJl8Srumv7GdP3MtHEBI5pnLzCyzwGeEOSH+EUiHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lyy1xye9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH9liB8013051;
	Mon, 17 Nov 2025 15:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wduAFa
	UIIb016RzZ6GW5BNy/Q5aJH/rLX2WiqAXI1es=; b=lyy1xye9FKvawV8KbL1auo
	ZuccEvQcsDbH0TJmbG+oBBKCf4odCyE2u7SG4dPYfZOG7qUhZ95jeTlv6zMsqyWw
	x2aCkdjRbW6WEMz9BSpuiWrOw36kGiJ1rhwOTB3ymzdrrHkGmD3XkNJFyJkF8u+z
	3AG3U69W1IrBauLVRoOC35/h5MXZ4W4mn3DtaHe3cWY5LIkNUBMNAfANMAk9itGu
	ks693xgUGD6lyXNh2YxjrRmi8vzpKXIxj/LI7uQLdGbvqQhcVuCPLzgFkbIAxf5l
	c8PIVL/wz+5mrwGVnWXJqVQkGYM8mXqzzZ/A6umuBddT9Gm68h0eIzgLUp2wfTLg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjvxxmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 15:39:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHEjUef022311;
	Mon, 17 Nov 2025 15:39:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4umpm19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 15:39:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AHFdZ5H26280402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:39:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B9B52004B;
	Mon, 17 Nov 2025 15:39:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FE9420040;
	Mon, 17 Nov 2025 15:39:35 +0000 (GMT)
Received: from darkmoore (unknown [9.111.6.92])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Nov 2025 15:39:34 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Nov 2025 16:39:29 +0100
Message-Id: <DEB2ZQ9XHHQO.1XWSIQ15M036Q@linux.ibm.com>
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
 <1c5279ce-b0d6-4c08-becb-b52d7d6d48ae@linux.ibm.com>
In-Reply-To: <1c5279ce-b0d6-4c08-becb-b52d7d6d48ae@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691b41bc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=vu4FiGKeA0I0DeMifdQA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX3/YBqAQfrdS9
 ShlZud21g7+LPJI5aTKzEWnNm2lVQvLJlxkdfuqfa50N+P/p8JYjUCy4jcFiTX5M8l7S52ykLuv
 DFBsaWCISkzmvj24OYS8Jf+cnnZDJIE+IROO/C83m0YIZ6w4G3dclkx0LUmiausIsos9HMkgOY+
 AQBTv19FZfjMjnwDi69pVT3AVlRffM7xgMWt+Rnu2gzniWLpIgFSdsJ49JIqzp0GZfm85q9KoLq
 p9dSskotP/84FsV5EJ6XIc8VnkqaCVt/ccXHLdYpwQtcHDI5DfKttFImxTDviJ/81SD4vyMjbj2
 XBxYrgI6tf9FrC36P8n/QFPk+vZ0uHMtuwDxq/b8bMxpyTGLEA9VX9OQ1WxvgXZIFCHd7XP+aRw
 BjV7HEXvDX7I/CuYnwIWnU1yaXydKw==
X-Proofpoint-GUID: 4qoBBFA6TJHq5uCvISq8wmFBVtciX2lp
X-Proofpoint-ORIG-GUID: 4qoBBFA6TJHq5uCvISq8wmFBVtciX2lp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Fri Nov 14, 2025 at 3:09 PM CET, Janosch Frank wrote:
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
>> ---
>>   arch/s390/include/asm/kvm_host.h       |  11 +-
>>   arch/s390/include/asm/kvm_host_types.h |   5 +-
>>   arch/s390/kvm/kvm-s390.c               |   6 +-
>>   arch/s390/kvm/kvm-s390.h               |   2 +-
>>   arch/s390/kvm/vsie.c                   | 672 +++++++++++++++++++++++++=
+++-----
>>   5 files changed, 596 insertions(+), 100 deletions(-)
>>=20
>
> [...]
>
>> +enum vsie_sca_flags {
>> +	VSIE_SCA_ESCA =3D 0,
>> +	VSIE_SCA_PINNED =3D 1,
>>   };
>>  =20
>>   struct vsie_page {
>> @@ -62,7 +68,9 @@ struct vsie_page {
>>   	 * looked up by other CPUs.
>>   	 */
>>   	unsigned long flags;			/* 0x0260 */
>> -	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
>> +	/* vsie system control area */
>> +	struct vsie_sca *sca;			/* 0x0268 */
>> +	__u8 reserved[0x0700 - 0x0270];		/* 0x0270 */
>>   	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
>>   	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
>>   };
>> @@ -72,6 +80,41 @@ struct kvm_address_pair {
>>   	hpa_t hpa;
>>   };
>>  =20
>> +/*
>> + * Store the vsie system configuration data.
>> + */
>> +struct vsie_sca {
>> +	/* calculated guest addresses of the sca */
>
> Can you move the comments to the right?
> Well, actually I'm not sure why we need them at all.
> Aren't the variable names enough?
>

For me they surely are ;) But that is always the issue when writing the cod=
e. I
will cut them down.

>> +	gpa_t			sca_gpa;
>> +	atomic_t		ref_count;
>> +	/* defined in enum vsie_sca_flags */
>
> Move the enum above the struct please.
>

Will do.

>> +	unsigned long		flags;
>> +	unsigned long		sca_o_nr_pages;
>> +	struct kvm_address_pair	sca_o_pages[KVM_S390_MAX_SCA_PAGES];
>> +	u64			mcn[4];
>> +	struct ssca_block	*ssca;
>> +	int			page_count;
>> +	int			page_next;
>> +	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
>> +};
>> +
>> +static inline bool use_vsie_sigpif(struct kvm *kvm)
>> +{
>> +	return kvm->arch.use_vsie_sigpif;
>> +}
>> +
>> +static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_pag=
e *vsie_page)
>
> The "for" in the name is weird.
>
> Also, why are we allocating fenced on use_vsie_sigpif() but then shadow=
=20
> on the EC bits and sigpif? If neither extcall nor SRS are interpreted,=20
> why shadow via vsigpif at all?
>

Right, I then also can inline the vsie_sca->ssca / ssca_block into the stru=
ct
and just have a single allocation. That should simplify some thing at least=
 a
little bit.

>> +{
>> +	return use_vsie_sigpif(kvm) &&
>> +	       (vsie_page->scb_o->eca & ECA_SIGPI) &&
>> +	       (vsie_page->scb_o->ecb & ECB_SRSI);
>
> Is SIGPI a prereq for SRSI and vice versa for vsigpif?
> If no, then this should not be anded.
>

Ack.

>> +}
>> +
>> +static inline bool sie_uses_esca(struct kvm_s390_sie_block *scb)
>> +{
>> +	return (scb->ecb2 & ECB2_ESCA);
>> +}
>> +
>>   /**
>>    * gmap_shadow_valid() - check if a shadow guest address space matches=
 the
>>    *                       given properties and is still valid
>> @@ -630,6 +673,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
>>   		scb_s->ictl |=3D ICTL_ISKE | ICTL_SSKE | ICTL_RRBE;
>>  =20
>>   	scb_s->icpua =3D scb_o->icpua;
>> +	write_scao(scb_s, virt_to_phys(vsie_page->sca->ssca));
>> +	scb_s->osda =3D virt_to_phys(scb_o);
>>  =20
>>   	if (!(atomic_read(&scb_s->cpuflags) & CPUSTAT_SM))
>>   		new_mso =3D READ_ONCE(scb_o->mso) & 0xfffffffffff00000UL;
>> @@ -681,6 +726,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
>>   	/* Instruction Execution Prevention */
>>   	if (test_kvm_facility(vcpu->kvm, 130))
>>   		scb_s->ecb2 |=3D scb_o->ecb2 & ECB2_IEP;
>> +	/* extended SCA */
>> +	scb_s->ecb2 |=3D scb_o->ecb2 & ECB2_ESCA;
>>   	/* Guarded Storage */
>>   	if (test_kvm_facility(vcpu->kvm, 133)) {
>>   		scb_s->ecb |=3D scb_o->ecb & ECB_GS;
>> @@ -713,12 +760,250 @@ static int shadow_scb(struct kvm_vcpu *vcpu, stru=
ct vsie_page *vsie_page)
>>   	return rc;
>>   }
>>  =20
>> +/* Called with ssca_lock held. */
>> +static void unpin_sca(struct kvm *kvm, struct vsie_sca *sca)
>> +{
>> +	if (!test_bit(VSIE_SCA_PINNED, &sca->flags))
>> +		return;
>> +
>> +	unpin_guest_pages(kvm, sca->sca_o_pages, sca->sca_o_nr_pages);
>> +	sca->sca_o_nr_pages =3D 0;
>> +
>> +	__clear_bit(VSIE_SCA_PINNED, &sca->flags);
>> +}
>> +
>> +/* pin g2s original sca in g1 memory */
>> +static int pin_sca(struct kvm *kvm, struct vsie_page *vsie_page, struct=
 vsie_sca *sca)
>> +{
>> +	bool is_esca =3D sie_uses_esca(vsie_page->scb_o);
>> +	int nr_pages =3D KVM_S390_MAX_SCA_PAGES;
>> +
>> +	if (test_bit(VSIE_SCA_PINNED, &sca->flags))
>> +		return 0;
>> +
>> +	if (!is_esca) {
>> +		nr_pages =3D 1;
>> +		if ((sca->sca_gpa & ~PAGE_MASK) + sizeof(struct bsca_block) > PAGE_SI=
ZE)
>> +			nr_pages =3D 2;
>> +	}
>> +
>> +	sca->sca_o_nr_pages =3D pin_guest_pages(kvm, sca->sca_gpa, nr_pages, s=
ca->sca_o_pages);
>> +	if (WARN_ON_ONCE(sca->sca_o_nr_pages !=3D nr_pages)) {
>> +		set_validity_icpt(&vsie_page->scb_s, 0x0034U);
>> +		return -EIO;
>
> Any idea when this would happen?
> gpa translate to last page and following pages would be over the guests=
=20
> allowed memory?
>

Not really, if this would happen we would surely not want to go on.

>> +	}
>> +	__set_bit(VSIE_SCA_PINNED, &sca->flags);
>> +
>> +	return 0;
>> +}
>> +
>> +static void get_sca_entry_addr(struct kvm *kvm, struct vsie_page *vsie_=
page, struct vsie_sca *sca,
>> +			       u16 cpu_nr, gpa_t *gpa, hpa_t *hpa)
>> +{
>> +	hpa_t offset;
>> +	int pn;
>> +
>> +	/*
>> +	 * We cannot simply access the hva since the esca_block has typically
>> +	 * 4 pages (arch max 5 pages) that might not be continuous in g1 memor=
y.
>> +	 * The bsca_block may also be stretched over two pages. Only the heade=
r
>> +	 * is guaranteed to be on the same page.
>> +	 */
>> +	if (test_bit(VSIE_SCA_ESCA, &sca->flags))
>> +		offset =3D offsetof(struct esca_block, cpu[cpu_nr]);
>> +	else
>> +		offset =3D offsetof(struct bsca_block, cpu[cpu_nr]);
>> +	pn =3D ((vsie_page->sca->sca_gpa & ~PAGE_MASK) + offset) >> PAGE_SHIFT=
;
>> +	if (WARN_ON_ONCE(pn > sca->sca_o_nr_pages))
>> +		return;
>> +
>> +	if (gpa)
>> +		*gpa =3D sca->sca_o_pages[pn].gpa + offset;
>> +	if (hpa)
>> +		*hpa =3D sca->sca_o_pages[pn].hpa + offset;
>> +}


