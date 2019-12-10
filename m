Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012F41191F3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 21:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLJU3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 15:29:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLJU3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 15:29:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAKTiUj053896;
        Tue, 10 Dec 2019 20:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=X0NRXY1z5PEhGQy4tdDhQxEEB6ElYlIMOUeIx0Iv8aE=;
 b=agvKs4UEcyNPMv9VwgUoX2dbE5RYLrcdKVMe7XhERYaLfQRPC2/s66uyLlqV16pFzSsy
 Aqy0iTz/OYGz25XSSarfbu3F3d89KvfpZz5oMj92TH4qi/uO4oGM3MY70bbdzWTZVhcJ
 VqSbkaObiQHMhaaYfE1ubEycis7BMu/1wqLEAzpb8H4EqR5m8IFqjUqyvA33OApIhFek
 7Yo3YeX2I+kG4rFt96S6QLc4dTGT8as7gKFitqUVH2Cam+HQutUV8ojHdFL072zcZ9zw
 SmQ3uT0KS/ieTQX9C1m+9T45xbveVNAxc7T7p47Oqpd6ruF/CaDm5oFpzhFsdzd3chcW /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wrw4n5f2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 20:29:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAKSexo169213;
        Tue, 10 Dec 2019 20:29:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wsv8cchq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 20:29:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBAKTeN7000449;
        Tue, 10 Dec 2019 20:29:40 GMT
Received: from [10.159.229.173] (/10.159.229.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 12:29:40 -0800
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
 <20191206231302.3466-2-krish.sadhukhan@oracle.com>
 <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
 <47daeae4-6836-9d60-729a-d5e2d5810edd@oracle.com>
 <CALMp9eRaX-bdyxAP4C=mdSOFLjCpT+f5RTAb+DchTVktZ+_xfQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <43382539-7646-c913-e3cd-bf696e524ea3@oracle.com>
Date:   Tue, 10 Dec 2019 12:29:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRaX-bdyxAP4C=mdSOFLjCpT+f5RTAb+DchTVktZ+_xfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/10/19 11:48 AM, Jim Mattson wrote:
> On Tue, Dec 10, 2019 at 11:36 AM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 12/10/19 9:57 AM, Jim Mattson wrote:
>>> On Fri, Dec 6, 2019 at 3:49 PM Krish Sadhukhan
>>> <krish.sadhukhan@oracle.com> wrote:
>>>> According to section "Checks on Guest Control Registers, Debug Registers, and
>>>> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
>>>> of nested guests:
>>>>
>>>>       "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
>>>>        contain a canonical address."
>>>>
>>>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/nested.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>>> index 0e7c9301fe86..a2d1c305a7d8 100644
>>>> --- a/arch/x86/kvm/vmx/nested.c
>>>> +++ b/arch/x86/kvm/vmx/nested.c
>>>> @@ -2770,6 +2770,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>>>               CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>>>>                   return -EINVAL;
>>>>
>>>> +       if (CC(!is_noncanonical_address(vmcs12->guest_sysenter_esp)) ||
>>>> +           CC(!is_noncanonical_address(vmcs12->guest_sysenter_eip)))
>>>> +               return -EINVAL;
>>>> +
>>> Don't the hardware checks on the corresponding vmcs02 fields suffice
>>> in this case?
>> In prepare_vmcs02(), we have the following code:
>>
>>           if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
>>                   prepare_vmcs02_rare(vmx, vmcs12);
>>
>> If vmcs12 is dirty, we are setting these two fields from vmcs12 and I
>> thought the values needed to be checked in software. Did I miss something ?
> Typically, "guest state" doesn't have to be checked in software, as
> long as (a) the vmcs12 field is copied unmodified to the corresponding
> vmcs02 field, and (b) the virtual CPU enforces the same constraints as
> the physical CPU. In this case, if there is a problem with the guest
> state, the VM-entry to vmcs02 will immediately VM-exit with "VM-entry
> failure due to invalid guest state," and L0 will reflect this exit
> reason to L1.


Thanks for the explanation !

So the kvm-unit-test is still needed to verify that hardware does the 
check. Right ?

>
>>>>           if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>>>>               CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
>>>>                   return -EINVAL;
>>>> --
>>>> 2.20.1
>>>>
