Return-Path: <kvm+bounces-7750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A20845E80
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 971CA1C21EA2
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671171649D2;
	Thu,  1 Feb 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QnYKD5Rt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D71649BB
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706808525; cv=none; b=LcuvmKn6/Aa3CodxfynXgkjShC/3V+uIGz56ufZp3DI8P9csY9VNWvMU4F7KtCTv02aOK+cArYKrxMJKttI99sDVqg6Z4VR+K8gqkc01cOPqQytZiMtLtewcPRLu4lBQtYiiZ98kpLER9rUcBecvMe8+4SGo/k+A83b8PJbIqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706808525; c=relaxed/simple;
	bh=LDz4cSPclHrGcUNF60Wj+2awLj0W9TGGEoMVoXcsebQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S35qAt0iGPH6bOjk5PR+Asb+nGAnm5QD9twE0M/NnVJ4ITKWJZelZ2dU9wfJfoV98CTOQPKczcuMg//cE+p0tEwkXrVj1pRKU3KmAMut/jQ0V40wSwicc5gRuKfqlT60jT3jLk6Jqd/OJsEElR0+jfqkd4b4jSIrGBaPC0YzzMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QnYKD5Rt; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so932338a12.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 09:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706808523; x=1707413323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FqcNQbYXwUHok/DzOu9wC5HLHmgl3kq0tC4Cv9tO/lY=;
        b=QnYKD5RtNcDtzMJkK4lbYkkMeDPOkFf10wmghzkzm1kHZXi+UE1y5bw6EDthtYhL8d
         D++h9PtH5/HIHaSur99jbbeTJNsVdjv8UQJi0VO94ByWJn1KHL6YQSgzpJYPQy+nMm7K
         vrjudzDu2LVBS2Ejv+2uHTTahrz/NlJuBVKp6Wd8ACjDiXBmCgL2nBwV/8msLVsGEFDz
         hJ0ppbnNWWz7F/8/iF2TUQk7kE91oCU0c90NNhyc3RGaSShBOLYuTh8/vc7mahZIZdeX
         JN4OgdBu2x6ecLkEfnIpG0kDfGxF8Wjrep94uGZdDrUQMg0vg375HOR4H2+s1gM08on6
         5LTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706808523; x=1707413323;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FqcNQbYXwUHok/DzOu9wC5HLHmgl3kq0tC4Cv9tO/lY=;
        b=m48Ii1rDu9sl8CrDyBY/X2uQJCI0MpsXLYq5X2xf7Dz8m+Pbcy8IbtiNDXkb7V0moy
         TLRXr2CSpY3D4Jfz1slGHcYSSG/AXGghpJAsR32zjyh/ezOgC+q7U3tvtJGfwQ1VhobR
         CfazYjrc3ELL8/R4PribVMbUEcrzymaBLmctY6xaWZq8CPxLh9t8nLqiWXeBBvZ5NU1t
         Qz984Oudf8iLxs190dwBh63DC2slNBtBbjP5EYC1xl71DHV9/vUP6GiJB2qU8GzqANPJ
         RdnM/gDDKCGM9wuPMAWOrvAIlG8JYCe6IWmdLRKLXe+ZsLFdpuBRDlydLFKx0taDGCES
         rz4g==
X-Gm-Message-State: AOJu0YxBm4moS8lM1JpgCrZ2AyfZL+q9QLRAk1+sb/+NEcWgfn1AXzE+
	kY10k+FPgfm/qMEQ18dK7OjoaJBD4JP1XF5eyyEOIOFTpNVVjBG4J6awNZyxzlgEOGUyivxecGd
	eyg==
X-Google-Smtp-Source: AGHT+IGYLucmIpRdmDluEURIVy4glnQOvmk9DqRdJS6rorxHVDPbTuaQNO1rQaQRMADTqIDJuDdtwb7Cs1U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2485:0:b0:5ce:2aa:8988 with SMTP id
 k127-20020a632485000000b005ce02aa8988mr221950pgk.4.1706808523492; Thu, 01 Feb
 2024 09:28:43 -0800 (PST)
Date: Thu, 1 Feb 2024 09:28:41 -0800
In-Reply-To: <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240123221220.3911317-1-mizhang@google.com> <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com> <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
Message-ID: <ZbvUyaEypRmb2s73@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024, Mingwei Zhang wrote:
> On Wed, Jan 31, 2024 at 9:02=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle=
.com> wrote:
> > On 1/31/24 07:43, Sean Christopherson wrote:
> > > On Tue, Jan 23, 2024, Mingwei Zhang wrote:
> > >> Fix type length error since pmu->fixed_ctr_ctrl is u64 but the local
> > >> variable old_fixed_ctr_ctrl is u8. Truncating the value leads to
> > >> information loss at runtime. This leads to incorrect value in old_ct=
rl
> > >> retrieved from each field of old_fixed_ctr_ctrl and causes incorrect=
 code
> > >> execution within the for loop of reprogram_fixed_counters(). So fix =
this
> > >> type to u64.
> > >
> > > But what is the actual fallout from this?  Stating that the bug cause=
s incorrect
> > > code execution isn't helpful, that's akin to saying water is wet.
> > >
> > > If I'm following the code correctly, the only fallout is that KVM may=
 unnecessarily
> > > mark a fixed PMC as in use and reprogram it.  I.e. the bug can result=
 in (minor?)
> > > performance issues, but it won't cause functional problems.
> >
> > My this issue cause "Uhhuh. NMI received for unknown reason XX on CPU X=
X." at VM side?
> >
> > The PMC is still active while the VM side handle_pmi_common() is not go=
ing to handle it?
>=20
> hmm, so the new value is '0', but the old value is non-zero, KVM is
> supposed to zero out (stop) the fix counter), but it skips it. This
> leads to the counter continuously increasing until it overflows, but
> guest PMU thought it had disabled it. That's why you got this warning?

No, that can't happen, and KVM would have a massive bug if that were the ca=
se.
The truncation can _only_ cause bits to disappear, it can't magically make =
bits
appear, i.e. the _only_ way this can cause a problem is for KVM to incorrec=
tly
think a PMC is being disabled.

And FWIW, KVM does do the right thing (well, "right" might be too strong) w=
hen a
fixed PMC is disabled. KVM will pause the counter in reprogram_counter(), a=
nd
then leave the perf event paused counter as pmc_event_is_allowed() will ret=
urn
%false due to the PMC being locally disabled.

But in this case, _if_ the counter is actually enabled, KVM will simply rep=
rogram
the PMC.  Reprogramming is unnecessary and wasteful, but it's not broken.

Side topic, looking at this code made me realize just how terrible the name=
s
pmc_in_use and pmc_speculative_in_use() are.  "pmc_in_use" sounds like it t=
racks
which PMCs have perf_events, and at first glance at kvm_pmu_cleanup(), it e=
ven
_looks_ like that's the case.  But kvm_pmu_cleanup() is _skipping_ PMCs tha=
t are
not "in use".  And conversely, there is nothing speculative about checking =
the
local enable bit for a PMC.

I'll send patches to rename pmc_in_use to pmc_accessed, and pmc_speculative=
_in_use()
to pmc_is_locally_enabled().

As for this one, unless someone spends the time to prove me wrong, it's des=
tined
for 6.9 with a changelog that says the bug is likely benign.

