Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186893F1B5C
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhHSOMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 10:12:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240264AbhHSOMe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 10:12:34 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JE3eeq012849;
        Thu, 19 Aug 2021 10:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UMnRDRYOJDpDifj1IXkiSVngbPMsSJRp2DIFs9Zi6ak=;
 b=ZTihp2JD7yPZVzjeccaXpjt/tawvxt6janDGJxxoOBcEsLvVZbAWLShx4z/L9Xh2SgIX
 0gKINjpVFw/og8yx12OFV1J963paqbKlGMaPrHf+Dn69+JDojL70H49VS3Q67YL6thzp
 uCiPc4O2g6zzeeWuwdBUC8xWaGfeknuZBCrG9BIGKeu4od3h0PGbLPlZcjg2ppqahTy8
 tHjFacG6dzay0282yXOKCyvw2hIwwHGGgQ6oKfEetxAds+VgREZg/mGsmvZZ+alFqTtn
 B1N2r9UYQ395c9Xjo47IdQvXAejXMtpA9ebWQEHf9fFbRmwM7uQpjxDJlmJMnI1/yBL/ 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahqjc2qtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:11:57 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JE3k6N013286;
        Thu, 19 Aug 2021 10:11:57 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahqjc2qt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:11:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JE8sTT008623;
        Thu, 19 Aug 2021 14:11:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8f7yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 14:11:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JEBpbZ56689046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 14:11:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B7004C058;
        Thu, 19 Aug 2021 14:11:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6FC54C046;
        Thu, 19 Aug 2021 14:11:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.148.15])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 14:11:50 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-2-scgl@linux.ibm.com>
 <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
 <584ca757-4eb4-491e-a4cd-7bc60fb04b61@linux.ibm.com>
 <745fb5fc-175b-5920-5c56-db4ca8bc2488@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <f98925f4-70f4-156b-0204-a50b2457de34@linux.ibm.com>
Date:   Thu, 19 Aug 2021 16:11:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <745fb5fc-175b-5920-5c56-db4ca8bc2488@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cu3Do8jpXOG6wIJf4g8l8q_ek_gIi0NU
X-Proofpoint-ORIG-GUID: 4gFBLpVlF_CT03WCJlJzvtaL2zbkFAi9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108190083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/21 3:53 PM, Janis Schoetterl-Glausch wrote:
> On 8/18/21 10:06 AM, Janosch Frank wrote:
>> On 8/18/21 9:54 AM, David Hildenbrand wrote:
>>> On 16.08.21 17:07, Janis Schoetterl-Glausch wrote:
>>>> Introduce a helper function for guest frame access.
>>>> Rewrite the calculation of the gpa and the length of the segment
>>>> to be more readable.
>>>>
>>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> [...]
>>>> -	unsigned long _len, gpa;
>>>> +	unsigned long gpa;
>>>> +	unsigned int seg;
>>>>   	int rc = 0;
>>>>   
>>>>   	while (len && !rc) {
>>>>   		gpa = kvm_s390_real_to_abs(vcpu, gra);
>>>> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>>>> -		if (mode)
>>>> -			rc = write_guest_abs(vcpu, gpa, data, _len);
>>>> -		else
>>>> -			rc = read_guest_abs(vcpu, gpa, data, _len);
>>>> -		len -= _len;
>>>> -		gra += _len;
>>>> -		data += _len;
>>>> +		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
>>>
>>> What does "seg" mean? I certainly know when "len" means -- which is also 
>>> what the function eats.
>>
>> What does "_len" mean especially in contrast to "len"?
>>
>> "seg" is used in the common kvm guest access functions so it's at least
>> consistent although I share the sentiment that it's not a great name for
>> the length we access inside the page.
>>
>> Originally I suggested "len_in_page" if you have a better name I'd
>> expect we'll both be happy to discuss it :-)
> 
> fragment_len ? 

Sounds good to me

>>
>>>
>>>> +		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
>>>> +		len -= seg;
>>>> +		gra += seg;
>>>> +		data += seg;
>>>>   	}
>>>>   	return rc;
>>>>   }
>>>>
>>>
>>>
>>
> 

