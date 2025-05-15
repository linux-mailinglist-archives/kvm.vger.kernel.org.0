Return-Path: <kvm+bounces-46680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE7CAB84C0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B17EB189063E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB5429824B;
	Thu, 15 May 2025 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iZwlBg7w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50628003F;
	Thu, 15 May 2025 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747308409; cv=none; b=IXst4wa/N19pMgV2xJswL8RYGz0PtPgSGjLQrNGLNOci54e/+vjigPgvQRXNqDmhWB6Fp5wJSBjsRBAVqTTnEAz67kTKJ2JPpnJ8K51bR0pupKjxgTxg1FMkkUvy+dRJzthcd8e8T/JldRDX/z/l68nyWNojaiMDY3wcTW2kpzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747308409; c=relaxed/simple;
	bh=wJudgktcMt4NPJ3pwlQJdKMCMJAqE9Fd/hQtuq1RWYE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ojz5Npu866JMDEprvgWRrKdWmV+tNBKKa5f/P4/f/UCd3LBENk8UmLk6lGHywpKonD21IS3Slkefy2fJocX+YVCPjSmg1joGIXlHNW6ktrLsMdnCL+UXTMc+vAVB7PAceJYbINUyy9qCPd/9XP09W3XNS0AF64Odk96flZ4cu8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iZwlBg7w; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F9ExKX017363;
	Thu, 15 May 2025 11:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HXZCtz
	DhTIw9IIAml18Nk1hBS5XtAkpc0JGpvZ6czSk=; b=iZwlBg7wcd7aW4tRyMCyF4
	psazf3KvHJ/+ksZ4UdTYLdlqqk2hdau5Vu/fOk3lRyX7FqN1HCn0eliQMA14In/o
	jY/bbR4u3GyElHrLKEg6QDlfOE7rBiBtzJUa+Uf9pwJoOaAWTeBOQo0pv6FB5Kg7
	y3Z2noCqW0usq1kT3DoBNoJRzECdeoBT8kC0Cn/BqtGuEgzBpj/asC/jgV0UVIaY
	oYYpPPV7NVQ/YnGXDZ5SVuVuG21DCLK1PHPuv5zFqRvfsZaKJUykDgdCjDD4ivGf
	ZHvMp9ptSiyl5tKZvKSr1svCGcZFo7NJdKQwz9pr3H1yIY81T2+xwODnzJyNKbhg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ndfjrktn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FADRKJ021806;
	Thu, 15 May 2025 11:26:44 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpsvx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FBQe1L48496968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 11:26:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B3BD20084;
	Thu, 15 May 2025 11:26:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C9C820083;
	Thu, 15 May 2025 11:26:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 11:26:40 +0000 (GMT)
Date: Thu, 15 May 2025 13:14:47 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: s390: Set KVM_MAX_VCPUS to 256
Message-ID: <20250515131447.5d99ce69@p-imbrenda>
In-Reply-To: <20250514-rm-bsca-v1-1-6c2b065a8680@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
	<20250514-rm-bsca-v1-1-6c2b065a8680@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qiBadI-QXyyzfmEQyMSZ2QedaS9h_qiy
X-Authority-Analysis: v=2.4 cv=ecg9f6EH c=1 sm=1 tr=0 ts=6825cf75 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=aIpEvDJpU-EyJW3OM6wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: qiBadI-QXyyzfmEQyMSZ2QedaS9h_qiy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEwOSBTYWx0ZWRfXwxjvEDAgfL9S QnZEETnTuP2R5vbnyE4Yf0vPhy++h1MTIsbNUWHGqvCv+DV93PhUr71jFa1zw6i+WO1g+lTRUvx Qv0WSMycUjoEeLOj3/UL27leNAj+HIwJiqgP9eQuUQsqv1hH4TOt6mOJcM+0QoBMCxz96fYr3OD
 0bPA72Rkg1R9FUWZ0WyeGNdBLQn2SFeF13KeFYIPCU0UzAISmZz9oheEJ+NeU5IYy/k0A3oGWMM FQCeuzEp4W9cFNPv6drC2AV4mxkVkv3UOIltQMlmGTXqqaweoCFZNOVmpVYkL65TUg2Mn4Wf15i Ops46q+ZIT5QwnQrjQ9eERQfUrsGjye1yi6iUtxOJ2WLsrxHO7KoDyc9xpQZtRWi84gAQblcxBa
 4k4h9spDH85ALrUuRdRDtUtuCi7/sXSZ1aoOf6Q0wYmMmTjpsydnAUx++MTCmFSfQfcVkfMi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=881
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150109

On Wed, 14 May 2025 18:34:49 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> The s390x architecture allows for 256 vCPUs with a max CPUID of 255.
> The current KVM implementation limits this to 248 when using the
> extended system control area (ESCA). So this correction should not cause
> any real world problems but actually correct the values returned by the
> ioctls:
> 
> * KVM_CAP_NR_VCPUS
> * KVM_CAP_MAX_VCPUS
> * KVM_CAP_MAX_VCPU_ID
> 
> KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
> future type definitions.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h       | 2 --
>  arch/s390/include/asm/kvm_host_types.h | 2 ++
>  arch/s390/kvm/kvm-s390.c               | 2 ++
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..f51bac835260f562eaf4bbfd373a24bfdbc43834 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -27,8 +27,6 @@
>  #include <asm/isc.h>
>  #include <asm/guarded_storage.h>
>  
> -#define KVM_MAX_VCPUS 255
> -
>  #define KVM_INTERNAL_MEM_SLOTS 1
>  
>  /*
> diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
> index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f85b4b974c344769a 100644
> --- a/arch/s390/include/asm/kvm_host_types.h
> +++ b/arch/s390/include/asm/kvm_host_types.h
> @@ -6,6 +6,8 @@
>  #include <linux/atomic.h>
>  #include <linux/types.h>
>  
> +#define KVM_MAX_VCPUS 256
> +
>  #define KVM_S390_BSCA_CPU_SLOTS 64
>  #define KVM_S390_ESCA_CPU_SLOTS 248
>  
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..b65e4cbe67cf70a7d614607ebdd679060e7d31f4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -638,6 +638,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			r = KVM_S390_ESCA_CPU_SLOTS;
>  		if (ext == KVM_CAP_NR_VCPUS)
>  			r = min_t(unsigned int, num_online_cpus(), r);
> +		else if (ext == KVM_CAP_MAX_VCPU_ID)
> +			r -= 1;
>  		break;
>  	case KVM_CAP_S390_COW:
>  		r = machine_has_esop();
> 


