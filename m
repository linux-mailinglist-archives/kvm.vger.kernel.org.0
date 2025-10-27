Return-Path: <kvm+bounces-61211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D11DBC0FBEF
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB28422080
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87312BE647;
	Mon, 27 Oct 2025 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYf/7TlC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8221DF26A
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761587206; cv=none; b=ahaY+bxbjWQSi5zJOW0Ffhrk3IcSVTW9TGp++UVXiLn3LYfiI+TagB00KGxKxF1L625KBtk2BzdRm4vU99964daAH/W6HUkGWJEfVqcQTJHkLX5wzaLzMdH4U7HY+5qFcAvVvOe+kebd9RuVuQrUWn/yGH3FQ8FbEfyXYMx+oAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761587206; c=relaxed/simple;
	bh=VcG5+XrvrT1sRlh00mVu9cyDAkrQ1aMhBFqFLZQAOQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucQlyWxbAOPpHRENBGbreiqcPSdmhIP28dXf4l5wxxdtuyqRvQpWufSRBMFS3RBaVqhz9I3ojn89ZNDLREbsOoebuKyIBZR/QH8ULcXpR1THpTKadNF8JVDFZxs7GJltQ9hL63VJxpqx4j7Lq9T9T/oKecwd3poagyxzo/fsfAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYf/7TlC; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3717780ea70so64914871fa.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761587202; x=1762192002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/OxAieWT1IlZT6K7vEkuqxMdOaiR3DM/O5Sopg8BcA=;
        b=YYf/7TlCNLYSIMdr1QJTpZcYoXLRc5EZdz6CAlHgWOWXWhWXFg2FSeYPu4SMmjwzzZ
         9uVHXi2RjLoFVDM4fGoYMVkt+hbwCyX/wZLqk9F+Qmj1OAtL3Mc4NJVkF5VqhE91ulNa
         hJ17Pnq3+1Nf7w20HTAyrw/krmrhoWtf+Rzy1EYg7rDU+6Jx6bn+4fWhQxEaUtnQWyi5
         8GvCJBX/qTG/2PwjxK5FqVPriIsT3Wv49xIDHRI7D8a+ss9sR4CKoq6duYSm8UygRRmP
         wnRAGGsKW4NUNI70zs39D7OA17SVGztI6p8LqqHQFA+aFpIBUFKiSqMeCSz5x6WqEQo5
         jkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761587202; x=1762192002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/OxAieWT1IlZT6K7vEkuqxMdOaiR3DM/O5Sopg8BcA=;
        b=YoBsEZULVt9lOjvs8BfUOMlUQhszNJlU6N3GEQsngSgpaDfud4+JQ5PGG2qfuqG4E3
         2gCRa+2aHNnt1bhxs8Kve4aVyUZWAdQP8Kh9tj2KruU5mJ6o0/BbZPmmvFwklSI9Q4wc
         ObrTkdr8tQPq7qhWjA3Qrz/NJX1UqrvgzJb4/itpAWfe/GruAyamA81JRWyFQYgV7mfg
         OLL6ML0+B4QbhwRsS0DizHq4yBlGNVMgs8jifOXFzI/z3EHFKEGk23Xh9Q8IeuyZLicX
         kXZjDh9J+W6J3TlHpkiU8ZojwzfwLHLcaenlDGttBle4WAHwBZ4qzWkDShsRlPzM+929
         O2Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWDnkyhNZNE2NCBPH+qQcHtY5AVprrhNUTr2CT17GN2/lc6Gdh65f9OX2jCMD/9NfC5aqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWsaT4IhMkmqnFKZyEa0OloEXJx+VH0dQBXuHom2lEZZBOFxnL
	H+s4Is+qPOO02k/TeFx4HKuozDS7TeOq1Q4myQfGfBKtxwf5n4u5CmhqMxV38HcM17ae1y+eqrB
	i4IncKmpp8Gu3bFhnGOYWyJKbJ3QvyKTJ+JRfNRap
