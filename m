Return-Path: <kvm+bounces-52796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA1BB095E1
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EF1F1C2832A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 20:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B207A2264A5;
	Thu, 17 Jul 2025 20:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="su0tjRDp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4FC6EB79
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785006; cv=none; b=iquHCOdLQGEJyRxivcApYrfFLj8PYyFmG7GJLz0LM0urYRta/Pta7vCoT7qU/dtNp+mw6fq9tlOrekl9uaFlGhejk403eIO2jwsn3pMJjbR6L84olMtF0rGyb2BD5R0wp/4/ULP0Xnn2bHeVcZV9o35Jai8UsBquhOiSXPdYsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785006; c=relaxed/simple;
	bh=r0oMkv3OMfB5/+73UptezlQrHtmfzQYUnJiDVo4LFQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=psV+wkNWbqDF8nKvY/yj6rGRoQAsZg14PYvIvhU02z6F5KHCzOlEv1HenSNi7CnpTohdMQaM/CkBZQCyeVaIRwaSX56CIQ2rU0n8vv1n0cl+X+msttYExdEVXuL6W2bE1ZplteOT5d91yhCUrKU2NB3w+QOMgFJsX6ToI/YPlfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=su0tjRDp; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-556fd896c99so1326820e87.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752785003; x=1753389803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGMN5UTJKcHxRHTgA7W5UA3KAEyLNTKya3uMYL5K6U4=;
        b=su0tjRDpuXIzt67wdleEy1/P4N+td20o++K5FqXt3RRt44zhLmw4PXWSdxjuulmVtb
         wHVZhmKQxggsR9J3FAmuaa0UZ2MrPXSGLt5RLDputUkyWWLC92frJjiNLwc8VJQcBz5t
         nLQvCF/ihepCTTVV9t/IMmE/2YOhNThFNIsHsnHowElcN/OFJAGRB/Mqy2455GvX+/Fp
         Lv6WSKhU421zwKplXBjW1TugiB2Wr/BnwQXErU7dBFVmAdkbU1IgqMNrxkd+8HF1DD9F
         RGjQGDmLk85m9UdPH5NiVfwhsNKCRO3VhVyRzuV4xmM3yG/m23homeOApqvaMS++8LEk
         eEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752785003; x=1753389803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGMN5UTJKcHxRHTgA7W5UA3KAEyLNTKya3uMYL5K6U4=;
        b=BeIlj4ixkPt98UTEgtk76ByaZhZSLzz+LF87+AZQnjpgWANfCZAoGlo0Ji5UeU3tW0
         fz+S3DXHwv948QkIpgpByU/2Oq3F6VErapb7rq6MnMsaTszBEpIYUDhRCXqjFDApn33K
         vBVMXwSORKObBoPENKfe9Sxfk7WsL6aR2idODoDZw2BWNyBydnn4aVPKGgoy3w3zOYmT
         W6jK27Xjji5IQg6kgRoEKCcePPuPVHmKvZNBx/a+gyNXX8sHWeAk2HQLzBeVs1JnWVgy
         5DH1XB24xUUuQ+y9scKI3srKNx6RLOSNNtuuFg3/smEXSaKVDU6E++CRmebgB///lnjM
         zfAg==
X-Forwarded-Encrypted: i=1; AJvYcCULe69cbW9PzHpkzhcb44MU/wdepeFGWDb7/KUO5AbZtXO8+RtwkI5+2ggG00OpGhXzOWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyamasinhufgXkSjCJTN7Ntgk4u+mN8kxeCGqq5INvtG0qAOufE
	EsoN+uo74sO6UbUMixM3haCEjOZTdM8uVcsJRUG+TyOWwwLNXBX3DTa44VtdMVjQtdNSWfrS96p
	0djLS22kJgh6T12P/OqvmFdeKCYZODv0Z2/34CKg=
X-Gm-Gg: ASbGncs6V+LreuzzOqj0ClaGSi1v2+93fDO1CKCR8y8olUrBrOx8xTAQCVpF4GRebNz
	cbG02GOaTXWAI+FV3VLX6zw7XDC5oLSSWjIWzwi5/KQ4efzomPCk6U6D5ufemY00vDdZHiyNNFp
	/j4EnRaFdf0PUamh5e8HxqfNYNQtVeWjXLphhEdYxfgIVU6gqI/QO2taqmJt+g1nAKKM/o3y82M
	oFo43pRL62wXySzCf0plVpAAFUsTyTxWU6yU35oldPaJf4=
