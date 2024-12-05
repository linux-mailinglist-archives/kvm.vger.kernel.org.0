Return-Path: <kvm+bounces-33180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 002159E6163
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0B2D164B0D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175331D5AC9;
	Thu,  5 Dec 2024 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTBngy2d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA521B4136
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 23:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733441504; cv=none; b=T36rNojbApZV7QrGlVR6RIoFlTgiPmNmALz2wWfc5hQ5C//jP0zTTDKpzbyvGvAn/JCCC+/Y8Pwhw5qzB2+yJJyWnDOeaEAbE5F4oEgSTbMYmuwfx+oAGbivzdm5TrM8O/vWVEds9wY9ZTa5fycqc/bGi/Xar5YoHRH+YWRoU6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733441504; c=relaxed/simple;
	bh=/ihX0lCXBJfFCvsOFHIJu6cysZ6Vq0x4cO5iS9Q7qBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TYj6QAnZ/YGcSVx98CFwQwEakczzEuXxv0cbY3Ad8xUplNjVTRXP/VdYCW1ydrmlQdxz3YqZO3po7WTKp0QTVWXQVcD+Y8y7QJfbkRu0nDLAYq4WGbTLYrpqlzB5RZ2eNcmHPaV8hm7UOWUJB+W+wsoebr1h2bjPAjemgxSOhpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oTBngy2d; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6ef0ef11aafso11920137b3.2
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 15:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733441501; x=1734046301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0IMN5OU4hbVrS5t00San57aLCq8tVf/YYU7UNV9XtU=;
        b=oTBngy2dRTKxt4HaiJo2zQx2tJFl4Fzr7ePXI0fZaGsfY7TnvQmxydcdjiRyGEMKos
         Y8Olb3c6k1NRps8ToYYEbOS//ekrGPvL8uTV0KIYYQnWWv3mgBhFkvxS0PtXEJr8wZjH
         50Gy9fINYHitrIBb8CADRJKb0zrfkeySCYkSAGoSvScqv+3mr4aJDAKVTKwyttxJslch
         JW1lw5cC4GJRwmoAJm6+fR9iixNXgH1hWuDX4CO/a7jCii4+fUHt+dO68tN+OJcT6iuT
         gmymlIWrD1a4id/pkeGibfmFG6aI6JAz5CnZfTwdSBtCXz0WaKdLFI3Gzl65fUn7NUJu
         IVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733441501; x=1734046301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0IMN5OU4hbVrS5t00San57aLCq8tVf/YYU7UNV9XtU=;
        b=sqmHtxCGu8dYHkXo3JV+cNvNNT32dhbldtKvOYXxg44NjcCpnKR1gAuPNKiLuiIUUc
         EgmaYO1pKfWHDPbDWHUhS7Xh4HqGkp85OCFy4WtOSp6BTo93TWnYQKc2Te4L2MLVGBzH
         dpGnvDbPNzoWvVcJESXVOQp/r91WZH5+phzu4FDj/i7pjQ7e6sOMYnAg+MBhvnCoo1oB
         OLIoUc+iGptFHC40XAH5h8iYG1DOchWTIFJ1JFrhcrFg1ctBwNCrepbgzQriMP70cf9e
         9TJUru+PniBTHGPtWppTy7k2O/AO28PLBopnPpLWThfDP1URGrI1iVM+cHus3eUuQfy/
         7a1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3U4izeSb9Htsi+OtFn1sEYDpQywNAsGC6NEBJ3Cc8eUR1lSiuLj9JyEQtAF0PXptAv1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxId5iGmptJWndr2Fsd028O7FF68dWNr9vrGPLuHmKL7HE9+HDx
	54/mNgZaT/S58udOQnCBDtxo6av+SvXmJDYsp7CIkEGjWuzdU0qaEDZaMC5Ht+XrEjGE3Y+0JKY
	JvyFUfHw+fLDv5qZL3+Ztk9qc2h5uhrtz4ylj
X-Gm-Gg: ASbGnctnHYLfVlIkWwnIvE53vWYqKf/JjeIAfwKmQFI/k/vEBfa3yF/oxLn0qhvgMie
	9HHebSCQD7ERrePUoX/X4fW6XdqvVfCRfK0FuKZd5V/zXDSkNAWSpnCH1Yry+
X-Google-Smtp-Source: AGHT+IGmoqWrGrMqKXzXbSlaDtMUJEUS1r8dSNypZARIHLTYBVYvB4FriHIdmOjPWn9wrKQu/NTZU5U476BPS24s0cI=
X-Received: by 2002:a05:690c:6083:b0:6ee:6c7d:4888 with SMTP id
 00721157ae682-6efe3c6049bmr11833187b3.22.1733441501392; Thu, 05 Dec 2024
 15:31:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-7-jthoughton@google.com> <Z1Dgr_TnaFQT04Pi@linux.dev>
In-Reply-To: <Z1Dgr_TnaFQT04Pi@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Dec 2024 15:31:05 -0800
Message-ID: <CADrL8HWC7HhYmEBWa+5KeWmyD+iT1zPBJUAUtNyrhH7ZpLXJNQ@mail.gmail.com>
Subject: Re: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 3:07=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi James,

Hi Oliver!

>
> On Wed, Dec 04, 2024 at 07:13:41PM +0000, James Houghton wrote:
> > Adhering to the requirements of KVM Userfault:
> >
> > 1. When it is toggled (either on or off), zap the second stage with
> >    kvm_arch_flush_shadow_memslot(). This is to (1) respect
> >    userfault-ness and (2) to reconstruct block mappings.
> > 2. While KVM_MEM_USERFAULT is enabled, restrict new second-stage mappin=
gs
> >    to be PAGE_SIZE, just like when dirty logging is enabled.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >   I'm not 100% sure if kvm_arch_flush_shadow_memslot() is correct in
> >   this case (like if the host does not have S2FWB).
>
> Invalidating the stage-2 entries is of course necessary for correctness
> on the !USERFAULT -> USERFAULT transition, and the MMU will do the right
> thing regardless of whether hardware implements FEAT_S2FWB.
>
> What I think you may be getting at is the *performance* implications are
> quite worrying without FEAT_S2FWB due to the storm of CMOs, and I'd
> definitely agree with that.

Thanks for clarifying that for me.

> > @@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *k=
vm,
> >                                  enum kvm_mr_change change)
> >  {
> >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 changed_flags =3D (new ? new->flags : 0) ^ (old ? old->flags =
: 0);
> > +
> > +     /*
> > +      * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so=
 that
> > +      * we can (1) respect userfault-ness or (2) create block mappings=
.
> > +      */
> > +     if ((changed_flags & KVM_MEM_USERFAULT) && change =3D=3D KVM_MR_F=
LAGS_ONLY)
> > +             kvm_arch_flush_shadow_memslot(kvm, old);
>
> I'd strongly prefer that we make (2) a userspace problem and don't
> eagerly invalidate stage-2 mappings on the USERFAULT -> !USERFAULT
> change.
>
> Having implied user-visible behaviors on ioctls is never good, and for
> systems without FEAT_S2FWB you might be better off avoiding the unmap in
> the first place.
>
> So, if userspace decides there's a benefit to invalidating the stage-2
> MMU, it can just delete + recreate the memslot.

Ok I think that's reasonable. So for USERFAULT -> !USERFAULT, I'll
just follow the precedent set by dirty logging. For x86 today, we
collapse the mappings, and for arm64 we do not.

Is arm64 ever going to support collapsing back to huge mappings after
dirty logging is disabled?

