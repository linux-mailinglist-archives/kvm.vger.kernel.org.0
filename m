Return-Path: <kvm+bounces-15479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BAC8ACACA
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67493B228B9
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF362146593;
	Mon, 22 Apr 2024 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PoSAviw2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C314601A
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713782073; cv=none; b=i75F09d2CS0Vp336yJu3kUADjrInfO5B+6GHj/8fZyekgfCSvfUa+mJfyfdwwKaScTTf4lDI0ikkdWDvu2E+vZntsqQM5G/IaukxrFo0WR4DJvQOhEl5fmUpfU6KXKrg3qdEkDdguPf169Ic78ARTzxW06ZxyvcDSCnrS/1Q2JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713782073; c=relaxed/simple;
	bh=UArJF6LV02ybPnW3cckOh9ZJHRnOYM9wUStlH0hfzXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9tLDZb9A/0ZMTe+xK+4tN7D0GFKLj+3EWQ/Th7fH9902Ux7PsOh+CGPs6jhzdY1STDy+bwkwLA/z8J46TXWnD5wY5y9f3iTUmKQTLRSx87sJXYzUQtJEm+qLT3sdQDm8sLmd+lqgeJqct7skevBwX9hBpW6yU12htjpKojeVL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PoSAviw2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713782068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iu1FhQyYHf9/hTUWxKsKZUlq9b0c85wfRA6HDlXeNjk=;
	b=PoSAviw2TgWxElydruZorSXGOniP9+iNcQjFg4ViZjQv074LW74KHdjI76oPdMcCQDoUev
	CLssK4NorUF34B9XUfHt1cXQxecNO/JY9DIjclLT7d+3keZzfufOb2YEmaLMxvJ4e8gGA3
	h7E4x7WyNNC2pNg6Aor6YkV81EZKOhs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-kDjwHx4eNwGiDnhsiCXNfQ-1; Mon, 22 Apr 2024 06:34:26 -0400
X-MC-Unique: kDjwHx4eNwGiDnhsiCXNfQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41681022d82so19666905e9.1
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 03:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713782065; x=1714386865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iu1FhQyYHf9/hTUWxKsKZUlq9b0c85wfRA6HDlXeNjk=;
        b=SXgZ4fYqItAvJVlxp9CnhWDU+e8hfkxS7LqqcqSmLuxFIBSrZHf3KlRcNuj1gObxSZ
         k58T1BwFlGwY3JK+UnFoOw2vthSa1YqnikFgvOZjVjsMKR5B6qZqfFasp1xdZvQdkwUy
         9y4cLnIWKBy6P3SJ2oKfc3XQxJNqkiihPYw+cGG6Cpx1LaR7QbuJEnFZkHbG+DeUsq7E
         aobJ/eST+oVbWwW7I9IPUi/batlHIuGqFJ+Zlauy4WZe6bATlVr1aGuTYBKgfkje9BGM
         x8KPWmZAgN7Wl+0l0PAlmNI+u+N2GSTsZcGcq30uKO4S1L7TzSl7vO3jKLzelVvCacII
         fCeA==
X-Forwarded-Encrypted: i=1; AJvYcCXGwUevNdkaC3GaEc+BJMPya7e3wiXFeAvpwwz1k04raiZ72v5LnanwDGR1jbE0vryEXyqYNixrYSVaLN74XsGvHRkL
X-Gm-Message-State: AOJu0YyPAzu3UEWsYS1IKHgglcBpwNacn4iSskWnVQW5EaLCjfL88Q6Y
	tmmqU5UPyLnMRFNN+EjyBD08946QQbe7r9tJ2gRYdHTHP8SYr0N0GraBCue3NKWs2PW6Ru430z1
	+GeuL0pisjW6+Nv1DMFDyRvA4XJ9FqIRl7OqdI7kFxXiFD2W2JwTrp5zpHucFiXrNM14e7Sho09
	ARitCOavhQDI/EwPk7E5iYjyBeXYRM0v4d
X-Received: by 2002:a05:600c:3504:b0:416:605b:5868 with SMTP id h4-20020a05600c350400b00416605b5868mr5847129wmq.35.1713782063892;
        Mon, 22 Apr 2024 03:34:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFF55AcTjsHRrgyip80Wc4Dj3ogH5DhC7yyv7cvh0cGuvPauXtb2/yBTUhDtbFrzsJvDcKIMdT994wGjFZhis8=
X-Received: by 2002:a05:600c:3504:b0:416:605b:5868 with SMTP id
 h4-20020a05600c350400b00416605b5868mr5847101wmq.35.1713782062570; Mon, 22 Apr
 2024 03:34:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240419112952.15598-1-wei.w.wang@intel.com> <20240419112952.15598-3-wei.w.wang@intel.com>
In-Reply-To: <20240419112952.15598-3-wei.w.wang@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 22 Apr 2024 12:34:10 +0200
Message-ID: <CABgObfaaec5JmLtZ+OJ7NuX1zGh6_dSQ_n7-8K=LtEY-ON-dJQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: x86: Introduce KVM_X86_CALL() to simplify
 static calls of kvm_x86_ops
To: Wei Wang <wei.w.wang@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 1:30=E2=80=AFPM Wei Wang <wei.w.wang@intel.com> wro=
te:
> +#define KVM_X86_CALL(func, ...) static_call(kvm_x86_##func)(__VA_ARGS__)

Just

#define KVM_X86_CALL(func) static_call(kvm_x86_##func)

please, because having the parentheses around the arguments is a lot
more readable (and works better with most editors, for example in vim
you can use the "%" movement comment to find the matching
parenthesis).

Paolo

> +
>  #define KVM_X86_OP(func) \
>         DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->=
func));
>  #define KVM_X86_OP_OPTIONAL KVM_X86_OP
> @@ -1875,7 +1877,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  {
>         if (kvm_x86_ops.flush_remote_tlbs &&
> -           !static_call(kvm_x86_flush_remote_tlbs)(kvm))
> +           !KVM_X86_CALL(flush_remote_tlbs, kvm))
>                 return 0;
>         else
>                 return -ENOTSUPP;
> @@ -1888,7 +1890,7 @@ static inline int kvm_arch_flush_remote_tlbs_range(=
struct kvm *kvm, gfn_t gfn,
>         if (!kvm_x86_ops.flush_remote_tlbs_range)
>                 return -EOPNOTSUPP;
>
> -       return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_=
pages);
> +       return KVM_X86_CALL(flush_remote_tlbs_range, kvm, gfn, nr_pages);
>  }
>  #endif /* CONFIG_HYPERV */
>
> @@ -2280,12 +2282,12 @@ static inline bool kvm_irq_is_postable(struct kvm=
_lapic_irq *irq)
>
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
> -       static_call(kvm_x86_vcpu_blocking)(vcpu);
> +       KVM_X86_CALL(vcpu_blocking, vcpu);
>  }
>
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
> -       static_call(kvm_x86_vcpu_unblocking)(vcpu);
> +       KVM_X86_CALL(vcpu_unblocking, vcpu);
>  }
>
>  static inline int kvm_cpu_get_apicid(int mps_cpu)
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 77352a4abd87..ba15fb416aaf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -388,7 +388,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu =
*vcpu)
>                                                     vcpu->arch.cpuid_nent=
));
>
>         /* Invoke the vendor callback only after the above state is updat=
ed. */
> -       static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
> +       KVM_X86_CALL(vcpu_after_set_cpuid, vcpu);
>
>         /*
>          * Except for the MMU, which needs to do its thing any vendor spe=
cific
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 8a47f8541eab..5833e82221ea 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1417,7 +1417,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu,=
 u32 msr, u64 data,
>                 }
>
>                 /* vmcall/vmmcall */
> -               static_call(kvm_x86_patch_hypercall)(vcpu, instructions +=
 i);
> +               KVM_X86_CALL(patch_hypercall, vcpu, instructions + i);
>                 i +=3D 3;
>
>                 /* ret */
> @@ -1985,7 +1985,7 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>                  */
>                 gva =3D entries[i] & PAGE_MASK;
>                 for (j =3D 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> -                       static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j =
* PAGE_SIZE);
> +                       KVM_X86_CALL(flush_tlb_gva, vcpu, gva + j * PAGE_=
SIZE);
>
>                 ++vcpu->stat.tlb_flush;
>         }
> @@ -2526,7 +2526,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>          * hypercall generates UD from non zero cpl and real mode
>          * per HYPER-V spec
>          */
> -       if (static_call(kvm_x86_get_cpl)(vcpu) !=3D 0 || !is_protmode(vcp=
u)) {
> +       if (KVM_X86_CALL(get_cpl, vcpu) !=3D 0 || !is_protmode(vcpu)) {
>                 kvm_queue_exception(vcpu, UD_VECTOR);
>                 return 1;
>         }
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 7cf93d427484..2feaeec271cf 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -157,7 +157,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
>  {
>         __kvm_migrate_apic_timer(vcpu);
>         __kvm_migrate_pit_timer(vcpu);
> -       static_call(kvm_x86_migrate_timers)(vcpu);
> +       KVM_X86_CALL(migrate_timers, vcpu);
>  }
>
>  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.=
h
> index 75eae9c4998a..2053ed0066ac 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -98,7 +98,7 @@ static inline unsigned long kvm_register_read_raw(struc=
t kvm_vcpu *vcpu, int reg
>                 return 0;
>
>         if (!kvm_register_is_available(vcpu, reg))
> -               static_call(kvm_x86_cache_reg)(vcpu, reg);
> +               KVM_X86_CALL(cache_reg, vcpu, reg);
>
>         return vcpu->arch.regs[reg];
>  }
> @@ -138,7 +138,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcp=
u, int index)
>         might_sleep();  /* on svm */
>
>         if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
> -               static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_PDPTR);
> +               KVM_X86_CALL(cache_reg, vcpu, VCPU_EXREG_PDPTR);
>
>         return vcpu->arch.walk_mmu->pdptrs[index];
>  }
> @@ -153,7 +153,7 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu=
 *vcpu, ulong mask)
>         ulong tmask =3D mask & KVM_POSSIBLE_CR0_GUEST_BITS;
>         if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
>             !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
> -               static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR0);
> +               KVM_X86_CALL(cache_reg, vcpu, VCPU_EXREG_CR0);
>         return vcpu->arch.cr0 & mask;
>  }
>
> @@ -175,7 +175,7 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu=
 *vcpu, ulong mask)
