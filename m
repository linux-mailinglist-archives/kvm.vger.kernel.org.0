Return-Path: <kvm+bounces-32433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D629D8558
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A91E11666BE
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089651A76D0;
	Mon, 25 Nov 2024 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gGczVFoL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA9619DF66;
	Mon, 25 Nov 2024 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732537253; cv=none; b=j9ne3o+dIhww8B1V0y0r0skX9lUW6aPB4dv7n2ZzoVjgCQEicM+EiB2qHFGR72yB0cCjC0RBwxy799W08xwuViAFRPgP8qjdHN7wv/uDQTW5grqET/pctAVLranAYQJjwzO0tmf6+aAAwhM/8SkKg2R2pcUn0Dhr6biMv2zg2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732537253; c=relaxed/simple;
	bh=UwQzAV6pygolccPeZJqLGBDA4xJBjDxL5lR4HuUXWck=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXos+F5oFhBw3ESJlyJNvd341NGXEFnPZx7j+MoI1qserCevWtOCWLYmZTiF4CcBI2D2OerNItoREL+3s0v8cwEHmHfuqTPzLeiVmgT9UJAYGydn66bfuO93cNhpaaF+1JeVforbS12ZcUatxyJ6yc3fmGAVR1MmUfRq8HUipUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gGczVFoL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APBcL4P000762;
	Mon, 25 Nov 2024 12:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Gr/IGm
	sKdcl1voX3o1/yyOorAqfygXc1qtIMJwHSFvs=; b=gGczVFoLhnEzH74D5YZodE
	culnlsQXzZtTIJmcAbAOVNxLbMchTqTBkpjUcRg5/oBCrrmYVQhAAveS9coSGxva
	hjYQrWk6A8NEjZOIoe4jl7aMr09W3kKlw5fOZfyhw+VA/0hnPUWyMCQC+s7HKafW
	1ER1RYa0szNVpKsyZKgXSg6zfTouOD4EzwBXg0QqXIH4Sbf8oX6Cp9i3kM6H39DJ
	of/o3QGjLdQhw0QhErRlEnxhbc6w3BM/forbmeF9VsZjPIRQtNbdyk8lTSw//0L5
	6In+C03TWVc4SIEB1tWlh6FMt2G3HgjmvzcJPafBXMJkBV6+hmtVPqJM7CsmbSsg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4338a7825a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:20:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP50mmp003199;
	Mon, 25 Nov 2024 12:20:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmafuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:20:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APCKiIn52822338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 12:20:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A51520049;
	Mon, 25 Nov 2024 12:20:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E0392004B;
	Mon, 25 Nov 2024 12:20:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 12:20:44 +0000 (GMT)
Date: Mon, 25 Nov 2024 13:20:42 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241125132042.44918953@p-imbrenda>
In-Reply-To: <20241125115039.1809353-4-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
	<20241125115039.1809353-4-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CPimPQspbuy7oqgm6e5MGZXLUdxiEY7y
X-Proofpoint-ORIG-GUID: CPimPQspbuy7oqgm6e5MGZXLUdxiEY7y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=933 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250103

On Mon, 25 Nov 2024 12:50:39 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> kvm_s390_update_topology_change_report() modifies a single bit within
> sca_utility using cmpxchg(). Given that the size of the sca_utility union
> is two bytes this generates very inefficient code. Change the size to four
> bytes, so better code can be generated.
> 
> Even though the size of sca_utility doesn't reflect architecture anymore
> this seems to be the easiest and most pragmatic approach to avoid
> inefficient code.

wouldn't an atomic bit_op be better in that case?

> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 1cd8eaebd3c0..1cb1de232b9e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -95,10 +95,10 @@ union ipte_control {
>  };
>  
>  union sca_utility {
> -	__u16 val;
> +	__u32 val;
>  	struct {
> -		__u16 mtcr : 1;
> -		__u16 reserved : 15;
> +		__u32 mtcr : 1;
> +		__u32	   : 31;
>  	};
>  };
>  
> @@ -107,7 +107,7 @@ struct bsca_block {
>  	__u64	reserved[5];
>  	__u64	mcn;
>  	union sca_utility utility;
> -	__u8	reserved2[6];
> +	__u8	reserved2[4];
>  	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>  };
>  
> @@ -115,7 +115,7 @@ struct esca_block {
>  	union ipte_control ipte_control;
>  	__u64   reserved1[6];
>  	union sca_utility utility;
> -	__u8	reserved2[6];
> +	__u8	reserved2[4];
>  	__u64   mcn[4];
>  	__u64   reserved3[20];
>  	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];


