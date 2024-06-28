Return-Path: <kvm+bounces-20713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC4191C9A6
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 01:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE35D1C220E3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 23:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187BC84DE7;
	Fri, 28 Jun 2024 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TQrSwqNr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4AB81729
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719617978; cv=none; b=p2MTZFHuIuKnJMbS90Df3bPrkGeXyJIC1xOTv1DLNH/qgNLeHXh79IvN4DuWmZlJTuPpMhwJQdqUj7KvUMtZU5BrjEi0NcULIw4ZZdnG4OVvV5MlAanDIObHsGKCfl0a5RIQO4CRMT/O5dpf8fLHUgzoX5o4syuEcva5+u8jnY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719617978; c=relaxed/simple;
	bh=gFGn9wBfLc25cpluTcfGbu57LjjE9VgM7fY2JHTU37Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B6I9G6woSsHUQ5/+BzYBsp4xLsA9xrN2tXb23/ddadehJhkTzWcK7AdDNaNhlC6bupplwLBjLJyp6KvOTKrPtLh8mVDDPNIvcrjVERB6+80b0X0hwvkdJ4nuPqeSAqPhu+kIgF//tTAgCiJbJlve0KTSA4HuRBxrfaDe1Al8mB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TQrSwqNr; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-445022f78e1so66821cf.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 16:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719617975; x=1720222775; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ca0DA4OYtmu5vjHp6DDkTi8s1JKrMVKIGk5L1tKfRw=;
        b=TQrSwqNrZO6ZZgJTmflthhJBMpifN1qlw3aTE+ATunfiUgyaDIs5/BFBLBapg0jJmn
         /3OqgatXcn0WYH6KFj8tRoWxjD0alTUDuCJRkrPnAEnszTPtJPxKhcXr3DqgQIwome72
         Tu4Ee26whA9I5NH9pw7P4h1ir3tIb+KCkH8OMQBg+IEtQLWM44vdImtyQnNzmHSvKjAX
         Inag5Tf4LZvC+Pki5S1kWG1tAvr1JXNLoHtDmsnAKIeVD4aEptCqSyRzQKQdl+Y4lfpW
         oQrQHm9johYp5tWecVKGkqYxDXn2oIURF69UdDNjM9ONGj+zOwKyZOTuBovoNQ9PSYHy
         WDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719617975; x=1720222775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Ca0DA4OYtmu5vjHp6DDkTi8s1JKrMVKIGk5L1tKfRw=;
        b=XT2/rGoa4xHSCG6Af82f6UBiFACEYOGWZr5XZgt6C1sB5LRkpZI33oD8c8uP2YyCJo
         4WcoTVMSqIhE+upCJSIv3b0u1cFDmSyqcmTP9NovCj6a0Fpl9IxLRI19LCH8048hCXXp
         8sfBDFER4Lui1xP5+0jBVdT3PXjMLimlKMYxvYAL56tI0/Y49sTSQXMtPFboyWvheslL
         I9r/ObSqQHNTPJqhAtKUhmUozJJfZsOpRMl6dQgnQ6aVP170MkyhG8XPv8Y3RgXeklTK
         gH956L9N4JUkMMVboLrN34iEvSfKuk2Y3olhV2oR8/cCDzGKFCOGreMpssQodAuJicYT
         ityQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6d20jj2ZGNdX+GGhV89o0U3rmdfKC7vOW/ekfa41XJgPiBz14WKwuqORVBpW2zfGPUArZKrl1Q7rJQ/C0cNL1v9P+
X-Gm-Message-State: AOJu0Yy9cYgcFxf0XIghy9P/mdvV35YOEVoFFyIRuL3ifKcOxn8DQAUq
	M4fmI2R78Mi165TP1vzqkEwD3beOuZ3huLKCjYqzrX52Hvp0E9zYlVEj+S8aBJZkz1o4f2moMpo
	2kgC5tmo3pOrIRkspl0BAHKPJUi3EjVpxOuDB
