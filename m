Return-Path: <kvm+bounces-41588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5A9A6AC5A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FE9B189166C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBBB2236FC;
	Thu, 20 Mar 2025 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GEmmKRoM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0785579F2;
	Thu, 20 Mar 2025 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742492781; cv=none; b=lz+EpsY4iuZO1zj9xDQzqhqgdDMstfxyxB2i9AZgyhGbG+T61nuQUOMOpz18txCj8xTSskG21hqgO/Mwc0XSfrqlxZwGmDVmwSra8Tz0flcZrDapC1NCeheyzCaewD5bTLjv6qLOBwMu1qlW8NXvsyz2IH2k878LuTboqDoCW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742492781; c=relaxed/simple;
	bh=EUkmoBUO/3XHU00lALn7PlB6uJZI/M9I+UhX7Fk0KQM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=rIq0IBu4lP9Js57heXF0R348Wru/JORuyDp6Jt7FZbjw+K2n9S0aU4z1xCwVQe4yEzNU09bfIuWxLMbsX7o+vu0OypszfhUkuveLwMIfhkIjIm4yjP/6EZQUXGJjOZT+8E1iZWcvEtvtIqMB8Jb/TTmfzqxjsBJx0dPtmOIU49I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GEmmKRoM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KCRrcD030255;
	Thu, 20 Mar 2025 17:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XI+qQc
	d22f+3nzHsKCNofRRcntEIcxfYcOnpUtKW9h8=; b=GEmmKRoM5AfyBLgANQj8HJ
	Vcz8MAj9TvyLSHKTtNWfuWI8FCDYsWB1+lgA42boqjleEpms3ei88giYSIQCjnEB
	p44RK4URfnkTehZA78IOdpuq/XgFF+KyO1CNNwFaKKbuZMyvitBNMxHntvypXVj2
	hBcYcmka0EOUzMB+Dxk6PVp8d+184AdEkquQyEU+dliszIMPiXhE4YLrtZc/wcvt
	r4KKSN7u3qWUpuitktf5953pvDDmPhtDjEosTGLE0ov1QaNqSQmIIRcxcUUPYxRs
	+FCtilpJEfPVU4cB96C5KIVT6eQELLQgwppFzx8fZqVw4+uRAaUeL/ijG5ukaG5Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45gk21stj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 17:46:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52KHiRwu005628;
	Thu, 20 Mar 2025 17:46:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dm909cpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 17:46:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52KHkCQb59572496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 17:46:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBDA12004B;
	Thu, 20 Mar 2025 17:46:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8A9820043;
	Thu, 20 Mar 2025 17:46:11 +0000 (GMT)
Received: from darkmoore (unknown [9.171.36.179])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Mar 2025 17:46:11 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Mar 2025 18:46:06 +0100
Message-Id: <D8LA4TZSP197.BFRXHQBPA6SJ@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven Schnelle"
 <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, <linux-s390@vger.kernel.org>
To: "Nico Boehr" <nrb@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 3/5] KVM: s390: Shadow VSIE SCA in guest-1
X-Mailer: aerc 0.20.1
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
 <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
 <D8L732XS5NQW.1M5J3D0TFMQMD@linux.ibm.com>
In-Reply-To: <D8L732XS5NQW.1M5J3D0TFMQMD@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8WE2WiiYQxGTMnHat-MZefTV_BclGeuD
X-Proofpoint-GUID: 8WE2WiiYQxGTMnHat-MZefTV_BclGeuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_05,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=969
 malwarescore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503200111

On Thu Mar 20, 2025 at 4:22 PM CET, Nico Boehr wrote:
> On Tue Mar 18, 2025 at 7:59 PM CET, Christoph Schlameuss wrote:
> [...]
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index 0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22..4ab196caa9e79e4c4d295d23=
fed65e1a142e6ab1 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
> [...]
>> +static struct ssca_vsie *get_ssca(struct kvm *kvm, struct vsie_page *vs=
ie_page)
>> +{
>> +	u64 sca_o_hva =3D vsie_page->sca_o;
>> +	phys_addr_t sca_o_hpa =3D virt_to_phys((void *)sca_o_hva);
>> +	struct ssca_vsie *ssca, *ssca_new =3D NULL;
>> +
>> +	/* get existing ssca */
>> +	down_read(&kvm->arch.vsie.ssca_lock);
>> +	ssca =3D get_existing_ssca(kvm, sca_o_hva);
>> +	up_read(&kvm->arch.vsie.ssca_lock);
>> +	if (ssca)
>> +		return ssca;
>
> I would assume this is the most common case, no?
>
> And below only happens rarely, right?
>

By far, yes.

>> +	/*
>> +	 * Allocate new ssca, it will likely be needed below.
>> +	 * We want at least #online_vcpus shadows, so every VCPU can execute t=
he
>> +	 * VSIE in parallel. (Worst case all single core VMs.)
>> +	 */
>> +	if (kvm->arch.vsie.ssca_count < atomic_read(&kvm->online_vcpus)) {
>> +		BUILD_BUG_ON(offsetof(struct ssca_block, cpu) !=3D 64);
>> +		BUILD_BUG_ON(offsetof(struct ssca_vsie, ref_count) !=3D 0x2200);
>> +		BUILD_BUG_ON(sizeof(struct ssca_vsie) > ((1UL << SSCA_PAGEORDER)-1) *=
 PAGE_SIZE);
>> +		ssca_new =3D (struct ssca_vsie *)__get_free_pages(GFP_KERNEL_ACCOUNT =
| __GFP_ZERO,
>> +								SSCA_PAGEORDER);
>> +		if (!ssca_new) {
>> +			ssca =3D ERR_PTR(-ENOMEM);
>> +			goto out;
>> +		}
>> +		init_ssca(vsie_page, ssca_new);
>> +	}
>> +
>> +	/* enter write lock and recheck to make sure ssca has not been created=
 by other cpu */
>> +	down_write(&kvm->arch.vsie.ssca_lock);
>
> I am wondering whether it's really worth having this optimization of tryi=
ng to
> avoid taking the lock? Maybe we can accept a bit of contention on the rwl=
ock
> since it shouldn't happen very often and keep the code a bit less complex=
?

With that reasoning I did not try to reduce the section under the write loc=
k
further than it is now. I would hope this is a somewhat good balance. The
allocation really is the "worst" bit I would rather not do under the write =
lock
if possible.

I can try to make this a bit easier to read.

