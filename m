Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636E1C8F8F
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfJBRRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:17:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbfJBRRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:17:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92HEUlo054332;
        Wed, 2 Oct 2019 17:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xV21EA0eNgSgi4TIbwPwUUHlu47QThoHD8fTIEzcp1k=;
 b=PrcLfj3+Z+Ywk0KV89jGsc1iyxAHBx2oZYs+wIXvxG1WRlqbTcB56Iqr3ubT0SWTa16q
 wjk8GUXjSygwA9QLR5mnLIiftTa5F3NJcNrg63vyeQhD0q4B6Ampy2GHIDEugHh6KGtX
 1wCD+30c0cKZIRh3WFAx48+q6CADDD0+gyJ0HF6qpzZeTH6ecZXK82epB+rZ+6uMMUIx
 2Nnn/2q3VP7H9Zz8B90Ye9VQkikmlNcEMvE2Tbce4rn4DY9fFaQ+KBFsI5mjc9SnOwpf
 5lnIB/IJkee3VwRkt7VvBdSXN6hxFdqqhJPjRIQd2rdGds3Qju7LPYI8WBYrsGZawlf/ 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rxbns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 17:16:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92HDrxk007456;
        Wed, 2 Oct 2019 17:16:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vckyp92v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 17:16:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x92HGoiW002443;
        Wed, 2 Oct 2019 17:16:50 GMT
Received: from [10.159.229.216] (/10.159.229.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 10:16:49 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] nVMX: Defer error from VM-entry MSR-load area to until
 after hardware verifies VMCS guest state-area
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
 <20190930233626.22852-2-krish.sadhukhan@oracle.com>
 <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
 <8d2a861d-cd7f-13c7-87e9-7a1e21b63e2b@oracle.com>
 <CALMp9eTcXVo73JCKyxLzWz9s_VZ52UV3y_XJtyhC-MnkYRJCbQ@mail.gmail.com>
Message-ID: <9b881861-260d-fbf8-c740-20ca93aa2ae9@oracle.com>
Date:   Wed, 2 Oct 2019 10:16:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTcXVo73JCKyxLzWz9s_VZ52UV3y_XJtyhC-MnkYRJCbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/1/19 3:02 PM, Jim Mattson wrote:
> On Tue, Oct 1, 2019 at 2:23 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com>  wrote:
>>
>> On 10/01/2019 10:09 AM, Jim Mattson wrote:
>>> On Mon, Sep 30, 2019 at 5:12 PM Krish Sadhukhan
>>> <krish.sadhukhan@oracle.com>  wrote:
>>>> According to section “VM Entries” in Intel SDM vol 3C, VM-entry checks are
>>>> performed in a certain order. Checks on MSRs that are loaded on VM-entry
>>>> from VM-entry MSR-load area, should be done after verifying VMCS controls,
>>>> host-state area and guest-state area. As KVM relies on CPU hardware to
>>>> perform some of these checks, we need to defer VM-exit due to invalid
>>>> VM-entry MSR-load area to until after CPU hardware completes the earlier
>>>> checks and is ready to do VMLAUNCH/VMRESUME.
>>>>
>>>> In order to defer errors arising from invalid VM-entry MSR-load area in
>>>> vmcs12, we set up a single invalid entry, which is illegal according to
>>>> section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area of
>>>> vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry failure
>>>> due to MSR loading" after it completes checks on VMCS controls, host-state
>>>> area and guest-state area. We reflect a synthesized Exit Qualification to
>>>> our guest.
>>> This change addresses the priority inversion, but it still potentially
>>> leaves guest MSRs incorrectly loaded with values from the VMCS12
>>> VM-entry MSR-load area when a higher priority error condition would
>>> have precluded any processing of the VM-entry MSR-load area.
>> May be, we should not load any guest MSR until we have checked the
>> entire vmcs12 MSR-load area in nested_vmx_load_msr()  ?
> That's not sufficient. We shouldn't load any guest MSR until all of
> the checks on host state, controls, and guest state have passed. Since
> we defer the guest state checks to hardware, that makes the proper
> ordering a bit problematic. Instead, you can try to arrange to undo
> the guest MSR loads if a higher priority error is discovered. That
> won't be trivial.


We discussed about undoing guest MSR loads in an earlier thread. You 
said that some MSR updates couldn't be rolled back. If we can't rollback 
some MSR updates and if that leads to an undefined guest configuration, 
may be we should return to L0 and mark it as a hardware failure, like 
what we currently do for some VM-entry failures in vmx_handle_exit():


     if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
                 dump_vmcs();
                 vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
vcpu->run->fail_entry.hardware_entry_failure_reason
                         = exit_reason;
                 return 0;
         }


