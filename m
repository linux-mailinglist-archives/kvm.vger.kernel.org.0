Return-Path: <kvm+bounces-19725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B186A9094BA
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 01:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CECC284186
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 23:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160BC18F2DD;
	Fri, 14 Jun 2024 23:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhpi91VK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9603188CB2
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718407078; cv=none; b=eZGKcg7SrgShwQq51MFk0AABU/YZqbJ1gw2zc41OXJ3eiGK1Zy0I81EeKk9U0uVSF5PU7yqXeVj4Uy+0/V1TGSgH6M7iX02KWL6ehUEhSZCkQar8IQSLHY4o9MT6LbaGs8JhrOa4S+qtclamCU+pKkHckrIco2AXSw49Yh2hakE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718407078; c=relaxed/simple;
	bh=GxPpqWMg7Qw+KH+laN3j9zDFH85/MQwodFiM32k6C2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gW97qYgrAkbU+Le1wpIVeSQBDsYEjjoxIfIf68JQt//dfn3rJurgB78f/HeaCa3bC52vMlWryemnFxM5OPWJC1YDbxW9fe5I5GssNj8MC7RS2mSmu97swnEuPiSEPlX7/wdnNHzstCyIl0IreuMf9z1o5Z9V6LXDAUJAQfRmG/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhpi91VK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-632e098ab42so14902787b3.3
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 16:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718407075; x=1719011875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Of1/APUBbAKdtL3qvNUh6RP4QfUxQKIPvJrZrNb83Wo=;
        b=dhpi91VKVtLPMDil8lDM9ArGzUKLclY1kMLyqvobzX8/mIUypu9q/xN/t5geniUpd9
         GeJfVCCvcmNpepqaHIj9eNR33v1n7rj/eHuJUnHp8w6IW+jDME0O0J/aCBNPLUBQ5aRL
         X9kut2yQ7/MgBfVRFSWlET5DjREnQkscvUC33CJQ4uJZUBFcEYan/MXDHijRi2aGMvLi
         EAs5UFMLj8AjYy6IXF5A2mJqx/vKxxYyuYgN9sPjfrIuVF1MZ3o5DvEfH/zhxU4EuX2Z
         1Xx7bXnwGiak48cmKzKeWV0Ocoh2E61VYkNZubOsBdBA0HvOy0wdTRjdnzph/Jtw4Jja
         Taew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718407075; x=1719011875;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Of1/APUBbAKdtL3qvNUh6RP4QfUxQKIPvJrZrNb83Wo=;
        b=thd6h/zwGvYDCjD8ds2XEVjAMexYmmEssIfco35L/tolL75PKXcqOKE1QRDye+mTDj
         WmnpQn7rs6ae/i0Ir4FMqpm/LnmSLj2Y7d+yvO/xkZmoE0Xj+SxIuX6MRYp9GpkVMUuT
         3hDdFhiWWrFB2imPNbxl6Cmgv8aDXeecgr87A83QVkMW9O/4bCUQBzX6B5HzQNM0Phqn
         huJXsjlSbI1SYIQ1BaNiDziU1NL4xW6wbLsCtozOo33H/AXbJ8KgfxvfAOkxSfCurkNf
         xHjO/6h9tvzxHqoSAqbVwVtgPY1565netvmmOdFmxNczNKFGnG6+ejDCybeiry06gy4k
         ai+A==
X-Forwarded-Encrypted: i=1; AJvYcCW93lmGANTKZQnV/4+JPe/ZQT5/TtKYxtJj4jYUjeBoTyzBRXqoC42sIOfxK9MGOny8aWIrF/QA15ggopfFsQ5DCq7n
X-Gm-Message-State: AOJu0YzK6dokb00ALnehyHcisnxPNdNyYMtCVwNPDkOCwaRRwuJ384Ip
	bOw9BdfP2CNPqBlIAaZ6J7pJCSpuC5BuDTFcQvMFWmXX8IMwsndaFusrvv1XSqAsKsYeBjRYpEr
	S9A==
