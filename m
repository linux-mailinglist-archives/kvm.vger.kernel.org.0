Return-Path: <kvm+bounces-21219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8F492C2C9
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75D02283596
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 17:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1590317B043;
	Tue,  9 Jul 2024 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQcVGKeb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D21B86EF
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720547380; cv=none; b=KtXGBxlNpY4e5xqHJlOGVfESB35mdbxH/DvCx271Q/tWG2qrFom47TE+afYcit6cospDekR5H9hz/S+JgrITtkYwucBoFxru6e4q3hwmX3M+nXQo2RsPbjScsiHJ+MDXWpn7HFhrVnA8LQFRAUf+fJOEweBH9rK50pgg3gLtmjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720547380; c=relaxed/simple;
	bh=dY+lUZ8Mpz7G3y7r8O4eTqL6qKCOvVANRZDSPBHjLvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bG+7mnzRmLhXPC8ZgioBF6dpU9mlgfVmyVRBOqmsq4DoiSOvmeudPxh2THlug1CC9YROgYaR0kThqOSxXstuMOBsEnxakDzFJMJp/Y7f10XLGyMgqzXAMwGSAMrCHP/vsEiwh9J2m9ysuiXaxbFLmQzGRB6rYAOe+rJKBskQfFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQcVGKeb; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6502e4c5aafso54939217b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 10:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720547376; x=1721152176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVrOFEvDX+XM8YnlH+Wmmy/8FZGIo1WsbeGzDkgNVps=;
        b=LQcVGKeb4FAkIGUOzeblNM/6Za6oLjARwtPqIGS+ThO9j7YvnUeBJjZwPt0VNS47Go
         e36dkhntWAP6pcWqWLhI3HGiFZnK/4jU9oZVXDLh5OGJXlwDyVehs3mmXKACzmoWJSv+
         iNJRlV4OX62e0qmqwvqJM5GTmGn79im2ORPfA5+Z8GDbiLyy11xoRVBYotzrriq5LLjG
         noVJ92cAEej+SVTMJVofxqWwti7g216m8gqXHtmLurLjH3Au4uI9cr7OKjJNf5j+jwiR
         QmM8kYJT1qtDT1foiGiI/KOr+8hKHTKBpSB51jpzT9TWU2tMLEWi9uEdrHXO/3jfUPMM
         mChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720547376; x=1721152176;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vVrOFEvDX+XM8YnlH+Wmmy/8FZGIo1WsbeGzDkgNVps=;
        b=lOBGRepejeVrmyrb17gpzrlfGLQM3n1+ZkspvnZXAZOseypHCDIhj3hCqZ5YGzimn/
         rap01WAEYMgbkVLGb8CYr3Ec2W2HxUmq7BLZCnD6F/CUhJxWnzMJT/l/2kP+gH60A965
         6nLpXQNWni1wnI/Y/XYhbkQFY6JbcnRx2jMTJHqg1kVccbePjzyzPcZXJg0C0UMipPy0
         tGFnRhAsSPWwWdD55hzmN0cA0vTuoz3r6+6UjvFOKZNiroG7xyoHLFZjX5GqZr46/4YV
         XnafZ+oNNUVDfp7mBT/QAf5HyogxLr1BlGRcvvRqK9NSN5EE3vLBbDzsUGYk5vrpDcIF
         w5fw==
X-Forwarded-Encrypted: i=1; AJvYcCXx6UCs7VtGo+JQnB030wflOvdPvaWm4qsiGOQEnFWIT3936gmoEgHQntqCIfZHVYzOSmaeWHd9JX2gqH/D80GpvZKz
X-Gm-Message-State: AOJu0YwH35JBERsoczu+mejdPtGbni/BUY54MTTey3MBUWUSW3EvvDti
	lMXBqj2DCZwDJbevWEG73uruewlVbQ4KIDpWiFduW0QTtvrnXnYgYqVzO7IHIuDRG23by3lP+hW
	ipw==
