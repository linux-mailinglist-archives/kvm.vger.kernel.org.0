Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08353A3169
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFJQye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:54:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhFJQye (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:54:34 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AGmsHr147320;
        Thu, 10 Jun 2021 12:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4bl6TEgvBMn2nlMyfo2M71N96hZvWMMJC6TvwrGU2ZQ=;
 b=WjajmjDgdqTx01Zdv+AH1yklB6pAD3D0U9fEcs+UJ30LByNKLsWxr1uPBP3a5iRpWpND
 wA5ffc4pYNrbAGFh9q+59+6/uNRDAAdyfk1VP6ULh5Br07khlzxCAJAm6glBWKKhUiHb
 vEcgEkd3JFHfsbXG0eBe9qZJaD37/fymfnr/Vie8oP7lTc6S2RcAsN1Aww3tVt2MU2mP
 7lfnssbpkQltckjJCNsK+rLjgQOVaqJQJPtdDszjy19Wq90CeYBjQnxXJf0LoUjDSxZY
 huFzgT9a59xadtSLr3YPoCzTAB9XQj0ZzpLN4GoLASCNP2f9lLbJP3u1m3DOiFWtp8kr nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393pkd01m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 12:52:25 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AGpvJx157194;
        Thu, 10 Jun 2021 12:52:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393pkd01k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 12:52:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AGm4k5008811;
        Thu, 10 Jun 2021 16:52:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhty4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 16:52:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AGqJon16646460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 16:52:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B0C652052;
        Thu, 10 Jun 2021 16:52:19 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.90])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6436852054;
        Thu, 10 Jun 2021 16:52:18 +0000 (GMT)
Subject: Re: [PATCH v3 2/2] KVM: s390: fix for hugepage vmalloc
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
 <20210610154220.529122-3-imbrenda@linux.ibm.com>
 <368cfb74-fdc2-00a7-d452-696e375c2ff7@de.ibm.com>
 <20210610184953.19bed6b4@ibm-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <7001a6a9-d415-e826-9bf0-17032568e7b3@de.ibm.com>
Date:   Thu, 10 Jun 2021 18:52:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210610184953.19bed6b4@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ik8gMA4YqgbXZWjYsswXqPubT5cdR38g
X-Proofpoint-ORIG-GUID: FLkjyK-DIdfQS0okD3KmNowzW0wvHa0y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_11:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=787 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.06.21 18:49, Claudio Imbrenda wrote:
> On Thu, 10 Jun 2021 17:56:58 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 10.06.21 17:42, Claudio Imbrenda wrote:
>>> The Create Secure Configuration Ultravisor Call does not support
>>> using large pages for the virtual memory area. This is a hardware
>>> limitation.
>>>
>>> This patch replaces the vzalloc call with an almost equivalent call
>>> to the newly introduced vmalloc_no_huge function, which guarantees
>>> that only small pages will be used for the backing.
>>>
>>> The new call will not clear the allocated memory, but that has never
>>> been an actual requirement.
> 
> ^ here
> 
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Nicholas Piggin <npiggin@gmail.com>
>>> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: David Rientjes <rientjes@google.com>
>>> Cc: Christoph Hellwig <hch@infradead.org>
>>> ---
>>>    arch/s390/kvm/pv.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>>> index 813b6e93dc83..ad7c6d7cc90b 100644
>>> --- a/arch/s390/kvm/pv.c
>>> +++ b/arch/s390/kvm/pv.c
>>> @@ -140,7 +140,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>>>    	/* Allocate variable storage */
>>>    	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE),
>>> PAGE_SIZE); vlen += uv_info.guest_virt_base_stor_len;
>>> -	kvm->arch.pv.stor_var = vzalloc(vlen);
>>> +	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);
>>
>> dont we need a memset now?
> 
> no, as explained above

Makes sense.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
