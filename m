Return-Path: <kvm+bounces-13896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E00B89C5A8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A8661F217E2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862CD7E580;
	Mon,  8 Apr 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="D9JTJa7f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569547E111
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584726; cv=none; b=Fd1nOzrsNP7CtmUOkggjvqA/ADRWmPEhF7NN4Aif9v9idMcb38wCVRvSrPbb4IMxDg3p77b5TsWwNtqdWjaJUPAF1+rIYHmAc9+tBxqHNDvSeaG9T+ryQsMie3EukS+tEJz76nzlU1i4iSSeEB2DFQG2TU+2lnlZa+gQlTZc8S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584726; c=relaxed/simple;
	bh=JwKbHyDdJqKkWIrXnGAqf8zmpkXLprKnjLhDbuicsmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rtz72OikQoPdqBJY+osuiw1RKZZbrtkfRf9hpi09+AYX/J10F8W0kuYyt5TIjh4NVfSawITB9bVKgSLMQLc46h8W0fTvgYwjygRxMB3ae0M+W52amAkDQAVFNJTcfr2Xg/sp3ycrQAub2ByW+E15WqE9NLiaEdB0Otpdb7kboa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=D9JTJa7f; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dcc80d6006aso4345055276.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 06:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712584723; x=1713189523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exi1tZ25M8U9KJRZYlm9vl7tg5u6eSxfy3YOWCKZkMU=;
        b=D9JTJa7fp33VftzKU0Ja2w2rioAQJcvY+SSfdjXoedKbvYIBel53p0aRyyRgfyIgpA
         Af6Fd7O5vAh8C3PXBjB0VRuqhYm+Ym8ZYopFsBsdOYMmJHgd6SNfNNo+IM4o2vpIwesK
         vZa7a/1X9DH2FsW9ISknam/kJ4gEvL4jmqOy2zfp2+WFEsNUoQZX53z0P4GwB36a5twW
         D63wJETKisafGXxocvrZquHeMPbprQv6dBbpDrWpBB8BLJYPKk8bZSHnOraQ0eglp3V5
         dDGFnqoGUqrRb7GjuuscCwxxDt7fFO+kAoW2obC0jEco2z+ymyJzJ3HaW55I/vVZ8yc3
         kmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584723; x=1713189523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exi1tZ25M8U9KJRZYlm9vl7tg5u6eSxfy3YOWCKZkMU=;
        b=vb7u2kh19V/U/OjgbExplKpd5KmJzaQd2Cw79cGehmdRJ2+0eXZwmDOqozbj7Sg+Iz
         qgXdxGfCly3meSYn2Kbn3aCNXodDUHsYpwqZUSbeD1N15UbAVHgOhrHWCDsYpmwJKA3y
         BBTIwH4zem7pQHkkjxGLPw7VqHQ82ARYSJ5ZvDUWUb5flkL8z+mako6O76PMSXbr8Qfk
         3//D892hYVqHZ8SoLC+SnI8LZdQ4gbOksgVaz/8jRCPI8eMUIK0oMmyVpCH+yYfp2e/B
         gM+49IaE+6HNZsPbAvEDQh2cuxFRdwkdm+upqXyuEsORBOU4lHJ3Yy3im9NnkmzkN69A
         COzA==
X-Forwarded-Encrypted: i=1; AJvYcCUVC3g1gTDmyYoK5UZ7SD5wVP7Km5PZFrZ8pewh+/IDk0tiN+qYPPdXXJYWvloMgyuaO6CGx/5t9yiLlNpUR/n153ap
X-Gm-Message-State: AOJu0YylIAsnSwRxxgRkc4qh9/WRRIwXe3fbqkyp7VOTyf49pIz29Ndw
	Ym6Tl9JOI8Sa+hgyyKlWDn58yBbdUUPR3eGl4OWantjH7P0a41Ad6U35enGR+y/5qTkBqgfIiu1
	sKSEvxjQcGp16k7WaX3ZFeAmaVAOgcDXS2AC8iQ==
X-Google-Smtp-Source: AGHT+IGuCCcfELaEOafnUyIzlkMVIzGa0/nrDZhXkl+wn5FhYnjaxiCaNzwtpX4RKKNoJ+7mdJmoFf2L2rUt90SG/xA=
X-Received: by 2002:a25:b107:0:b0:dc6:9ea9:8154 with SMTP id
 g7-20020a25b107000000b00dc69ea98154mr7557910ybj.13.1712584723316; Mon, 08 Apr
 2024 06:58:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org> <20240403140116.3002809-3-vineeth@bitbyteword.org>
In-Reply-To: <20240403140116.3002809-3-vineeth@bitbyteword.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 8 Apr 2024 09:58:32 -0400
Message-ID: <CAO7JXPhDKXWkSpkQU=bXJ2GuXn=Eyd0=vk4M2XWrqHmp9roqQw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] kvm: Implement the paravirt sched framework
 for kvm
