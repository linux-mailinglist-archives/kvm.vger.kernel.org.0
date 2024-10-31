Return-Path: <kvm+bounces-30205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA38C9B800D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EBFD283A6C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFC61BDA99;
	Thu, 31 Oct 2024 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LOU5OBPZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CAB1BC099
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392043; cv=none; b=flzTsk7PF3IhPggQMc1mmHWl29RFKVRmkzwlO+EsBGVN3oiN0D8Es9fCb7TX6pZYJrxT9ODHX8SCYLYL1ubTa1K0Z+fPUf0m2yRQG5KXXcqEYBItP+ZDtPGEGXetDe2U7wNCzTP0oAvWTuwpOO6J5Oc/Q9A4du5ZUkB5174f9gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392043; c=relaxed/simple;
	bh=NU0xaNlNHGmQK844TSiXuj7X7LIE06A9gv89YXL980A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UOOrXF7XCFsnxpggfWbhZYHgI0UQGB9oQMvmQzrCxzE0jyiRw4KO6ReF8qjaBe36Rh/zf75l64XPXvHBiiLxNRvSEb7EBqerWKcHrEL7nKvPN+bape8tGOZOZ/hYDQe+JDQ6udBAkWM306v6AjREBHyvYWBMmCov1b3m+PGNOSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LOU5OBPZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29205f6063so1719220276.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 09:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730392039; x=1730996839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=htdto3GIHZjF9NL40XLaFDklPXk3MFHaGDKHh7lyDhU=;
        b=LOU5OBPZCwQ5iAoVwdK3D1TD2xjn2WRD3mZQ+w2ba27CfTsUlcKqx0GHwYi/ZnWt1t
         PeX3zRMC7N08oVkRvqwFKWr74pZw9CJf8LRNacbphbwnF3HAw3L4UY8aWwzdqsuCACi4
         cwBJV4h7r5hSN3sDC0Bt53gFyZ1xhex+om4RWKdULsCweWTwpWxIlpX2vTq5HRC3EC3k
         tPtOY4f0dMaIcKZ3D07ezduFkjwDD8jJE92IPH9nL7Lrwc6OjP2geq8xVyOvA17mVHOs
         1Ds1npT6Euzjvobccg/HKftvewLli7gg+mXgaIkNaI06eFxbHm2S5MoBcP8rVrjvVYCM
         5Tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730392039; x=1730996839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htdto3GIHZjF9NL40XLaFDklPXk3MFHaGDKHh7lyDhU=;
        b=oTMLy0Gs2n1eWvsvyKYaBIw+gyRTwFQaaLJ3E/8GdW0Cf0I7nB3wP/BULdsHkcJ3tv
         BcIdoSG3hSF04R+AGUhZxq7eEtp3RLdp772Dfxruo9OImWlPdnjJpeQb/KNnBhc0fg4J
         Ib/DTpX8L7l5UfaUejrBeGg0bPYO/3vGEByZcCpcIekT26cVf/K4Nr+EoU0hl4Lc95oo
         AThzDl8edttf/Thy2Rj1+320S1VetKg25lk++4cAu8RweDvWVi/n6anbuIt+Jy0pn4OU
         EfOI1NHngEeXnORSq5MVJMyiG2bB7m/gYy48ri/tshwj9hA32+EQ1gY/5glMjAzDbISh
         5ksQ==
X-Gm-Message-State: AOJu0YzJloi8hKGCzBloPzC79hTYQ+zuf2/HfRJvjZ7PoFxUp9RP6gpk
	uPyHLC6dc2T+EE0a5jVwPV/rmQiihFWOVlEOxKvBRrpDnqLUQbvZO4+Ww3m2sIBVhmIR95WSda+
	dcA==
X-Google-Smtp-Source: AGHT+IH9PK36u636nwxFPXdS66ZnSfGY1YetAREPu6oHLX8U7RtYCb075OWMHk0HfgZtYlvRJ+T+jRRWWLs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:df8e:0:b0:e30:d896:dde3 with SMTP id
 3f1490d57ef6-e33026cf50fmr1278276.11.1730392039328; Thu, 31 Oct 2024 09:27:19
 -0700 (PDT)
Date: Thu, 31 Oct 2024 16:27:17 +0000
In-Reply-To: <11787a92-66ed-41ef-9623-d6c7220fb861@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com>
 <20240905124107.6954-3-pratikrajesh.sampat@amd.com> <Zw2fW2AJU-_Yi5U6@google.com>
 <4984cba7-427a-4065-9fcc-97b9f67163ed@amd.com> <Zx_QJJ1iAYewvP-k@google.com>
 <71f0fb41-d5a7-450b-ba47-ad6c39dce586@amd.com> <ZyI4cRLsaTQ3FMk7@google.com>
 <de2a6758-a906-4dc0-b481-6ce73aba24b9@amd.com> <ZyJzcOCPJstrumbE@google.com> <11787a92-66ed-41ef-9623-d6c7220fb861@amd.com>
Message-ID: <ZyOv5US9u22lAiPU@google.com>
Subject: Re: [PATCH v3 2/9] KVM: selftests: Add a basic SNP smoke test
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Pratik R. Sampat wrote:
> Hi Sean,
> 
> On 10/30/2024 12:57 PM, Sean Christopherson wrote:
> > On Wed, Oct 30, 2024, Pratik R. Sampat wrote:
> >> On 10/30/2024 8:46 AM, Sean Christopherson wrote:
> >>> +/* Minimum firmware version required for the SEV-SNP support */
> >>> +#define SNP_FW_REQ_VER_MAJOR   1
> >>> +#define SNP_FW_REQ_VER_MINOR   51
> >>>
> >>> Side topic, why are these hardcoded?  And where did they come from?  If they're
> >>> arbitrary KVM selftests values, make that super duper clear.
> >>
> >> Well, it's not entirely arbitrary. This was the version that SNP GA'd
> >> with first so that kind of became the minimum required version needed.
> >>
> >> I think the only place we've documented this is here -
> >> https://github.com/AMDESE/AMDSEV/tree/snp-latest?tab=readme-ov-file#upgrade-sev-firmware.
> >>
> >> Maybe, I can modify the comment above to say something like -
> >> Minimum general availability release firmware required for SEV-SNP support.
> > 
> > Hmm, so if AMD says SNP is only supported for firmware version >= 1.51, why on
> > earth is that not checked and enforced by the kernel?  Relying on userspace to
> > not crash the host (or worse) because of unsupported firmware is not a winning
> > strategy.
> 
> We do check against the firmware level 1.51 while setting things up
> first (drivers/crypto/ccp/sev-dev.c:__sev_snp_init_locked()) and we bail
> out if it's otherwise. From the userspace, calls to KVM_SEV_INIT2 or any
> other corresponding SNP calls should fail cleanly without any adverse
> effects to the host.

And I'm saying, that's not good enough.  If the platform doesn't support SNP,
the KVM *must not* advertise support for SNP.

> From the positive selftest perspective though, we want to make sure it's
> both supported and enabled, and skip the test if not.

No, we want the test to assert that KVM reports SNP support if and only if SNP
is 100% supported.

> I believe we can tell if it's supported by the platform using the MSR -
> MSR_AMD64_SEV_SNP_ENABLED or the X86_FEATURE_SEV_SNP from the KVM
> capabilities. However, to determine if it's enabled from the kernel, I
> made this check here. Having said that, I do agree that there should
> probably be a better way to expose this support to the userspace.
> 
> Thanks
> Pratik

