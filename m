Return-Path: <kvm+bounces-15452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B4F8AC340
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 05:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 451751C20B23
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 03:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22A910A2B;
	Mon, 22 Apr 2024 03:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="WU8Zb0zF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87821FBE8
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 03:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713758240; cv=none; b=IfqDXDuGT6upn0SJw7cPGPJ1rYOkI0jf7ho6pSIEixRYPJ02dFeAlMBWvuH7vgd1qmXehX6j5764pQTd6Rl1xBDjPjXtuqh4ZFqlPBigZFTkKJ0/3/pBeRRNxq7Lvj1D6vPV6ScshXbkn/Az5nVJJTwjIaeBs0K3q3adAX4oSYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713758240; c=relaxed/simple;
	bh=C7oXOAIueSChCOFjBf4yXr47ijuvzjjzUww+hjXS/Ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ncqXSN/NUFU8VDEz+/2SJ5lXwEXieKeQ1h90YeHiUaI8jwlN5VjQtygDx0oKPeBHUFbIJahmhSYQ79SaENob1+maFc5segmdsTK8DNtaSPKqRGh4yWQzf8ul00SwW89CYH39e1EB9FW/FWr3c1OIzrSlu+MbA0kIA7QpCSoRTJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=WU8Zb0zF; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7d5f87224a8so177291439f.1
        for <kvm@vger.kernel.org>; Sun, 21 Apr 2024 20:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1713758236; x=1714363036; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxMvEkhMO/oefS5y2Vv6EBhGarUlSL5vA59TpkffJtE=;
        b=WU8Zb0zFtVY6Kck2Yq0iB631WeJ4bUW9xlpqLYZdUWdGYewIHoIbICUHCw+Om0PBSO
         OW9NRmkWK7qdd94DOM7tegKUWUE496os78y9TNllruxGQQtMQilT2JIVRF44RvF+vg6H
         rgybH7JocQm77Wn8A7W8iR2mdQzEUpbUvGun4zVk2/WwXX++dD/JnwwLOc8Tiyzj8a9k
         pIdH0XlbDdnvDNwWemE9QgyCM7yz5GG4FcmXQcB5ldquygw42xEb1Ky2Xda8VeZtwpg/
         XDzaeP+l1S/pnaWTabhRKrl7QySj0pfNwXZ6rYGGYzHu3QACOkX2i6BDNQ7SBWAD3GJZ
         VAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713758236; x=1714363036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxMvEkhMO/oefS5y2Vv6EBhGarUlSL5vA59TpkffJtE=;
        b=VO+dKBf9P/fzKFRmUMzxW65dy92RqAhRwKmlux7r5tgS+PvVMrW/jBS3I+6R58YyOu
         qvNwsf8IG9CL2azpl3/R4dC17j9ltfWRvei1GAKs0JAt1i7c8Y7b3B214DD7j4J8Oi3y
         LYSIeTYi9+PMjtrNKowmjeRRLBOjeTAVOIaJ8afOXrQQE/xbVVAQVr3BaM2ebDzqYG4P
         mp/lelFnSWiYYknGDMxId3Pv2/5TxWw0pfFIB6QwBI+RZwXy/0GHv0cEEv+z9MyfxWm5
         CYKo47uUGhD5jNS2SHlG6Ew0whIjGUhwnwF9dzCOj3UyLowYDvnPNASBec+MCdfCPmSI
         usxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+x50d+VxO41Vdn7t1GXRpZfmeg9UFG1stQ08Zu3i2dRxsC8Vts9eX228tRtt8TbaSEIQ7NDlsVw3o9sGnDBEL/v2b
X-Gm-Message-State: AOJu0YxuuwmBbQKk5Z5MwFXFsevnWxa83SGjfnaN8nHxP5O/EItBCJlU
	HN8wR0xe6Hj4PRaVb2D7NJM+WkRzj1hB8VSkA14RVjivNMgcGJ9ucHEfb5YRLlrDZfmvXmyOPWj
	VDozPpyc2W94mLRGVWtYGXYZqx+wicrTnbgpjaOb4Mr9vut4r
X-Google-Smtp-Source: AGHT+IEfXmNboQBWQv5TaehVyCZXDONHrrHKtvj+JX6Jhm2LM11IausIv6pX26KiIKRgmVbB/rGXl1IvBxb6iREpPdo=
X-Received: by 2002:a05:6e02:4c9:b0:36b:ffc1:d1ad with SMTP id
 f9-20020a056e0204c900b0036bffc1d1admr9986145ils.18.1713758236580; Sun, 21 Apr
 2024 20:57:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240417074528.16506-1-yongxuan.wang@sifive.com> <20240417074528.16506-2-yongxuan.wang@sifive.com>