>         ulong tmask =3D mask & KVM_POSSIBLE_CR4_GUEST_BITS;
>         if ((tmask & vcpu->arch.cr4_guest_owned_bits) &&
>             !kvm_register_is_available(vcpu, VCPU_EXREG_CR4))
> -               static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR4);
> +               KVM_X86_CALL(cache_reg, vcpu, VCPU_EXREG_CR4);
>         return vcpu->arch.cr4 & mask;
>  }
>
> @@ -190,7 +190,7 @@ static __always_inline bool kvm_is_cr4_bit_set(struct=
 kvm_vcpu *vcpu,
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
>         if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -               static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR3);
> +               KVM_X86_CALL(cache_reg, vcpu, VCPU_EXREG_CR3);
>         return vcpu->arch.cr3;
>  }
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index eaf840699d27..0c52cf912712 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -728,8 +728,8 @@ static inline void apic_clear_irr(int vec, struct kvm=
_lapic *apic)
>         if (unlikely(apic->apicv_active)) {
>                 /* need to update RVI */
>                 kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
> -               static_call(kvm_x86_hwapic_irr_update)(apic->vcpu,
> -                                                           apic_find_hig=
hest_irr(apic));
> +               KVM_X86_CALL(hwapic_irr_update,
> +                            apic->vcpu, apic_find_highest_irr(apic));
>         } else {
>                 apic->irr_pending =3D false;
>                 kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
> @@ -755,7 +755,7 @@ static inline void apic_set_isr(int vec, struct kvm_l=
apic *apic)
>          * just set SVI.
>          */
>         if (unlikely(apic->apicv_active))
> -               static_call(kvm_x86_hwapic_isr_update)(vec);
> +               KVM_X86_CALL(hwapic_isr_update, vec);
>         else {
>                 ++apic->isr_count;
>                 BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> @@ -800,7 +800,7 @@ static inline void apic_clear_isr(int vec, struct kvm=
_lapic *apic)
>          * and must be left alone.
>          */
>         if (unlikely(apic->apicv_active))
> -               static_call(kvm_x86_hwapic_isr_update)(apic_find_highest_=
isr(apic));
> +               KVM_X86_CALL(hwapic_isr_update, apic_find_highest_isr(api=
c));
>         else {
>                 --apic->isr_count;
>                 BUG_ON(apic->isr_count < 0);
> @@ -936,7 +936,7 @@ static int apic_has_interrupt_for_ppr(struct kvm_lapi=
c *apic, u32 ppr)
>  {
>         int highest_irr;
>         if (kvm_x86_ops.sync_pir_to_irr)
> -               highest_irr =3D static_call(kvm_x86_sync_pir_to_irr)(apic=
->vcpu);
> +               highest_irr =3D KVM_X86_CALL(sync_pir_to_irr, apic->vcpu)=
;
>         else
>                 highest_irr =3D apic_find_highest_irr(apic);
>         if (highest_irr =3D=3D -1 || (highest_irr & 0xF0) <=3D ppr)
> @@ -1328,8 +1328,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic=
, int delivery_mode,
>                                                        apic->regs + APIC_=
TMR);
>                 }
>
> -               static_call(kvm_x86_deliver_interrupt)(apic, delivery_mod=
e,
> -                                                      trig_mode, vector)=
;
> +               KVM_X86_CALL(deliver_interrupt,
> +                            apic, delivery_mode, trig_mode, vector);
>                 break;
>
>         case APIC_DM_REMRD:
> @@ -2095,7 +2095,7 @@ static void cancel_hv_timer(struct kvm_lapic *apic)
>  {
>         WARN_ON(preemptible());
>         WARN_ON(!apic->lapic_timer.hv_timer_in_use);
> -       static_call(kvm_x86_cancel_hv_timer)(apic->vcpu);
> +       KVM_X86_CALL(cancel_hv_timer, apic->vcpu);
>         apic->lapic_timer.hv_timer_in_use =3D false;
>  }
>
> @@ -2112,7 +2112,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
>         if (!ktimer->tscdeadline)
>                 return false;
>
> -       if (static_call(kvm_x86_set_hv_timer)(vcpu, ktimer->tscdeadline, =
&expired))
> +       if (KVM_X86_CALL(set_hv_timer, vcpu, ktimer->tscdeadline, &expire=
d))
>                 return false;
>
>         ktimer->hv_timer_in_use =3D true;
> @@ -2567,7 +2567,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 =
value)
>
>         if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENAB=
LE)) {
>                 kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> -               static_call(kvm_x86_set_virtual_apic_mode)(vcpu);
> +               KVM_X86_CALL(set_virtual_apic_mode, vcpu);
>         }
>
>         apic->base_address =3D apic->vcpu->arch.apic_base &
> @@ -2677,7 +2677,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool in=
it_event)
>         u64 msr_val;
>         int i;
>
> -       static_call(kvm_x86_apicv_pre_state_restore)(vcpu);
> +       KVM_X86_CALL(apicv_pre_state_restore, vcpu);
>
>         if (!init_event) {
>                 msr_val =3D APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_EN=
ABLE;
> @@ -2732,9 +2732,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool in=
it_event)
>         vcpu->arch.pv_eoi.msr_val =3D 0;
>         apic_update_ppr(apic);
>         if (apic->apicv_active) {
> -               static_call(kvm_x86_apicv_post_state_restore)(vcpu);
> -               static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
> -               static_call(kvm_x86_hwapic_isr_update)(-1);
> +               KVM_X86_CALL(apicv_post_state_restore, vcpu);
> +               KVM_X86_CALL(hwapic_irr_update, vcpu, -1);
> +               KVM_X86_CALL(hwapic_isr_update, -1);
>         }
>
>         vcpu->arch.apic_arb_prio =3D 0;
> @@ -2830,7 +2830,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int tim=
er_advance_ns)
>         vcpu->arch.apic =3D apic;
>
>         if (kvm_x86_ops.alloc_apic_backing_page)
> -               apic->regs =3D static_call(kvm_x86_alloc_apic_backing_pag=
e)(vcpu);
> +               apic->regs =3D KVM_X86_CALL(alloc_apic_backing_page, vcpu=
);
>         else
>                 apic->regs =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT=
);
>         if (!apic->regs) {
> @@ -3014,7 +3014,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struc=
t kvm_lapic_state *s)
>         struct kvm_lapic *apic =3D vcpu->arch.apic;
>         int r;
>
> -       static_call(kvm_x86_apicv_pre_state_restore)(vcpu);
> +       KVM_X86_CALL(apicv_pre_state_restore, vcpu);
>
>         kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
>         /* set SPIV separately to get count of SW disabled APICs right */
> @@ -3041,9 +3041,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, stru=
ct kvm_lapic_state *s)
>         kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>         kvm_apic_update_apicv(vcpu);
>         if (apic->apicv_active) {
> -               static_call(kvm_x86_apicv_post_state_restore)(vcpu);
> -               static_call(kvm_x86_hwapic_irr_update)(vcpu, apic_find_hi=
ghest_irr(apic));
> -               static_call(kvm_x86_hwapic_isr_update)(apic_find_highest_=
isr(apic));
> +               KVM_X86_CALL(apicv_post_state_restore, vcpu);
> +               KVM_X86_CALL(hwapic_irr_update,
> +                            vcpu, apic_find_highest_irr(apic));
> +               KVM_X86_CALL(hwapic_isr_update, apic_find_highest_isr(api=
c));
>         }
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>         if (ioapic_in_kernel(vcpu->kvm))
> @@ -3331,7 +3332,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>                         /* evaluate pending_events before reading the vec=
tor */
>                         smp_rmb();
>                         sipi_vector =3D apic->sipi_vector;
> -                       static_call(kvm_x86_vcpu_deliver_sipi_vector)(vcp=
u, sipi_vector);
> +                       KVM_X86_CALL(vcpu_deliver_sipi_vector,
> +                                    vcpu, sipi_vector);
>                         vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
>                 }
>         }
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0a0ea4b5dd8c..b56208a6864c 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -236,7 +236,7 @@ static inline bool kvm_apic_has_pending_init_or_sipi(=
struct kvm_vcpu *vcpu)
>  static inline bool kvm_apic_init_sipi_allowed(struct kvm_vcpu *vcpu)
>  {
>         return !is_smm(vcpu) &&
> -              !static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
> +              !KVM_X86_CALL(apic_init_signal_blocked, vcpu);
>  }
>
>  static inline bool kvm_lowest_prio_delivery(struct kvm_lapic_irq *irq)
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..e13af03f5cc1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -161,8 +161,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *=
vcpu)
>         if (!VALID_PAGE(root_hpa))
>                 return;
>
> -       static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
> -                                         vcpu->arch.mmu->root_role.level=
);
> +       KVM_X86_CALL(load_mmu_pgd, vcpu, root_hpa,
> +                    vcpu->arch.mmu->root_role.level);
>  }
>
>  static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcp=
u,
> @@ -197,7 +197,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vc=
pu, struct kvm_mmu *mmu,
>  {
>         /* strip nested paging fault error codes */
>         unsigned int pfec =3D access;
> -       unsigned long rflags =3D static_call(kvm_x86_get_rflags)(vcpu);
> +       unsigned long rflags =3D KVM_X86_CALL(get_rflags, vcpu);
>
>         /*
>          * For explicit supervisor accesses, SMAP is disabled if EFLAGS.A=
C =3D 1.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index db007a4dffa2..112643a1fa05 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5626,7 +5626,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>          * stale entries.  Flushing on alloc also allows KVM to skip the =
TLB
>          * flush when freeing a root (see kvm_tdp_mmu_put_root()).
>          */
> -       static_call(kvm_x86_flush_tlb_current)(vcpu);
> +       KVM_X86_CALL(flush_tlb_current, vcpu);
>  out:
>         return r;
>  }
> @@ -5962,7 +5962,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu,=
 struct kvm_mmu *mmu,
