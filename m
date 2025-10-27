Return-Path: <kvm+bounces-61215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDF1C10587
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2132463B11
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45B732548B;
	Mon, 27 Oct 2025 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EfhYwleY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8295E32B9A2
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591009; cv=none; b=NpUVdrB38U4tYoiMV9UfD5XTdzG9JgnJ4dFEgg0KSEU403q1cszsvYIHZonSEXjuKdnu96WCz4RVHVgYAK5cscdPrbO7Fo1RAAna1KiFlqn7v2xGb09aepX7c3tW2DNF0E2QkFZxd9mVTWCfp9PY5VedHRPQbY8k7ktTt105M3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591009; c=relaxed/simple;
	bh=LHo4hqgw05W9d5Nifk75Y/zx91VbS2TazCr1UluRyXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zyv/ZVK7Y1KiVLzU+cD1TKYmHOpK3SHDsumR33TyCk887yZwZevu8q4ilME6DmPbLIsuAggyA1JsdGlYTaiSBBU1HrmzY1OFObuCrAEyxvQlRrMSnKXRWu/UKNb/NW1wB+pYaBhIwtk5SoapnKKk7GMiRkD3wfHEktbAcw01lmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EfhYwleY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-781171fe1c5so4057336b3a.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761591005; x=1762195805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lm7/Sgbdrc5iUiEYI9clRPMJG97DXWwp5LdVn77LF3E=;
        b=EfhYwleYx9CtjALj+dsPn52USNx6UJSxtGrFZa4dNvgBooF/bbQ18tz5/vXZzERluk
         UwzeEo9C9iTY6HGmyTADopQj8X0q2AeSbkislFPxClKqk3WwjEtrEbbbvs/BFkPiS2mY
         kNeexsIWVb9fcXAxPLxQxl8xVTGOMIVpgn5oDtBxJlCqNQw0gtancAegVqSJNGuvOqVV
         WqHej0qOt6GMO8tpIS5uzs53bJiiz8dHLXUA2Nb+tFMfRX8jUJPhTATqoALjInCwVn7h
         BOIMQmZBHAfA6N/kLsJkjI48qdLtEtC4xzO/vY+6KcrNFfc95JFXdfXzc/NHPKpIXh0h
         LRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761591005; x=1762195805;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lm7/Sgbdrc5iUiEYI9clRPMJG97DXWwp5LdVn77LF3E=;
        b=W/ZYDdXTYcb/WlqvGggIx8XCmWVdFv9v5cr88ZPvEb5MX6oXEOTValclbD8hG8UN9T
         RnXl1h4AECMC7rF5yD1Xgi0uNstVPjrBEGjxhLTDxLN3ZF0+HwU2412bE30VJiorBKke
         w+nTdS9Yc/vJliDgVHz1XXPzV+PsknXIxPJvkOv9uyEp/EJBhTNDni7dA08xp8HvJ5Ly
         NzKoRcdIvKjMXyMqW4bvOMJXZUh+Hw2AKTIvT/z2Pii3CcW9L16tErCW9CkcNh1K8kFB
         zx7JCb11oXhcTEvSdvVFTl8FS480RxBN5v7yUKk3P8BuGJpa/QcQt36kSvLitc+d0DOW
         i7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXUT+9KZr+pWtNUrpDh3FHm1nPGjMXfyr519c4luOn4a+i32omiiHuVYMZzRgBbczkiRgg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqb4kPMbO+PAfRDJIoX7Ps6yvy2N1LRsOuxseyDgaEq4ormCWa
	rA+Bfi3wvN6FKkfWNlJAWvo2zuaJsXr4kaQ47JbDrgyCBANBRcIMSqPcZ3OaYTJR1YF4Nd0r1Di
	VFmzCxg==