In-Reply-To: <20240417074528.16506-2-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 22 Apr 2024 09:27:05 +0530
Message-ID: <CAAhSdy30XpKzewqF1-UEinis6ScrQnB2aT1+iJakWC7eFDSbGA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] RISCV: KVM: Introduce mp_state_lock to avoid lock
 inversion in SBI_EXT_HSM_HART_START
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 1:15=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifiv=
e.com> wrote:
>
> Documentation/virt/kvm/locking.rst advises that kvm->lock should be
> acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
> handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
> kvm->srcu then kvm->lock.
>
> Although the lockdep checking no longer complains about this after commit
> f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
> it's necessary to replace kvm->lock with a new dedicated lock to ensure
> only one hart can execute the SBI_EXT_HSM_HART_START call for the target
> hart simultaneously.
>
> Additionally, this patch also rename "power_off" to "mp_state" with two
> possible values. The vcpu->mp_state_lock also protects the access of
> vcpu->mp_state.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  7 ++--
>  arch/riscv/kvm/vcpu.c             | 56 ++++++++++++++++++++++++-------
>  arch/riscv/kvm/vcpu_sbi.c         |  7 ++--
>  arch/riscv/kvm/vcpu_sbi_hsm.c     | 23 ++++++++-----
>  4 files changed, 68 insertions(+), 25 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 484d04a92fa6..64d35a8c908c 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -252,8 +252,9 @@ struct kvm_vcpu_arch {
>         /* Cache pages needed to program page tables with spinlock held *=
/
>         struct kvm_mmu_memory_cache mmu_page_cache;
>
> -       /* VCPU power-off state */
> -       bool power_off;
> +       /* VCPU power state */
> +       struct kvm_mp_state mp_state;
> +       spinlock_t mp_state_lock;
>
>         /* Don't run the VCPU (blocked) */
>         bool pause;
> @@ -375,7 +376,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu =
*vcpu);
>  void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
>  bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
> +void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
> +bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
>
>  void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..70937f71c3c4 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -102,6 +102,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         struct kvm_cpu_context *cntx;
>         struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
>
> +       spin_lock_init(&vcpu->arch.mp_state_lock);
> +
>         /* Mark this VCPU never ran */
>         vcpu->arch.ran_atleast_once =3D false;
>         vcpu->arch.mmu_page_cache.gfp_zero =3D __GFP_ZERO;
> @@ -201,7 +203,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
>         return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
> -               !vcpu->arch.power_off && !vcpu->arch.pause);
> +               !kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
>  }
>
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
> @@ -429,26 +431,50 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu =
*vcpu, u64 mask)
>         return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
>  }
>
> -void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
> +static void __kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.power_off =3D true;
> +       vcpu->arch.mp_state.mp_state =3D KVM_MP_STATE_STOPPED;
>         kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         kvm_vcpu_kick(vcpu);
>  }
>
> -void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
> +{
> +       spin_lock(&vcpu->arch.mp_state_lock);
> +       __kvm_riscv_vcpu_power_off(vcpu);
> +       spin_unlock(&vcpu->arch.mp_state_lock);
> +}
> +
> +void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.power_off =3D false;
> +       vcpu->arch.mp_state.mp_state =3D KVM_MP_STATE_RUNNABLE;
>         kvm_vcpu_wake_up(vcpu);
>  }
>
> +void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
> +{
> +       spin_lock(&vcpu->arch.mp_state_lock);
> +       __kvm_riscv_vcpu_power_on(vcpu);
> +       spin_unlock(&vcpu->arch.mp_state_lock);
> +}
> +
> +bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu)
> +{
> +       bool ret;
> +
> +       spin_lock(&vcpu->arch.mp_state_lock);
> +       ret =3D vcpu->arch.mp_state.mp_state =3D=3D KVM_MP_STATE_STOPPED;
> +       spin_unlock(&vcpu->arch.mp_state_lock);
> +
> +       return ret;

Checking mp_state is very expensive this way because spin locks
are implicit fences.

Instead of this, we can simply use READ_ONCE() here and we
use WRITE_ONCE() + spin lock to serialize writes.

I will take care of this at the time of merging this patch.

> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       if (vcpu->arch.power_off)
> -               mp_state->mp_state =3D KVM_MP_STATE_STOPPED;
> -       else
> -               mp_state->mp_state =3D KVM_MP_STATE_RUNNABLE;
> +       spin_lock(&vcpu->arch.mp_state_lock);
> +       *mp_state =3D vcpu->arch.mp_state;
> +       spin_unlock(&vcpu->arch.mp_state_lock);
>
>         return 0;
>  }
> @@ -458,17 +484,21 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu=
 *vcpu,
