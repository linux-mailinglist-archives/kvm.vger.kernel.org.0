Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE38B401E1B
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbhIFQRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 12:17:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234132AbhIFQRX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 12:17:23 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186GEHr2054075;
        Mon, 6 Sep 2021 12:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4LuLvRTwcB5+x/Z+K7GSrWAkFn9onhsaecda0nUz62I=;
 b=Vj9RVpQbnx5MFdrQSFMIXADgRO8n5Ytqv/IPdbIp+2F7BEW8HzEiuYIIBHdHF0xVWCzA
 gnbgAXY6LxR93OZl1TO8XzYhnj/tDD4SpL4H39VuQnHOAidMqEoh7wkQkCmlOiccJ+Tz
 vqL3DT5gIL8rDPVNqnqpTsjCdfc1pRyyxgB2l1hJcq3tieFpHaGPswGqLSy9mKLrf2pb
 DI7vBnm1wmCP/7XuioMb9yUeCrtZMeH6iVn5DzOjGQiPLn9ClZVSnBdjDgTvEF+CMLed
 zji/JnRbG+Nlm3EZln3sRrBhVyv86bDdc+DPy7kkbc7Y7MF8p2dxFNfAntk2iE5+6bMw 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awmc62d7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 12:16:18 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186GGDWd060607;
        Mon, 6 Sep 2021 12:16:18 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awmc62d70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 12:16:18 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186GDPAd011105;
        Mon, 6 Sep 2021 16:16:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3av0e9da97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 16:16:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186GBvJp37683482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 16:11:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70B3E52052;
        Mon,  6 Sep 2021 16:16:11 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.95.210])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0B84F52054;
        Mon,  6 Sep 2021 16:16:11 +0000 (GMT)
Subject: Re: [PATCH v4 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-7-imbrenda@linux.ibm.com>
 <1a44ff5c-f59f-2f37-2585-084294ed5e11@de.ibm.com>
 <20210906175618.4ce0323f@p-imbrenda>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <35e4b7a3-42d8-6b8f-e2e7-5b6a81dfcfa3@de.ibm.com>
Date:   Mon, 6 Sep 2021 18:16:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210906175618.4ce0323f@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3lNbS7yAX7Cph2cK1wos9PWw4Y4TYO9k
X-Proofpoint-GUID: IDYCKt2rdwNe6EwvY7s_cxQU_e-tdyIV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_08:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.09.21 17:56, Claudio Imbrenda wrote:
> On Mon, 6 Sep 2021 17:46:40 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 18.08.21 15:26, Claudio Imbrenda wrote:
>>> Introduce variants of the convert and destroy page functions that also
>>> clear the PG_arch_1 bit used to mark them as secure pages.
>>>
>>> These new functions can only be called on pages for which a reference
>>> is already being held.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>
>> Can you refresh my mind? We do have over-indication of PG_arch_1 and this
>> might result in spending some unneeded cycles but in the end this will be
>> correct. Right?
>> And this patch will fix some unnecessary places that add overindication.
> 
> correct, PG_arch_1 will still overindicate, but with this patch it will
> happen less.
> 
> And PG_arch_1 overindication is perfectly fine from a correctness point
> of view.

Maybe add something like this to the patch description then.

>>> +/*
>>> + * The caller must already hold a reference to the page
>>> + */
>>> +int uv_destroy_owned_page(unsigned long paddr)
>>> +{
>>> +	struct page *page = phys_to_page(paddr);

Do we have to protect against weird mappings without struct page here? I have not
followed the discussion about this topic. Maybe Gerald knows if we can have memory
without struct pages.

>>> +	int rc;
>>> +
>>> +	get_page(page);
>>> +	rc = uv_destroy_page(paddr);
>>> +	if (!rc)
>>> +		clear_bit(PG_arch_1, &page->flags);
>>> +	put_page(page);
>>> +	return rc;
>>> +}
>>> +
>>>    /*
>>>     * Requests the Ultravisor to encrypt a guest page and make it
>>>     * accessible to the host for paging (export).
>>> @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
>>>    	return 0;
>>>    }
>>>    
>>> +/*
>>> + * The caller must already hold a reference to the page
>>> + */
>>> +int uv_convert_owned_from_secure(unsigned long paddr)
>>> +{
>>> +	struct page *page = phys_to_page(paddr);

Same here. If this is not an issue (and you add something to the patch description as
outlined above)

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


