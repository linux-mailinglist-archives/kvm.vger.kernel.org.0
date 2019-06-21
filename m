Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34A4E462
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfFUJmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:42:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46504 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfFUJms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:42:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id z23so5660911ote.13;
        Fri, 21 Jun 2019 02:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zt/rkE2uwb6CHB8DWB4fHAhRCcaDGCC18elm653yUDY=;
        b=ZQofFxTwBUPKH+zyHD0AH17wZUU0DCJaxZHMHZYckRylWbKITQHUZc9KhiI8mkcYWY
         3bvUv8mw8+mFCIXpbTNA6C+g7ZrnY5ajfezudlhvz2hsrAMzWcaHUvmu76W3gCbxswca
         G0J2D8i6jaRXg4F6I+jENVcnoYM9lmsl3Ut3K9ZizmnqMnl/smd/XMJoFjw5sIWRVOcn
         xprZItGGQJ9N/uD9Ph+0PCG8L+2XMmp6cyO1WBeLI4vJfDJNhcR0U3EnZy+jsYwDZpMe
         A91Wi5Fm0JtW0/vUHmKe4RXc2eO0/h8vC32mxZnFPcSWcGaBkDSQZFgm+HGP4DvWRVds
         hssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zt/rkE2uwb6CHB8DWB4fHAhRCcaDGCC18elm653yUDY=;
        b=CJenKUjpHE4oxg4FogP7aH5hlmVMZC0qHbIQPKo7JkulYJMHN4pQIXbZSJAdujMmF3
         9gCAZUWHedRJBvtUPqW2YS6mLgAAdUpBD8wPSrpi/P85nEeWm8LZTVipFnJNAVsO1j3e
         QmWo+GOJb069cSOhD5kXEREaKS8g/x8aSZzF3Ou00yU3wK3UnZufwxm4oBpGV15u1Xlu
         ljVdOp6CZ3TpUSinSJtESnm+yJZnmBolqqPiNXVX/x5uqMLgEhPLrzginFruiJS8HpbG
         LON9tRj12Gcv11MU6Gw60r8Un3wQPxlIH2qc/Jcjzs93GQjOzCTHkNC6bt7fWYTQiw7J
         +p9g==
X-Gm-Message-State: APjAAAVKdq2eNScHlUywyGNIkGSXO8FwWtti8KOiGV5EeKjygXRxJBs/
        VbJiBmYo6cSoWgaazaw1wBQchowrv+97UpjsFTvZCA==
X-Google-Smtp-Source: APXvYqzXaxnHnbrDiK893TTngEMYU6AznBNF5SGeiHoNi5DIMU1hATKzIzNQ81kaD16ArmnAJxWZYecejazZWPirLKI=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr7101354otk.56.1561110167615;
 Fri, 21 Jun 2019 02:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <1560474949-20497-1-git-send-email-wanpengli@tencent.com> <1560474949-20497-2-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1560474949-20497-2-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 21 Jun 2019 17:44:00 +0800
