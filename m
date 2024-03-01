Return-Path: <kvm+bounces-10648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5E686E2E5
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 15:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BF481C22E8B
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FDE6EEE6;
	Fri,  1 Mar 2024 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ASbjTFCj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9C6EB52;
	Fri,  1 Mar 2024 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709301631; cv=none; b=ES+1De0A71btAwCcON6GK7LhCu5QO+DwDZus94uqJqCf8gaw573AIbRni3el8kqxFymgBfJ6Iq9VEE1esrEfkquZFPrImBXr8Z006DL2kBghnukT00k8pB7jnzqgcmUwJrxiV0a9Y3+TpKbJWR6T2eIJNroIt17iS3DIMf+tS98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709301631; c=relaxed/simple;
	bh=rnQG0RYa0vCgi5/RqR0kfUP0JURoJ9BVtlS3WqRsXqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+iUT5SFirVS3O5mxduGdj2ZuRgGiIFd/dG2xLzVEx9+RvJAxBGVJzSoxkyV3FZiJ4U5roy1orCPP1MplsAQemafbaFlESe1mP9KEZmGsDbDBemrF03Pt8CR7bHb5sqVMMP2LtuvanVcYO/xpQV58KVO7+e7z6TnTjyN/nFx9oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ASbjTFCj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5ce07cf1e5dso1925599a12.2;
        Fri, 01 Mar 2024 06:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709301629; x=1709906429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hpDxMagyZiMsrEcLSx4CKqR7Q5yVjUbUGFKDQCjEe8=;
        b=ASbjTFCj2L70sjzIk6Kz4L1vGamoiRO3yq1Nrax3j7sEoMegiWPhvrQiXoZBMVauWZ
         r0dULVuTptNssrnQo2GOWGwRIzllAp5z3XygMKg1/BKQLrgE22LsMXlUyC/cq0ghzC/3
         Po6pKgN7Rj4mOU+V0/HcrU8WzF0OiesdiaJE51vlpVunnr0RJSHyrSydL5ZIgHd8uHf0
         qQ6PKp6J2hyl/pWFYvXtmDwbM/RxmBYfb/rsRRUMT4oDlwP/mJ+c9oqN0A5coonaMYS+
         DrUn/MKgBeSpoSNEv8MD2o7GGiu50VX68+9KapkZlU/rEzsZcTWLGZYV6uwkQb5sDvI/
         u4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709301629; x=1709906429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hpDxMagyZiMsrEcLSx4CKqR7Q5yVjUbUGFKDQCjEe8=;
        b=Xz1spPGvck4ctJBvHpcmXBPV/W6m0KEMxMW6Fk4YyV1vJMckE+Jc5qUfvqE8j4GwGg
         oU0BtwwXODJ2RbTuxv/wBu9fzz2ZbhaNpzbWpJlEvrqNl3wD9PJodhZiB8WiFPShTwEk
         a1RB9EmEEwxaIbPFf3qLDtoYbtIdv7pR7TauNSFUNSAhINaP9iax9MpUtiJXWB43UV6+
         eYR7AlTn2Ub0Mgx9SPsZCbCXPtVm0IC9QLL66U2FVol5aEL3VtdlOGogxZTFsINsv5TO
         u5vPWcv9GQmJoNIM7UnPJiut1NjW4F1avZYQGC6SjKNKWVyUqrOyYgMi4TgEYU9b6i6I
         cGnw==
X-Forwarded-Encrypted: i=1; AJvYcCWOwTvfpim+9rKX+50QF2UJ/k3wuLavxK/vSZRSfrp/4OrW5tNA48ZpQltIfHEm3ojAgYW3XDWKR+vZpEtrLodsk4oDrJO9ppyoBGLbNW7MNKYZbxhDsdEVT/xgHnLqU36B
X-Gm-Message-State: AOJu0YxO8Hy13nHqFwIauYuG1XNPOiz3ce0Gq6H33OZyUh3/qcFWD4V2
	P+IVMEh1uciKNSdguTSbznuHg6PTnVhPaEOaU8DmHO7qgYLb7oZC34jCZ9ffu9qlFpDcNOrTmDU
	PjYgu+yrX5fx72KCVih5Wm5HXFpw=
