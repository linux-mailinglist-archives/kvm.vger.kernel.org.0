Return-Path: <kvm+bounces-64513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F204BC85C82
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 63EEA4E4328
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F4E1F3BAC;
	Tue, 25 Nov 2025 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d9WrdA9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC5A95E
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764084687; cv=none; b=qFN7pqmuPlBUXpuU0VCKPns1pl6WLv/64pDr/vlQgi3kYwtINnAy3vskyclso/4aPa4JKb+BrkVo3LFp2FUzQCiqQYdEiwVqTCvklUpNyMjHmN6T2aer/74+pDyniMYYTnWif9J1lP74/m7okIwBxD5tDCOj1VzJnlQ0WlnRZtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764084687; c=relaxed/simple;
	bh=YY8ndmONUZS6NcasP+quxoLIbi2kXvAyImZJXqWZPuw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L9la9sjuIjpA06jOGjO6u8fsevgER4B/fd454VRV/fPlCDQTRvSOe5GApc5kMJVYGUUNm/GLGCChceAjjBWecu9XiN2pd93Zkff/Q0f0gJWOu477lR1T2CVSQi0TZDDg/w+mZtjzjC050AZP0YssZ8oyE8mqGov3hBtBHa2nl/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d9WrdA9x; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3437b43eec4so8892427a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 07:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764084685; x=1764689485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DmWSYGu8d/geawZZhXmuFXs26yPA/DTCO8ionrRSVO8=;
        b=d9WrdA9x3TfyAu68GsFIlxuihEpLpide9YQqypDFFgy4AkQXZdbtyzI+9kmUHJYzS2
         qc2Fl4/ImL22UeDGZ6cfRdn0n1u0kG+JUEqaijZcxWFTA2eJUvg5rZtMwIUTUu0tnHzF
         M/PpHTjqiAIG1tVjn8kKjn+Md04DPnsOneKx/KWClc/Xr36252Jc3bmwaAYWzeRKdgBp
         3bPZi38LcGczwtR703EVmJHF1HTY2FEBxzFLZMYRLhx0/WIOkiYQ5qbEsZD5puoCZr7q
         L2Fnq8VdqTByHmlHuhHPZqLnnXa30fohkJn1UWj7CHt232p/+7NhIRCbqTRxavDM93Mq
         BXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764084685; x=1764689485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmWSYGu8d/geawZZhXmuFXs26yPA/DTCO8ionrRSVO8=;
        b=j3YwMPEu6PrRmRbJAugL/o9fwZXtsZzDwZ1Cs0Yu8v0DIc0AvaMoKe/IfbV46n9dAZ
         7Eb1wEyjkyiFwddLS/VPq70GKmN03afkHP0eLWSbQ5G4PV+ZRrtOHFqB98BSDwS02KO0
         fiX2xXvC4jkqHlsJNvoUtVwl3bdtr2b4qdd4Se5qi2IpqjE/99s8ok1O/ExlNfYOpe2x
         P15cbFsWStwORyL23TR/gGvi60FfOqFkngwuR8xKZs5EEssFbNWOAZS+FoYhsKDqxVz2
         zVJH/dQidcR9PlGqHbaacgaXZXvIavoBOdNObic0FUgwFzyPgZEvM+i1nU6wX+BdTui3
         3NzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYIQUx2c+bJ9ZiplWsQ8/CNXZnQRyV8tyO6MNpgs10ht3J9/MqTDwsMDTOJzjSsG0iQZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSgnf/yruhEb51P6YhIgDcGzFrJ3yWusBuKV7ZW9MkDl0nkIgx
	143zsRIpxI+J/E1KTnalXIBBs5QNObb/hEUOSoNGgleEsWUV3bbldpWVBjnYCpOK4zj2fLNDGCo
	rQFgZ9g==
X-Google-Smtp-Source: AGHT+IGqEMSEx4f2R1GE+drf+UXVd7hSxzb0FixozSFQiMvVbNXTvXSfsE7HJar9IDlW366CbRXB3S5xlJk=
X-Received: from pjbqe14.prod.google.com ([2002:a17:90b:4f8e:b0:343:5259:2292])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5450:b0:330:82b1:ef76
 with SMTP id 98e67ed59e1d1-34733f350cdmr16791323a91.28.1764084685059; Tue, 25
 Nov 2025 07:31:25 -0800 (PST)
Date: Tue, 25 Nov 2025 07:31:23 -0800
In-Reply-To: <20251125152013.433803-1-chelsyratnawat2001@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251125152013.433803-1-chelsyratnawat2001@gmail.com>
Message-ID: <aSXLyxvBvXvEhRpm@google.com>
Subject: Re: [PATCH] KVM: x86: Fix potential NULL dereference in amd_pmu_refresh()
From: Sean Christopherson <seanjc@google.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 25, 2025, Chelsy Ratnawat wrote:
> kvm_find_cpuid_entry_index() can return NULL if the guest CPUID
> entry is missing, but amd_pmu_refresh() was dereferencing the pointer
> without checking. This could cause a kernel crash.
> 
> Add a NULL check and fallback to AMD64_NUM_COUNTERS_CORE if the
> entry is missing.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index bc062285fbf5..aa8313fa98c9 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -178,6 +178,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	union cpuid_0x80000022_ebx ebx;
> +	struct kvm_cpuid_entry2 *entry;
>  
>  	pmu->version = 1;
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFMON_V2)) {
> @@ -188,8 +189,13 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  		 */
>  		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
>  			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
> -		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;

Heh, me thinks you didn't read the comment above the BUILD_BUG_ON():

		/*
		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
		 * CPUID entry is guaranteed to be non-NULL.
		 */
		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);

Yes, it's weird and confusing to subtly rely on entry 0x80000022 being non-NULL,
but doing so means KVM doesn't have to provide arbitrary fallback logic for a
scenario that can't happen.

