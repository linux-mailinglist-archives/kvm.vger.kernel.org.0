Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB13360483
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 10:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhDOIjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 04:39:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40788 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231491AbhDOIjj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 04:39:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13F8XK8w139676;
        Thu, 15 Apr 2021 04:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cWqWhXpeE891XaaOIAv789/uVt+fRH/StL31geR92tc=;
 b=CTy4/O+9WDOw7V9JBxgwt8gGbmkX2xKDluqwU1cu0F1htJLz4nv0sz+aBVIIZuRUtF6e
 mpr3PtO3rwGCs4edOhfHt3BlcEXwwVMbOkpOJ2TZRXQlbmCyqYEeJUl9/b4VKXLcwRSm
 +p9sMMB1VA1VuuuIeDYEKpCp6cx+biQgJcRtENWqcNOESDn3Keu0jAluVjv414E6MRdz
 +c0/srbrVR6Lv3nmPwLD9d7JXKiX9MCD/8y2FnT4Las4pUF/5bKQOv+o6dU/ip4lYNrL
 tRAhKpyJETKcBzQK2An1A/fTIUmxt4IjccdW0Eb/qNH1q1QeX81QhCjD43ereiBx8+Qp 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x88hw5uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 04:39:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13F8XN2t139844;
        Thu, 15 Apr 2021 04:39:15 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x88hw5u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 04:39:15 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13F8RQRb025239;
        Thu, 15 Apr 2021 08:39:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37u39hkrth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 08:39:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13F8dAiR41681394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 08:39:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A57C52051;
        Thu, 15 Apr 2021 08:39:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.191.146])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A6E225204E;
        Thu, 15 Apr 2021 08:39:09 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: fix guarded storage control register handling
To:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210415080127.1061275-1-hca@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <cecfb01e-1a5a-1acf-e8e3-8b488db85f45@linux.ibm.com>
Date:   Thu, 15 Apr 2021 10:39:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210415080127.1061275-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TilkHSTteZYyTNVvBnwW8ixx_NXrqAlO
X-Proofpoint-ORIG-GUID: xQJqfG5ex9RIEtf2TJEJxNxiaNRW84GR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_03:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=888 clxscore=1015
 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/15/21 10:01 AM, Heiko Carstens wrote:
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

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2f09e9d7dc95..24ad447e648c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4307,16 +4307,16 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu)
>  	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>  	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
>  	if (MACHINE_HAS_GS) {
> +		preempt_disable();
>  		__ctl_set_bit(2, 4);
>  		if (vcpu->arch.gs_enabled)
>  			save_gs_cb(current->thread.gs_cb);
> -		preempt_disable();
>  		current->thread.gs_cb = vcpu->arch.host_gscb;
>  		restore_gs_cb(vcpu->arch.host_gscb);
> -		preempt_enable();
>  		if (!vcpu->arch.host_gscb)
>  			__ctl_clear_bit(2, 4);
>  		vcpu->arch.host_gscb = NULL;
> +		preempt_enable();
>  	}
>  	/* SIE will save etoken directly into SDNX and therefore kvm_run */
>  }
> 