X-Google-Smtp-Source: AGHT+IEN3fKckUQ9bIamtgU20Go7E3qdpBliAncF94FYF8hBWPLJ+p02vAHPjpbiOhvjXwyaawlg7U5DKeweY+PKcng=
X-Received: by 2002:a05:6a20:d808:b0:1a0:dcf0:c73e with SMTP id
 iv8-20020a056a20d80800b001a0dcf0c73emr1681454pzb.56.1709301629404; Fri, 01
 Mar 2024 06:00:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
 <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com> <Zd4bhQPwZDvyrF44@google.com>
In-Reply-To: <Zd4bhQPwZDvyrF44@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Fri, 1 Mar 2024 22:00:16 +0800
Message-ID: <CAJhGHyChprt9LvLXXDeu1KwS4_V5mqhUTwJyDvqca-S_PSy6zg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello, Sean

On Wed, Feb 28, 2024 at 1:27=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Feb 26, 2024, Paolo Bonzini wrote:
> > On Mon, Feb 26, 2024 at 3:34=E2=80=AFPM Lai Jiangshan <jiangshanlai@gma=
il.com> wrote:
> > > - Full control: In XENPV/Lguest, the host Linux (dom0) entry code is
> > >   subordinate to the hypervisor/switcher, and the host Linux kernel
> > >   loses control over the entry code. This can cause inconvenience if
> > >   there is a need to update something when there is a bug in the
> > >   switcher or hardware.  Integral entry gives the control back to the
> > >   host kernel.
> > >
> > > - Zero overhead incurred: The integrated entry code doesn't cause any
> > >   overhead in host Linux entry path, thanks to the discreet design wi=
th
> > >   PVM code in the switcher, where the PVM path is bypassed on host ev=
ents.
> > >   While in XENPV/Lguest, host events must be handled by the
> > >   hypervisor/switcher before being processed.
> >
> > Lguest... Now that's a name I haven't heard in a long time. :)  To be
> > honest, it's a bit weird to see yet another PV hypervisor. I think
> > what really killed Xen PV was the impossibility to protect from
> > various speculation side channel attacks, and I would like to
> > understand how PVM fares here.
> >
> > You obviously did a great job in implementing this within the KVM
> > framework; the changes in arch/x86/ are impressively small. On the
> > other hand this means it's also not really my call to decide whether
> > this is suitable for merging upstream. The bulk of the changes are
> > really in arch/x86/kernel/ and arch/x86/entry/, and those are well
> > outside my maintenance area.
>
> The bulk of changes in _this_ patchset are outside of arch/x86/kvm, but t=
here are
> more changes on the horizon:
>
>  : To mitigate the performance problem, we designed several optimizations
>  : for the shadow MMU (not included in the patchset) and also planning to
>  : build a shadow EPT in L0 for L2 PVM guests.
>
>  : - Parallel Page fault for SPT and Paravirtualized MMU Optimization.
>
> And even absent _new_ shadow paging functionality, merging PVM would effe=
ctively
> shatter any hopes of ever removing KVM's existing, complex shadow paging =
code.
>
> Specifically, unsync 4KiB PTE support in KVM provides almost no benefit f=
or nested
> TDP.  So if we can ever drop support for legacy shadow paging, which is a=
 big if,
> but not completely impossible, then we could greatly simplify KVM's shado=
w MMU.
>

One of the important goals of open-sourcing PVM is to allow for the
optimization of shadow paging, especially through paravirtualization
methods, and potentially even to eliminate the need for shadow paging.

1) Technology: Shadow paging is a technique for page table compaction in
   the category of "one-dimensional paging", which includes the direct
   paging technology in XenPV. When the page tables are stable,
   one-dimensional paging can outperform TDP because it saves on TLB
   resources. Another one-dimensional paging technology would be better
   to be introduced before shadow paging is removed for performance.

2) Naming: The reason we use the name shadowpage in our paper and the
   cover letter is that this term is more widely recognized and makes it
   easier for people to understand how PVM implements its page tables.
   It also demonstrates that PVM is able to implement a paging mechanism
   with very little code on top of KVM. However, this does not mean we
   adhere to shadow paging. Any one-dimensional paging technology can
   work here too.

3) Paravirt: As you mentioned, the best way to eliminate shadow paging
   is by using a paravirtualization (PV) approach. PVM is inherently
   suitable for having PV since it is a paravirt solution and has a
   corresponding framework. However, PV pagetables leads to a complex
   patchset, which we prefer not to include in the initial PVM patchset
   introduction.