X-Google-Smtp-Source: AGHT+IHKkpUk+WD6bTey5Z/OEgEg1zX4EupEIZF89/wKvvk+qrClQWspsS+52Ps7BfIHqkzp7QfwKpYEDXC+Usvf3S0=
X-Received: by 2002:a05:622a:4709:b0:444:e9b9:708f with SMTP id
 d75a77b69052e-4465df8c326mr435621cf.21.1719617974492; Fri, 28 Jun 2024
 16:39:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com>
In-Reply-To: <ZnCCZ5gQnA3zMQtv@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 28 Jun 2024 16:38:57 -0700
Message-ID: <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: multipart/mixed; boundary="00000000000085f40d061bfbc2cf"

--00000000000085f40d061bfbc2cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Jun 17, 2024, James Houghton wrote:
> > On Fri, Jun 14, 2024 at 4:17=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > Ooh!  Actually, after fiddling a bit to see how feasible fast-aging i=
n the shadow
> > > MMU would be, I'm pretty sure we can do straight there for nested TDP=
.  Or rather,
> > > I suspect/hope we can get close enough for an initial merge, which wo=
uld allow
> > > aging_is_fast to be a property of the mmu_notifier, i.e. would simpli=
fy things
> > > because KVM wouldn't need to communicate MMU_NOTIFY_WAS_FAST for each=
 notification.
> > >
> > > Walking KVM's rmaps requires mmu_lock because adding/removing rmap en=
tries is done
> > > in such a way that a lockless walk would be painfully complex.  But i=
f there is
> > > exactly _one_ rmap entry for a gfn, then slot->arch.rmap[...] points =
directly at
> > > that one SPTE.  And with nested TDP, unless L1 is doing something unc=
ommon, e.g.
> > > mapping the same page into multiple L2s, that overwhelming vast major=
ity of rmaps
> > > have only one entry.  That's not the case for legacy shadow paging be=
cause kernels
> > > almost always map a pfn using multiple virtual addresses, e.g. Linux'=
s direct map
> > > along with any userspace mappings.

Hi Sean, sorry for taking so long to get back to you.

So just to make sure I have this right: if L1 is using TDP, the gfns
in L0 will usually only be mapped by a single spte. If L1 is not using
TDP, then all bets are off. Is that true?

If that is true, given that we don't really have control over whether
or not L1 decides to use TDP, the lockless shadow MMU walk will work,
but, if L1 is not using TDP, it will often return false negatives
(says "old" for an actually-young gfn). So then I don't really
understand conditioning the lockless shadow MMU walk on us (L0) using
the TDP MMU[1]. We care about L1, right?

(Maybe you're saying that, when the TDP MMU is enabled, the only cases
where the shadow MMU is used are cases where gfns are practically
always mapped by a single shadow PTE. This isn't how I understood your
mail, but this is what your hack-a-patch[1] makes me think.)

[1] https://lore.kernel.org/linux-mm/ZmzPoW7K5GIitQ8B@google.com/

>
> ...
>
> > Hmm, interesting. I need to spend a little bit more time digesting this=
.
> >
> > Would you like to see this included in v6? (It'd be nice to avoid the
> > WAS_FAST stuff....) Should we leave it for a later series? I haven't
> > formed my own opinion yet.
>
> I would say it depends on the viability and complexity of my idea.  E.g. =
if it
> pans out more or less like my rough sketch, then it's probably worth taki=
ng on
> the extra code+complexity in KVM to avoid the whole WAS_FAST goo.
>
> Note, if we do go this route, the implementation would need to be tweaked=
 to
> handle the difference in behavior between aging and last-minute checks fo=
r eviction,
> which I obviously didn't understand when I threw together that hack-a-pat=
ch.
>
> I need to think more about how best to handle that though, e.g. skipping =
GFNs with
> multiple mappings is probably the worst possible behavior, as we'd risk e=
victing
> hot pages.  But falling back to taking mmu_lock for write isn't all that =
desirable
> either.

I think falling back to the write lock is more desirable than evicting
a young page.

I've attached what I think could work, a diff on top of this series.
It builds at least. It uses rcu_read_lock/unlock() for
walk_shadow_page_lockless_begin/end(NULL), and it puts a
synchronize_rcu() in kvm_mmu_commit_zap_page().

