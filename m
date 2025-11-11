Return-Path: <kvm+bounces-62728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD9DC4C546
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96D9189E4D9
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F9232F77F;
	Tue, 11 Nov 2025 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BSQzr49q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1852FB629;
	Tue, 11 Nov 2025 08:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762848800; cv=none; b=iBWx4/LCOJHil+XUGcX9nH51pnTIZd/431nZ+8IfdDp2hPsTDYn2b/8Sk5ckAvp3rXXFJMg0VL6ceKkvieNkTAszgderCZ/uDuuo0JNuRKx8wznPXHpZ4iw1zncawxf+ylPJVPoT7Nv2xi9lbIpNGFrWOTG2+3GSLl35YKGKWIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762848800; c=relaxed/simple;
	bh=WBhs09FFluzRch+yyJAu47OKXpPRUHJJuZFrEfWshWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3742HGlsCCP2nkr4e9jrzl1Ap4/bBeHd8qIo4Qx+ECh0I6dQOazRBAf+/TXT6QgVGc7mr5LzXyMM4YR0J8whS/5I8rDRzZBHHrs2F3P72ew9PPehL+1k7dAntfyis77K1lzKpwk5k5Bp5mkNFltWTgmMSl1NwGEXXjqZZqdduw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BSQzr49q; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB4RSdH025181;
	Tue, 11 Nov 2025 08:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:sender:subject:to; s=pp1; bh=x2GKGJh1HojmVjCsLyDHnaS
	SrgB21ao/zOSFwkEAWdk=; b=BSQzr49qa8IVkxCOP/uGwZqzqGRYYs2p/nDbGNY
	slBKrnQ1QLJKesP6NcYl52SOSLjYKFxzyNxtVrMWjfwwC5CsNsq2cUSd+qBnSbLK
	3kgWitzhOhzsGjwyvRUYZ7BEqK/fzXjdOKSCXp/bDjgXe3GpYLzRw+/4IaUXNeK6
	5V3odXUj/y5xpFEBFIcfJZcibl6A9IBxXNnf3IMFm3RHj9vK+aZ+L+awgxWbNyxb
	PPxfde1yiLKGhkQ5X8wAPoDWyKLP8W3rhuXOR38JRn9+Jdyn1n7CgASDXzgU/uBY
	K6om6DqTRXH4byUlfWRRBEViATE2mThNvfLZhmAgx0QF+vA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m825h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:13:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5ACKl028867;
	Tue, 11 Nov 2025 08:13:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aag6s9xrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:13:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AB8D9UW31326514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 08:13:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E6D12004D;
	Tue, 11 Nov 2025 08:13:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 098F820043;
	Tue, 11 Nov 2025 08:13:09 +0000 (GMT)
Received: from vela (unknown [9.155.211.212])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 11 Nov 2025 08:13:08 +0000 (GMT)
Received: from brueckner by vela with local (Exim 4.98.2)
	(envelope-from <brueckner@linux.ibm.com>)
	id 1vIjUy-000000005zG-2vtw;
	Tue, 11 Nov 2025 09:13:08 +0100
Date: Tue, 11 Nov 2025 09:13:08 +0100
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH RFC v2 02/11] KVM: s390: Remove double 64bscao feature
 check
Message-ID: <aRLwFNV3SU4_3rZA@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-2-9e53a3618c8c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110-vsieie-v2-2-9e53a3618c8c@linux.ibm.com>
Sender: Hendrik Brueckner <brueckner@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=6912f01a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Ga-AtK6nKil8RvkuQPcA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: bFwWBX-YFF3KhtdxkJ4qVb9V_Mp828qm
X-Proofpoint-ORIG-GUID: bFwWBX-YFF3KhtdxkJ4qVb9V_Mp828qm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX1iiwVnoTS3TI
 yaL63ZxZ7aI4mSAk+hkdGadkQiEcgusXP2ra0dKBba9SuqTK3j+Oum0jYsUFA1+9Hs74A7JDC7H
 ruf3lAukC4Dgg7xw7gyw0l+QTOXCmOQsgPixb00RKD4MwE3b/9/xS+2BgPXzw4tEVoJydwI49W4
 dPSqODCCrz2wg/ROtWh/D88uLuF1vO/z4iBsoNWD34m8tqMNdoCid6LHMps0rzhaDpyM7bu9Njl
 E+EEx1kfGlvjgfD124MUz56eqzf+9WetuxAopyis/AOg8sMESneZNAfqXSRSw+rOtBmlvcJ5sSu
 wOUXpUkModgyDBQXRZZiAm5FSoY3vLzp64MZwbzOC3LvuztGGu7lBmVIxtSLPB6xSPiTbrgnG4M
 t7uraNk5zgmnGcbN3Kw+mmZlZJGmGQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

On Mon, Nov 10, 2025 at 06:16:42PM +0100, Christoph Schlameuss wrote:
> sclp.has_64bscao is already verified in the guard clause a few lines
> above this. So we cannot reach this code if it is not true.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 769820e3a2431c16c7ec85dbf313f61f7ba1a3cc..984baa5f5ded1e05e389abc485c63c0bf35eee4c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -455,8 +455,7 @@ static void __init kvm_s390_cpu_feat_init(void)
>  	    !test_facility(3) || !nested)
>  		return;
>  	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIEF2);
> -	if (sclp.has_64bscao)
> -		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);
> +	allow_cpu_feat(KVM_S390_VM_CPU_FEAT_64BSCAO);
>  	if (sclp.has_siif)
>  		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIIF);
>  	if (sclp.has_gpere)
> 

Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>

