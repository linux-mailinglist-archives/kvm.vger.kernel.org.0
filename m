Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70374104723
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 00:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKTX4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 18:56:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTX4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 18:56:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKNsXnA055976;
        Wed, 20 Nov 2019 23:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=nnzORrQ7EdAyNCQXcEXFfBwROupR3wqEvFAWWi9ltJQ=;
 b=Pya7pEMVs7KKn3XI86rGkuanBPZglFkUuHwfIFDaOL9LbMo/Rn5uWlwX8aKIQGdRbmJS
 cFG/SLZ7PX32J5l0GI2+1BoRYJTg5lbryNJrqwSzCuZtSNyFavw2y3Z0N/dsZov6zNxE
 MN21Wv42vKbJR7M7Ze0g8HMjwJ3Xg+snzkoGNOCR+F9GHsR9j9y25krezu2UDKZ03/Sd
 H+u6nj/Ad7rw/OpDxa3Up6XD+5uFhnw8HzdmeguYmjEv+m/Bh1fKT1tatA7VFbLi7wux
 9F7Y9YyRj+qgXD1nfdTKAr1WWMxhj0ZGKC/gIGh80xxwcPQ3x0Qxy3dAxRVG5RKhQ6g7 Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wa92q0t5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 23:55:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKNs580094840;
        Wed, 20 Nov 2019 23:55:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wda04yjur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 23:55:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKNtWUu025176;
        Wed, 20 Nov 2019 23:55:33 GMT
Received: from [192.168.14.112] (/79.176.218.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 15:55:32 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v3 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <61E34902-0743-4DAF-A7DF-94C0E51CDA08@oracle.com>
Date:   Thu, 21 Nov 2019 01:55:27 +0200
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA11DF59-9969-4E1C-AF8A-8102D2D9D8A9@oracle.com>
References: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
 <61E34902-0743-4DAF-A7DF-94C0E51CDA08@oracle.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200201
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 21 Nov 2019, at 1:36, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 20 Nov 2019, at 5:42, Wanpeng Li <kernellwp@gmail.com> wrote:
>>=20
>> From: Wanpeng Li <wanpengli@tencent.com>
>>=20
>> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in=20=

>> our product observation, multicast IPIs are not as common as unicast=20=

>> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>=20
> Have you also had the chance to measure non-Linux workloads. Such as =
Windows?
>=20
>>=20
>> This patch tries to optimize x2apic physical destination mode, fixed=20=

>> delivery mode single target IPI. The fast path is invoked at=20
>> ->handle_exit_irqoff() to emulate only the effect of the ICR write
>> itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
>> flow reduces the latency of virtual IPIs by avoiding the expensive =
bits
>> of transitioning from guest to host, e.g. reacquiring KVM's SRCU =
lock.
>> Especially when running guest w/ KVM_CAP_X86_DISABLE_EXITS capability=20=

>> enabled or guest can keep running, IPI can be injected to target vCPU=20=

>> by posted-interrupt immediately.
>=20
> May I suggest an alternative phrasing? Something such as:
>=20
> =E2=80=9C=E2=80=9D=E2=80=9D
> This patch introduce a mechanism to handle certain =
performance-critical WRMSRs
> in a very early stage of KVM VMExit handler.
>=20
> This mechanism is specifically used for accelerating writes to x2APIC =
ICR that
> attempt to send a virtual IPI with physical destination-mode, fixed =
delivery-mode
> and single target. Which was found as one of the main causes of =
VMExits for
> Linux workloads.
>=20
> The reason this mechanism significantly reduce the latency of such =
virtual IPIs
> is by sending the physical IPI to the target vCPU in a very early =
stage of KVM
> VMExit handler, before host interrupts are enabled and before =
expensive
> operations such as reacquiring KVM=E2=80=99s SRCU lock.
> Latency is reduced even more when KVM is able to use APICv =
posted-interrupt
> mechanism (which allows to deliver the virtual IPI directly to target =
vCPU without
> the need to kick it to host).
> =E2=80=9C=E2=80=9D=E2=80=9D
>=20
>>=20
>> Testing on Xeon Skylake server:
>>=20
>> The virtual IPI latency from sender send to receiver receive reduces=20=

>> more than 200+ cpu cycles.
>>=20
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Liran Alon <liran.alon@oracle.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>=20
> I see you used the code I provided my reply to v2. :)
> I had only some very minor comments inline below. Therefore:
> Reviewed-by: Liran Alon <liran.alon@oracle.com>

Oh there is a small thing pointed by Sean I agree with (and missed in my =
review) before this Reviewed-by can be given.
You should avoid performing accelerated WRMSR handling in case vCPU is =
in guest-mode.
(=46rom obvious reasons as L1 for example could intercept this WRMSR=E2=80=
=A6)

-Liran

