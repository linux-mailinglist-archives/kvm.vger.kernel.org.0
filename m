Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF469D5C8
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 20:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732779AbfHZS04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 14:26:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbfHZS04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 14:26:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIEDhM029016;
        Mon, 26 Aug 2019 18:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=jAy0cGywVAtnlmR3S8hGXjmT9SkDx4KufmMe6S5e/Es=;
 b=DyXZlgCyDbpDfx1hIxLIPtUnFSOulBfvhrurSxMKi5YDhDJiAnrHwJG7u1CRsv2WMnYJ
 9pK7GFm9npxr1GuL0KeWYiR4ugZURYl8GNIPOXRfjcluG+SGIhxHXA8tQO3hA9b+3XKh
 R6SNin8xvDTHpQmUSYyPZOqKVUZqNat+/w0VbdnCPzjwiHMyRO7Ak5+Bw+ZhRFwnoCsm
 Dofw9KQaIrV/j9wFhUymuoPFJO8Kpi9L9mIhpZEOVESDR10zUJLUF/ZrcQRNKmRAb4oz
 jiDrLhjvSVcX2zjxZyoGldkUaO2PGkgbzLHUIOhQXYMDIIOysjErOAuNL4MqZv0fJeh7 PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ujwvqb554-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 18:26:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIE6Tu019963;
        Mon, 26 Aug 2019 18:26:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu7qmyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 18:26:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QIQUCC012108;
        Mon, 26 Aug 2019 18:26:30 GMT
Received: from [192.168.14.112] (/79.180.242.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 11:26:29 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190826160301.GC19381@linux.intel.com>
Date:   Mon, 26 Aug 2019 21:26:25 +0300
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, vkuznets@redhat.com,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <221B019B-D38D-401E-9C6B-17D512B61345@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <20190826160301.GC19381@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 26 Aug 2019, at 19:03, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, Aug 26, 2019 at 01:24:49PM +0300, Liran Alon wrote:
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
>=20
> I think there's a {get,set}_nested_state() component missing, e.g. the =
SMM
> case exposes and consumes a pending INIT via events->smi.latched_init.
> Similar functionality is needed to preserve a pending INIT for =
post-VMXON
> across migration.

Good catch. I have missed this.

It seems that kvm_vcpu_ioctl_x86_get_vcpu_events() sets =
events->smi.latched_init
just based on KVM_APIC_INIT being set in LAPIC pending events.
Therefore, in case INIT is latched outside of SMM (e.g. By vCPU being in =
VMX operation),
it should also record it in this variable.
However, kvm_vcpu_ioctl_x86_set_vcpu_events() seems to only treat this
flag in case vCPU is in SMM (As indicated by events->smi.smm).

I would actually like to add a new field (that deprecates this =
events->smi.latched_init)
of events->pending_lapic_events that holds pending LAPIC events.
Regardless of specific CPU state we are at. I would need to use
one of the reserved fields in struct kvm_vcpu_events and introduce
a new KVM_VCPUEVENT_VALID_APIC_EVENTS flags to indicate
this field is specified by userspace.
I will define that when this field is specified, the =
events->smi.latched_init is ignored.

An alternative could be to just add a flag to events->flags that =
modifies
behaviour to treat events->smi.latched_init as just =
events->latched_init.
But I prefer the previous option.

I don=E2=80=99t want to introduce a new flag for "pending INIT during =
VMX operation" as
there are various vendor-specific CPU states that latch INIT (As handled =
by this commit=E2=80=A6).

Do you agree?

>=20
>> (*) For AMD, INIT should also be latched while vCPU runs with GIF=3D0
>> or in guest-mode with intercept defined on INIT signal.
>>=20
>> To fix this:
>> 1) Add kvm_x86_ops->apic_init_signal_blocked() such that each CPU =
vendor
>> can define the various CPU states in which INIT signals should be
>> blocked and modify kvm_apic_accept_events() to use it.
>=20
> kvm_arch_vcpu_ioctl_set_mpstate() should also use the new helper, e.g.
> userspace shouldn't be able to put the vCPU into =
KVM_MP_STATE_SIPI_RECEIVED
> or KVM_MP_STATE_INIT_RECEIVED if it's post-VMXON.

Good catch. I have missed this as-well.
Will fix in v2.

