Return-Path: <kvm+bounces-26049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1C696FEBE
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D9AD1F23C76
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77273A927;
	Sat,  7 Sep 2024 00:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OTmt21ci"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B55256D
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670385; cv=none; b=Mui0f+1jzrmz5OEyZVbnOtL3jCWj3J/Mo92E0kLYbpzHqPKkULLPmrSlTDBROB6e5XKtqT7wPVASnEUfGNHXi+QMNo1nrI70RfHFMkAlmBkCzTx03j0+c7nohm6ToJCkLYB0SpPSRI14eC4ptYAAKypFihJVm01xj+KtZIhQtFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670385; c=relaxed/simple;
	bh=TFKe5FEoxPpWJXUbnXP7EQsXSllTlOcF0yXGY+oNEu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J+X9ZtKtMFHB3CpOz2dD0pXYnYUw53cbGLUrCMGjhb0s/ANf5WrZ/vnDBzs0KREe6pLrGSxwJoK8OmOcTxnV/NS+7YcNMNNaZ60zDFeCdd4DfTH0yAE3Aee9XY9CkSTPR+vNsl+cm+OvyYPQCBUFE+RcIx1VJdj49z/Jyu4ttGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OTmt21ci; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e11368fa2e3so5812253276.3
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 17:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725670383; x=1726275183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cvDg3DfHKLXZUdcNlHwYYdDUD8sFXAigpGLjYaFm+7Q=;
        b=OTmt21ci8IrhHrvadVdxfDTJ+QaiUhIsZaADOF1J8qQ+MPbDJEbwplvLzrpdsRvjyu
         kPM5dTigLPLOFysnrmqjaPx+VPNAFRBTjxJ6MYRR7bYrcrJeymDOSV+qWvAJVpuRSRFn
         1iUwIGbisMwE9iDvLwNM+EEjvI3sFrodI+r+eXgAugfyjyXX6/rkwei94ZJiPz45sfmS
         fe20k0BBZDxRTChqwY69AQ6gjf2mLwP+MheU9OqYt10/wrKmElhIlT9Zs8DPNurISIxV
         PcGA4EH2CUjV/s38EDlPJT5b3nPDmlV+u/9SKyCqyWm7Isqm0Fadl2op+3D865uPONp3
         j68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725670383; x=1726275183;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cvDg3DfHKLXZUdcNlHwYYdDUD8sFXAigpGLjYaFm+7Q=;
        b=JJaIkmGDJWapX8xFc6eNJ4wVh3k32h7ZfrqjaJqtI7ExGzByzPWbkw5HuGT4GyOH+N
         KtFH6qT0z1CtSe8b79W5Wmm1i/g924pINFruxVzUgM39odu+3ClJ34CCwAu31quc4hSL
         EGrw51E5RFWCpEbkrQBYWVttv37Gq+HmV0Z6uwVfCSrWKr0y1GgChR6kujbQpgNUeIJ2
         HuEvyIyRZ73v52veKpKcQc9i7uOxdt0qHhevV+vNYqlqVYcpFnOnUzowJ9TAdK7wo/kk
         59gyzsWrTj2RaiNVtX7/1XqJfn1YurCJg1Ha01qBpAmXD9Ra6qKbE5dqAFIabr5iEaOp
         F8hw==
X-Forwarded-Encrypted: i=1; AJvYcCXALdr19JnvaMuka9Wqz1rbwLcvXBg3qe0y6/EZaPgn7X3uJfHjPp2Kq9JAx8x+NdnWSks=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXgMLj3yCz2/Bzz43fFmdrUrPybfGCdNOjytBgEAS6hPiQkDNz
	dyQlFXQ/ivktK5u0WfOooHLnKdXEtm6L9bEW0cbPWC38ZY3OkjW/GviM+Hkem1BBoJgMxoG0f6j
	gIA==
X-Google-Smtp-Source: AGHT+IGsrtQk6Vz/G0pLur+KioHIKoI49GqvwNCfvT5Rl6lo6ANEQKKE3nF1KjMCp7XQuepxjDSam58ag94=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6845:0:b0:e1c:ea19:98f with SMTP id
 3f1490d57ef6-e1d34a4dc8dmr62489276.8.1725670382387; Fri, 06 Sep 2024 17:53:02
 -0700 (PDT)
