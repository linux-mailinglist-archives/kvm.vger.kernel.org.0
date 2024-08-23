Return-Path: <kvm+bounces-24863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2991A95C41A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 06:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91927B21F19
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 04:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6758F41A80;
	Fri, 23 Aug 2024 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/51xwf8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85B1D52D
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 04:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386665; cv=none; b=D9ulmO/cULatzjfVQhzurE++AcFb4TIaRpIvtA0y6jpzWVPJz83J16RQOl7G22usRGNJzzLENioiN9N/ErY3+8dpB/xmkTyymCbKJ4MgKKhicNcE6cU5bJs54Y6W5KxSx4TuqEAjuxvaSG3jvbrtx9TzyhtMztXsxzlHtz9U6fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386665; c=relaxed/simple;
	bh=zFZdx23HnzLYC+NY4UvZuHsDGkKcK3j50SHMCYMhn8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UVwo9cztNnO8S2TITZIQg26Shs7IbliGL+LEalbsaum5eTaMQcRmqvKXqgwU7FFSwOzZsG72NMcjRf0cXWulLFHnnfQReKiK3VcoKIUJfCvlrdjVeCLno+ykTI++X4piFw7ouNtaUByy0hN8dceo+ikkRxGKYAnX2fQtxulpmok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q/51xwf8; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4fd07f0315dso527890e0c.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 21:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724386663; x=1724991463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSZlGnS8Yi3PbWaYIYLB38Taazl30a+zo2QRNYAbZFM=;
        b=q/51xwf82lQPr1lkYUVbLgEUngxXlP0A3oQwTQ7GaXO1OfVh+zGnp3QsbgIc9eP5yv
         fmBxlvtwuzVqOZ4g/DgKZNis/QuhcoKLsjdNhg0vboi9u7y1G3g27EF7+ND0DNcqk7Hu
         yqjduAeWa4GfSmEThAUe24K7lS69KOKCUue3IC13JUKq1ptcDmO3zGAGbFjR74QAJ5OZ
         GG0bZLlfgrwuD0ni02Qwg5//7Lax/eU6qhFsUYE03E9Bz7HC9+CNioDObseUeQBMCqXI
         Mn6JdWDdKyg8EkrVqaGQNFjnB1maMJYwGrPCM0VK6FAyw/nvu6kP4OlCKjircLG2TLzf
         GAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724386663; x=1724991463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSZlGnS8Yi3PbWaYIYLB38Taazl30a+zo2QRNYAbZFM=;
        b=sbXFZMmHTvyg7Bf9Irss6hKTd6WFlO9XbEKjUB8H9m60OGatmsxC2MZYhsj8BNzL3/
         aF00jAc/IVepzVaBPt7eCmYIBBoEiPmb6Lpjw2tFEHf8QxMnl+yCqfLvqOyVMjyH0k0P
         pf/EJac8AJvcmFIdUliIMnute2uIYJzla0GqfNZBnQLRtFTIRcP3Kg92aV+IThBVfSIm
         CIAHJaL8P1AOPL2bHPJzsyCUbrfLYqmXNHN2ELYyz8x+Z/28LX9d7887R0EIEIRjigfR
         3G72XnXqPc/FANUHarPNPwtyRmRqGzfpzO6SDUD0We+WAMxKDO84PXFUZPO3ly5JORXD
         cEPg==
X-Forwarded-Encrypted: i=1; AJvYcCU8msF7zr+sCkloXUVs0OVHyJP+9tc4xa1uiZGjqGxYeYslJyTyyO13JYVWTWx9cJfgcHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfyQN68t7W5vl46jdBhnD0q7OMjgEG3FxqDWKuuONz0ijdEqu6
	YGDrpfqkctPnSJu3SAqr/zL9bdv8z0P9iLQAPGk+/rvyKejGKqzF3rr9TX4yFzDOCK/j789aWt4
	3xhclAHvC2GdzF/UEfBf63mYSVNkaJ2bY6vh+
