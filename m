Return-Path: <kvm+bounces-53859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E59BB1890F
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8776AA39F7
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 22:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B122264CC;
	Fri,  1 Aug 2025 22:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TTieYSsw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3F91D63C5
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 22:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754085650; cv=none; b=ZMqYpMgML693AVjwbUpvyZlWo+8CzC3HWunvXSzrQ/3wuOq92+9JjPMm09V8hXNCs+o3P6l46Clz5uu7HNxGZ0IcAknEMT7lpPNwhpGRRgv//5yFfwjA9j0vmxYaEr1+C521vtuHD0nOv8n/r/MPYJi5QMynDXHyYkNz47vMvN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754085650; c=relaxed/simple;
	bh=FJbGcCue6qpLoRxmdJLZqLsTcNdoa2JmYIW1qA7u5j8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jtxriOpES4sjHWLq9bKLSAHDy5Scti3+EkaerdDX9fKiGZVKan5CG/tTSR8u1e8HJtLIegJGWFTp/lvrxmQqa6CSEaFn5eSC7CDu/r15cJfEPQ2+vM1zQ0AbSEPm8/j2p+qN+KEQXs9iylewCvhCs+meYkf5knD94Q1vXTSBFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TTieYSsw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so2324557a91.2
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 15:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754085648; x=1754690448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6hWtAmBq8NWkkuIGz9saUWFccZ5KABPtbv3tcTlVdv8=;
        b=TTieYSswxKwNhUnyptysmvCWduxxv0FDM2p/phhiJHW6/JUGUDpJllnDABRVsL6P9I
         C8Fgz0CnbAzsAvrwGV5g9Wgls5D/0r2S1qn6bOkNe0Ag2e2Hko5JJ4SDy6oN7QVduW38
         vlbQ9r1OsOKopR8JxEPKbt+ywS6Cme5GtSOiHx6EFLYEtJH2Hp4bJwBzKVGMeQNwqgOy
         VuUQtdgjfI/TKIPUUrwUbVxxybSMPBxleBWjbDu9559JinlvoMNVZXkaXAmAra6jPZmx
         USy5UNjxvxNgyKgspInQXYcIhwRAiLwGI6a8fDxwUG1WskPAbAJytvtP+AbKjQxlsAc8
         GGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754085648; x=1754690448;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6hWtAmBq8NWkkuIGz9saUWFccZ5KABPtbv3tcTlVdv8=;
        b=PLMTlw/MYFDlDczeWYb7jUUAOHmSoqWx03uAR7aPMUmh29xfpwEJFwf0Z0SvNYfu06
         qW16fmrcLfCuRI8TPZrppNCOfUFD/+YylB+iWYSSSFDqEDDYlZV5w3K0qS8mAKlhZALh
         099BHeu1DpBcFhRhT3TJnl/qKm0JF+UckPGpp8zN65grIwZAMGglcvVATi9zsIXOm69h
         eT9xjiIziuVP4qyhylgw7hwJyBWR6CvcXOGgu8gb1tDk0NtZf06Ept6szCrWvSRUL738
         zuBV21REjK1MkiExQ/5F1bxwfEAZ7LNEO3c7J+It0m0Guw4Ltp/1xtiNQcGZz0h+PLL1
         6i7g==
X-Forwarded-Encrypted: i=1; AJvYcCXweKk6rZi4IhmHK1NzGeVPu+bIL8ZVcv677VIZlJ1hhtBBQVFM7Z+3lVtgwABoEUIHBMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwojRM/+xYhFIjUnK4u5vPdjmeLA5NR7QMGDunQltRnqAYd56Pz
	6gxRaEa5TzXodYQf9vq8wL5RSEuSeMGPHYm8eiGrATVegfIuPNWsQlEAcs2YZIphyv5TlHxWiJW
	IOS/A4g==
X-Google-Smtp-Source: AGHT+IGfcgNlNPWZ5oNIPHk6Lj5LPjCCB2x8xNhsWx0DyHgtmxUxN/54VjWC/Vymhntx9L93TmAfrNXldKw=
X-Received: from pjbqx16.prod.google.com ([2002:a17:90b:3e50:b0:313:242b:1773])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c88:b0:31e:b77c:1f09
 with SMTP id 98e67ed59e1d1-321162b4134mr1730610a91.19.1754085648200; Fri, 01
 Aug 2025 15:00:48 -0700 (PDT)