Date: Sat, 7 Sep 2024 00:53:00 +0000
In-Reply-To: <CADrL8HXcD--jn1iLeCJycCd3Btv4_rBPxz6NMnTREXfeh0vRZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-10-seanjc@google.com>
 <CADrL8HXcD--jn1iLeCJycCd3Btv4_rBPxz6NMnTREXfeh0vRZA@mail.gmail.com>
Message-ID: <Ztuj7KapTJyBVCVR@google.com>
Subject: Re: [PATCH 09/22] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2024, James Houghton wrote:
> On Fri, Aug 9, 2024 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Add two phases to mmu_stress_test to verify that KVM correctly handles
> > guest memory that was writable, and then made read-only in the primary =
MMU,
> > and then made writable again.
> >
> > Add bonus coverage for x86 to verify that all of guest memory was marke=
d
> > read-only.  Making forward progress (without making memory writable)
> > requires arch specific code to skip over the faulting instruction, but =
the
> > test can at least verify each vCPU's starting page was made read-only.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Writing off-list because I just have some smaller questions that I
> don't want to bother the list with.

Pulling everyone and the lists back in :-)

IMO, no question is too small for kvm@, and lkml@ is gigantic firehose that=
's 99%
archival and 1% list, at best.  Odds are very, very good that if you have a
question, however trivial or small, then someone else has the exact same qu=
estion,
or _will_ have the question in the future.

I strongly prefer that all questions, review, feedback, etc. happen on list=
, even
if the questions/feedback may seem trivial or noisy.  The only exception is=
 if
information can't/shouldn't be made public, e.g. because of an embargo, NDA=
,
security implications, etc.

> For the next version, feel free to add:
>=20
> Reviewed-by: James Houghton <jthoughton@google.com>
>=20
> All of the selftest patches look fine to me.
>=20
> > ---
> >  tools/testing/selftests/kvm/mmu_stress_test.c | 87 ++++++++++++++++++-
> >  1 file changed, 84 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/test=
ing/selftests/kvm/mmu_stress_test.c
> > index 50c3a17418c4..98f9a4660269 100644
> > --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> > +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> > @@ -16,6 +16,8 @@
> >  #include "guest_modes.h"
> >  #include "processor.h"
> >
> > +static bool mprotect_ro_done;
> > +
> >  static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t =
stride)
> >  {
> >         uint64_t gpa;
> > @@ -31,6 +33,33 @@ static void guest_code(uint64_t start_gpa, uint64_t =
end_gpa, uint64_t stride)
> >                 *((volatile uint64_t *)gpa);
> >         GUEST_SYNC(2);
> >
> > +       /*
> > +        * Write to the region while mprotect(PROT_READ) is underway.  =
Keep
> > +        * looping until the memory is guaranteed to be read-only, othe=
rwise
> > +        * vCPUs may complete their writes and advance to the next stag=
e
> > +        * prematurely.
> > +        */
> > +       do {
> > +               for (gpa =3D start_gpa; gpa < end_gpa; gpa +=3D stride)
> > +#ifdef __x86_64__
> > +                       asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a" (=
gpa) : "memory");
>=20
> Ok so this appears to be a `mov BYTE PTR [rax + 0x0], 0x0`, where %rax =
=3D gpa. :)
>=20
> Does '0xc6,0x0,0x0' also work? It seems like that translates to `mov
> BYTE PTR [rax], 0x0`. (just curious, no need to change it)

LOL, yes, but as evidenced by the trailing comment, my intent was to genera=
te
"mov rax, [rax]", not "movb $0, [rax]".  I suspect I was too lazy to consul=
t the
SDM to recall the correct opcode and simply copied an instruction from some=
 random
disassembly output without looking too closely at the output.

	asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a" (gpa) : "memory"); /* MOV RA=
X, [RAX] */

> And I take it you wrote it out like this (instead of using mnemonics)
> so that you could guarantee that IP + 4 would be the right way to skip
> forwards. Does it make sense to leave a comment about that?=20

Yes and yes.

> The translation from mnemonic --> bytes won't change...

Heh, this is x86, by no means is that guaranteed.  E.g. see the above, wher=
e the
same mnemonic can be represented multiple ways.

> so could you just write the proper assembly? (not a request,  just curiou=
s)

In practice, probably.  But the rules for inline assembly are, at best, fuz=
zy.
So long as the correct instruction is generated, the assembler has quite a =
bit
of freedom.

