Return-Path: <kvm+bounces-47155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BEBABE06B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D9E03B27F1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F5E28000C;
	Tue, 20 May 2025 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s9pVr6JL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183926A09A
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747757609; cv=none; b=fI3UzafPUyjyhsoWZ6aqB9r7v867T0O0qwu1j4E4dRq0O0FL7a8RakUHDyNon4gm7tb8aBDmo+vZjsFovPih2mRHovioTyXf8E5cfFSlEictFTPINOvymuoAYg4u9KvLlwAN7L8Amla6URKQC+xSendfUjSpNkezFTuGE2AGJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747757609; c=relaxed/simple;
	bh=KE2OCe6IyeztKEsfnChEOSQXap8doIjqd735T6E7YA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJWy0HVNQO8S0DFHDyILt6BqIwvn6F6GJB8SeAibeQpUBsYs6zzXKCxBYNajLej59/AUv0LDKJUf/18VMsBPQSsN8LeaIRO9G1P2mq55X8np8seBCh0mBc6kVxMxCwd2nbGWbnR3Qaq290sN3wz6QIKDaz5w6CiJHi6n489yiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s9pVr6JL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e8aec4689so4688391a91.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747757607; x=1748362407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ls0/Kk7BPNf74U1b37tpKVNG4EXoATMFXNgVLcw3EiQ=;
        b=s9pVr6JLXBYRs3v5K3xBFiX3wmzzSHW3nyzneXsJX1cKbo07Xlo+F9F/5H7hnSoWCF
         JEoulPbRS9FkOZDWWFrLC11KqydWFz8DA2kllTh4i+qsyui+V3vmiWQ4ppqLSIq6212D
         XnrDzrisFwcvew4DzwACNc21K4isGwyecRMwIdD3PwnoVSBv/9c/SBSAtGvgxqgB3kpX
         rLAt9twvESe5oGq50Az7No9lw9bubwkeANOXY0GMnQe/eBxT0iKcHqM3Gx1RBPbkt+EG
         8ub+9xfq/TzSbZbWy1gJcggYnGSvHWXYWGV8R3LgNyfYgPkaEoVQHtsoDI4VKT/3caGj
         dnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747757607; x=1748362407;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ls0/Kk7BPNf74U1b37tpKVNG4EXoATMFXNgVLcw3EiQ=;
        b=pgyCybWG8GwAVcEtQ1/du9ONtYFMJakzJjOZDnr0cFErm1o/4HHwc2pvhwIREJOjSl
         3jKl/03T6XeNzPOhijMts+N9SOTK76cfAkmqnsncjzISy70wOD+MX7NuyoQJgjAPCsGE
         6Ch9A2TPxxqgZgZlhx/wexRdjtMnKXGmWxFi8SyMYPJeU2xCD2Qy7OKP8DtRi4urqOaO
         jSwvV17CLqNQE6boBx1YvV75R8rxSy2c76Nt0qhIUdqj368L1NmuyfMwXogjGU2YqA2A
         e3UTGS1+ESUmQkCgIB4KEJvonr4bWMcitPG2l3GVclCgHoIzrdUQGzBm/p4EgXH6R+C2
         rfjQ==
X-Forwarded-Encrypted: i=1; AJvYcCURzFPugDroZJaR02c9H0Cx1nOYCT2DaTITveY+45VfSmrVGSInw522wj9vETiD2ZqGKP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRfboZc/4q+sBBrvmYFeuSWKuEaUWiY6SVC0nx/lJ/5v8gk4Be
	mfLsmUzdP0kbz+okdqXlb2sIZMXhtWgbyAPjcPvq/4XBwvKAscSOHJ3ICLpUwKxiIp1utSfbgnQ
	mFDj3Ww==
