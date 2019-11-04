Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D47EDC87
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfKDK32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:29:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbfKDK32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572863367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5pOpItnW/Pud/PvLUA6I6D+lIMtESVd1h94P4vuvHM=;
        b=L3XyZ9SXYChWsMnRhQMYiW5kcXeRqcLXKpXe0tah+gsCPJbZbAXGMioqQRco4SZwOaLMCu
        IIkQKoV1q/LIiTbSap19Utcgd6m7w/vxf1UQERbvy/BEi2h4PTDgnXJ2FiPhtm4QsE07eI
        Zy6kZ2x+ZZvZPLyrHvWdW8L2Hy9mW/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-DQiKQKS_NhS7xcx7uuaf2A-1; Mon, 04 Nov 2019 05:29:23 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85CCD107ACC2;
        Mon,  4 Nov 2019 10:29:22 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46CF15C21B;
        Mon,  4 Nov 2019 10:29:20 +0000 (UTC)
Subject: Re: [RFC 14/37] KVM: s390: protvirt: Implement interruption injection
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-15-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f51f2146-834c-ba48-1015-b83c4fe6cd54@redhat.com>
Date:   Mon, 4 Nov 2019 11:29:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-15-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: DQiKQKS_NhS7xcx7uuaf2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> The patch implements interruption injection for the following
> list of interruption types:
>=20
>    - I/O
>      __deliver_io (III)
>=20
>    - External
>      __deliver_cpu_timer (IEI)
>      __deliver_ckc (IEI)
>      __deliver_emergency_signal (IEI)
>      __deliver_external_call (IEI)
>      __deliver_service (IEI)
>=20
>    - cpu restart
>      __deliver_restart (IRI)

What exactly is IRQ_PEND_EXT_SERVICE_EV? Can you add some comments whet=20
the new interrupt does and why it is needed in this context? Thanks