4) Pave the path: One of the purposes of open-sourcing PVM is to bring
   in a new scenario for possibly introducing PV pagetable interfaces
   and optimizing shadow paging. Moreover, investing development effort
   in shadow paging is the only way to ultimately remove it.

5) Optimizations: We have experimented with numerous optimizations
   including at least two categories: parallel-pagetable and
   enlightened-pagetable. The parallel pagetable overhauls the locking
   mechanism within the shadow paging. The enlightened-pagetable
   introduces PVOPS in the guest to modify the page tables. One set of
   PVOPS, used on 4KiB PTEs, queues the pointers of the modified GPTEs
   in a hypervisor-guest shared ring buffer. Although the overall
   mechanism, including TLB handling, is not simple, the hypervisor
   portion is simpler than the unsync-sp method, and it bypasses many
   unsync-sp related code paths. The other set of PVOPS targets larger
   page table entries and directly issues hypercalls. Should both sets
   of PVOPS be utilized, write-protect for SPs is unneeded and shadow
   paging could be considered as being removed.


> Which is a good segue into my main question: was there any one thing that=
 was
> _the_ motivating factor for taking on the cost+complexity of shadow pagin=
g?  And
> as alluded to be Paolo, taking on the downsides of reduced isolation?
>
> It doesn't seem like avoiding L0 changes was the driving decision, since =
IIUC
> you have plans to make changes there as well.
>
>  : To mitigate the performance problem, we designed several optimizations
>  : for the shadow MMU (not included in the patchset) and also planning to
>  : build a shadow EPT in L0 for L2 PVM guests.
>


Getting every cloud provider to adopt a technology is more challenging
than developing the technology itself. It is easy to compile a list that
includes many technologies for L0 that have been merged into upstream
KVM for quite some time, yet not all major cloud providers use or
support them.

The purpose of PVM includes enabling the use of KVM within various cloud
VMs, allowing for easy operation of businesses with secure containers.
Therefore, it cannot rely on whether cloud providers make such changes
to L0.

The reason we are experimenting with modifications to L0 is because we
have many physical machines. Developing this technology getting help from
L0 for L2 paging could provide us and others who have their own physical
machines with an additional option.


> Performance I can kinda sorta understand, but my gut feeling is that the =
problems
> with nested virtualization are solvable by adding nested paravirtualizati=
on between
> L0<=3D>L1, with likely lower overall cost+complexity than paravirtualizin=
g L1<=3D>L2.
>
> The bulk of the pain with nested hardware virtualization lies in having t=
o emulate
> VMX/SVM, and shadow L1's TDP page tables.  Hyper-V's eVMCS takes some of =
the sting
> off nVMX in particular, but eVMCS is still hobbled by its desire to be al=
most
> drop-in compatible with VMX.
>
> If we're willing to define a fully PV interface between L0 and L1 hypervi=
sors, I
> suspect we provide performance far, far better than nVMX/nSVM.  E.g. if L=
0 provides
> a hypercall to map an L2=3D>L1 GPA, then L0 doesn't need to shadow L1 TDP=
, and L1
> doesn't even need to maintain hardware-defined page tables, it can use wh=
atever
> software-defined data structure best fits it needs.
>
> And if we limit support to 64-bit L2 kernels and drop support for unneces=
sary cruft,
> the L1<=3D>L2 entry/exit paths could be drastically simplified and stream=
lined.  And
> it should be very doable to concoct an ABI between L0 and L2 that allows =
L0 to
> directly emulate "hot" instructions from L2, e.g. CPUID, common MSRs, etc=
.  I/O
> would likely be solvable too, e.g. maybe with a mediated device type solu=
tion that
> allows L0 to handle the data path for L2?
>
> The one thing that I don't see line of sight to supporting is taking L0 o=
ut of the
> TCB, i.e. running L2 VMs inside TDX/SNP guests.  But for me at least, tha=
t alone
> isn't sufficient justification for adding a PV flavor of KVM.


I didn't want to suggest that running PVM inside TDX is an important use
case, but I just used it to emphasize PVM's universally accessibility in
all environments, including inside the notoriously otherwise impossible
environment as TDX as Paolo said in a LWN comment:
https://lwn.net/Articles/865807/

 : TDX cannot be used in a nested VM, and you cannot use nested
 : virtualization inside a TDX virtual machine.

(and actually the support for PVM in TDX/SNP is not completed yet)

Thanks
Lai