>>>> Suggested-by: Jim Mattson<jmattson@google.com>
>>>> Signed-off-by: Krish Sadhukhan<krish.sadhukhan@oracle.com>
>>>> Reviewed-by: Mihai Carabas<mihai.carabas@oracle.com>
>>>> Reviewed-by: Liran Alon<liran.alon@oracle.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
>>>>    arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
>>>>    arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
>>>>    3 files changed, 49 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>>> index ced9fba32598..b74491c04090 100644
>>>> --- a/arch/x86/kvm/vmx/nested.c
>>>> +++ b/arch/x86/kvm/vmx/nested.c
>>>> @@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
>>>>                   goto vmentry_fail_vmexit_guest_mode;
>>>>
>>>>           if (from_vmentry) {
>>>> -               exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
>>>>                   exit_qual = nested_vmx_load_msr(vcpu,
>>>>                                                   vmcs12->vm_entry_msr_load_addr,
>>>>                                                   vmcs12->vm_entry_msr_load_count);
>>>> -               if (exit_qual)
>>>> -                       goto vmentry_fail_vmexit_guest_mode;
>>>> +               if (exit_qual) {
>>>> +                       /*
>>>> +                        * According to section “VM Entries” in Intel SDM
>>>> +                        * vol 3C, VM-entry checks are performed in a certain
>>>> +                        * order. Checks on MSRs that are loaded on VM-entry
>>>> +                        * from VM-entry MSR-load area, should be done after
>>>> +                        * verifying VMCS controls, host-state area and
>>>> +                        * guest-state area. As KVM relies on CPU hardware to
>>>> +                        * perform some of these checks, we need to defer
>>>> +                        * VM-exit due to invalid VM-entry MSR-load area to
>>>> +                        * until after CPU hardware completes the earlier
>>>> +                        * checks and is ready to do VMLAUNCH/VMRESUME.
>>>> +                        *
>>>> +                        * In order to defer errors arising from invalid
>>>> +                        * VM-entry MSR-load area in vmcs12, we set up a
>>>> +                        * single invalid entry, which is illegal according
>>>> +                        * to section "Loading MSRs in Intel SDM vol 3C, in
>>>> +                        * VM-entry MSR-load area of vmcs02. This will cause
>>>> +                        * the CPU hardware to VM-exit with "VM-entry
>>>> +                        * failure due to MSR loading" after it completes
>>>> +                        * checks on VMCS controls, host-state area and
>>>> +                        * guest-state area.
>>>> +                        */
>>>> +                       vmx->loaded_vmcs->invalid_msr_load_area.index =
>>>> +                           MSR_FS_BASE;
>>> Can this field be statically populated during initialization?
>> Yes.
>>
>>>> +                       vmx->loaded_vmcs->invalid_msr_load_area.value =
>>>> +                           exit_qual;
>>> This seems awkward. Why not save 16 bytes per loaded_vmcs by
>>> allocating one invalid_msr_load_area system-wide and just add a 4 byte
>>> field to struct nested_vmx to store this value?
>> OK.
>>
>>>> +                       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
>>>> +                       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
>>>> +                           __pa(&(vmx->loaded_vmcs->invalid_msr_load_area)));
>>>> +               }
>>> Do you need to set vmx->nested.dirty_vmcs12 to ensure that
>>> prepare_vmcs02_constant_state() will be called at the next emulated
>>> VM-entry, to undo this change to VM_ENTRY_MSR_LOAD_ADDR?
>> Yes.
>>
>>>>           } else {
>>>>                   /*
>>>>                    * The MMU is not initialized to point at the right entities yet and
>>>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>>>> index 187d39bf0bf1..f3a384235b68 100644
>>>> --- a/arch/x86/kvm/vmx/nested.h
>>>> +++ b/arch/x86/kvm/vmx/nested.h
>>>> @@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
>>>>    static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>>>>                                               u32 exit_reason)
>>>>    {
>>>> +       u32 exit_qual;
>>>>           u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>>>> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>>
>>>>           /*
>>>>            * At this point, the exit interruption info in exit_intr_info
>>>> @@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>>>>                           vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
>>>>           }
>>>>
>>>> -       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
>>>> -                         vmcs_readl(EXIT_QUALIFICATION));
>>>> +       exit_qual = vmcs_readl(EXIT_QUALIFICATION);
>>>> +
>>>> +       if (vmx->loaded_vmcs->invalid_msr_load_area.index == MSR_FS_BASE &&
>>>> +           (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
>>>> +                           EXIT_REASON_MSR_LOAD_FAIL))) {
>>> Is the second conjunct sufficient? i.e. Isn't there a bug in kvm if
>>> the second conjunct is true and the first is not?
>> If the first conjunct isn't true and the second one is, it means it's a
>> hardware-detected MSR-load error. Right ? So won't that be handled the
>> same way it is handled currently in KVM ?
> I believe that KVM will currently forward such an error to L1, which
> is wrong, since L1 has no control over vmcs02's VM-entry MSR-load
> area.


You are right. I hadn't noticed it until you mentioned.


>   The assumption is that this will never happen, because L0 is too
> careful.
>>>> +               exit_qual = vmx->loaded_vmcs->invalid_msr_load_area.value;
>>>> +       }
>>>> +
>>>> +       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
>>>> +
>>>>           return 1;
>>>>    }
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
>>>> index 481ad879197b..e272788bd4b8 100644
>>>> --- a/arch/x86/kvm/vmx/vmcs.h
>>>> +++ b/arch/x86/kvm/vmx/vmcs.h
>>>> @@ -70,6 +70,12 @@ struct loaded_vmcs {
>>>>           struct list_head loaded_vmcss_on_cpu_link;
>>>>           struct vmcs_host_state host_state;
>>>>           struct vmcs_controls_shadow controls_shadow;
>>>> +       /*
>>>> +        * This field is used to set up an invalid VM-entry MSR-load area
>>>> +        * for vmcs02 if an error is detected while processing the entries
>>>> +        * in VM-entry MSR-load area of vmcs12.
>>>> +        */
>>>> +       struct vmx_msr_entry invalid_msr_load_area;
>>>>    };
>>> I'd suggest allocating just one invalid_msr_load_area system-wide, as
>>> mentioned above.
>>>
>>>>    static inline bool is_exception_n(u32 intr_info, u8 vector)
>>>> --
>>>> 2.20.1
>>>>
