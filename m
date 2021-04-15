Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE70F360789
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhDOKum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 06:50:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOKuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 06:50:40 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FAWdM8077883;
        Thu, 15 Apr 2021 06:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Gjt4EgW56brUbYftu1iZBaxRGbjz8xj38ozi/chtUyU=;
 b=nfuD81KhkrehwmXK/UT39/NvXbix3ZDSuAKSAzX52rC77nOmyJAtDuHr1kVDukP0HXkI
 BrSsj4AvN/TkDblShT+ztzOpUPnuUonIFbsj5x7qHa5ZIBajRNYRDERQ8f0teX11eqKg
 HTN+agWcZgB4FP3bC6D+CS8fvEA+0hB1tlm2K+VM8Kc0OovdopxioUuh/PQaherUv83n
 WdWwXIamfiQlLFoea61EAaNx4uHzwkGVR5PO8Yvyj8YZMIE83y2k/4vkB9xpSmdBJzHa
 +SEHnXhHetw22k0VsWKfpORgqLSiZWYG4PxdL/kAOIE8VUsCRcmE9w60t2/bDIQYFQWT Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x5apd3tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 06:50:17 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13FAWbvo077852;
        Thu, 15 Apr 2021 06:50:17 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x5apd3s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 06:50:17 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FAnWXr012543;
        Thu, 15 Apr 2021 10:50:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n8a1xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 10:50:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FAoB7O25755928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 10:50:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D83AE045;
        Thu, 15 Apr 2021 10:50:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFB24AE04D;
        Thu, 15 Apr 2021 10:50:10 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.63.231])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 10:50:10 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: fix guarded storage control register handling
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210415080127.1061275-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <26d79734-0397-5ab6-6b7b-2180012ccb95@de.ibm.com>
Date:   Thu, 15 Apr 2021 12:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415080127.1061275-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kfXerBdv1mTJH2e68DMAQwkfwt7e_npV
X-Proofpoint-ORIG-GUID: NivrJRK1jo1FOWoAmXFuUv0eBUWG7T5P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_03:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 suspectscore=0 mlxlogscore=981
 impostorscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.04.21 10:01, Heiko Carstens wrote:
> store_regs_fmt2() has an ordering problem: first the guarded storage
> facility is enabled on the local cpu, then preemption disabled, and
> then the STGSC (store guarded storage controls) instruction is
> executed.
> 
> If the process gets scheduled away between enabling the guarded
> storage facility and before preemption is disabled, this might lead to
> a special operation exception and therefore kernel crash as soon as
> the process is scheduled back and the STGSC instruction is executed.
> 
> Fixes: 4e0b1ab72b8a ("KVM: s390: gs support for kvm guests")
> Cc: <stable@vger.kernel.org> # 4.12
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Thanks applied. Will queue for the s390kvm tree after the CI/regression has finished.
> ---
>   arch/s390/kvm/kvm-s390.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2f09e9d7dc95..24ad447e648c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4307,16 +4307,16 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu)
>   	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>   	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
>   	if (MACHINE_HAS_GS) {
> +		preempt_disable();
>   		__ctl_set_bit(2, 4);
>   		if (vcpu->arch.gs_enabled)
>   			save_gs_cb(current->thread.gs_cb);
> -		preempt_disable();
>   		current->thread.gs_cb = vcpu->arch.host_gscb;
>   		restore_gs_cb(vcpu->arch.host_gscb);
> -		preempt_enable();
>   		if (!vcpu->arch.host_gscb)
>   			__ctl_clear_bit(2, 4);
>   		vcpu->arch.host_gscb = NULL;
> +		preempt_enable();
>   	}
>   	/* SIE will save etoken directly into SDNX and therefore kvm_run */
>   }
> 