X-Google-Smtp-Source: AGHT+IFsZ6Q+oxAaPQSUV2QgR6LdQz2eaiEWblLJAUmt8IoOc2zaha2Rbw12EZbueXNK3o+GzpRzKLUZke0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2b11:b0:644:c4d6:add0 with SMTP id
 00721157ae682-659177ca45amr105927b3.1.1720547375567; Tue, 09 Jul 2024
 10:49:35 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:49:34 -0700
In-Reply-To: <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com> <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
 <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com>
Message-ID: <Zo137P7BFSxAutL2@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2024, James Houghton wrote:
> On Fri, Jun 28, 2024 at 7:38=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > On Mon, Jun 17, 2024 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Mon, Jun 17, 2024, James Houghton wrote:
> > > > On Fri, Jun 14, 2024 at 4:17=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > Ooh!  Actually, after fiddling a bit to see how feasible fast-agi=
ng in the shadow
> > > > > MMU would be, I'm pretty sure we can do straight there for nested=
 TDP.  Or rather,
> > > > > I suspect/hope we can get close enough for an initial merge, whic=
h would allow
> > > > > aging_is_fast to be a property of the mmu_notifier, i.e. would si=
mplify things
> > > > > because KVM wouldn't need to communicate MMU_NOTIFY_WAS_FAST for =
each notification.
> > > > >
> > > > > Walking KVM's rmaps requires mmu_lock because adding/removing rma=
p entries is done
> > > > > in such a way that a lockless walk would be painfully complex.  B=
ut if there is
> > > > > exactly _one_ rmap entry for a gfn, then slot->arch.rmap[...] poi=
nts directly at
> > > > > that one SPTE.  And with nested TDP, unless L1 is doing something=
 uncommon, e.g.
> > > > > mapping the same page into multiple L2s, that overwhelming vast m=
ajority of rmaps
> > > > > have only one entry.  That's not the case for legacy shadow pagin=
g because kernels
> > > > > almost always map a pfn using multiple virtual addresses, e.g. Li=
nux's direct map
> > > > > along with any userspace mappings.
> >
> > Hi Sean, sorry for taking so long to get back to you.
> >
> > So just to make sure I have this right: if L1 is using TDP, the gfns
> > in L0 will usually only be mapped by a single spte. If L1 is not using
> > TDP, then all bets are off. Is that true?
> >
> > If that is true, given that we don't really have control over whether
> > or not L1 decides to use TDP, the lockless shadow MMU walk will work,
> > but, if L1 is not using TDP, it will often return false negatives
> > (says "old" for an actually-young gfn). So then I don't really
> > understand conditioning the lockless shadow MMU walk on us (L0) using
> > the TDP MMU[1]. We care about L1, right?
>=20
> Ok I think I understand now. If L1 is using shadow paging, L2 is
> accessing memory the same way L1 would, so we use the TDP MMU at L0
> for this case (if tdp_mmu_enabled). If L1 is using TDP, then we must
> use the shadow MMU, so that's the interesting case.

Yep.
=20
> > (Maybe you're saying that, when the TDP MMU is enabled, the only cases
> > where the shadow MMU is used are cases where gfns are practically
> > always mapped by a single shadow PTE. This isn't how I understood your
> > mail, but this is what your hack-a-patch[1] makes me think.)
>=20
> So it appears that this interpretation is actually what you meant.

Yep.

