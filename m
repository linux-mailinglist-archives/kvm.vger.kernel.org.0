Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428BBB01DA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbfIKQmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:42:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbfIKQmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:42:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8BGd566141126;
        Wed, 11 Sep 2019 16:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Ytv3HM0UuqPmk1T50ByaaO0uZWIycidEklTQAsV36C4=;
 b=AvzJEfmNCiesG6usjVNtOPOOxVuTAhOILViW92T3A+V1V7rM0UBA8FFTo5RmQ/vYwCix
 KW+uAPZcWSx6m1434odFjEeKkERoLU4AvKjIzntbtNzOTrJIV8iBYmEAh0v4lXjYVfN0
 qtIZzaskyyB+vfIHQwkypCpTWM3rEweTEDsNHg6vYPmc09AM/vGp6d0p38yUTuo0bYGB
 RfKCPaQ7FYISlES3Z0I8OUjCKjIPuvD8pqwE3lP3J3AW7/5quIu/IIE7sCe35MEh07gZ
 j0vNmKMbangBA0Kr4oiXzPqFtw+NovF5hU21ovQ3WNzcR3GTiA/lIVczbn05JDwYQOoV gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uw1m93ec5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 16:42:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8BGcx9x078319;
        Wed, 11 Sep 2019 16:42:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uxj890148-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 16:42:12 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8BGgCRd032640;
        Wed, 11 Sep 2019 16:42:12 GMT
Received: from [192.168.14.112] (/109.66.230.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Sep 2019 09:42:12 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <2a36ca45-56fa-5d4e-7b8c-157190f29f82@redhat.com>
Date:   Wed, 11 Sep 2019 19:42:08 +0300
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5253F0DE-D2E3-4475-9B02-092B7A44D776@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <2a36ca45-56fa-5d4e-7b8c-157190f29f82@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9377 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9377 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Sep 2019, at 19:23, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 26/08/19 12:24, Liran Alon wrote:
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
> I'd prefer keeping is_smm(vcpu) here, since that is not =
vendor-specific.
>=20
> Together with some edits to the comments, this is what I got.
> Let me know if you prefer to have the latched_init changes
> on top, or you'd like to post v2 with everything.
>=20
> Thanks,
>=20
> Paolo

The code change below seems good to me.
(The only thing you changed is moving is_smm(vcpu) to the non-vendor =
specific part and rephrased comments right?)

I plan to submit a patch for the latched_init changes soon. (And =
respective kvm-unit-test which I already have ready and working).
We also have another small patch on top to add support for wait-for-SIPI =
activity-state which I will submit soon as-well.
So I=E2=80=99m fine with either option of you first applying this change =
and then I submit another patch on top,
or me just submitting a new v2 patch series with a new version for this =
patch and the rest of the changes.
I don=E2=80=99t have strong preference. Whatever you prefer is fine by =
me. :)

-Liran

>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index c4f271a9b306..b523949a8df8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1209,6 +1209,8 @@ struct kvm_x86_ops {
> 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>=20
> 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +
> +	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> };
>=20
> struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 559e1c4c0832..dbbe4781fbb2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2706,11 +2706,14 @@ void kvm_apic_accept_events(struct kvm_vcpu =
*vcpu)
> 		return;
>=20
> 	/*
> -	 * INITs are latched while in SMM.  Because an SMM CPU cannot
> -	 * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
> -	 * and delay processing of INIT until the next RSM.
> +	 * INITs are latched while CPU is in specific states
> +	 * (SMM, VMX non-root mode, SVM with GIF=3D0).
> +	 * Because a CPU cannot be in these states immediately
> +	 * after it has processed an INIT signal (and thus in
> +	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
> +	 * and leave the INIT pending.
> 	 */
> -	if (is_smm(vcpu)) {
> +	if (is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu)) =
{
> 		WARN_ON_ONCE(vcpu->arch.mp_state =3D=3D =
KVM_MP_STATE_INIT_RECEIVED);
> 		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
> 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2854aafc489e..d24050b647c7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7170,6 +7170,21 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> 	return false;
> }
>=20
> +static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm =3D to_svm(vcpu);
> +
> +	/*
> +	 * TODO: Last condition latch INIT signals on vCPU when
> +	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
> +	 * To properly emulate the INIT intercept, SVM should implement
> +	 * kvm_x86_ops->check_nested_events() and call =
nested_svm_vmexit()
> +	 * there if an INIT signal is pending.
> +	 */
> +	return !gif_set(svm) ||
> +		   (svm->vmcb->control.intercept & (1ULL << =
INTERCEPT_INIT));
> +}
> +
> static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
> 	.cpu_has_kvm_support =3D has_svm,
> 	.disabled_by_bios =3D is_disabled,
> @@ -7306,6 +7321,8 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> 	.nested_get_evmcs_version =3D nested_get_evmcs_version,
>=20
> 	.need_emulation_on_page_fault =3D =
svm_need_emulation_on_page_fault,
> +
> +	.apic_init_signal_blocked =3D svm_apic_init_signal_blocked,
> };
>=20
> static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ad2453317c4b..6ce83c602e7f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3409,6 +3409,15 @@ static int vmx_check_nested_events(struct =
kvm_vcpu *vcpu, bool external_intr)
> 	unsigned long exit_qual;
> 	bool block_nested_events =3D
> 	    vmx->nested.nested_run_pending || =
kvm_event_needs_reinjection(vcpu);
> +	struct kvm_lapic *apic =3D vcpu->arch.apic;
> +
> +	if (lapic_in_kernel(vcpu) &&
> +		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> +		if (block_nested_events)
> +			return -EBUSY;
> +		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +		return 0;
> +	}
>=20
> 	if (vcpu->arch.exception.pending &&
> 		nested_vmx_check_exception(vcpu, &exit_qual)) {
> @@ -4470,7 +4479,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
> {
> 	if (!nested_vmx_check_permission(vcpu))
> 		return 1;
> +
> 	free_nested(vcpu);
> +
> +	/* Process a latched INIT during time CPU was in VMX operation =
*/
> +	kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
> 	return nested_vmx_succeed(vcpu);
> }
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 99f52f8c969a..73bf9a2e6fb6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7470,6 +7470,11 @@ static bool =
vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> 	return false;
> }
>=20
> +static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	return to_vmx(vcpu)->nested.vmxon;
> +}
> +
> static __init int hardware_setup(void)
> {
> 	unsigned long host_bndcfgs;
> @@ -7794,6 +7799,7 @@ static __exit void hardware_unsetup(void)
> 	.get_vmcs12_pages =3D NULL,
> 	.nested_enable_evmcs =3D NULL,
> 	.need_emulation_on_page_fault =3D =
vmx_need_emulation_on_page_fault,
> +	.apic_init_signal_blocked =3D vmx_apic_init_signal_blocked,
> };
>=20
> static void vmx_cleanup_l1d_flush(void)

