Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4092DBE943
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 01:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfIYXze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 19:55:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfIYXze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 19:55:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PNsGsb154963;
        Wed, 25 Sep 2019 23:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g4/xuxSmWl76M0e2JgrpaUXPD+Ns9UygHRa/6EFUfgQ=;
 b=e4OsdQH0vRejMjXJgbgajX8o7UJcErvjofKPUCO5ViQcTpTaaWisjcli8oWDiRyQbo+o
 ctz+97WWWFJesUrBOYtNTTNK/J5kxIZKNL7jl9YHRI5VRMSWP4Lo1XPixWqwBhItUaK8
 i8SA1SzNgClRS++bW1Myf41x8AcdlR+OtpNQz98TIfeXch+n0VX57IGL7iI5eQ5Pm9R0
 0CqytJhMH9scVr6IKMsFHRewyni2J2bMMhtdrXmUBElPvdwH72rJFNVSkfTLiUJJAZ15
 7Y0nayMn20a0QqAM2jT30naZOJtNYrDo00lG0e54OhP+5edrthg01V2qi3cn5LbR9Gf0 Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tyxsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 23:55:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PNsAvJ015460;
        Wed, 25 Sep 2019 23:55:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qaumma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 23:55:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PNtHdB027924;
        Wed, 25 Sep 2019 23:55:17 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 16:55:17 -0700
Subject: Re: [PATCH] KVM: nVMX: cleanup and fix host 64-bit mode checks
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eTBPTnsRDipdGDgmugWgfFEjQ2wd_9-JY0ZeM9YG2fBjg@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <3460bd57-6fdd-f73c-9ce0-c97d4cc85f63@oracle.com>
Date:   Wed, 25 Sep 2019 16:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTBPTnsRDipdGDgmugWgfFEjQ2wd_9-JY0ZeM9YG2fBjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250196
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/25/2019 09:47 AM, Jim Mattson wrote:
> On Wed, Sep 25, 2019 at 9:34 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> KVM was incorrectly checking vmcs12->host_ia32_efer even if the "load
>> IA32_EFER" exit control was reset.  Also, some checks were not using
>> the new CC macro for tracing.
>>
>> Cleanup everything so that the vCPU's 64-bit mode is determined
>> directly from EFER_LMA and the VMCS checks are based on that, which
>> matches section 26.2.4 of the SDM.
>>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Fixes: 5845038c111db27902bc220a4f70070fe945871c
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++---------------------------
>>   1 file changed, 22 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 70d59d9304f2..e108847f6cf8 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2664,8 +2664,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>              CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
>>                  return -EINVAL;
>>
>> -       ia32e = (vmcs12->vm_exit_controls &
>> -                VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
>> +#ifdef CONFIG_X86_64
>> +       ia32e = !!(vcpu->arch.efer & EFER_LMA);
>> +#else
>> +       if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE))
>> +               return -EINVAL;
> This check is redundant, since it is checked in the else block below.

Should we be re-using is_long_mode() instead of duplicating the code ?

>
>> +
>> +       ia32e = false;
>> +#endif
>> +
>> +       if (ia32e) {
>> +               if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
>> +                   CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
>> +                       return -EINVAL;
>> +       } else {
>> +               if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
>> +                   CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
>> +                   CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
>> +                   CC(((vmcs12->host_rip) >> 32) & 0xffffffff))
> The mask shouldn't be necessary.
>
>> +                       return -EINVAL;
>> +       }
>>
>>          if (CC(vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
>>              CC(vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
>> @@ -2684,35 +2702,8 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>              CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
>>              CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
>>              CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
>> -           CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)))
>> -               return -EINVAL;
>> -
>> -       if (!(vmcs12->host_ia32_efer & EFER_LMA) &&
>> -           ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
>> -           (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE))) {
>> -               return -EINVAL;
>> -       }
>> -
>> -       if ((vmcs12->host_ia32_efer & EFER_LMA) &&
>> -           !(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) {
>> -               return -EINVAL;
>> -       }
>> -
>> -       if (!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
>> -           ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
>> -           (vmcs12->host_cr4 & X86_CR4_PCIDE) ||
>> -           (((vmcs12->host_rip) >> 32) & 0xffffffff))) {
>> -               return -EINVAL;
>> -       }
>> -
>> -       if ((vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
>> -           ((!(vmcs12->host_cr4 & X86_CR4_PAE)) ||
>> -           (is_noncanonical_address(vmcs12->host_rip, vcpu)))) {
>> -               return -EINVAL;
>> -       }
>> -#else
>> -       if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE ||
>> -           vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
>> +           CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
>> +           CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))
>>                  return -EINVAL;
>>   #endif
>>
>> --
>> 1.8.3.1
>>
> Reviewed-by: Jim Mattson <jmattson@google.com>

