Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926F43EFFC9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhHRJAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:00:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230344AbhHRJAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:00:49 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I8Zf1n077928;
        Wed, 18 Aug 2021 05:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=koZyDJ5M5B8mJGjjUNX6ImXe8elhxJEcIzpkDgjwuBI=;
 b=sF4VTXbbEVuJCun4EYhS6vp/thcQg4eogzm0qc0BEDoGHKrEFXG5IS64lPU0nE0JC8xl
 2ep35x6j8p5Pm8WqmREeIQhq9FM/kf4NHqmoaJXEMomnkj+OoHeefcGP5/8tMKcx9F6v
 IbOac10qaDOEcSCUo63icVRxIKHIheVH+NJYgaANfwqzJFZHjR4fVlaEuJDZ1LIwN4el
 3kiC7b9ijW3EQdofbJ+PAX0m6uy3nT+w6NxwABq8wjodcA+UTIHEX0K3uqN9/pgnd2hK
 Zo3f9Iops05iRBuh7dVmsdjL3K26m3hlGM0l0zIB3jUMoMFwJ45v8PmddqqnPQQcctUm Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf67fbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:00:14 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I8ccXo085286;
        Wed, 18 Aug 2021 05:00:14 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf67fa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:00:14 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I8wQIp027686;
        Wed, 18 Aug 2021 09:00:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3ae53hded1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:00:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I907Rk50463196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 09:00:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D5E411C058;
        Wed, 18 Aug 2021 09:00:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9021E11C073;
        Wed, 18 Aug 2021 09:00:06 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.50.49])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 09:00:06 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-2-scgl@linux.ibm.com>
 <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <3326a23b-be19-4461-6268-809d4ed194e8@linux.vnet.ibm.com>
Date:   Wed, 18 Aug 2021 11:00:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wmzpbC0jIajJkIWG-rhofcUhKMMC6FRQ
X-Proofpoint-GUID: nLpErGr8BYpo90rsZOXxLoVSZthVwYJw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 9:54 AM, David Hildenbrand wrote:
> On 16.08.21 17:07, Janis Schoetterl-Glausch wrote:
>> Introduce a helper function for guest frame access.
>> Rewrite the calculation of the gpa and the length of the segment
>> to be more readable.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   arch/s390/kvm/gaccess.c | 48 +++++++++++++++++++++++++----------------
>>   1 file changed, 29 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index b9f85b2dc053..df83de0843de 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -827,11 +827,26 @@ static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>>       return 0;
>>   }
>>   +static int access_guest_frame(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>> +                  void *data, unsigned int len)
> 
> I know, "frame" is a beautiful term for "page" -- can we just avoid using it because we're not using it anywhere else here? :)
> 
> What's wrong with "access_guest_page()" ?

Ok, I'll use page for consistency's sake.
> 
> 
>> +{
>> +    gfn_t gfn = gpa_to_gfn(gpa);
>> +    unsigned int offset = offset_in_page(gpa);
>> +    int rc;
> 
> You could turn both const. You might want to consider reverse-christmas-treeing this.

Ok
> 
>> +
>> +    if (mode == GACC_STORE)
>> +        rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
>> +    else
>> +        rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
> 
> Personally, I prefer passing in pfn + offset instead of a gpa. Also avoids having to convert back and forth.

In access_guest_real we get back the gpa directly from the translation function.
After the next patch the same is true for access_guest.
So using gpas everywhere is nicer.
And if we were to introduce a len_in_page function the offset would not even show up as an intermediary.
> 
>> +    return rc;
>> +}
>> +
>>   int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>            unsigned long len, enum gacc_mode mode)
>>   {
>>       psw_t *psw = &vcpu->arch.sie_block->gpsw;
>> -    unsigned long _len, nr_pages, gpa, idx;
>> +    unsigned long nr_pages, gpa, idx;
>> +    unsigned int seg;
> 
> Dito, reverse christmas tree might be worth keeping.
> 
>>       unsigned long pages_array[2];
>>       unsigned long *pages;
>>       int need_ipte_lock;
>> @@ -855,15 +870,12 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>           ipte_lock(vcpu);
>>       rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
>>       for (idx = 0; idx < nr_pages && !rc; idx++) {
>> -        gpa = *(pages + idx) + (ga & ~PAGE_MASK);
>> -        _len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>> -        if (mode == GACC_STORE)
>> -            rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
>> -        else
>> -            rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
>> -        len -= _len;
>> -        ga += _len;
>> -        data += _len;
>> +        gpa = pages[idx] + offset_in_page(ga);
>> +        seg = min(PAGE_SIZE - offset_in_page(gpa), len);
>> +        rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
>> +        len -= seg;
>> +        ga += seg;
>> +        data += seg;
>>       }
>>       if (need_ipte_lock)
>>           ipte_unlock(vcpu);
>> @@ -875,19 +887,17 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>   int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>>                 void *data, unsigned long len, enum gacc_mode mode)
>>   {
>> -    unsigned long _len, gpa;
>> +    unsigned long gpa;
>> +    unsigned int seg;
>>       int rc = 0;
>>         while (len && !rc) {
>>           gpa = kvm_s390_real_to_abs(vcpu, gra);
>> -        _len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>> -        if (mode)
>> -            rc = write_guest_abs(vcpu, gpa, data, _len);
>> -        else
>> -            rc = read_guest_abs(vcpu, gpa, data, _len);
>> -        len -= _len;
>> -        gra += _len;
>> -        data += _len;
>> +        seg = min(PAGE_SIZE - offset_in_page(gpa), len);
> 
> What does "seg" mean? I certainly know when "len" means -- which is also what the function eats.
> 
>> +        rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
>> +        len -= seg;
>> +        gra += seg;
>> +        data += seg;
>>       }
>>       return rc;
>>   }
>>
> 
> 