It doesn't get rid of the WAS_FAST things because it doesn't do
exactly what [1] does. It basically makes three calls now: lockless
TDP MMU, lockless shadow MMU, locked shadow MMU. It only calls the
locked shadow MMU bits if the lockless bits say !young (instead of
being conditioned on tdp_mmu_enabled). My choice is definitely
questionable for the clear path.

Thanks!

--00000000000085f40d061bfbc2cf
Content-Type: text/x-patch; charset="US-ASCII"; name="shadow-mmu-patch.diff"
Content-Disposition: attachment; filename="shadow-mmu-patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lxzbr9zx0>
X-Attachment-Id: f_lxzbr9zx0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21t
dS5jCmluZGV4IDg0MWNlZTNmMzQ2ZC4uNTQ4ZDFlNDgwZGU5IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vbW11L21tdS5jCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMKQEAgLTY0MCw2ICs2
NDAsMzcgQEAgc3RhdGljIGJvb2wgbW11X3NwdGVfYWdlKHU2NCAqc3B0ZXApCiAJcmV0dXJuIHRy
dWU7CiB9CiAKKy8qCisgKiBTaW1pbGFyIHRvIG1tdV9zcHRlX2FnZSgpLCBidXQgdGhpcyBvbmUg
c2hvdWxkIGJlIHVzZWQgZm9yIGxvY2tsZXNzIHNoYWRvdworICogcGFnZSB0YWJsZSB3YWxrcy4K
KyAqLworc3RhdGljIGJvb2wgbW11X3NwdGVfYWdlX2xvY2tsZXNzKHU2NCAqc3B0ZXApCit7CisJ
dTY0IG9sZF9zcHRlID0gbW11X3NwdGVfZ2V0X2xvY2tsZXNzKHNwdGVwKTsKKwl1NjQgbmV3X3Nw
dGU7CisKKwlpZiAoIWlzX2FjY2Vzc2VkX3NwdGUob2xkX3NwdGUpKQorCQlyZXR1cm4gZmFsc2U7
CisKKwlpZiAoc3B0ZV9hZF9lbmFibGVkKG9sZF9zcHRlKSkKKwkJY2xlYXJfYml0KChmZnMoc2hh
ZG93X2FjY2Vzc2VkX21hc2spIC0gMSksCisJCQkgICh1bnNpZ25lZCBsb25nICopc3B0ZXApOwor
CWVsc2UgeworCQluZXdfc3B0ZSA9IG1hcmtfc3B0ZV9mb3JfYWNjZXNzX3RyYWNrKG9sZF9zcHRl
KTsKKwkJaWYgKCF0cnlfY21weGNoZzY0KHNwdGVwLCAmb2xkX3NwdGUsIG5ld19zcHRlKSkKKwkJ
CS8qCisJCQkgKiBJZiB0aGUgc3B0ZSBjaGFuZ2VkLCBpdCdzIGxpa2VseSB0aGF0IHRoZSBnZm4K
KwkJCSAqIGlzIHlvdW5nLgorCQkJICovCisJCQlyZXR1cm4gdHJ1ZTsKKworCQlpZiAoaXNfd3Jp
dGFibGVfcHRlKG9sZF9zcHRlKSkKKwkJCWt2bV9zZXRfcGZuX2RpcnR5KHNwdGVfdG9fcGZuKG9s
ZF9zcHRlKSk7CisJfQorCisJcmV0dXJuIHRydWU7Cit9CisKIHN0YXRpYyBpbmxpbmUgYm9vbCBp
c190ZHBfbW11X2FjdGl2ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiB7CiAJcmV0dXJuIHRkcF9t
bXVfZW5hYmxlZCAmJiB2Y3B1LT5hcmNoLm1tdS0+cm9vdF9yb2xlLmRpcmVjdDsKQEAgLTY0Nyw2
ICs2NzgsMTEgQEAgc3RhdGljIGlubGluZSBib29sIGlzX3RkcF9tbXVfYWN0aXZlKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkKIAogc3RhdGljIHZvaWQgd2Fsa19zaGFkb3dfcGFnZV9sb2NrbGVzc19i
ZWdpbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiB7CisJaWYgKCF2Y3B1KSB7CisJCXJjdV9yZWFk
X2xvY2soKTsKKwkJcmV0dXJuOworCX0KKwogCWlmIChpc190ZHBfbW11X2FjdGl2ZSh2Y3B1KSkg
ewogCQlrdm1fdGRwX21tdV93YWxrX2xvY2tsZXNzX2JlZ2luKCk7CiAJfSBlbHNlIHsKQEAgLTY2
Niw2ICs3MDIsMTEgQEAgc3RhdGljIHZvaWQgd2Fsa19zaGFkb3dfcGFnZV9sb2NrbGVzc19iZWdp
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAKIHN0YXRpYyB2b2lkIHdhbGtfc2hhZG93X3BhZ2Vf
bG9ja2xlc3NfZW5kKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKKwlpZiAoIXZjcHUpIHsKKwkJ
cmN1X3JlYWRfdW5sb2NrKCk7CisJCXJldHVybjsKKwl9CisKIAlpZiAoaXNfdGRwX21tdV9hY3Rp
dmUodmNwdSkpIHsKIAkJa3ZtX3RkcF9tbXVfd2Fsa19sb2NrbGVzc19lbmQoKTsKIAl9IGVsc2Ug
ewpAQCAtOTQ5LDE0ICs5OTAsMTQgQEAgc3RhdGljIGludCBwdGVfbGlzdF9hZGQoc3RydWN0IGt2
bV9tbXVfbWVtb3J5X2NhY2hlICpjYWNoZSwgdTY0ICpzcHRlLAogCWludCBjb3VudCA9IDA7CiAK
IAlpZiAoIXJtYXBfaGVhZC0+dmFsKSB7Ci0JCXJtYXBfaGVhZC0+dmFsID0gKHVuc2lnbmVkIGxv
bmcpc3B0ZTsKKwkJV1JJVEVfT05DRSgmcm1hcF9oZWFkLT52YWwsICh1bnNpZ25lZCBsb25nKXNw
dGUpOwogCX0gZWxzZSBpZiAoIShybWFwX2hlYWQtPnZhbCAmIDEpKSB7CiAJCWRlc2MgPSBrdm1f
bW11X21lbW9yeV9jYWNoZV9hbGxvYyhjYWNoZSk7CiAJCWRlc2MtPnNwdGVzWzBdID0gKHU2NCAq
KXJtYXBfaGVhZC0+dmFsOwogCQlkZXNjLT5zcHRlc1sxXSA9IHNwdGU7CiAJCWRlc2MtPnNwdGVf
Y291bnQgPSAyOwogCQlkZXNjLT50YWlsX2NvdW50ID0gMDsKLQkJcm1hcF9oZWFkLT52YWwgPSAo
dW5zaWduZWQgbG9uZylkZXNjIHwgMTsKKwkJV1JJVEVfT05DRSgmcm1hcF9oZWFkLT52YWwsICh1
bnNpZ25lZCBsb25nKWRlc2MgfCAxKTsKIAkJKytjb3VudDsKIAl9IGVsc2UgewogCQlkZXNjID0g
KHN0cnVjdCBwdGVfbGlzdF9kZXNjICopKHJtYXBfaGVhZC0+dmFsICYgfjF1bCk7CkBAIC05NzEs
NyArMTAxMiw3IEBAIHN0YXRpYyBpbnQgcHRlX2xpc3RfYWRkKHN0cnVjdCBrdm1fbW11X21lbW9y
eV9jYWNoZSAqY2FjaGUsIHU2NCAqc3B0ZSwKIAkJCWRlc2MtPm1vcmUgPSAoc3RydWN0IHB0ZV9s
aXN0X2Rlc2MgKikocm1hcF9oZWFkLT52YWwgJiB+MXVsKTsKIAkJCWRlc2MtPnNwdGVfY291bnQg
PSAwOwogCQkJZGVzYy0+dGFpbF9jb3VudCA9IGNvdW50OwotCQkJcm1hcF9oZWFkLT52YWwgPSAo
dW5zaWduZWQgbG9uZylkZXNjIHwgMTsKKwkJCVdSSVRFX09OQ0UoJnJtYXBfaGVhZC0+dmFsLCAo
dW5zaWduZWQgbG9uZylkZXNjIHwgMSk7CiAJCX0KIAkJZGVzYy0+c3B0ZXNbZGVzYy0+c3B0ZV9j
b3VudCsrXSA9IHNwdGU7CiAJfQpAQCAtMTAwOSw5ICsxMDUwLDEwIEBAIHN0YXRpYyB2b2lkIHB0
ZV9saXN0X2Rlc2NfcmVtb3ZlX2VudHJ5KHN0cnVjdCBrdm0gKmt2bSwKIAkgKiBoZWFkIGF0IHRo
ZSBuZXh0IGRlc2NyaXB0b3IsIGkuZS4gdGhlIG5ldyBoZWFkLgogCSAqLwogCWlmICghaGVhZF9k
ZXNjLT5tb3JlKQotCQlybWFwX2hlYWQtPnZhbCA9IDA7CisJCVdSSVRFX09OQ0UoJnJtYXBfaGVh
ZC0+dmFsLCAwKTsKIAllbHNlCi0JCXJtYXBfaGVhZC0+dmFsID0gKHVuc2lnbmVkIGxvbmcpaGVh
ZF9kZXNjLT5tb3JlIHwgMTsKKwkJV1JJVEVfT05DRSgmcm1hcF9oZWFkLT52YWwsCisJCQkJKHVu
c2lnbmVkIGxvbmcpaGVhZF9kZXNjLT5tb3JlIHwgMSk7CiAJbW11X2ZyZWVfcHRlX2xpc3RfZGVz
YyhoZWFkX2Rlc2MpOwogfQogCkBAIC0xMDI4LDcgKzEwNzAsNyBAQCBzdGF0aWMgdm9pZCBwdGVf
bGlzdF9yZW1vdmUoc3RydWN0IGt2bSAqa3ZtLCB1NjQgKnNwdGUsCiAJCWlmIChLVk1fQlVHX09O
X0RBVEFfQ09SUlVQVElPTigodTY0ICopcm1hcF9oZWFkLT52YWwgIT0gc3B0ZSwga3ZtKSkKIAkJ
CXJldHVybjsKIAotCQlybWFwX2hlYWQtPnZhbCA9IDA7CisJCVdSSVRFX09OQ0UoJnJtYXBfaGVh
ZC0+dmFsLCAwKTsKIAl9IGVsc2UgewogCQlkZXNjID0gKHN0cnVjdCBwdGVfbGlzdF9kZXNjICop
KHJtYXBfaGVhZC0+dmFsICYgfjF1bCk7CiAJCXdoaWxlIChkZXNjKSB7CkBAIC0xMDc4LDcgKzEx
MjAsNyBAQCBzdGF0aWMgYm9vbCBrdm1femFwX2FsbF9ybWFwX3NwdGVzKHN0cnVjdCBrdm0gKmt2
bSwKIAl9CiBvdXQ6CiAJLyogcm1hcF9oZWFkIGlzIG1lYW5pbmdsZXNzIG5vdywgcmVtZW1iZXIg
dG8gcmVzZXQgaXQgKi8KLQlybWFwX2hlYWQtPnZhbCA9IDA7CisJV1JJVEVfT05DRSgmcm1hcF9o
ZWFkLT52YWwsIDApOwogCXJldHVybiB0cnVlOwogfQogCkBAIC0xNjM0LDE3ICsxNjc2LDY0IEBA
IHN0YXRpYyBib29sIGt2bV9oYXNfc2hhZG93X21tdV9zcHRlcyhzdHJ1Y3Qga3ZtICprdm0pCiAJ
cmV0dXJuICF0ZHBfbW11X2VuYWJsZWQgfHwgUkVBRF9PTkNFKGt2bS0+YXJjaC5pbmRpcmVjdF9z
aGFkb3dfcGFnZXMpOwogfQogCitzdGF0aWMgYm9vbCBrdm1fYWdlX3JtYXBfZmFzdCh1NjQgKnNw
dGVwKQoreworCXJldHVybiBtbXVfc3B0ZV9hZ2VfbG9ja2xlc3Moc3B0ZXApOworfQorCitzdGF0
aWMgYm9vbCBrdm1fdGVzdF9hZ2Vfcm1hcF9mYXN0KHU2NCAqc3B0ZXApCit7CisJcmV0dXJuIGlz
X2FjY2Vzc2VkX3NwdGUoUkVBRF9PTkNFKCpzcHRlcCkpOworfQorCit0eXBlZGVmIGJvb2wgKCpy
bWFwX2xvY2tsZXNzX2hhbmRsZXJfdCkodTY0ICpzcHRlcCk7CisKK3N0YXRpYyBfX2Fsd2F5c19p
bmxpbmUgYm9vbCBrdm1faGFuZGxlX2dmbl9yYW5nZV9sb2NrbGVzcygKKwkJc3RydWN0IGt2bSAq
a3ZtLCBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFuZ2UsCisJCXJtYXBfbG9ja2xlc3NfaGFuZGxl
cl90IGhhbmRsZXIpCit7CisJc3RydWN0IGt2bV9ybWFwX2hlYWQgKnJtYXA7CisJdTY0ICpzcHRl
cDsKKwlnZm5fdCBnZm47CisJaW50IGxldmVsOworCWJvb2wgcmV0ID0gZmFsc2U7CisKKwl3YWxr
X3NoYWRvd19wYWdlX2xvY2tsZXNzX2JlZ2luKE5VTEwpOworCisJZm9yIChnZm4gPSByYW5nZS0+
c3RhcnQ7IGdmbiA8IHJhbmdlLT5lbmQ7IGdmbisrKSB7CisJCWZvciAobGV2ZWwgPSBQR19MRVZF
TF80SzsgbGV2ZWwgPD0gS1ZNX01BWF9IVUdFUEFHRV9MRVZFTDsKKwkJICAgICBsZXZlbCsrKSB7
CisJCQlybWFwID0gZ2ZuX3RvX3JtYXAoZ2ZuLCBsZXZlbCwgcmFuZ2UtPnNsb3QpOworCQkJc3B0
ZXAgPSAodm9pZCAqKVJFQURfT05DRShybWFwLT52YWwpOworCisJCQkvKiBTa2lwIHRoaXMgZ2Zu
IGlmIG11bHRpcGxlIFNQVEVzIG1hcHBpbmcgaXQgKi8KKwkJCWlmICgodW5zaWduZWQgbG9uZylz
cHRlcCAmIDEpCisJCQkJY29udGludWU7CisKKwkJCXJldCB8PSBoYW5kbGVyKHNwdGVwKTsKKwkJ
fQorCX0KKworCXdhbGtfc2hhZG93X3BhZ2VfbG9ja2xlc3NfZW5kKE5VTEwpOworCisJcmV0dXJu
IHJldDsKK30KKwogYm9vbCBrdm1fYWdlX2dmbihzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1f
Z2ZuX3JhbmdlICpyYW5nZSkKIHsKLQlib29sIHlvdW5nID0gZmFsc2U7CisJYm9vbCB5b3VuZyA9
IGZhbHNlLCBzaGFkb3dfeW91bmcgPSBmYWxzZTsKIAotCWlmICh0ZHBfbW11X2VuYWJsZWQpIHsK
KwlpZiAodGRwX21tdV9lbmFibGVkKQogCQl5b3VuZyB8PSBrdm1fdGRwX21tdV9hZ2VfZ2ZuX3Jh
bmdlKGt2bSwgcmFuZ2UpOwotCQlpZiAoeW91bmcpCi0JCQlyYW5nZS0+YXJnLnJlcG9ydF9mYXN0
ID0gdHJ1ZTsKLQl9CiAKLQlpZiAoIXJhbmdlLT5hcmcuZmFzdF9vbmx5ICYmIGt2bV9oYXNfc2hh
ZG93X21tdV9zcHRlcyhrdm0pKSB7CisJc2hhZG93X3lvdW5nID0ga3ZtX2hhbmRsZV9nZm5fcmFu
Z2VfbG9ja2xlc3Moa3ZtLCByYW5nZSwKKwkJCQkJICAgICAgIGt2bV9hZ2Vfcm1hcF9mYXN0KTsK
Kwl5b3VuZyB8PSBzaGFkb3dfeW91bmc7CisJaWYgKHlvdW5nKQorCQlyYW5nZS0+YXJnLnJlcG9y
dF9mYXN0ID0gdHJ1ZTsKKworCWVsc2UgaWYgKCFzaGFkb3dfeW91bmcgJiYgIXJhbmdlLT5hcmcu
ZmFzdF9vbmx5ICYmCisJCSBrdm1faGFzX3NoYWRvd19tbXVfc3B0ZXMoa3ZtKSkgewogCQl3cml0
ZV9sb2NrKCZrdm0tPm1tdV9sb2NrKTsKIAkJeW91bmcgPSBrdm1faGFuZGxlX2dmbl9yYW5nZShr
dm0sIHJhbmdlLCBrdm1fYWdlX3JtYXApOwogCQl3cml0ZV91bmxvY2soJmt2bS0+bW11X2xvY2sp
OwpAQCAtMTY1NywxMSArMTc0NiwxNSBAQCBib29sIGt2bV90ZXN0X2FnZV9nZm4oc3RydWN0IGt2
bSAqa3ZtLCBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFuZ2UpCiB7CiAJYm9vbCB5b3VuZyA9IGZh
bHNlOwogCi0JaWYgKHRkcF9tbXVfZW5hYmxlZCkgeworCWlmICh0ZHBfbW11X2VuYWJsZWQpCiAJ
CXlvdW5nIHw9IGt2bV90ZHBfbW11X3Rlc3RfYWdlX2dmbihrdm0sIHJhbmdlKTsKLQkJaWYgKHlv
dW5nKQotCQkJcmFuZ2UtPmFyZy5yZXBvcnRfZmFzdCA9IHRydWU7Ci0JfQorCisJaWYgKCF5b3Vu
ZykKKwkJeW91bmcgfD0ga3ZtX2hhbmRsZV9nZm5fcmFuZ2VfbG9ja2xlc3Moa3ZtLCByYW5nZSwK
KwkJCQkJCSAgICAgICBrdm1fdGVzdF9hZ2Vfcm1hcF9mYXN0KTsKKworCWlmICh5b3VuZykKKwkJ
cmFuZ2UtPmFyZy5yZXBvcnRfZmFzdCA9IHRydWU7CiAKIAlpZiAoIXlvdW5nICYmICFyYW5nZS0+
YXJnLmZhc3Rfb25seSAmJiBrdm1faGFzX3NoYWRvd19tbXVfc3B0ZXMoa3ZtKSkgewogCQl3cml0
ZV9sb2NrKCZrdm0tPm1tdV9sb2NrKTsKQEAgLTI2MzYsNiArMjcyOSwxMiBAQCBzdGF0aWMgdm9p
ZCBrdm1fbW11X2NvbW1pdF96YXBfcGFnZShzdHJ1Y3Qga3ZtICprdm0sCiAJICovCiAJa3ZtX2Zs
dXNoX3JlbW90ZV90bGJzKGt2bSk7CiAKKwkvKgorCSAqIFdhaXQgZm9yIGFueSBub24tdkNQVSBs
b2NrbGVzcyBzaGFkb3cgcGFnZSB0YWJsZSB3YWxrZXJzIHRvIHN0b3AKKwkgKiB1c2luZyB0aGUg
c2hhZG93IHBhZ2VzIHdlJ3JlIGFib3V0IHRvIGZyZWUuCisJICovCisJc3luY2hyb25pemVfcmN1
KCk7CisKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoc3AsIG5zcCwgaW52YWxpZF9saXN0LCBs
aW5rKSB7CiAJCVdBUk5fT05fT05DRSghc3AtPnJvbGUuaW52YWxpZCB8fCBzcC0+cm9vdF9jb3Vu
dCk7CiAJCWt2bV9tbXVfZnJlZV9zaGFkb3dfcGFnZShzcCk7Cg==
--00000000000085f40d061bfbc2cf--

