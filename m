Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4748D5BD
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 11:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiAMKaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 05:30:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230445AbiAMKaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 05:30:20 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D8RdAP016551;
        Thu, 13 Jan 2022 10:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GrMzlfN7No+KZtUsd8R7qpTJJc/Z3501crjbfKFLyI8=;
 b=lbRV1Bf8pzi27e6OIpaxW+x1oCUOg1ER/jwQpxdrBRDtIZZoknOn66xpOkt10XRU4Lrl
 JbJVEAjT8moCtDuU2P5DYRbd95PArwwy4UX7Pt9fYDO4hixy+7pEh6pepTN3NgWtrSgC
 rS7bZIGktHqQlHo6gEyPXqOLwZZJmiqq3K1poJ0nUY7s+jcyVCzmGjmSpOopS6ijtGnf
 jgimwx6Vfv9E1NkroAqgrVq7zW+gzYLpvwsuUOHhfX9b+6QBopfocc796VsSRCD4Q/VI
 fF+eYvWh+L90lLbEEEUP+mmaEoKM0eYLjngi65a3cQRPRbo7HRMeQtDrzNRMTrkNeIqy 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbt8f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:30:19 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DALgdn004760;
        Thu, 13 Jan 2022 10:30:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbt8er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:30:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DAETqY020622;
        Thu, 13 Jan 2022 10:30:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3df289kbsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 10:30:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DAUEf943843884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 10:30:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00CF34C046;
        Thu, 13 Jan 2022 10:30:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 974514C040;
        Thu, 13 Jan 2022 10:30:13 +0000 (GMT)
Received: from [9.145.16.55] (unknown [9.145.16.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 10:30:13 +0000 (GMT)
Message-ID: <af066c18-6e75-d260-274f-87ae1b29f9d2@linux.ibm.com>
Date:   Thu, 13 Jan 2022 11:30:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v6 09/17] KVM: s390: pv: clear the state without memset
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
 <20211203165814.73016-10-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211203165814.73016-10-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ax3nXSd5HaFav570lCxlchnjWKcAjvUW
X-Proofpoint-ORIG-GUID: zKUEwU9X0qSUe5QZwz7YrO2lGIOWlSqC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_02,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201130059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 17:58, Claudio Imbrenda wrote:
> Do not use memset to clean the whole struct kvm_s390_pv; instead,
> explicitly clear the fields that need to be cleared.
> 
> Upcoming patches will introduce new fields in the struct kvm_s390_pv
> that will not need to be cleared.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/pv.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 04aa4a20260b..59da54bd6b21 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,6 +16,15 @@
>   #include <linux/sched/mm.h>
>   #include "kvm-s390.h"
>   
> +static void kvm_s390_clear_pv_state(struct kvm *kvm)
> +{
> +	kvm->arch.pv.handle = 0;
> +	kvm->arch.pv.guest_len = 0;
> +	kvm->arch.pv.stor_base = 0;
> +	kvm->arch.pv.stor_var = NULL;
> +	kvm->arch.pv.handle = 0;

We could use the same approach that we use in qemu to do the cpu resets.
But maybe that would be overkill for a few struct members.

> +}
> +
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>   {
>   	int cc;
> @@ -110,7 +119,7 @@ static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
>   	vfree(kvm->arch.pv.stor_var);
>   	free_pages(kvm->arch.pv.stor_base,
>   		   get_order(uv_info.guest_base_stor_len));
> -	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
> +	kvm_s390_clear_pv_state(kvm);
>   }
>   
>   static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> 