>                 if (is_noncanonical_address(addr, vcpu))
>                         return;
>
> -               static_call(kvm_x86_flush_tlb_gva)(vcpu, addr);
> +               KVM_X86_CALL(flush_tlb_gva, vcpu, addr);
>         }
>
>         if (!mmu->sync_spte)
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4a599130e9c9..40a6368e4913 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -190,8 +190,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_=
page *sp,
>                 spte |=3D PT_PAGE_SIZE_MASK;
>
>         if (shadow_memtype_mask)
> -               spte |=3D static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
> -                                                        kvm_is_mmio_pfn(=
pfn));
> +               spte |=3D KVM_X86_CALL(get_mt_mask,
> +                                    vcpu, gfn, kvm_is_mmio_pfn(pfn));
>         if (host_writable)
>                 spte |=3D shadow_host_writable_mask;
>         else
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index d06d43d8d2aa..745b3d0954c7 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -200,11 +200,11 @@ static void enter_smm_save_state_32(struct kvm_vcpu=
 *vcpu,
>         enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG=
_TR);
>         enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_=
SREG_LDTR);
>
> -       static_call(kvm_x86_get_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(get_gdt, vcpu, &dt);
>         smram->gdtr.base =3D dt.address;
>         smram->gdtr.limit =3D dt.size;
>
> -       static_call(kvm_x86_get_idt)(vcpu, &dt);
> +       KVM_X86_CALL(get_idt, vcpu, &dt);
>         smram->idtr.base =3D dt.address;
>         smram->idtr.limit =3D dt.size;
>
> @@ -220,7 +220,7 @@ static void enter_smm_save_state_32(struct kvm_vcpu *=
vcpu,
>         smram->smm_revision =3D 0x00020000;
>         smram->smbase =3D vcpu->arch.smbase;
>
> -       smram->int_shadow =3D static_call(kvm_x86_get_interrupt_shadow)(v=
cpu);
> +       smram->int_shadow =3D KVM_X86_CALL(get_interrupt_shadow, vcpu);
>  }
>
>  #ifdef CONFIG_X86_64
> @@ -250,13 +250,13 @@ static void enter_smm_save_state_64(struct kvm_vcpu=
 *vcpu,
>
>         enter_smm_save_seg_64(vcpu, &smram->tr, VCPU_SREG_TR);
>
> -       static_call(kvm_x86_get_idt)(vcpu, &dt);
> +       KVM_X86_CALL(get_idt, vcpu, &dt);
>         smram->idtr.limit =3D dt.size;
>         smram->idtr.base =3D dt.address;
>
>         enter_smm_save_seg_64(vcpu, &smram->ldtr, VCPU_SREG_LDTR);
>
> -       static_call(kvm_x86_get_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(get_gdt, vcpu, &dt);
>         smram->gdtr.limit =3D dt.size;
>         smram->gdtr.base =3D dt.address;
>
> @@ -267,7 +267,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *=
vcpu,
>         enter_smm_save_seg_64(vcpu, &smram->fs, VCPU_SREG_FS);
>         enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>
> -       smram->int_shadow =3D static_call(kvm_x86_get_interrupt_shadow)(v=
cpu);
> +       smram->int_shadow =3D KVM_X86_CALL(get_interrupt_shadow, vcpu);
>  }
>  #endif
>
> @@ -297,7 +297,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
>          * Kill the VM in the unlikely case of failure, because the VM
>          * can be in undefined state in this case.
>          */
> -       if (static_call(kvm_x86_enter_smm)(vcpu, &smram))
> +       if (KVM_X86_CALL(enter_smm, vcpu, &smram))
>                 goto error;
>
>         kvm_smm_changed(vcpu, true);
> @@ -305,24 +305,24 @@ void enter_smm(struct kvm_vcpu *vcpu)
>         if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram=
, sizeof(smram)))
>                 goto error;
>
> -       if (static_call(kvm_x86_get_nmi_mask)(vcpu))
> +       if (KVM_X86_CALL(get_nmi_mask, vcpu))
>                 vcpu->arch.hflags |=3D HF_SMM_INSIDE_NMI_MASK;
>         else
> -               static_call(kvm_x86_set_nmi_mask)(vcpu, true);
> +               KVM_X86_CALL(set_nmi_mask, vcpu, true);
>
>         kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>         kvm_rip_write(vcpu, 0x8000);
>
> -       static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> +       KVM_X86_CALL(set_interrupt_shadow, vcpu, 0);
>
>         cr0 =3D vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS |=
 X86_CR0_PG);
> -       static_call(kvm_x86_set_cr0)(vcpu, cr0);
> +       KVM_X86_CALL(set_cr0, vcpu, cr0);
>
> -       static_call(kvm_x86_set_cr4)(vcpu, 0);
> +       KVM_X86_CALL(set_cr4, vcpu, 0);
>
>         /* Undocumented: IDT limit is set to zero on entry to SMM.  */
>         dt.address =3D dt.size =3D 0;
> -       static_call(kvm_x86_set_idt)(vcpu, &dt);
> +       KVM_X86_CALL(set_idt, vcpu, &dt);
>
>         if (WARN_ON_ONCE(kvm_set_dr(vcpu, 7, DR7_FIXED_1)))
>                 goto error;
> @@ -354,7 +354,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
>
>  #ifdef CONFIG_X86_64
>         if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> -               if (static_call(kvm_x86_set_efer)(vcpu, 0))
> +               if (KVM_X86_CALL(set_efer, vcpu, 0))
>                         goto error;
>  #endif
>
> @@ -479,11 +479,11 @@ static int rsm_load_state_32(struct x86_emulate_ctx=
t *ctxt,
>
>         dt.address =3D               smstate->gdtr.base;
>         dt.size =3D                  smstate->gdtr.limit;
> -       static_call(kvm_x86_set_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(set_gdt, vcpu, &dt);
>
>         dt.address =3D               smstate->idtr.base;
>         dt.size =3D                  smstate->idtr.limit;
> -       static_call(kvm_x86_set_idt)(vcpu, &dt);
> +       KVM_X86_CALL(set_idt, vcpu, &dt);
>
>         rsm_load_seg_32(vcpu, &smstate->es, smstate->es_sel, VCPU_SREG_ES=
);
>         rsm_load_seg_32(vcpu, &smstate->cs, smstate->cs_sel, VCPU_SREG_CS=
);
> @@ -501,7 +501,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt =
*ctxt,
>         if (r !=3D X86EMUL_CONTINUE)
>                 return r;
>
> -       static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> +       KVM_X86_CALL(set_interrupt_shadow, vcpu, 0);
>         ctxt->interruptibility =3D (u8)smstate->int_shadow;
>
>         return r;
> @@ -535,13 +535,13 @@ static int rsm_load_state_64(struct x86_emulate_ctx=
t *ctxt,
>
>         dt.size =3D                   smstate->idtr.limit;
>         dt.address =3D                smstate->idtr.base;
> -       static_call(kvm_x86_set_idt)(vcpu, &dt);
> +       KVM_X86_CALL(set_idt, vcpu, &dt);
>
>         rsm_load_seg_64(vcpu, &smstate->ldtr, VCPU_SREG_LDTR);
>
>         dt.size =3D                   smstate->gdtr.limit;
>         dt.address =3D                smstate->gdtr.base;
> -       static_call(kvm_x86_set_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(set_gdt, vcpu, &dt);
>
>         r =3D rsm_enter_protected_mode(vcpu, smstate->cr0, smstate->cr3, =
smstate->cr4);
>         if (r !=3D X86EMUL_CONTINUE)
> @@ -554,7 +554,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt =
*ctxt,
>         rsm_load_seg_64(vcpu, &smstate->fs, VCPU_SREG_FS);
>         rsm_load_seg_64(vcpu, &smstate->gs, VCPU_SREG_GS);
>
> -       static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> +       KVM_X86_CALL(set_interrupt_shadow, vcpu, 0);
>         ctxt->interruptibility =3D (u8)smstate->int_shadow;
>
>         return X86EMUL_CONTINUE;
> @@ -576,7 +576,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>                 return X86EMUL_UNHANDLEABLE;
>
>         if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) =3D=3D 0)
> -               static_call(kvm_x86_set_nmi_mask)(vcpu, false);
> +               KVM_X86_CALL(set_nmi_mask, vcpu, false);
>
>         kvm_smm_changed(vcpu, false);
>
> @@ -628,7 +628,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
>          * state (e.g. enter guest mode) before loading state from the SM=
M
>          * state-save area.
>          */
> -       if (static_call(kvm_x86_leave_smm)(vcpu, &smram))
> +       if (KVM_X86_CALL(leave_smm, vcpu, &smram))
>                 return X86EMUL_UNHANDLEABLE;
>
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index c6b4b1728006..27096f001e54 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -314,12 +314,9 @@ TRACE_EVENT(name,                                   =
                    \
>                 __entry->guest_rip      =3D kvm_rip_read(vcpu);          =
      \
>                 __entry->isa            =3D isa;                         =
      \
>                 __entry->vcpu_id        =3D vcpu->vcpu_id;               =
      \
> -               static_call(kvm_x86_get_exit_info)(vcpu,                 =
    \
> -                                         &__entry->exit_reason,         =
    \
> -                                         &__entry->info1,               =
    \
> -                                         &__entry->info2,               =
    \
> -                                         &__entry->intr_info,           =
    \
> -                                         &__entry->error_code);         =
    \
> +               KVM_X86_CALL(get_exit_info, vcpu, &__entry->exit_reason, =
    \
> +                            &__entry->info1, &__entry->info2,           =
    \
> +                            &__entry->intr_info, &__entry->error_code); =
    \
>         ),                                                               =
    \
>                                                                          =
    \
>         TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "     =
    \
> @@ -828,7 +825,8 @@ TRACE_EVENT(kvm_emulate_insn,
>                 ),
>
>         TP_fast_assign(
> -               __entry->csbase =3D static_call(kvm_x86_get_segment_base)=
(vcpu, VCPU_SREG_CS);
> +               __entry->csbase =3D KVM_X86_CALL(get_segment_base,
> +                                              vcpu, VCPU_SREG_CS);
>                 __entry->len =3D vcpu->arch.emulate_ctxt->fetch.ptr
>                                - vcpu->arch.emulate_ctxt->fetch.data;
>                 __entry->rip =3D vcpu->arch.emulate_ctxt->_eip - __entry-=
>len;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4e6cbbab1e18..2467e053cb35 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -839,7 +839,7 @@ EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
>   */
>  bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
>  {
> -       if (static_call(kvm_x86_get_cpl)(vcpu) <=3D required_cpl)
> +       if (KVM_X86_CALL(get_cpl, vcpu) <=3D required_cpl)
>                 return true;
>         kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>         return false;
> @@ -923,7 +923,7 @@ static bool kvm_is_valid_cr0(struct kvm_vcpu *vcpu, u=
nsigned long cr0)
>         if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>                 return false;
>
> -       return static_call(kvm_x86_is_valid_cr0)(vcpu, cr0);
> +       return KVM_X86_CALL(is_valid_cr0, vcpu, cr0);
>  }
>
>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsi=
gned long cr0)
> @@ -987,7 +987,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long =
cr0)
>
>                 if (!is_pae(vcpu))
>                         return 1;
> -               static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l=
);
> +               KVM_X86_CALL(get_cs_db_l_bits, vcpu, &cs_db, &cs_l);
>                 if (cs_l)
>                         return 1;
>         }
> @@ -1001,7 +1001,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned lon=
g cr0)
>             (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCI=
DE)))
>                 return 1;
>
> -       static_call(kvm_x86_set_cr0)(vcpu, cr0);
> +       KVM_X86_CALL(set_cr0, vcpu, cr0);
>
>         kvm_post_set_cr0(vcpu, old_cr0, cr0);
>
> @@ -1119,7 +1119,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32=
 index, u64 xcr)
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>  {
>         /* Note, #UD due to CR4.OSXSAVE=3D0 has priority over the interce=
pt. */
> -       if (static_call(kvm_x86_get_cpl)(vcpu) !=3D 0 ||
> +       if (KVM_X86_CALL(get_cpl, vcpu) !=3D 0 ||
>             __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu=
))) {
>                 kvm_inject_gp(vcpu, 0);
>                 return 1;
> @@ -1144,7 +1144,7 @@ EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
>  static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>         return __kvm_is_valid_cr4(vcpu, cr4) &&
> -              static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
> +              KVM_X86_CALL(is_valid_cr4, vcpu, cr4);
>  }
>
>  void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsi=
gned long cr4)
> @@ -1212,7 +1212,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned lon=
g cr4)
>                         return 1;
>         }
>
> -       static_call(kvm_x86_set_cr4)(vcpu, cr4);
> +       KVM_X86_CALL(set_cr4, vcpu, cr4);
>
>         kvm_post_set_cr4(vcpu, old_cr4, cr4);
>
> @@ -1351,7 +1351,7 @@ void kvm_update_dr7(struct kvm_vcpu *vcpu)
>                 dr7 =3D vcpu->arch.guest_debug_dr7;
>         else
>                 dr7 =3D vcpu->arch.dr7;
> -       static_call(kvm_x86_set_dr7)(vcpu, dr7);
> +       KVM_X86_CALL(set_dr7, vcpu, dr7);
>         vcpu->arch.switch_db_regs &=3D ~KVM_DEBUGREG_BP_ENABLED;
>         if (dr7 & DR7_BP_EN_MASK)
>                 vcpu->arch.switch_db_regs |=3D KVM_DEBUGREG_BP_ENABLED;
> @@ -1694,7 +1694,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry=
 *msr)
