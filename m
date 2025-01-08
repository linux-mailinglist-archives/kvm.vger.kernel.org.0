Return-Path: <kvm+bounces-34804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7B8A062EC
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96012188AF17
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 17:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2813B202C4A;
	Wed,  8 Jan 2025 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1zAdsskX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D0C200120
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736355758; cv=none; b=p3bUO4DrXfN+zHYWNEE8l3vCv7uq5pLNs7TnbJOyPwfPaLW6oWtTGr9aDKtGHJsrqP3VDb7Q12d30c7Bec+9DmTc8XiulR4JABXImul3Bk4/iJwZidnKx6jCWSUvtYYa6NE1nPZROaZo61sMfo3d5xEzCgU3s7IXVRV8jvfwSGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736355758; c=relaxed/simple;
	bh=0F437mfJ2df9Auz0w1t3X7ooZON62mJ6dJ3m6Z9w3bQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N47yL1QoKRtjwf5AhVFgHiCwyuLtiezZno4zQynqCdjeN/oi5/M1CAtZdfdjS/UlMMXKUc5eQzpC5fo5PVRMJAtITFH5H9XlgEkYrjieXCeZgxo6P6UlqKunsKJuPCA5X7f6Ek1yFcrOGAvUgS8/8QnbUl5fQo59uk9TWR2/tXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1zAdsskX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so45980a91.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 09:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736355756; x=1736960556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oWGOfJXeBpA+hYoCim4Gl4TweVde5GBvuzvE6PWPJug=;
        b=1zAdsskXhxqNZzcwrDMjXjhnNCmoezlyblZsdF08l/G2Q1QPy3Vg676v59+0LVThs0
         fJ08qB1JnNmnaAJgCuZIkgh9b3kpnBAx9giX0ya1ep+e8Nb5OJa/wtTPL9EyA4IPctQH
         sKM9pCBtocXbdCotW2qOhJlRptnbcSgDptNa3tD9XklWm3RmpptH6ES2UyiPw/QXykWC
         AcELj1xWDmdqda5zsNYbD3S7V8Pjyl6whow5NXnSpWiZ7qO0ANe7zvmK0R5UWU82JaYJ
         KGoxODb532CH0ck7gUSShSpmbfRdCCv6VqO7COy0jwDWb3za/Hn1cyZndyru41t5/ox+
         DiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736355756; x=1736960556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oWGOfJXeBpA+hYoCim4Gl4TweVde5GBvuzvE6PWPJug=;
        b=SbuTXWIq1FA1G7kvT8OO358RdsxvCOkj7xw2xek1YM7+p5PBTtR989qLcxjPTj9IoZ
         mutvU8/9gqmBwNqGmmwhHpEa3ETpCybrtzbazfsJjwK286isbYRuCrwLiEyKRhAMZ41n
         Ea2HmbwkZn7Sr7JepFVbLMt9o4b0Ptom43mwnKoJKRWsKErxImzKbydBYYCVVAO3SRZB
         a4GM/cLE6f8hAGW3aNn8MjMtPjvwOwhuzN9dkxryzuI1OxJQgepw6Qj7dJzQg4zEVQMQ
         LFSJZ90goZEKOMaHm0OtWx0nyxFcBppXG+cT2pRCCMFR1VfQp2EElkv76DRv1vLTMvr1
         NWUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXovqwgGDIk1pr23hdJBA/Ppf/hC6P1wNcwA2RNeBxxW35kp5xPvhLFzWBDY0QwsDQSvx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyToY7jx2NducigTzfgtr2z53WXXLIUBXaYDMUut6syfYo6e8aB
	LwyVPry1/ZJCNDN2GOP+tFdG58tllzO2bfH+jHKN9sE73HSwSv4Fk/sRcHFOCiQdStJGKLhA1es
	IVQ==
X-Google-Smtp-Source: AGHT+IFcMiWpr8ThIWscW+O4xOSlH1bKgP0p8hoq8VvU3k6Dn6eFdDHwNuDtTPplzGCT/zn8pa5ZsKmc/FU=
X-Received: from pfbf6.prod.google.com ([2002:a05:6a00:ad86:b0:725:e76f:1445])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:35c7:b0:725:ef4d:c1bd
 with SMTP id d2e1a72fcca58-72d21fcec0fmr4923399b3a.19.1736355756132; Wed, 08
 Jan 2025 09:02:36 -0800 (PST)
Date: Wed, 8 Jan 2025 09:02:34 -0800
In-Reply-To: <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250106124633.1418972-1-nikunj@amd.com> <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local> <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local> <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com> <Z36FG1nfiT5kKsBr@google.com> <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
Message-ID: <Z36vqqTgrZp5Y3ab@google.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com, 
	francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 08, 2025, Borislav Petkov wrote:
> On Wed, Jan 08, 2025 at 06:00:59AM -0800, Sean Christopherson wrote:
> > Ideally, if the TSC is the preferred clocksource, then the scheduler will use the
> > TSC and not a PV clock irrespective of STSC.  But I 100% agree with Boris that
> > it needs buy-in from other maintainers (including Paolo), because it's entirely
> > possible (likely, even) that there's an angle to scheduling I'm not considering.
> 
> That's exactly why I wanted to have this taken care of only for the STSC side
> of things now and temporarily. So that we can finally land those STSC patches
> - they've been pending for waaay too long.
> 
> And then ask Nikunj nicely to clean up this whole pv clock gunk, potentially
> kill some of those old clocksources which probably don't matter anymore.
> 
> But your call how/when you wanna do this.

I'm okay starting with just TDX and SNP guests, but I don't want to special case
SNP's Secure TSC anywhere in kvmclock or common TSC/sched code.

For TDX guests, the TSC is _always_ "secure".  So similar to singling out kvmclock,
handling SNP's STSC but not the TDX case again leaves the kernel in an inconsistent
state.  Which is why I originally suggested[*] fixing the sched_clock mess in a
generically; doing so would avoid the need to special case SNP or TDX in code
that doesn't/shouldn't care about SNP or TDX.

[*] https://lore.kernel.org/all/ZurCbP7MesWXQbqZ@google.com

> If you want the cleanup first, I'll take only a subset of the STSC set so that
> I can unload some of that set upstream.

My vote is to apply through "x86/sev: Mark Secure TSC as reliable clocksource",
and then split "x86/tsc: Switch Secure TSC guests away from kvm-clock" to grab
only the snp_secure_tsc_init() related changes (which is how that patch should
be constructed no matter what; adding support for MSR_AMD64_GUEST_TSC_FREQ has
nothing to do with kvmclock).

And then figure out how to wrangle clocksource and sched_clock in a way that is
sane and consistent.