Message-ID: <CANRm+CzUvTTOuYhsGErSDxdNSmxVr7o8d66DF0KOk4v3Meajmg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Fri, 14 Jun 2019 at 09:15, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Advance lapic timer tries to hidden the hypervisor overhead between the
> host emulated timer fires and the guest awares the timer is fired. Howeve=
r,
> even though after more sustaining optimizations, kvm-unit-tests/tscdeadli=
ne_latency
> still awares ~1000 cycles latency since we lost the time between the end =
of
> wait_lapic_expire and the guest awares the timer is fired. There are
> codes between the end of wait_lapic_expire and the world switch, furtherm=
ore,
> the world switch itself also has overhead. Actually the guest_tsc is equa=
l
> to the target deadline time in wait_lapic_expire is too late, guest will
> aware the latency between the end of wait_lapic_expire() and after vmentr=
y
> to the guest. This patch takes this time into consideration.
>
> The vmentry_advance_ns module parameter is conservative 25ns by default(t=
hanks
> to Radim's kvm-unit-tests/vmentry_latency.flat), it can be tuned/reworked=
 in
> the future.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>  * default value is 25ns
>  * compute vmentry_advance_cycles in kvm_set_tsc_khz() path
> v2 -> v3:
>  * read-only module parameter
>  * get_vmentry_advance_cycles() not inline
> v1 -> v2:
>  * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
>  * cache vmentry_advance_cycles by setting param bit 0
>  * add param max limit
>
>  arch/x86/kvm/lapic.c   | 21 ++++++++++++++++++---
>  arch/x86/kvm/lapic.h   |  2 ++
>  arch/x86/kvm/vmx/vmx.c |  3 ++-
>  arch/x86/kvm/x86.c     | 12 ++++++++++--
>  arch/x86/kvm/x86.h     |  2 ++
>  5 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e82a18c..e92e4e5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1528,6 +1528,19 @@ static inline void adjust_lapic_timer_advance(stru=
ct kvm_vcpu *vcpu,
>         apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
>  }
>
> +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
> +{
> +       u64 cycles;
> +       struct kvm_lapic *apic =3D vcpu->arch.apic;
> +
> +       cycles =3D vmentry_advance_ns * vcpu->arch.virtual_tsc_khz;
> +       do_div(cycles, 1000000);
> +
> +       apic->lapic_timer.vmentry_advance_cycles =3D cycles;
> +
> +       return cycles;
> +}
> +
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic =3D vcpu->arch.apic;
> @@ -1541,7 +1554,8 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>
>         tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
>         apic->lapic_timer.expired_tscdeadline =3D 0;
> -       guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> +       guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) +
> +               apic->lapic_timer.vmentry_advance_cycles;
>         apic->lapic_timer.advance_expire_delta =3D guest_tsc - tsc_deadli=
ne;
>
>         if (guest_tsc < tsc_deadline)
> @@ -1569,7 +1583,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *=
apic)
>         local_irq_save(flags);
>
>         now =3D ktime_get();
> -       guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> +       guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) +
> +               apic->lapic_timer.vmentry_advance_cycles;
>
>         ns =3D (tscdeadline - guest_tsc) * 1000000ULL;
>         do_div(ns, this_tsc_khz);
> @@ -2326,7 +2341,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int tim=
er_advance_ns)
>                 apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
>                 apic->lapic_timer.timer_advance_adjust_done =3D true;
>         }
> -
> +       apic->lapic_timer.vmentry_advance_cycles =3D 0;
>
>         /*
>          * APIC is created enabled. This will prevent kvm_lapic_set_base =
from
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 3674717..7c38950 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -33,6 +33,7 @@ struct kvm_timer {
>         u64 expired_tscdeadline;
>         u32 timer_advance_ns;
>         s64 advance_expire_delta;
> +       u64 vmentry_advance_cycles;
>         atomic_t pending;                       /* accumulated triggered =
timers */
>         bool hv_timer_in_use;
>         bool timer_advance_adjust_done;
> @@ -226,6 +227,7 @@ static inline int kvm_lapic_latched_init(struct kvm_v=
cpu *vcpu)
>  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
>
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq =
*irq,
>                         struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8fbea03..dc81c78 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7064,7 +7064,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, =
u64 guest_deadline_tsc,
>
>         vmx =3D to_vmx(vcpu);
>         tscl =3D rdtsc();
> -       guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl);
> +       guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl) +
> +               vcpu->arch.apic->lapic_timer.vmentry_advance_cycles;
>         delta_tsc =3D max(guest_deadline_tsc, guest_tscl) - guest_tscl;
>         lapic_timer_advance_cycles =3D nsec_to_cycles(vcpu,
>                                                     ktimer->timer_advance=
_ns);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0a05a4e..5e79b6c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IW=
USR);
>  static int __read_mostly lapic_timer_advance_ns =3D -1;
>  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
>
> +/*
> + * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
> + */
> +u32 __read_mostly vmentry_advance_ns =3D 25;
> +module_param(vmentry_advance_ns, uint, S_IRUGO);
> +
>  static bool __read_mostly vector_hashing =3D true;
>  module_param(vector_hashing, bool, S_IRUGO);
>
> @@ -1592,6 +1598,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u=
32 user_tsc_khz)
>         kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
>                            &vcpu->arch.virtual_tsc_shift,
>                            &vcpu->arch.virtual_tsc_mult);
> +       if (user_tsc_khz !=3D vcpu->arch.virtual_tsc_khz)
> +               compute_vmentry_advance_cycles(vcpu);
>         vcpu->arch.virtual_tsc_khz =3D user_tsc_khz;
>
>         /*
> @@ -9134,8 +9142,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>         }
>         vcpu->arch.pio_data =3D page_address(page);
>
> -       kvm_set_tsc_khz(vcpu, max_tsc_khz);
> -
>         r =3D kvm_mmu_create(vcpu);
>         if (r < 0)
>                 goto fail_free_pio_data;
> @@ -9148,6 +9154,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>         } else
>                 static_key_slow_inc(&kvm_no_apic_vcpu);
>
> +       kvm_set_tsc_khz(vcpu, max_tsc_khz);
> +
>         vcpu->arch.mce_banks =3D kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) =
* 4,
>                                        GFP_KERNEL_ACCOUNT);
>         if (!vcpu->arch.mce_banks) {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index e08a128..9998989 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -299,6 +299,8 @@ extern u64 kvm_supported_xcr0(void);
>
>  extern unsigned int min_timer_period_us;
>
> +extern unsigned int vmentry_advance_ns;
> +
>  extern bool enable_vmware_backdoor;
>
>  extern struct static_key kvm_no_apic_vcpu;
> --
> 2.7.4
>
