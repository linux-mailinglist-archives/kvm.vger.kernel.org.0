Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1CD230A6B
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgG1MlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 08:41:15 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:14898 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgG1MlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 08:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595940074; x=1627476074;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6rxh8ac7ciw0Zx1kOsDPP9G7yloRQNmqTy3ETBX5Dnk=;
  b=ACtqboWhCAHPtbKlSRClabiQYXkDXlPIHuSXyDC6p+D+PhY9n07iLEr8
   080AegfRHu0p+Ag90GstQDHRUMaQCE0T9SufOMjuVjSc9AegPe6rPhMLH
   dtPNynd8rIs0NMF2KJSmdGt2yQ2KZkdBSBhr4OSaOdQOEWHr8B1MZxYWw
   I=;
IronPort-SDR: OI6Md8XnA7In1NYMEUVaWRThdYVkS8OecLPvGhSVExiqbaKocbCYBSmINzjFKtGcrdky1jwv0F
 ZgcKu3gUeglw==
X-IronPort-AV: E=Sophos;i="5.75,406,1589241600"; 
   d="scan'208";a="45972090"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Jul 2020 12:41:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 70F94A1809;
        Tue, 28 Jul 2020 12:41:08 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Jul 2020 12:41:07 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.203) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Jul 2020 12:41:03 +0000
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200728004446.932-1-graf@amazon.com>
 <87d04gm4ws.fsf@vitty.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
Date:   Tue, 28 Jul 2020 14:41:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87d04gm4ws.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D14UWC002.ant.amazon.com (10.43.162.214) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.07.20 10:15, Vitaly Kuznetsov wrote:
> =

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
> =

> In theory, we can go further: userspace will give KVM the list of MSRs
> it is interested in. This list may even contain MSRs which are normally
> handled by KVM, in this case userspace gets an option to mangle KVM's
> reply (RDMSR) or do something extra (WRMSR). I'm not sure if there is a
> real need behind this, just an idea.
> =

> The problem with this approach is: if currently some MSR is not
> implemented in KVM you will get an exit. When later someone comes with a
> patch to implement this MSR your userspace handling will immediately get
> broken so the list of not implemented MSRs effectively becomes an API :-)

Yeah, I'm not quite sure how to do this without bloating the kernel's =

memory footprint too much though.

One option would be to create a shared bitmap with user space. But that =

would need to be sparse and quite big to be able to address all of =

today's possible MSR indexes. From a quick glimpse at Linux's MSR =

defines, there are:

   0x00000000 - 0x00001000 (Intel)
   0x00001000 - 0x00002000 (VIA)
   0x40000000 - 0x50000000 (PV)
   0xc0000000 - 0xc0003000 (AMD)
   0xc0010000 - 0xc0012000 (AMD)
   0x80860000 - 0x80870000 (Transmeta)

Another idea would be to turn the logic around and implement an =

allowlist in KVM with all of the MSRs that KVM should handle. In that =

API we could ask for an array of KVM supported MSRs into user space. =

User space could then bounce that array back to KVM to have all in-KVM =

supported MSRs handled. Or it could remove entries that it wants to =

handle on its own.

KVM internally could then save the list as a dense bitmap, translating =

every list entry into its corresponding bit.

While it does feel a bit overengineered, it would solve the problem that =

we're turning in-KVM handled MSRs into an ABI.

> =

>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>
>> ---
>>
>> As a quick example to show what this does, I implemented handling for MS=
R 0x35
>> (MSR_CORE_THREAD_COUNT) in QEMU on top of this patch set:
>>
>>    https://github.com/agraf/qemu/commits/user-space-msr
>> ---
>>   Documentation/virt/kvm/api.rst  | 60 ++++++++++++++++++++++++++++++
>>   arch/x86/include/asm/kvm_host.h |  6 +++
>>   arch/x86/kvm/emulate.c          | 18 +++++++--
>>   arch/x86/kvm/x86.c              | 65 ++++++++++++++++++++++++++++++++-
>>   include/trace/events/kvm.h      |  2 +-
>>   include/uapi/linux/kvm.h        | 11 ++++++
>>   6 files changed, 155 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api=
.rst
>> index 320788f81a05..7dfcc8e09dad 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5155,6 +5155,34 @@ Note that KVM does not skip the faulting instruct=
ion as it does for
>>   KVM_EXIT_MMIO, but userspace has to emulate any change to the processi=
ng state
>>   if it decides to decode and emulate the instruction.
>>
>> +::
>> +
>> +             /* KVM_EXIT_RDMSR / KVM_EXIT_WRMSR */
>> +             struct {
>> +                     __u8 reply;
>> +                     __u8 error;
>> +                     __u8 pad[2];
>> +                     __u32 index;
>> +                     __u64 data;
>> +             } msr;
> =

