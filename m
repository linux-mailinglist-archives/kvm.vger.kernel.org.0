Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD5E102C38
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 19:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKSS7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 13:59:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKSS7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 13:59:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJIidte043221;
        Tue, 19 Nov 2019 18:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=llp9rhdYAJL5/rv0v1JRIqcD0WzDj3VucxzLreoJoQI=;
 b=kF6HWRcTSlD6Wfe/PJsy89bUw/Y7pKBwxkAWBVRMGZUI7FlGTI6uTxeykwRI7HFguInd
 bwket3EBgk9aGBbB4Gz4ts+ufG7FPqKqrYtRtMNRpt7oEERApWcUMO3w9DTbZ+GJmk8j
 yw85w3+Q9Qa6GVPIZYx4innUS+sGQDtWnu+VfQiFJuxGodvHxa7AU9wA+ziu0gap2Jx7
 k8gFvEzORfUB/7brQ59NwksjjZdpnh90lrOdKFvImNc56Iny7kbyab/kN+j0x9WKoXFc
 X0P3Qo62idwuyJ0b5NzSyPA4Cgk9OLoMHTz4/p6dTBQG+fdFId8cEobPhq2iy0/wLR3I yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hts160-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 18:58:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJIhWkB065071;
        Tue, 19 Nov 2019 18:58:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wbxm4rads-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 18:58:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJIwbWt026395;
        Tue, 19 Nov 2019 18:58:38 GMT
Received: from [192.168.14.112] (/79.181.226.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 10:58:37 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191119183658.GC25672@linux.intel.com>
Date:   Tue, 19 Nov 2019 20:58:32 +0200
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4C827CE1-CF87-45BE-BE84-42ABDEA3DE8D@oracle.com>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
 <20191119183658.GC25672@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=520
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=590 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Nov 2019, at 20:36, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Nov 19, 2019 at 02:36:28PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>=20
>> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in=20=

>> our product observation, multicast IPIs are not as common as unicast=20=

>> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>>=20
>> This patch tries to optimize x2apic physical destination mode, fixed=20=

>> delivery mode single target IPI by delivering IPI to receiver as soon=20=

>> as possible after sender writes ICR vmexit to avoid various checks=20
>> when possible, especially when running guest w/ --overcommit =
cpu-pm=3Don
>> or guest can keep running, IPI can be injected to target vCPU by=20
>> posted-interrupt immediately.
>>=20
>> Testing on Xeon Skylake server:
>>=20
>> The virtual IPI latency from sender send to receiver receive reduces=20=

>> more than 200+ cpu cycles.
>>=20
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>> v1 -> v2:
>> * add tracepoint
>> * Instead of a separate vcpu->fast_vmexit, set exit_reason
>>   to vmx->exit_reason to -1 if the fast path succeeds.
>> * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
>> * moving the handling into vmx_handle_exit_irqoff()
>>=20
>> arch/x86/include/asm/kvm_host.h |  4 ++--
>> arch/x86/include/uapi/asm/vmx.h |  1 +
>> arch/x86/kvm/svm.c              |  4 ++--
>> arch/x86/kvm/vmx/vmx.c          | 40 =
+++++++++++++++++++++++++++++++++++++---
>> arch/x86/kvm/x86.c              |  5 +++--
>> 5 files changed, 45 insertions(+), 9 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
>> index 898ab9e..0daafa9 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
>> 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>>=20
>> 	void (*run)(struct kvm_vcpu *vcpu);
>> -	int (*handle_exit)(struct kvm_vcpu *vcpu);
>> +	int (*handle_exit)(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason);
>> 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>> 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>> 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>> @@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
>> 	int (*check_intercept)(struct kvm_vcpu *vcpu,
>> 			       struct x86_instruction_info *info,
>> 			       enum x86_intercept_stage stage);
>> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
>> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 =
*vcpu_exit_reason);
>> 	bool (*mpx_supported)(void);
>> 	bool (*xsaves_supported)(void);
>> 	bool (*umip_emulated)(void);
>> diff --git a/arch/x86/include/uapi/asm/vmx.h =
b/arch/x86/include/uapi/asm/vmx.h
>> index 3eb8411..b33c6e1 100644
>> --- a/arch/x86/include/uapi/asm/vmx.h
>> +++ b/arch/x86/include/uapi/asm/vmx.h
>> @@ -88,6 +88,7 @@
>> #define EXIT_REASON_XRSTORS             64
>> #define EXIT_REASON_UMWAIT              67
>> #define EXIT_REASON_TPAUSE              68
>> +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
>>=20
>> #define VMX_EXIT_REASONS \
>> 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
>=20
> Rather than pass a custom exit reason around, can we simply handle =
*all*
> x2apic ICR writes during handle_exit_irqoff() for both VMX and SVM?  =
The
> only risk I can think of is that KVM could stall too long before =
enabling
> IRQs.
>=20

