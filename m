Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC11023FE
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKSMND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:13:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbfKSMND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 07:13:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJC8uKE042522;
        Tue, 19 Nov 2019 12:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=6VslcxNNBVO0SmhupZgqcfLd/Yue4nN9ld+yM7qCaJg=;
 b=a4lj3B5MlEIZ3WvDdRd/G65w3Pq1mYhD2rhMmGsweycbvUuYP3lrl/nR1S1h74sK4quP
 YUVcW1dE2MSw5/qOMMvwSpFVtvOC8mNnwZq4TBBendaEQ/nBFGpwBedRnxJC8tS7taPf
 tIWASL2ilwHFqPnAnMqlA91HdqjRdc1R4TelGbsSQx3bipK2Ynue8YGu+hK1fMV6ywRQ
 n17egAQ9SCjY46niu+lj2eTgUbMaqTjoUlLkdLN5bcc4NIxN5TbsfrsfgOklxiSTSmvM
 vLMiP6KCZv9OfiCC7SM+vcjdMRT6XCroC+sZCFV2u1daN9O7N930FyoQ6EikuElxbyZx TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqeccr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:11:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJC95Wb110095;
        Tue, 19 Nov 2019 12:11:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wc0aga2sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:11:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJCBkiw016202;
        Tue, 19 Nov 2019 12:11:47 GMT
Received: from [192.168.14.112] (/79.181.226.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 04:11:46 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 19 Nov 2019 14:11:41 +0200
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <09CD3BD3-1F5E-48DA-82ED-58E3196DBD83@oracle.com>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Nov 2019, at 8:36, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> From: Wanpeng Li <wanpengli@tencent.com>
>=20
> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in=20
> our product observation, multicast IPIs are not as common as unicast=20=

> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>=20
> This patch tries to optimize x2apic physical destination mode, fixed=20=

> delivery mode single target IPI by delivering IPI to receiver as soon=20=

> as possible after sender writes ICR vmexit to avoid various checks=20
> when possible, especially when running guest w/ --overcommit cpu-pm=3Don=

> or guest can keep running, IPI can be injected to target vCPU by=20
> posted-interrupt immediately.
>=20
> Testing on Xeon Skylake server:
>=20
> The virtual IPI latency from sender send to receiver receive reduces=20=

> more than 200+ cpu cycles.
>=20
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
> * add tracepoint
> * Instead of a separate vcpu->fast_vmexit, set exit_reason
>   to vmx->exit_reason to -1 if the fast path succeeds.
> * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
> * moving the handling into vmx_handle_exit_irqoff()
>=20
> arch/x86/include/asm/kvm_host.h |  4 ++--
> arch/x86/include/uapi/asm/vmx.h |  1 +
> arch/x86/kvm/svm.c              |  4 ++--
> arch/x86/kvm/vmx/vmx.c          | 40 =
+++++++++++++++++++++++++++++++++++++---
> arch/x86/kvm/x86.c              |  5 +++--
> 5 files changed, 45 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index 898ab9e..0daafa9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
> 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>=20
> 	void (*run)(struct kvm_vcpu *vcpu);
> -	int (*handle_exit)(struct kvm_vcpu *vcpu);
> +	int (*handle_exit)(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason);
> 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> @@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
> 	int (*check_intercept)(struct kvm_vcpu *vcpu,
> 			       struct x86_instruction_info *info,
> 			       enum x86_intercept_stage stage);
> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason);
> 	bool (*mpx_supported)(void);
> 	bool (*xsaves_supported)(void);
> 	bool (*umip_emulated)(void);
> diff --git a/arch/x86/include/uapi/asm/vmx.h =
b/arch/x86/include/uapi/asm/vmx.h
> index 3eb8411..b33c6e1 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -88,6 +88,7 @@
> #define EXIT_REASON_XRSTORS             64
> #define EXIT_REASON_UMWAIT              67
> #define EXIT_REASON_TPAUSE              68
> +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
>=20
> #define VMX_EXIT_REASONS \
> 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d02a73a..c8e063a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4929,7 +4929,7 @@ static void svm_get_exit_info(struct kvm_vcpu =
*vcpu, u64 *info1, u64 *info2)
> 	*info2 =3D control->exit_info_2;
> }
>=20
> -static int handle_exit(struct kvm_vcpu *vcpu)
> +static int handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
> {
> 	struct vcpu_svm *svm =3D to_svm(vcpu);
> 	struct kvm_run *kvm_run =3D vcpu->run;
> @@ -6187,7 +6187,7 @@ static int svm_check_intercept(struct kvm_vcpu =
*vcpu,
> 	return ret;
> }
>=20
> -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason)
> {
>=20
> }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 621142e5..b98198d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5792,7 +5792,7 @@ void dump_vmcs(void)
>  * The guest has exited.  See if we can fix it or if we need userspace
>  * assistance.
>  */
> -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> +static int vmx_handle_exit(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason)

vmx_handle_exit() should get second parameter by value and not by =
pointer. As it doesn=E2=80=99t need to modify it.

I would also rename parameter to =E2=80=9Caccel_exit_completion=E2=80=9D =
to indicate this is additional work that needs to happen to complete =
accelerated-exit handling.
This parameter should be an enum that currently only have 2 values: =
ACCEL_EXIT_NONE and ACCEL_EXIT_SKIP_EMUL_INS.