> (Personal taste most likely)
> =

> This layout is perfect but it makes my brain explode :-) Naturally, I
> expect index and data to be the most significant members and I expect
> them to be the first two members, something like
> =

>                  struct {
>                          __u32 index;
>                          __u32 pad32;
>                          __u64 data;
>                          __u8 reply;
>                          __u8 error;
>                          __u8 pad8[6];
>                  } msr;

The layout I chose mimics the io one and does feel pretty natural to me =

(flags first, index next, data last). Let's shrug it off as taste? :)

> =

>> +
>> +Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR =
is
>> +enabled, MSR accesses to registers that are not known by KVM kernel cod=
e will
>> +trigger a KVM_EXIT_RDMSR exit for reads and KVM_EXIT_WRMSR exit for wri=
tes.
>> +
>> +For KVM_EXIT_RDMSR, the "index" field tells user space which MSR the gu=
est
>> +wants to read. To respond to this request with a successful read, user =
space
>> +writes a 1 into the "reply" field and the respective data into the "dat=
a" field.
>> +
>> +If the RDMSR request was unsuccessful, user space indicates that with a=
 "1"
>> +in the "reply" field and a "1" in the "error" field. This will inject a=
 #GP
>> +into the guest when the VCPU is executed again.
>> +
>> +For KVM_EXIT_WRMSR, the "index" field tells user space which MSR the gu=
est
>> +wants to write. Once finished processing the event, user space sets the=
 "reply"
>> +field to "1". If the MSR write was unsuccessful, user space also sets t=
he
>> +"error" field to "1".
>> +
>>   ::
>>
>>                /* Fix the size of the union. */
>> @@ -5844,6 +5872,27 @@ controlled by the kvm module parameter halt_poll_=
ns. This capability allows
>>   the maximum halt time to specified on a per-VM basis, effectively over=
riding
>>   the module parameter for the target VM.
>>
>> +7.21 KVM_CAP_X86_USER_SPACE_MSR
>> +----------------------
>> +
>> +:Architectures: x86
>> +:Target: VM
>> +:Parameters: args[0] is 1 if user space MSR handling is enabled, 0 othe=
rwise
>> +:Returns: 0 on success; -1 on error
>> +
>> +This capability enabled trapping of unhandled RDMSR and WRMSR instructi=
ons
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
>> +this capability. With it enabled, MSR accesses that are not handled by =
KVM
>> +will trigger KVM_EXIT_RDMSR and KVM_EXIT_WRMSR exit notifications which
>> +user space can then handle to implement model specific MSR handling and=
/or
>> +user notifications to inform a user that an MSR was not handled.
>> +
>>   8. Other capabilities.
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> @@ -6151,3 +6200,14 @@ KVM can therefore start protected VMs.
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
>> +accesses that are not handled by KVM and would thus usually trigger a
>> +#GP into the guest will instead get bounced to user space through the
>> +KVM_EXIT_RDMSR and KVM_EXIT_WRMSR exit notifications.
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index be5363b21540..c4218e05d8b8 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1002,6 +1002,9 @@ struct kvm_arch {
>>        bool guest_can_read_msr_platform_info;
>>        bool exception_payload_enabled;
>>
>> +     /* Deflect RDMSR and WRMSR to user space if not handled in kernel =
*/
>> +     bool user_space_msr_enabled;
>> +
>>        struct kvm_pmu_event_filter *pmu_event_filter;
>>        struct task_struct *nx_lpage_recovery_thread;
>>   };
>> @@ -1437,6 +1440,9 @@ int kvm_emulate_instruction(struct kvm_vcpu *vcpu,=
 int emulation_type);
>>   int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>>                                        void *insn, int insn_len);
>>
>> +/* Indicate that an MSR operation should be handled by user space */
>> +#define ETRAP_TO_USER_SPACE EREMOTE
> =

> What if we just use ENOENT in
> kvm_set_msr_user_space()/kvm_get_msr_user_space()? Or, maybe, we can
> just notice that KVM_EXIT_RDMSR/KVM_EXIT_WRMSR was set, this way we
> don't need a specific exit code.

Yeah, ENOENT is definitely a better option.

Checking for the exit_reason in the rdmsr/wrmsr code paths is tricky, as =

we don't provide any guarantees over the value of vcpu->run->exit_reason =

unless we are in the user space return path. So if you trap to user =

space for one MSR, handle that, continue and the next MSR access is an =

in-kvm handled one that triggers a #GP, we have no way to differentiate =

whether the exit_reason is just stale from the previous run.

We could avoid that by setting exit_reason to unknown on every vcpu_run, =

but it really only creates yet another magical API. Explicitly saying =

"go back to user space" from {g,s}et_msr() is much more explicit and =

readable IMHO.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