> > [1] https://lore.kernel.org/linux-mm/ZmzPoW7K5GIitQ8B@google.com/
> >
> > >
> > > ...
> > >
> > > > Hmm, interesting. I need to spend a little bit more time digesting =
this.
> > > >
> > > > Would you like to see this included in v6? (It'd be nice to avoid t=
he
> > > > WAS_FAST stuff....) Should we leave it for a later series? I haven'=
t
> > > > formed my own opinion yet.
> > >
> > > I would say it depends on the viability and complexity of my idea.  E=
.g. if it
> > > pans out more or less like my rough sketch, then it's probably worth =
taking on
> > > the extra code+complexity in KVM to avoid the whole WAS_FAST goo.
> > >
> > > Note, if we do go this route, the implementation would need to be twe=
aked to
> > > handle the difference in behavior between aging and last-minute check=
s for eviction,
> > > which I obviously didn't understand when I threw together that hack-a=
-patch.
> > >
> > > I need to think more about how best to handle that though, e.g. skipp=
ing GFNs with
> > > multiple mappings is probably the worst possible behavior, as we'd ri=
sk evicting
> > > hot pages.  But falling back to taking mmu_lock for write isn't all t=
hat desirable
> > > either.
> >
> > I think falling back to the write lock is more desirable than evicting
> > a young page.
> >
> > I've attached what I think could work, a diff on top of this series.
> > It builds at least. It uses rcu_read_lock/unlock() for
> > walk_shadow_page_lockless_begin/end(NULL), and it puts a
> > synchronize_rcu() in kvm_mmu_commit_zap_page().
> >
> > It doesn't get rid of the WAS_FAST things because it doesn't do
> > exactly what [1] does. It basically makes three calls now: lockless
> > TDP MMU, lockless shadow MMU, locked shadow MMU. It only calls the
> > locked shadow MMU bits if the lockless bits say !young (instead of
> > being conditioned on tdp_mmu_enabled). My choice is definitely
> > questionable for the clear path.
>=20
> I still don't think we should get rid of the WAS_FAST stuff.

I do :-)

> The assumption that the L1 VM will almost never share pages between L2
> VMs is questionable. The real question becomes: do we care to have
> accurate age information for this case? I think so.

I think you're conflating two different things.  WAS_FAST isn't about accur=
acy,
it's about supporting lookaround in conditionally fast secondary MMUs.

Accuracy only comes into play when we're talking about the last-minute chec=
k,
which, IIUC, has nothing to do with WAS_FAST because any potential lookarou=
nd has
already been performed.

> It's not completely trivial to get the lockless walking of the shadow
> MMU rmaps correct either (please see the patch I attached here[1]).

Heh, it's not correct.  Invoking synchronize_rcu() in kvm_mmu_commit_zap_pa=
ge()
is illegal, as mmu_lock (rwlock) is held and synchronize_rcu() might_sleep(=
).

For kvm_test_age_rmap_fast(), KVM can blindly read READ_ONCE(*sptep).  KVM =
might
read garbage, but that would be an _extremely_ rare scenario, and reporting=
 a
zapped page as being young is acceptable in that 1 in a billion situation.

For kvm_age_rmap_fast(), i.e. where KVM needs to write, I'm pretty sure KVM=
 can
handle that by rechecking the rmap and using CMPXCHG to write the SPTE.  If=
 the
rmap is unchanged, then the old SPTE value is guaranteed to be valid, in th=
e sense
that its value most definitely came from a KVM shadow page table.  Ah, drat=
, that
won't work, because very theoretically, the page table could be freed, real=
located,
and rewritten with the exact same value by something other than KVM.  Hrm.

Looking more closely, I think we can go straight to supporting rmap walks o=
utside
of mmu_lock.  There will still be a "lock", but it will be a *very* rudimen=
tary
lock, akin to the TDP MMU's REMOVED_SPTE approach.  Bit 0 of rmap_head->val=
 is
used to indicate "many", while bits 63:3/31:2 on 64-bit/32-bit KVM hold the
pointer (to a SPTE or a list).  That means bit 1 is available for shenaniga=
ns.

If we use bit 1 to lock the rmap, then the fast mmu_notifier can safely wal=
k the
entire rmap chain.  And with a reader/write scheme, the rmap walks that are
performed under mmu_lock don't need to lock the rmap, which means flows lik=
e
kvm_mmu_zap_collapsible_spte() don't need to be modified to avoid recursive
self-deadlock.  Lastly, the locking can be conditioned on the rmap being va=
lid,
i.e. having at least one SPTE.  That way the common case of a gfn not havin=
g any
rmaps is a glorified nop.

