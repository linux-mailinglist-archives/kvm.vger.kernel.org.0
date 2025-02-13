Return-Path: <kvm+bounces-37996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF06CA333FC
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 01:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD05167B77
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 00:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFBD2C181;
	Thu, 13 Feb 2025 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="barvS0VC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DCF4A29
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739406414; cv=none; b=CP+dG2sI34DEgx7hr2sN2BjvmOpO2gbdFLxg8mPZpOYIeGu3bk6dEhkU/nfbIXpl4u68OZKf8aMv85dFCxmoMCzpUBM17h16XVaOXcKIptF41bY33wJ4KEtJxwQLiPMzR6V2vRRxa8dm/zY7uQkLsHBQ1EN69NfTiX9b+23SCEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739406414; c=relaxed/simple;
	bh=btBR5N7uRHHuw3ht8npwHcy0kScz5qPCp2DfQ4EoDaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IGkRJmy+7JdQiaaqEnJFDdqS1lDULCBDNWykf9CUJ5HMTSjnhplWjofhRUEOBbTbfpMGZ8nbRQxFWBXiHn89iSLvwua9yDBBMtOcsXv479J5oVPgoWQX/aFw9Sr/q0A/stzo3k3MR3HDi0tLaGbb3WbZ3wC+zjEW2/O5Pdm4rbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=barvS0VC; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e455bf1f4d3so310283276.2
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 16:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739406411; x=1740011211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1lQra2BGRqr8BJ2tXCVKhfWYo8wxpCnBIWRVHL8S1U=;
        b=barvS0VCutBXeRNxi2W+7FmdXcYxT5tBeZlANHQ9FpSzuZDs6dSZMEgB0T3kqhqLdz
         MFFl28gwq3W4W1IqTCsOyx6D0cIBIH31jIgZa09hIDfcKi1FEVS+Y9BIPnHvmUjmK54e
         h+d6XlRUaUjlXxzgdAfmD20ALBSt5OEixd+fudxLrZmCnEvdscAfzvlWJt7RXuw3w89L
         uKfpOr6fKhDZXzLoaf3CYJrkS9I+2Ow8UjafnPBu/5nyxI64kqcIee6+yFlQ569/4IjQ
         nuBBRYLwXTkRXvVlnXDbcMFRMREnQXlYxzghk9cGZYum/BzrFVRGUGsTcpxr6D/i7U1T
         +soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739406411; x=1740011211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1lQra2BGRqr8BJ2tXCVKhfWYo8wxpCnBIWRVHL8S1U=;
        b=PEiVyZIMg2LcWhom8S2lRA/u6q00JV6hvzaFYTJJKoRG8f1C3cprWchPms12qWgk4s
         XBvCWrZdjPkq82/Re/h8ArRJC40ZdCHetuUU3E/dzXTJ0AoDPkQLMkB/9SToRamAIAi0
         CIxEiK01l72XH8jssAYpIj5U7YDs2qiqZPhvH0koRJ/1beSJXkuChpHYZsKAT4LHrL2M
         U+FCciDAVZ+ySew7J7gpzsB3kvyQYYx/fB9iWTV1EKcAbhhUx7sKOa+EQptRsRwnx/dt
         odKcN1xehPT4qMCbNsH5/8AeZ7Me9tFr6B50MutovhmpWHD0ky4zQ3JeAMRvn+VziE0/
         uskQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd91JhQ/p2sZ1aqvPsX/u4aUeWDE8c80dBtiBpX5NdmXUmWHePk6b9jRwW9iRGbFEAqCA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfOrctz81WbucCbK94PCC5SZNgP+e+Ynj56SFV9+hQ/pTyDpn9
	QV4w+J9tCe86m3WUq1z1ew9VZrVkBJsneEhSkZ9ulPJbuGuMOjrN4r5hm2+Y1GYHyUphu/Z377Q
	9MIE/Gpa7IIyatn1Rdg9aZaY75OCRWjx9LjIJ
X-Gm-Gg: ASbGnct723RBDrc4HofubPDmNUqEuB4fKXYQJeXLTGVGQ09c6UJSuKjcXIGzC0ziQjY
	zOreGfl/vII/yvJfVN6GFF5R91TJMvD7fjwK2SXmWoZB9HCxIp1CVOWwfMztsfOGPijcZkltfxc
	2GNROWJ7SUufDtsdEoNkluL5wnsQ==
X-Google-Smtp-Source: AGHT+IHF7oWRUxJv7dCUpYW2IfmB3aCv+yjHjliJNpKqm7wi+IQ41sadVcf4u51Avvxozru5EBha7WCpmy+tM7d3Ufk=
X-Received: by 2002:a05:690c:6988:b0:6f6:cad6:6b5a with SMTP id
 00721157ae682-6fb1f19ba28mr70396737b3.13.1739406411154; Wed, 12 Feb 2025
 16:26:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
 <20250204004038.1680123-6-jthoughton@google.com> <Z60cEcQ0P1G7oyFK@google.com>
In-Reply-To: <Z60cEcQ0P1G7oyFK@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 12 Feb 2025 16:26:15 -0800
X-Gm-Features: AWEUYZlW0xEqFDzX78EQEAIp-JOIdOgFVbgwEl-2uovs7RNjvbMVfq0Tz6WW5Vc
Message-ID: <CADrL8HXchc0XVK3JVP17mhvzy9Ga9eKMEi-U8ibah2xBy=2bSg@mail.gmail.com>
Subject: Re: [PATCH v9 05/11] KVM: x86/mmu: Rename spte_has_volatile_bits() to spte_needs_atomic_write()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 2:09=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 04, 2025, James Houghton wrote:
> > spte_has_volatile_bits() is now a misnomer, as the an SPTE can have its
> > Accessed bit set or cleared without the mmu_lock held, but the state of
> > the Accessed bit is not checked in spte_has_volatile_bits().
> > Even if a caller uses spte_needs_atomic_write(), Accessed bit
> > information may still be lost, but that is already tolerated, as the TL=
B
> > is not invalidated after the Accessed bit is cleared.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
>
> ...
>
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index 59746854c0af..4c290ae9a02a 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -519,7 +519,7 @@ static inline u64 get_mmio_spte_generation(u64 spte=
)
> >       return gen;
> >  }
> >
> > -bool spte_has_volatile_bits(u64 spte);
> > +bool spte_needs_atomic_write(u64 spte);
> >
> >  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >              const struct kvm_memory_slot *slot,
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index 05e9d678aac9..b54123163efc 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -55,7 +55,7 @@ static inline bool kvm_tdp_mmu_spte_need_atomic_write=
(u64 old_spte, int level)
> >  {
> >       return is_shadow_present_pte(old_spte) &&
> >              is_last_spte(old_spte, level) &&
> > -            spte_has_volatile_bits(old_spte);
> > +            spte_needs_atomic_write(old_spte);
>
> Unless you object, I'll change this to spte_needs_atomic_update(), and tw=
eak
> kvm_tdp_mmu_spte_need_atomic_write() accordingly.  "write" was a bad choi=
ce by
> me.  It's not just the store/write that needs to be atomic, it's the enti=
re
> read-modify-write.  E.g. KVM needs to preserve the existing value, but fo=
r many
> flows, it's even more important that KVM's snapshot of the old SPTE is ac=
curate.

No objections, please make that change. Thanks!

