Return-Path: <kvm+bounces-54546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5BB4B23850
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2977417C55D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED782D3A94;
	Tue, 12 Aug 2025 19:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fuM6o1A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B659F3D994
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026506; cv=none; b=IIcjcUzob2v6rpxvNvz3GxYH0e9bwMyuh485ayMIb3A8rsuLRSv6G92zY3BC71iEypQaYlY4D+1m0mWepZDXDhq9IAMGEuuQlLCTL2jKBCZR0wEE5jVbsLMiEHYzNL4Zf4FoW/lNjDNGUCNXzPDDuQbcZ2l+dCJQlEcVEHZgGaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026506; c=relaxed/simple;
	bh=LZVfSD+9g2iG6Zp/WvEK8nNevTGgD8kpOWiqVjB44vk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G18syyhBu1+gDDl+hJJH7DMYHpuM4MiAvy6Y4sWnTGi0zqvoO6VUT/kLKQ5Pbgu+zxRRBywh2XWtzw1A1R2SZh/Bpwfc5b7ENYAOvzFiqCCEauc5U7TbevBZJ/vj7xwoQX0z8Jz9DEuEZ5QgUwA6/hJNlL+B0cOmpA0ruJe7YEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fuM6o1A; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55b85413019so6905978e87.0
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 12:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755026503; x=1755631303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlLr74oj7kNde5sc/Z7gm+dSIgGuc1b54R25OBGeIpM=;
        b=4fuM6o1A87GoEywpWhXWkX/a3JoAfkZ3iX6RxqzWKFHyOgHRmxjR5QHA799WAsTpkJ
         Vzt4+ljYd4CddiOuNd/zw+5rQ6cDYOyclNdfzOtWQXXT78d+/v1oM8EbwzuhrqP5NQIn
         TvoTFr8Sw1Qm/6MXSSnB2wCI2eVC0440xiaWGuX0rB4UnxSYbi8oOpDhKZ+xjYgKnyNA
         0AHvuoU6HZ30MbD6G+sJRid/JHIyQ6bKBljsSeoSxZf9O5QX4yMrCIy1ZoSDXExMJryv
         jj57T28buHFPozTVtcCCIUwFa3QyRS596lZB7uq/k4+YFsSlibdX4StTbVOmOKTBg6zM
         DFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755026503; x=1755631303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hlLr74oj7kNde5sc/Z7gm+dSIgGuc1b54R25OBGeIpM=;
        b=Jm5E/P9HQkXsk6tWx6Gy45c3xr02F28ORx45acpsIBOo+ypgRbXJgPngJrznpSSnud
         MEbbqrnt64JiboEMEZytFY0YmHTbCWH2vt9/jWyqkHcrocAwr02ytEW6+0HvIuISUQTu
         VoIJPf84sY4tIX8tbZNdS/g9A988Rq6moyvvBwCES+KdrWbwv24CRLFrFf0RiHWxc1Bl
         i69wVZM7oJG9L9sFqHE5CmGvx6o07ihXQeh08Wzk1T3Rw95pKh7gVmJw/l3uxoCFk66G
         ZKU+g0IwWAchjODg6TyMijhUJQ0i5ArYmfliGsqO/S9e1SpTZ7rCzSMbs2quXiUThfvR
         VMiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7kotxQ+TJyU0wClip2crLXMbUO2YFD4QrOLqFFKfpffHsgdFKnkCEVBsbMqY9XI6+wFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMgltHJov52wTstNtxdVdx4J4ifX5vpUmPxeyLywRkqMTIojPi
	+++o+ZKvmhC9BNGi20kMzpSt4sgBjKl0taPemYkcnj+QLSXn/h3YnU0ndXKdMbF99+U0txJdYwa
	whl4Y/pDK4PsdDIzXfMna7qw4jQrdwAO3PG5GPVzI
X-Gm-Gg: ASbGncvW/6Ne5MlIzhRNtsLbQS2Tus+R+q3X0eBsKK2TwBDXQRrpbk4EwClVwKO64Ij
	95NMoEHb79oD0Xm+O0GWVskNNiLhtOmKIhhWJlX9Oi9SwXNwKreQ5l9sokAJA5HD6sf4or8uca7
	G9sm7x6BTlpWcpKqVaGhuC0v25Dxm2OLP7qL/uJGxkY0bxU4j5QtEN/gqH7p9osXnT53c/veQql
	o1m/2Rsl/m0q54SeA==
