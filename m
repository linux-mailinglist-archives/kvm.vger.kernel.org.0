Return-Path: <kvm+bounces-57429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 868DAB555AB
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF305C0B10
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41F0327A34;
	Fri, 12 Sep 2025 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C/iGDfI+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F0030DED0;
	Fri, 12 Sep 2025 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757699772; cv=none; b=MIvDkELPN1Wm8cczatUefyDYberg9cT75BXb94dzrtlI7Ol3+UcBHxKj8vxM9+jCDVGGaR4zEpeOLl3YMioz6kHvVaGqQK5ZWsbDCFZjzVlwIqzAHotSnzW7l+BG017ZB3qxw2o5wo5GPotzStjyI7oK43l1lZwSJxRzsTWhgs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757699772; c=relaxed/simple;
	bh=Y6YKJmEUZboYUT7iCS3yFYTfJT+GWTUOlJjJCx7HZSs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U1vbd6uj3tJR0ZrtvyZlp6M5uPWT3Bs5L+v077N0aCEHQ+wvGZVDWcwA8n0Ytr8WMP3j9YGcHGovAb0CePSwaljAaV6Mld0fo762NJw16zx0MzJx8/ETC2OVVc0hIIN0ipgjnYmlMLulFol2Z24Tnl4SA2qy1M1i1FJmo9Tt3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C/iGDfI+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C9XeGu005342;
	Fri, 12 Sep 2025 17:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ODvj8i
	gC3COoXgKZG0KHGynGNntrtQmbpTrvJM/LuWQ=; b=C/iGDfI+bQWUoaAomE7/ri
	/EPZYpt9PWljUmQOLbesUAxukxWzuL5zq99ONj46CfT9tNCQd+tluMIbjjVZmX8/
	vVUT2KOxn+MA/PlOYh4/JNuaANmAj/yetdtQdWYmCdSb76K0qSHPrVGlJA/G125D
	ojaB5v7X7vWiM3S1bZ+rcA1MnkS8KGyL1RbPifzOPhejThxwEybp8ulby+DII28d
	DJawXh4ZqH5/QmOLE5Llwb8MbubK9nsoEfT7ztZhHf/rlW8v3wy8GGrmGkEnjHBx
	UMRtvHNjirN50o6Hy57hSrzPJ6dzJUPZngC6FRaJ2d0i6q1+qloTHOqZGxYNvFhw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukf15gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 17:56:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58CErc84017227;
	Fri, 12 Sep 2025 17:56:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmv1uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 17:56:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58CHu4Ij17891838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 17:56:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE00520043;
	Fri, 12 Sep 2025 17:56:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F4620040;
	Fri, 12 Sep 2025 17:56:03 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.85.13])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 17:56:03 +0000 (GMT)
Message-ID: <92285479bc2b97b418b0efe8a52f0711a95cbf36.camel@linux.ibm.com>
Subject: Re: [PATCH v2 05/20] KVM: s390: Add helper functions for fault
 handling
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
Date: Fri, 12 Sep 2025 19:56:02 +0200
In-Reply-To: <20250910180746.125776-6-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	 <20250910180746.125776-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX+mrilySnSLKG
 TSsRHMuhp3Ct/5MJLYdW1cZOCuJF9XFrXTalJWz0K3+Ij1nw0DVeujZ7tFzHx5yIOqRJG1rlYeZ
 lVbhpBjlB+too7dT2ftNL8Y3BclULEfiZvI31DaOMpI5m1/8fjCFbQvPYxnKWc/wEZjyYzLOQjq
 J65NxCX4ohNZSfBQGsgsJ+li6GKYmjDOM6qQnChmksVDqG09Md6CZqmJK4hCO6T3IPUdx7DX4pg
 DkTwWdT/meLLLOFDuIPyOMy5kJbM0+0i0eZ7vjnTyWoLVp/gmUjy1UQqVu/KJjwJF5KVtnYWPev
 CM9lqv3z2ckJxIoTeW9aQJUtgKZIJWkys9rGEvfC1ckYt9QrkHa8pSzagCcg4aHqY/eXhyDDK0+
 9C1x0IRm
X-Proofpoint-ORIG-GUID: RkepuE5y3wT8jEHLKdA0jrtrVaWCVNHP
X-Proofpoint-GUID: RkepuE5y3wT8jEHLKdA0jrtrVaWCVNHP
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c45eb8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=YNtB7HBByXDDIQ3sV5sA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On Wed, 2025-09-10 at 20:07 +0200, Claudio Imbrenda wrote:
> Add some helper functions for handling multiple guest faults at the
> same time.
>=20
> This will be needed for VSIE, where a nested guest access also needs to
> access all the page tables that map it.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.h  | 14 ++++++++++
>  arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h | 56 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 114 insertions(+)
>=20
[...]

> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c44fe0c3a097..dabcf65f58ff 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -22,6 +22,15 @@
>=20
[...]

> +static inline void release_faultin_multiple(struct kvm *kvm, struct gues=
t_fault *guest_faults,
> +					    int n, bool ignore)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < n; i++) {
> +		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
> +					 guest_faults[i].write_attempt);
> +		guest_faults[i].page =3D NULL;
> +	}
> +}
> +
> +static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm=
, unsigned long seq,
> +							 struct guest_fault *guest_faults, int n,
> +							 bool unsafe)

The name of the function does not at all suggest that it releases guest pag=
es.
Can you remove that and use

if (__kvm_s390_fault_array_needs_retry(...))
	release_faultin_array(...);

in the caller?
(I haven't yet looked at those)
"needs_retry" isn't telling me much right now, either.
What is being retried and why?
Comments would not hurt :)

> +{
> +	int i;
> +
> +	for (i =3D 0; i < n; i++) {
> +		if (!guest_faults[i].valid)
> +			continue;
> +		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[=
i].gfn)) ||
> +		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn=
))) {
> +			release_faultin_multiple(kvm, guest_faults, n, true);
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct g=
uest_fault *guest_faults,
> +					       gfn_t start, int n_pages, bool write_attempt)
> +{
> +	int i, rc =3D 0;
> +
> +	for (i =3D 0; !rc && i < n_pages; i++)
> +		rc =3D __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_=
attempt);
> +	return rc;
> +}
> +
> +#define release_faultin_array(kvm, array, ignore) \
> +	release_faultin_multiple(kvm, array, ARRAY_SIZE(array), ignore)
> +
> +#define __kvm_s390_fault_array_needs_retry(kvm, seq, array, unsafe) \
> +	__kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array=
), unsafe)
> +
>  /* implemented in diag.c */
>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
> =20

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