>                 rdmsrl_safe(msr->index, &msr->data);
>                 break;
>         default:
> -               return static_call(kvm_x86_get_msr_feature)(msr);
> +               return KVM_X86_CALL(get_msr_feature, msr);
>         }
>         return 0;
>  }
> @@ -1768,7 +1768,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct m=
sr_data *msr_info)
>         efer &=3D ~EFER_LMA;
>         efer |=3D vcpu->arch.efer & EFER_LMA;
>
> -       r =3D static_call(kvm_x86_set_efer)(vcpu, efer);
> +       r =3D KVM_X86_CALL(set_efer, vcpu, efer);
>         if (r) {
>                 WARN_ON(r > 0);
>                 return r;
> @@ -1898,7 +1898,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32=
 index, u64 data,
>         msr.index =3D index;
>         msr.host_initiated =3D host_initiated;
>
> -       return static_call(kvm_x86_set_msr)(vcpu, &msr);
> +       return KVM_X86_CALL(set_msr, vcpu, &msr);
>  }
>
>  static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
> @@ -1940,7 +1940,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index,=
 u64 *data,
>         msr.index =3D index;
>         msr.host_initiated =3D host_initiated;
>
> -       ret =3D static_call(kvm_x86_get_msr)(vcpu, &msr);
> +       ret =3D KVM_X86_CALL(get_msr, vcpu, &msr);
>         if (!ret)
>                 *data =3D msr.data;
>         return ret;
> @@ -2008,7 +2008,7 @@ static int complete_emulated_rdmsr(struct kvm_vcpu =
*vcpu)
>
>  static int complete_fast_msr_access(struct kvm_vcpu *vcpu)
>  {
> -       return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run=
->msr.error);
> +       return KVM_X86_CALL(complete_emulated_msr, vcpu, vcpu->run->msr.e=
rror);
>  }
>
>  static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
> @@ -2072,7 +2072,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>                 trace_kvm_msr_read_ex(ecx);
>         }
>
> -       return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
> +       return KVM_X86_CALL(complete_emulated_msr, vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
>
> @@ -2097,7 +2097,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>                 trace_kvm_msr_write_ex(ecx, data);
>         }
>
> -       return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
> +       return KVM_X86_CALL(complete_emulated_msr, vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>
> @@ -2625,12 +2625,12 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_=
vcpu *vcpu, u64 l1_offset)
>         if (is_guest_mode(vcpu))
>                 vcpu->arch.tsc_offset =3D kvm_calc_nested_tsc_offset(
>                         l1_offset,
> -                       static_call(kvm_x86_get_l2_tsc_offset)(vcpu),
> -                       static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu))=
;
> +                       KVM_X86_CALL(get_l2_tsc_offset, vcpu),
> +                       KVM_X86_CALL(get_l2_tsc_multiplier, vcpu));
>         else
>                 vcpu->arch.tsc_offset =3D l1_offset;
>
> -       static_call(kvm_x86_write_tsc_offset)(vcpu);
> +       KVM_X86_CALL(write_tsc_offset, vcpu);
>  }
>
>  static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_=
multiplier)
> @@ -2641,12 +2641,12 @@ static void kvm_vcpu_write_tsc_multiplier(struct =
kvm_vcpu *vcpu, u64 l1_multipli
>         if (is_guest_mode(vcpu))
>                 vcpu->arch.tsc_scaling_ratio =3D kvm_calc_nested_tsc_mult=
iplier(
>                         l1_multiplier,
> -                       static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu))=
;
> +                       KVM_X86_CALL(get_l2_tsc_multiplier, vcpu));
>         else
>                 vcpu->arch.tsc_scaling_ratio =3D l1_multiplier;
>
>         if (kvm_caps.has_tsc_control)
> -               static_call(kvm_x86_write_tsc_multiplier)(vcpu);
> +               KVM_X86_CALL(write_tsc_multiplier, vcpu);
>  }
>
>  static inline bool kvm_check_tsc_unstable(void)
> @@ -3619,7 +3619,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
>         ++vcpu->stat.tlb_flush;
> -       static_call(kvm_x86_flush_tlb_all)(vcpu);
> +       KVM_X86_CALL(flush_tlb_all, vcpu);
>
>         /* Flushing all ASIDs flushes the current ASID... */
>         kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> @@ -3640,7 +3640,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcp=
u *vcpu)
>                 kvm_mmu_sync_prev_roots(vcpu);
>         }
>
> -       static_call(kvm_x86_flush_tlb_guest)(vcpu);
> +       KVM_X86_CALL(flush_tlb_guest, vcpu);
>
>         /*
>          * Flushing all "guest" TLB is always a superset of Hyper-V's fin=
e
> @@ -3653,7 +3653,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcp=
u *vcpu)
>  static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>  {
>         ++vcpu->stat.tlb_flush;
> -       static_call(kvm_x86_flush_tlb_current)(vcpu);
> +       KVM_X86_CALL(flush_tlb_current, vcpu);
>  }
>
>  /*
> @@ -4764,7 +4764,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>                  * fringe case that is not enabled except via specific se=
ttings
>                  * of the module parameters.
>                  */
> -               r =3D static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32=
_SMBASE);
> +               r =3D KVM_X86_CALL(has_emulated_msr, kvm, MSR_IA32_SMBASE=
);
>                 break;
>         case KVM_CAP_NR_VCPUS:
>                 r =3D min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPU=
S);
> @@ -5012,14 +5012,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, in=
t cpu)
>  {
>         /* Address WBINVD may be executed by guest */
>         if (need_emulate_wbinvd(vcpu)) {
> -               if (static_call(kvm_x86_has_wbinvd_exit)())
> +               if (KVM_X86_CALL(has_wbinvd_exit))
>                         cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask=
);
>                 else if (vcpu->cpu !=3D -1 && vcpu->cpu !=3D cpu)
>                         smp_call_function_single(vcpu->cpu,
>                                         wbinvd_ipi, NULL, 1);
>         }
>
> -       static_call(kvm_x86_vcpu_load)(vcpu, cpu);
> +       KVM_X86_CALL(vcpu_load, vcpu, cpu);
>
>         /* Save host pkru register if supported */
>         vcpu->arch.host_pkru =3D read_pkru();
> @@ -5127,14 +5127,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>                 srcu_read_unlock(&vcpu->kvm->srcu, idx);
>         }
>
> -       static_call(kvm_x86_vcpu_put)(vcpu);
> +       KVM_X86_CALL(vcpu_put, vcpu);
>         vcpu->arch.last_host_tsc =3D rdtsc();
>  }
>
>  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
>                                     struct kvm_lapic_state *s)
>  {
> -       static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +       KVM_X86_CALL(sync_pir_to_irr, vcpu);
>
>         return kvm_apic_get_state(vcpu, s);
>  }
> @@ -5251,7 +5251,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_=
vcpu *vcpu,
>
>         kvm_apic_after_set_mcg_cap(vcpu);
>
> -       static_call(kvm_x86_setup_mce)(vcpu);
> +       KVM_X86_CALL(setup_mce, vcpu);
>  out:
>         return r;
>  }
> @@ -5411,11 +5411,11 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(st=
ruct kvm_vcpu *vcpu,
>         events->interrupt.injected =3D
>                 vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.so=
ft;
>         events->interrupt.nr =3D vcpu->arch.interrupt.nr;
> -       events->interrupt.shadow =3D static_call(kvm_x86_get_interrupt_sh=
adow)(vcpu);
> +       events->interrupt.shadow =3D KVM_X86_CALL(get_interrupt_shadow, v=
cpu);
>
>         events->nmi.injected =3D vcpu->arch.nmi_injected;
>         events->nmi.pending =3D kvm_get_nr_pending_nmis(vcpu);
> -       events->nmi.masked =3D static_call(kvm_x86_get_nmi_mask)(vcpu);
> +       events->nmi.masked =3D KVM_X86_CALL(get_nmi_mask, vcpu);
>
>         /* events->sipi_vector is never valid when reporting to user spac=
e */
>
> @@ -5497,8 +5497,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struc=
t kvm_vcpu *vcpu,
>         vcpu->arch.interrupt.nr =3D events->interrupt.nr;
>         vcpu->arch.interrupt.soft =3D events->interrupt.soft;
>         if (events->flags & KVM_VCPUEVENT_VALID_SHADOW)
> -               static_call(kvm_x86_set_interrupt_shadow)(vcpu,
> -                                               events->interrupt.shadow)=
;
> +               KVM_X86_CALL(set_interrupt_shadow,
> +                            vcpu, events->interrupt.shadow);
>
>         vcpu->arch.nmi_injected =3D events->nmi.injected;
>         if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> @@ -5507,7 +5507,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struc=
t kvm_vcpu *vcpu,
>                 if (events->nmi.pending)
>                         kvm_make_request(KVM_REQ_NMI, vcpu);
>         }
> -       static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> +       KVM_X86_CALL(set_nmi_mask, vcpu, events->nmi.masked);
>
>         if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
>             lapic_in_kernel(vcpu))
> @@ -5842,7 +5842,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcp=
u *vcpu,
>                 if (!kvm_x86_ops.enable_l2_tlb_flush)
>                         return -ENOTTY;
>
> -               return static_call(kvm_x86_enable_l2_tlb_flush)(vcpu);
> +               return KVM_X86_CALL(enable_l2_tlb_flush, vcpu);
>
>         case KVM_CAP_HYPERV_ENFORCE_CPUID:
>                 return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
> @@ -6314,14 +6314,14 @@ static int kvm_vm_ioctl_set_tss_addr(struct kvm *=
kvm, unsigned long addr)
>
>         if (addr > (unsigned int)(-3 * PAGE_SIZE))
>                 return -EINVAL;
> -       ret =3D static_call(kvm_x86_set_tss_addr)(kvm, addr);
> +       ret =3D KVM_X86_CALL(set_tss_addr, kvm, addr);
>         return ret;
>  }
>
>  static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
>                                               u64 ident_addr)
>  {
> -       return static_call(kvm_x86_set_identity_map_addr)(kvm, ident_addr=
);
> +       return KVM_X86_CALL(set_identity_map_addr, kvm, ident_addr);
>  }
>
>  static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
> @@ -6634,14 +6634,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 if (!kvm_x86_ops.vm_copy_enc_context_from)
>                         break;
>
> -               r =3D static_call(kvm_x86_vm_copy_enc_context_from)(kvm, =
cap->args[0]);
> +               r =3D KVM_X86_CALL(vm_copy_enc_context_from, kvm, cap->ar=
gs[0]);
>                 break;
>         case KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM:
>                 r =3D -EINVAL;
>                 if (!kvm_x86_ops.vm_move_enc_context_from)
>                         break;
>
> -               r =3D static_call(kvm_x86_vm_move_enc_context_from)(kvm, =
cap->args[0]);
> +               r =3D KVM_X86_CALL(vm_move_enc_context_from, kvm, cap->ar=
gs[0]);
>                 break;
>         case KVM_CAP_EXIT_HYPERCALL:
>                 if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
> @@ -7273,7 +7273,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>                 if (!kvm_x86_ops.mem_enc_ioctl)
>                         goto out;
>
> -               r =3D static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
> +               r =3D KVM_X86_CALL(mem_enc_ioctl, kvm, argp);
>                 break;
>         }
>         case KVM_MEMORY_ENCRYPT_REG_REGION: {
> @@ -7287,7 +7287,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>                 if (!kvm_x86_ops.mem_enc_register_region)
>                         goto out;
>
> -               r =3D static_call(kvm_x86_mem_enc_register_region)(kvm, &=
region);
> +               r =3D KVM_X86_CALL(mem_enc_register_region, kvm, &region)=
;
>                 break;
>         }
>         case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
> @@ -7301,7 +7301,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>                 if (!kvm_x86_ops.mem_enc_unregister_region)
>                         goto out;
>
> -               r =3D static_call(kvm_x86_mem_enc_unregister_region)(kvm,=
 &region);