>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com> [interrupt =
masking]
> ---
>   arch/s390/include/asm/kvm_host.h |  10 ++
>   arch/s390/kvm/interrupt.c        | 182 +++++++++++++++++++++++--------
>   2 files changed, 149 insertions(+), 43 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 82443236d4cc..63fc32d38aa9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -496,6 +496,7 @@ enum irq_types {
>   =09IRQ_PEND_PFAULT_INIT,
>   =09IRQ_PEND_EXT_HOST,
>   =09IRQ_PEND_EXT_SERVICE,
> +=09IRQ_PEND_EXT_SERVICE_EV,
>   =09IRQ_PEND_EXT_TIMING,
>   =09IRQ_PEND_EXT_CPU_TIMER,
>   =09IRQ_PEND_EXT_CLOCK_COMP,
> @@ -540,6 +541,7 @@ enum irq_types {
>   =09=09=09   (1UL << IRQ_PEND_EXT_TIMING)     | \
>   =09=09=09   (1UL << IRQ_PEND_EXT_HOST)       | \
>   =09=09=09   (1UL << IRQ_PEND_EXT_SERVICE)    | \
> +=09=09=09   (1UL << IRQ_PEND_EXT_SERVICE_EV) | \
>   =09=09=09   (1UL << IRQ_PEND_VIRTIO)         | \
>   =09=09=09   (1UL << IRQ_PEND_PFAULT_INIT)    | \
>   =09=09=09   (1UL << IRQ_PEND_PFAULT_DONE))
> @@ -556,6 +558,13 @@ enum irq_types {
>   #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
>   =09=09=09    (1UL << IRQ_PEND_MCHK_EX))
>  =20
> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
> +=09=09=09      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
> +=09=09=09      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
> +=09=09=09      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
> +=09=09=09      (1UL << IRQ_PEND_EXT_SERVICE)    | \
> +=09=09=09      (1UL << IRQ_PEND_EXT_SERVICE_EV))
> +
>   struct kvm_s390_interrupt_info {
>   =09struct list_head list;
>   =09u64=09type;
> @@ -614,6 +623,7 @@ struct kvm_s390_local_interrupt {
>  =20
>   struct kvm_s390_float_interrupt {
>   =09unsigned long pending_irqs;
> +=09unsigned long masked_irqs;
>   =09spinlock_t lock;
>   =09struct list_head lists[FIRQ_LIST_COUNT];
>   =09int counters[FIRQ_MAX_COUNT];
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 165dea4c7f19..c919dfe4dfd3 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -324,8 +324,10 @@ static inline int gisa_tac_ipm_gisc(struct kvm_s390_=
gisa *gisa, u32 gisc)
>  =20
>   static inline unsigned long pending_irqs_no_gisa(struct kvm_vcpu *vcpu)
>   {
> -=09return vcpu->kvm->arch.float_int.pending_irqs |
> -=09=09vcpu->arch.local_int.pending_irqs;
> +=09unsigned long pending =3D vcpu->kvm->arch.float_int.pending_irqs | vc=
pu->arch.local_int.pending_irqs;
> +
> +=09pending &=3D ~vcpu->kvm->arch.float_int.masked_irqs;
> +=09return pending;
>   }
>  =20
>   static inline unsigned long pending_irqs(struct kvm_vcpu *vcpu)
> @@ -383,10 +385,16 @@ static unsigned long deliverable_irqs(struct kvm_vc=
pu *vcpu)
>   =09=09__clear_bit(IRQ_PEND_EXT_CLOCK_COMP, &active_mask);
>   =09if (!(vcpu->arch.sie_block->gcr[0] & CR0_CPU_TIMER_SUBMASK))
>   =09=09__clear_bit(IRQ_PEND_EXT_CPU_TIMER, &active_mask);
> -=09if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK))
> +=09if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK)) {
>   =09=09__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
> +=09=09__clear_bit(IRQ_PEND_EXT_SERVICE_EV, &active_mask);
> +=09}
>   =09if (psw_mchk_disabled(vcpu))
>   =09=09active_mask &=3D ~IRQ_PEND_MCHK_MASK;
> +=09/* PV guest cpus can have a single interruption injected at a time. *=
/
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm) &&
> +=09    vcpu->arch.sie_block->iictl !=3D IICTL_CODE_NONE)
> +=09=09active_mask &=3D ~(IRQ_PEND_EXT_II_MASK | IRQ_PEND_IO_MASK);
>   =09/*
>   =09 * Check both floating and local interrupt's cr14 because
>   =09 * bit IRQ_PEND_MCHK_REP could be set in both cases.
> @@ -479,19 +487,23 @@ static void set_intercept_indicators(struct kvm_vcp=
u *vcpu)
>   static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
>   {
>   =09struct kvm_s390_local_interrupt *li =3D &vcpu->arch.local_int;
> -=09int rc;
> +=09int rc =3D 0;
>  =20
>   =09vcpu->stat.deliver_cputm++;
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CPU_TIM=
ER,
>   =09=09=09=09=09 0, 0);
> -
> -=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_CPU_TIMER,
> -=09=09=09   (u16 *)__LC_EXT_INT_CODE);
> -=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> -=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> -=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> -=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> -=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_EXT;
> +=09=09vcpu->arch.sie_block->eic =3D EXT_IRQ_CPU_TIMER;
> +=09} else {
> +=09=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_CPU_TIMER,
> +=09=09=09=09   (u16 *)__LC_EXT_INT_CODE);
> +=09=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> +=09=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> +=09=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> +=09=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09}
>   =09clear_bit(IRQ_PEND_EXT_CPU_TIMER, &li->pending_irqs);
>   =09return rc ? -EFAULT : 0;
>   }
> @@ -499,19 +511,23 @@ static int __must_check __deliver_cpu_timer(struct =
kvm_vcpu *vcpu)
>   static int __must_check __deliver_ckc(struct kvm_vcpu *vcpu)
>   {
>   =09struct kvm_s390_local_interrupt *li =3D &vcpu->arch.local_int;
> -=09int rc;
> +=09int rc =3D 0;
>  =20
>   =09vcpu->stat.deliver_ckc++;
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CLOCK_C=
OMP,
>   =09=09=09=09=09 0, 0);
> -
> -=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_CLK_COMP,
> -=09=09=09   (u16 __user *)__LC_EXT_INT_CODE);
> -=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> -=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> -=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> -=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> -=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_EXT;
> +=09=09vcpu->arch.sie_block->eic =3D EXT_IRQ_CLK_COMP;
> +=09} else {
> +=09=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_CLK_COMP,
> +=09=09=09=09   (u16 __user *)__LC_EXT_INT_CODE);
> +=09=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> +=09=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> +=09=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> +=09=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09}
>   =09clear_bit(IRQ_PEND_EXT_CLOCK_COMP, &li->pending_irqs);
>   =09return rc ? -EFAULT : 0;
>   }
> @@ -533,7 +549,6 @@ static int __must_check __deliver_pfault_init(struct =
kvm_vcpu *vcpu)
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
>   =09=09=09=09=09 KVM_S390_INT_PFAULT_INIT,
>   =09=09=09=09=09 0, ext.ext_params2);
> -
>   =09rc  =3D put_guest_lc(vcpu, EXT_IRQ_CP_SERVICE, (u16 *) __LC_EXT_INT_=
CODE);
>   =09rc |=3D put_guest_lc(vcpu, PFAULT_INIT, (u16 *) __LC_EXT_CPU_ADDR);
>   =09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> @@ -696,17 +711,21 @@ static int __must_check __deliver_machine_check(str=
uct kvm_vcpu *vcpu)
>   static int __must_check __deliver_restart(struct kvm_vcpu *vcpu)
>   {
>   =09struct kvm_s390_local_interrupt *li =3D &vcpu->arch.local_int;
> -=09int rc;
> +=09int rc =3D 0;
>  =20
>   =09VCPU_EVENT(vcpu, 3, "%s", "deliver: cpu restart");
>   =09vcpu->stat.deliver_restart_signal++;
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_RESTART, 0,=
 0);
>  =20
> -=09rc  =3D write_guest_lc(vcpu,
> -=09=09=09     offsetof(struct lowcore, restart_old_psw),
> -=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> -=09rc |=3D read_guest_lc(vcpu, offsetof(struct lowcore, restart_psw),
> -=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_RESTART;
> +=09} else {
> +=09=09rc  =3D write_guest_lc(vcpu,
> +=09=09=09=09     offsetof(struct lowcore, restart_old_psw),
> +=09=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09=09rc |=3D read_guest_lc(vcpu, offsetof(struct lowcore, restart_psw),
> +=09=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09}
>   =09clear_bit(IRQ_PEND_RESTART, &li->pending_irqs);
>   =09return rc ? -EFAULT : 0;
>   }
> @@ -748,6 +767,12 @@ static int __must_check __deliver_emergency_signal(s=
truct kvm_vcpu *vcpu)
>   =09vcpu->stat.deliver_emergency_signal++;
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGEN=
CY,
>   =09=09=09=09=09 cpu_addr, 0);
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_EXT;
> +=09=09vcpu->arch.sie_block->eic =3D EXT_IRQ_EMERGENCY_SIG;
> +=09=09vcpu->arch.sie_block->extcpuaddr =3D cpu_addr;
> +=09=09return 0;
> +=09}
>  =20
>   =09rc  =3D put_guest_lc(vcpu, EXT_IRQ_EMERGENCY_SIG,
>   =09=09=09   (u16 *)__LC_EXT_INT_CODE);
> @@ -776,6 +801,12 @@ static int __must_check __deliver_external_call(stru=
ct kvm_vcpu *vcpu)
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
>   =09=09=09=09=09 KVM_S390_INT_EXTERNAL_CALL,
>   =09=09=09=09=09 extcall.code, 0);
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_EXT;
> +=09=09vcpu->arch.sie_block->eic =3D EXT_IRQ_EXTERNAL_CALL;
> +=09=09vcpu->arch.sie_block->extcpuaddr =3D extcall.code;
> +=09=09return 0;
> +=09}
>  =20
>   =09rc  =3D put_guest_lc(vcpu, EXT_IRQ_EXTERNAL_CALL,
>   =09=09=09   (u16 *)__LC_EXT_INT_CODE);
> @@ -902,6 +933,31 @@ static int __must_check __deliver_prog(struct kvm_vc=
pu *vcpu)
>   =09return rc ? -EFAULT : 0;
>   }
>  =20
> +#define SCCB_MASK 0xFFFFFFF8
> +#define SCCB_EVENT_PENDING 0x3
> +
> +static int write_sclp(struct kvm_vcpu *vcpu, u32 parm)
> +{
> +=09int rc;
> +
> +=09if (kvm_s390_pv_handle_cpu(vcpu)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_EXT;
> +=09=09vcpu->arch.sie_block->eic =3D EXT_IRQ_SERVICE_SIG;
> +=09=09vcpu->arch.sie_block->eiparams =3D parm;
> +=09=09return 0;
> +=09}
> +
> +=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_SERVICE_SIG, (u16 *)__LC_EXT_INT_C=
ODE);
> +=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> +=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> +=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> +=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> +=09rc |=3D put_guest_lc(vcpu, parm,
> +=09=09=09   (u32 *)__LC_EXT_PARAMS);
> +=09return rc;
> +}
> +
>   static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
>   {
>   =09struct kvm_s390_float_interrupt *fi =3D &vcpu->kvm->arch.float_int;
> @@ -909,13 +965,17 @@ static int __must_check __deliver_service(struct kv=
m_vcpu *vcpu)
>   =09int rc =3D 0;
>  =20
>   =09spin_lock(&fi->lock);
> -=09if (!(test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs))) {
> +=09if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs) ||
> +=09    !(test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs))) {
>   =09=09spin_unlock(&fi->lock);
>   =09=09return 0;
>   =09}
>   =09ext =3D fi->srv_signal;
>   =09memset(&fi->srv_signal, 0, sizeof(ext));
>   =09clear_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
> +=09clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm))
> +=09=09set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
>   =09spin_unlock(&fi->lock);
>  =20
>   =09VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
> @@ -924,15 +984,33 @@ static int __must_check __deliver_service(struct kv=
m_vcpu *vcpu)
>   =09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE=
,
>   =09=09=09=09=09 ext.ext_params, 0);
>  =20
> -=09rc  =3D put_guest_lc(vcpu, EXT_IRQ_SERVICE_SIG, (u16 *)__LC_EXT_INT_C=
ODE);
> -=09rc |=3D put_guest_lc(vcpu, 0, (u16 *)__LC_EXT_CPU_ADDR);
> -=09rc |=3D write_guest_lc(vcpu, __LC_EXT_OLD_PSW,
> -=09=09=09     &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> -=09rc |=3D read_guest_lc(vcpu, __LC_EXT_NEW_PSW,
> -=09=09=09    &vcpu->arch.sie_block->gpsw, sizeof(psw_t));
> -=09rc |=3D put_guest_lc(vcpu, ext.ext_params,
> -=09=09=09   (u32 *)__LC_EXT_PARAMS);
> +=09rc =3D write_sclp(vcpu, ext.ext_params);
> +=09return rc ? -EFAULT : 0;
> +}
>  =20
> +static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
> +{
> +=09struct kvm_s390_float_interrupt *fi =3D &vcpu->kvm->arch.float_int;
> +=09struct kvm_s390_ext_info ext;
> +=09int rc =3D 0;
> +
> +=09spin_lock(&fi->lock);
> +=09if (!(test_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs))) {
> +=09=09spin_unlock(&fi->lock);
> +=09=09return 0;
> +=09}
> +=09ext =3D fi->srv_signal;
> +=09/* only clear the event bit */
> +=09fi->srv_signal.ext_params &=3D ~SCCB_EVENT_PENDING;
> +=09clear_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
> +=09spin_unlock(&fi->lock);
> +
> +=09VCPU_EVENT(vcpu, 4, "%s", "deliver: sclp parameter event");
> +=09vcpu->stat.deliver_service_signal++;
> +=09trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
> +=09=09=09=09=09 ext.ext_params, 0);
> +
> +=09rc =3D write_sclp(vcpu, SCCB_EVENT_PENDING);
>   =09return rc ? -EFAULT : 0;
>   }
>  =20
> @@ -1028,6 +1106,15 @@ static int __do_deliver_io(struct kvm_vcpu *vcpu, =
struct kvm_s390_io_info *io)
>   {
>   =09int rc;
>  =20
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_IO;
> +=09=09vcpu->arch.sie_block->subchannel_id =3D io->subchannel_id;
> +=09=09vcpu->arch.sie_block->subchannel_nr =3D io->subchannel_nr;
> +=09=09vcpu->arch.sie_block->io_int_parm =3D io->io_int_parm;
> +=09=09vcpu->arch.sie_block->io_int_word =3D io->io_int_word;
> +=09=09return 0;
> +=09}
> +
>   =09rc  =3D put_guest_lc(vcpu, io->subchannel_id, (u16 *)__LC_SUBCHANNEL=
_ID);
>   =09rc |=3D put_guest_lc(vcpu, io->subchannel_nr, (u16 *)__LC_SUBCHANNEL=
_NR);
>   =09rc |=3D put_guest_lc(vcpu, io->io_int_parm, (u32 *)__LC_IO_INT_PARM)=
;
> @@ -1329,6 +1416,9 @@ int __must_check kvm_s390_deliver_pending_interrupt=
s(struct kvm_vcpu *vcpu)
>   =09=09case IRQ_PEND_EXT_SERVICE:
>   =09=09=09rc =3D __deliver_service(vcpu);
>   =09=09=09break;
> +=09=09case IRQ_PEND_EXT_SERVICE_EV:
> +=09=09=09rc =3D __deliver_service_ev(vcpu);
> +=09=09=09break;
>   =09=09case IRQ_PEND_PFAULT_DONE:
>   =09=09=09rc =3D __deliver_pfault_done(vcpu);
>   =09=09=09break;
> @@ -1421,7 +1511,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, =
struct kvm_s390_irq *irq)
>   =09if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) =3D=3D NULL)
>   =09=09return -EINVAL;
>  =20
> -=09if (sclp.has_sigpif)
> +=09if (sclp.has_sigpif && !kvm_s390_pv_handle_cpu(vcpu))
>   =09=09return sca_inject_ext_call(vcpu, src_id);
>  =20
>   =09if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
> @@ -1681,9 +1771,6 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int=
(struct kvm *kvm,
>   =09return inti;
>   }
>  =20
> -#define SCCB_MASK 0xFFFFFFF8
> -#define SCCB_EVENT_PENDING 0x3
> -
>   static int __inject_service(struct kvm *kvm,
>   =09=09=09     struct kvm_s390_interrupt_info *inti)
>   {
> @@ -1692,6 +1779,11 @@ static int __inject_service(struct kvm *kvm,
>   =09kvm->stat.inject_service_signal++;
>   =09spin_lock(&fi->lock);
>   =09fi->srv_signal.ext_params |=3D inti->ext.ext_params & SCCB_EVENT_PEN=
DING;
> +
> +=09/* We always allow events, track them separately from the sccb ints *=
/
> +=09if (fi->srv_signal.ext_params & SCCB_EVENT_PENDING)
> +=09=09set_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs);
> +
>   =09/*
>   =09 * Early versions of the QEMU s390 bios will inject several
>   =09 * service interrupts after another without handling a
> @@ -1834,7 +1926,8 @@ static void __floating_irq_kick(struct kvm *kvm, u6=
4 type)
>   =09=09break;
>   =09case KVM_S390_INT_IO_MIN...KVM_S390_INT_IO_MAX:
>   =09=09if (!(type & KVM_S390_INT_IO_AI_MASK &&
> -=09=09      kvm->arch.gisa_int.origin))
> +=09=09      kvm->arch.gisa_int.origin) ||
> +=09=09      kvm_s390_pv_handle_cpu(dst_vcpu))
>   =09=09=09kvm_s390_set_cpuflags(dst_vcpu, CPUSTAT_IO_INT);
>   =09=09break;
>   =09default:
> @@ -2082,6 +2175,8 @@ void kvm_s390_clear_float_irqs(struct kvm *kvm)
>  =20
>   =09spin_lock(&fi->lock);
>   =09fi->pending_irqs =3D 0;
> +=09if (!kvm_s390_pv_is_protected(kvm))
> +=09=09fi->masked_irqs =3D 0;
>   =09memset(&fi->srv_signal, 0, sizeof(fi->srv_signal));
>   =09memset(&fi->mchk, 0, sizeof(fi->mchk));
>   =09for (i =3D 0; i < FIRQ_LIST_COUNT; i++)
> @@ -2146,7 +2241,8 @@ static int get_all_floating_irqs(struct kvm *kvm, u=
8 __user *usrbuf, u64 len)
>   =09=09=09n++;
>   =09=09}
>   =09}
> -=09if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs)) {
> +=09if (test_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs) ||
> +=09    test_bit(IRQ_PEND_EXT_SERVICE_EV, &fi->pending_irqs)) {
>   =09=09if (n =3D=3D max_irqs) {
>   =09=09=09/* signal userspace to try again */
>   =09=09=09ret =3D -ENOMEM;
>=20


--=20

Thanks,

David / dhildenb

