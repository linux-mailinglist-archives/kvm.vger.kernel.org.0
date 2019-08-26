Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7CE9D8CB
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 00:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfHZWE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 18:04:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfHZWEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 18:04:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QM3WEO004753;
        Mon, 26 Aug 2019 22:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=XhoIgLGOsYLkTqUYGuMgrm277L25+BrpH1lZ1EdT1Ls=;
 b=CL0vw2JUXVeAM7xh6gkp8gs6GY7ygm85gWGDJTruUHlZVhifHbCxlzQdY8VBctTrq+Oy
 aWtMYmibb0Ie3oAAO8gwRZMzjdX6dpzJXfX75vO14LMb1oLKKZ290eV9/qAJ8f6WCXr0
 qnEpmnzMLQnq5ITsRvvX8ZIPjblSqhMPrCOhfES3ZjY6p3YFwI5GzBSF2eH2o7gpL1yb
 XgLdcPbVRe1DOrihprcfLd7CELTDL4WpA1WmQVQz+JPMeuECu5LFtV/ZOvg8Olw43oKl
 UeZI3Rmms7OwdF/eB6pToCyVeGNQdiFvUygWBv1ZpMssLitHEk0UQI2e008hpVKTbXa6 TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t86p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 22:04:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QM3kFS129372;
        Mon, 26 Aug 2019 22:04:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tms5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 22:04:05 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QM44GJ018463;
        Mon, 26 Aug 2019 22:04:05 GMT
Received: from [192.168.14.112] (/79.180.242.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 15:04:04 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eTDtZo73fCBF+ygPmT2ZmDr5-uSfZrtQSveWQBfMNPnEg@mail.gmail.com>
Date:   Tue, 27 Aug 2019 01:04:00 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Marc Orr <marcorr@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F8517F7A-7F66-4E4A-B4C2-9FB4B628F945@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <CALMp9eTDtZo73fCBF+ygPmT2ZmDr5-uSfZrtQSveWQBfMNPnEg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260205
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260205
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Aug 2019, at 0:17, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Mon, Aug 26, 2019 at 3:25 AM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>> Commit cd7764fe9f73 ("KVM: x86: latch INITs while in system =
management mode")
>> changed code to latch INIT while vCPU is in SMM and process latched =
INIT
>> when leaving SMM. It left a subtle remark in commit message that =
similar
>> treatment should also be done while vCPU is in VMX non-root-mode.
>>=20
>> However, INIT signals should actually be latched in various vCPU =
states:
>> (*) For both Intel and AMD, INIT signals should be latched while vCPU
>> is in SMM.
>> (*) For Intel, INIT should also be latched while vCPU is in VMX
>> operation and later processed when vCPU leaves VMX operation by
>> executing VMXOFF.
>> (*) For AMD, INIT should also be latched while vCPU runs with GIF=3D0
>> or in guest-mode with intercept defined on INIT signal.
>>=20
>> To fix this:
>> 1) Add kvm_x86_ops->apic_init_signal_blocked() such that each CPU =
vendor
>> can define the various CPU states in which INIT signals should be
>> blocked and modify kvm_apic_accept_events() to use it.
>> 2) Modify vmx_check_nested_events() to check for pending INIT signal
>> while vCPU in guest-mode. If so, emualte vmexit on
>> EXIT_REASON_INIT_SIGNAL. Note that nSVM should have similar behaviour
>> but is currently left as a TODO comment to implement in the future
>> because nSVM don't yet implement svm_check_nested_events().
>>=20
>> Note: Currently KVM nVMX implementation don't support VMX =
wait-for-SIPI
>> activity state as specified in MSR_IA32_VMX_MISC bits 6:8 exposed to
>> guest (See nested_vmx_setup_ctls_msrs()).
>> If and when support for this activity state will be implemented,
>> kvm_check_nested_events() would need to avoid emulating vmexit on
>> INIT signal in case activity-state is wait-for-SIPI. In addition,
>> kvm_apic_accept_events() would need to be modified to avoid =
discarding
>> SIPI in case VMX activity-state is wait-for-SIPI but instead delay
>> SIPI processing to vmx_check_nested_events() that would clear
>> pending APIC events and emulate vmexit on SIPI.
>>=20
>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>> Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>=20
> Thanks for doing this! I asked Marc to take a look at it earlier this
> month, but he's been swamped.

No problem. BTW Nikita is also preparing a patch on top of this to =
support wait-for-SIPI activity-state.
In case that was in your TODO list as-well.

