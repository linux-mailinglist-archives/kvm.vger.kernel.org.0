Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60F7A4105
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfH3X1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 19:27:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3X1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 19:27:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNNmWj153195;
        Fri, 30 Aug 2019 23:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ngtg4yHQ9M+IZvk9vsX6CV0kQrDljgS/M+sOckzc5hc=;
 b=JfGcjOgd4XUKYEQEUMlkVycNCzryYymkHc59a2MqoZmIhnsDEMRM94druYA6UHW8SmdG
 HimQNZ21TFwrXjF5UcUMErBtbDtiRH/LSQToa9um3LRjB26IaMHLLPwD0fztJH9JA1JR
 6zqj3tbhH2JGGzd6Un0Lkiqp573dEMXe3KN3xEtkXtSBkkEy6pHLJhFeslW9h0/wYlhw
 SvEvB8PZrHKenstow9+QkavwqYHVLZRgYlGIJf1KRqVre6FUOvQTvNS7dzDMJGgbyrVp
 MT5NUOAjyFMmAFiv1CZJlf9TdOGbAfqDZlfcAm2uGPyYdJksBbAhYK40Ikdnbt8cyzCf Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uqdah00yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNN4n6031578;
        Fri, 30 Aug 2019 23:26:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uqd1vgppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:26:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UNQpI3003246;
        Fri, 30 Aug 2019 23:26:51 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 16:26:50 -0700
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_DEBUGCTL on vmentry of nested
 guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-2-krish.sadhukhan@oracle.com>
 <CALMp9eQxdF5tJLWaWu+0t0NjhSiJfowo1U6MDkjB_zYNRKiyKw@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e35e7c1f-e5c8-5f98-771e-302cf8dfba7f@oracle.com>
Date:   Fri, 30 Aug 2019 16:26:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQxdF5tJLWaWu+0t0NjhSiJfowo1U6MDkjB_zYNRKiyKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300229
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300229
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/29/2019 03:12 PM, Jim Mattson wrote:
> On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Checks on Guest Control Registers, Debug Registers, and
>> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
>> of nested guests:
>>
>>      If the "load debug controls" VM-entry control is 1, bits reserved in the
>>      IA32_DEBUGCTL MSR must be 0 in the field for that register. The first
>>      processors to support the virtual-machine extensions supported only the
>>      1-setting of this control and thus performed this check unconditionally.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 4 ++++
>>   arch/x86/kvm/x86.h        | 6 ++++++
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 46af3a5e9209..0b234e95e0ed 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2677,6 +2677,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>              !nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4))
>>                  return -EINVAL;
>>
>> +       if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
>> +           !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
>> +               return -EINVAL;
>> +
>>          if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>>              !kvm_pat_valid(vmcs12->guest_ia32_pat))
>>                  return -EINVAL;
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index a470ff0868c5..28ba6d0c359f 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -354,6 +354,12 @@ static inline bool kvm_pat_valid(u64 data)
>>          return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>>   }
>>
>> +static inline bool kvm_debugctl_valid(u64 data)
>> +{
>> +       /* Bits 2, 3, 4, 5, 13 and [31:16] are reserved */
>> +       return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
>> +}
> This should actually be consistent with the constraints in kvm_set_msr_common:
>
> case MSR_IA32_DEBUGCTLMSR:
>          if (!data) {
>                  /* We support the non-activated case already */
>                  break;
>          } else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
>                  /* Values other than LBR and BTF are vendor-specific,
>                     thus reserved and should throw a #GP */
>                  return 1;
>          }
>
> Also, as I said earlier...
>
> I'd rather see this built on an interface like:
>
> bool kvm_valid_msr_value(u32 msr_index, u64 value);

Yes, I forgot to do it. Will send a patch for this...

>
> Strange that we allow IA32_DEBUGCTL.BTF, since kvm_vcpu_do_singlestep
> ignores it. And vLBR still isn't a thing, is it?

Yes, DEBUGCTLMSR_LBR isn't used.
Good catch !

>
> It's a bit scary to me that we allow any architecturally legal
> IA32_DEBUGCTL bits to be set today. There's probably a CVE in there
> somewhere.
Is it appropriate to disable those two bits as well, then ?