> {
> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> 	u32 exit_reason =3D vmx->exit_reason;
> @@ -5878,7 +5878,10 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		}
> 	}
>=20
> -	if (exit_reason < kvm_vmx_max_exit_handlers
> +	if (*vcpu_exit_reason =3D=3D =
EXIT_REASON_NEED_SKIP_EMULATED_INSN) {
> +		kvm_skip_emulated_instruction(vcpu);
> +		return 1;
> +	} else if (exit_reason < kvm_vmx_max_exit_handlers
> 	    && kvm_vmx_exit_handlers[exit_reason]) {
> #ifdef CONFIG_RETPOLINE
> 		if (exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> @@ -6223,7 +6226,36 @@ static void =
handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> }
> STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>=20
> -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static u32 handle_ipi_fastpath(struct kvm_vcpu *vcpu)
> +{
> +	u32 index;
> +	u64 data;
> +	int ret =3D 0;
> +
> +	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) =
{
> +		/*
> +		 * fastpath to IPI target, FIXED+PHYSICAL which is =
popular
> +		 */
> +		index =3D kvm_rcx_read(vcpu);
> +		data =3D kvm_read_edx_eax(vcpu);
> +
> +		if (((index - APIC_BASE_MSR) << 4 =3D=3D APIC_ICR) &&
> +			((data & KVM_APIC_DEST_MASK) =3D=3D =
APIC_DEST_PHYSICAL) &&
> +			((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) =
{
> +
> +			trace_kvm_msr_write(index, data);

On a standard EXIT_REASON_MSR_WRITE VMExit, this trace will be printed =
only after LAPIC emulation logic happens.
You should preserve same ordering.

> +			kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, =
(u32)(data >> 32));
> +			ret =3D kvm_lapic_reg_write(vcpu->arch.apic, =
APIC_ICR, (u32)data);
> +
> +			if (ret =3D=3D 0)
> +				return =
EXIT_REASON_NEED_SKIP_EMULATED_INSN;
> +		}
> +	}
> +
> +	return ret;
> +}

Maybe it would be more elegant to modify this function as follows?

static int handle_accel_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u32 =
msr, u64 data)
{
    if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) &&
        ((data & KVM_APIC_DEST_MASK) =3D=3D APIC_DEST_PHYSICAL) &&
        ((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) {

        kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> =
32));
        return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, =
(u32)data);
    }

    return 1;
}

static enum accel_exit_completion handle_accel_set_msr_irqoff(struct =
kvm_vcpu *vcpu)
{
    u32 msr =3D kvm_rcx_read(vcpu);
    u64 data =3D kvm_read_edx_eax(vcpu);
    int ret =3D 0;

    switch (msr) {
    case APIC_BASE_MSR + (APIC_ICR >> 4):
        ret =3D handle_accel_set_x2apic_icr_irqoff(vcpu, msr, data);
        break;
    default:
        return ACCEL_EXIT_NONE;
    }

    if (!ret) {
        trace_kvm_msr_write(msr, data);
        return ACCEL_EXIT_SKIP_EMUL_INS;
    }

    return ACCEL_EXIT_NONE;
}

> +
> +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 =
*exit_reason)
> {
> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>=20
> @@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct =
kvm_vcpu *vcpu)
> 		handle_external_interrupt_irqoff(vcpu);
> 	else if (vmx->exit_reason =3D=3D EXIT_REASON_EXCEPTION_NMI)
> 		handle_exception_nmi_irqoff(vmx);
> +	else if (vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> +		*exit_reason =3D handle_ipi_fastpath(vcpu);

1) This case requires a comment as the only reason it is called here is =
an optimisation.
In contrast to the other cases which must be called before interrupts =
are enabled on the host.

2) I would rename handler to handle_accel_set_msr_irqoff().
To signal this handler runs with host interrupts disabled and to make it =
a general place for accelerating WRMSRs in case we would require more in =
the future.

-Liran

> }
>=20
> static bool vmx_has_emulated_msr(int index)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 991dd01..a53bce3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7981,6 +7981,7 @@ EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
> static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> {
> 	int r;
> +	u32 exit_reason =3D 0;
> 	bool req_int_win =3D
> 		dm_request_for_irq_injection(vcpu) &&
> 		kvm_cpu_accept_dm_intr(vcpu);
> @@ -8226,7 +8227,7 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
> 	vcpu->mode =3D OUTSIDE_GUEST_MODE;
> 	smp_wmb();
>=20
> -	kvm_x86_ops->handle_exit_irqoff(vcpu);
> +	kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_reason);
>=20
> 	/*
> 	 * Consume any pending interrupts, including the possible source =
of
> @@ -8270,7 +8271,7 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
> 		kvm_lapic_sync_from_vapic(vcpu);
>=20
> 	vcpu->arch.gpa_available =3D false;
> -	r =3D kvm_x86_ops->handle_exit(vcpu);
> +	r =3D kvm_x86_ops->handle_exit(vcpu, &exit_reason);
> 	return r;
>=20
> cancel_injection:
> --=20
> 2.7.4
>=20