>=20
>> ---
>> arch/x86/include/asm/kvm_host.h |  2 ++
>> arch/x86/kvm/lapic.c            | 11 +++++++----
>> arch/x86/kvm/svm.c              | 20 ++++++++++++++++++++
>> arch/x86/kvm/vmx/nested.c       | 14 ++++++++++++++
>> arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>> 5 files changed, 49 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
>> index 74e88e5edd9c..158483538181 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1209,6 +1209,8 @@ struct kvm_x86_ops {
>>        uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>>=20
>>        bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
>> +
>> +       bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>> };
>>=20
>> struct kvm_arch_async_pf {
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 685d17c11461..9620fe5ce8d1 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2702,11 +2702,14 @@ void kvm_apic_accept_events(struct kvm_vcpu =
*vcpu)
>>                return;
>>=20
>>        /*
>> -        * INITs are latched while in SMM.  Because an SMM CPU cannot
>> -        * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
>> -        * and delay processing of INIT until the next RSM.
>> +        * INITs are latched while CPU is in specific states.
>> +        * Because a CPU cannot be in these states immediately
>> +        * after it have processed an INIT signal (and thus in
>> +        * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
>> +        * and delay processing of INIT until CPU leaves
>> +        * the state which latch INIT signal.
>>         */
>> -       if (is_smm(vcpu)) {
>> +       if (kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
>>                WARN_ON_ONCE(vcpu->arch.mp_state =3D=3D =
KVM_MP_STATE_INIT_RECEIVED);
>>                if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
>>                        clear_bit(KVM_APIC_SIPI, =
&apic->pending_events);
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 6462c386015d..0e43acf7bea4 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -7205,6 +7205,24 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>>        return false;
>> }
>>=20
>> +static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>> +{
>> +       struct vcpu_svm *svm =3D to_svm(vcpu);
>> +
>> +       /*
>> +        * TODO: Last condition latch INIT signals on vCPU when
>> +        * vCPU is in guest-mode and vmcb12 defines intercept on =
INIT.
>> +        * To properly emulate INIT intercept, SVM should also =
implement
>> +        * kvm_x86_ops->check_nested_events() and process pending =
INIT
>> +        * signal to cause nested_svm_vmexit(). As SVM currently =
don't
>> +        * implement check_nested_events(), this work is delayed
>> +        * for future improvement.
>> +        */
>> +       return is_smm(vcpu) ||
>> +                  !gif_set(svm) ||
>> +                  (svm->vmcb->control.intercept & (1ULL << =
INTERCEPT_INIT));
>> +}
>> +
>> static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
>>        .cpu_has_kvm_support =3D has_svm,
>>        .disabled_by_bios =3D is_disabled,
>> @@ -7341,6 +7359,8 @@ static struct kvm_x86_ops svm_x86_ops =
__ro_after_init =3D {
>>        .nested_get_evmcs_version =3D nested_get_evmcs_version,
>>=20
>>        .need_emulation_on_page_fault =3D =
svm_need_emulation_on_page_fault,
>> +
>> +       .apic_init_signal_blocked =3D svm_apic_init_signal_blocked,
>> };
>>=20
>> static int __init svm_init(void)
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ced9fba32598..d655fcd04c01 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -3401,6 +3401,15 @@ static int vmx_check_nested_events(struct =
kvm_vcpu *vcpu, bool external_intr)
>>        unsigned long exit_qual;
>>        bool block_nested_events =3D
>>            vmx->nested.nested_run_pending || =
kvm_event_needs_reinjection(vcpu);
>> +       struct kvm_lapic *apic =3D vcpu->arch.apic;
>> +
>> +       if (lapic_in_kernel(vcpu) &&
>> +               test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>> +               if (block_nested_events)
>> +                       return -EBUSY;
>> +               nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, =
0);
>> +               return 0;
>> +       }
>=20
> Suppose that L0 just finished emulating an L2 instruction with
> EFLAGS.TF set. So, we've just queued up a #DB trap in
> vcpu->arch.exception. On this emulated VM-exit from L2 to L1, the
> guest pending debug exceptions field in the vmcs12 should get the
> value of vcpu->arch.exception.payload, and the queued #DB should be
> squashed.

If I understand correctly you are discussing a case where L2 exited to =
L0 for
emulating some instruction when L2=E2=80=99s RFLAGS.TF is set. =
Therefore, after x86
emulator finished emulating L2 instruction, it queued a #DB exception.

Then before resuming L2 guest, some other vCPU send an INIT signal
to this vCPU. When L0 will reach vmx_check_nested_events() it will
see pending INIT signal and exit on EXIT_REASON_INIT_SIGNAL
but nested_vmx_vmexit() will basically drop pending #DB exception
in prepare_vmcs12() when it calls kvm_clear_exception_queue()
because vmcs12_save_pending_event() only saves injected exceptions.
(As changed by myself a long time ago)

I think you are right this is a bug.
I also think it could trivially be fixed by just making sure =
vmx_check_nested_events()
first evaluates pending exceptions and only then pending apic events.
However, we also want to make sure to request an =E2=80=9Cimmediate-exit=E2=
=80=9D in case
eval of pending exception require emulation of an exit from L2 to L1.

I will add this scenario to my kvm-unit-tests that I=E2=80=99m about to =
submit.

Thanks,
-Liran

>=20
>>        if (vcpu->arch.exception.pending &&
>>                nested_vmx_check_exception(vcpu, &exit_qual)) {
>> @@ -4466,7 +4475,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
>> {
>>        if (!nested_vmx_check_permission(vcpu))
>>                return 1;
>> +
>>        free_nested(vcpu);
>> +
>> +       /* Process a latched INIT during time CPU was in VMX =
operation */
>> +       kvm_make_request(KVM_REQ_EVENT, vcpu);
>> +
>>        return nested_vmx_succeed(vcpu);
>> }
>>=20
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b5b5b2e5dac5..5a1aa0640f2a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7479,6 +7479,11 @@ static bool =
vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>>        return false;
>> }
>>=20
>> +static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>> +{
>> +       return is_smm(vcpu) || to_vmx(vcpu)->nested.vmxon;
>> +}
>> +
>> static __init int hardware_setup(void)
>> {
>>        unsigned long host_bndcfgs;
>> @@ -7803,6 +7808,7 @@ static struct kvm_x86_ops vmx_x86_ops =
__ro_after_init =3D {
>>        .get_vmcs12_pages =3D NULL,
>>        .nested_enable_evmcs =3D NULL,
>>        .need_emulation_on_page_fault =3D =
vmx_need_emulation_on_page_fault,
>> +       .apic_init_signal_blocked =3D vmx_apic_init_signal_blocked,
>> };
>>=20
>> static void vmx_cleanup_l1d_flush(void)
>> --
>> 2.20.1
>>=20

