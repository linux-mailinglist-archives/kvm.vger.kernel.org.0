Return-Path: <kvm+bounces-8816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E5F856D01
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1705F1C23C36
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545FB18E02;
	Thu, 15 Feb 2024 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qqfk8Pod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F29134721
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708022731; cv=none; b=litC1F0b33/5LpcafMYtcG/8rDnKOmUikL26VR0O6QBzWvOHaTwyGUfzgRv/EYLwjJG8MIe0qW3XvpobJphTI9c99Z2KkQUAOU4ff6um3gGe4a9R61mWzTBlYqjeL8NptdBygGzlkMcSyc52+1AHjM2o+V58imZ9obnwxPbo0Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708022731; c=relaxed/simple;
	bh=UOeiFxBa6qkD5GL0C7Hexl1Pj7GUKu+u7H599BzMonQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r7oKpi17KgKMycjb7TdYFDb46leunte7UIuGj59A+enLYJTg9SF4X8Ak9vLFe30wGw9tcTQnPvS4LjYc5OdyUbY+dP/NaAo0a8FD8a5/qfd7ncd56JrbKkRFXOF33ECHL97ni0F0ODtqLABYeUk0H+wdUpa1n3w6HcJv9oQ07kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qqfk8Pod; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso536981276.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708022729; x=1708627529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=es2Z8u6824g77CxfRGV/9UPwzp6tSbCJdwnZIQFRqkQ=;
        b=Qqfk8Podgz1i60TAcI8G+9q5bijlyK+JU6d41/AzQBG9EfrA/N9X8nkel4XcknAeGp
         iit6O42Kx5X3NV7qr8Iht55mBHE2FWIqpJo03jlQk35pTWL2XaduTC1WQlvUf3+L/Qoj
         3QQUmkeLw33gu37uBS54ihJvmRrflVD3xsCBLmOoR9AIm9VXw9zZ//FtsKzJ3uNkEFyB
         F41mQ5igbxDQiTv3ZnKQhmxEYAvvhHaOkbtFDC9TJOWahn6GxGM1Jh1MVjOVPF1WhkZS
         PJ7YNGEBcd7vOAUDug3F6y7TYLpcQziMQGSCpufO9lfHtGMGz/Cn7KvtAxpBX1UoWG2j
         6zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708022729; x=1708627529;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=es2Z8u6824g77CxfRGV/9UPwzp6tSbCJdwnZIQFRqkQ=;
        b=o+eKRrmD9Fnta7n9z/wOl6gBqPhh83eJAO2UGVC+6fqtw3/wTT8cGpFbWr6n09/Bz/
         Jl2YUSLNAdGmfK8NG/OsMMFym0LPHB1m/1HveLAs4XL8V7lTEn/HjM6lh4bqFIst8y1w
         NWlQz4IriCLBMPRZqqlNWv/cXhymFsZkxZ9cu+IG0KeMr50ycBu04WmPv2AssYEPvnrM
         +qKeT5hdrG0o+u2UKBX21dLoBiHwP0/HppVxunPMCDh5jfzxJsHntV9Q3GDQIIDXpEg1
         ooeo3BVRxToqvPucjIz4viHRCU6QUkODRmP9XiQgV/J9t7sVC93VPOZXByw+vUJNLl2p
         Wu9w==
X-Forwarded-Encrypted: i=1; AJvYcCWgUP7LuSbrbyzG2OL5KWtxJKID8d/ra/EvKD0Cba2WzEP8Kp6QRbq6zqhtr8TdjCSsFV1vL21I3nBbRAxuwwyx9hDU
X-Gm-Message-State: AOJu0YzzlhXnJS6F5M+1dJmsYjbgx/fQMyU0jnTpL7JUJCP7ea9CPPHg
	Ln0210mjHRpuYTA5/z3z6tEG+P3mveYng6VnGqAJOd7XtMQjJ2dEYfOuMQPa/f2kM/kEtZxYLHS
	5IQ==
X-Google-Smtp-Source: AGHT+IE7n09VM6PDbu4AAFi/LoNJGkG79DodiNLPnLaY+HtysoZAZhU/auqUHuRtOKX8nI9xHjPD3v/5T7s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:eb07:0:b0:dc6:b7c2:176e with SMTP id
 d7-20020a25eb07000000b00dc6b7c2176emr1071480ybs.4.1708022728842; Thu, 15 Feb
 2024 10:45:28 -0800 (PST)
