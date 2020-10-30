Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E67D2A07E4
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 15:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgJ3ObK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 10:31:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgJ3ObJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 10:31:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UE2Swq034756;
        Fri, 30 Oct 2020 10:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ohl5SYtmqEqbnAQIUMNmpkUrg6xu5xgKTdULuJLlh8g=;
 b=S7YnYdHIQt0M96DsYxpZLjV6kabTz1hS4Z5a1ei7f6c/rHZ+Ph9C4JnsB0CQo/nrm+f6
 V+/YRVaL9Alz//VktSP4rE0QXb8GmKZ+2Mpa1I1ESkWjwm3A3plDvf8bg0hz3t/h/HKq
 zsTkuc7Et+YTgwTM0gxSydJGO5aG2D2zuHcGSjateZrjEsiBARUHzzpeB+X3qkzGaGMu
 EJMtzBJU6XWKglF2AapaoilC+3sGjErKCawB7ICXpBKjdNlHg8dBHAsPpLpsyaPTWcVd
 yDth075oimsVqBxI95x2AoG7Psrwyw3CpApdbfjLJbppR3Ht0o9o+QaRMAZjOx5EihAh ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gghjg6me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 10:31:09 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UEGZhp106043;
        Fri, 30 Oct 2020 10:31:08 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gghjg6jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 10:31:08 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UELr5k014936;
        Fri, 30 Oct 2020 14:31:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 34f7s3s6kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 14:31:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UEV3Rm23855504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 14:31:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA775204F;
        Fri, 30 Oct 2020 14:31:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.23.31])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8620852050;
        Fri, 30 Oct 2020 14:31:02 +0000 (GMT)
Subject: Re: [PATCH] kvm: s390: pv: Mark mm as protected after the set secure
 parameters and improve cleanup
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20201030140141.106641-1-frankja@linux.ibm.com>
 <7461fd5d-4a44-51ad-bb7b-0bea8737b6e1@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <616a50f1-85f2-3286-7385-ead45256c6b5@linux.ibm.com>
Date:   Fri, 30 Oct 2020 15:31:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <7461fd5d-4a44-51ad-bb7b-0bea8737b6e1@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_04:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/20 3:25 PM, Christian Borntraeger wrote:
> On 30.10.20 15:01, Janosch Frank wrote:
>> We can only have protected guest pages after a successful set secure
>> parameters call as only then the UV allows imports and unpacks.
>>
>> By moving the test we can now also check for it in s390_reset_acc()
>> and do an early return if it is 0.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Looks sane.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks

> 
> As said in my other mail lets give it some days for the CI to test this.

Sure, I'll push it in a minute

> 
>> ---
>>  arch/s390/kvm/kvm-s390.c | 2 +-
>>  arch/s390/kvm/pv.c       | 3 ++-
>>  arch/s390/mm/gmap.c      | 2 ++
>>  3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6b74b92c1a58..08ea6c4735cd 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2312,7 +2312,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>  		struct kvm_s390_pv_unp unp = {};
>>
>>  		r = -EINVAL;
>> -		if (!kvm_s390_pv_is_protected(kvm))
>> +		if (!kvm_s390_pv_is_protected(kvm) || !mm_is_protected(kvm->mm))
>>  			break;
>>
>>  		r = -EFAULT;
>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>> index eb99e2f95ebe..f5847f9dec7c 100644
>> --- a/arch/s390/kvm/pv.c
>> +++ b/arch/s390/kvm/pv.c
>> @@ -208,7 +208,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>>  		return -EIO;
>>  	}
>>  	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
>> -	atomic_set(&kvm->mm->context.is_protected, 1);
>>  	return 0;
>>  }
>>
>> @@ -228,6 +227,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>>  	*rrc = uvcb.header.rrc;
>>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
>>  		     *rc, *rrc);
>> +	if (!cc)
>> +		atomic_set(&kvm->mm->context.is_protected, 1);
>>  	return cc ? -EINVAL : 0;
>>  }
>>
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index cfb0017f33a7..64795d034926 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -2690,6 +2690,8 @@ static const struct mm_walk_ops reset_acc_walk_ops = {
>>  #include <linux/sched/mm.h>
>>  void s390_reset_acc(struct mm_struct *mm)
>>  {
>> +	if (!mm_is_protected(mm))
>> +		return;
>>  	/*
>>  	 * we might be called during
>>  	 * reset:                             we walk the pages and clear
>>