To: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding sched_ext folks

On Wed, Apr 3, 2024 at 10:01=E2=80=AFAM Vineeth Pillai (Google)
<vineeth@bitbyteword.org> wrote:
>
> kvm uses the kernel's paravirt sched framework to assign an available
> pvsched driver for a guest. guest vcpus registers with the pvsched
> driver and calls into the driver callback to notify the events that the
> driver is interested in.
>
> This PoC doesn't do the callback on interrupt injection yet. Will be
> implemented in subsequent iterations.
>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  arch/x86/kvm/Kconfig     |  13 ++++
>  arch/x86/kvm/x86.c       |   3 +
>  include/linux/kvm_host.h |  32 +++++++++
>  virt/kvm/kvm_main.c      | 148 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 196 insertions(+)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 65ed14b6540b..c1776cdb5b65 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -189,4 +189,17 @@ config KVM_MAX_NR_VCPUS
>           the memory footprint of each KVM guest, regardless of how many =
vCPUs are
>           created for a given VM.
>
> +config PARAVIRT_SCHED_KVM
> +       bool "Enable paravirt scheduling capability for kvm"
> +       depends on KVM
> +       default n
> +       help
> +         Paravirtualized scheduling facilitates the exchange of scheduli=
ng
> +         related information between the host and guest through shared m=
emory,
> +         enhancing the efficiency of vCPU thread scheduling by the hyper=
visor.
> +         An illustrative use case involves dynamically boosting the prio=
rity of
> +         a vCPU thread when the guest is executing a latency-sensitive w=
orkload
> +         on that specific vCPU.
> +         This config enables paravirt scheduling in the kvm hypervisor.
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ffe580169c93..d0abc2c64d47 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10896,6 +10896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>
>         preempt_disable();
>
> +       kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_VMENTER);
> +
>         static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
>
>         /*
> @@ -11059,6 +11061,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
>         guest_timing_exit_irqoff();
>
>         local_irq_enable();
> +       kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_VMEXIT);
>         preempt_enable();
>
>         kvm_vcpu_srcu_read_lock(vcpu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 179df96b20f8..6381569f3de8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -45,6 +45,8 @@
>  #include <asm/kvm_host.h>
>  #include <linux/kvm_dirty_ring.h>
>
> +#include <linux/pvsched.h>
> +
>  #ifndef KVM_MAX_VCPU_IDS
>  #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
>  #endif
> @@ -832,6 +834,11 @@ struct kvm {
>         bool vm_bugged;
>         bool vm_dead;
>
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +       spinlock_t pvsched_ops_lock;
> +       struct pvsched_vcpu_ops __rcu *pvsched_ops;
> +#endif
> +
>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>         struct notifier_block pm_notifier;
>  #endif
> @@ -2413,4 +2420,29 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm=
,
>  }
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 events);
> +int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu);
> +
> +int kvm_replace_pvsched_ops(struct kvm *kvm, char *name);
> +#else
> +static inline int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 eve=
nts)
> +{
> +       return 0;
> +}
> +static inline int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu)
> +{
> +       return 0;
> +}
> +static inline void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline int kvm_replace_pvsched_ops(struct kvm *kvm, char *name)
> +{
> +       return 0;
> +}
> +#endif
> +
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0f50960b0e3a..0546814e4db7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -170,6 +170,142 @@ bool kvm_is_zone_device_page(struct page *page)
>         return is_zone_device_page(page);
>  }
>
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +typedef enum {
> +       PVSCHED_CB_REGISTER =3D 1,
> +       PVSCHED_CB_UNREGISTER =3D 2,
> +       PVSCHED_CB_NOTIFY =3D 3
> +} pvsched_vcpu_callback_t;
> +
> +/*
> + * Helper function to invoke the pvsched driver callback.
> + */
> +static int __vcpu_pvsched_callback(struct kvm_vcpu *vcpu, u32 events,
> +               pvsched_vcpu_callback_t action)
> +{
> +       int ret =3D 0;
> +       struct pid *pid;
> +       struct pvsched_vcpu_ops *ops;
> +
> +       rcu_read_lock();
> +       ops =3D rcu_dereference(vcpu->kvm->pvsched_ops);
> +       if (!ops) {
> +               ret =3D -ENOENT;
> +               goto out;
> +       }
> +
> +       pid =3D rcu_dereference(vcpu->pid);
> +       if (WARN_ON_ONCE(!pid)) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +       get_pid(pid);
> +       switch(action) {
> +               case PVSCHED_CB_REGISTER:
> +                       ops->pvsched_vcpu_register(pid);
> +                       break;
> +               case PVSCHED_CB_UNREGISTER:
> +                       ops->pvsched_vcpu_unregister(pid);
> +                       break;
> +               case PVSCHED_CB_NOTIFY:
> +                       if (ops->events & events) {
> +                               ops->pvsched_vcpu_notify_event(
> +                                       NULL, /* TODO: Pass guest allocat=
ed sharedmem addr */
> +                                       pid,
> +                                       ops->events & events);
> +                       }
> +                       break;
> +               default:
> +                       WARN_ON_ONCE(1);
> +       }
> +       put_pid(pid);
> +
> +out:
> +       rcu_read_unlock();
> +       return ret;
> +}
> +
> +int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 events)
> +{
> +       return __vcpu_pvsched_callback(vcpu, events, PVSCHED_CB_NOTIFY);
> +}
> +
> +int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu)
> +{
> +       return __vcpu_pvsched_callback(vcpu, 0, PVSCHED_CB_REGISTER);
> +       /*
> +        * TODO: Action if the registration fails?
> +        */
> +}
> +
> +void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu)
> +{
> +       __vcpu_pvsched_callback(vcpu, 0, PVSCHED_CB_UNREGISTER);
> +}
> +
> +/*
> + * Replaces the VM's current pvsched driver.
> + * if name is NULL or empty string, unassign the
> + * current driver.
> + */
> +int kvm_replace_pvsched_ops(struct kvm *kvm, char *name)
> +{
> +       int ret =3D 0;
> +       unsigned long i;
> +       struct kvm_vcpu *vcpu =3D NULL;
> +       struct pvsched_vcpu_ops *ops =3D NULL, *prev_ops;
> +
> +
> +       spin_lock(&kvm->pvsched_ops_lock);
> +
> +       prev_ops =3D rcu_dereference(kvm->pvsched_ops);
> +
> +       /*
> +        * Unassign operation if the passed in value is
> +        * NULL or an empty string.
> +        */
> +       if (name && *name) {
> +               ops =3D pvsched_get_vcpu_ops(name);
> +               if (!ops) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +       }
> +
> +       if (prev_ops) {
> +               /*
> +                * Unregister current pvsched driver.
> +                */
> +               kvm_for_each_vcpu(i, vcpu, kvm) {
> +                       kvm_vcpu_pvsched_unregister(vcpu);
> +               }
> +
> +               pvsched_put_vcpu_ops(prev_ops);
> +       }
> +
> +
> +       rcu_assign_pointer(kvm->pvsched_ops, ops);
> +       if (ops) {
> +               /*
> +                * Register new pvsched driver.
> +                */
> +               kvm_for_each_vcpu(i, vcpu, kvm) {
> +                       WARN_ON_ONCE(kvm_vcpu_pvsched_register(vcpu));
> +               }
> +       }
> +
> +out:
> +       spin_unlock(&kvm->pvsched_ops_lock);
> +
> +       if (ret)
> +               return ret;
> +
> +       synchronize_rcu();
> +
> +       return 0;
> +}
> +#endif
> +
>  /*
>   * Returns a 'struct page' if the pfn is "valid" and backed by a refcoun=
ted
>   * page, NULL otherwise.  Note, the list of refcounted PG_reserved page =
types
> @@ -508,6 +644,8 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
>         kvm_arch_vcpu_destroy(vcpu);
>         kvm_dirty_ring_free(&vcpu->dirty_ring);
>
> +       kvm_vcpu_pvsched_unregister(vcpu);
> +
>         /*
>          * No need for rcu_read_lock as VCPU_RUN is the only place that c=
hanges
>          * the vcpu->pid pointer, and at destruction time all file descri=
ptors
> @@ -1221,6 +1359,10 @@ static struct kvm *kvm_create_vm(unsigned long typ=
e, const char *fdname)
>
>         BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +       spin_lock_init(&kvm->pvsched_ops_lock);
> +#endif
> +
>         /*
>          * Force subsequent debugfs file creations to fail if the VM dire=
ctory
>          * is not created (by kvm_create_vm_debugfs()).
> @@ -1343,6 +1485,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
>         int i;
>         struct mm_struct *mm =3D kvm->mm;
>
> +       kvm_replace_pvsched_ops(kvm, NULL);
> +
>         kvm_destroy_pm_notifier(kvm);
>         kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
>         kvm_destroy_vm_debugfs(kvm);
> @@ -3779,6 +3923,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>                 if (kvm_vcpu_check_block(vcpu) < 0)
>                         break;
>
> +               kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_HALT);
> +
>                 waited =3D true;
>                 schedule();
>         }
> @@ -4434,6 +4580,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                         /* The thread running this VCPU changed. */
>                         struct pid *newpid;
>
> +                       kvm_vcpu_pvsched_unregister(vcpu);
>                         r =3D kvm_arch_vcpu_run_pid_change(vcpu);
>                         if (r)
>                                 break;
> @@ -4442,6 +4589,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                         rcu_assign_pointer(vcpu->pid, newpid);
>                         if (oldpid)
>                                 synchronize_rcu();
> +                       kvm_vcpu_pvsched_register(vcpu);
>                         put_pid(oldpid);
>                 }
>                 r =3D kvm_arch_vcpu_ioctl_run(vcpu);
> --
> 2.40.1
>