X-Google-Smtp-Source: AGHT+IFf04V+NzFpQ2I3NWK+rQ7QUB1fuzeDCHCZBIuJOjTEyb5oX0HI/aAQHZ5FG+/pVHLQj8M1yQSGuys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:700e:b0:627:a962:4252 with SMTP id
 00721157ae682-63224613c12mr8916887b3.7.1718407074918; Fri, 14 Jun 2024
 16:17:54 -0700 (PDT)
Date: Fri, 14 Jun 2024 16:17:53 -0700
In-Reply-To: <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
Message-ID: <ZmzPoW7K5GIitQ8B@google.com>
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

On Fri, Jun 14, 2024, James Houghton wrote:
> On Fri, Jun 14, 2024 at 9:13=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Jun 13, 2024, James Houghton wrote:
> > > On Tue, Jun 11, 2024 at 5:34=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > A flag would also avoid an indirect call and thus a RETPOLINE when =
CONFIG_RETPOLINE=3Dy,
> > > > i.e. would be a minor optimization when KVM doesn't suppport fast a=
ging.  But that's
> > > > probably a pretty unlikely combination, so it's probably not a vali=
d argument.
> > > >
> > > > So, I guess I don't have a strong opinion?
> > >
> > > (Sorry for the somewhat delayed response... spent some time actually
> > > writing what this would look like.)
> > >
> > > I see what you mean, thanks! So has_fast_aging might be set by KVM if
> > > the architecture sets a Kconfig saying that it understands the concep=
t
> > > of fast aging, basically what the presence of this v5's
> > > test_clear_young_fast_only() indicates.
> >
> > It would need to be a runtime setting, because KVM x86-64 with tdp_mmu_=
enabled=3Dfalse
> > doesn't support fast aging (uses the shadow MMU even for TDP).
>=20
> I see. I'm not sure if it makes sense to put this in `ops` as you
> originally had it then (it seems like a bit of a pain anyway). I could
> just make it a member of `struct mmu_notifier` itself.

Ah, right, because the ops are const.  Yeah, losing the const just to set a=
 flag
would be unfortunate.

> > > So just to be clear, for test_young(), I intend to have a patch in v6
> > > to elide the shadow MMU check if the TDP MMU indicates Accessed. Seem=
s
> > > like a pure win; no reason not to include it if we're making logic
> > > changes here anyway.
> >
> > I don't think that's correct.  The initial fast_only=3Dfalse aging shou=
ld process
> > shadow MMUs (nested TDP) and TDP MMUs, otherwise a future fast_only=3Df=
alse would
> > get a false positive on young due to failing to clear the Accessed bit =
in the
> > shadow MMU.  E.g. if page X is accessed by both L1 and L2, then aged, a=
nd never
> > accessed again, the Accessed bit would still be set in the page tables =
for L2.
>=20
> For clear_young(fast_only=3Dfalse), yeah we need to check and clear
> Accessed for both MMUs. But for test_young(fast_only=3Dfalse), I don't
> see why we couldn't just return early if the TDP MMU reports young.

Ooh, good point.

> > > Oh, yeah, that's a lot more intelligent than what I had. I think I
> > > fully understand your suggestion; I guess we'll see in v6. :)
> > >
> > > I wonder if this still makes sense if whether or not an MMU is "fast"
> > > is determined by how contended some lock(s) are at the time.
> >
> > No.  Just because a lock wasn't contended on the initial aging doesn't =
mean it
> > won't be contended on the next round.  E.g. when using KVM x86's shadow=
 MMU, which
> > takes mmu_lock for write for all operations, an aging operation could g=
et lucky
> > and sneak in while mmu_lock happened to be free, but then get stuck beh=
ind a large
> > queue of operations.
> >
> > The fast-ness needs to be predictable and all but guaranteed, i.e. lock=
less or in
> > an MMU that takes mmu_lock for read in all but the most rare paths.
>=20
> Aging and look-around themselves only use the fast-only notifiers, so
> they won't ever wait on a lock (well... provided KVM is written like
> that, which I think is a given).

