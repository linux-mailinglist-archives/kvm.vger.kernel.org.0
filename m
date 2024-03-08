Return-Path: <kvm+bounces-11370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB7E87677B
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDDE81F24613
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 15:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C938A1F93E;
	Fri,  8 Mar 2024 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A1hzkDDo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB5E1F932
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709912446; cv=none; b=MUuEoe5S2GjTLC6D9U5LiEimFAofrlCNnG/oD+vTmrTXL/5ZyRdmHj/hOTk9QU7DnqCYZQ73ArxJUfG7k7zrjKET3oyI3wnHaB/Z5PAgd52kjjJGWcy7GoyFztwJ3Szu44wQ55afLOzwYfMDiWfbjl79d7ZcZglAAS2EKinrtaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709912446; c=relaxed/simple;
	bh=DcGK2/3fl/rA0ThXMceF6UGOxdgz7YeQ6d40VzoEefU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRzrzElLSnCYxack8lMWnho/WxMZqyUtacHrkWB94BC35Hsh50iab7T5aI8OoI5clVYazWXUldQIO6n5R9HMshMHP2Eavyc2rq7ghm0jam8iR1e1eIxnp2hBmizNlAbWX67AqkJ3cDPw1+FobpccKaPOMUbcThwF79SR90jr5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A1hzkDDo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d1bffa322eso2293577a12.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 07:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709912443; x=1710517243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGXij0pXxbNnFrojQkAhwWd7kWJ6lHgt5Xgw5lH9rKY=;
        b=A1hzkDDokp6aEDVDoaxwHBqjsNur/n/QG19gyuKKsjlwX9KxpKkPCDJtofIXTDUq0y
         XCjBq3mLoufqZoJFSEwQ7IdRmqgOaV4NSIS3lJg0Nb/001FVYLnR2mcLwvBMcfvgDxqu
         sj58Z+xYeayCEpG2GW7jZ7/lZDEafyDq+gWvswM8djCcG4OAB7T/BoP1YSd0s8IEudJG
         etD1Mf7cd9dIXhwwcC77pqTg4mGIrd7iU4EPM5quq0xUZBPdp14ebvd5CHi8CJK+vFcP
         Girq8XaIufo5TwSKqyWkN89V9dqB6PizZKWCVXCXQ7oTm1TqQ6eJ1sIJCW9pm5nU/FqJ
         IAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709912443; x=1710517243;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yGXij0pXxbNnFrojQkAhwWd7kWJ6lHgt5Xgw5lH9rKY=;
        b=UFL01wou8e/QtEHyqP4xhe34ujWwj8B8cWdzAie2aTj2C/Uoi9FU04MPfPi/7vHoh3
         yJXoXPKOs8y3iafFyPZEPtxwblmKubVGOVFoyxfDc1ija2C20hxmzh87PVrPhogem3uU
         gxOriENvKSTF0bki+SRyVZkYglVvCdeZv6S1jv0gB/KbnkYTLA0sE1YzcJxiAsMQ111Q
         jyQmeilt0P5M7G4CyOnurIwkq1AlC1zpVQeQaTIrh8G973+FsxoqayyxrfjqCliEoZpO
         PBWg13nGRHoDr4/gNX8zbh4xXuS9Au9aL6OOgV7TV00z14zh5hlLrAmBxIkghCqX9Kvg
         8b1g==
X-Forwarded-Encrypted: i=1; AJvYcCU26UTyUwrDWjfOQUG/T8u32V+x5eE1bLfWYXozlJAWv/ziR7hNkgFYnbQzEWe87qlVhPU9CoZEEUknuTuGxnaHGSKV
X-Gm-Message-State: AOJu0YyM0eFmjt73NVYsLa5riharRowYTNPTJnNBDvwWrxLoshHpsG2S
	5ALuN+J+WbHRYIJzejAuu0lhywC5o/vcAFT21RkBltU39lJObZQvKGSAGuvuyJ/pCJNeQuK5n1/
	3LQ==
X-Google-Smtp-Source: AGHT+IFjEBX6C+7q1SBXQ+tSA4pdjdQXgmJ9UBKLZS/xnmX8tOHGVqK01y9ERowX6ifH4R9/jDDhuoSeDmU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1f64:0:b0:5dc:1c7d:2c75 with SMTP id
 q36-20020a631f64000000b005dc1c7d2c75mr56894pgm.1.1709912443614; Fri, 08 Mar
 2024 07:40:43 -0800 (PST)
