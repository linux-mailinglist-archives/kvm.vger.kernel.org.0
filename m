Return-Path: <kvm+bounces-26061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC9E96FF40
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 786E2286442
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C09A17C8D;
	Sat,  7 Sep 2024 02:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKxK/tmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7CE56A
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725676020; cv=none; b=NRwkvd6dq4iMAZ53f3j11fePsd6wMR/VHJlFgbFuNwx8wQ/h7ZBHUikBQC7qy3A7xIOhGl9NQp9Gr0X7YIIEscxaze30pkGVOrcm+cl3nUorhBEhQB0pReOpWQcOrWNyFmqrPSrfy88vRP4p+Z+G84NUBOuYf/sRR9T+7AlkkTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725676020; c=relaxed/simple;
	bh=Zu57J3ORUFFDl6UImfWt90pCcKI9cEed9srV8fr4rZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXqvBxoT8FzjnxprOSsnCcFOXqTSPrNf+RybOvU7ygnIXXzmhMqagCZQ69Dn0+fXUQn0vdzW8YfbQlGdgecmesYhp+nB7L59mw3fRAKSe3xATVZbg+YqylD6xREe55xBN0i3RBKDZXCS9ACnOxIB+ASceqpTP3YMTpzNW4P40Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKxK/tmO; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6d6891012d5so23816117b3.2
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725676018; x=1726280818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBeddYgbDmYn5319rd5Q0c4oe13WBhLqIiKeKnDAi7E=;
        b=NKxK/tmO36jvkjGeAV4SCSwiWUZgJkkU+Fb6qibIXcGjkSsOElLmAOpXPM9GZL2RGD
         juX1ewBUvU3QMR8S0Dt6OnXAiTZI70Chnw1U5Q9McjDRlr1nZE9d8XdLRIdlrzLCjR2l
         Giezdmo6gzvLL+vka+A/QV8Vc1Q2qgafPFznE4hzj6OCm18StqbnAdZc6Cm7Coxeho1o
         lacJs2axXi+E9C9S1ZNCZOLX93T+ObPkHjMC326x4K2kGaiewIIVPbivBkFGV0r4levm
         MRtzYcthik4iUT4jvza+xv8fBByvFdkodhALQNJEY1lVU2Luz6AL6OartSU9x3IkTKz0
         We1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725676018; x=1726280818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kBeddYgbDmYn5319rd5Q0c4oe13WBhLqIiKeKnDAi7E=;
        b=KY/KgvVWwhsNfVY1wd9ABOaqe7D029+oZyOKDcM2qSHp/k7dSNxoRfNIhPpv/tRGQM
         TleBJpuuD0bBw6DcMls6JX2sS4TQZYgVdcvLsRun39/q8SSFYMPWu0i0sSVpIc3DTkO8
         Z+a0a4RnJs01jSdjkzl9uK6hZCtHLzr0bTIWY+/PbaRussXHjDwXi/xrAWU4q5tBOqZr
         B2ZtKgghSi+tdhBsLu+dfEMTrNMgEsiJ33LT3lTGneU0Q8Qb5wgo1IUis8R3f5cN50Zk
         e7jYtZAE1LzmaPl3nGERf6MNfkuD5nzyYZDkMCk1iN3wHqCCbs1M4d6jYldGlQCFoiOZ
         nijA==
X-Forwarded-Encrypted: i=1; AJvYcCX5EF0XnR5dROLXIrT4Q4vIFPKR1jYZbH+dTT5GTjw64aIwZ6H8MjvlWowkJ02kAYL5fWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjzGyOY17F4LPRPTN3CWqmQOgxGWGpwOVULd4FnXu1hqCIbCOM
	7w9VPD4kK8hgu1Hne24Zj53CSuMuAWT4wmaU7kU/W3bhUAkEaFoHUJjHzJ3uVuEWxLVBFYbr4FX
	A/BZx11mA8GFxfP2zVE21GjMsu+1pNy6tBJPF
X-Google-Smtp-Source: AGHT+IFr6erGGzLIowBv1MIlp4/drXvGHXusR5ak9HTYQTi51u3FknzGWur7d0TtuxQodMi0p2Ht/zIFPRbvZsf2ghA=
X-Received: by 2002:a05:690c:2e06:b0:65f:cd49:48e0 with SMTP id
 00721157ae682-6db452c39admr40487597b3.31.1725676017481; Fri, 06 Sep 2024
 19:26:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-10-seanjc@google.com>
 <CADrL8HXcD--jn1iLeCJycCd3Btv4_rBPxz6NMnTREXfeh0vRZA@mail.gmail.com> <Ztuj7KapTJyBVCVR@google.com>
