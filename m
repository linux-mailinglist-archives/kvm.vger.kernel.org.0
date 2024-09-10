Return-Path: <kvm+bounces-26349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C62F97449E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DC0EB253F8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 21:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB331AB531;
	Tue, 10 Sep 2024 21:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QRG7aq1i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90581AB508
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 21:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726002715; cv=none; b=QSX3DL3JLtRgz2XkX8Unvg7V4c/+fxGGIjTtCqbTHbArnWWIHvnRkw30vBmJKllz9EU4s5KJp2LO2OoNlKQkPvwkOjAJrvcdgEjjkA/S6bnuyZEbKViOC82LD2j8ldgaToYRiFPnsQHkMEt+KrOeGdnKPCmlDCwVfLSWodZfxKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726002715; c=relaxed/simple;
	bh=vQ19Neos0DyR2KeY0ecAmyspXyYZOWY65Booqku3A+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tLxSNbzmh69wT8d6W18OM91qdTEONRQoDSkNHjjDK+GQ6GdXM+XC0vk3sT8lWcThuL/kgU0nEjgSJ3JYHz3KYp0uuwSm1sTz+pDBqX2im48li0G8XZIHMYGwNAzEmXZUbnIFmHv/PO7f+9hl4kPrM1DZE7cbuXext6oDA2BoHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QRG7aq1i; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-50108a42fa9so1532401e0c.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 14:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726002712; x=1726607512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mL456C9bf2/NmawuOM2i75QU0ioWJIK8fenw90OA60=;
        b=QRG7aq1i6d891jb5kRmAOpiq6j6e0jEU+k+GF8Xio9Jdj2w4JUahuOOKXoqYM2rqUk
         paSTgEuDbKHXvg+0zucLYk3e5lQXyyBrETl2pE/XzggNAody0L7XoypUvWtG+Sqc3tLy
         KtdNtPWdDbgKM70V51npsIUbFdNo3EFDBfHIyd93Dv+vzOn/HeZt50p9q/qVjnTBWPel
         WXMU/e5geV9REQBtfpy17FkksY8C5nD3IT09kKM0iklIhUJSvL5m4v1caaQRmZ25mESa
         ufJVJ3v0YVU66JwY9DABoV62V2hY4+SXB5P9gBQK9s1QwhZntfxKkpSHPxgaIrjEBAon
         xgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726002712; x=1726607512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9mL456C9bf2/NmawuOM2i75QU0ioWJIK8fenw90OA60=;
        b=AMB+q/kTqMIR8fnepapJmnSRmJ9cEh9r1SU2dNyFfCewAL8r+U4Ya7SzgUmEwq+lTG
         gofvJJUA6BQCIuqNpNnfucL3tf5JXll3TUwF0V0GadzXPGQiElUnxo9qUYM7D26b0sm9
         snZpgmdXIyUL+BkmqObbpAcrUvs3uyilsvd1I2SAy0v2YM6Zg3u9U8Bo7s/SaLAm2Oxw
         teOHt/BFu3r0KwbKSPhTS99CzBHDf97X/qfWw/bVZ9JsecIUpI3ju+bNr4ydXrzn0Xgh
         /vJEikpCheK0oFY0MNEK8N+96/Jjw7WNGK1JhtsgRUQPNhARbNGws1VPF+KGmKOAS9Fv
         RaHw==
X-Forwarded-Encrypted: i=1; AJvYcCVjoeULEMMH0IstviBQd9LeBPf+9AobPrIS9rm4YpX/CXSisPiha14JVq7YrOiuTQe/V3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyiAel3ZvM7qFwyoUOqughch3lgWOuggqRtHWA0ecewjShWlXs
	st5iykOac02+xV0AoWaUZnwrnifI0jKOOJ/BJPt0I8Dkeb7ZIAC6xT/61z5korHMdVPhkMw/Eg3
	7i7w5uAZazXVhGVhZKX3ffyLdahp96Ro2xaeK
X-Google-Smtp-Source: AGHT+IGNmBkL+R7xBhZDsZOCgpmdSTcN3mnBPXPvha5B1FEl7C+EEP8dxL5+KIrRnUpFi2Hpj2/2XWpfjHaq+rdxtm4=
X-Received: by 2002:a05:6122:2808:b0:501:2960:7595 with SMTP id
 71dfb90a1353d-502143a9979mr12814010e0c.11.1726002712536; Tue, 10 Sep 2024
 14:11:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
 <Zt9UT74XkezVpTuK@google.com> <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
 <Zt9wg6h_bPp8BKtd@google.com> <CADrL8HWbNjv-w-ZJOxkLK78S5RePd2QXDuXV-=4iFVV29uHKyg@mail.gmail.com>
 <Zt-kHjtTVrONMU1V@google.com>
In-Reply-To: <Zt-kHjtTVrONMU1V@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 10 Sep 2024 14:11:15 -0700
Message-ID: <CADrL8HV1Erpg-D4LzuRHUk7dg6mvex8oQz5pBzwO7A3OjB8Uvw@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 6:42=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Sep 09, 2024, James Houghton wrote:
> > I take back what I said about this working on x86. I think it's
> > possible for there to be a race.
> >
> > Say...
> >
> > 1. T1 modifies pte_list_desc then unlocks kvm_rmap_unlock().
> > 2. T2 then locks kvm_rmap_lock_readonly().
> >
> > The modifications that T1 has made are not guaranteed to be visible to
> > T2 unless T1 has an smp_wmb() (or equivalent) after the modfication
> > and T2 has an smp_rmb() before reading the data.
> >
> > Now the way you had it, T2, because it uses try_cmpxchg() with full
> > ordering, will effectively do a smp_rmb(). But T1 only does an
> > smp_wmb() *after dropping the mmu_lock*, so there is a race. While T1
> > still holds the mmu_lock but after releasing the kvm_rmap_lock(), T2
> > may enter its critical section and then *later* observe the changes
> > that T1 made.
> >
> > Now this is impossible on x86 (IIUC) if, in the compiled list of
> > instructions, T1's writes occur in the same order that we have written
> > them in C. I'm not sure if WRITE_ONCE guarantees that this reordering
> > at compile time is forbidden.
> >
> > So what I'm saying is:
> >
> > 1. kvm_rmap_unlock() must have an smp_wmb().
>
> No, because beating a dead horse, this is not generic code, this is x86.

What prevents the compiler from reordering (non-atomic, non-volatile)
stores that happen before WRITE_ONCE() in kvm_rmap_unlock() to after
the WRITE_ONCE()?

IMV, such a reordering is currently permitted[1] (i.e., a barrier() is
missing), and should the compiler choose to do this, the lock will not
function correctly.

> If kvm_rmap_head.val were an int, i.e. could be unionized with an atomic_=
t, then
> I wouldn't be opposed to doing this in the locking code to document thing=
s:
>
>  s/READ_ONCE/atomic_read_acquire
>  s/WRITE_ONCE/atomic_set_release
>  s/try_cmpxchg/atomic_cmpxchg_acquire

I think we can use atomic_long_t.

It would be really great if we did a substitution like this. That
would address my above concern about barrier() (atomic_set_release,
for example, implies a barrier() that we otherwise need to include).

[1]: https://www.kernel.org/doc/Documentation/memory-barriers.txt
(GUARANTEES + COMPILER BARRIER)

