Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA623A364
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHCLep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 07:34:45 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:41273 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCLem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 07:34:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596454480; x=1627990480;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6wA/Tb+ewavhb+NtDfbEKUtgYOHoclsINec5IA+200s=;
  b=bPJCU2AC0GD5PennMl+XVgIVVffTq298r1G4BM4xntwQ4U51jqxH4koo
   8xJms7wCM/UB6sNhdipBnj1i3S+wtg7kI8wK12L/xwc9+5YNJ62zezR9o
   3GB/auHwDcK4jYYQ6DNbKCxLXIXN0b9qN3oxjSAEovoXoIMGF14dX7zjB
   0=;
IronPort-SDR: kwi446vP05FKaOiIhhiqhG+zPgE8OfKO28Tfagp+QvK/zw2kwjh5fIR7Mv1C12HuCALAXgez6B
 7FReTH9Z1m6w==
X-IronPort-AV: E=Sophos;i="5.75,430,1589241600"; 
   d="scan'208";a="45735734"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 03 Aug 2020 11:34:38 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 2ED12A2246;
        Mon,  3 Aug 2020 11:34:34 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 11:34:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.192) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 11:34:31 +0000
Subject: Re: [PATCH v3 1/3] KVM: x86: Deflect unknown MSR accesses to user
 space
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "KarimAllah Raslan" <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200731214947.16885-1-graf@amazon.com>
 <20200731214947.16885-2-graf@amazon.com>
 <873654q89j.fsf@vitty.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <4155720f-73ce-0857-134f-52a1f09d15cd@amazon.com>
Date:   Mon, 3 Aug 2020 13:34:28 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <873654q89j.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13D31UWC001.ant.amazon.com (10.43.162.152) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.08.20 13:27, Vitaly Kuznetsov wrote:
> Alexander Graf <graf@amazon.com> writes:
> =