Adding the locking isn't actually all that difficult, with the *huge* cavea=
t that
the below patch is compile-tested only.  The vast majority of the churn is =
to make
it so existing code ignores the new KVM_RMAP_LOCKED bit.

I don't know that we should pursue such an approach in this series unless w=
e have
to.  E.g. if we can avoid WAS_FAST or don't have to carry too much intermed=
iate
complexity, then it'd probably be better to land the TDP MMU support first =
and
then add nested TDP support later.

At the very least, it does make me more confident that a fast walk of the r=
maps
is very doable (at least for nested TDP), i.e. makes me even more steadfast
against adding WAS_FAST.

> And the WAS_FAST functionality isn't even that complex to begin with.

I agree the raw code isn't terribly complex, but it's not trivial either.  =
And the
concept and *behavior* is complex, which is just as much of a maintenance b=
urden
as the code itself.  E.g. it requires knowing that KVM has multiple MMUs bu=
ried
behind a single mmu_notifier, and that a "hit" on the fast MMU will trigger
lookaround on the fast MMU, but not the slow MMU.  Understanding and descri=
bing
the implications of that behavior isn't easy.  E.g. if GFN=3DX is young in =
the TDP
MMU, but X+1..X+N are young only in the shadow MMU, is doing lookaround and=
 making
decisions based purely on the TDP MMU state the "right" behavior?

I also really don't like bleeding KVM details into the mmu_nofitier APIs.  =
The
need for WAS_FAST is 100% a KVM limitation.  AFAIK, no other secondary MMU =
has
multiple MMU implementations active behind a single notifier, and other tha=
n lack
of support, nothing fundamentally prevents a fast query in the shadow MMU.

---
 arch/x86/kvm/mmu/mmu.c | 163 ++++++++++++++++++++++++++++++++---------
 1 file changed, 128 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 842a3a4cdfe9..bfcfdc0a8600 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -935,9 +935,59 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bi=
tmap(struct kvm_vcpu *vcpu
  * About rmap_head encoding:
  *
  * If the bit zero of rmap_head->val is clear, then it points to the only =
spte
- * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
+ * in this rmap chain. Otherwise, (rmap_head->val & ~3) points to a struct
  * pte_list_desc containing more mappings.
  */
+#define KVM_RMAP_MANY	BIT(0)
+#define KVM_RMAP_LOCKED	BIT(1)
+
+static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+{
+	unsigned long old_val, new_val;
+
+	old_val =3D READ_ONCE(rmap_head->val);
+	if (!old_val)
+		return 0;
+
+	do {
+		while (old_val & KVM_RMAP_LOCKED) {
+			old_val =3D READ_ONCE(rmap_head->val);
+			cpu_relax();
+		}
+		if (!old_val)
+			return 0;
+
+		new_val =3D old_val | KVM_RMAP_LOCKED;
+	} while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
+
+	return old_val;
+}
+
+static unsigned long kvm_rmap_write_lock(struct kvm_rmap_head *rmap_head)
+{
+	return kvm_rmap_lock(rmap_head);
+}
+
+static void kvm_rmap_write_ulock(struct kvm_rmap_head *rmap_head,
+			    unsigned long new_val)
+{
+	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	WRITE_ONCE(rmap_head->val, new_val);
+}
+
+static unsigned long kvm_rmap_read_lock(struct kvm_rmap_head *rmap_head)
+{
+	return kvm_rmap_lock(rmap_head);
+}
+
+static void kvm_rmap_read_unlock(struct kvm_rmap_head *rmap_head,
+				 unsigned long old_val)
+{
+	if (!old_val)
+		return;
+
+	WRITE_ONCE(rmap_head->val, old_val & ~KVM_RMAP_LOCKED);
+}
=20
 /*
  * Returns the number of pointers in the rmap chain, not counting the new =
one.
@@ -945,21 +995,24 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_b=
itmap(struct kvm_vcpu *vcpu
 static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
+	unsigned long old_val, new_val;
 	struct pte_list_desc *desc;
 	int count =3D 0;
=20
-	if (!rmap_head->val) {
-		rmap_head->val =3D (unsigned long)spte;
-	} else if (!(rmap_head->val & 1)) {
+	old_val =3D kvm_rmap_write_lock(rmap_head);
+
+	if (!old_val) {
+		new_val =3D (unsigned long)spte;
+	} else if (!(old_val & KVM_RMAP_MANY)) {
 		desc =3D kvm_mmu_memory_cache_alloc(cache);
-		desc->sptes[0] =3D (u64 *)rmap_head->val;
+		desc->sptes[0] =3D (u64 *)old_val;
 		desc->sptes[1] =3D spte;
 		desc->spte_count =3D 2;
 		desc->tail_count =3D 0;
-		rmap_head->val =3D (unsigned long)desc | 1;
+		new_val =3D (unsigned long)desc | KVM_RMAP_MANY;
 		++count;
 	} else {
-		desc =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		desc =3D (struct pte_list_desc *)(old_val & ~KVM_RMAP_MANY);
 		count =3D desc->tail_count + desc->spte_count;
=20
 		/*
@@ -968,21 +1021,25 @@ static int pte_list_add(struct kvm_mmu_memory_cache =
*cache, u64 *spte,
 		 */
 		if (desc->spte_count =3D=3D PTE_LIST_EXT) {
 			desc =3D kvm_mmu_memory_cache_alloc(cache);
-			desc->more =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+			desc->more =3D (struct pte_list_desc *)(old_val & ~KVM_RMAP_MANY);
 			desc->spte_count =3D 0;
 			desc->tail_count =3D count;
-			rmap_head->val =3D (unsigned long)desc | 1;
+			new_val =3D (unsigned long)desc | KVM_RMAP_MANY;
+		} else {
+			new_val =3D old_val;
 		}
 		desc->sptes[desc->spte_count++] =3D spte;
 	}