X-Google-Smtp-Source: AGHT+IFcHQUWl/n2orMHwgarOtwpKpctRVIL9CN5RMw5fhIsqXF7RhESup4auAxNzvkEUHSpAcaEU4w5zxY=
X-Received: from pjboi8.prod.google.com ([2002:a17:90b:3a08:b0:32e:b34b:92eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a108:b0:341:262f:651c
 with SMTP id adf61e73a8af0-344d228b3f1mr831535637.25.1761591004736; Mon, 27
 Oct 2025 11:50:04 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:50:03 -0700
In-Reply-To: <CALzav=eV6OQXSkL-AF7LoOzQ4gsWpfn395UdU2=P7NGChZWX8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com> <20250912222525.2515416-3-dmatlack@google.com>
 <aP-jZOVdrIVB_qaV@google.com> <CALzav=eV6OQXSkL-AF7LoOzQ4gsWpfn395UdU2=P7NGChZWX8g@mail.gmail.com>
Message-ID: <aP--2xUoRt4pixsM@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Add a test for vfio-pci device IRQ
 delivery to vCPUs
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, David Matlack wrote:
> On Mon, Oct 27, 2025 at 9:52=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
>=20
> Thank you for the feedback!
>=20
> > On Fri, Sep 12, 2025, David Matlack wrote:
> > >
> > > This test only supports x86_64 for now, but can be ported to other
> > > architectures in the future.
> >
> > Can it though?  There are bits and pieces that can be reused, but this =
test is
> > x86 through and through.
>=20
> Delivering MSIs from a vfio-pci device into a guest is not an
> x86-specific thing. But I think you could make the argument that it
> will be simpler for each architecture to have their own version of
> this test, with some shared code, rather than the other way around.

Right, the concept is x86, but the code as written is very x86 centric.

> > > +static void guest_irq_handler(struct ex_regs *regs)
> > > +{
> > > +     WRITE_ONCE(guest_received_irq[guest_get_vcpu_id()], true);
> >
> > Hmm, using APID ID works, but I don't like the hidden dependency on the=
 library
> > using ascending IDs starting from '0'.  This would also be a good oppor=
tunity to
> > improve the core infrastructure.
>=20
> What dependency are you referring to? I think the only requirement is
> vcpu->id =3D=3D APIC ID

Yep, this one.

> Are you saying tests should not make that assumption?

Ya, ideally, they would not.

> > > +     WRITE_ONCE(vcpu_tids[vcpu->id], syscall(__NR_gettid));
> >
> > Please add wrapper in tools/testing/selftests/kvm/include/kvm_syscalls.=
h.
>=20
> Will do.
>=20
> > > +static void pin_vcpu_threads(int nr_vcpus, int start_cpu, cpu_set_t =
*available_cpus)
> > > +{
> > > +     const size_t size =3D sizeof(cpu_set_t);
> > > +     int nr_cpus, cpu, vcpu_index =3D 0;
> > > +     cpu_set_t target_cpu;
> > > +     int r;
> > > +
> > > +     nr_cpus =3D get_nprocs();
> >
> > Generally speaking, KVM selftests try to avoid affining tasks to CPUs t=
hat are
> > outside of the original affinity list.  See various usage of sched_geta=
ffinity().
>=20
> available_cpus is initialized by calling sched_getaffinity().

Ah, I missed that in the for-loop.
=20
> > > +static FILE *open_proc_interrupts(void)
> > > +{
> > > +     FILE *fp;
> > > +
> > > +     fp =3D fopen("/proc/interrupts", "r");
> > > +     TEST_ASSERT(fp, "fopen(/proc/interrupts) failed");
> >
> > open_path_or_exit()?
>=20
> I guess I'll have to rework this code to use fds instead of FILE?

Hmm, not necessarily.  E.g. maybe open_file_or_exit()?  I don't have a stro=
ng
preference (and have put zero thought into what would work well).
=20
> > > +int main(int argc, char **argv)
> > > +{
> > > +     /* Random non-reserved vector and GSI to use for the device IRQ=
 */
> > > +     const u8 vector =3D 0xe0;
> >
> > s/random/arbitrary
> >
> > Why not make it truly random?
>=20
> Only because there's already a lot going on in this test. Do you think
> it's worth randomizing these?

Probably?  But without a command line option, to keep this somewhat less cr=
azy?

> > > +     irq_count =3D get_irq_count(irq);
> > > +     pin_count =3D __get_irq_count("PIN:");
> > > +     piw_count =3D __get_irq_count("PIW:");
> >
> > This is obviously very Intel specific information.  If you're going to =
print the
> > posted IRQ info, then the test should also print e.g. AMD GALogIntr eve=
nts.
>=20
> I saw PIN and PIW in /proc/interrupts when I tested on AMD hosts,

The kernel really should key off CONFIG_KVM_INTEL=3D{m,y}, not CONFIG_KVM (=
though
in practice it doesn't matter all that much).

> that's why I included them both by default.

I think it makes sense to only print PIN+PIW on Intel, otherwise it's pure =
noise.

> I can look into adding GALogIntr if you want.

PIN is midly interesting.  PIW and GALogIntr are much more interesting from=
 a
coverage perspective.  E.g. if the deltas for PIW and GALogIntr are '0', th=
en
the test likely isn't exercising the blocking path.

> > > +     /* Set a consistent seed so that test are repeatable. */
> > > +     srand(0);
> >
> > We should really figure out a solution for reproducible random numbers =
in the
> > host.  Ah, and kvm_selftest_init()'s handling of guest random seeds is =
flawed,
> > because it does random() without srand() and so AFAICT, gets the same s=
eed every
> > time.  E.g. seems like we want something like this, but with a way to o=
verride
> > "random_seed" from a test.
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing=
/selftests/kvm/lib/kvm_util.c
> > index 5744643d9ec3..0118fd2ba56b 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2310,6 +2310,7 @@ void __attribute((constructor)) kvm_selftest_init=
(void)
> >         struct sigaction sig_sa =3D {
> >                 .sa_handler =3D report_unexpected_signal,
> >         };
> > +       int random_seed;
> >
> >         /* Tell stdout not to buffer its content. */
> >         setbuf(stdout, NULL);
> > @@ -2319,8 +2320,13 @@ void __attribute((constructor)) kvm_selftest_ini=
t(void)
> >         sigaction(SIGILL, &sig_sa, NULL);
> >         sigaction(SIGFPE, &sig_sa, NULL);
> >
> > +       random_seed =3D time(NULL);
> > +       srand(random_seed);
> > +
> >         guest_random_seed =3D last_guest_seed =3D random();
> > -       pr_info("Random seed: 0x%x\n", guest_random_seed);
> > +
> > +       pr_info("Guest random seed: 0x%x (srand: 0x%x)\n",
> > +               guest_random_seed, random_seed);
> >
> >         kvm_selftest_arch_init();
> >  }
>=20
> Just to make sure I understand: You are proposing using the current
> time as the seed

Or anything that's somewhat random.  I don't know what glibc is doing under=
 the
hood, so it's entirely possible/likely there's a much better method.

> and printing it to the console. That way each run uses a different random
> seed and we get broader test coverage. Then if someone wants to reproduce=
 a
> test result, there would be some way for them to override the seed via
> cmdline? That sounds reasonable to me, I can take a look at adding that i=
n
> the next version.

Yep.  That was the intent with the guest_random_seed, I just didn't impleme=
nt it
very well :-)

Regarding reproducibility, one idea would be to have kvm_selftest_init() pu=
ll the
seed from an environment variable, e.g. so that reproducing with a specific=
 seed
doesn't require hacking or test support.  I'm not entirely sure I like the =
idea
of using environment variables though...

