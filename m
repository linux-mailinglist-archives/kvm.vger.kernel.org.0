Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2593C3A01DE
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 21:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhFHS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 14:57:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236688AbhFHSzB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 14:55:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158IYZ7O170745;
        Tue, 8 Jun 2021 14:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ja/oWp63gVjtoAxtl10waklaf29/OvvCU3PvYc+GAGg=;
 b=QjJtO2taJDAEDxKshngV7vNhFnIGyRU8WawoekYYfh2ve1CC9qOav+NRI5CYrJtmRNBe
 07JctMIGMFlU95NzSr9GbYW6C600DCG4pxdUOG1CCtNU3FnRNtd8Tmc7d45fEAKR7o6+
 jfBJ9jm2gFE5lA7kBg73ptlbDx9lSgdgOe8FZ/N6MQaiauHfMP/Pa6dt0H2GNATe9WPh
 mTAunY6Du17A6k9EQJmAm7parIQvpSAR3MTk9Ga+/FeiDDwxiAHVaTLen8zBmHdGRAEm
 UI/7ISFD966X1kz4Hngi8kPQqCUpsxA8XEWLExvbK8ahPm/IqjOJ7FwVbH5gYzcmnr8N 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392ctk2g03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:53:00 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158IYlsN171447;
        Tue, 8 Jun 2021 14:53:00 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392ctk2fyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 14:52:59 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158IqrC3002480;
        Tue, 8 Jun 2021 18:52:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 392e798003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 18:52:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158Iq7Rm30933264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 18:52:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BBF1A4040;
        Tue,  8 Jun 2021 18:52:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80D21A4051;
        Tue,  8 Jun 2021 18:52:53 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.36.114])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 18:52:53 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] KVM: s390: fix for hugepage vmalloc
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
 <20210608180618.477766-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <58ff375c-bad4-e808-fa2f-fd21222ffc74@de.ibm.com>
Date:   Tue, 8 Jun 2021 20:52:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210608180618.477766-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M21To_wYAthKWxSUEu_dmq6eoR_qiQXV
X-Proofpoint-GUID: QjMqZ56-sMhIVPeYrRmVxcRt6QpD54dq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_14:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 mlxlogscore=953
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 08.06.21 20:06, Claudio Imbrenda wrote:
> The Create Secure Configuration Ultravisor Call does not support using
> large pages for the virtual memory area. This is a hardware limitation.
> 
> This patch replaces the vzalloc call with a longer but equivalent
> __vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
> guarantee that this allocation will not be performed with large pages.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Would be good to have this in 5.13, as for everything else we want to have
hugepages in vmalloc space on s390.

In case Andrew picks this up
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
for the KVM/390 part.

> ---
>   arch/s390/kvm/pv.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 813b6e93dc83..6087fe7ae77c 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   	/* Allocate variable storage */
>   	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>   	vlen += uv_info.guest_virt_base_stor_len;
> -	kvm->arch.pv.stor_var = vzalloc(vlen);
> +	kvm->arch.pv.stor_var = __vmalloc_node_range(vlen, PAGE_SIZE, VMALLOC_START, VMALLOC_END,
> +						     GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
> +						     VM_NO_HUGE_VMAP, NUMA_NO_NODE,
> +						     __builtin_return_address(0));
>   	if (!kvm->arch.pv.stor_var)
>   		goto out_err;
>   	return 0;
> 
