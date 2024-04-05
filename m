Return-Path: <kvm+bounces-13720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2768B899EE4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB4901F22CD7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850BA16DEA8;
	Fri,  5 Apr 2024 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HcrTaqms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CA616D9CA
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712325602; cv=none; b=tQ6OS26hl2+N9Srfow6q/4xhIf9jYWpEeqpppBF98Ai3zuPP4rEx5w8Ltkar93gbb+CENgLG49sqvvsbKOXEjZjPNLL04sAzFKv/bNDZaVwFNQXVSBOgM5BC3YAlu37DxqezlQJJwlM28vqjGNc5RlnoNk2cVVP1iyEqT1vSDsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712325602; c=relaxed/simple;
	bh=d2Gjkn8zQPo53nYXq1JewbpOyGYLdbMCwU7yiaeQ1Ks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qlZsk0xfQzkB7LnqwBwQAOxW6sKoDEPV30LzinUGDsO12oGCHwBF7njmSUl6aNn8+0TgckkTcg3XVXVpXe5j/rZJqVe0K7Ka2Qh+H5n7hwE/p3tvcujKRoQl1FJ3af6aKugnINaQiHfH8KxBgqJspZGHbAE3t4lfyBNeNnDiWpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HcrTaqms; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dcbb769a71so1901866a12.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712325600; x=1712930400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lnhmHwoeSCP7BicvkvyxKIC7YaO6DxVsF5ZxyJsDQ1U=;
        b=HcrTaqmsjEA3WbngmCTcuxsp8N5ydo0BhtZn868PtZ9D9UZFFB6XL4A9S5ZeKyo3EW
         26D7n48RF/Z6+4+9uMZlDxjSgS+RgTmFzplltzTeDAdvGlBmZVtx8Hg1qGJTLda6OfAy
         kN//CAwNKFsMobMkdZ9/TDh8IR/ylAc/UqMbk75TA+ixnf905vStj/jCU3Gz75gInOA6
         //8SJrc+y480pKRUbchOUK80eJhzpdM4fHs3/vEw1AusodftT1ZiKmqs3PupIzBuHQxO
         4/3eF7jAvydrkMhZOiAEa9RpsbAW4GaUhMuP+5b+SWUnKhkXp+gCDX3gMx2GiEmkCcHi
         sDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712325600; x=1712930400;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lnhmHwoeSCP7BicvkvyxKIC7YaO6DxVsF5ZxyJsDQ1U=;
        b=Zsp1/1DZTRbNBrOaKp9xPbJbU3No03AgIYFNNC7SF6/ehuqHD1mak+dsjDL/ZkXVy2
         d0fQXb8TfTS79HAME5yTGh0948+4L7Xeu2OFka1Cmzj7FqAaIRPnolzUROt80mkc+GPe
         RAaBTR3SJujEilmPGPB05PKYTUZ2Mi3waX6Se/PwEjbT/QCykfZLVEeed/hd3/UglCb+
         jyjk+WvFVnKvEe/vZRVIbxDX9NA3Oq43esjOehOlWhPFEUhkOHwKPUJYG4UNjL1aSmbF
         clxahCj8dhsSrMJ4r3Ofxh0dKhC6cwgsst2y+xzpFFa2o3fYd/x2Xm2y6VD7b/lO4eGI
         Rx1g==
X-Forwarded-Encrypted: i=1; AJvYcCWtf5rnM1JPtrkus9/oLPVpvPvPsIRpLCb7SLmZlsnmeLLvFecdYSK3ewOUz47mWZZvS3boAsr/EYkGbZOmwiLm5yw8
X-Gm-Message-State: AOJu0Yx/GJ6C3AKcG6ZUagfIgzHbC4hjTzhnZDspA0qYKpX6lghR4rWI
	zqgdY2h0bD+gcRvQ/OWCy/6hJwevKOS/0DwxB6wCZBjqn9iBjEvmVMwhSerlh9TXMaX69D2Jyiw
	Kfw==
