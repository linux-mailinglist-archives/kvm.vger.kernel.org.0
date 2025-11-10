Return-Path: <kvm+bounces-62598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2A9C496B8
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89DEC188CEC9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0F632ED34;
	Mon, 10 Nov 2025 21:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Lm1tBn8N"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C41532E123;
	Mon, 10 Nov 2025 21:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810384; cv=none; b=lpMet3q3+SWoTyvfgaj2O9UwivyCnn1NPw2OGzFiBrlFQ3d5t6RMBQXKO5WK5HawOpHGZQNzg6jfXBZswAv6+6fzrdA2yRWqLxrNYwDV+QvBHJLDk4q5+YWHYJlLPiOiLekrvyhhR5EOTPWmPQIPPKueMsl9yF+VCNQ+sYibNCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810384; c=relaxed/simple;
	bh=I56UU5AU1EInyWemGjTwNbb3p1xLVLVwehbdUJOt73o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jb96h6UKDiokeBehcByMQGacNaGhf8C5p/pZ2dMM1KfT+DfirwXjdaYPkzbnhYW2htat/98QC0maI72OMUL2NKawZFnDn5LBM0xcJYeUHakf7kjZ/964+yj5lvNscURp8wERNIi0rILMrVKU7ZZCkYg490XHw2MSaJ61RQ/aW+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Lm1tBn8N; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAElWFM029815;
	Mon, 10 Nov 2025 21:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jDpCuQ
	d7ZIO/+9wFAWJ+4gtnfpsddVR7srR/c8VTPMg=; b=Lm1tBn8NfRzhc5/TYpD/a1
	oKnKWuCuvgi96o8aD9fQcRwFnIzdU9NULkoAHeJgwgJl5fFvy1l61dlk0v/xykPy
	M1+ZS4UEY23BtR6T7xHSuOJ3PugJdEyyR/VhPbTSNZh+g4UfLAsTuktmgtrHakQ4
	t+/CSz2299ijy2Srt2Hz1JD48aOfz2ia1ZJvynnJdByLaZFgaj3i48HPY859HAFz
	VEx3/ptxUC1knbEYRIlbmKYH74bu93WLCKUFPAuH4gxjOvYJI2IKOOi+m4791stx
	6fNuMdYncAyt0GP0t1/7ure6mHY2IPRErX/UigBO0el0D5jZwt2rqIzdn/7ThP8g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj12kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 21:32:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAK0tlR007314;
	Mon, 10 Nov 2025 21:32:57 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdj7h84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 21:32:57 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AALWu7C27722426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 21:32:56 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 868DB58056;
	Mon, 10 Nov 2025 21:32:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A05575803F;
	Mon, 10 Nov 2025 21:32:55 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.62.231])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 21:32:55 +0000 (GMT)
Message-ID: <36e9df1ef49110cf4743707f7457e63e34e5e82f.camel@linux.ibm.com>
Subject: Re: [PATCH RFC v2 02/11] KVM: s390: Remove double 64bscao feature
 check
From: Eric Farman <farman@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger	 <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico
 Boehr <nrb@linux.ibm.com>, David Hildenbrand	 <david@redhat.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini	 <pbonzini@redhat.com>, Shuah
 Khan <shuah@kernel.org>
Date: Mon, 10 Nov 2025 16:32:55 -0500
In-Reply-To: <20251110-vsieie-v2-2-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
	 <20251110-vsieie-v2-2-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69125a0a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=hC69KZXbuyQtWk_iz-UA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX9HJ1G56ZVTEI
 xHwE8/FV4CBqh/GF5JjuXvQG2RNvz2TWRwZBSurnlFL0+HtHuwlFnok9FJJT/eJt9afadTgNtZ/
 bEFgH5dQphx65wPHgqrAKb57pCdBBsvv7m2TWD5sSZB0Zumr/okC4ZlMDkcFvuNicPWQftgoRTL
 MBaWsdr18iVo2Om+csmpcpa+rlOxtzpODj3QZzVthImKJRS5PM9Eb1382cb24RV36P6dj2/R9AO
 nG58XVfPcNbXg9+ANE/wuEDSsfilcpowwI+ZhQNn7Tl0bTSBDidWDZEPdLIs05TYetZMkLBvCGB
 Q/zGnkZoNvyUQ+Dim+zldlNZp5PpTm5LbOiTQi2wl0szsV3dreH4cqnLp6vemJtf1G580PYaD8h
 cfWdA8DiJnsKJpST0Vf6HXMZW6k/FA==
X-Proofpoint-GUID: VPJoFpb2aIhXccMa7XgM5Idz9DyBUHK3
X-Proofpoint-ORIG-GUID: VPJoFpb2aIhXccMa7XgM5Idz9DyBUHK3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Mon, 2025-11-10 at 18:16 +0100, Christoph Schlameuss wrote:
> sclp.has_64bscao is already verified in the guard clause a few lines
> above this. So we cannot reach this code if it is not true.
>=20
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 769820e3a2431c16c7ec85dbf313f61f7ba1a3cc..984baa5f5ded1e05e389abc48=
5c63c0bf35eee4c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -455,8 +455,7 @@ static void __init kvm_s390_cpu_feat_init(void)

Context:
        if (!sclp.has_sief2 || !machine_has_esop() || !sclp.has_64bscao ||
>  	    !test_facility(3) || !nested)
>  		return;
>  	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIEF2);
> -	if (sclp.has_64bscao)
> -		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);
> +	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);

Ha, yup.

Reviewed-by: Eric Farman <farman@linux.ibm.com>

>  	if (sclp.has_siif)
>  		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIIF);
>  	if (sclp.has_gpere)