>> MSRs are weird. Some of them are normal control registers, such as EFER.
>> Some however are registers that really are model specific, not very
>> interesting to virtualization workloads, and not performance critical.
>> Others again are really just windows into package configuration.
>>
>> Out of these MSRs, only the first category is necessary to implement in
>> kernel space. Rarely accessed MSRs, MSRs that should be fine tunes again=
st
>> certain CPU models and MSRs that contain information on the package level
>> are much better suited for user space to process. However, over time we =
have
>> accumulated a lot of MSRs that are not the first category, but still han=
dled
>> by in-kernel KVM code.
>>
>> This patch adds a generic interface to handle WRMSR and RDMSR from user
>> space. With this, any future MSR that is part of the latter categories c=
an
>> be handled in user space.
>>
>> Furthermore, it allows us to replace the existing "ignore_msrs" logic wi=
th
>> something that applies per-VM rather than on the full system. That way y=
ou
>> can run productive VMs in parallel to experimental ones where you don't =
care
>> about proper MSR handling.
>>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>
>> ---
>>
>> v1 -> v2:
>>
>>    - s/ETRAP_TO_USER_SPACE/ENOENT/g
>>    - deflect all #GP injection events to user space, not just unknown MS=
Rs.
>>      That was we can also deflect allowlist errors later
>>    - fix emulator case
>>
>> v2 -> v3:
>>
>>    - return r if r =3D=3D X86EMUL_IO_NEEDED
>>    - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
>>    - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
>>    - Use complete_userspace_io logic instead of reply field
>>    - Simplify trapping code
>> ---
>>   Documentation/virt/kvm/api.rst  |  62 +++++++++++++++++++
>>   arch/x86/include/asm/kvm_host.h |   6 ++
>>   arch/x86/kvm/emulate.c          |  18 +++++-
>>   arch/x86/kvm/x86.c              | 106 ++++++++++++++++++++++++++++++--
>>   include/trace/events/kvm.h      |   2 +-
>>   include/uapi/linux/kvm.h        |  10 +++
>>   6 files changed, 197 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api=
.rst
>> index 320788f81a05..79c3e2fdfae4 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5155,6 +5155,35 @@ Note that KVM does not skip the faulting instruct=
ion as it does for
>>   KVM_EXIT_MMIO, but userspace has to emulate any change to the processi=
ng state
>>   if it decides to decode and emulate the instruction.
>>
>> +::
>> +
>> +             /* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
>> +             struct {
>> +                     __u8 error;
>> +                     __u8 pad[3];
>> +                     __u32 index;
>> +                     __u64 data;
>> +             } msr;
>> +
>> +Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR =
is
>> +enabled, MSR accesses to registers that would invoke a #GP by KVM kerne=
l code
>> +will instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X=
86_WRMSR
>> +exit for writes.
>> +
>> +For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR th=
e guest
>> +wants to read. To respond to this request with a successful read, user =
space
>> +writes the respective data into the "data" field and must continue guest
>> +execution to ensure the read data is transferred into guest register st=
ate.
>> +
>> +If the RDMSR request was unsuccessful, user space indicates that with a=
 "1" in
>> +the "error" field. This will inject a #GP into the guest when the VCPU =
is
>> +executed again.
>> +
>> +For KVM_EXIT_X86_WRMSR, the "index" field tells user space which MSR th=
e guest
>> +wants to write. Once finished processing the event, user space must con=
tinue
>> +vCPU execution. If the MSR write was unsuccessful, user space also sets=
 the
>> +"error" field to "1".
>> +
>>   ::
>>
>>                /* Fix the size of the union. */
>> @@ -5844,6 +5873,28 @@ controlled by the kvm module parameter halt_poll_=
ns. This capability allows
>>   the maximum halt time to specified on a per-VM basis, effectively over=
riding
>>   the module parameter for the target VM.
>>
>> +7.21 KVM_CAP_X86_USER_SPACE_MSR
>> +-------------------------------
>> +
>> +:Architectures: x86
>> +:Target: VM
>> +:Parameters: args[0] is 1 if user space MSR handling is enabled, 0 othe=
rwise
>> +:Returns: 0 on success; -1 on error
>> +
>> +This capability enables trapping of #GP invoking RDMSR and WRMSR instru=
ctions
>> +into user space.
>> +
>> +When a guest requests to read or write an MSR, KVM may not implement al=
l MSRs
>> +that are relevant to a respective system. It also does not differentiat=
e by
>> +CPU type.
>> +
>> +To allow more fine grained control over MSR handling, user space may en=
able
>> +this capability. With it enabled, MSR accesses that would usually trigg=
er
>> +a #GP event inside the guest by KVM will instead trigger KVM_EXIT_X86_R=
DMSR
>> +and KVM_EXIT_X86_WRMSR exit notifications which user space can then han=
dle to
>> +implement model specific MSR handling and/or user notifications to info=
rm
>> +a user that an MSR was not handled.
>> +
>>   8. Other capabilities.
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> @@ -6151,3 +6202,14 @@ KVM can therefore start protected VMs.
>>   This capability governs the KVM_S390_PV_COMMAND ioctl and the
>>   KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>>   guests when the state change is invalid.
>> +
>> +8.24 KVM_CAP_X86_USER_SPACE_MSR
>> +----------------------------
>> +
>> +:Architectures: x86
>> +
>> +This capability indicates that KVM supports deflection of MSR reads and
>> +writes to user space. It can be enabled on a VM level. If enabled, MSR
>> +accesses that would usually trigger a #GP by KVM into the guest will
>> +instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
>> +KVM_EXIT_X86_WRMSR exit notifications.
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index be5363b21540..809eed0dbdea 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -829,6 +829,9 @@ struct kvm_vcpu_arch {
>>
>>        /* AMD MSRC001_0015 Hardware Configuration */
>>        u64 msr_hwcr;
>> +
>> +     /* User space is handling an MSR request */
>> +     bool pending_user_msr;
>>   };
>>
>>   struct kvm_lpage_info {
>> @@ -1002,6 +1005,9 @@ struct kvm_arch {
>>        bool guest_can_read_msr_platform_info;
>>        bool exception_payload_enabled;
>>
>> +     /* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>> +     bool user_space_msr_enabled;
>> +
>>        struct kvm_pmu_event_filter *pmu_event_filter;
>>        struct task_struct *nx_lpage_recovery_thread;
>>   };
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index d0e2825ae617..744ab9c92b73 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3689,11 +3689,18 @@ static int em_dr_write(struct x86_emulate_ctxt *=
ctxt)
>>
>>   static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>>   {
>> +     u64 msr_index =3D reg_read(ctxt, VCPU_REGS_RCX);
>>        u64 msr_data;
>> +     int r;
>>
>>        msr_data =3D (u32)reg_read(ctxt, VCPU_REGS_RAX)
>>                | ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
>> -     if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_da=
ta))
>> +     r =3D ctxt->ops->set_msr(ctxt, msr_index, msr_data);
>> +
>> +     if (r =3D=3D X86EMUL_IO_NEEDED)
>> +             return r;
>> +
>> +     if (r)
>>                return emulate_gp(ctxt, 0);
>>
>>        return X86EMUL_CONTINUE;
>> @@ -3701,9 +3708,16 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>>
>>   static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
>>   {
>> +     u64 msr_index =3D reg_read(ctxt, VCPU_REGS_RCX);
>>        u64 msr_data;
>> +     int r;
>> +
>> +     r =3D ctxt->ops->get_msr(ctxt, msr_index, &msr_data);
>> +
>> +     if (r =3D=3D X86EMUL_IO_NEEDED)
>> +             return r;
>>
>> -     if (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_d=
ata))
>> +     if (r)
>>                return emulate_gp(ctxt, 0);
>>
>>        *reg_write(ctxt, VCPU_REGS_RAX) =3D (u32)msr_data;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 88c593f83b28..24c72250f6df 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1549,12 +1549,75 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index=
, u64 data)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_set_msr);
>>
>> +static int complete_emulated_msr(struct kvm_vcpu *vcpu, bool is_read)
>> +{
>> +     BUG_ON(!vcpu->arch.pending_user_msr);
>> +
>> +     if (vcpu->run->msr.error) {
>> +             kvm_inject_gp(vcpu, 0);
>> +     } else if (is_read) {
>> +             kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
>> +             kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
>> +     }
>> +
>> +     return kvm_skip_emulated_instruction(vcpu);
>> +}
>> +
>> +static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
>> +{
>> +     return complete_emulated_msr(vcpu, true);
>> +}
>> +
>> +static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
>> +{
>> +     return complete_emulated_msr(vcpu, false);
>> +}
>> +
>> +static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index)
>> +{
>> +     if (!vcpu->kvm->arch.user_space_msr_enabled)
>> +             return 0;
>> +
>> +     vcpu->run->exit_reason =3D KVM_EXIT_X86_RDMSR;
>> +     vcpu->run->msr.error =3D 0;
>> +     vcpu->run->msr.index =3D index;
>> +     vcpu->arch.pending_user_msr =3D true;
>> +     vcpu->arch.complete_userspace_io =3D complete_emulated_rdmsr;
>> +
>> +     return 1;
>> +}
>> +
>> +static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64=
 data)
>> +{
>> +     if (!vcpu->kvm->arch.user_space_msr_enabled)
>> +             return 0;
>> +
>> +     vcpu->run->exit_reason =3D KVM_EXIT_X86_WRMSR;
>> +     vcpu->run->msr.error =3D 0;
>> +     vcpu->run->msr.index =3D index;
>> +     vcpu->run->msr.data =3D data;
>> +     vcpu->arch.pending_user_msr =3D true;
>> +     vcpu->arch.complete_userspace_io =3D complete_emulated_wrmsr;
> =

> I'm probably missing something but where do we reset
> vcpu->arch.pending_user_msr? Shouldn't it be done in
> complete_emulated_msr()?

It's even worse than that: We don't need it at all. I'll remove it for v4.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