X-Gm-Gg: ASbGnctZGjrQ+yfgaEmw6Ieb7LmD2cphw2F1uRZDDYX6ASRec9tN2Cbkjyj1ogIW3Z4
	Q1Jj4siX8DAS9hyEdSe3mY/4Agt5+nfMa10XwNt8FiYy+YumxlT2NKYS7KfwHw7tEpt/qlXWEiA
	k6b4/lcKTnMbv9+tC4kOTOLyGyFtxdWK6zRQ6su7F3v6/C0/SIIjVnIG5zRJBfd7N4GTDMhvRyy
	/Tx19QREbOVKgftiyK6plHPZ0Jh5u+pxZTe+EDcdNN6YQcGXyF0y6fF70/3XLZZWzpZqhA=
X-Google-Smtp-Source: AGHT+IHkh278KwfUHPTzc5VicZripZvZrUk0vB++mCtwjLhz+uh7rj9RS70YXfJyBQCKh3CzASqgCkSwgmM2v4er/sU=
X-Received: by 2002:a05:651c:2450:10b0:373:a537:6a00 with SMTP id
 38308e7fff4ca-3790773be31mr1223281fa.30.1761587202208; Mon, 27 Oct 2025
 10:46:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com> <20250912222525.2515416-3-dmatlack@google.com>
 <aP-jZOVdrIVB_qaV@google.com>
In-Reply-To: <aP-jZOVdrIVB_qaV@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 10:46:14 -0700
X-Gm-Features: AWmQ_bl-uhT1aNzDhVn581PsXGZQcal3BydVSD19tHZW9f1erZWj44XAaoDjX2Y
Message-ID: <CALzav=eV6OQXSkL-AF7LoOzQ4gsWpfn395UdU2=P7NGChZWX8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Add a test for vfio-pci device IRQ
 delivery to vCPUs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 9:52=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:

Thank you for the feedback!

> On Fri, Sep 12, 2025, David Matlack wrote:
> >
> > This test only supports x86_64 for now, but can be ported to other
> > architectures in the future.
>
> Can it though?  There are bits and pieces that can be reused, but this te=
st is
> x86 through and through.

Delivering MSIs from a vfio-pci device into a guest is not an
x86-specific thing. But I think you could make the argument that it
will be simpler for each architecture to have their own version of
this test, with some shared code, rather than the other way around.

> >  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> >  .../testing/selftests/kvm/vfio_pci_irq_test.c | 507 ++++++++++++++++++
>
> Please break this into multiple patches, e.g. a "basic" patch and and the=
n roughly
> one per "advanced" command line option.

Will do.

> > +static pid_t vcpu_tids[KVM_MAX_VCPUS];
>
> s/tids/pids?

This stores output from gettid(), so tids felt more appropriate.

> > +#define TIMEOUT_NS (2ULL * 1000 * 1000 * 1000)
>
> The timeout should be configurable via command line.

Will do.

> > +#define READ_FROM_GUEST(_vm, _variable) ({           \
> > +     sync_global_from_guest(_vm, _variable);         \
> > +     READ_ONCE(_variable);                           \
> > +})
> > +
> > +#define WRITE_TO_GUEST(_vm, _variable, _value) do {  \
> > +     WRITE_ONCE(_variable, _value);                  \
> > +     sync_global_to_guest(_vm, _variable);           \
> > +} while (0)
>
> These belong in a separate patch, and in tools/testing/selftests/kvm/incl=
ude/kvm_util.h.

Will do.

> > +static void guest_enable_interrupts(void)
>
> This is a misleading name, e.g. I would expect it to _just_ be sti_nop().=
  If the
