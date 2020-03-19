Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C5918BFBA
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 19:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCSS4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 14:56:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgCSS4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 14:56:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02JIirN3049186;
        Thu, 19 Mar 2020 18:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=h0BPCn5kWMDTJdRZqmOIj5/kwc8bwemVB3+LYAVkPM4=;
 b=DYwwCnRBdTMqakFcoYaj61hm5PRyHqoO7wAc9Gu0a3zEA0qvbTzm7ZGr0Tz+sr87Z3AH
 gNc7U7UNoL73l/SyRvT6IOpKNRElmJHVvwvgbwhvn+W6Q6/uUVUftZhnfE4uPAy0GFFQ
 4eDhy2s296ZszJ6nGR+9z614as+EN5u92dvyMcllcT0HuYlhw3IPuHMOZkQaBo/3gzJw
 +mqCGTnOtumcLa+7b514mLc1jZgpiwgZgaJK7k3kTb68JIlAzXLgXF9eTtM5axf4Sj17
 KqHUCK4pdAjE9tzJrVBSFOtZ8HIL8aTuBoCYDV4W/HFLeaYv5YSpdm1DYT5bNumfZa0n 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yub279yq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 18:56:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02JInoxl139237;
        Thu, 19 Mar 2020 18:56:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92mxsca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 18:56:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02JIuCfi014085;
        Thu, 19 Mar 2020 18:56:12 GMT
Received: from localhost.localdomain (/10.65.178.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Mar 2020 11:56:12 -0700
Subject: Re: [PATCH] KVM: nSVM: check for EFER.SVME=1 before entering guest
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
 <b5cb03b1-9840-f8f5-843a-1eab680d5e8e@oracle.com>
 <6426c98d-d206-aeb7-93fa-da62b77df21a@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <3ce6d879-5e53-cdf1-a876-542044511836@oracle.com>
Date:   Thu, 19 Mar 2020 11:56:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6426c98d-d206-aeb7-93fa-da62b77df21a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/19/20 3:05 AM, Paolo Bonzini wrote:
> On 18/03/20 19:40, Krish Sadhukhan wrote:
>> On 3/18/20 5:41 AM, Paolo Bonzini wrote:
>>> EFER is set for L2 using svm_set_efer, which hardcodes EFER_SVME to 1
>>> and hides
>>> an incorrect value for EFER.SVME in the L1 VMCB.  Perform the check
>>> manually
>>> to detect invalid guest state.
>>>
>>> Reported-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>    arch/x86/kvm/svm.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 08568ae9f7a1..2125c6ae5951 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -3558,6 +3558,9 @@ static bool nested_svm_vmrun_msrpm(struct
>>> vcpu_svm *svm)
>>>      static bool nested_vmcb_checks(struct vmcb *vmcb)
>>>    {
>>> +    if ((vmcb->save.efer & EFER_SVME) == 0)
>>> +        return false;
>>> +
>>>        if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
>>>            return false;
>>>    
>> Ah! This now tells me that I forgot the KVM fix that was supposed to
>> accompany my patchset.
> Heh, indeed.  I was puzzled for a second after applying it, then decided
> I would just fix it myself. :)
>
>> Do we need this check in software ? I wasn't checking the bit in KVM and
>> instead I was just making sure that L0 sets that bit based on the
>> setting in nested vmcb:
Thanks !
> The only effect of the function below over svm_set_efer is to guarantee
> a vmrun error to happen.  Doing the test in nested_vmcb_checks is more
> consistent with other must-be-one bits such as the VMRUN intercept, and
> it's also a smaller patch.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

>
> Paolo
>
>> +static void nested_svm_set_efer(struct kvm_vcpu *vcpu, u64
>> nested_vmcb_efer)
>> +{
>> +       svm_set_efer(vcpu, nested_vmcb_efer);
>> +
>> +       if (!(nested_vmcb_efer & EFER_SVME))
>> +               to_svm(vcpu)->vmcb->save.efer &= ~EFER_SVME;
>> +}
>> +
>>   static int is_external_interrupt(u32 info)
>>   {
>>          info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
>> @@ -3554,7 +3562,7 @@ static void enter_svm_guest_mode(struct vcpu_svm
>> *svm, u64
>>          svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
>>          svm->vmcb->save.idtr = nested_vmcb->save.idtr;
>>          kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
>> -       svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>> +       nested_svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>>          svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>>          svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
>>          if (npt_enabled) {
>>
