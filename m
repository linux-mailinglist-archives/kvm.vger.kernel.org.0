Return-Path: <kvm+bounces-22483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0670393EE62
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 09:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB7F128241E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 07:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE419127B57;
	Mon, 29 Jul 2024 07:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GxAhRp9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A2584E11
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 07:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722237989; cv=none; b=W4dAjdoco8B2i7FzbEfzPnibeJSUr3eyIXqKmoYVhjs3h+NcjRv0Ji4oDwial9ezmGEBFXTRXnaJjgADXygNdccORkH15rRZ/CPSWrO5wja9Rq3UdrM3TA9WXCJXdqSRjSeYGEH1mcJHxNpEFie+eaOAJQ4Ya+lh+vwqg9jYRS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722237989; c=relaxed/simple;
	bh=2hKEZgm5/EE5wIeD8w9GbGX7uU/DWHZu0LlH9PopXKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QxvwwqMFoE7isOzZ5zzxhA1AMkb1du+657KviH+BXIkACndTY98qQ1I1o1aPSBfuYT1GgRlXOSLsyxXOkAUFHhf9pa19UOhibyN0x3efaK6RzhGqB3L3tBxNi3hAp9JsXh58g9u5CNv+CtzMrD8O0xP2AxKsVsxoIkyemAwJ0w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GxAhRp9b; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4f51e80f894so1306724e0c.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 00:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722237986; x=1722842786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCebpCWNKlXe6DpILlIFO1QGAoyqFmV8Q7GN3Vo8R20=;
        b=GxAhRp9bf22jGr/2U51usbxgjWV9AxUudYitxPYcfh3u1gXkWjCysjXU+37zxkdfKA
         Wd8SWs/n7sYFTFR1gP6RjXi+MUwgXRHboMLFB24/Ezl9USIocG5Tj6Y1GJ7u+ba/imX8
         0RYKwPHg6XBAtbIXUqQlOAatWoXABFvBptS2O9ql8DKTpdwxFlHaONOqPEu08O+B0ML4
         e8HD+NLx7U1iYt0en3lY7MosuFznCtNThTHo5LcesSCSlDntderuTjrH+czEYjn0PY6w
         n1uunnt5DoiW5U1fC+LKLTN+rdUp4L2Yxy4gCK2eLDmSZLNwpsBppJZ00rl3u+dDI2yu
         80jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722237986; x=1722842786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCebpCWNKlXe6DpILlIFO1QGAoyqFmV8Q7GN3Vo8R20=;
        b=wvUzsESgNHMpB6Eve15H3QgKdDJLkeB/PlrR12jAnC/CTpDs9WZlRptyUOJzMuDRU3
         kA0b1rwUUfEaccJoDoUCdkPatu5rcfO2xpR7S4/ltZ6l+C8IG+yxRNBAaLV4Qez6btgF
         4JRNbj0VUC73V6FZFQZNoMN9tyos/UWod4BMzVtGANnrRRYcpSqG9fRqjgpc0m/qSGZZ
         oqYMVTFtFk/I5jxnULGBGSSwU0lq42SB4kGJPu4aD0piI7jNtPKdtew/u/fOm8lgnQdx
         Pusx4ehPCZw02V/XEuSx/AaXpmkYMV1H45OzFKLfCVg//TKkxsSqQ/K/gKLtYKQT/zEg
         Iclg==
X-Forwarded-Encrypted: i=1; AJvYcCUR1q8Oe4QIlsLlYVa062pCx1BwW81pC7KSmDRqo0TfjfVp5l8xZf519ceyb12dKNOnTzLuJ7GJwFOZgyYhg0DF3o/7
X-Gm-Message-State: AOJu0YxLI8cNTQAPJZUbszdhVwxan9VvpQad/N0Hzd37qPH546NXhz+y
	uoAR4HF122RoIpfBFrlAN/txgE3D5uqXU93lm3X5auOmed7Jy7KerQhI/O3q1CIx2munDffymXX
	zDbwQOt8Uj7fsihdQ9LusyqCfTnocmxn04ayE
