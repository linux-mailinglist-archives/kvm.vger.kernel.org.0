Return-Path: <kvm+bounces-26547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A9F975733
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F29A1F23E1D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4C0186E57;
	Wed, 11 Sep 2024 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQjY4j4j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101B87E583
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068837; cv=none; b=Q7TPiVCJi7kDJo8IHF5NMnOinQE9zQJVrALufBwoF6IzNmUEoF9f8uBa7Yz/z49nlY+L53KBxrixLthDEsVdsAJny9dOW7ta+4+qbEkpn28VQV7ONkiAWd0YRbWKnSCqI+6KvwRA7aU4mGp5kqieU89DnvGn1HYDTv58hslm01s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068837; c=relaxed/simple;
	bh=ayl5RujrcIoIbZiylngRNpI68XJsjFCab88H7hrJBBY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g7fSBOrNib6dR68LqViJYUj5H3OyVMcjoEw4/GDt5Th+TfmFSSfhHrZdkurUxrGyVEL0BC1Rbjuaed8itovn7k72iv8Ze71QK232T+vtTnxRtY9d/B75cYJJgtRBKYAZQe0w4lnh+IkdwqDIHJl1ryvNPsmUOqKH71Gx8on7ZF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQjY4j4j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d8e59fcd4bso2477324a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726068835; x=1726673635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9PjfZ/H+0hBJSkcWiHIbXsU+9SAnJ63aVgh3FD7FYE=;
        b=iQjY4j4jMyoOLMPmtn08rcp/s496Iv7oU5cie4QKYH8RB8aR7r38vq/aGVO30uaedR
         5NJ9qNEVZEEeS2KI5j7JCdteJ514vcv8KByEp8ji60WtCa47qrn8RmV9luBFrc+DGS2M
         ctlMDXt4G+VbJE6qeRS5kNnkYWc1nENZq/61mtIkPcdKBxw7RgdTPeugevZlRs/VnOfW
         +dFcKum7zl6+lq2bCsbVJHM+yt0xe308otlCDCrt9Dx0+JcBRoZD06WKKggxxIxdAMHg
         /IVRz6TbkDJ1lBuSQvAykfLNj84XVroMmrhfeF/V80BxdUWqrIvL4R5WTyJfwSuGci6F
         UoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068835; x=1726673635;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n9PjfZ/H+0hBJSkcWiHIbXsU+9SAnJ63aVgh3FD7FYE=;
        b=B1XBHOZiU8Le1zcrBgKuXg8Yv2ARMD0YTvzq68/CL5mr590yeDyP2Ai9j9DnXGbL6B
         F8So/8HqgMU63S5FvsjAmVK0pkduUaE1Agytxc3E61Tq6CfJD7Xy4vhPdq36k9v2n7m6
         igdAOsvEbxm5ZKtrHG0Osy5lH2192A7rhK1sQ70JjI+2e4Is+C7nGN4V5lYKKTucvXuV
         Oma89d1R5Ghrn56Gwyh7GWox+DA+6C/HLENIdFl2A38v+CDX9GkqDMbF7YYZ+CKjzesB
         6LVmQxYJ0emo5HfjO6IFcbcfxw3M/QmLmIkiJ6qnsQMlkvK4UbiNhCl+ZQTyBiqEHbYM
         c8uw==
X-Forwarded-Encrypted: i=1; AJvYcCUR/h7KZTMMGekYp7A/dWdCRakdk/ak4malqVK/Ra+iSOmtb8BwZsi3CcVY1RJwVmL6O6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ7tNfMIunh7PjUAngbqlxPrhVP+lOmOinBqM5PFlGaEkh22W8
	xagZowYTsa1TVFqiVhyz8mG0JstN3rs76yipeZy85IQikUTF7+LbLq3dzt5b2JV7zVEQSjGXayw
	aRw==