> +               r =3D KVM_X86_CALL(mem_enc_unregister_region,
> +                                kvm, &region);
>                 break;
>         }
>  #ifdef CONFIG_KVM_HYPERV
> @@ -7452,7 +7453,8 @@ static void kvm_init_msr_lists(void)
>         }
>
>         for (i =3D 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
> -               if (!static_call(kvm_x86_has_emulated_msr)(NULL, emulated=
_msrs_all[i]))
> +               if (!KVM_X86_CALL(has_emulated_msr,
> +                                 NULL, emulated_msrs_all[i]))
>                         continue;
>
>                 emulated_msrs[num_emulated_msrs++] =3D emulated_msrs_all[=
i];
> @@ -7511,13 +7513,13 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, =
gpa_t addr, int len, void *v)
>  void kvm_set_segment(struct kvm_vcpu *vcpu,
>                      struct kvm_segment *var, int seg)
>  {
> -       static_call(kvm_x86_set_segment)(vcpu, var, seg);
> +       KVM_X86_CALL(set_segment, vcpu, var, seg);
>  }
>
>  void kvm_get_segment(struct kvm_vcpu *vcpu,
>                      struct kvm_segment *var, int seg)
>  {
> -       static_call(kvm_x86_get_segment)(vcpu, var, seg);
> +       KVM_X86_CALL(get_segment, vcpu, var, seg);
>  }
>
>  gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u64 access,
> @@ -7540,7 +7542,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu=
, gva_t gva,
>  {
>         struct kvm_mmu *mmu =3D vcpu->arch.walk_mmu;
>
> -       u64 access =3D (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3) ? PF=
ERR_USER_MASK : 0;
> +       u64 access =3D (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3) ? PFERR_USE=
R_MASK : 0;
>         return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
> @@ -7550,7 +7552,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcp=
u, gva_t gva,
>  {
>         struct kvm_mmu *mmu =3D vcpu->arch.walk_mmu;
>
> -       u64 access =3D (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3) ? PF=
ERR_USER_MASK : 0;
> +       u64 access =3D (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3) ? PFERR_USE=
R_MASK : 0;
>         access |=3D PFERR_WRITE_MASK;
>         return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
>  }
> @@ -7603,7 +7605,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_=
ctxt *ctxt,
>  {
>         struct kvm_vcpu *vcpu =3D emul_to_vcpu(ctxt);
>         struct kvm_mmu *mmu =3D vcpu->arch.walk_mmu;
> -       u64 access =3D (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3) ? PF=
ERR_USER_MASK : 0;
> +       u64 access =3D (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3) ? PFERR_USE=
R_MASK : 0;
>         unsigned offset;
>         int ret;
>
> @@ -7628,7 +7630,7 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>                                gva_t addr, void *val, unsigned int bytes,
>                                struct x86_exception *exception)
>  {
> -       u64 access =3D (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3) ? PF=
ERR_USER_MASK : 0;
> +       u64 access =3D (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3) ? PFERR_USE=
R_MASK : 0;
>
>         /*
>          * FIXME: this should call handle_emulation_failure if X86EMUL_IO=
_NEEDED
> @@ -7651,7 +7653,7 @@ static int emulator_read_std(struct x86_emulate_ctx=
t *ctxt,
>
>         if (system)
>                 access |=3D PFERR_IMPLICIT_ACCESS;
> -       else if (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3)
> +       else if (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3)
>                 access |=3D PFERR_USER_MASK;
>
>         return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,=
 exception);
> @@ -7696,7 +7698,7 @@ static int emulator_write_std(struct x86_emulate_ct=
xt *ctxt, gva_t addr, void *v
>
>         if (system)
>                 access |=3D PFERR_IMPLICIT_ACCESS;
> -       else if (static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3)
> +       else if (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3)
>                 access |=3D PFERR_USER_MASK;
>
>         return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> @@ -7717,8 +7719,8 @@ EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>  static int kvm_check_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
>                                   void *insn, int insn_len)
>  {
> -       return static_call(kvm_x86_check_emulate_instruction)(vcpu, emul_=
type,
> -                                                             insn, insn_=
len);
> +       return KVM_X86_CALL(check_emulate_instruction,
> +                           vcpu, emul_type, insn, insn_len);
>  }
>
>  int handle_ud(struct kvm_vcpu *vcpu)
> @@ -7768,8 +7770,9 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vc=
pu, unsigned long gva,
>                                 bool write)
>  {
>         struct kvm_mmu *mmu =3D vcpu->arch.walk_mmu;
> -       u64 access =3D ((static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 3) ? P=
FERR_USER_MASK : 0)
> -               | (write ? PFERR_WRITE_MASK : 0);
> +       u64 access =3D (KVM_X86_CALL(get_cpl, vcpu) =3D=3D 3) ? PFERR_USE=
R_MASK : 0;
> +
> +       access |=3D (write ? PFERR_WRITE_MASK : 0);
>
>         /*
>          * currently PKRU is only applied to ept enabled guest so
> @@ -8195,7 +8198,7 @@ static int emulator_pio_out_emulated(struct x86_emu=
late_ctxt *ctxt,
>
>  static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
>  {
> -       return static_call(kvm_x86_get_segment_base)(vcpu, seg);
> +       return KVM_X86_CALL(get_segment_base, vcpu, seg);
>  }
>
>  static void emulator_invlpg(struct x86_emulate_ctxt *ctxt, ulong address=
)
> @@ -8208,7 +8211,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcp=
u *vcpu)
>         if (!need_emulate_wbinvd(vcpu))
>                 return X86EMUL_CONTINUE;
>
> -       if (static_call(kvm_x86_has_wbinvd_exit)()) {
> +       if (KVM_X86_CALL(has_wbinvd_exit)) {
>                 int cpu =3D get_cpu();
>
>                 cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
> @@ -8312,27 +8315,27 @@ static int emulator_set_cr(struct x86_emulate_ctx=
t *ctxt, int cr, ulong val)
>
>  static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
>  {
> -       return static_call(kvm_x86_get_cpl)(emul_to_vcpu(ctxt));
> +       return KVM_X86_CALL(get_cpl, emul_to_vcpu(ctxt));
>  }
>
>  static void emulator_get_gdt(struct x86_emulate_ctxt *ctxt, struct desc_=
ptr *dt)
>  {
> -       static_call(kvm_x86_get_gdt)(emul_to_vcpu(ctxt), dt);
> +       KVM_X86_CALL(get_gdt, emul_to_vcpu(ctxt), dt);
>  }
>
>  static void emulator_get_idt(struct x86_emulate_ctxt *ctxt, struct desc_=
ptr *dt)
>  {
> -       static_call(kvm_x86_get_idt)(emul_to_vcpu(ctxt), dt);
> +       KVM_X86_CALL(get_idt, emul_to_vcpu(ctxt), dt);
>  }
>
>  static void emulator_set_gdt(struct x86_emulate_ctxt *ctxt, struct desc_=
ptr *dt)
>  {
> -       static_call(kvm_x86_set_gdt)(emul_to_vcpu(ctxt), dt);
> +       KVM_X86_CALL(set_gdt, emul_to_vcpu(ctxt), dt);
>  }
>
>  static void emulator_set_idt(struct x86_emulate_ctxt *ctxt, struct desc_=
ptr *dt)
>  {
> -       static_call(kvm_x86_set_idt)(emul_to_vcpu(ctxt), dt);
> +       KVM_X86_CALL(set_idt, emul_to_vcpu(ctxt), dt);
>  }
>
>  static unsigned long emulator_get_cached_segment_base(
> @@ -8479,8 +8482,8 @@ static int emulator_intercept(struct x86_emulate_ct=
xt *ctxt,
>                               struct x86_instruction_info *info,
>                               enum x86_intercept_stage stage)
>  {
> -       return static_call(kvm_x86_check_intercept)(emul_to_vcpu(ctxt), i=
nfo, stage,
> -                                           &ctxt->exception);
> +       return KVM_X86_CALL(check_intercept,
> +                           emul_to_vcpu(ctxt), info, stage, &ctxt->excep=
tion);
>  }
>
>  static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
> @@ -8517,7 +8520,7 @@ static void emulator_write_gpr(struct x86_emulate_c=
txt *ctxt, unsigned reg, ulon
>
>  static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool ma=
sked)
>  {
> -       static_call(kvm_x86_set_nmi_mask)(emul_to_vcpu(ctxt), masked);
> +       KVM_X86_CALL(set_nmi_mask, emul_to_vcpu(ctxt), masked);
>  }
>
>  static bool emulator_is_smm(struct x86_emulate_ctxt *ctxt)
> @@ -8562,7 +8565,8 @@ static gva_t emulator_get_untagged_addr(struct x86_=
emulate_ctxt *ctxt,
>         if (!kvm_x86_ops.get_untagged_addr)
>                 return addr;
>
> -       return static_call(kvm_x86_get_untagged_addr)(emul_to_vcpu(ctxt),=
 addr, flags);
> +       return KVM_X86_CALL(get_untagged_addr,
> +                           emul_to_vcpu(ctxt), addr, flags);
>  }
>
>  static const struct x86_emulate_ops emulate_ops =3D {
> @@ -8614,7 +8618,7 @@ static const struct x86_emulate_ops emulate_ops =3D=
 {
>
>  static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  {
> -       u32 int_shadow =3D static_call(kvm_x86_get_interrupt_shadow)(vcpu=
);
> +       u32 int_shadow =3D KVM_X86_CALL(get_interrupt_shadow, vcpu);
>         /*
>          * an sti; sti; sequence only disable interrupts for the first
>          * instruction. So, if the last instruction, be it emulated or
> @@ -8625,7 +8629,7 @@ static void toggle_interruptibility(struct kvm_vcpu=
 *vcpu, u32 mask)
>         if (int_shadow & mask)
>                 mask =3D 0;
>         if (unlikely(int_shadow || mask)) {
> -               static_call(kvm_x86_set_interrupt_shadow)(vcpu, mask);
> +               KVM_X86_CALL(set_interrupt_shadow, vcpu, mask);
>                 if (!mask)
>                         kvm_make_request(KVM_REQ_EVENT, vcpu);
>         }
> @@ -8666,7 +8670,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu=
)
>         struct x86_emulate_ctxt *ctxt =3D vcpu->arch.emulate_ctxt;
>         int cs_db, cs_l;
>
> -       static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
> +       KVM_X86_CALL(get_cs_db_l_bits, vcpu, &cs_db, &cs_l);
>
>         ctxt->gpa_available =3D false;
>         ctxt->eflags =3D kvm_get_rflags(vcpu);
> @@ -8722,9 +8726,8 @@ static void prepare_emulation_failure_exit(struct k=
vm_vcpu *vcpu, u64 *data,
>          */
>         memset(&info, 0, sizeof(info));
>
> -       static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1=
],
> -                                          &info[2], (u32 *)&info[3],
> -                                          (u32 *)&info[4]);
> +       KVM_X86_CALL(get_exit_info, vcpu, (u32 *)&info[0], &info[1],
> +                    &info[2], (u32 *)&info[3], (u32 *)&info[4]);
>
>         run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>         run->emulation_failure.suberror =3D KVM_INTERNAL_ERROR_EMULATION;
> @@ -8801,7 +8804,7 @@ static int handle_emulation_failure(struct kvm_vcpu=
 *vcpu, int emulation_type)
