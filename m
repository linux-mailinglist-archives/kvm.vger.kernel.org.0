Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354663F1995
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhHSMkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 08:40:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhHSMkb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 08:40:31 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JCX0VN009397;
        Thu, 19 Aug 2021 08:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2ux6dVtsvjGBHearavU8txuwwr9fho19UK9Z9YKT8JU=;
 b=VkPemmlVK+SGgi78rF8eAXQ+FeXr5ONv3qPYT9pxua/ujbSoj/l5aTjodBHpmtX/W0pi
 3KmEibBEba/lJ/8aCZhYpjfvaRqVXQ46zi6yyNXX6UMVrxCWRmXlotLv0vJAh+DxUDKO
 0jnizA/A7lQYMlbTBINIoxggCuei3gUs6MC2uRJxDc5KxMLAwcT9ShayPWNDagd24KJz
 9T9js4XozaTrLWX9c1/ZQCO31fc52pY14lSAndCfhhKxXtCxajVCbRJihCRz3lkGu7gp
 BqMMwS5SJTBWfb5+JJ6ZNiyYGbdOUyURIdI2U4zYohy/CGx1N9x3+mHnk8FXAsjSBhiB aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahp9x2cnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 08:39:55 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JCXMUL013631;
        Thu, 19 Aug 2021 08:39:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahp9x2cmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 08:39:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JCXGUv023725;
        Thu, 19 Aug 2021 12:39:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8g80m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 12:39:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JCdnVb50856330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 12:39:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25A844204C;
        Thu, 19 Aug 2021 12:39:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 998EB42049;
        Thu, 19 Aug 2021 12:39:48 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.33.59])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 12:39:48 +0000 (GMT)
Subject: Re: [PATCH 2/2] KVM: s390: gaccess: Refactor access address range
 check
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-3-scgl@linux.ibm.com>
 <20210818120815.6e048149@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <017e23a8-8a7a-0b25-c5b7-913c0dd894f9@linux.vnet.ibm.com>
Date:   Thu, 19 Aug 2021 14:39:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818120815.6e048149@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8rK7hl31KAY4Ypwc9ixJL8PxNMlkIetd
X-Proofpoint-GUID: oe6VDJj5WkaCh0tHmWA4dnMoqQJyyEVI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108190072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 12:08 PM, Claudio Imbrenda wrote:
> On Mon, 16 Aug 2021 17:07:17 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Do not round down the first address to the page boundary, just translate
>> it normally, which gives the value we care about in the first place.
>> Given this, translating a single address is just the special case of
>> translating a range spanning a single page.
>>
>> Make the output optional, so the function can be used to just check a
>> range.
> 
> I like the idea, but see a few nits below
> 
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  arch/s390/kvm/gaccess.c | 91 ++++++++++++++++++-----------------------
>>  1 file changed, 39 insertions(+), 52 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index df83de0843de..e5a19d8b30e2 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -794,35 +794,45 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>>  	return 1;
>>  }
>>  
>> -static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>> -			    unsigned long *pages, unsigned long nr_pages,
>> -			    const union asce asce, enum gacc_mode mode)
>> +/* Stores the gpas for each page in a real/virtual range into @gpas
>> + * Modifies the 'struct kvm_s390_pgm_info pgm' member of @vcpu in the same
>> + * way read_guest/write_guest do, the meaning of the return value is likewise
> 
> this comment is a bit confusing; why telling us to look what a
> different function is doing?
> 
> either don't mention this at all (since it's more or less the expected
> behaviour), or explain in full what's going on

Yeah, it's not ideal. I haven't decided yet what I'll do.
I think a comment would be helpful, and it may be expected behavior only if one has
looked at the code for long enough :).
> 
>> + * the same.
>> + * If @gpas is NULL only the checks are performed.
>> + */
>> +static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>> +			       unsigned long *gpas, unsigned long len,
>> +			       const union asce asce, enum gacc_mode mode)
>>  {
>>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>> +	unsigned long gpa;
>> +	unsigned int seg;
>> +	unsigned int offset = offset_in_page(ga);
>>  	int lap_enabled, rc = 0;
>>  	enum prot_type prot;
>>  
>>  	lap_enabled = low_address_protection_enabled(vcpu, asce);
>> -	while (nr_pages) {
>> +	while ((seg = min(PAGE_SIZE - offset, len)) != 0) {
> 
> I'm not terribly fond of assignments-as-values; moreover offset is used
> only once.
> 
> why not something like:
> 
> 	seg = min(PAGE_SIZE - offset, len);
> 	while (seg) {
> 
> 		...
> 
> 		seg = min(PAGE_SIZE, len);
> 	}
> 
> or maybe even:
> 
> 	seg = min(PAGE_SIZE - offset, len);
> 	for (; seg; seg = min(PAGE_SIZE, len)) {
> 
> (although the one with the while is perhaps more readable)

That code pattern is not entirely uncommon, but I'll change it to:

	while(min(PAGE_SIZE - offset, len) > 0) {
		seg = min(PAGE_SIZE - offset, len);
		...
	}

which I think reads better than having the assignment at the end.
I assume the compiler gets rid of the redundancy.
> 
[...]

>> @@ -845,10 +855,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>  		 unsigned long len, enum gacc_mode mode)
>>  {
>>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>> -	unsigned long nr_pages, gpa, idx;
>> +	unsigned long nr_pages, idx;
>>  	unsigned int seg;
>> -	unsigned long pages_array[2];
>> -	unsigned long *pages;
>> +	unsigned long gpa_array[2];
>> +	unsigned long *gpas;
> 
> reverse Christmas tree?
> 
> also, since you're touching this: have you checked if a different size
> for the array would bring any benefit?
> 2 seems a little too small, but I have no idea if anything bigger would
> bring any advantages.

I have not checked it, no. When emulating instructions, you would only need >2
entries if an operand is >8k or >4k and weirdly aligned, hardly seems like a common occurrence.
On the other hand, bumping it up should not have any negative consequences.
I'll leave it as is.

[...]