Date: Thu, 15 Feb 2024 10:45:27 -0800
In-Reply-To: <CALzav=c0MFB7UG7yaXB3bAFampYO_xN=5Pjao6La55wy4cwjSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-2-seanjc@google.com>
 <CALzav=c0MFB7UG7yaXB3bAFampYO_xN=5Pjao6La55wy4cwjSw@mail.gmail.com>
Message-ID: <Zc5bx4p6z8e3CmKK@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Mark target gfn of emulated atomic
 instruction as dirty
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pasha Tatashin <tatashin@google.com>, Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024, David Matlack wrote:
> On Wed, Feb 14, 2024 at 5:00=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > When emulating an atomic access on behalf of the guest, mark the target
> > gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
> > fixes a bug where KVM effectively corrupts guest memory during live
> > migration by writing to guest memory without informing userspace that t=
he
> > page is dirty.
> >
> > Marking the page dirty got unintentionally dropped when KVM's emulated
> > CMPXCHG was converted to do a user access.  Before that, KVM explicitly
> > mapped the guest page into kernel memory, and marked the page dirty dur=
ing
> > the unmap phase.
> >
> > Mark the page dirty even if the CMPXCHG fails, as the old data is writt=
en
> > back on failure, i.e. the page is still written.  The value written is
> > guaranteed to be the same because the operation is atomic, but KVM's AB=
I
> > is that all writes are dirty logged regardless of the value written.  A=
nd
> > more importantly, that's what KVM did before the buggy commit.
> >
> > Huge kudos to the folks on the Cc list (and many others), who did all t=
he
> > actual work of triaging and debugging.
> >
> > Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate ato=
mic accesses")
>=20
> I'm only half serious but... Should we just revert this commit?

No.

> This commit claims that kvm_vcpu_map() is unsafe because it can race
> with mremap(). But there are many other places where KVM uses
> kvm_vcpu_map() (e.g. nested VMX). It seems like KVM is just not
> compatible with mremap() until we address all the users of
> kvm_vcpu_map(). Patching _just_ emulator_cmpxchg_emulated() seems
> silly but maybe I'm missing some context on what led to commit
> 1c2361f667f3 being written.

The short version is that it's a rather trivial vector for userspace to tri=
gger
UAF.  E.g. map non-refcounted memory into a guest and then unmap the memory=
.

We tried to fix the nVMX usage, but that proved to be impractical[1].  We h=
aven't
forced the issue because it's not obvious that there's meaningful exposure =
in
practice, e.g. unless userspace is hiding regular memory from the kernel *a=
nd*
oversubscribing VMs, a benign userspace won't be affected.  But at the same=
 time,
we don't have high confidence that the unsafe behavior can't be exploited i=
n
practice.

What I am pushing for now is an off-by-default module param to let userspac=
e
opt-in to unsafe mappings such as these[2].  Because if KVM starts allowing
non-refcounted struct page memory, the ability to exploit these flaws skyro=
ckets.
(Though this reminds me that I need to take another look at whether or not =
allowing
non-refcounted struct page memory is actually necessary).

[1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com
[2] https://lore.kernel.org/all/20230911021637.1941096-4-stevensd@google.co=
m

> kvm_vcpu_map/unmap() might not be the best interface, but it serves as
> a common choke-point for mapping guest memory to access in KVM. This
> is helpful for avoiding missed dirty logging updates (obviously) and
> will be even more helpful if we add support for freezing guest memory
> and "KVM Userfault" (as discussed in the 1/3 PUCK). I think we all
> agree we should do more of this (common choke points), not less. If
> there's a usecase for mremap()ing guest memory, we should make
> kvm_vcpu_map() play nice with mmu_notifiers.

I agree, but KVM needs to __try_cmpxchg_user() use anyways, when updating g=
uest
A/D bits in FNAME(update_accessed_dirty_bits)().  And that one we *definite=
ly*
don't want to revert; see commit 2a8859f373b0 ("KVM: x86/mmu: do compare-an=
d-exchange
of gPTE via the user address") for details on how broken the previous code =
was.

In other words, reverting to kvm_vcpu_{un,}map() *probably* isn't wildly un=
safe,
but it also doesn't really buy us anything, and long term we have line of s=
ight
to closing the holes for good.  And unlike the nVMX code, where it's reason=
able
for KVM to disallow using non-refcounted memory for VMCS pages, disallowing=
 such
memory for emulated atomic accesses is less reasonable.

Rather than revert, to make this more robust in the longer term, we can add=
 a
wrapper in KVM to mark the gfn dirty.  I didn't do it here because I was hu=
stling
to get this minimal fix posted.

E.g.

--
Subject: [PATCH] KVM: x86: Provide a wrapper for __try_cmpxchg_user() to ma=
rk
 the gfn dirty

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 arch/x86/kvm/x86.c             | 25 +++++++++----------------
 arch/x86/kvm/x86.h             | 19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 4d4e98fe4f35..a8123406fe99 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -246,11 +246,11 @@ static int FNAME(update_accessed_dirty_bits)(struct k=
vm_vcpu *vcpu,
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
=20
-		ret =3D __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
+		ret =3D kvm_try_cmpxchg_user(ptep_user, &orig_pte, pte, fault,
+					   vcpu, table_gfn);
 		if (ret)
 			return ret;
=20
-		kvm_vcpu_mark_page_dirty(vcpu, table_gfn);
 		walker->ptes[level - 1] =3D pte;
 	}
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ec9781d6122..bedb51fbbad3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7946,8 +7946,9 @@ static int emulator_write_emulated(struct x86_emulate=
_ctxt *ctxt,
 				   exception, &write_emultor);
 }