>=20
> Thanks for doing this optimisation.
> -Liran
>=20
>> ---
>> v2 -> v3:
>> * for both VMX and SVM
>> * vmx_handle_exit() get second parameter by value and not by pointer
>> * rename parameter to =E2=80=9Caccel_exit_completion=E2=80=9D
>> * preserve tracepoint ordering
>> * rename handler to handle_accel_set_msr_irqoff and more generic
>> * add comments above handle_accel_set_msr_irqoff
>> * msr index APIC_BASE_MSR + (APIC_ICR >> 4)
>> v1 -> v2:
>> * add tracepoint
>> * Instead of a separate vcpu->fast_vmexit, set exit_reason
>> to vmx->exit_reason to -1 if the fast path succeeds.
>> * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
>> * moving the handling into vmx_handle_exit_irqoff()
>>=20
>> arch/x86/include/asm/kvm_host.h | 11 ++++++++--
>> arch/x86/kvm/svm.c              | 14 ++++++++----
>> arch/x86/kvm/vmx/vmx.c          | 13 ++++++++---
>> arch/x86/kvm/x86.c              | 48 =
+++++++++++++++++++++++++++++++++++++++--
>> arch/x86/kvm/x86.h              |  1 +
>> 5 files changed, 76 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
>> index 898ab9e..67c7889 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -175,6 +175,11 @@ enum {
>> 	VCPU_SREG_LDTR,
>> };
>>=20
>> +enum accel_exit_completion {
>> +	ACCEL_EXIT_NONE,
>> +	ACCEL_EXIT_SKIP_EMUL_INS =3D -1,
>=20
> You should remove the =E2=80=9C=3D -1=E2=80=9D.
>=20
>> +};
>> +
>> #include <asm/kvm_emulate.h>
>>=20
>> #define KVM_NR_MEM_OBJS 40
>> @@ -1084,7 +1089,8 @@ struct kvm_x86_ops {
>> 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>>=20
>> 	void (*run)(struct kvm_vcpu *vcpu);
>> -	int (*handle_exit)(struct kvm_vcpu *vcpu);
>> +	int (*handle_exit)(struct kvm_vcpu *vcpu,
>> +		enum accel_exit_completion accel_exit);
>> 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>> 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>> 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>> @@ -1134,7 +1140,8 @@ struct kvm_x86_ops {
>> 	int (*check_intercept)(struct kvm_vcpu *vcpu,
>> 			       struct x86_instruction_info *info,
>> 			       enum x86_intercept_stage stage);
>> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
>> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
>> +		enum accel_exit_completion *accel_exit);
>> 	bool (*mpx_supported)(void);
>> 	bool (*xsaves_supported)(void);
>> 	bool (*umip_emulated)(void);
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index d02a73a..060b11d 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -4929,7 +4929,8 @@ static void svm_get_exit_info(struct kvm_vcpu =
*vcpu, u64 *info1, u64 *info2)
>> 	*info2 =3D control->exit_info_2;
>> }
>>=20
>> -static int handle_exit(struct kvm_vcpu *vcpu)
>> +static int handle_exit(struct kvm_vcpu *vcpu,
>> +	enum accel_exit_completion accel_exit)
>> {
>> 	struct vcpu_svm *svm =3D to_svm(vcpu);
>> 	struct kvm_run *kvm_run =3D vcpu->run;
>> @@ -4987,7 +4988,10 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>> 		       __func__, svm->vmcb->control.exit_int_info,
>> 		       exit_code);
>>=20
>> -	if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
>> +	if (accel_exit =3D=3D ACCEL_EXIT_SKIP_EMUL_INS) {
>> +		kvm_skip_emulated_instruction(vcpu);
>> +		return 1;
>> +	} else if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
>> 	    || !svm_exit_handlers[exit_code]) {
>> 		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", =
exit_code);
>> 		dump_vmcb(vcpu);
>> @@ -6187,9 +6191,11 @@ static int svm_check_intercept(struct kvm_vcpu =
*vcpu,
>> 	return ret;
>> }
>>=20
>> -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>> +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>> +	enum accel_exit_completion *accel_exit)
>> {
>> -
>> +	if (to_svm(vcpu)->vmcb->control.exit_code =3D=3D =
EXIT_REASON_MSR_WRITE)
>> +		*accel_exit =3D handle_accel_set_msr_irqoff(vcpu);
>> }
>>=20
>> static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 621142e5..86c0a23 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5792,7 +5792,8 @@ void dump_vmcs(void)
>> * The guest has exited.  See if we can fix it or if we need userspace
>> * assistance.
>> */
>> -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>> +static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>> +	enum accel_exit_completion accel_exit)
>> {
>> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>> 	u32 exit_reason =3D vmx->exit_reason;
>> @@ -5878,7 +5879,10 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
>> 		}
>> 	}
>>=20
>> -	if (exit_reason < kvm_vmx_max_exit_handlers
>> +	if (accel_exit =3D=3D ACCEL_EXIT_SKIP_EMUL_INS) {
>> +		kvm_skip_emulated_instruction(vcpu);
>> +		return 1;
>> +	} else if (exit_reason < kvm_vmx_max_exit_handlers
>> 	    && kvm_vmx_exit_handlers[exit_reason]) {
>> #ifdef CONFIG_RETPOLINE
>> 		if (exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
>> @@ -6223,7 +6227,8 @@ static void =
handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>> }
>> STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>>=20
>> -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>> +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
>> +	enum accel_exit_completion *accel_exit)
>> {
>> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20
>> @@ -6231,6 +6236,8 @@ static void vmx_handle_exit_irqoff(struct =
kvm_vcpu *vcpu)
>> 		handle_external_interrupt_irqoff(vcpu);
>> 	else if (vmx->exit_reason =3D=3D EXIT_REASON_EXCEPTION_NMI)
>> 		handle_exception_nmi_irqoff(vmx);
>> +	else if (vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
>> +		*accel_exit =3D handle_accel_set_msr_irqoff(vcpu);
>> }
>>=20
>> static bool vmx_has_emulated_msr(int index)
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 991dd01..966c659 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1509,6 +1509,49 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>> }
>> EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>>=20
>> +static int handle_accel_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, =
u64 data)
>> +{
>> +	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) =
&&
>> +		((data & KVM_APIC_DEST_MASK) =3D=3D APIC_DEST_PHYSICAL) =
&&
>> +		((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) {
>> +
>> +		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data =
>> 32));
>> +		return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, =
(u32)data);
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +/*
>> + * The fast path for frequent and performance sensitive wrmsr =
emulation,
>> + * i.e. the sending of IPI, sending IPI early in the VM-Exit flow =
reduces
>> + * the latency of virtual IPI by avoiding the expensive bits of =
transitioning
>> + * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast =
to the
>> + * other cases which must be called after interrupts are enabled on =
the host.
>> + */
>=20
> This comment belongs better on top of =
handle_accel_set_x2apic_icr_irqoff().
> As handle_accel_set_msr_irqoff() is in theory written to maybe use it =
for other MSRs as-well.
>=20
>> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct =
kvm_vcpu *vcpu)
>> +{
>> +	u32 msr =3D kvm_rcx_read(vcpu);
>> +	u64 data =3D kvm_read_edx_eax(vcpu);
>> +	int ret =3D 0;
>> +
>> +	switch (msr) {
>> +	case APIC_BASE_MSR + (APIC_ICR >> 4):
>> +		ret =3D handle_accel_set_x2apic_icr_irqoff(vcpu, data);
>> +		break;
>> +	default:
>> +		return ACCEL_EXIT_NONE;
>> +	}
>> +
>> +	if (!ret) {
>> +		trace_kvm_msr_write(msr, data);
>> +		return ACCEL_EXIT_SKIP_EMUL_INS;
>> +	}
>> +
>> +	return ACCEL_EXIT_NONE;
>> +}
>> +EXPORT_SYMBOL_GPL(handle_accel_set_msr_irqoff);
>> +
>> /*
>> * Adapt set_msr() to msr_io()'s calling convention
>> */
>> @@ -7984,6 +8027,7 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
>> 	bool req_int_win =3D
>> 		dm_request_for_irq_injection(vcpu) &&
>> 		kvm_cpu_accept_dm_intr(vcpu);
>> +	enum accel_exit_completion accel_exit =3D ACCEL_EXIT_NONE;
>>=20
>> 	bool req_immediate_exit =3D false;
>>=20
>> @@ -8226,7 +8270,7 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
>> 	vcpu->mode =3D OUTSIDE_GUEST_MODE;
>> 	smp_wmb();
>>=20
>> -	kvm_x86_ops->handle_exit_irqoff(vcpu);
>> +	kvm_x86_ops->handle_exit_irqoff(vcpu, &accel_exit);
>>=20
>> 	/*
>> 	 * Consume any pending interrupts, including the possible source =
of
>> @@ -8270,7 +8314,7 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
>> 		kvm_lapic_sync_from_vapic(vcpu);
>>=20
>> 	vcpu->arch.gpa_available =3D false;
>> -	r =3D kvm_x86_ops->handle_exit(vcpu);
>> +	r =3D kvm_x86_ops->handle_exit(vcpu, accel_exit);
>> 	return r;
>>=20
>> cancel_injection:
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 29391af..f14ec14 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -291,6 +291,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct =
kvm_vcpu *vcpu, gfn_t gfn,
>> bool kvm_vector_hashing_enabled(void);
>> int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>> 			    int emulation_type, void *insn, int =
insn_len);
>> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct =
kvm_vcpu *vcpu);
>>=20
>> #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE =
\
>> 				| XFEATURE_MASK_YMM | =
XFEATURE_MASK_BNDREGS \
>> --=20
>> 2.7.4

