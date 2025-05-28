Return-Path: <kvm+bounces-47877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E11CAC6881
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 13:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19AC3188436F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31202283C90;
	Wed, 28 May 2025 11:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sN5EW3IL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C93F6A33B;
	Wed, 28 May 2025 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748432501; cv=none; b=REoaOSSfeNzzCdmE/KY7auXMCPd5xN5R8ZqAN8epIJzklqRJx3N3Iu5Z3AUyvdCarUNwzdje7IJukMhTEx7DL+RNBRBPFseHs6jG+V1JgC1aC/8/9KF12eJ6oWldMzXsXlddcnfsCLkVjrnIxLTMKAU2FV7dPrGqr8HUAZSIdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748432501; c=relaxed/simple;
	bh=jfVipnFX8c+CXKIXIAfOUvdKSEC5JiBHwcVxFEtgUxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ov6gPi0veK1J2VvlDkKVgPIP4KZ30bwV6oR6Bet0utYdGFHXfav6gRt4+Wzl9iH63eCoOliQsjyDTJ8xNU702TcRfGcjjS5Is6KMRKwdKDKBxEzvcBumkwDXWRBR4jtULko0TRCswjLVxl5cojOeeNorItfhcjtAPpDh0GE9+C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sN5EW3IL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8f3iG003702;
	Wed, 28 May 2025 11:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ToOHKu
	yEJOxIMByz7C7sQFI0iWmp+FFoh1aU9Y1+yRk=; b=sN5EW3ILA6g0oukm92IWuE
	Zd3MbV/q5HF7YLjgoMXdEoJRY5stRvLelrURjmLhkr/e55YmAmPGzPd8jSDQ0OYP
	3Rf9XkE8Umv3T2EKT5DEHClSbgp5QciuDby3/vR4chtadETKtELOInYSN9Vi00bO
	SXjEWy3JgddJ2rmDoRWPz+clIp0YzwjLuZOzACwZBj0JXz+bHYZK39EGLoXsinHt
	cum0oood6dNgUVs2caI6fxjzgPZdmyM9L07SoQrRCs9P6fZFbzX4ImBCjYxH7af+
	DejoW39yM/m+r0QjArvYFwDDx/FwYM1CjTEyDOXtWjPB9DaJxoHSlklUHXkRHr4g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy690std-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 11:41:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SB6G6A021310;
	Wed, 28 May 2025 11:41:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46utnmq30q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 11:41:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SBfWtW48038172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 11:41:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81B2720043;
	Wed, 28 May 2025 11:41:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF43720040;
	Wed, 28 May 2025 11:41:31 +0000 (GMT)
Received: from [9.87.152.254] (unknown [9.87.152.254])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 11:41:31 +0000 (GMT)
Message-ID: <3ad77cfa-ab86-4bd0-92f8-04ef484dc3ac@linux.ibm.com>
Date: Wed, 28 May 2025 13:41:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] KVM: s390: Refactor and split some gmap helpers
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
References: <20250528095502.226213-1-imbrenda@linux.ibm.com>
 <20250528095502.226213-4-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250528095502.226213-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836f671 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=fDxGR4FE8qlWS1JHXvMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: -rS7SLqujL_3Nxu3YGodEo-SUuLEUo8K
X-Proofpoint-ORIG-GUID: -rS7SLqujL_3Nxu3YGodEo-SUuLEUo8K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEwMSBTYWx0ZWRfXw2SxJPiHt+jd k9F3caGAVkPww9eE0BOAacdRCBqGRnKifLi9iVHi3158L5rQPlFz0H4pIPzsDzOK0a50H4wPWLp SsqGGyoaapwbOAnUo71CplkHhARk7zEgFJJfOOpd5XMwrz4XhZoRj79Th21Op4sE6aPhSa2uojm
 c1Q5AExF9VlKtuHDAfnpNk1ZEVf6s7bLDZMpEnx05Hn7MObRHE6iuQIoTyr9mOXMxIdJyswWtXp 08sfu1RWN1IU3tUd+1YsNpmc42z8sAyLCP4G02yWghu95bEagKKyHJAGmJMhz4e1MXyM+zAV9iL taDHAynw1+QcuZ0agHVAqRS3ldViZMhwDcsSIrIyw0HW8t+JaflhQbjLWNfq2UzK2kNB/xsKJ3T
 er3Ef97HkBTczNQsYZ+qx0IoD7nbohEDkyWsBDVHsITYSkh453LOH3Cb9zHYzTgwBBtW3+a0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280101

On 5/28/25 11:55 AM, Claudio Imbrenda wrote:
> Refactor some gmap functions; move the implementation into a separate
> file with only helper functions. The new helper functions work on vm
> addresses, leaving all gmap logic in the gmap functions, which mostly
> become just wrappers.
> 
> The whole gmap handling is going to be moved inside KVM soon, but the
> helper functions need to touch core mm functions, and thus need to
> stay in the core of kernel.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---

Acked-by: Janosch Frank <frankja@linux.ibm.com>

>   MAINTAINERS                          |   2 +
>   arch/s390/include/asm/gmap.h         |   2 -
>   arch/s390/include/asm/gmap_helpers.h |  15 ++
>   arch/s390/kvm/diag.c                 |  30 +++-
>   arch/s390/kvm/kvm-s390.c             |   5 +-
>   arch/s390/mm/Makefile                |   2 +
>   arch/s390/mm/gmap.c                  | 184 +---------------------
>   arch/s390/mm/gmap_helpers.c          | 221 +++++++++++++++++++++++++++
>   8 files changed, 274 insertions(+), 187 deletions(-)
>   create mode 100644 arch/s390/include/asm/gmap_helpers.h
>   create mode 100644 arch/s390/mm/gmap_helpers.c
> 

[...]

> +#endif /* _ASM_S390_GMAP_HELPERS_H */
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 74f73141f9b9..53233dec8cad 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -11,12 +11,30 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   #include <asm/gmap.h>
> +#include <asm/gmap_helpers.h>
>   #include <asm/virtio-ccw.h>
>   #include "kvm-s390.h"
>   #include "trace.h"
>   #include "trace-s390.h"
>   #include "gaccess.h"
>   
> +static void do_discard_gfn_range(struct kvm_vcpu *vcpu, gfn_t gfn_start, gfn_t gfn_end)
> +{

A helper function for your helper function :)