> intent is to provide a hook for a potential non-x86 implementation, then =
it should
> probably be split into guest_arch_test_setup() and guest_arch_irq_enable(=
) or so
> (to align with the kernel's local_irq_{dis,en}able()).
>
> As is, I would just omit the helper.

Will do.

> > +static void guest_irq_handler(struct ex_regs *regs)
> > +{
> > +     WRITE_ONCE(guest_received_irq[guest_get_vcpu_id()], true);
>
> Hmm, using APID ID works, but I don't like the hidden dependency on the l=
ibrary
> using ascending IDs starting from '0'.  This would also be a good opportu=
nity to
> improve the core infrastructure.

What dependency are you referring to? I think the only requirement is
vcpu->id =3D=3D APIC ID. Are you saying tests should not make that
assumption?

> > +     WRITE_ONCE(vcpu_tids[vcpu->id], syscall(__NR_gettid));
>
> Please add wrapper in tools/testing/selftests/kvm/include/kvm_syscalls.h.

Will do.

> > +static void pin_vcpu_threads(int nr_vcpus, int start_cpu, cpu_set_t *a=
vailable_cpus)
> > +{
> > +     const size_t size =3D sizeof(cpu_set_t);
> > +     int nr_cpus, cpu, vcpu_index =3D 0;
> > +     cpu_set_t target_cpu;
> > +     int r;
> > +
> > +     nr_cpus =3D get_nprocs();
>
> Generally speaking, KVM selftests try to avoid affining tasks to CPUs tha=
t are
> outside of the original affinity list.  See various usage of sched_getaff=
inity().

available_cpus is initialized by calling sched_getaffinity().

> > +static FILE *open_proc_interrupts(void)
> > +{
> > +     FILE *fp;
> > +
> > +     fp =3D fopen("/proc/interrupts", "r");
> > +     TEST_ASSERT(fp, "fopen(/proc/interrupts) failed");
>
> open_path_or_exit()?

I guess I'll have to rework this code to use fds instead of FILE?

>
> > +
> > +     return fp;
> > +}
>
> And all of these /proc helpers belong in library code.

Will do.

> > +static int setup_msi(struct vfio_pci_device *device, bool use_device_m=
si)
> > +{
> > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > +     const int prot =3D PROT_READ | PROT_WRITE;
> > +     struct vfio_dma_region *region;
> > +
> > +     if (use_device_msi) {
> > +             /* A driver is required to generate an MSI. */
> > +             TEST_REQUIRE(device->driver.ops);
> > +
> > +             /* Set up a DMA-able region for the driver to use. */
>
> Why?

I will extend the comment to explain.

Each driver needs DMA-able memory so that it can post commands to the
device to get the device to perform actions like sending an MSI and
doing a memcpy.

You might wonder why tests have to worry about setting up this region
and why the driver doesn't just do it automatically. That is because
some tests will want to control how the memory is mapped in the host
(e.g. Live Update tests want to use memfds so it can persist them
across Live Update) and how it is mapped into the IOMMU.

That being said, I think it would be worth adding a helper to set up a
default mapping for drivers for tests that don't care.

>
> > +             region =3D &device->driver.region;
> > +             region->iova =3D 0;
> > +             region->size =3D SZ_2M;
> > +             region->vaddr =3D mmap(NULL, region->size, prot, flags, -=
1, 0);
>
> kvm_mmap()

Will do.

> > +static void send_msi(struct vfio_pci_device *device, bool use_device_m=
si, int msi)
>
> IMO, this helper does more harm than good.  There is only one real user, =
the
> second call unconditionally passes %false for @use_device_msi.
>
> If you drop the helper, than there should be no need to assert that the M=
SI is
> the device MSI on *every* send via device.

Will do.

> > +int main(int argc, char **argv)
> > +{
> > +     /* Random non-reserved vector and GSI to use for the device IRQ *=
/
> > +     const u8 vector =3D 0xe0;
>
> s/random/arbitrary
>
> Why not make it truly random?

Only because there's already a lot going on in this test. Do you think
it's worth randomizing these?

> > +     irq_count =3D get_irq_count(irq);
> > +     pin_count =3D __get_irq_count("PIN:");
> > +     piw_count =3D __get_irq_count("PIW:");
>
> This is obviously very Intel specific information.  If you're going to pr=
int the
> posted IRQ info, then the test should also print e.g. AMD GALogIntr event=
s.

I saw PIN and PIW in /proc/interrupts when I tested on AMD hosts,
that's why I included them both by default.

I can look into adding GALogIntr if you want.

> > +     if (pin_vcpus) {
> > +             ret =3D sched_getaffinity(vcpu_tids[0], sizeof(available_=
cpus), &available_cpus);
> > +             TEST_ASSERT(ret =3D=3D 0, "sched_getaffinity() failed");
>
> !ret
>
> Though this is another syscall that deserves a wrapper in kvm_syscalls.h.

Will do.

> > +             if (nr_vcpus > CPU_COUNT(&available_cpus)) {
> > +                     printf("There are more vCPUs than pCPUs; refusing=
 to pin.\n");
> > +                     pin_vcpus =3D false;
>
> Why is this not an assertion?  Alternatively, why not double/triple/quadr=
uple up
> as needed?

I don't recall why I added this... I can probably just drop it in the
next version. I'll report back here if I remember why when working on
v2.

> > +     if (irq_affinity) {
> > +             char path[PATH_MAX];
> > +
> > +             snprintf(path, sizeof(path), "/proc/irq/%d/smp_affinity_l=
ist", irq);
> > +             irq_affinity_fp =3D fopen(path, "w");
> > +             TEST_ASSERT(irq_affinity_fp, "fopen(%s) failed", path);
>
> More code that belongs in the library.

Will do.

> > +     /* Set a consistent seed so that test are repeatable. */
> > +     srand(0);
>
> We should really figure out a solution for reproducible random numbers in=
 the
> host.  Ah, and kvm_selftest_init()'s handling of guest random seeds is fl=
awed,
> because it does random() without srand() and so AFAICT, gets the same see=
d every
> time.  E.g. seems like we want something like this, but with a way to ove=
rride
> "random_seed" from a test.
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 5744643d9ec3..0118fd2ba56b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2310,6 +2310,7 @@ void __attribute((constructor)) kvm_selftest_init(v=
oid)
>         struct sigaction sig_sa =3D {
>                 .sa_handler =3D report_unexpected_signal,
>         };
> +       int random_seed;
>
>         /* Tell stdout not to buffer its content. */
>         setbuf(stdout, NULL);
> @@ -2319,8 +2320,13 @@ void __attribute((constructor)) kvm_selftest_init(=
void)
>         sigaction(SIGILL, &sig_sa, NULL);
>         sigaction(SIGFPE, &sig_sa, NULL);
>
> +       random_seed =3D time(NULL);
> +       srand(random_seed);
> +
>         guest_random_seed =3D last_guest_seed =3D random();
> -       pr_info("Random seed: 0x%x\n", guest_random_seed);
> +
> +       pr_info("Guest random seed: 0x%x (srand: 0x%x)\n",
> +               guest_random_seed, random_seed);
>
>         kvm_selftest_arch_init();
>  }

Just to make sure I understand: You are proposing using the current
time as the seed and printing it to the console. That way each run
uses a different random seed and we get broader test coverage. Then if
someone wants to reproduce a test result, there would be some way for
them to override the seed via cmdline? That sounds reasonable to me, I
can take a look at adding that in the next version.

> > +             if (irq_affinity && vcpu->id =3D=3D 0) {
>
> Please add comments explaining why affinity related stuff is only applied=
 to
> vCPU0.  I could probably figure it out, but I really shouldn't have to.

Will do.

> > +             for (j =3D 0; j < nr_vcpus; j++) {
> > +                     TEST_ASSERT_EQ(READ_FROM_GUEST(vm, guest_received=
_irq[vcpu->id]), false);
> > +                     TEST_ASSERT_EQ(READ_FROM_GUEST(vm, guest_received=
_nmi[vcpu->id]), false);
>
> These won't generate helpful assert messages.

Good point. I'll improve these in the next version.

> > +             for (;;) {
> > +                     if (do_nmi && READ_FROM_GUEST(vm, guest_received_=
nmi[vcpu->id]))
> > +                             break;
> > +
> > +                     if (!do_nmi && READ_FROM_GUEST(vm, guest_received=
_irq[vcpu->id]))
> > +                             break;
>
>                 received_irq =3D do_nmi ? &guest_received_nmi[vcpu->id] :
>                                         &guest_received_irq[vcpu->id];
>                 while (!READ_FROM_GUEST(vm, *received_irq))
>                         if (timespec_to_ns(timespec_elapsed(start)) > TIM=
EOUT_NS) {
>                                 ...
>                         }
>
>                         cpu_relax();
>                 }

LGTM

> > +
> > +                     if (timespec_to_ns(timespec_elapsed(start)) > TIM=
EOUT_NS) {
> > +                             printf("Timeout waiting for interrupt!\n"=
);
> > +                             printf("  vCPU: %d\n", vcpu->id);
> > +                             printf("  do_nmi: %d\n", do_nmi);
> > +                             printf("  do_empty: %d\n", do_empty);
> > +                             if (irq_affinity)
> > +                                     printf("  irq_cpu: %d\n", irq_cpu=
>
> > +             if (do_nmi)
> > +                     WRITE_TO_GUEST(vm, guest_received_nmi[vcpu->id], =
false);
> > +             else
> > +                     WRITE_TO_GUEST(vm, guest_received_irq[vcpu->id], =
false);
> > +     }
> > +
> > +     WRITE_TO_GUEST(vm, done, true);
> > +
> > +     for (i =3D 0; i < nr_vcpus; i++) {
> > +             if (block) {
> > +                     kvm_route_msi(vm, gsi, vcpus[i], vector, false);
> > +                     send_msi(device, false, msi);
> > +             }
> > +
> > +             pthread_join(vcpu_threads[i], NULL);
> > +     }
> > +
> > +     if (irq_affinity)
> > +             fclose(irq_affinity_fp);
> > +
> > +     printf("Host interrupts handled:\n");
> > +     printf("  IRQ-%d: %lu\n", irq, get_irq_count(irq) - irq_count);
> > +     printf("  Posted-interrupt notification events: %lu\n",
> > +            __get_irq_count("PIN:") - pin_count);
> > +     printf("  Posted-interrupt wakeup events: %lu\n",
> > +            __get_irq_count("PIW:") - piw_count);
> > +
> > +     vfio_pci_device_cleanup(device);
> > +
> > +     return 0;
> > +}
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >);
>
> vfio_pci_irq_test.c: In function =E2=80=98main=E2=80=99:
> vfio_pci_irq_test.c:469:41: error: =E2=80=98irq_cpu=E2=80=99 may be used =
uninitialized [-Werror=3Dmaybe-uninitialized]
>   469 |                                         printf("  irq_cpu: %d\n",=
 irq_cpu);
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> vfio_pci_irq_test.c:332:13: note: =E2=80=98irq_cpu=E2=80=99 was declared =
here
>   332 |         int irq_cpu;
>       |             ^~~~~~~

Ack, will fix.

> > +                             if (pin_vcpus)
> > +                                     printf("  vcpu_cpu: %d\n", get_cp=
u(vcpu));
> > +
> > +                             TEST_FAIL("vCPU never received IRQ!\n");
> > +                     }
> > +             }
>
>                 TEST_ASSERT(guest_received_irq[vcpu->id] !=3D
>                             guest_received_nmi[vcpu->id],
>                             "blah blah blah");
>
>                 WRITE_TO_GUEST(vm, *received_irq, false);

LGTM