X-Google-Smtp-Source: AGHT+IFpZ9ndY7Ts97EEPr2ASMuCzC5PgXkvhoZjCrqJDmQXEhIoN17GXMOiW9kwAQyxWgil0J2fQ/kYSDY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1e50:b0:2d2:453:1501 with SMTP id
 98e67ed59e1d1-2db82e64986mr19872a91.2.1726068835051; Wed, 11 Sep 2024
 08:33:55 -0700 (PDT)
Date: Wed, 11 Sep 2024 08:33:53 -0700
In-Reply-To: <CADrL8HV1Erpg-D4LzuRHUk7dg6mvex8oQz5pBzwO7A3OjB8Uvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
 <Zt9UT74XkezVpTuK@google.com> <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
 <Zt9wg6h_bPp8BKtd@google.com> <CADrL8HWbNjv-w-ZJOxkLK78S5RePd2QXDuXV-=4iFVV29uHKyg@mail.gmail.com>
 <Zt-kHjtTVrONMU1V@google.com> <CADrL8HV1Erpg-D4LzuRHUk7dg6mvex8oQz5pBzwO7A3OjB8Uvw@mail.gmail.com>
Message-ID: <ZuG4YYzozOddPRCm@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024, James Houghton wrote:
> On Mon, Sep 9, 2024 at 6:42=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Mon, Sep 09, 2024, James Houghton wrote:
> > > I take back what I said about this working on x86. I think it's
> > > possible for there to be a race.
> > >
> > > Say...
> > >
> > > 1. T1 modifies pte_list_desc then unlocks kvm_rmap_unlock().
> > > 2. T2 then locks kvm_rmap_lock_readonly().
> > >
> > > The modifications that T1 has made are not guaranteed to be visible t=
o
> > > T2 unless T1 has an smp_wmb() (or equivalent) after the modfication
> > > and T2 has an smp_rmb() before reading the data.
> > >
> > > Now the way you had it, T2, because it uses try_cmpxchg() with full
> > > ordering, will effectively do a smp_rmb(). But T1 only does an
> > > smp_wmb() *after dropping the mmu_lock*, so there is a race. While T1
> > > still holds the mmu_lock but after releasing the kvm_rmap_lock(), T2
> > > may enter its critical section and then *later* observe the changes
> > > that T1 made.
> > >
> > > Now this is impossible on x86 (IIUC) if, in the compiled list of
> > > instructions, T1's writes occur in the same order that we have writte=
n
> > > them in C. I'm not sure if WRITE_ONCE guarantees that this reordering
> > > at compile time is forbidden.
> > >
> > > So what I'm saying is:
> > >
> > > 1. kvm_rmap_unlock() must have an smp_wmb().
> >
> > No, because beating a dead horse, this is not generic code, this is x86=
.
>=20
> What prevents the compiler from reordering (non-atomic, non-volatile)
> stores that happen before WRITE_ONCE() in kvm_rmap_unlock() to after
> the WRITE_ONCE()?

Oof, right, nothing.  Which is why __smp_store_release() has an explicit
barrier() before its WRITE_ONCE().

> IMV, such a reordering is currently permitted[1] (i.e., a barrier() is
> missing), and should the compiler choose to do this, the lock will not
> function correctly.
>=20
> > If kvm_rmap_head.val were an int, i.e. could be unionized with an atomi=
c_t, then
> > I wouldn't be opposed to doing this in the locking code to document thi=
ngs:
> >
> >  s/READ_ONCE/atomic_read_acquire
> >  s/WRITE_ONCE/atomic_set_release
> >  s/try_cmpxchg/atomic_cmpxchg_acquire
>=20
> I think we can use atomic_long_t.

Duh.  That's a /facepalm moment.

> It would be really great if we did a substitution like this. That
> would address my above concern about barrier() (atomic_set_release,
> for example, implies a barrier() that we otherwise need to include).

Ya, agreed, not just for warm fuzzies, but because it's necessary to preven=
t
the compiler from being clever.

