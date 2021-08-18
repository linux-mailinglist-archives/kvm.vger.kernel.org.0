Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE433EFF83
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhHRItp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:49:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhHRIte (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 04:49:34 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I8ZwaG182674;
        Wed, 18 Aug 2021 04:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WZ4P+pwIsGVf1pV3zJwgc85DOLpUVVl8Vn+tXtWVtS4=;
 b=metuliNfZOCsKh0I+nUHzH71gJw3OLoODtdPDfGCpX6jdLMmsVHcpXjlLIYsWKE83xph
 L5FspcI/x0Vo9DzzMuQZAsOwrQBkHGyOVcZ/R4MsoPUfqWuCddBVbcLHUla49QE4I4iU
 572qY70p6+OSCsWaijBfNFcngu9ZPsec07yjypYCm2BsnLVTZRbfnm3KEznR13KYT7G4
 /wWgkpuaHPqVrp7P92b9yXkcnNn4sN9baBVoPKljpLnsjkk4XpOJ+ylJqMtgGGQJ2tNn
 qUZ26ARjlu7W5cpspPMVADl6RD5lHyGJPBMoia7U6mnaQ2TGQ+sSLh6RWHu9SPLGnNoy Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvrxdhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:48:58 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I8bo38188065;
        Wed, 18 Aug 2021 04:48:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvrxdgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:48:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I8lDNI027832;
        Wed, 18 Aug 2021 08:48:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hx8r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 08:48:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I8jPAG52756782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 08:45:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F1F11C052;
        Wed, 18 Aug 2021 08:48:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA28311C064;
        Wed, 18 Aug 2021 08:48:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.50.49])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 08:48:51 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
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
 <0c800ed3-cc60-9c13-c0a7-8ba302365ccb@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <655a04b7-f73c-b2e4-026e-c361c545dd8e@linux.vnet.ibm.com>
Date:   Wed, 18 Aug 2021 10:48:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0c800ed3-cc60-9c13-c0a7-8ba302365ccb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _iJ5KdRmlJJsN_v1haxfp9NrmKQLOng9
X-Proofpoint-GUID: n6wsFdFmwnLIsq7KpvMrXcfBqaQw-BQI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 10:44 AM, David Hildenbrand wrote:
> On 18.08.21 10:06, Janosch Frank wrote:
>> On 8/18/21 9:54 AM, David Hildenbrand wrote:
>>> On 16.08.21 17:07, Janis Schoetterl-Glausch wrote:
>>>> Introduce a helper function for guest frame access.
>>>> Rewrite the calculation of the gpa and the length of the segment
>>>> to be more readable.
>>>>
>>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> [...]
>>>> -    unsigned long _len, gpa;
>>>> +    unsigned long gpa;
>>>> +    unsigned int seg;
>>>>        int rc = 0;
>>>>           while (len && !rc) {
>>>>            gpa = kvm_s390_real_to_abs(vcpu, gra);
>>>> -        _len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>>>> -        if (mode)
>>>> -            rc = write_guest_abs(vcpu, gpa, data, _len);
>>>> -        else
>>>> -            rc = read_guest_abs(vcpu, gpa, data, _len);
>>>> -        len -= _len;
>>>> -        gra += _len;
>>>> -        data += _len;
>>>> +        seg = min(PAGE_SIZE - offset_in_page(gpa), len);
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
> Similar code I encountered in other places uses "len" vs "cur_len" or "total_len" vs. "cur_len". I agree that everything is better than "len" vs. "_len".
> 
> I just cannot come up with a proper word for "seg" that would make sense. "Segment" ? Maybe my uneducated mind is missing some important English words that just fit perfectly here.

Yes, it's short for segment, kvm_main has a function next_segment to calculate it.
I don't like the naming scheme much either.
> 
> Anyhow, just my 2 cents, you maintain this code :)
> 