X-Google-Smtp-Source: AGHT+IEJLrewATdlF8sTxBovk7rkSyyPGxSiIzqS5JKFRHBkCQgBvdYKodgoQdop5RmT0rFSKqrgHPxLRos=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8b:b0:1e2:36d1:3019 with SMTP id
 x11-20020a170902ec8b00b001e236d13019mr4866plg.6.1712325600238; Fri, 05 Apr
 2024 07:00:00 -0700 (PDT)
Date: Fri, 5 Apr 2024 06:59:58 -0700
In-Reply-To: <7a1c58d7-ddd9-40fc-a4ef-81c548de2b07@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZgygGmaEuddZGKyX@google.com> <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
 <Zg3V-M3iospVUEDU@google.com> <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
 <Zg7j2D6WFqcPaXFB@google.com> <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
 <Zg8jip0QIBbOCgpz@google.com> <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
 <CABgObfbykeRXv2r2tULe6_SwD7DkWPaMTdc6PkAUb3JmTodf4w@mail.gmail.com> <7a1c58d7-ddd9-40fc-a4ef-81c548de2b07@redhat.com>
Message-ID: <ZhAD3hQwI0ltYnFp@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2024, David Hildenbrand wrote:
> On 05.04.24 11:37, Paolo Bonzini wrote:
> > On Fri, Apr 5, 2024 at 8:53=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> > > >        mmu_notifier_invalidate_range_start(&range);
> > > >        tlb_start_vma(&tlb, vma);
> > > >        walk_page_range(vma->vm_mm, range.start, range.end,
> > > >                        &madvise_free_walk_ops, &tlb);
> > > >        tlb_end_vma(&tlb, vma);
> > > >        mmu_notifier_invalidate_range_end(&range);
> > > >=20
> > >=20
> > > Indeed, we do setup the MMU notifier invalidation. We do the start/en=
d
> > > ... I was looking for PTE notifications.
> > >=20
> > > I spotted the set_pte_at(), not a set_pte_at_notify() like we do in
> > > other code. Maybe that's not required here (digging through
> > > documentation I'm still left clueless). [...]
> > > Absolutely unclear to me when we *must* to use it, or if it is. Likel=
y
> > > its a pure optimization when we're *changing* a PTE.
> >=20
> > Yes, .change_pte() is just an optimization. The original point of it
> > was for KSM, so that KVM could flip the sPTE to a new location without
> > first zapping it. At the time there was also an .invalidate_page()
> > callback, and both of them were *not* bracketed by calls to
> > mmu_notifier_invalidate_range_{start,end}()
> >=20
> > Later on, both callbacks were changed to occur within an
> > invalidate_range_start/end() block.
> >=20
> > Commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify with
> > invalidate_range_start and invalidate_range_end", 2012-10-09) did so
> > for .change_pte(). The reason to do so was a bit roundabout, namely to
> > allow sleepable .invalidate_page() hooks (because .change_pte() is not
> > sleepable and at the time .invalidate_page() was used as a fallback
> > for .change_pte()).
> >=20
> > This however made KVM's usage of the .change_pte() callback completely
> > moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> > and therefore .change_pte() has no hope of succeeding.
> >=20
> > (Commit 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic
> > v2", 2017-08-31) is where the other set of non-bracketed calls to MMU
> > notifier callbacks was changed; calls to
> > mmu_notifier_invalidate_page() were replaced by calls to
> > mmu_notifier_invalidate_range(), bracketed by calls to
> > mmu_notifier_invalidate_range_{start,end}()).
> >=20
> > Since KVM is the only user of .change_pte(), we can remove
> > .change_pte() and set_pte_at_notify() completely.
>=20
> Nice, thanks for all that information!

Ya, from commit c13fda237f08 ("KVM: Assert that notifier count is elevated =
in
.change_pte()"):

    x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
    is guaranteed due to the prior invalidation.  PPC simply unmaps the SPT=
E,
    which again should be a nop due to the invalidation.  arm64 is a bit
    murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
    called without a cache pointer, which means it will map an entry if and
    only if an existing PTE was found.

I'm 100% in favor of removing .change_pte().  As I've said multiple times, =
the
only reason I haven't sent a patch is because I didn't want it to prompt so=
meone
into resurrecting the original behavior. :-)