X-Google-Smtp-Source: AGHT+IHSR0Z7VG3kt7Ncu0q2ap3y0qVXAQRK8G3Cyts4am3bFQAfPjRYFqYj85H9qo+HqKNpEzuIIA7fKt3FeMTJw8g=
X-Received: by 2002:a05:6122:1aca:b0:4f6:ae65:1e10 with SMTP id
 71dfb90a1353d-4f6e68d4398mr7427802e0c.4.1722237986227; Mon, 29 Jul 2024
 00:26:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710074410.770409-1-suleiman@google.com>
In-Reply-To: <20240710074410.770409-1-suleiman@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Mon, 29 Jul 2024 16:26:15 +0900
Message-ID: <CABCjUKAD=L0jcQcoj_5608EidAZDdRcPPHqZhvVXxHf5__FtiQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: ssouhlal@freebsd.org, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Jul 10, 2024 at 4:44=E2=80=AFPM Suleiman Souhlal <suleiman@google.c=
om> wrote:
>
> When the host resumes from a suspend, the guest thinks any task
> that was running during the suspend ran for a long time, even though
> the effective run time was much shorter, which can end up having
> negative effects with scheduling. This can be particularly noticeable
> if the guest task was RT, as it can end up getting throttled for a
> long time.
>
> To mitigate this issue, we include the time that the host was
> suspended in steal time, which lets the guest can subtract the
> duration from the tasks' runtime.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
>  include/linux/kvm_host.h |  4 ++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0763a0f72a067f..94bbdeef843863 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu=
)
>         struct kvm_steal_time __user *st;
>         struct kvm_memslots *slots;
>         gpa_t gpa =3D vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> -       u64 steal;
> +       u64 steal, suspend_duration;
>         u32 version;
>
>         if (kvm_xen_msr_enabled(vcpu->kvm)) {
> @@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu *vcp=
u)
>                         return;
>         }
>
> +       suspend_duration =3D 0;
> +       if (READ_ONCE(vcpu->suspended)) {
> +               suspend_duration =3D vcpu->kvm->last_suspend_duration;
> +               vcpu->suspended =3D 0;
> +       }
> +
>         st =3D (struct kvm_steal_time __user *)ghc->hva;
>         /*
>          * Doing a TLB flush here, on the guest's behalf, can avoid
> @@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu=
)
>         unsafe_get_user(steal, &st->steal, out);
>         steal +=3D current->sched_info.run_delay -
>                 vcpu->arch.st.last_steal;
> +       steal +=3D suspend_duration;
>         vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
>         unsafe_put_user(steal, &st->steal, out);
>
> @@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kv=
m)
>
>         mutex_lock(&kvm->lock);
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> +               WRITE_ONCE(vcpu->suspended, 1);
>                 if (!vcpu->arch.pv_time.active)
>                         continue;
>
> @@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct kvm *=
kvm)
>         }
>         mutex_unlock(&kvm->lock);
>
> +       kvm->suspended_time =3D ktime_get_boottime_ns();
> +
>         return ret ? NOTIFY_BAD : NOTIFY_DONE;
>  }
>
> +static int
> +kvm_arch_resume_notifier(struct kvm *kvm)
> +{
> +       kvm->last_suspend_duration =3D ktime_get_boottime_ns() -
> +           kvm->suspended_time;
> +       return NOTIFY_DONE;
> +}
> +
>  int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
>  {
>         switch (state) {
>         case PM_HIBERNATION_PREPARE:
>         case PM_SUSPEND_PREPARE:
>                 return kvm_arch_suspend_notifier(kvm);
> +       case PM_POST_HIBERNATION:
> +       case PM_POST_SUSPEND:
> +               return kvm_arch_resume_notifier(kvm);
>         }
>
>         return NOTIFY_DONE;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 692c01e41a18ef..2d37af9a348648 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -366,6 +366,8 @@ struct kvm_vcpu {
>         } async_pf;
>  #endif
>
> +       bool suspended;
> +
>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>         /*
>          * Cpu relax intercept or pause loop exit optimization
> @@ -840,6 +842,8 @@ struct kvm {
>         struct xarray mem_attr_array;
>  #endif
>         char stats_id[KVM_STATS_NAME_SIZE];
> +       u64 last_suspend_duration;
> +       u64 suspended_time;
>  };
>
>  #define kvm_err(fmt, ...) \
> --
> 2.45.2.993.g49e7a77208-goog
>

Gentle ping.

Thanks,
-- Suleiman

