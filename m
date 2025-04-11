Return-Path: <kvm+bounces-43169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD19A861A4
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 17:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D64F1BC2750
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 15:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6810620F07D;
	Fri, 11 Apr 2025 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmRQTAMy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A6C1F4C96
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744384792; cv=none; b=r3BTibATGZgqH6UnoCgeCR6+jJ9ehq4DBD34l4kYleRUEZ17Y7V5HpX6vqmmf+OkiKIv0K3EhqN3eXWOpyhTnNwxIlBFOipNqJx6GOLFo4jigFa30+HkYDUVNcdYnalH+GtAvm9FI5PBsD4gbLvqJV3q4/bTrwIAjMTkTWSqyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744384792; c=relaxed/simple;
	bh=+LVrTuu2BoV4qsYUdZJEg1X0y6bt0GaG1o3i23mBjR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K60uMxEdx9I09kds01y5xeNuI+c7hUNVSIpdr0iFY29Yjfrp7o9Xak5mbeD8cPNIJNLDv2izpH495ZfMb9W1KlE2TX78S0ZM2CRrK8OWfdKIim4DuE16Vr/3y4uQJKxBBhla1/IrKmIW0PsOGGY/2KdZJkB9UEQbzT+Y9jGNMqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmRQTAMy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af9070a5311so1312856a12.0
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744384790; x=1744989590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9xuF6Haal74K5Z0mLjpEBCXt1AT7vXGXP6LiOoiIU8s=;
        b=lmRQTAMyXD3Efkadqckwg8r4x6pHK0eAHJ0iolwT2ZX/CDzetB81Gh7xNODWhHcgmn
         fPujr06cnO9nvD/avnZ5nZ/HyHN2rsAL1jxWyKIppH5268+zqaMMA9PbbVwLpF2NH5HG
         VMLjGX+FoUllgR0LWYen1Op9f8R+G1ieBFG84PL+Z9++zoFtRqczWzYHkscrXqjPkvHW
         D/RbSSXVkMzPh4M5P22DpXoZC1WEztOuw7/ajAfteTRoSnwDyRy9goPmkaS334Jq7Mp4
         zYWp8FMkrsZOXwlICt9QtRP7gT2GwxYpehEowrcO1PfEmTXCEvJ5Y70Wk3YBv2cNRgnV
         JhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744384790; x=1744989590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xuF6Haal74K5Z0mLjpEBCXt1AT7vXGXP6LiOoiIU8s=;
        b=ZbmkV69Utj4Osev+oYmzMa9qdADRCPMW6kmSRlNz6h7GMmDcj/qERgt4qaTUgUMepN
         s+i5A0OYV8KqGH8BBe0TElWzkXNGyVDFRAQK8p//oN2fVe39dZephWa0CSAFaoMUaOfn
         ZVtZO9xhN7hWwKcRKnHpMDHiTs646hzSiHLL6E64iXOFyWIYmYipDOLu/uvtq+UQdaA2
         PbpMKgdNiVu8KzRNxhYDElpArLafcOn3h9ji/hfK2di1C8Lm6nv80pXtxgnQigaGrqOk
         D07P+eiLSLstnMysP10knztGLvtFo2xo8aS242dERSgLrFYoapsX0SBTuLNGF5cyMGLT
         C65g==
X-Forwarded-Encrypted: i=1; AJvYcCUwWIYAMA3IodMD3y/y99Td/P96uBQ8Xm5hETj3sMYxdsTqYYDlNUTz216PeAV9HPBJxso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3mWTnNoFtAc5Vn3jaCO+gc06T6BdNLErIzlrdqGzTSrOWnzy2
	aA0lPJ/1R4FpZQnmVOfJ2NTzx6HqqB6hJ9UEqYYQSwp/TZwGcmkemEncpm4qFCTwKYFw9FLBrqK
	I2g==
X-Google-Smtp-Source: AGHT+IEZLyIIJW2mCRYN66gUJVCR+EODdfxL3Vh7qjvrgh+Wr4kM0O7nB4eHO+R/i867XHGoDe/zX7Vl4UM=
X-Received: from pfbfq2.prod.google.com ([2002:a05:6a00:60c2:b0:739:45ba:a49a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f688:b0:215:b473:1dc9
 with SMTP id d9443c01a7336-22bea502637mr42960875ad.46.1744384790359; Fri, 11
 Apr 2025 08:19:50 -0700 (PDT)
Date: Fri, 11 Apr 2025 08:19:48 -0700
In-Reply-To: <20250411144422.GFZ_kqxnqO65es2xPs@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru> <20250411094059.GIZ_jjq0DxLhJOEQ9B@fat_crate.local>
 <Z_keAsy09KU0kDFj@google.com> <20250411144422.GFZ_kqxnqO65es2xPs@fat_crate.local>
Message-ID: <Z_kzFLUwN714lqk1@google.com>
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, babu.moger@amd.com, 
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 11, 2025, Borislav Petkov wrote:
> On Fri, Apr 11, 2025 at 06:49:54AM -0700, Sean Christopherson wrote:
> > KVM should still explicitly advertise support for AMD's flavor.  There are KVM
> > use cases where KVM's advertised CPUID support is used almost verbatim, in which
> 
> So that means the vendor differentiation is done by the user

Yes.

> and KVM shouldn't even try to unify things...?

Yeah, more or less.  KVM doesn't ever unify CPUID features, in the sense of giving
userspace one way to query support.

For better or worse, KVM does stuff feature bits for various mitigations, e.g. so
that kernels looking for just one or the other will get the desired behavior.

	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
	if (boot_cpu_has(X86_FEATURE_STIBP))
		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);

	...

	if (boot_cpu_has(X86_FEATURE_IBPB)) {
		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
		    !boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB))
			kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
	}
	if (boot_cpu_has(X86_FEATURE_IBRS))
		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
	if (boot_cpu_has(X86_FEATURE_STIBP))
		kvm_cpu_cap_set(X86_FEATURE_AMD_STIBP);
	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
		kvm_cpu_cap_set(X86_FEATURE_AMD_SSBD);
	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
		kvm_cpu_cap_set(X86_FEATURE_AMD_SSB_NO);
	/*
	 * The preference is to use SPEC CTRL MSR instead of the
	 * VIRT_SPEC MSR.
	 */
	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);

But we've generally agreed that KVM shouldn't do that going forward, because many
of the mitigations don't have strict 1:1 mappings between Intel and AMD, i.e.
deciding which bits to stuff gets dangerously close to defining policy, which KVM
definitely wants to stay away from.

> But I guess KVM isn't exporting CPUID *names* but CPUID *leafs* so the
> internal naming doesn't matter.

Yep, exactly.

