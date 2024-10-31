Return-Path: <kvm+bounces-30191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8DF9B7DB8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF581C21880
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4DF1B5821;
	Thu, 31 Oct 2024 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rT5xIYSf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29DE1A264C;
	Thu, 31 Oct 2024 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386917; cv=none; b=YwVxCbQftPxDKeuVC1hxLhxhzkyIf+4xqmZbrsB4GEg1LWpLw30VDQZoEUmFnUrIPbWIHDJDhcg1B+tpEcWJ/2jDxrvHg8OLVvHsc4WR/UjILFEoY5/NuJOZoATNwDszbaZC7o6THJkzJWLo6VR435xt9FCzyGJW41V36+jpvYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386917; c=relaxed/simple;
	bh=DRNAKqCWl6xr2DzwTZ1pWCQyLy5rgo/LXTxk5+5jp9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mo9X0DF8HrOxbMgCRGAHsGRjueH0a9LtoZfb3qfELjQ5eQ8W0bV/SKNASmnU9R4A0W8nQW5jEyAKQ/UcEEK6xoQRt6xEu8tUdKE8wMArVLxtaG9MrCXJdzs/Xdvn6nB0W+wzYjDxedtUYxSufCWb/MDI+s6EoNrRTAdVTtzOUhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rT5xIYSf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V2j1rd012836;
	Thu, 31 Oct 2024 15:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cDdOD8
	eZhdmi15wTlhn2ZOdGiuux+Hscb5nk0qtazGw=; b=rT5xIYSfO4XLgq76ad7K+N
	YzZZXFBVO8+CsPdM81Cdbaa5bQvlM9If2yVDDZnG/O7MLTM5B9/yegUQAJ3rnQoj
	fd5uyKR8VGYzTIFGTthFCbc1GTKha9iWupR42SaUigbIZWXPc59XUf6CvAQ/3YL6
	sAITrNONgk9cNgXvIBoAvlzU/rVMtUxKixWlMBEejHVEEYb75RPuPqjBynrQVfKE
	60aKDkGsB9BuS0p1qmtcvL6SO5ulx/u2+OCmA1sdDjcaEYtoT3pHbW3gPgHYuSeX
	JVHHh83mHhx94tndcsLOJnvzCwSdFdteXT6HTCoYUqQqYLMtnx3iXItJ5hdy5HZg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nt5e5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 15:01:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VD8hPT017353;
	Thu, 31 Oct 2024 15:01:53 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42harsnj5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 15:01:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VF1oWV59703648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 15:01:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FB3E2004E;
	Thu, 31 Oct 2024 15:01:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E78720040;
	Thu, 31 Oct 2024 15:01:49 +0000 (GMT)
Received: from [9.152.224.204] (unknown [9.152.224.204])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 31 Oct 2024 15:01:48 +0000 (GMT)
Message-ID: <8a9aa0c1-ff20-4d01-8884-590f77a13758@de.ibm.com>
Date: Thu, 31 Oct 2024 16:01:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] s390/kvm: mask extra bits from program interrupt
 code
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: nsg@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        seiden@linux.ibm.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20241031120316.25462-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20241031120316.25462-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NcFY3BJBVtvUSVpHTqWGUqTyIsI_ZUED
X-Proofpoint-GUID: NcFY3BJBVtvUSVpHTqWGUqTyIsI_ZUED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=832 clxscore=1011 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310113



Am 31.10.24 um 13:03 schrieb Claudio Imbrenda:
> The program interrupt code has some extra bits that are sometimes set
> by hardware for various reasons; those bits should be ignored when the
> program interrupt number is needed for interrupt handling.
> 
> Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

seems to fix my issue:
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8b3afda99397..f2d1351f6992 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4737,7 +4737,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>   	if (kvm_s390_cur_gmap_fault_is_write())
>   		flags = FAULT_FLAG_WRITE;
>   
> -	switch (current->thread.gmap_int_code) {
> +	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
>   	case 0:
>   		vcpu->stat.exit_null++;
>   		break;