>
>         kvm_queue_exception(vcpu, UD_VECTOR);
>
> -       if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) =
=3D=3D 0) {
> +       if (!is_guest_mode(vcpu) && KVM_X86_CALL(get_cpl, vcpu) =3D=3D 0)=
 {
>                 prepare_emulation_ctxt_failure_exit(vcpu);
>                 return 0;
>         }
> @@ -8959,10 +8962,10 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu=
 *vcpu)
>
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
> -       unsigned long rflags =3D static_call(kvm_x86_get_rflags)(vcpu);
> +       unsigned long rflags =3D KVM_X86_CALL(get_rflags, vcpu);
>         int r;
>
> -       r =3D static_call(kvm_x86_skip_emulated_instruction)(vcpu);
> +       r =3D KVM_X86_CALL(skip_emulated_instruction, vcpu);
>         if (unlikely(!r))
>                 return 0;
>
> @@ -8994,7 +8997,7 @@ static bool kvm_is_code_breakpoint_inhibited(struct=
 kvm_vcpu *vcpu)
>          * but AMD CPUs do not.  MOV/POP SS blocking is rare, check that =
first
>          * to avoid the relatively expensive CPUID lookup.
>          */
> -       shadow =3D static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +       shadow =3D KVM_X86_CALL(get_interrupt_shadow, vcpu);
>         return (shadow & KVM_X86_SHADOW_INT_MOV_SS) &&
>                guest_cpuid_is_intel(vcpu);
>  }
> @@ -9268,7 +9271,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, =
gpa_t cr2_or_gpa,
>
>  writeback:
>         if (writeback) {
> -               unsigned long rflags =3D static_call(kvm_x86_get_rflags)(=
vcpu);
> +               unsigned long rflags =3D KVM_X86_CALL(get_rflags, vcpu);
>                 toggle_interruptibility(vcpu, ctxt->interruptibility);
>                 vcpu->arch.emulate_regs_need_sync_to_vcpu =3D false;
>
> @@ -9285,7 +9288,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, =
gpa_t cr2_or_gpa,
>                         kvm_rip_write(vcpu, ctxt->eip);
>                         if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GU=
ESTDBG_SINGLESTEP)))
>                                 r =3D kvm_vcpu_do_singlestep(vcpu);
> -                       static_call(kvm_x86_update_emulated_instruction)(=
vcpu);
> +                       KVM_X86_CALL(update_emulated_instruction, vcpu);
>                         __kvm_set_rflags(vcpu, ctxt->eflags);
>                 }
>
> @@ -9684,7 +9687,7 @@ static int kvm_x86_check_processor_compatibility(vo=
id)
>             __cr4_reserved_bits(cpu_has, &boot_cpu_data))
>                 return -EIO;
>
> -       return static_call(kvm_x86_check_processor_compatibility)();
> +       return KVM_X86_CALL(check_processor_compatibility);
>  }
>
>  static void kvm_x86_check_cpu_compat(void *ret)
> @@ -9819,7 +9822,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *op=
s)
>
>  out_unwind_ops:
>         kvm_x86_ops.hardware_enable =3D NULL;
> -       static_call(kvm_x86_hardware_unsetup)();
> +       KVM_X86_CALL(hardware_unsetup);
>  out_mmu_exit:
>         kvm_mmu_vendor_module_exit();
>  out_free_percpu:
> @@ -9850,7 +9853,7 @@ void kvm_x86_vendor_exit(void)
>         irq_work_sync(&pvclock_irq_work);
>         cancel_work_sync(&pvclock_gtod_work);
>  #endif
> -       static_call(kvm_x86_hardware_unsetup)();
> +       KVM_X86_CALL(hardware_unsetup);
>         kvm_mmu_vendor_module_exit();
>         free_percpu(user_return_msrs);
>         kmem_cache_destroy(x86_emulator_cache);
> @@ -9976,7 +9979,8 @@ EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>  bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
>  {
>         ulong vm_reasons =3D READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reas=
ons);
> -       ulong vcpu_reasons =3D static_call(kvm_x86_vcpu_get_apicv_inhibit=
_reasons)(vcpu);
> +       ulong vcpu_reasons =3D
> +               KVM_X86_CALL(vcpu_get_apicv_inhibit_reasons, vcpu);
>
>         return (vm_reasons | vcpu_reasons) =3D=3D 0;
>  }
> @@ -10079,7 +10083,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 a3 &=3D 0xFFFFFFFF;
>         }
>
> -       if (static_call(kvm_x86_get_cpl)(vcpu) !=3D 0) {
> +       if (KVM_X86_CALL(get_cpl, vcpu) !=3D 0) {
>                 ret =3D -KVM_EPERM;
>                 goto out;
>         }
> @@ -10173,7 +10177,7 @@ static int emulator_fix_hypercall(struct x86_emul=
ate_ctxt *ctxt)
>                 return X86EMUL_PROPAGATE_FAULT;
>         }
>
> -       static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
> +       KVM_X86_CALL(patch_hypercall, vcpu, instruction);
>
>         return emulator_write_emulated(ctxt, rip, instruction, 3,
>                 &ctxt->exception);
> @@ -10190,7 +10194,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vc=
pu)
>  {
>         struct kvm_run *kvm_run =3D vcpu->run;
>
> -       kvm_run->if_flag =3D static_call(kvm_x86_get_if_flag)(vcpu);
> +       kvm_run->if_flag =3D KVM_X86_CALL(get_if_flag, vcpu);
>         kvm_run->cr8 =3D kvm_get_cr8(vcpu);
>         kvm_run->apic_base =3D kvm_get_apic_base(vcpu);
>
> @@ -10225,7 +10229,7 @@ static void update_cr8_intercept(struct kvm_vcpu =
*vcpu)
>
>         tpr =3D kvm_lapic_get_cr8(vcpu);
>
> -       static_call(kvm_x86_update_cr8_intercept)(vcpu, tpr, max_irr);
> +       KVM_X86_CALL(update_cr8_intercept, vcpu, tpr, max_irr);
>  }
>
>
> @@ -10255,7 +10259,7 @@ static void kvm_inject_exception(struct kvm_vcpu =
*vcpu)
>                                 vcpu->arch.exception.error_code,
>                                 vcpu->arch.exception.injected);
>
> -       static_call(kvm_x86_inject_exception)(vcpu);
> +       KVM_X86_CALL(inject_exception, vcpu);
>  }
>
>  /*
> @@ -10341,9 +10345,9 @@ static int kvm_check_and_inject_events(struct kvm=
_vcpu *vcpu,
>         else if (kvm_is_exception_pending(vcpu))
>                 ; /* see above */
>         else if (vcpu->arch.nmi_injected)
> -               static_call(kvm_x86_inject_nmi)(vcpu);
> +               KVM_X86_CALL(inject_nmi, vcpu);
>         else if (vcpu->arch.interrupt.injected)
> -               static_call(kvm_x86_inject_irq)(vcpu, true);
> +               KVM_X86_CALL(inject_irq, vcpu, true);
>
>         /*
>          * Exceptions that morph to VM-Exits are handled above, and pendi=
ng
> @@ -10428,7 +10432,8 @@ static int kvm_check_and_inject_events(struct kvm=
_vcpu *vcpu,
>          */
>  #ifdef CONFIG_KVM_SMM
>         if (vcpu->arch.smi_pending) {
> -               r =3D can_inject ? static_call(kvm_x86_smi_allowed)(vcpu,=
 true) : -EBUSY;
> +               r =3D can_inject ? KVM_X86_CALL(smi_allowed, vcpu, true) =
:
> +                                -EBUSY;
>                 if (r < 0)
>                         goto out;
>                 if (r) {
> @@ -10437,27 +10442,29 @@ static int kvm_check_and_inject_events(struct k=
vm_vcpu *vcpu,
>                         enter_smm(vcpu);
>                         can_inject =3D false;
>                 } else
> -                       static_call(kvm_x86_enable_smi_window)(vcpu);
> +                       KVM_X86_CALL(enable_smi_window, vcpu);
>         }
>  #endif
>
>         if (vcpu->arch.nmi_pending) {
> -               r =3D can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu,=
 true) : -EBUSY;
> +               r =3D can_inject ? KVM_X86_CALL(nmi_allowed, vcpu, true) =
:
> +                                -EBUSY;
>                 if (r < 0)
>                         goto out;
>                 if (r) {
>                         --vcpu->arch.nmi_pending;
>                         vcpu->arch.nmi_injected =3D true;
> -                       static_call(kvm_x86_inject_nmi)(vcpu);
> +                       KVM_X86_CALL(inject_nmi, vcpu);
>                         can_inject =3D false;
> -                       WARN_ON(static_call(kvm_x86_nmi_allowed)(vcpu, tr=
ue) < 0);
> +                       WARN_ON(KVM_X86_CALL(nmi_allowed, vcpu, true) < 0=
);
>                 }
>                 if (vcpu->arch.nmi_pending)
> -                       static_call(kvm_x86_enable_nmi_window)(vcpu);
> +                       KVM_X86_CALL(enable_nmi_window, vcpu);
>         }
>
>         if (kvm_cpu_has_injectable_intr(vcpu)) {
> -               r =3D can_inject ? static_call(kvm_x86_interrupt_allowed)=
(vcpu, true) : -EBUSY;
> +               r =3D can_inject ? KVM_X86_CALL(interrupt_allowed, vcpu, =
true) :
> +                                -EBUSY;
>                 if (r < 0)
>                         goto out;
>                 if (r) {
> @@ -10465,12 +10472,13 @@ static int kvm_check_and_inject_events(struct k=
vm_vcpu *vcpu,
>
>                         if (!WARN_ON_ONCE(irq =3D=3D -1)) {
>                                 kvm_queue_interrupt(vcpu, irq, false);
> -                               static_call(kvm_x86_inject_irq)(vcpu, fal=
se);
> -                               WARN_ON(static_call(kvm_x86_interrupt_all=
owed)(vcpu, true) < 0);
> +                               KVM_X86_CALL(inject_irq, vcpu, false);
> +                               WARN_ON(KVM_X86_CALL(interrupt_allowed,
> +                                                    vcpu, true) < 0);
>                         }
>                 }
>                 if (kvm_cpu_has_injectable_intr(vcpu))
> -                       static_call(kvm_x86_enable_irq_window)(vcpu);
> +                       KVM_X86_CALL(enable_irq_window, vcpu);
>         }
>
>         if (is_guest_mode(vcpu) &&
> @@ -10516,7 +10524,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>          * blocks NMIs).  KVM will immediately inject one of the two NMIs=
, and
>          * will request an NMI window to handle the second NMI.
>          */
> -       if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_inj=
ected)
> +       if (KVM_X86_CALL(get_nmi_mask, vcpu) || vcpu->arch.nmi_injected)
>                 limit =3D 1;
>         else
>                 limit =3D 2;
> @@ -10525,14 +10533,14 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>          * Adjust the limit to account for pending virtual NMIs, which ar=
en't
>          * tracked in vcpu->arch.nmi_pending.
>          */
> -       if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
> +       if (KVM_X86_CALL(is_vnmi_pending, vcpu))
>                 limit--;
>
>         vcpu->arch.nmi_pending +=3D atomic_xchg(&vcpu->arch.nmi_queued, 0=
);
>         vcpu->arch.nmi_pending =3D min(vcpu->arch.nmi_pending, limit);
>
>         if (vcpu->arch.nmi_pending &&
> -           (static_call(kvm_x86_set_vnmi_pending)(vcpu)))
> +           (KVM_X86_CALL(set_vnmi_pending, vcpu)))
>                 vcpu->arch.nmi_pending--;
>
>         if (vcpu->arch.nmi_pending)
> @@ -10542,8 +10550,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>  /* Return total number of NMIs pending injection to the VM */
>  int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu)
>  {
> -       return vcpu->arch.nmi_pending +
> -              static_call(kvm_x86_is_vnmi_pending)(vcpu);
> +       return vcpu->arch.nmi_pending + KVM_X86_CALL(is_vnmi_pending, vcp=
u);
>  }
>
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
> @@ -10577,7 +10584,7 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcp=
u)
>
>         apic->apicv_active =3D activate;
>         kvm_apic_update_apicv(vcpu);
> -       static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
> +       KVM_X86_CALL(refresh_apicv_exec_ctrl, vcpu);
>
>         /*
>          * When APICv gets disabled, we may still have injected interrupt=
s
> @@ -10680,7 +10687,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcp=
u)
>         if (irqchip_split(vcpu->kvm))
>                 kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_ve=
ctors);
>         else {
> -               static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +               KVM_X86_CALL(sync_pir_to_irr, vcpu);
>                 if (ioapic_in_kernel(vcpu->kvm))
>                         kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_han=
dled_vectors);
>         }
> @@ -10703,17 +10710,17 @@ static void vcpu_load_eoi_exitmap(struct kvm_vc=
pu *vcpu)
>                 bitmap_or((ulong *)eoi_exit_bitmap,
>                           vcpu->arch.ioapic_handled_vectors,
>                           to_hv_synic(vcpu)->vec_bitmap, 256);
> -               static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitm=
ap);
> +               KVM_X86_CALL(load_eoi_exitmap, vcpu, eoi_exit_bitmap);
>                 return;
>         }
>  #endif
> -       static_call(kvm_x86_load_eoi_exitmap)(
> -               vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
> +       KVM_X86_CALL(load_eoi_exitmap, vcpu,
> +                    (u64 *)vcpu->arch.ioapic_handled_vectors);
>  }
>
>  void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
>  {
> -       static_call(kvm_x86_guest_memory_reclaimed)(kvm);
> +       KVM_X86_CALL(guest_memory_reclaimed, kvm);
>  }
>
>  static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> @@ -10721,7 +10728,7 @@ static void kvm_vcpu_reload_apic_access_page(stru=
ct kvm_vcpu *vcpu)
>         if (!lapic_in_kernel(vcpu))
>                 return;
>
> -       static_call(kvm_x86_set_apic_access_page_addr)(vcpu);
> +       KVM_X86_CALL(set_apic_access_page_addr, vcpu);
>  }
>
>  /*
> @@ -10885,10 +10892,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>                 if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>                         kvm_check_async_pf_completion(vcpu);
>                 if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
> -                       static_call(kvm_x86_msr_filter_changed)(vcpu);
> +                       KVM_X86_CALL(msr_filter_changed, vcpu);
>
>                 if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, v=
cpu))
> -                       static_call(kvm_x86_update_cpu_dirty_logging)(vcp=
u);
> +                       KVM_X86_CALL(update_cpu_dirty_logging, vcpu);
>         }
>
>         if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> @@ -10910,7 +10917,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>                         goto out;
>                 }
>                 if (req_int_win)
> -                       static_call(kvm_x86_enable_irq_window)(vcpu);
> +                       KVM_X86_CALL(enable_irq_window, vcpu);
>
>                 if (kvm_lapic_enabled(vcpu)) {
>                         update_cr8_intercept(vcpu);
> @@ -10925,7 +10932,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>
>         preempt_disable();
>
> -       static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
> +       KVM_X86_CALL(prepare_switch_to_guest, vcpu);
>
>         /*
>          * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
> @@ -10961,7 +10968,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>          * i.e. they can post interrupts even if APICv is temporarily dis=
abled.
>          */
>         if (kvm_lapic_enabled(vcpu))
> -               static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +               KVM_X86_CALL(sync_pir_to_irr, vcpu);
>
>         if (kvm_vcpu_exit_request(vcpu)) {
>                 vcpu->mode =3D OUTSIDE_GUEST_MODE;
> @@ -11005,12 +11012,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>                 WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) !=3D kvm_vcp=
u_apicv_active(vcpu)) &&
>                              (kvm_get_apic_mode(vcpu) !=3D LAPIC_MODE_DIS=
ABLED));
>
> -               exit_fastpath =3D static_call(kvm_x86_vcpu_run)(vcpu, req=
_immediate_exit);
> +               exit_fastpath =3D KVM_X86_CALL(vcpu_run,
> +                                            vcpu, req_immediate_exit);
>                 if (likely(exit_fastpath !=3D EXIT_FASTPATH_REENTER_GUEST=
))
>                         break;
>
>                 if (kvm_lapic_enabled(vcpu))
> -                       static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +                       KVM_X86_CALL(sync_pir_to_irr, vcpu);
>
>                 if (unlikely(kvm_vcpu_exit_request(vcpu))) {
>                         exit_fastpath =3D EXIT_FASTPATH_EXIT_HANDLED;
> @@ -11029,7 +11037,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>          */
>         if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))=
 {
>                 WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> -               static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
> +               KVM_X86_CALL(sync_dirty_debug_regs, vcpu);
>                 kvm_update_dr0123(vcpu);
>                 kvm_update_dr7(vcpu);
>         }
> @@ -11058,7 +11066,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>         if (vcpu->arch.xfd_no_write_intercept)
>                 fpu_sync_guest_vmexit_xfd_state();
>
> -       static_call(kvm_x86_handle_exit_irqoff)(vcpu);
> +       KVM_X86_CALL(handle_exit_irqoff, vcpu);
>
>         if (vcpu->arch.guest_fpu.xfd_err)
>                 wrmsrl(MSR_IA32_XFD_ERR, 0);
> @@ -11104,13 +11112,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>         if (vcpu->arch.apic_attention)
>                 kvm_lapic_sync_from_vapic(vcpu);
>
> -       r =3D static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
> +       r =3D KVM_X86_CALL(handle_exit, vcpu, exit_fastpath);
>         return r;
>
>  cancel_injection:
>         if (req_immediate_exit)
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
> -       static_call(kvm_x86_cancel_injection)(vcpu);
> +       KVM_X86_CALL(cancel_injection, vcpu);
>         if (unlikely(vcpu->arch.apic_attention))
>                 kvm_lapic_sync_from_vapic(vcpu);
>  out:
> @@ -11430,7 +11438,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
>                 goto out;
>         }
>
> -       r =3D static_call(kvm_x86_vcpu_pre_run)(vcpu);
> +       r =3D KVM_X86_CALL(vcpu_pre_run, vcpu);
>         if (r <=3D 0)
>                 goto out;
>
> @@ -11550,10 +11558,10 @@ static void __get_sregs_common(struct kvm_vcpu =
*vcpu, struct kvm_sregs *sregs)
>         kvm_get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
>         kvm_get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
>
> -       static_call(kvm_x86_get_idt)(vcpu, &dt);
> +       KVM_X86_CALL(get_idt, vcpu, &dt);
>         sregs->idt.limit =3D dt.size;
>         sregs->idt.base =3D dt.address;
> -       static_call(kvm_x86_get_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(get_gdt, vcpu, &dt);
>         sregs->gdt.limit =3D dt.size;
>         sregs->gdt.base =3D dt.address;
>
> @@ -11749,27 +11757,27 @@ static int __set_sregs_common(struct kvm_vcpu *=
vcpu, struct kvm_sregs *sregs,
>
>         dt.size =3D sregs->idt.limit;
>         dt.address =3D sregs->idt.base;
> -       static_call(kvm_x86_set_idt)(vcpu, &dt);
> +       KVM_X86_CALL(set_idt, vcpu, &dt);
>         dt.size =3D sregs->gdt.limit;
>         dt.address =3D sregs->gdt.base;
> -       static_call(kvm_x86_set_gdt)(vcpu, &dt);
> +       KVM_X86_CALL(set_gdt, vcpu, &dt);
>
>         vcpu->arch.cr2 =3D sregs->cr2;
>         *mmu_reset_needed |=3D kvm_read_cr3(vcpu) !=3D sregs->cr3;
>         vcpu->arch.cr3 =3D sregs->cr3;
>         kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> -       static_call(kvm_x86_post_set_cr3)(vcpu, sregs->cr3);
> +       KVM_X86_CALL(post_set_cr3, vcpu, sregs->cr3);
>
>         kvm_set_cr8(vcpu, sregs->cr8);
>
>         *mmu_reset_needed |=3D vcpu->arch.efer !=3D sregs->efer;
> -       static_call(kvm_x86_set_efer)(vcpu, sregs->efer);
> +       KVM_X86_CALL(set_efer, vcpu, sregs->efer);
>
>         *mmu_reset_needed |=3D kvm_read_cr0(vcpu) !=3D sregs->cr0;
> -       static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
> +       KVM_X86_CALL(set_cr0, vcpu, sregs->cr0);
>
>         *mmu_reset_needed |=3D kvm_read_cr4(vcpu) !=3D sregs->cr4;
> -       static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
> +       KVM_X86_CALL(set_cr4, vcpu, sregs->cr4);
>
>         if (update_pdptrs) {
>                 idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> @@ -11943,7 +11951,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kv=
m_vcpu *vcpu,
>          */
>         kvm_set_rflags(vcpu, rflags);
>
> -       static_call(kvm_x86_update_exception_bitmap)(vcpu);
> +       KVM_X86_CALL(update_exception_bitmap, vcpu);
>
>         kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
>
> @@ -12080,7 +12088,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsi=
gned int id)
>         if (id >=3D kvm->arch.max_vcpu_ids)
>                 return -EINVAL;
>
> -       return static_call(kvm_x86_vcpu_precreate)(kvm);
> +       return KVM_X86_CALL(vcpu_precreate, kvm);
>  }
>
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> @@ -12151,7 +12159,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.hv_root_tdp =3D INVALID_PAGE;
>  #endif
>
> -       r =3D static_call(kvm_x86_vcpu_create)(vcpu);
> +       r =3D KVM_X86_CALL(vcpu_create, vcpu);
>         if (r)
>                 goto free_guest_fpu;
>
> @@ -12209,7 +12217,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
>         kvmclock_reset(vcpu);
>
> -       static_call(kvm_x86_vcpu_free)(vcpu);
> +       KVM_X86_CALL(vcpu_free, vcpu);
>
>         kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
>         free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
> @@ -12327,7 +12335,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool i=
nit_event)
>         cpuid_0x1 =3D kvm_find_cpuid_entry(vcpu, 1);
>         kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
>
> -       static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> +       KVM_X86_CALL(vcpu_reset, vcpu, init_event);
>
>         kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>         kvm_rip_write(vcpu, 0xfff0);
> @@ -12346,10 +12354,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool=
 init_event)