Date: Fri, 1 Aug 2025 15:00:46 -0700
In-Reply-To: <CALzav=eQWJ-97T7YPt2ikFJ+hPqUSqQ+U_spq8M4vMaQWfasWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
 <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
 <aIft7sUk_w8rV2DB@google.com> <CADrL8HWE+TQ8Vm1a=eb5ZKo2+zeeE-b8-PUXLOS0g5KuJ5kfZQ@mail.gmail.com>
 <CALzav=eQWJ-97T7YPt2ikFJ+hPqUSqQ+U_spq8M4vMaQWfasWQ@mail.gmail.com>
Message-ID: <aI05DvQlMWJXewUi@google.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2025, David Matlack wrote:
> On Mon, Jul 28, 2025 at 2:49=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index a6a1fb42b2d1..e2bde6a5e346 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -7624,8 +7624,14 @@ static bool kvm_mmu_sp_dirty_logging_enabled(s=
truct kvm *kvm,
> > >  static void kvm_recover_nx_huge_pages(struct kvm *kvm,
> > >                                       const enum kvm_mmu_type mmu_typ=
e)
> > >  {
> > > +#ifdef CONFIG_X86_64
> > > +       const bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> > > +       spinlock_t *tdp_mmu_pages_lock =3D &kvm->arch.tdp_mmu_pages_l=
ock;
> > > +#else
> > > +       const bool is_tdp_mmu =3D false;
> > > +       spinlock_t *tdp_mmu_pages_lock =3D NULL;
> > > +#endif
> > >         unsigned long to_zap =3D nx_huge_pages_to_zap(kvm, mmu_type);
> > > -       bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> > >         struct list_head *nx_huge_pages;
> > >         struct kvm_mmu_page *sp;
> > >         LIST_HEAD(invalid_list);
> > > @@ -7648,15 +7654,12 @@ static void kvm_recover_nx_huge_pages(struct =
kvm *kvm,
> > >         rcu_read_lock();
> > >
> > >         for ( ; to_zap; --to_zap) {
> > > -#ifdef CONFIG_X86_64
> > >                 if (is_tdp_mmu)
> > > -                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > > -#endif
> > > +                       spin_lock(tdp_mmu_pages_lock);
> > > +
> > >                 if (list_empty(nx_huge_pages)) {
> > > -#ifdef CONFIG_X86_64
> > >                         if (is_tdp_mmu)
> > > -                               spin_unlock(&kvm->arch.tdp_mmu_pages_=
lock);
> > > -#endif
> > > +                               spin_unlock(tdp_mmu_pages_lock);
> > >                         break;
> > >                 }
> > >
> > > @@ -7675,10 +7678,8 @@ static void kvm_recover_nx_huge_pages(struct k=
vm *kvm,
> > >
> > >                 unaccount_nx_huge_page(kvm, sp);
> > >
> > > -#ifdef CONFIG_X86_64
> > >                 if (is_tdp_mmu)
> > > -                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > -#endif
> > > +                       spin_unlock(tdp_mmu_pages_lock);
> > >
> > >                 /*
> > >                  * Do not attempt to recover any NX Huge Pages that a=
re being
> > > --
> >
> > LGTM! Thanks Sean.
>=20
> Is the compiler not smart enough to optimize out kvm->arch.tdp_mmu_pages_=
lock?

Yes, the compiler will eliminate dead code at most optimization levels.  Bu=
t that
optimization phase happens after initial compilation, i.e. the compiler nee=
ds to
generate the (probably intermediate?) code before it can trim away paths th=
at are
unreachable.

> (To avoid needing the extra local variable?) I thought there was some oth=
er
> KVM code that relied on similar optimizations but I would have to go dig =
them
> up to remember.

KVM, and the kernel, absolutely relies on dead code elimination.  KVM most =
blatantly
uses the technique to avoid _defining_ stubs for code that is guarded by a =
Kconfig,
e.g. all of these functions are defined in sev.c (guarded by CONFIG_KVM_AMD=
_SEV),
but callers are guarded only with sev_guest() or sev_es_guest(), not with e=
xplicit
#idefs.

There are no build errors because the function calls aren't fully resolved =
until
link time (when svm.o is linked into kvm-amd.o).  But KVM still needs to _d=
eclare_
the functions, otherwise the compiler would fail during its initial code ge=
neration.

  int pre_sev_run(struct vcpu_svm *svm, int cpu);
  void sev_init_vmcb(struct vcpu_svm *svm);
  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, i=
nt in);
  void sev_es_vcpu_reset(struct vcpu_svm *svm);
  void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_s=
ave_area *hostsa);
  void sev_es_unmap_ghcb(struct vcpu_svm *svm);

Other notable "users" of dead code elimination are the BUILD_BUG_ON() famil=
y of
compile-time asserts.  So long as the condition can be resolved to a consta=
nt
false value during compile time, the "call" to __compiletime_error() will b=
e
elided and everyone is happy.

  #ifdef __OPTIMIZE__
  /*
   * #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
   * CFLAGS_foo.o=3D-Og" defines __OPTIMIZE__, does not elide the condition=
al code
   * and can break compilation with wrong error message(s). Combine with
   * -U__OPTIMIZE__ when needed.
   */
  # define __compiletime_assert(condition, msg, prefix, suffix)		\
	do {								\
		/*							\
		 * __noreturn is needed to give the compiler enough	\
		 * information to avoid certain possibly-uninitialized	\
		 * warnings (regardless of the build failing).		\
		 */							\
		__noreturn extern void prefix ## suffix(void)		\
			__compiletime_error(msg);			\
		if (!(condition))					\
			prefix ## suffix();				\
	} while (0)
  #else
  # define __compiletime_assert(condition, msg, prefix, suffix) ((void)(con=
dition))
  #endif

Note, static_assert() is different in that it's a true assertion that's res=
olved
early on during compilation.

 * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
 * scope, but requires the expression to be an integer constant
 * expression (i.e., it is not enough that __builtin_constant_p() is
 * true for expr).


From a previous thread related to asserts (https://lore.kernel.org/all/aFGY=
0KVUksf1a6xB@google.com):

 : The advantage of BUILD_BUG_ON() is that it works so long as the conditio=
n is
 : compile-time constant, whereas static_assert() requires the condition to=
 an
 : integer constant expression.  E.g. BUILD_BUG_ON() can be used so long as=
 the
 : condition is eventually resolved to a constant, whereas static_assert() =
has
 : stricter requirements.
 :=20
 : E.g. the fls64() assert below is fully resolved at compile time, but isn=
't a
 : purely constant expression, i.e. that one *needs* to be BUILD_BUG_ON().
 :=20
 : --
 : arch/x86/kvm/svm/avic.c: In function =E2=80=98avic_init_backing_page=E2=
=80=99:
 : arch/x86/kvm/svm/avic.c:293:45: error: expression in static assertion is=
 not constant
 :   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
 : include/linux/build_bug.h:78:56: note: in definition of macro =E2=80=98_=
_static_assert=E2=80=99
 :    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg=
)
 :       |                                                        ^~~~
 : arch/x86/kvm/svm/avic.c:293:9: note: in expansion of macro =E2=80=98stat=
ic_assert=E2=80=99
 :   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
 :       |         ^~~~~~~~~~~~~
 : make[5]: *** [scripts/Makefile.build:203: arch/x86/kvm/svm/avic.o] Error=
 1
 : --
 :=20
 : The downside of BUILD_BUG_ON() is that it can't be used at global scope,=
 i.e.
 : needs to be called from a function.
 :=20
 : As a result, when adding an assertion in a function, using BUILD_BUG_ON(=
) is
 : slightly preferred, because it's less likely to break in the future.  E.=
g. if
 : X2AVIC_MAX_PHYSICAL_ID were changed to something that is a compile-time =
constant,
 : but for whatever reason isn't a pure integer constant.