E.g. similar to above, "mov %rax,(%rax)" can (should) be encoded as:

  48 89 00

but can also be encoded as

  48 89 40 00

Now, it's _extremely_ unlikely a compiler will actually generate the latter=
, but
it's perfectly legal to do so.  E.g. with gcc-13, this

  mov %rax, 0x0(%rax)

generates

  48 89 00

even though a more literal interpretation would be

  48 89 40 00

So yeah, while the hand-coded opcode is gross and annoying, given that a fa=
ilure
due to the "wrong" instruction being generated would be painful and time co=
nsuming
to debug, hand-coding is worth avoiding the risk and potential pain if the =
compiler
decides to be mean :-)

> A comment that 0x40 corresponds to %rax and that "a" also corresponds
> to %rax would have been helpful for me. :)

Eh, I get what you're saying, but giving a play-by-play of the encoding isn=
't
really all that reasonable because _so_ much information needs to be convey=
ed to
capture the entire picture, and some things are essentially table stakes wh=
en it
comes to x86 kernel programming.

E.g. 0x40 doesn't simply mean "(%rax)", it's a full ModR/M that defines the
addressing mode, which in turn depends on the operating mode (64-bit).

And "a" isn't just %rax; it's specifically an input register constraint, e.=
g. is
distinctly different than:

  asm volatile(".byte 0x48,0x89,0x0" : "+a"(gpa) :: "memory"); /* mov %rax,=
 (%rax) */

even though in this specific scenario they generate the same code.

And with the correct "48 89 00", understanding the full encoding requires d=
escribing
REX prefixes, which are a mess unto themselves.

So, a trailing comment (with the correct mnemonic) is all I'm willing to do=
, even
though I 100% agree that it puts a decent sized load on the reader.  There'=
s just
_too_ much information to communicate to the reader, at least for x86.

> > +#else
> > +                       vcpu_arch_put_guest(*((volatile uint64_t *)gpa)=
, gpa);
> > +#endif
> > +       } while (!READ_ONCE(mprotect_ro_done));
> > +
> > +       /*
> > +        * Only x86 can explicitly sync, as other architectures will be=
 stuck
> > +        * on the write fault.
>=20
> It would also have been a little clearer if the comment also said how
> this is just because the test has been written to increment for the PC
> upon getting these write faults *for x86 only*. IDK something like
> "For x86, the test will adjust the PC for each write fault, allowing
> the above loop to complete. Other architectures will get stuck, so the
> #3 sync step is skipped."

Ya.  Untested, but how about this?

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/=
selftests/kvm/mmu_stress_test.c
index 2d66c2724336..29acb22ea387 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -38,11 +38,18 @@ static void guest_code(uint64_t start_gpa, uint64_t end=
_gpa, uint64_t stride)
         * looping until the memory is guaranteed to be read-only, otherwis=
e
         * vCPUs may complete their writes and advance to the next stage
         * prematurely.
+        *
+        * For architectures that support skipping the faulting instruction=
,
+        * generate the store via inline assembly to ensure the exact lengt=
h
+        * of the instruction is known and stable (vcpu_arch_put_guest() on
+        * fixed-length architectures should work, but the cost of paranoia
+        * is low in this case).  For x86, hand-code the exact opcode so th=
at
+        * there is no room for variability in the generated instruction.
         */
        do {
                for (gpa =3D start_gpa; gpa < end_gpa; gpa +=3D stride)
 #ifdef __x86_64__
-                       asm volatile(".byte 0xc6,0x40,0x0,0x0" :: "a" (gpa)=
 : "memory"); /* MOV RAX, [RAX] */
+                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "=
memory"); /* mov %rax, (%rax) */
 #elif defined(__aarch64__)
                        asm volatile("str %0, [%0]" :: "r" (gpa) : "memory"=
);
 #else
@@ -163,7 +170,7 @@ static void *vcpu_worker(void *data)
                TEST_ASSERT_EQ(errno, EFAULT);
 #ifdef __x86_64__
                WRITE_ONCE(vcpu->run->kvm_dirty_regs, KVM_SYNC_X86_REGS);
-               vcpu->run->s.regs.regs.rip +=3D 4;
+               vcpu->run->s.regs.regs.rip +=3D 3;
 #endif
 #ifdef __aarch64__
                vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc),