+
+	kvm_rmap_write_ulock(rmap_head, new_val);
+
 	return count;
 }
=20
-static void pte_list_desc_remove_entry(struct kvm *kvm,
-				       struct kvm_rmap_head *rmap_head,
+static void pte_list_desc_remove_entry(struct kvm *kvm, unsigned long *rma=
p_val,
 				       struct pte_list_desc *desc, int i)
 {
-	struct pte_list_desc *head_desc =3D (struct pte_list_desc *)(rmap_head->v=
al & ~1ul);
+	struct pte_list_desc *head_desc =3D (struct pte_list_desc *)(*rmap_val & =
~KVM_RMAP_MANY);
 	int j =3D head_desc->spte_count - 1;
=20
 	/*
@@ -1009,9 +1066,9 @@ static void pte_list_desc_remove_entry(struct kvm *kv=
m,
 	 * head at the next descriptor, i.e. the new head.
 	 */
 	if (!head_desc->more)
-		rmap_head->val =3D 0;
+		*rmap_val =3D 0;
 	else
-		rmap_head->val =3D (unsigned long)head_desc->more | 1;
+		*rmap_val =3D (unsigned long)head_desc->more | KVM_RMAP_MANY;
 	mmu_free_pte_list_desc(head_desc);
 }
=20
@@ -1019,24 +1076,26 @@ static void pte_list_remove(struct kvm *kvm, u64 *s=
pte,
 			    struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
+	unsigned long rmap_val;
 	int i;
=20
-	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_head->val, kvm))
-		return;
+	rmap_val =3D kvm_rmap_write_lock(rmap_head);
+	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
+		goto out;
=20
-	if (!(rmap_head->val & 1)) {
-		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_head->val !=3D spte, kvm))
-			return;
+	if (!(rmap_val & KVM_RMAP_MANY)) {
+		if (KVM_BUG_ON_DATA_CORRUPTION((u64 *)rmap_val !=3D spte, kvm))
+			goto out;
=20
-		rmap_head->val =3D 0;
+		rmap_val =3D 0;
 	} else {
-		desc =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		desc =3D (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 		while (desc) {
 			for (i =3D 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] =3D=3D spte) {
-					pte_list_desc_remove_entry(kvm, rmap_head,
+					pte_list_desc_remove_entry(kvm, &rmap_val,
 								   desc, i);
-					return;
+					goto out;
 				}
 			}
 			desc =3D desc->more;
@@ -1044,6 +1103,9 @@ static void pte_list_remove(struct kvm *kvm, u64 *spt=
e,
=20
 		KVM_BUG_ON_DATA_CORRUPTION(true, kvm);
 	}
+
+out:
+	kvm_rmap_write_ulock(rmap_head, rmap_val);
 }
=20
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -1058,17 +1120,19 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 				   struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc, *next;
+	unsigned long rmap_val;
 	int i;
=20
-	if (!rmap_head->val)
+	rmap_val =3D kvm_rmap_write_lock(rmap_head);
+	if (!rmap_val)
 		return false;
=20
-	if (!(rmap_head->val & 1)) {
-		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
+	if (!(rmap_val & KVM_RMAP_MANY)) {
+		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_val);
 		goto out;
 	}
=20
-	desc =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	desc =3D (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
=20
 	for (; desc; desc =3D next) {
 		for (i =3D 0; i < desc->spte_count; i++)
@@ -1078,20 +1142,21 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	}
 out:
 	/* rmap_head is meaningless now, remember to reset it */
-	rmap_head->val =3D 0;
+	kvm_rmap_write_ulock(rmap_head, 0);
 	return true;
 }
=20
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
+	unsigned long rmap_val =3D READ_ONCE(rmap_head->val) & ~KVM_RMAP_LOCKED;
 	struct pte_list_desc *desc;
=20
-	if (!rmap_head->val)
+	if (!rmap_val)
 		return 0;
-	else if (!(rmap_head->val & 1))
+	else if (!(rmap_val & KVM_RMAP_MANY))
 		return 1;
=20
-	desc =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	desc =3D (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	return desc->tail_count + desc->spte_count;
 }
=20
@@ -1134,6 +1199,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
  */
 struct rmap_iterator {
 	/* private fields */
+	struct rmap_head *head;
 	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
 	int pos;			/* index of the sptep */
 };
@@ -1148,18 +1214,19 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
+	unsigned long rmap_val =3D READ_ONCE(rmap_head->val) & ~KVM_RMAP_LOCKED;
 	u64 *sptep;
=20
-	if (!rmap_head->val)
+	if (!rmap_val)
 		return NULL;
=20
-	if (!(rmap_head->val & 1)) {
+	if (!(rmap_val & KVM_RMAP_MANY)) {
 		iter->desc =3D NULL;
-		sptep =3D (u64 *)rmap_head->val;
+		sptep =3D (u64 *)rmap_val;
 		goto out;
 	}
=20
-	iter->desc =3D (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	iter->desc =3D (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	iter->pos =3D 0;
 	sptep =3D iter->desc->sptes[iter->pos];
 out:
@@ -1553,6 +1620,32 @@ static __always_inline bool kvm_handle_gfn_range(str=
uct kvm *kvm,
 	return ret;
 }
=20
+static __always_inline bool kvm_handle_gfn_range_lockless(struct kvm *kvm,
+							  struct kvm_gfn_range *range,
+							  rmap_handler_t handler)
+{
+	struct kvm_rmap_head *rmap_head;
+	unsigned long rmap_val;
+	bool ret =3D false;
+	gfn_t gfn;
+	int level;
+
+	for (gfn =3D range->start; gfn < range->end; gfn++) {
+		for (level =3D PG_LEVEL_4K; level <=3D KVM_MAX_HUGEPAGE_LEVEL; level++) =
{
+			rmap_head =3D gfn_to_rmap(gfn, level, range->slot);
+			rmap_val =3D kvm_rmap_read_lock(rmap_head);
+
+			if (rmap_val)
+				ret |=3D handler(kvm, rmap_head, range->slot, gfn, level);
+
+			kvm_rmap_read_unlock(rmap_head, rmap_val);
+		}
+	}
+
+	return ret;
+}
+
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush =3D false;

base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
--=20

