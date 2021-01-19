Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9542FBA51
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404821AbhASOv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:51:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390240AbhASKUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:20:38 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JAJDmR081544;
        Tue, 19 Jan 2021 05:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8xSdf2UpZx7/hOEnLy6Z2LyPyDig2KOMr7IqsgGVhK0=;
 b=ZC9yBsrIUjzzWLwB2xoQAPEaVuckTtU4R0OiXb4XSMT/uqffyB9CysKKiSpK+McSWhpT
 VRY/J1gGHAC7gF7MjZwVzDXTfjUR1XHN9JcA1fZmlVU8gNnLAqkh+y/q8FMVU+WPwT5Q
 dv2UtrMXl/agJXp3utuNiUG3k2/F3TJ/YKJF/tNZwOJImtYoz4qdd++L8WdgeMZ8chin
 XJ/FyYeE8YFOCFM6RlzRM5ioozQmh8FGvyfiNLBL6GnEu/r+gpusOjV0GMQmqfJzEuNf
 Cvq0Kx7LfFVkTDWqjk1Ipbgdl3svRFligNvpsqRlMsrH2ZsrJ9eOLYjmTYIayPEVjyUb Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365wjqg0mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:19:55 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JAJtI5083419;
        Tue, 19 Jan 2021 05:19:55 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365wjqg0m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:19:55 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JAHuDF013806;
        Tue, 19 Jan 2021 10:19:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 363qs89gsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:19:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JAJoLl50987514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:19:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD1334C040;
        Tue, 19 Jan 2021 10:19:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F5B34C046;
        Tue, 19 Jan 2021 10:19:50 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.184])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:19:50 +0000 (GMT)
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
To:     Janosch Frank <frankja@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-2-frankja@linux.ibm.com>
 <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>
 <945319e9-641b-70ea-0e0b-2e71f73cf086@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b3d99ee1-864c-c96b-34f8-1eb7d464db03@de.ibm.com>
Date:   Tue, 19 Jan 2021 11:19:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <945319e9-641b-70ea-0e0b-2e71f73cf086@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.01.21 11:15, Janosch Frank wrote:
> On 1/19/21 11:11 AM, Christian Borntraeger wrote:
>>
>>
>> On 19.01.21 11:04, Janosch Frank wrote:
>>> The number reported by the query is N-1 and I think people reading the
>>> sysfs file would expect N instead. For users creating VMs there's no
>>> actual difference because KVM's limit is currently below the UV's
>>> limit.
>>>
>>> The naming of the field is a bit misleading. Number in this context is
>>> used like ID and starts at 0. The query field denotes the maximum
>>> number that can be put into the VCPU number field in the "create
>>> secure CPU" UV call.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  arch/s390/boot/uv.c        | 2 +-
>>>  arch/s390/include/asm/uv.h | 4 ++--
>>>  arch/s390/kernel/uv.c      | 2 +-
>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>>> index a15c033f53ca..afb721082989 100644
>>> --- a/arch/s390/boot/uv.c
>>> +++ b/arch/s390/boot/uv.c
>>> @@ -35,7 +35,7 @@ void uv_query_info(void)
>>>  		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
>>>  		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
>>>  		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
>>> -		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
>>> +		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_num;
>>>  	}
>>>  
>>>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>>> index 0325fc0469b7..c484c95ea142 100644
>>> --- a/arch/s390/include/asm/uv.h
>>> +++ b/arch/s390/include/asm/uv.h
>>> @@ -96,7 +96,7 @@ struct uv_cb_qui {
>>>  	u32 max_num_sec_conf;
>>>  	u64 max_guest_stor_addr;
>>>  	u8  reserved88[158 - 136];
>>> -	u16 max_guest_cpus;
>>> +	u16 max_guest_cpu_num;
>>
>> I think it would read better if we name this also max_guest_cpu_id.
>> Otherwise this looks good.
>>
> 
> Yes, but I wanted to have the same name as in the specification.
> So, what do we value more?

I think readability is more important. Maybe add a comment in the structure definition that
explains it?