>         else
>                 new_cr0 |=3D X86_CR0_NW | X86_CR0_CD;
>
> -       static_call(kvm_x86_set_cr0)(vcpu, new_cr0);
> -       static_call(kvm_x86_set_cr4)(vcpu, 0);
> -       static_call(kvm_x86_set_efer)(vcpu, 0);
> -       static_call(kvm_x86_update_exception_bitmap)(vcpu);
> +       KVM_X86_CALL(set_cr0, vcpu, new_cr0);
> +       KVM_X86_CALL(set_cr4, vcpu, 0);
> +       KVM_X86_CALL(set_efer, vcpu, 0);
> +       KVM_X86_CALL(update_exception_bitmap, vcpu);
>
>         /*
>          * On the standard CR0/CR4/EFER modification paths, there are sev=
eral
> @@ -12406,7 +12414,7 @@ int kvm_arch_hardware_enable(void)
>         if (ret)
>                 return ret;
>
> -       ret =3D static_call(kvm_x86_hardware_enable)();
> +       ret =3D KVM_X86_CALL(hardware_enable);
>         if (ret !=3D 0)
>                 return ret;
>
> @@ -12488,7 +12496,7 @@ int kvm_arch_hardware_enable(void)
>
>  void kvm_arch_hardware_disable(void)
>  {
> -       static_call(kvm_x86_hardware_disable)();
> +       KVM_X86_CALL(hardware_disable);
>         drop_user_return_notifiers();
>  }
>
> @@ -12511,7 +12519,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int=
 cpu)
>                 pmu->need_cleanup =3D true;
>                 kvm_make_request(KVM_REQ_PMU, vcpu);
>         }
> -       static_call(kvm_x86_sched_in)(vcpu, cpu);
> +       KVM_X86_CALL(sched_in, vcpu, cpu);
>  }
>
>  void kvm_arch_free_vm(struct kvm *kvm)
> @@ -12539,7 +12547,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>
>         kvm_mmu_init_vm(kvm);
>
> -       ret =3D static_call(kvm_x86_vm_init)(kvm);
> +       ret =3D KVM_X86_CALL(vm_init, kvm);
>         if (ret)
>                 goto out_uninit_mmu;
>
> @@ -12713,7 +12721,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>                 mutex_unlock(&kvm->slots_lock);
>         }
>         kvm_unload_vcpu_mmus(kvm);
> -       static_call(kvm_x86_vm_destroy)(kvm);
> +       KVM_X86_CALL(vm_destroy, kvm);
>         kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, =
&kvm->srcu, 1));
>         kvm_pic_destroy(kvm);
>         kvm_ioapic_destroy(kvm);
> @@ -13045,7 +13053,7 @@ void kvm_arch_commit_memory_region(struct kvm *kv=
m,
>  static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  {
>         return (is_guest_mode(vcpu) &&
> -               static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
> +               KVM_X86_CALL(guest_apic_has_interrupt, vcpu));
>  }
>
>  static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> @@ -13064,14 +13072,12 @@ static inline bool kvm_vcpu_has_events(struct k=
vm_vcpu *vcpu)
>                 return true;
>
>         if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
> -           (vcpu->arch.nmi_pending &&
> -            static_call(kvm_x86_nmi_allowed)(vcpu, false)))
> +           (vcpu->arch.nmi_pending && KVM_X86_CALL(nmi_allowed, vcpu, fa=
lse)))
>                 return true;
>
>  #ifdef CONFIG_KVM_SMM
>         if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
> -           (vcpu->arch.smi_pending &&
> -            static_call(kvm_x86_smi_allowed)(vcpu, false)))
> +           (vcpu->arch.smi_pending && KVM_X86_CALL(smi_allowed, vcpu, fa=
lse)))
>                 return true;
>  #endif
>
> @@ -13105,7 +13111,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  {
>         return kvm_vcpu_apicv_active(vcpu) &&
> -              static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu);
> +              KVM_X86_CALL(dy_apicv_has_pending_interrupt, vcpu);
>  }
>
>  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> @@ -13133,7 +13139,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcp=
u)
>         if (vcpu->arch.guest_state_protected)
>                 return true;
>
> -       return static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 0;
> +       return KVM_X86_CALL(get_cpl, vcpu) =3D=3D 0;
>  }
>
>  unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
> @@ -13148,7 +13154,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vc=
pu)
>
>  int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
>  {
> -       return static_call(kvm_x86_interrupt_allowed)(vcpu, false);
> +       return KVM_X86_CALL(interrupt_allowed, vcpu, false);
>  }
>
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
> @@ -13174,7 +13180,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcp=
u)
>  {
>         unsigned long rflags;
>
> -       rflags =3D static_call(kvm_x86_get_rflags)(vcpu);
> +       rflags =3D KVM_X86_CALL(get_rflags, vcpu);
>         if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>                 rflags &=3D ~X86_EFLAGS_TF;
>         return rflags;
> @@ -13186,7 +13192,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcp=
u, unsigned long rflags)
>         if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
>             kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
>                 rflags |=3D X86_EFLAGS_TF;
> -       static_call(kvm_x86_set_rflags)(vcpu, rflags);
> +       KVM_X86_CALL(set_rflags, vcpu, rflags);
>  }
>
>  void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> @@ -13297,8 +13303,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_v=
cpu *vcpu)
>         if (!kvm_pv_async_pf_enabled(vcpu))
>                 return false;
>
> -       if (vcpu->arch.apf.send_user_only &&
> -           static_call(kvm_x86_get_cpl)(vcpu) =3D=3D 0)
> +       if (vcpu->arch.apf.send_user_only && KVM_X86_CALL(get_cpl, vcpu) =
=3D=3D 0)
>                 return false;
>
>         if (is_guest_mode(vcpu)) {
> @@ -13409,7 +13414,7 @@ bool kvm_arch_can_dequeue_async_page_present(stru=
ct kvm_vcpu *vcpu)
>  void kvm_arch_start_assignment(struct kvm *kvm)
>  {
>         if (atomic_inc_return(&kvm->arch.assigned_device_count) =3D=3D 1)
> -               static_call(kvm_x86_pi_start_assignment)(kvm);
> +               KVM_X86_CALL(pi_start_assignment, kvm);
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
>
> @@ -13472,9 +13477,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_b=
ypass_consumer *cons,
>
>         irqfd->producer =3D prod;
>         kvm_arch_start_assignment(irqfd->kvm);
> -       ret =3D static_call(kvm_x86_pi_update_irte)(irqfd->kvm,
> -                                        prod->irq, irqfd->gsi, 1);
> -
> +       ret =3D KVM_X86_CALL(pi_update_irte,
> +                          irqfd->kvm, prod->irq, irqfd->gsi, 1);
>         if (ret)
>                 kvm_arch_end_assignment(irqfd->kvm);
>
> @@ -13497,7 +13501,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_=
bypass_consumer *cons,
>          * when the irq is masked/disabled or the consumer side (KVM
>          * int this case doesn't want to receive the interrupts.
>         */
> -       ret =3D static_call(kvm_x86_pi_update_irte)(irqfd->kvm, prod->irq=
, irqfd->gsi, 0);
> +       ret =3D KVM_X86_CALL(pi_update_irte,
> +                          irqfd->kvm, prod->irq, irqfd->gsi, 0);
>         if (ret)
>                 printk(KERN_INFO "irq bypass consumer (token %p) unregist=
ration"
>                        " fails: %d\n", irqfd->consumer.token, ret);
> @@ -13508,7 +13513,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_=
bypass_consumer *cons,
>  int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq=
,
>                                    uint32_t guest_irq, bool set)
>  {
> -       return static_call(kvm_x86_pi_update_irte)(kvm, host_irq, guest_i=
rq, set);
> +       return KVM_X86_CALL(pi_update_irte, kvm, host_irq, guest_irq, set=
);
>  }
>
>  bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *o=
ld,
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a8b71803777b..8260da45540b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -157,7 +157,7 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vc=
pu)
>
>         if (!is_long_mode(vcpu))
>                 return false;
> -       static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
> +       KVM_X86_CALL(get_cs_db_l_bits, vcpu, &cs_db, &cs_l);
>         return cs_l;
>  }
>
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index f65b35a05d91..afa804d32166 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1270,7 +1270,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *v=
cpu, u64 data)
>                 instructions[0] =3D 0xb8;
>
>                 /* vmcall / vmmcall */
> -               static_call(kvm_x86_patch_hypercall)(vcpu, instructions +=
 5);
> +               KVM_X86_CALL(patch_hypercall, vcpu, instructions + 5);
>
>                 /* ret */
>                 instructions[8] =3D 0xc3;
> @@ -1650,7 +1650,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>                 params[5] =3D (u64)kvm_r9_read(vcpu);
>         }
>  #endif
> -       cpl =3D static_call(kvm_x86_get_cpl)(vcpu);
> +       cpl =3D KVM_X86_CALL(get_cpl, vcpu);
>         trace_kvm_xen_hypercall(cpl, input, params[0], params[1], params[=
2],
>                                 params[3], params[4], params[5]);
>
> --
> 2.27.0
>