X-Google-Smtp-Source: AGHT+IGqPXeFIPAOoZ3s0A8sYWXLemJ3PfMIvMNQi0Nr744O5BH7/Angge1d5qoZ3/6X1K5pNizMqNB+48VpK567/a8=
X-Received: by 2002:a2e:612:0:b0:32b:7ddd:275f with SMTP id
 38308e7fff4ca-333e9b459f4mr240711fa.30.1755026502472; Tue, 12 Aug 2025
 12:21:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
 <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
 <aIft7sUk_w8rV2DB@google.com> <CADrL8HWE+TQ8Vm1a=eb5ZKo2+zeeE-b8-PUXLOS0g5KuJ5kfZQ@mail.gmail.com>
 <CALzav=eQWJ-97T7YPt2ikFJ+hPqUSqQ+U_spq8M4vMaQWfasWQ@mail.gmail.com> <aI05DvQlMWJXewUi@google.com>
In-Reply-To: <aI05DvQlMWJXewUi@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 12 Aug 2025 12:21:15 -0700
X-Gm-Features: Ac12FXzy8OiFs2n0sexVrOC6patBND53jwOL-JcXev94xDQT6ChYiHcU-0KraAc
Message-ID: <CALzav=cy8SoVs1N7sCbtqv5b5smGFQi0JNwOdwrQkkv0wMrz8g@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 3:00=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Aug 01, 2025, David Matlack wrote:
> > On Mon, Jul 28, 2025 at 2:49=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index a6a1fb42b2d1..e2bde6a5e346 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -7624,8 +7624,14 @@ static bool kvm_mmu_sp_dirty_logging_enabled=
(struct kvm *kvm,
> > > >  static void kvm_recover_nx_huge_pages(struct kvm *kvm,
> > > >                                       const enum kvm_mmu_type mmu_t=
ype)
> > > >  {
> > > > +#ifdef CONFIG_X86_64
> > > > +       const bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> > > > +       spinlock_t *tdp_mmu_pages_lock =3D &kvm->arch.tdp_mmu_pages=
_lock;
> > > > +#else
> > > > +       const bool is_tdp_mmu =3D false;
> > > > +       spinlock_t *tdp_mmu_pages_lock =3D NULL;
> > > > +#endif
> > > >         unsigned long to_zap =3D nx_huge_pages_to_zap(kvm, mmu_type=
);
> > > > -       bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> > > >         struct list_head *nx_huge_pages;
> > > >         struct kvm_mmu_page *sp;
> > > >         LIST_HEAD(invalid_list);
> > > > @@ -7648,15 +7654,12 @@ static void kvm_recover_nx_huge_pages(struc=
t kvm *kvm,
> > > >         rcu_read_lock();
> > > >
> > > >         for ( ; to_zap; --to_zap) {
> > > > -#ifdef CONFIG_X86_64
> > > >                 if (is_tdp_mmu)
> > > > -                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > > > -#endif
> > > > +                       spin_lock(tdp_mmu_pages_lock);
> > > > +
> > > >                 if (list_empty(nx_huge_pages)) {
> > > > -#ifdef CONFIG_X86_64
> > > >                         if (is_tdp_mmu)
> > > > -                               spin_unlock(&kvm->arch.tdp_mmu_page=
s_lock);
> > > > -#endif
> > > > +                               spin_unlock(tdp_mmu_pages_lock);
> > > >                         break;
> > > >                 }
> > > >
> > > > @@ -7675,10 +7678,8 @@ static void kvm_recover_nx_huge_pages(struct=
 kvm *kvm,
> > > >
> > > >                 unaccount_nx_huge_page(kvm, sp);
> > > >
> > > > -#ifdef CONFIG_X86_64
> > > >                 if (is_tdp_mmu)
> > > > -                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > > -#endif
> > > > +                       spin_unlock(tdp_mmu_pages_lock);
> > > >
> > > >                 /*
> > > >                  * Do not attempt to recover any NX Huge Pages that=
 are being
> > > > --
> > >
> > > LGTM! Thanks Sean.
> >
> > Is the compiler not smart enough to optimize out kvm->arch.tdp_mmu_page=
s_lock?
>
> Yes, the compiler will eliminate dead code at most optimization levels.  =
But that
> optimization phase happens after initial compilation, i.e. the compiler n=
eeds to
> generate the (probably intermediate?) code before it can trim away paths =
that are
> unreachable.
>
> > (To avoid needing the extra local variable?) I thought there was some o=
ther
> > KVM code that relied on similar optimizations but I would have to go di=
g them
> > up to remember.
>
> KVM, and the kernel, absolutely relies on dead code elimination.  KVM mos=
t blatantly
> uses the technique to avoid _defining_ stubs for code that is guarded by =
a Kconfig,
> e.g. all of these functions are defined in sev.c (guarded by CONFIG_KVM_A=
MD_SEV),
> but callers are guarded only with sev_guest() or sev_es_guest(), not with=
 explicit
> #idefs.
>
> There are no build errors because the function calls aren't fully resolve=
d until
> link time (when svm.o is linked into kvm-amd.o).  But KVM still needs to =
_declare_
> the functions, otherwise the compiler would fail during its initial code =
generation.
>
>   int pre_sev_run(struct vcpu_svm *svm, int cpu);
>   void sev_init_vmcb(struct vcpu_svm *svm);
>   void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port,=
 int in);
>   void sev_es_vcpu_reset(struct vcpu_svm *svm);
>   void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es=
_save_area *hostsa);
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>
> Other notable "users" of dead code elimination are the BUILD_BUG_ON() fam=
ily of
> compile-time asserts.  So long as the condition can be resolved to a cons=
tant
> false value during compile time, the "call" to __compiletime_error() will=
 be
> elided and everyone is happy.
>
>   #ifdef __OPTIMIZE__
>   /*
>    * #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
>    * CFLAGS_foo.o=3D-Og" defines __OPTIMIZE__, does not elide the conditi=
onal code
>    * and can break compilation with wrong error message(s). Combine with
>    * -U__OPTIMIZE__ when needed.
>    */
>   # define __compiletime_assert(condition, msg, prefix, suffix)         \
>         do {                                                            \
>                 /*                                                      \
>                  * __noreturn is needed to give the compiler enough     \
>                  * information to avoid certain possibly-uninitialized  \
>                  * warnings (regardless of the build failing).          \
>                  */                                                     \
>                 __noreturn extern void prefix ## suffix(void)           \
>                         __compiletime_error(msg);                       \
>                 if (!(condition))                                       \
>                         prefix ## suffix();                             \
>         } while (0)
>   #else
>   # define __compiletime_assert(condition, msg, prefix, suffix) ((void)(c=
ondition))
>   #endif
>
> Note, static_assert() is different in that it's a true assertion that's r=
esolved
> early on during compilation.
>
>  * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
>  * scope, but requires the expression to be an integer constant
>  * expression (i.e., it is not enough that __builtin_constant_p() is
>  * true for expr).
>
>
> From a previous thread related to asserts (https://lore.kernel.org/all/aF=
GY0KVUksf1a6xB@google.com):
>
>  : The advantage of BUILD_BUG_ON() is that it works so long as the condit=
ion is
>  : compile-time constant, whereas static_assert() requires the condition =
to an
>  : integer constant expression.  E.g. BUILD_BUG_ON() can be used so long =
as the
>  : condition is eventually resolved to a constant, whereas static_assert(=
) has
>  : stricter requirements.
>  :
>  : E.g. the fls64() assert below is fully resolved at compile time, but i=
sn't a
>  : purely constant expression, i.e. that one *needs* to be BUILD_BUG_ON()=
.
>  :
>  : --
>  : arch/x86/kvm/svm/avic.c: In function =E2=80=98avic_init_backing_page=
=E2=80=99:
>  : arch/x86/kvm/svm/avic.c:293:45: error: expression in static assertion =
is not constant
>  :   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
>  : include/linux/build_bug.h:78:56: note: in definition of macro =E2=80=
=98__static_assert=E2=80=99
>  :    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, m=
sg)
>  :       |                                                        ^~~~
>  : arch/x86/kvm/svm/avic.c:293:9: note: in expansion of macro =E2=80=98st=
atic_assert=E2=80=99
>  :   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
>  :       |         ^~~~~~~~~~~~~
>  : make[5]: *** [scripts/Makefile.build:203: arch/x86/kvm/svm/avic.o] Err=
or 1
>  : --
>  :
>  : The downside of BUILD_BUG_ON() is that it can't be used at global scop=
e, i.e.
>  : needs to be called from a function.
>  :
>  : As a result, when adding an assertion in a function, using BUILD_BUG_O=
N() is
>  : slightly preferred, because it's less likely to break in the future.  =
E.g. if
>  : X2AVIC_MAX_PHYSICAL_ID were changed to something that is a compile-tim=
e constant,
>  : but for whatever reason isn't a pure integer constant.

Thank you so much for the detailed explanation!