Regarding aging, is that actually the behavior that we want?  I thought the=
 plan
is to have the initial test look at all MMUs, i.e. be potentially slow, but=
 only
do the lookaround if it can be fast.  IIUC, that was Yu's intent (and peeki=
ng back
at v2, that is indeed the case, unless I'm misreading the code).

If KVM _never_ consults shadow (nested TDP) MMUs, then a VM running an L2 w=
ill
end up with hot pages (used by L2) swapped out.

Or are you saying that the "test" could be slow, but not "clear"?  That's a=
lso
suboptimal, because any pages accessed by L2 will always appear hot.

> should_look_around() will use the slow notifier because it (despite its n=
ame)
> is responsible for accurately determining if a page is young lest we evic=
t a
> young page.
>=20
> So in this case where "fast" means "lock not contended for now",

No.  In KVM, "fast" needs to be a property of the MMU, not a reflection of =
system
state at some random snapshot in time.

> I don't think it's necessarily wrong for MGLRU to attempt to find young
> pages, even if sometimes it will bail out because a lock is contended/hel=
d

lru_gen_look_around() skips lookaround if something else is waiting on the =
page
table lock, but that is a far cry from what KVM would be doing.  (a) the PT=
L is
already held, and (b) it is scoped precisely to the range being processed. =
 Not
looking around makes sense because there's a high probability of the PTEs i=
n
question being modified by a different task, i.e. of the look around being =
a
waste of time.

In KVM, mmu_lock is not yet held, so KVM would need to use try-lock to avoi=
d
waiting, and would need to bail from the middle of the aging walk if a diff=
erent
task contends mmu_lock.

I agree that's not "wrong", but in part because mmu_lock is scoped to the e=
ntire
VM, it risks ending up with semi-random, hard to debug behavior.  E.g. a us=
er
could see intermittent "failures" that come and go based on seemingly unrel=
ated
behavior in KVM.  And implementing the "bail" behavior in the shadow MMU wo=
uld
require non-trivial changes.

In other words, I would very strongly prefer that the shadow MMU be all or =
nothing,
i.e. is either part of look-around or isn't.  And if nested TDP doesn't fai=
r well
with MGLRU, then we (or whoever cares) can spend the time+effort to make it=
 work
with fast-aging.

Ooh!  Actually, after fiddling a bit to see how feasible fast-aging in the =
shadow
MMU would be, I'm pretty sure we can do straight there for nested TDP.  Or =
rather,
I suspect/hope we can get close enough for an initial merge, which would al=
low
aging_is_fast to be a property of the mmu_notifier, i.e. would simplify thi=
ngs
because KVM wouldn't need to communicate MMU_NOTIFY_WAS_FAST for each notif=
ication.

Walking KVM's rmaps requires mmu_lock because adding/removing rmap entries =
is done
in such a way that a lockless walk would be painfully complex.  But if ther=
e is
exactly _one_ rmap entry for a gfn, then slot->arch.rmap[...] points direct=
ly at
that one SPTE.  And with nested TDP, unless L1 is doing something uncommon,=
 e.g.
mapping the same page into multiple L2s, that overwhelming vast majority of=
 rmaps
have only one entry.  That's not the case for legacy shadow paging because =
kernels
almost always map a pfn using multiple virtual addresses, e.g. Linux's dire=
ct map
along with any userspace mappings.

E.g. with a QEMU+KVM setup running Linux as L2, in my setup, only one gfn h=
as
multiple rmap entries (IIRC, it's from QEMU remapping BIOS into low memory =
during
boot).