In-Reply-To: <Ztuj7KapTJyBVCVR@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 6 Sep 2024 19:26:20 -0700
Message-ID: <CADrL8HVaZk7m73FftxXYEXvAqjKa8vc4QG_1FAMXTYSfOE7jhQ@mail.gmail.com>
Subject: Re: [PATCH 09/22] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 6, 2024 at 5:53=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Sep 06, 2024, James Houghton wrote:
> > On Fri, Aug 9, 2024 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Add two phases to mmu_stress_test to verify that KVM correctly handle=
s
> > > guest memory that was writable, and then made read-only in the primar=
y MMU,
> > > and then made writable again.
> > >
> > > Add bonus coverage for x86 to verify that all of guest memory was mar=
ked
> > > read-only.  Making forward progress (without making memory writable)
> > > requires arch specific code to skip over the faulting instruction, bu=
t the
> > > test can at least verify each vCPU's starting page was made read-only=
.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> >
> > Writing off-list because I just have some smaller questions that I
> > don't want to bother the list with.
>
> Pulling everyone and the lists back in :-)
>
> IMO, no question is too small for kvm@, and lkml@ is gigantic firehose th=
at's 99%
> archival and 1% list, at best.  Odds are very, very good that if you have=
 a
> question, however trivial or small, then someone else has the exact same =
question,
> or _will_ have the question in the future.
>
> I strongly prefer that all questions, review, feedback, etc. happen on li=
st, even
> if the questions/feedback may seem trivial or noisy.  The only exception =
is if
> information can't/shouldn't be made public, e.g. because of an embargo, N=
DA,
> security implications, etc.

I'll keep this in mind, thanks!

> > For the next version, feel free to add:
> >
> > Reviewed-by: James Houghton <jthoughton@google.com>
> >
> > All of the selftest patches look fine to me.
> >
> > > ---
> > >  tools/testing/selftests/kvm/mmu_stress_test.c | 87 +++++++++++++++++=
+-
> > >  1 file changed, 84 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/te=
sting/selftests/kvm/mmu_stress_test.c
> > > index 50c3a17418c4..98f9a4660269 100644
> > > --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> > > +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> > > @@ -16,6 +16,8 @@
> > >  #include "guest_modes.h"
> > >  #include "processor.h"
> > >
> > > +static bool mprotect_ro_done;
> > > +
> > >  static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_=
t stride)
> > >  {
> > >         uint64_t gpa;
> > > @@ -31,6 +33,33 @@ static void guest_code(uint64_t start_gpa, uint64_=
t end_gpa, uint64_t stride)
> > >                 *((volatile uint64_t *)gpa);
> > >         GUEST_SYNC(2);
> > >
> > > +       /*
> > > +        * Write to the region while mprotect(PROT_READ) is underway.=
  Keep
> > > +        * looping until the memory is guaranteed to be read-only, ot=
herwise
> > > +        * vCPUs may complete their writes and advance to the next st=
age
> > > +        * prematurely.
> > > +        */
> > > +       do {
> > > +               for (gpa =3D start_gpa; gpa < end_gpa; gpa +=3D strid=
e)
> > > +#ifdef __x86_64__
> > > +                       asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a"=
 (gpa) : "memory");
> >
> > Ok so this appears to be a `mov BYTE PTR [rax + 0x0], 0x0`, where %rax =
=3D gpa. :)
> >
> > Does '0xc6,0x0,0x0' also work? It seems like that translates to `mov
> > BYTE PTR [rax], 0x0`. (just curious, no need to change it)
>
> LOL, yes, but as evidenced by the trailing comment, my intent was to gene=
rate
> "mov rax, [rax]", not "movb $0, [rax]".  I suspect I was too lazy to cons=
ult the
> SDM to recall the correct opcode and simply copied an instruction from so=
me random
> disassembly output without looking too closely at the output.
>
>         asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a" (gpa) : "memory"); =
/* MOV RAX, [RAX] */
>
> > And I take it you wrote it out like this (instead of using mnemonics)
> > so that you could guarantee that IP + 4 would be the right way to skip
> > forwards. Does it make sense to leave a comment about that?
>
> Yes and yes.
>
> > The translation from mnemonic --> bytes won't change...
>
> Heh, this is x86, by no means is that guaranteed.  E.g. see the above, wh=
ere the
> same mnemonic can be represented multiple ways.
>
> > so could you just write the proper assembly? (not a request,  just curi=
ous)
>
> In practice, probably.  But the rules for inline assembly are, at best, f=
uzzy.
> So long as the correct instruction is generated, the assembler has quite =
a bit
> of freedom.
>
> E.g. similar to above, "mov %rax,(%rax)" can (should) be encoded as:
>
>   48 89 00
>
> but can also be encoded as
>
>   48 89 40 00
>
> Now, it's _extremely_ unlikely a compiler will actually generate the latt=
er, but
> it's perfectly legal to do so.  E.g. with gcc-13, this
>
>   mov %rax, 0x0(%rax)
>
> generates
>
>   48 89 00
>
> even though a more literal interpretation would be
>
>   48 89 40 00

