Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94F93A2FF0
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhFJP7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:59:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231428AbhFJP7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:59:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AFXH7f140888;
        Thu, 10 Jun 2021 11:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uKX2/jAAP65Vd02Aya8sWx7xYJRNb7mhgs7DZ2kbOXI=;
 b=THQUBT/uv60bIDCpoyp59v1VRFAfLFsNC3kXGIq9mOzljXf7c+Y7OShLL2fqspkCuYKg
 E8AINTOyyTtc5Krb1/ElVw72+4VN73MSwZJFW21j/g5bSH0HgKu0u6TkmEgxwNU0KyPD
 /+KDeeLQhlpHB5zAKJ87SFJtSWmo2SGcLvsUVXdiNxJ3YPyDQIMyYEkpksHs6pBMPRPp
 HJRHSBDvNM+lroGtfJV4NmARHqPZJtLZEXJ6sOvzNUO79XKbykjFnf51qaG0oopF1Sm7
 P5d/yzDtWyIpnSx5fhFleytyw+tEn9K/EZLmrp79inWHVa+gBUj4lTfC/2+bLfQQ6dDb EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393msna7k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:57:05 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AFYMgG145946;
        Thu, 10 Jun 2021 11:57:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393msna7j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:57:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AFqkRK027791;
        Thu, 10 Jun 2021 15:57:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhtx9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 15:57:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AFuxs023068930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 15:56:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 128824C059;
        Thu, 10 Jun 2021 15:56:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55F784C052;
        Thu, 10 Jun 2021 15:56:58 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.90])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 15:56:58 +0000 (GMT)
Subject: Re: [PATCH v3 2/2] KVM: s390: fix for hugepage vmalloc
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
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
 <20210610154220.529122-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <368cfb74-fdc2-00a7-d452-696e375c2ff7@de.ibm.com>
Date:   Thu, 10 Jun 2021 17:56:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210610154220.529122-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8lHUiS35QZWtxxrtV5VKu5c3t-_L5vee
X-Proofpoint-ORIG-GUID: BPOuKf0_1wDEX0XI3ZafasLem8gC-plt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_10:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 impostorscore=0 mlxlogscore=876 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.06.21 17:42, Claudio Imbrenda wrote:
> The Create Secure Configuration Ultravisor Call does not support using
> large pages for the virtual memory area. This is a hardware limitation.
> 
> This patch replaces the vzalloc call with an almost equivalent call to
> the newly introduced vmalloc_no_huge function, which guarantees that
> only small pages will be used for the backing.
> 
> The new call will not clear the allocated memory, but that has never
> been an actual requirement.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>   arch/s390/kvm/pv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 813b6e93dc83..ad7c6d7cc90b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -140,7 +140,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   	/* Allocate variable storage */
>   	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>   	vlen += uv_info.guest_virt_base_stor_len;
> -	kvm->arch.pv.stor_var = vzalloc(vlen);
> +	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);

dont we need a memset now?

>   	if (!kvm->arch.pv.stor_var)
>   		goto out_err;
>   	return 0;
> 