X-Google-Smtp-Source: AGHT+IGVVPB9kHQbtlixUOjG0Y7Hw8kpk+hQH06fsz+qrgKiUjTZ5R46WTJyRShUXNf62AA4Mjn8RyKHMX9D8NeXXKA=
X-Received: by 2002:ac2:4c48:0:b0:540:2fd2:6c87 with SMTP id
 2adb3069b0e04-55a23ef9ac5mr2872704e87.16.1752785002907; Thu, 17 Jul 2025
 13:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714033649.4024311-1-suleiman@google.com> <20250714033649.4024311-2-suleiman@google.com>
In-Reply-To: <20250714033649.4024311-2-suleiman@google.com>
From: John Stultz <jstultz@google.com>
Date: Thu, 17 Jul 2025 13:43:10 -0700
X-Gm-Features: Ac12FXzR_Ma-qJwExwNKytyrLvhKN8tppDYEJdJuvjDHEomuW7gmv3ZocILl3I4
Message-ID: <CANDhNCp5ovDmFg-DWpDPNYBg-rMYBr0MBhHBaeH1HOiWF+3Cuw@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] KVM: x86: Advance guest TSC after deep suspend.
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2025 at 8:37=E2=80=AFPM Suleiman Souhlal <suleiman@google.c=
om> wrote:
>
> Try to advance guest TSC to current time after suspend when the host
> TSCs went backwards.
>
> This makes the behavior consistent between suspends where host TSC
> resets and suspends where it doesn't, such as suspend-to-idle, where
> in the former case if the host TSC resets, the guests' would
> previously be "frozen" due to KVM's backwards TSC prevention, while
> in the latter case they would advance.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/x86.c              | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 7b9ccdd99f32..3650a513ba19 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1414,6 +1414,9 @@ struct kvm_arch {
>         u64 cur_tsc_offset;
>         u64 cur_tsc_generation;
>         int nr_vcpus_matched_tsc;
> +#ifdef CONFIG_X86_64
> +       bool host_was_suspended;
> +#endif
>
>         u32 default_tsc_khz;
>         bool user_set_tsc;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e21f5f2fe059..6539af701016 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5035,7 +5035,36 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int=
 cpu)
>
>         /* Apply any externally detected TSC adjustments (due to suspend)=
 */
>         if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
> +#ifdef CONFIG_X86_64
> +               unsigned long flags;
> +               struct kvm *kvm;
> +               bool advance;
> +               u64 kernel_ns, l1_tsc, offset, tsc_now;
> +
> +               kvm =3D vcpu->kvm;
> +               advance =3D kvm_get_time_and_clockread(&kernel_ns, &tsc_n=
ow);
> +               raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +               /*
> +                * Advance the guest's TSC to current time instead of onl=
y
> +                * preventing it from going backwards, while making sure
> +                * all the vCPUs use the same offset.
> +                */
> +               if (kvm->arch.host_was_suspended && advance) {
> +                       l1_tsc =3D nsec_to_cycles(vcpu,
> +                                               kvm->arch.kvmclock_offset=
 + kernel_ns);
> +                       offset =3D kvm_compute_l1_tsc_offset(vcpu, l1_tsc=
);
> +                       kvm->arch.cur_tsc_offset =3D offset;
> +                       kvm_vcpu_write_tsc_offset(vcpu, offset);
> +               } else if (advance) {
> +                       kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc=
_offset);
> +               } else {
> +                       adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offse=
t_adjustment);
> +               }
> +               kvm->arch.host_was_suspended =3D false;
> +               raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, fla=
gs);
> +#else
>                 adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjust=
ment);
> +#endif /* CONFIG_X86_64 */

Just style wise, it seems like renaming adjust_tsc_offset_host() to
__adjust_tsc_offset_host(), and then moving the ifdefed logic into a
new adjust_tsc_offset_host() implementation might be cleaner?
Then you could have:

#ifdef COFNIG_X86_64
static inline void adjust_tsc_offset_host(...)
{
/* added logic above */
}
#else
static inline void adjust_tsc_offset_host(...)
{
    __adjust_tsc_offset_host(...);
}
#endif

>                 vcpu->arch.tsc_offset_adjustment =3D 0;
>                 kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>         }
> @@ -12729,6 +12758,9 @@ int kvm_arch_enable_virtualization_cpu(void)
>                                 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDA=
TE, vcpu);
>                         }
>
> +#ifdef CONFIG_X86_64
> +                       kvm->arch.host_was_suspended =3D true;
> +#endif

Similarly I'd wrap this in a:

#ifdef CONFIG_x86_64
static inline void kvm_set_host_was_suspended(*kvm)
{
    kvm->arch.host_was_suspended =3D true;
}
#else
static inline void kvm_set_host_was_suspended(*kvm)
{
}
#endif

then call kvm_set_host_was_suspended(kvm) unconditionally in the logic abov=
e.

thanks
-john