Date: Fri, 8 Mar 2024 07:40:42 -0800
In-Reply-To: <CAAhSdy2Mu08RsBM+7FMjkcV49p9gOj3UKEoZnPAVk92e_3q=sw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com> <CAAhSdy2Mu08RsBM+7FMjkcV49p9gOj3UKEoZnPAVk92e_3q=sw@mail.gmail.com>
Message-ID: <ZesxeoyFZUeo-Z9F@google.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Anup Patel <anup@brainfault.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2024, Anup Patel wrote:
> On Thu, Mar 7, 2024 at 11:13=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Mar 07, 2024, Anup Patel wrote:
> > > ----------------------------------------------------------------
> > > KVM/riscv changes for 6.9
> > Uh, what's going on with this series?  Many of these were committed *ye=
sterday*,
> > but you sent a mail on February 12th[1] saying these were queued.  That=
's quite
> > the lag.
> >
> > I don't intend to police the RISC-V tree, but this commit caused a conf=
lict with
> > kvm-x86/selftests[2].  It's a non-issue in this case because it's such =
a trivial
> > conflict, and we're all quite lax with selftests, but sending a pull re=
quest ~12
> > hours after pushing commits that clearly aren't fixes is a bit ridiciul=
ous.  E.g.
> > if this were to happen with a less trivial conflict, the other sub-main=
tainer would
> > be left doing a late scramble to figure things out just before sending =
their own
> > pull requests.
> >
> >   tag kvm-riscv-6.9-1
> >   Tagger:     Anup Patel <anup@brainfault.org>
> >   TaggerDate: Thu Mar 7 11:54:34 2024 +0530
> >
> > ...
> >
> >   commit d8c0831348e78fdaf67aa95070bae2ef8e819b05
> >   Author:     Anup Patel <apatel@ventanamicro.com>
> >   AuthorDate: Tue Feb 13 13:39:17 2024 +0530
> >   Commit:     Anup Patel <anup@brainfault.org>
> >   CommitDate: Wed Mar 6 20:53:44 2024 +0530
> >
> > The other reason this caught my eye is that the conflict happened in co=
mmon code,
> > but the added helper is RISC-V specific and used only from RISC-V code.=
  ARM does
> > have an identical helper, but AFAICT ARM's helper is only used from ARM=
 code.
> >
> > But the prototype of guest_get_vcpuid() is in common code.  Which isn't=
 a huge
> > deal, but it's rather undesirable because there's no indication that it=
s
> > implementation is arch-specific, and trying to use it in code built for=
 s390 or
> > x86 (or MIPS or PPC, which are on the horizon), would fail.  I'm all fo=
r making
> > code common where possible, but going halfway and leaving a trap for ot=
her
> > architectures makes for a poor experience for developers.
> >
> > And again, this showing up _so_ late means it's unnecessarily difficult=
 to clean
> > things up.  Which is kinda the whole point of getting thing into linux-=
next, so
> > that folks that weren't involved in the original patch/series can react=
 if there
> > is a hiccup/problem/oddity.
>=20
> Sorry for the last minute conflict.
>=20
> In all release cycles, the riscv_kvm_queue freezes by rc6 and riscv_kvm_n=
ext
> is updated at least a week before sending PR.
>=20
> In this case there was a crucial last minute bug found in RISC-V arch_tim=
er
> selftest patches due to which the get-reg-list selftest was broken so I
> updated the offending commits in the queue itself before sending out PR.
>=20
> I will definitely try my best to avoid such last minute conflict.

You're missing the point.  I don't care when patches land in the RISC-V tre=
e, nor
do I care that you made a last minute tweak to fix a bug.  I care when comm=
its
show up in linux-next, and *none* of these commits were in linux-next until
yesterday.

  $ git tag -l --contains 2c5af1c8460376751d57c50af88a053a3b869926
  next-20240307
  next-20240308

The *entire* purpose of linux-next is to integrate *all* work destined for =
the
next kernel into a single tree, so that conflicts, bugs, etc. can be found =
and
fixed *before* the next merge window.

Commits should be getting pushed to riscv_kvm_next, i.e. pulled by linux-ne=
xt,
the instant you are confident they are "stable" and unlikely to be amended.=
  The
entire RISC-V KVM tree showing up in linux-next a week before the merge win=
dow
opens is *way* too late.

From Documentation/process/howto.rst:

  - As soon as a new kernel is released a two week window is open,
    during this period of time maintainers can submit big diffs to
    Linus, usually the patches that have already been included in the
    linux-next for a few weeks.=20

