Return-Path: <kvm+bounces-40104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2763FA4F337
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEFB616E93A
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403F413AD22;
	Wed,  5 Mar 2025 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BS4ZOw+o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124838634F
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741136742; cv=none; b=piBvYvAeki4+AXnudUYL6qggaJVhg2SfTDu0Km0FyLRODuVJ7y/Q/Iy3B2WANKN3vVITgvBNSSoTun1IUpQjpdSHxD2/7+tRXG0wh4g4INb/c7e9b82PLik93AxQ+c1DeTSPU1PVJsdsQZQjSSJ3646KA4OtsChQ15sADfajFGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741136742; c=relaxed/simple;
	bh=qTU8K2PWIG1V1RbO4Ak1BhgHZu1oSVP5mINIUP9TCOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fRq2CMIUJBznZvYgBM6l0PgzLuHwJLNy+XMiRjkVgxavHZv6owez01Q/WY2m2zAQsy0uagd6T9amUVDTFwBjvt91qk6k/uwf7iupsTgE/WnM8VnQT/4d8TBVFw2jKIcu55TKGczPOCrQUT49wRUICQl7k9BMOzzX08Gbrg/P9xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BS4ZOw+o; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f81a0d0a18so12082912a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741136740; x=1741741540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BR5XnJZFVFkwGJLxiaHHW5HYcb+++VvFcuEr2xoZe5k=;
        b=BS4ZOw+olRvQCKOkqlXhRaf9tYiWaAeaOwqkp+IxhurG3IbwS5QMaMmrPuPNMMTL+1
         Ahss6t0e/1M2KhveNTb+IPdVbvfgzDrAXwTG1HjlLfuc0aVuQwfBHUvhFGfWl/rSur2F
         OJ0i0DVMZTGgp9LDtN4OKF8mMoP4v51hm+pBekpJSRX8ZOy6LgnGgWGYF7SgyMnqfTDE
         6nlZPoLXiR9WwTuF6Kf60RHftv0jPmKJsCs08Mhe2aoecV7Ju/Qw8az5y47CDqn6VbGG
         LWiXJ/sPGCN4wR+0SoJlmF7AA+ISxc2KWK19+uESzcKHgCyhTZv4vqkP7MPuh5iCAufu
         n3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741136740; x=1741741540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BR5XnJZFVFkwGJLxiaHHW5HYcb+++VvFcuEr2xoZe5k=;
        b=aZvttTTVNJW3unrLKg/3g3kzS6iXeBL6nMQMSWMaT+EK/xpkwRiyTSenwxtNn8QXJU
         Cs68ALxDVMlmsBpOAUeZETiUBEm4VwdeFpbs7rPY7pcm0geo1UpRAYM0hgnmijCjYaOX
         Oysw6baOZcbtEtqUEc2eT21tb43dLn0aGDl9uRejqroeWKDcCTGhMUCCspVW1xvRC16z
         vyvsysuolJU4CjvDP/9lq4LFUfLKsNk4zfhv3NhTT+Rx+wDNjCX2CKgIU67Fii57mHSC
         BxwDI1rrs/NACPkKkgDPKOhhkr9KzjQDuSc6nmR51W2cKbDXAK+HDt2Y9yCtHWDUNFjq
         1I2g==
X-Gm-Message-State: AOJu0YzEMvK90uz7AGh4sz92OartZ6sjOf26LKve4tTp46e4xZ/+TUk2
	dUmQKholmCePTUB6IbY23++3una/goxDKi+rdMJvc2kzdWhOnC35y3R2lWxiNyxFGFMZSs6EeLh
	MBw==
X-Google-Smtp-Source: AGHT+IEgPfc6N3fp4PBiuSUOF/fXueFSpK+l5s5ONQlc7a3R9W7NXupP1/iDjCYnKuCRn/mgvD7uIz9BV8A=
X-Received: from pjbnb1.prod.google.com ([2002:a17:90b:35c1:b0:2f7:d453:e587])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258b:b0:2ee:f80c:6889
 with SMTP id 98e67ed59e1d1-2ff49856dd9mr2501980a91.33.1741136740431; Tue, 04
 Mar 2025 17:05:40 -0800 (PST)
Date: Tue,  4 Mar 2025 17:05:12 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174101578385.3894748.13921615638949593871.b4-ty@google.com>
Subject: Re: [PATCH v2 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Feb 2025 17:25:31 -0800, Sean Christopherson wrote:
> Try to address the worst of the issues that arise with guest controlled SEV
> features (thanks AP creation)[1].  The most pressing issue is with DebugSwap,
> as a misbehaving guest could clobber host DR masks (which should be relatively
> benign?).
> 
> The other notable issue is that KVM doesn't guard against userspace manually
> making a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).
> This shouldn't be super problematic, as VMRUN is supposed to "only" fail if
> the VMSA page is invalid, but passing a known bad PA to hardware isn't exactly
> desirable.
> 
> [...]

Thanks for the reviews and testing!

Applied:

[01/10] KVM: SVM: Save host DR masks on CPUs with DebugSwap
        https://github.com/kvm-x86/linux/commit/b2653cd3b75f
[02/10] KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
        https://github.com/kvm-x86/linux/commit/807cb9ce2ed9

to kvm-x86 fixes, and:

[3/10] KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+ guest has an invalid VMSA
       https://github.com/kvm-x86/linux/commit/72d12715edcd
[4/10] KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
       https://github.com/kvm-x86/linux/commit/d26638bfcdfc
[5/10] KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
       https://github.com/kvm-x86/linux/commit/745ff82199b1
[6/10] KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
       https://github.com/kvm-x86/linux/commit/c6e129fb2ad2
[7/10] KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
       https://github.com/kvm-x86/linux/commit/46332437e1c5
[8/10] KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
       https://github.com/kvm-x86/linux/commit/e268beee4a25
[9/10] KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
       https://github.com/kvm-x86/linux/commit/5279d6f7e43d
[10/10] KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
       https://github.com/kvm-x86/linux/commit/4e96f010afb2

to kvm-x86 svm.

--
https://github.com/kvm-x86/linux/tree/next

