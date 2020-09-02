Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC425A2F9
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 04:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgIBCVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 22:21:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBCU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 22:20:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822J3Xl150572;
        Wed, 2 Sep 2020 02:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LQD64URzqFn5SbT8xTu4ejNA/9+cygc6WuUNuUga+iM=;
 b=J+rob27nESYkMOEFN8KtQVBcL+F27OVlYcfmWJX1nPO+6mbJnTeE5UD8KKYSPgHNpiHJ
 imbqjsr/DFJY1qIr6yIYL2S+7g897VAHBpuPwtpn3Zg4e/BnkJ4SOXozuyGpLqnKRKg1
 A2C8lbDze8ks1UZEaFD8Dbgue6Ums2hfN9XKRtpHZfVFcUK/tBKFSzjjktrpcTou/Oyu
 o3+nMlg4KRASmiKLTZKu/HkApAfU2go8dGXfPBgfcMpwis4ND7Nw87s9ayKqeulxBCa2
 Ed2+0QEIK1GbFaxmDWNRfJ0TYWNj7AaV6yKDiKrTRz+U5nPs6D78MOLwpI9HBE5/H/6G kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqysx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:20:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822JhU8086392;
        Wed, 2 Sep 2020 02:20:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xxpcs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:20:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0822KnWu022782;
        Wed, 2 Sep 2020 02:20:49 GMT
Received: from localhost.localdomain (/10.159.224.211)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:20:49 -0700
Subject: Re: [PATCH 2/2] KVM: SVM: Don't flush cache of SEV-encrypted pages if
 hardware enforces cache coherency across encryption domains
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200829005926.5477-1-krish.sadhukhan@oracle.com>
 <20200829005926.5477-2-krish.sadhukhan@oracle.com>
 <ecf8a23a-8d7b-ed8d-e528-8298079d2df7@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <9f7b6a8b-aa32-bf1d-82d3-369eb5ae4368@oracle.com>
Date:   Tue, 1 Sep 2020 19:20:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ecf8a23a-8d7b-ed8d-e528-8298079d2df7@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020019
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/31/20 9:14 AM, Tom Lendacky wrote:
> On 8/28/20 7:59 PM, Krish Sadhukhan wrote:
>> Some hardware implementations may enforce cache coherency across 
>> encryption
>> domains. In such cases, it's not required to flush SEV-encrypted 
>> pages off
>> cache lines.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 402dc4234e39..c8ed8a62d5ef 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page 
>> *pages[], unsigned long npages)
>>       uint8_t *page_virtual;
>>       unsigned long i;
>>   -    if (npages == 0 || pages == NULL)
>> +    if ((cpuid_eax(SVM_SME_CPUID_FUNC) & (1u << 10)) || npages == 0 ||
>
> Thanks for the patch. This should really be added as an X86_FEATURE 
> bit, and then check that feature here, as opposed to calling CPUID 
> every time. Also, there are other places in the kernel that this may 
> be relevant, are you investigating those areas, also (e.g. 
> set_memory_encrypted() / set_memory_decrypted())?


Thanks for the suggestions. I will add it as an X86_FEATURE bit.

As for other places, I see that __set_memory_enc_dec() is where we can 
add this condition. Not sure if I have missed anything, but other places 
where we call cpa_flush() and stuff like that, are for regular pages and 
not encrypted one.

I will send out v2 with these changes.


>
> Thanks,
> Tom
>
>> +        pages == NULL)
>>           return;
>>         for (i = 0; i < npages; i++) {
>>