=20
-#define emulator_try_cmpxchg_user(t, ptr, old, new) \
-	(__try_cmpxchg_user((t __user *)(ptr), (t *)(old), *(t *)(new), efault ##=
 t))
+#define emulator_try_cmpxchg_user(t, ptr, old, new, vcpu, gfn)		  \
+	(kvm_try_cmpxchg_user((t __user *)(ptr), (t *)(old), *(t *)(new), \
+			      efault ## t, vcpu, gfn))
=20
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
@@ -7960,6 +7961,7 @@ static int emulator_cmpxchg_emulated(struct x86_emula=
te_ctxt *ctxt,
 	u64 page_line_mask;
 	unsigned long hva;
 	gpa_t gpa;
+	gfn_t gfn;
 	int r;
=20
 	/* guests cmpxchg8b have to be emulated atomically */
@@ -7990,18 +7992,19 @@ static int emulator_cmpxchg_emulated(struct x86_emu=
late_ctxt *ctxt,
=20
 	hva +=3D offset_in_page(gpa);
=20
+	gfn =3D gpa_to_gfn(gpa);
 	switch (bytes) {
 	case 1:
-		r =3D emulator_try_cmpxchg_user(u8, hva, old, new);
+		r =3D emulator_try_cmpxchg_user(u8, hva, old, new, vcpu, gfn);
 		break;
 	case 2:
-		r =3D emulator_try_cmpxchg_user(u16, hva, old, new);
+		r =3D emulator_try_cmpxchg_user(u16, hva, old, new, vcpu, gfn);
 		break;
 	case 4:
-		r =3D emulator_try_cmpxchg_user(u32, hva, old, new);
+		r =3D emulator_try_cmpxchg_user(u32, hva, old, new, vcpu, gfn);
 		break;
 	case 8:
-		r =3D emulator_try_cmpxchg_user(u64, hva, old, new);
+		r =3D emulator_try_cmpxchg_user(u64, hva, old, new, vcpu, gfn);
 		break;
 	default:
 		BUG();
@@ -8009,16 +8012,6 @@ static int emulator_cmpxchg_emulated(struct x86_emul=
ate_ctxt *ctxt,
=20
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
-
-	/*
-	 * Mark the page dirty _before_ checking whether or not the CMPXCHG was
-	 * successful, as the old value is written back on failure.  Note, for
-	 * live migration, this is unnecessarily conservative as CMPXCHG writes
-	 * back the original value and the access is atomic, but KVM's ABI is
-	 * that all writes are dirty logged, regardless of the value written.
-	 */
-	kvm_vcpu_mark_page_dirty(vcpu, gpa_to_gfn(gpa));
-
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
=20
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..2fabc7cd7e39 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -290,6 +290,25 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm=
, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
=20
+
+
+/*
+ * Mark the page dirty even if the CMPXCHG fails (but didn't fault), as th=
e old
+ * old value is written back on failure.  Note, for live migration, this i=
s
+ * unnecessarily conservative as CMPXCHG writes back the original value an=
d the
+ * access is atomic, but KVM's ABI is that all writes are dirty logged,
+ * regardless of the value written.
+ */
+#define kvm_try_cmpxchg_user(ptr, oldp, nval, label, vcpu, gfn) \
+({								\
+	int ret;						\
+								\
+	ret =3D __try_cmpxchg_user(ptr, oldp, nval, label);	\
+	if (ret >=3D 0)						\
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);		\
+	ret;							\
+})
+
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc=
_eip);
=20
 u64 get_kvmclock_ns(struct kvm *kvm);

base-commit: 6769ea8da8a93ed4630f1ce64df6aafcaabfce64
--=20