I agree that if it doesn=E2=80=99t cause to run with interrupts disabled =
then this is a nicer approach.
However, I think we may generalise a bit this patch to a clear code-path =
where accelerated exit handling
should be put. See my other reply in this email thread and tell me what =
you think:
https://www.spinics.net/lists/kernel/msg3322282.html

-Liran

>=20
> =46rom 1ea8ff1aa766928c869ef7c1eb437fe4f7b8daf9 Mon Sep 17 00:00:00 =
2001
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Tue, 19 Nov 2019 09:50:42 -0800
> Subject: [PATCH] KVM: x86: Add a fast path for sending virtual IPIs in =
x2APIC
> mode
>=20
> Add a fast path to handle writes to the ICR when the local APIC is
> emulated in the kernel and x2APIC is enabled.  The fast path is =
invoked
> at ->handle_exit_irqoff() to emulate only the effect of the ICR write
> itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
> flow reduces the latency of virtual IPIs by avoiding the expensive =
bits
> of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.
>=20
> Suggested-by: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> arch/x86/kvm/emulate.c |  1 -
> arch/x86/kvm/lapic.c   |  5 +++--
> arch/x86/kvm/lapic.h   | 25 +++++++++++++++++++++++++
> arch/x86/kvm/svm.c     |  3 +++
> arch/x86/kvm/vmx/vmx.c |  2 ++
> 5 files changed, 33 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 952d1a4f4d7e..8313234e7d64 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -19,7 +19,6 @@
>  */
>=20
> #include <linux/kvm_host.h>
> -#include "kvm_cache_regs.h"
> #include <asm/kvm_emulate.h>
> #include <linux/stringify.h>
> #include <asm/debugreg.h>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 452cedd6382b..0f02820332d4 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2655,9 +2655,10 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, =
u32 msr, u64 data)
> 	if (reg =3D=3D APIC_ICR2)
> 		return 1;
>=20
> -	/* if this is ICR write vector before command */
> +	/* ICR writes are handled early by kvm_x2apic_fast_icr_write(). =
*/
> 	if (reg =3D=3D APIC_ICR)
> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> +		return 0;
> +
> 	return kvm_lapic_reg_write(apic, reg, (u32)data);
> }
>=20
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index c1d77436126a..19fd2734d9e6 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -6,6 +6,8 @@
>=20
> #include <linux/kvm_host.h>
>=20
> +#include "kvm_cache_regs.h"
> +
> #define KVM_APIC_INIT		0
> #define KVM_APIC_SIPI		1
> #define KVM_APIC_LVT_NUM	6
> @@ -245,4 +247,27 @@ static inline enum lapic_mode kvm_apic_mode(u64 =
apic_base)
> 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
> }
>=20
> +/*
> + * Fast path for sending virtual IPIs immediately after VM-Exit.  =
Fault
> + * detection and injection, e.g. if x2apic is disabled, tracing =
and/or skipping
> + * of the emulated instruction are all handled in the standard WRMSR =
path,
> + * kvm_emulate_wrmsr().
> + */
> +static inline void kvm_x2apic_fast_icr_write(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic =3D vcpu->arch.apic;
> +	u64 data;
> +
> +	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
> +		return;
> +
> +	if (kvm_rcx_read(vcpu) !=3D (APIC_BASE_MSR + (APIC_ICR >> 4)))
> +		return;
> +
> +	data =3D kvm_read_edx_eax(vcpu);
> +
> +	kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> +	WARN_ON_ONCE(kvm_lapic_reg_write(apic, APIC_ICR, (u32)data));
> +}
> +
> #endif
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d02a73a48461..713510210b29 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6189,7 +6189,10 @@ static int svm_check_intercept(struct kvm_vcpu =
*vcpu,
>=20
> static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> {
> +	struct vcpu_svm *svm =3D to_svm(vcpu);
>=20
> +	if (svm->vmcb->control.exit_code && =
svm->vmcb->control.exit_info_1)
> +		kvm_x2apic_fast_icr_write(vcpu);
> }
>=20
> static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 621142e55e28..82412c4085fc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6231,6 +6231,8 @@ static void vmx_handle_exit_irqoff(struct =
kvm_vcpu *vcpu)
> 		handle_external_interrupt_irqoff(vcpu);
> 	else if (vmx->exit_reason =3D=3D EXIT_REASON_EXCEPTION_NMI)
> 		handle_exception_nmi_irqoff(vmx);
> +	else if (vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> +		kvm_x2apic_fast_icr_write(vcpu);
> }
>=20
> static bool vmx_has_emulated_msr(int index)
> --=20
> 2.24.0
>=20