So, if we bifurcate aging behavior based on whether or not the TDP MMU is e=
nabled,
then whether or not aging is fast is constant (after KVM loads).  Rougly, t=
he KVM
side of things would be the below, plus a bunch of conversions to WRITE_ONC=
E() to
ensure a stable rmap value (KVM already plays nice with lockless accesses t=
o SPTEs,
thanks to the fast page fault path).

If KVM adds an rmap entry after the READ_ONCE(), then functionally all is s=
till
well because the original SPTE pointer is still valid.  If the rmap entry i=
s
removed, then KVM just needs to ensure the owning page table isn't freed.  =
That
could be done either with a cmpxchg() (KVM zaps leafs SPTE before freeing p=
age
tables, and the rmap stuff doesn't actually walk upper level entries), or b=
y
enhancing the shadow MMU's lockless walk logic to allow lockless walks from
non-vCPU tasks.

And in the (hopefully) unlikely scenario someone has a use case where L1 ma=
ps a
gfn into multiple L2s (or aliases in bizarre ways), then we can tackle maki=
ng the
nested TDP shadow MMU rmap walks always lockless.

E.g. again very roughly, if we went with the latter:

@@ -1629,22 +1629,45 @@ static void rmap_add(struct kvm_vcpu *vcpu, const s=
truct kvm_memory_slot *slot,
        __rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
 }
=20
+static __always_inline bool kvm_handle_gfn_range_lockless(struct kvm *kvm,
+                                                         struct kvm_gfn_ra=
nge *range,
+                                                         typedefme handler=
)
+{
+       gfn_t gfn;
+       int level;
+       u64 *spte;
+       bool ret;
+
+       walk_shadow_page_lockless_begin(???);
+
+       for (gfn =3D range->start; gfn < range->end; gfn++) {
+               for (level =3D PG_LEVEL_4K; level <=3D KVM_MAX_HUGEPAGE_LEV=
EL; level++) {
+                       spte =3D (void *)READ_ONCE(gfn_to_rmap(gfn, level, =
range->slot)->val);
+
+                       /* Skip the gfn if there are multiple SPTEs. */
+                       if ((unsigned long)spte & 1)
+                               continue;
+
+                       ret |=3D handler(spte);
+               }
+       }
+
+       walk_shadow_page_lockless_end(???);
+}
+
 static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
                         bool fast_only)
 {
        bool young =3D false;
=20
-       if (kvm_memslots_have_rmaps(kvm)) {
-               if (fast_only)
-                       return -1;
-
-               write_lock(&kvm->mmu_lock);
-               young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
-               write_unlock(&kvm->mmu_lock);
-       }
-
-       if (tdp_mmu_enabled)
+       if (tdp_mmu_enabled) {
                young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
+               young |=3D kvm_handle_gfn_range_lockless(kvm, range, kvm_ag=
e_rmap_fast);
+       } else if (!fast_only) {
+               write_lock(&kvm->mmu_lock);
+               young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+               write_unlock(&kvm->mmu_lock);
+       }
=20
        return (int)young;
 }

> for a few or even a majority of the pages. Not doing look-around is the s=
ame
> as doing look-around and finding that no pages are young.

No, because the former is deterministic and predictable, the latter is not.

> Anyway, I don't think this bit is really all that important unless we
> can demonstrate that KVM participating like this actually results in a
> measurable win.

Participating like what?  You've lost me a bit.  Are we talking past each o=
ther?

What I am saying is that we do this (note that this is slightly different t=
han
an earlier sketch; I botched the ordering of spin_is_contend() in that one,=
 and
didn't account for the page being young in the primary MMU).

	if (pte_young(ptep_get(pte)))
		young =3D 1 | MMU_NOTIFY_WAS_FAST;

        young |=3D ptep_clear_young_notify(vma, addr, pte);
        if (!young)
                return false;

        if (!(young & MMU_NOTIFY_WAS_FAST))
                return true;

        if (spin_is_contended(pvmw->ptl))
                return false;

        /* exclude special VMAs containing anon pages from COW */
        if (vma->vm_flags & VM_SPECIAL)
                return false;