X-Google-Smtp-Source: AGHT+IGTRkdxlYLCBHLBkK8lFNaUjUTKqaXwIu200VLpRBRtKJFoYnuJVYx/nbFGmpdRfWc9b1eiNg4P6qxnoqjwhRQ=
X-Received: by 2002:a05:6122:1e0f:b0:4f6:ad39:dab1 with SMTP id
 71dfb90a1353d-4fd1a53145fmr1162809e0c.5.1724386662652; Thu, 22 Aug 2024
 21:17:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com> <20240820043543.837914-3-suleiman@google.com>
 <ZsWJsPkrhDReU4ez@intel.com>
In-Reply-To: <ZsWJsPkrhDReU4ez@intel.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Fri, 23 Aug 2024 13:17:31 +0900
Message-ID: <CABCjUKCBQq9AMCVd0BqOSViPn=Q3wiVByOvJNhNpHvqx=Ef-4g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Include host suspended time in steal time.
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 3:31=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Tue, Aug 20, 2024 at 01:35:42PM +0900, Suleiman Souhlal wrote:
> >When the host resumes from a suspend, the guest thinks any task
> >that was running during the suspend ran for a long time, even though
> >the effective run time was much shorter, which can end up having
> >negative effects with scheduling. This can be particularly noticeable
> >if the guest task was RT, as it can end up getting throttled for a
> >long time.
> >
> >To mitigate this issue, we include the time that the host was
> >suspended in steal time, which lets the guest subtract the duration from
> >the tasks' runtime.
> >
> >Note that the case of a suspend happening during a VM migration
> >might not be accounted.
> >
> >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> >---
> > arch/x86/include/asm/kvm_host.h |  1 +
> > arch/x86/kvm/x86.c              | 11 ++++++++++-
> > 2 files changed, 11 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
> >index 4a68cb3eba78f8..728798decb6d12 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -898,6 +898,7 @@ struct kvm_vcpu_arch {
> >               u8 preempted;
> >               u64 msr_val;
> >               u64 last_steal;
> >+              u64 last_suspend_ns;
> >               struct gfn_to_hva_cache cache;
> >       } st;
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 70219e4069874a..104f3d318026fa 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -3654,7 +3654,7 @@ static void record_steal_time(struct kvm_vcpu *vcp=
u)
> >       struct kvm_steal_time __user *st;
> >       struct kvm_memslots *slots;
> >       gpa_t gpa =3D vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> >-      u64 steal;
> >+      u64 steal, suspend_ns;
> >       u32 version;
> >
> >       if (kvm_xen_msr_enabled(vcpu->kvm)) {
> >@@ -3735,6 +3735,14 @@ static void record_steal_time(struct kvm_vcpu *vc=
pu)
> >       steal +=3D current->sched_info.run_delay -
> >               vcpu->arch.st.last_steal;
> >       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> >+      /*
> >+       * Include the time that the host was suspended in steal time.
> >+       * Note that the case of a suspend happening during a VM migratio=
n
> >+       * might not be accounted.
> >+       */
> >+      suspend_ns =3D kvm_total_suspend_ns();
> >+      steal +=3D suspend_ns - vcpu->arch.st.last_suspend_ns;
> >+      vcpu->arch.st.last_suspend_ns =3D suspend_ns;
>
> The document in patch 3 states:
>
>   Time during which the vcpu is idle, will not be reported as steal time
>
> I'm wondering if all host suspend time should be reported as steal time,
> or if the suspend time during a vCPU halt should be excluded.

I think the statement about idle time not being reported as steal isn't
completely accurate, so I'm not sure if it's worth the extra complexity.

>
> >       unsafe_put_user(steal, &st->steal, out);
> >
> >       version +=3D 1;
> >@@ -12280,6 +12288,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >       vcpu->arch.arch_capabilities =3D kvm_get_arch_capabilities();
> >       vcpu->arch.msr_platform_info =3D MSR_PLATFORM_INFO_CPUID_FAULT;
> >+      vcpu->arch.st.last_suspend_ns =3D kvm_total_suspend_ns();
>
> is this necessary? I doubt this because KVM doesn't capture
> current->sched_info.run_delay here.

Isn't run_delay being captured by the scheduler at all time?

We need to initialize last_suspend_ns otherwise the first call to
record_steal_time() for a VCPU would report a wrong value if
the VCPU is started after the host has already had a suspend.

Thanks,
-- Suleiman

