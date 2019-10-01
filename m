Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAABC429A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 23:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfJAVXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 17:23:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfJAVXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 17:23:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91L9bcw085152;
        Tue, 1 Oct 2019 21:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZpKc7aENQqYHUgfNOkecxRnZ6HzK5dDgx4joGZCtofA=;
 b=HQ2r5wRr97WdSUEY7mLJPvP/WxZeCcDP4/olK4LpuMK8K2pcm2nERldkmdGq5xAIVBVX
 FxjW4rMgn5z7iziIKmZnz9paUgEOpz99Kkbc6NdWb3naUvDARu2DdCONKXPeKTmq07xG
 cOuXD9wPPpn+j1tp4jKAQ+1N1Os+b/+lbUzSP7qb2iQVtjluBgl8ue7Y89+RhtYwKRUV
 wZXChR7cWYPlf7eyqSuF0xdNzsrh+5RWvX2UscSAUbETB+3rIbacvkyWYh5mBV+IKh6+
 7zgoULIRblvSxM2y7ukPuC+W9MWE6aktnHnIbTgJERjUOg2LFqQ2YNltTb6mw1+yTlqV QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rs159-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 21:23:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91L8f9e145186;
        Tue, 1 Oct 2019 21:21:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vbmq0cqds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 21:21:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91LLHLE003280;
        Tue, 1 Oct 2019 21:21:17 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 14:21:17 -0700
Subject: Re: [PATCH] nVMX: Defer error from VM-entry MSR-load area to until
 after hardware verifies VMCS guest state-area
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
 <20190930233626.22852-2-krish.sadhukhan@oracle.com>
 <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8d2a861d-cd7f-13c7-87e9-7a1e21b63e2b@oracle.com>
Date:   Tue, 1 Oct 2019 14:21:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010176
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/01/2019 10:09 AM, Jim Mattson wrote:
> On Mon, Sep 30, 2019 at 5:12 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section “VM Entries” in Intel SDM vol 3C, VM-entry checks are
>> performed in a certain order. Checks on MSRs that are loaded on VM-entry
>> from VM-entry MSR-load area, should be done after verifying VMCS controls,
>> host-state area and guest-state area. As KVM relies on CPU hardware to
>> perform some of these checks, we need to defer VM-exit due to invalid
>> VM-entry MSR-load area to until after CPU hardware completes the earlier
>> checks and is ready to do VMLAUNCH/VMRESUME.
>>
>> In order to defer errors arising from invalid VM-entry MSR-load area in
>> vmcs12, we set up a single invalid entry, which is illegal according to
>> section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area of
>> vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry failure
>> due to MSR loading" after it completes checks on VMCS controls, host-state
>> area and guest-state area. We reflect a synthesized Exit Qualification to
>> our guest.
> This change addresses the priority inversion, but it still potentially
> leaves guest MSRs incorrectly loaded with values from the VMCS12
> VM-entry MSR-load area when a higher priority error condition would
> have precluded any processing of the VM-entry MSR-load area.

May be, we should not load any guest MSR until we have checked the 
entire vmcs12 MSR-load area in nested_vmx_load_msr()  ?