...

  linux-next integration testing tree
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 =20
  Before updates from subsystem trees are merged into the mainline tree,
  they need to be integration-tested.  For this purpose, a special
  testing repository exists into which virtually all subsystem trees are
  pulled on an almost daily basis:
 =20
  	https://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git
 =20
  This way, the linux-next gives a summary outlook onto what will be
  expected to go into the mainline kernel at the next merge period.
  Adventurous testers are very welcome to runtime-test the linux-next.
 =20
The fact that your tree is based on -rc6 means your entire workflow is flaw=
ed.
There is almost never a need to to use a release candidate later than -rc2 =
as
the base, as the odds of there being a fix in Linus' tree aftern -rc2 that =
is
*absolutely necessary* for testing KVM are vanishingly small.

And given that these were "queued" on February 12th, but are now based on -=
rc6,
means that you reparented them at least once.  Rebasing/reparenting is expl=
icitly
documented as a Bad Idea=E2=84=A2, because for all intents and purposes reb=
asing creates
a completely new commit, and thus invalidates much of the testing that was =
done
on the prior incarnation of the branch/commits.

E.g. if you make a mistake when rebasing a patch and introduce a bug, bisec=
t will
point to the rebased commit, despite the fact that as *submitted* and origi=
nally
applied, the patch was correct.  But if you (or more likely Paolo or Linus)=
 make
the same mistake when merging the branch, bisect will point at the merge co=
mmit.
That is a huge difference, as it pinpoints that the problem wasn't with the=
 patch
itself, but instead with how it was integrated without someone else's work.

From Documentation/maintainer/rebasing-and-merging.rst

  Rebasing
  =3D=3D=3D=3D=3D=3D=3D=3D
 =20
  "Rebasing" is the process of changing the history of a series of commits
  within a repository.  There are two different types of operations that ar=
e
  referred to as rebasing since both are done with the ``git rebase``
  command, but there are significant differences between them:
 =20
   - Changing the parent (starting) commit upon which a series of patches i=
s
     built.  For example, a rebase operation could take a patch set built o=
n
     the previous kernel release and base it, instead, on the current
     release.  We'll call this operation "reparenting" in the discussion
     below.
 =20
   - Changing the history of a set of patches by fixing (or deleting) broke=
n
     commits, adding patches, adding tags to commit changelogs, or changing
     the order in which commits are applied.  In the following text, this
     type of operation will be referred to as "history modification"
 =20
  The term "rebasing" will be used to refer to both of the above operations=
.
  Used properly, rebasing can yield a cleaner and clearer development
  history; used improperly, it can obscure that history and introduce bugs.
 =20
  There are a few rules of thumb that can help developers to avoid the wors=
t
  perils of rebasing:
 =20
   - History that has been exposed to the world beyond your private system
     should usually not be changed.  Others may have pulled a copy of your
     tree and built on it; modifying your tree will create pain for them.  =
If
     work is in need of rebasing, that is usually a sign that it is not yet
     ready to be committed to a public repository.
 =20
     That said, there are always exceptions.  Some trees (linux-next being
     a significant example) are frequently rebased by their nature, and
     developers know not to base work on them.  Developers will sometimes
     expose an unstable branch for others to test with or for automated
     testing services.  If you do expose a branch that may be unstable in
     this way, be sure that prospective users know not to base work on it.
 =20
   - Do not rebase a branch that contains history created by others.  If yo=
u
     have pulled changes from another developer's repository, you are now a
     custodian of their history.  You should not change it.  With few
     exceptions, for example, a broken commit in a tree like this should be
     explicitly reverted rather than disappeared via history modification.
 =20
   - Do not reparent a tree without a good reason to do so.  Just being on =
a
     newer base or avoiding a merge with an upstream repository is not
     generally a good reason.
 =20
   - If you must reparent a repository, do not pick some random kernel comm=
it
     as the new base.  The kernel is often in a relatively unstable state
     between release points; basing development on one of those points
     increases the chances of running into surprising bugs.  When a patch
     series must move to a new base, pick a stable point (such as one of
     the -rc releases) to move to.
 =20
   - Realize that reparenting a patch series (or making significant history
     modifications) changes the environment in which it was developed and,
     likely, invalidates much of the testing that was done.  A reparented
     patch series should, as a general rule, be treated like new code and
     retested from the beginning.
 =20
  A frequent cause of merge-window trouble is when Linus is presented with =
a
  patch series that has clearly been reparented, often to a random commit,
  shortly before the pull request was sent.  The chances of such a series
  having been adequately tested are relatively low - as are the chances of
  the pull request being acted upon.
 =20
  If, instead, rebasing is limited to private trees, commits are based on a
  well-known starting point, and they are well tested, the potential for
  trouble is low.

