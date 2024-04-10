Return-Path: <kvm+bounces-14143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C07B89FCB5
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 18:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 261791F2275E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4076117A930;
	Wed, 10 Apr 2024 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uueRiOOE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE5E179943
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712765869; cv=none; b=DwQ4Tc2ZARmoZimNXov13yBgtmYA8QA0aUL+kxE7YAIm6y9Awbp1bUXgpRVRliSoNjD0CpVlC7QYr/s4PrS+6ohjp9XjIaiY/MUAbtAl1rC/+73t0RNj15aSkDd4L/je8qs+vC9q0tOkWXovNOr526Jdm7g/z5F165rvOyRc56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712765869; c=relaxed/simple;
	bh=1WyjkTl7b0Sdz5CN4zB/P780Z1I2Oi8XLWSFnpNieyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHX66vAIV4fl1jF/ohVKKF5CaK8Fq2DjvUzTbqxZcObESbjx11zAsfNfSCknqaijfcrQlvWWvJ6bawa7CUJ0BHFQMuiSljHsER7Ltl8RY5PkDxFZ1YcvwkYP6JQeSQNKEF+F0zdRBzq5FDGYlaSCui8IllOoW8eTxcKPmVR4P7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uueRiOOE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a49440f7b5so4413287a91.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712765867; x=1713370667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4RM9QND4Dh1XrtT52mI6sX0Ud+p6rtxAVIaz7hkBd0Y=;
        b=uueRiOOE4cE4ZvGsW/ExYZFMSQlQnfEJgktnIWqcvCXmHM4OW2cbai02XiriPJetmV
         8scWPdL5hISmnDzCukuGJRrQhgx/Kd82+WNKj61v4ChmIx8xQzFibKaLLIMTowT8+sLw
         x/CkueEJ1msc0yAbNWhdWmWPPZGogtj2hzIyNaeHAxTDnYhexbspKdWf8s1mZOmVUu5p
         Frf+oozzoctlro+ssi8yv5cXnZOZnxm8S8ZKUxM/TvR8XeBKpPf5r2CsyF6DA4zAEb0O
         wR8o38yVozOFttealbXF/MXmdue1Bb3duGH6coS205QDQYB8bvSXZscqTDTMVM7Xh9e7
         HnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712765867; x=1713370667;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4RM9QND4Dh1XrtT52mI6sX0Ud+p6rtxAVIaz7hkBd0Y=;
        b=poJNlGRf6Sp9UWcl+YsyDZK6TQWzocN3qEHaHPtxSswg+rVEPQr/VCL6zN68cf9Vn6
         tnCFs4M5nbYCmFX2ewwNTTJLT3MShUhsrcW4/p23ZihCIrjh5DhIXlE3LThFcCc0Fahb
         uFwjrPds16BxskrzVOdinb72IELkdlEGj7MjfdpsUHyfeSmmW0zAqnCUfEbSZqW7g1pT
         i5Du4QdVKCa9pzlzU6rZF4RFDpeT2NeUAVTZF7DZc4s4XMgoGWpH8HK6ogmqq1wPXzKI
         E/Bs8tAa0V95EcWbdBO/M6VIzievn5pv9ZVTJrwaIEzJBJuA+Psdy9Z5Bi/uR3yo8x40
         ksTA==
X-Forwarded-Encrypted: i=1; AJvYcCUGYPu3NAkPHyvyQO5k4rwBmy3Bitg4N2VJEI2hYpFXSAqxXPludd+o3QC1/UsLyPuWfFdpJPFivwe35lA8NUZB7M2M
X-Gm-Message-State: AOJu0YyIbs8T6Utm5aIJiVHPTcwRmSsU9d+gMXJhemG0cyKjI4gPTlYA
	vb7+jmM2YZDXqwlEEz40ad4b1L7dgL0tdqZuoDGR3hA3+qcQ91mUUoUcSG0s1qwVAK9tXjLdSGA
	C/w==
X-Google-Smtp-Source: AGHT+IE8r4m5kt68m3QpTx1M5VPtPagtkqmQhRKiMFUQyxkBPQhUR12Sr0TLYAzLjQbn/WdGOklZScVy1QI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d710:b0:2a4:70d5:2dd9 with SMTP id
 y16-20020a17090ad71000b002a470d52dd9mr8829pju.7.1712765867259; Wed, 10 Apr
 2024 09:17:47 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:17:45 -0700
In-Reply-To: <CALzav=eK-FeCDvjrfcWUR_KYy29r8O8HP=+L=zdp-UAYhpp+QQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com> <171270408430.1586965.15361632493269909438.b4-ty@google.com>
 <CALzav=eK-FeCDvjrfcWUR_KYy29r8O8HP=+L=zdp-UAYhpp+QQ@mail.gmail.com>
Message-ID: <Zha7qWnZP8IsO6Vc@google.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Fix TDP MMU dirty logging bug L2
 running with EPT disabled
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024, David Matlack wrote:
> On Tue, Apr 9, 2024 at 5:20=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, 15 Mar 2024 16:05:37 -0700, David Matlack wrote:
> > > Fix a bug in the TDP MMU caught by syzkaller and CONFIG_KVM_PROVE_MMU
> > > that causes writes made by L2 to no be reflected in the dirty log whe=
n
> > > L1 has disabled EPT.
> > >
> > > Patch 1 contains the fix. Patch 2 and 3 fix comments related to clear=
ing
> > > dirty bits in the TDP MMU. Patch 4 adds selftests coverage of dirty
> > > logging of L2 when L1 has disabled EPT. i.e.  a regression test for t=
his
> > > bug.
> > >
> > > [...]
> >
> > Applied to kvm-x86 fixes, with the various tweaks mentioned in reply, a=
nd the
> > s/READ_ONCE/WRITE_ONCE fixup.  A sanity check would be nice though, I b=
otched
> > the first attempt at the fixup (the one time I _should_ have copy+paste=
d code...).
> >
> > Thanks!
> >
> > [1/4] KVM: x86/mmu: Check kvm_mmu_page_ad_need_write_protect() when cle=
aring TDP MMU dirty bits
> >       https://github.com/kvm-x86/linux/commit/b44914b27e6b
> > [2/4] KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_ran=
ge,pt_masked}()
> >       https://github.com/kvm-x86/linux/commit/d0adc4ce20e8
> > [3/4] KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs. w=
rite-protecting
> >       https://github.com/kvm-x86/linux/commit/5709b14d1cea
> > [4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_tes=
t
> >       https://github.com/kvm-x86/linux/commit/1d24b536d85b
>=20
> This commit does not have the WRITE_ONCE() fixup, but when I look at
> the commits in the fixes branch itself I see [1] which is correct.

Argh, I must have forgot to copy+paste in the correct hashes (like I said a=
bove,
it took me a few tries to get things right).

For posterity...

[1/4] KVM: x86/mmu: Write-protect L2 SPTEs in TDP MMU when clearing dirty s=
tatus
      https://github.com/kvm-x86/linux/commit/b44914b27e6b
[2/4] KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_range,p=
t_masked}()
      https://github.com/kvm-x86/linux/commit/d0adc4ce20e8
[3/4] KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs. write=
-protecting
      https://github.com/kvm-x86/linux/commit/5709b14d1cea
[4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test
      https://github.com/kvm-x86/linux/commit/f1ef5c343399