X-Google-Smtp-Source: AGHT+IHMKyPInf5Mx6zQ4/ui8cpT9wwv9RNjU8jzSIFSzm+Iwk1A8XhiboMbrIzMSQGLh2tYzCEvCXrUorE=
X-Received: from pjbnc5.prod.google.com ([2002:a17:90b:37c5:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f46:b0:2ee:fa0c:cebc
 with SMTP id 98e67ed59e1d1-30e7d555a46mr25556918a91.20.1747757607132; Tue, 20
 May 2025 09:13:27 -0700 (PDT)
Date: Tue, 20 May 2025 09:13:25 -0700
In-Reply-To: <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519023613.30329-1-yan.y.zhao@intel.com> <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com> <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com> <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
Message-ID: <aCyqJTSDTKt1xiKr@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025, Yan Zhao wrote:
> On Mon, May 19, 2025 at 10:06:22AM -0700, Sean Christopherson wrote:
> > On Mon, May 19, 2025, Rick P Edgecombe wrote:
> > > On Mon, 2025-05-19 at 06:33 -0700, Sean Christopherson wrote:
> > > > Was this hit by a real VMM?=C2=A0 If so, why is a TDX VMM removing =
a memslot without
> > > > kicking vCPUs out of KVM?
> > > >=20
> > > > Regardless, I would prefer not to add a new RET_PF_* flag for this.=
=C2=A0 At a glance,
> > > > KVM can simply drop and reacquire SRCU in the relevant paths.
> > >=20
> > > During the initial debugging and kicking around stage, this is the fi=
rst
> > > direction we looked. But kvm_gmem_populate() doesn't have scru locked=
, so then
> > > kvm_tdp_map_page() tries to unlock without it being held. (although t=
hat version
> > > didn't check r =3D=3D RET_PF_RETRY like you had). Yan had the followi=
ng concerns and
> > > came up with the version in this series, which we held review on for =
the list:
> >=20
> > Ah, I missed the kvm_gmem_populate() =3D> kvm_tdp_map_page() chain.
> >=20
> > > > However, upon further consideration, I am reluctant to implement th=
is fix for
> >=20
> > Which fix?
> >=20
> > > > the following reasons:
> > > > - kvm_gmem_populate() already holds the kvm->slots_lock.
> > > > - While retrying with srcu unlock and lock can workaround the
> > > >   KVM_MEMSLOT_INVALID deadlock, it results in each kvm_vcpu_pre_fau=
lt_memory()
> > > >   and tdx_handle_ept_violation() faulting with different memslot la=
youts.
> >=20
> > This behavior has existed since pretty much the beginning of KVM time. =
 TDX is the
> > oddball that doesn't re-enter the guest.  All other flavors re-enter th=
e guest on
> > RET_PF_RETRY, which means dropping and reacquiring SRCU.  Which is why =
I don't like
> > RET_PF_RETRY_INVALID_SLOT; it's simply handling the case we know about.
> >=20
> > Arguably, _TDX_ is buggy by not providing this behavior.
> >=20
> > > I'm not sure why the second one is really a problem. For the first on=
e I think
> > > that path could just take the scru lock in the proper order with kvm-
> > > >slots_lock?
> >=20
> > Acquiring SRCU inside slots_lock should be fine.  The reserve order wou=
ld be
> > problematic, as KVM synchronizes SRCU while holding slots_lock.
> >=20
> > That said, I don't love the idea of grabbing SRCU, because it's so obvi=
ously a
> > hack.  What about something like this?
> So you want to avoid acquiring SRCU in the kvm_gmem_populate() path?

Yes, ideally.  Acquiring SCRU wouldn't be the end of the world, but I don't=
 love
the idea of taking a lock just so that the lock can be conditionally droppe=
d in
a common flow.  It's not a deal breaker (I wouldn't be surprised if there's=
 at
least one path in KVM that acquires SRCU purely because of such behavior), =
but
separating kvm_tdp_prefault_page() from kvm_tdp_map_page()=20

> Generally I think it's good, except that it missed a kvm_mmu_reload() (pl=
ease
> refer to my comment below) and the kvm_vcpu_srcu_read_{un}lock() pair in
> tdx_handle_ept_violation() path (So, Reinette reported it failed the TDX =
stress
> tests at [1]).

> > @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_=
t gpa, u64 error_code, u8 *level
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> > =20
> > +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_=
code, u8 *level)
> > +{
> > +	int r;
> > +
> > +	/*
> > +	 * Restrict to TDP page fault, since that's the only case where the M=
MU
> > +	 * is indexed by GPA.
> > +	 */
> > +	if (vcpu->arch.mmu->page_fault !=3D kvm_tdp_page_fault)
> > +		return -EOPNOTSUPP;
> > +
> > +	for (;;) {
> > +		r =3D kvm_tdp_map_page(vcpu, gpa, error_code, level);
> > +		if (r !=3D -EAGAIN)
> > +			break;
> > +
> > +		/* Comment goes here. */
> > +		kvm_vcpu_srcu_read_unlock(vcpu);
> > +		kvm_vcpu_srcu_read_lock(vcpu);
> For the hang in the pre_fault_memory_test reported by Reinette [1], it's =
because
> the memslot removal succeeds after releasing the SRCU, then the old root =
is
> stale. So kvm_mmu_reload() is required here to prevent is_page_fault_stal=
e()
> from being always true.

That wouldn't suffice, KVM would also need to process KVM_REQ_MMU_FREE_OBSO=
LETE_ROOTS,
otherwise kvm_mmu_reload() will do nothing.

Thinking about this scenario more, I don't mind punting this problem to use=
rspace
for KVM_PRE_FAULT_MEMORY because there's no existing behavior/ABI to uphold=
, and
because the complexity vs. ABI tradeoffs are heavily weighted in favor of p=
unting
to userspace.  Whereas for KVM_RUN, KVM can't change existing behavior with=
out
breaking userspace, should provide consistent behavior regardless of VM typ=
e, and
KVM needs the "complex" code irrespective of this particular scenario.

I especially like punting to userspace if KVM returns -EAGAIN, not -ENOENT,
because then KVM is effectively providing the same overall behavior as KVM_=
RUN,
just without slightly different roles and responsibilities between KVM and
userspace.  And -ENOENT is also flat out wrong for the case where a memslot=
 is
being moved, but the new base+size still contains the to-be-faulted GPA.

I still don't like RET_PF_RETRY_INVALID_SLOT, because that bleeds gory MMU =
details
into the rest of KVM, but KVM can simply return -EAGAIN if an invalid memsl=
ot is
encountered during prefault (as identified by fault->prefetch).

For TDX though, tdx_handle_ept_violation() needs to play nice with the scen=
ario,
i.e. punting to userspace is not a viable option.  But that path also has o=
ptions
that aren't available to prefaulting.  E.g. it could (and probably should) =
break
early if a request is pending instead of special casing KVM_REQ_VM_DEAD, wh=
ich
would take care of the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS scenario.  And as Ri=
ck
called out, the zero-step mess really needs to be solved in a more robust f=
ashion.

So this?

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 20 May 2025 07:55:32 -0700
Subject: [PATCH] KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves
 memslot during prefault

Return -EAGAIN if userspace attemps to delete or move a memslot while also
prefaulting memory for that same memslot, i.e. force userspace to retry
instead of trying to handle the scenario entirely within KVM.  Unlike
KVM_RUN, which needs to handle the scenario entirely within KVM because
userspace has come to depend on such behavior, KVM_PRE_FAULT_MEMORY can
return -EAGAIN without breaking userspace as this scenario can't have ever
worked (and there's no sane use case for prefaulting to a memslot that's
being deleted/moved).

And also unlike KVM_RUN, the prefault path doesn't naturally gaurantee
forward progress.  E.g. to handle such a scenario, KVM would need to drop
and reacquire SRCU to break the deadlock between the memslot update
(synchronizes SRCU) and the prefault (waits for the memslot update to
complete).

However, dropping SRCU creates more problems, as completing the memslot
update will bump the memslot generation, which in turn will invalidate the
MMU root.  To handle that, prefaulting would need to handle pending
KVM_REQ_MMU_FREE_OBSOLETE_ROOTS requests and do kvm_mmu_reload() prior to
mapping each individual.

I.e. to fully handle this scenario, prefaulting would eventually need to
look a lot like vcpu_enter_guest().  Given that there's no reasonable use
case and practically zero risk of breaking userspace, punt the problem to
userspace and avoid adding unnecessary complexity to the prefualt path.

Note, TDX's guest_memfd post-populate path is unaffected as slots_lock is
held for the entire duration of populate(), i.e. any memslot modifications
will be fully serialized against TDX's flavor of prefaulting.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel=
.com
Debugged-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a284dce227a0..7ae56a3c7607 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4595,10 +4595,16 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcp=
u,
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
-	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
+	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.  Punt the
+	 * error to userspace if this is a prefault, as KVM's prefaulting ABI
+	 * doesn't need provide the same forward progress guarantees as KVM_RUN.
 	 */
-	if (slot->flags & KVM_MEMSLOT_INVALID)
+	if (slot->flags & KVM_MEMSLOT_INVALID) {
+		if (fault->prefetch)
+			return -EAGAIN;
+
 		return RET_PF_RETRY;
+	}
=20
 	if (slot->id =3D=3D APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
 		/*

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
--