>  {
>         int ret =3D 0;
>
> +       spin_lock(&vcpu->arch.mp_state_lock);
> +
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> -               vcpu->arch.power_off =3D false;
> +               vcpu->arch.mp_state.mp_state =3D KVM_MP_STATE_RUNNABLE;
>                 break;
>         case KVM_MP_STATE_STOPPED:
> -               kvm_riscv_vcpu_power_off(vcpu);
> +               __kvm_riscv_vcpu_power_off(vcpu);
>                 break;
>         default:
>                 ret =3D -EINVAL;
>         }
>
> +       spin_unlock(&vcpu->arch.mp_state_lock);
> +
>         return ret;
>  }
>
> @@ -584,11 +614,11 @@ static void kvm_riscv_check_vcpu_requests(struct kv=
m_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
>                         kvm_vcpu_srcu_read_unlock(vcpu);
>                         rcuwait_wait_event(wait,
> -                               (!vcpu->arch.power_off) && (!vcpu->arch.p=
ause),
> +                               (!kvm_riscv_vcpu_stopped(vcpu)) && (!vcpu=
->arch.pause),
>                                 TASK_INTERRUPTIBLE);
>                         kvm_vcpu_srcu_read_lock(vcpu);
>
> -                       if (vcpu->arch.power_off || vcpu->arch.pause) {
> +                       if (kvm_riscv_vcpu_stopped(vcpu) || vcpu->arch.pa=
use) {
>                                 /*
>                                  * Awaken to handle a signal, request to
>                                  * sleep again later.
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 72a2ffb8dcd1..1851fc979bd2 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -138,8 +138,11 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu=
 *vcpu,
>         unsigned long i;
>         struct kvm_vcpu *tmp;
>
> -       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off =3D true;
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +               spin_lock(&vcpu->arch.mp_state_lock);
> +               tmp->arch.mp_state.mp_state =3D KVM_MP_STATE_STOPPED;
> +               spin_unlock(&vcpu->arch.mp_state_lock);
> +       }
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
>         memset(&run->system_event, 0, sizeof(run->system_event));
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index 7dca0e9381d9..115a6c6525fd 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -18,12 +18,18 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vc=
pu)
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
>         struct kvm_vcpu *target_vcpu;
>         unsigned long target_vcpuid =3D cp->a0;
> +       int ret =3D 0;
>
>         target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>         if (!target_vcpu)
>                 return SBI_ERR_INVALID_PARAM;
> -       if (!target_vcpu->arch.power_off)
> -               return SBI_ERR_ALREADY_AVAILABLE;
> +
> +       spin_lock(&target_vcpu->arch.mp_state_lock);
> +
> +       if (target_vcpu->arch.mp_state.mp_state !=3D KVM_MP_STATE_STOPPED=
) {
> +               ret =3D SBI_ERR_ALREADY_AVAILABLE;
> +               goto out;
> +       }
>
>         reset_cntx =3D &target_vcpu->arch.guest_reset_context;
>         /* start address */
> @@ -34,14 +40,18 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vc=
pu)
>         reset_cntx->a1 =3D cp->a2;
>         kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
>
> -       kvm_riscv_vcpu_power_on(target_vcpu);
> +       __kvm_riscv_vcpu_power_on(target_vcpu);
> +
> +out:
> +       spin_unlock(&target_vcpu->arch.mp_state_lock);
> +
>
>         return 0;
>  }
>
>  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
>  {
> -       if (vcpu->arch.power_off)
> +       if (kvm_riscv_vcpu_stopped(vcpu))
>                 return SBI_ERR_FAILURE;
>
>         kvm_riscv_vcpu_power_off(vcpu);
> @@ -58,7 +68,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu =
*vcpu)
>         target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>         if (!target_vcpu)
>                 return SBI_ERR_INVALID_PARAM;
> -       if (!target_vcpu->arch.power_off)
> +       if (!kvm_riscv_vcpu_stopped(target_vcpu))
>                 return SBI_HSM_STATE_STARTED;
>         else if (vcpu->stat.generic.blocking)
>                 return SBI_HSM_STATE_SUSPENDED;
> @@ -71,14 +81,11 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
>  {
>         int ret =3D 0;
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> -       struct kvm *kvm =3D vcpu->kvm;
>         unsigned long funcid =3D cp->a6;
>
>         switch (funcid) {
>         case SBI_EXT_HSM_HART_START:
> -               mutex_lock(&kvm->lock);
>                 ret =3D kvm_sbi_hsm_vcpu_start(vcpu);
> -               mutex_unlock(&kvm->lock);
>                 break;
>         case SBI_EXT_HSM_HART_STOP:
>                 ret =3D kvm_sbi_hsm_vcpu_stop(vcpu);
> --
> 2.17.1
>

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