Oh... neat! I'm glad I asked about this.

>
> So yeah, while the hand-coded opcode is gross and annoying, given that a =
failure
> due to the "wrong" instruction being generated would be painful and time =
consuming
> to debug, hand-coding is worth avoiding the risk and potential pain if th=
e compiler
> decides to be mean :-)

I 100% agree with hand-writing the opcode given what you've said. :)

> > A comment that 0x40 corresponds to %rax and that "a" also corresponds
> > to %rax would have been helpful for me. :)
>
> Eh, I get what you're saying, but giving a play-by-play of the encoding i=
sn't
> really all that reasonable because _so_ much information needs to be conv=
eyed to
> capture the entire picture, and some things are essentially table stakes =
when it
> comes to x86 kernel programming.
>
>
> E.g. 0x40 doesn't simply mean "(%rax)", it's a full ModR/M that defines t=
he
> addressing mode, which in turn depends on the operating mode (64-bit).
>
> And "a" isn't just %rax; it's specifically an input register constraint, =
e.g. is
> distinctly different than:
>
>   asm volatile(".byte 0x48,0x89,0x0" : "+a"(gpa) :: "memory"); /* mov %ra=
x, (%rax) */
>
> even though in this specific scenario they generate the same code.
>
> And with the correct "48 89 00", understanding the full encoding requires=
 describing
> REX prefixes, which are a mess unto themselves.
>
> So, a trailing comment (with the correct mnemonic) is all I'm willing to =
do, even
> though I 100% agree that it puts a decent sized load on the reader.  Ther=
e's just
> _too_ much information to communicate to the reader, at least for x86.

The trailing comment works for me! Thanks for all the detail -- I am
learning so much.

>
> > > +#else
> > > +                       vcpu_arch_put_guest(*((volatile uint64_t *)gp=
a), gpa);
> > > +#endif
> > > +       } while (!READ_ONCE(mprotect_ro_done));
> > > +
> > > +       /*
> > > +        * Only x86 can explicitly sync, as other architectures will =
be stuck
> > > +        * on the write fault.
> >
> > It would also have been a little clearer if the comment also said how
> > this is just because the test has been written to increment for the PC
> > upon getting these write faults *for x86 only*. IDK something like
> > "For x86, the test will adjust the PC for each write fault, allowing
> > the above loop to complete. Other architectures will get stuck, so the
> > #3 sync step is skipped."
>
> Ya.  Untested, but how about this?

LGTM! (I haven't tested it either.)

>
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testin=
g/selftests/kvm/mmu_stress_test.c
> index 2d66c2724336..29acb22ea387 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -38,11 +38,18 @@ static void guest_code(uint64_t start_gpa, uint64_t e=
nd_gpa, uint64_t stride)
>          * looping until the memory is guaranteed to be read-only, otherw=
ise
>          * vCPUs may complete their writes and advance to the next stage
>          * prematurely.
> +        *
> +        * For architectures that support skipping the faulting instructi=
on,
> +        * generate the store via inline assembly to ensure the exact len=
gth
> +        * of the instruction is known and stable (vcpu_arch_put_guest() =
on
> +        * fixed-length architectures should work, but the cost of parano=
ia
> +        * is low in this case).  For x86, hand-code the exact opcode so =
that
> +        * there is no room for variability in the generated instruction.
>          */
>         do {
>                 for (gpa =3D start_gpa; gpa < end_gpa; gpa +=3D stride)
>  #ifdef __x86_64__
> -                       asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a" (gp=
a) : "memory"); /* MOV RAX, [RAX] */
> +                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) :=
 "memory"); /* mov %rax, (%rax) */

FWIW I much prefer the trailing comment you have ended up with vs. the
one you had before. (To me, the older one _seems_ like it's Intel
syntax, in which case the comment says it's a load..? The comment you
have now is, to me, obviously indicating a store. Though... perhaps
"movq"?)


>  #elif defined(__aarch64__)
>                         asm volatile("str %0, [%0]" :: "r" (gpa) : "memor=
y");
>  #else
> @@ -163,7 +170,7 @@ static void *vcpu_worker(void *data)
>                 TEST_ASSERT_EQ(errno, EFAULT);
>  #ifdef __x86_64__
>                 WRITE_ONCE(vcpu->run->kvm_dirty_regs, KVM_SYNC_X86_REGS);
> -               vcpu->run->s.regs.regs.rip +=3D 4;
> +               vcpu->run->s.regs.regs.rip +=3D 3;
>  #endif
>  #ifdef __aarch64__
>                 vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc),
>