>=20
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
>> 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>>=20
>> 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
>> +
>> +	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>> };
>>=20
>> struct kvm_arch_async_pf {
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 685d17c11461..9620fe5ce8d1 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2702,11 +2702,14 @@ void kvm_apic_accept_events(struct kvm_vcpu =
*vcpu)
>> 		return;
>>=20
>> 	/*
>> -	 * INITs are latched while in SMM.  Because an SMM CPU cannot
>> -	 * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
>> -	 * and delay processing of INIT until the next RSM.
>> +	 * INITs are latched while CPU is in specific states.
>> +	 * Because a CPU cannot be in these states immediately
>> +	 * after it have processed an INIT signal (and thus in
>> +	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
>> +	 * and delay processing of INIT until CPU leaves
>> +	 * the state which latch INIT signal.
>> 	 */
>> -	if (is_smm(vcpu)) {
>> +	if (kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
>=20
> We may want to keep the SMM+INIT outside of the helper so as to avoid
> splitting the SMI+INIT logic across common x86 and vendor specific =
code.
> E.g. kvm_arch_vcpu_ioctl_set_mpstate() needs to handle the SMI pending
> scenario and kvm_vcpu_ioctl_x86_set_vcpu_events() must prevent putting
> the vCPU into SMM or pending an SMI when the vCPU is already in
> KVM_MP_STATE_INIT_RECEIVED.

I thought it will be nicer to have all conditions for INIT latching =
defined in a single place.
i.e. In the per-vendor callback.

Why does kvm_arch_vcpu_ioctl_set_mpstate() needs to prevent setting =
mpstate
to INIT_RECEIVED/SIPI_RECIEVED in case a SMI is pending?
I would expect it to just prevent to do so in case CPU is in a state =
where INIT is latched.

The commit which introduced this behaviour
28bf28887976 ("KVM: x86: fix user triggerable warning in =
kvm_apic_accept_events()")
Seems to just want to avoid WARN_ON_ONCE() at kvm_apic_accept_events().
Which in order to do so, smi_pending is not relevant.
Same argument goes for kvm_vcpu_ioctl_x86_set_vcpu_events() modified by =
same commit.

Am I missing something?

>=20
>> 		WARN_ON_ONCE(vcpu->arch.mp_state =3D=3D =
KVM_MP_STATE_INIT_RECEIVED);
>> 		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
>> 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 6462c386015d..0e43acf7bea4 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -7205,6 +7205,24 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>> 	return false;
>> }
>>=20
>> +static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm =3D to_svm(vcpu);
>> +
>> +	/*
>> +	 * TODO: Last condition latch INIT signals on vCPU when
>> +	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
>> +	 * To properly emulate INIT intercept, SVM should also implement
>> +	 * kvm_x86_ops->check_nested_events() and process pending INIT
>> +	 * signal to cause nested_svm_vmexit(). As SVM currently don't
>> +	 * implement check_nested_events(), this work is delayed
>> +	 * for future improvement.
>> +	 */
>> +	return is_smm(vcpu) ||
>> +		   !gif_set(svm) ||
>> +		   (svm->vmcb->control.intercept & (1ULL << =
INTERCEPT_INIT));
>> +}
>> +
>> static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
>> 	.cpu_has_kvm_support =3D has_svm,
>> 	.disabled_by_bios =3D is_disabled,
>> @@ -7341,6 +7359,8 @@ static struct kvm_x86_ops svm_x86_ops =
__ro_after_init =3D {
>> 	.nested_get_evmcs_version =3D nested_get_evmcs_version,
>>=20
>> 	.need_emulation_on_page_fault =3D =
svm_need_emulation_on_page_fault,
>> +
>> +	.apic_init_signal_blocked =3D svm_apic_init_signal_blocked,
>> };
>>=20
>> static int __init svm_init(void)
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ced9fba32598..d655fcd04c01 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -3401,6 +3401,15 @@ static int vmx_check_nested_events(struct =
kvm_vcpu *vcpu, bool external_intr)
>> 	unsigned long exit_qual;
>> 	bool block_nested_events =3D
>> 	    vmx->nested.nested_run_pending || =
kvm_event_needs_reinjection(vcpu);
>> +	struct kvm_lapic *apic =3D vcpu->arch.apic;
>> +
>> +	if (lapic_in_kernel(vcpu) &&
>> +		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>=20
> Prefer aligned identation.

Actually I now see that I can just use kvm_lapic_latched_init() instead.
Therefore, will replace to that.

-Liran

>=20
>> +		if (block_nested_events)
>> +			return -EBUSY;
>> +		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
>> +		return 0;
>> +	}
>>=20
>> 	if (vcpu->arch.exception.pending &&
>> 		nested_vmx_check_exception(vcpu, &exit_qual)) {
>> @@ -4466,7 +4475,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
>> {
>> 	if (!nested_vmx_check_permission(vcpu))
>> 		return 1;
>> +
>> 	free_nested(vcpu);
>> +
>> +	/* Process a latched INIT during time CPU was in VMX operation =
*/
>> +	kvm_make_request(KVM_REQ_EVENT, vcpu);
>> +
>> 	return nested_vmx_succeed(vcpu);
>> }
>>=20
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b5b5b2e5dac5..5a1aa0640f2a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7479,6 +7479,11 @@ static bool =
vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>> 	return false;
>> }
>>=20
>> +static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>> +{
>> +	return is_smm(vcpu) || to_vmx(vcpu)->nested.vmxon;
>> +}
>> +
>> static __init int hardware_setup(void)
>> {
>> 	unsigned long host_bndcfgs;
>> @@ -7803,6 +7808,7 @@ static struct kvm_x86_ops vmx_x86_ops =
__ro_after_init =3D {
>> 	.get_vmcs12_pages =3D NULL,
>> 	.nested_enable_evmcs =3D NULL,
>> 	.need_emulation_on_page_fault =3D =
vmx_need_emulation_on_page_fault,
>> +	.apic_init_signal_blocked =3D vmx_apic_init_signal_blocked,
>> };
>>=20
>> static void vmx_cleanup_l1d_flush(void)
>> --=20
>> 2.20.1
>>=20