>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
>> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
>>   arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
>>   arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
>>   3 files changed, 49 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ced9fba32598..b74491c04090 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
>>                  goto vmentry_fail_vmexit_guest_mode;
>>
>>          if (from_vmentry) {
>> -               exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
>>                  exit_qual = nested_vmx_load_msr(vcpu,
>>                                                  vmcs12->vm_entry_msr_load_addr,
>>                                                  vmcs12->vm_entry_msr_load_count);
>> -               if (exit_qual)
>> -                       goto vmentry_fail_vmexit_guest_mode;
>> +               if (exit_qual) {
>> +                       /*
>> +                        * According to section “VM Entries” in Intel SDM
>> +                        * vol 3C, VM-entry checks are performed in a certain
>> +                        * order. Checks on MSRs that are loaded on VM-entry
>> +                        * from VM-entry MSR-load area, should be done after
>> +                        * verifying VMCS controls, host-state area and
>> +                        * guest-state area. As KVM relies on CPU hardware to
>> +                        * perform some of these checks, we need to defer
>> +                        * VM-exit due to invalid VM-entry MSR-load area to
>> +                        * until after CPU hardware completes the earlier
>> +                        * checks and is ready to do VMLAUNCH/VMRESUME.
>> +                        *
>> +                        * In order to defer errors arising from invalid
>> +                        * VM-entry MSR-load area in vmcs12, we set up a
>> +                        * single invalid entry, which is illegal according
>> +                        * to section "Loading MSRs in Intel SDM vol 3C, in
>> +                        * VM-entry MSR-load area of vmcs02. This will cause
>> +                        * the CPU hardware to VM-exit with "VM-entry
>> +                        * failure due to MSR loading" after it completes
>> +                        * checks on VMCS controls, host-state area and
>> +                        * guest-state area.
>> +                        */
>> +                       vmx->loaded_vmcs->invalid_msr_load_area.index =
>> +                           MSR_FS_BASE;
> Can this field be statically populated during initialization?

Yes.

>
>> +                       vmx->loaded_vmcs->invalid_msr_load_area.value =
>> +                           exit_qual;
> This seems awkward. Why not save 16 bytes per loaded_vmcs by
> allocating one invalid_msr_load_area system-wide and just add a 4 byte
> field to struct nested_vmx to store this value?

OK.

>
>> +                       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
>> +                       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
>> +                           __pa(&(vmx->loaded_vmcs->invalid_msr_load_area)));
>> +               }
> Do you need to set vmx->nested.dirty_vmcs12 to ensure that
> prepare_vmcs02_constant_state() will be called at the next emulated
> VM-entry, to undo this change to VM_ENTRY_MSR_LOAD_ADDR?

Yes.

>
>>          } else {
>>                  /*
>>                   * The MMU is not initialized to point at the right entities yet and
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index 187d39bf0bf1..f3a384235b68 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
>>   static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>>                                              u32 exit_reason)
>>   {
>> +       u32 exit_qual;
>>          u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
>>
>>          /*
>>           * At this point, the exit interruption info in exit_intr_info
>> @@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>>                          vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
>>          }
>>
>> -       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
>> -                         vmcs_readl(EXIT_QUALIFICATION));
>> +       exit_qual = vmcs_readl(EXIT_QUALIFICATION);
>> +
>> +       if (vmx->loaded_vmcs->invalid_msr_load_area.index == MSR_FS_BASE &&
>> +           (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
>> +                           EXIT_REASON_MSR_LOAD_FAIL))) {
> Is the second conjunct sufficient? i.e. Isn't there a bug in kvm if
> the second conjunct is true and the first is not?

If the first conjunct isn't true and the second one is, it means it's a 
hardware-detected MSR-load error. Right ? So won't that be handled the 
same way it is handled currently in KVM ?

>
>> +               exit_qual = vmx->loaded_vmcs->invalid_msr_load_area.value;
>> +       }
>> +
>> +       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
>> +
>>          return 1;
>>   }
>>
>> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
>> index 481ad879197b..e272788bd4b8 100644
>> --- a/arch/x86/kvm/vmx/vmcs.h
>> +++ b/arch/x86/kvm/vmx/vmcs.h
>> @@ -70,6 +70,12 @@ struct loaded_vmcs {
>>          struct list_head loaded_vmcss_on_cpu_link;
>>          struct vmcs_host_state host_state;
>>          struct vmcs_controls_shadow controls_shadow;
>> +       /*
>> +        * This field is used to set up an invalid VM-entry MSR-load area
>> +        * for vmcs02 if an error is detected while processing the entries
>> +        * in VM-entry MSR-load area of vmcs12.
>> +        */
>> +       struct vmx_msr_entry invalid_msr_load_area;
>>   };
> I'd suggest allocating just one invalid_msr_load_area system-wide, as
> mentioned above.
>
>>   static inline bool is_exception_n(u32 intr_info, u8 vector)
>> --
>> 2.20.1
>>

