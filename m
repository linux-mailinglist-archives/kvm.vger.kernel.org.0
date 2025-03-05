Return-Path: <kvm+bounces-40108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD94A4F37F
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3ABB188D696
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6F113B2A9;
	Wed,  5 Mar 2025 01:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cB1NH5af"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847431EB3E
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137748; cv=none; b=c7qkNo96Vb5Ri9H1XjejG4UY376dS3804Yn/UU4iYmsHkuVWlwXMPLrjtd8arJFxUayod0tBRG7XHNqWoFgf0SzvLdAg1e8e6MnhBvIx95i9AgitOsusrgfxOkZBzjJpd0UwO9wAy9jCqQ/lh9dO8XCEDpft7zhFAYpD6x2SXUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137748; c=relaxed/simple;
	bh=wFxT9RQ0sb9pLM9Y/U7MV7va8rolltG9neGjNrYNxm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZjROGxtTBeOXLyUviptlqzkoV3OTRl8ifVLkgH8x46p2/r0VAoTdqcWWnNBRPeDYoY6lBYXPcX9/b+rN1QtMk9kI2TAVC/PQHuUcU0heaZNbj4tlkC6+m79U3Y8fe9u3eST1cfaLcML34nfkmbSzFmKKqQY4kHZuObqtRIeBD08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cB1NH5af; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2feb47c6757so10280700a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741137747; x=1741742547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCS/nNw6mNxVSNW6ZyvtCA2C5M73+qL9HLBJBSb59yY=;
        b=cB1NH5afP6cYoBEEFvY6aDPfmVyNUKx2f3FcCFFWAdxJIdlSW+8W25Bnbhs5trFdtt
         cC2o52dAvkMGUF/u6B/Tny+MBV9Qke1WACNPGxcWEcDfpvSUvTF5TSO5eTX7zMzczVwy
         QW4lhoW27Sw73E2+WYrYKlWubWr0tdeqOTJ8SiPrUHY4aEao1cYHwsU5Sr/4EPGM3Fxl
         ww4W1IWvsvu3MUkCslqRGLfYWhkfg7qHv8Z1zxk5UROtwf6/PFz+65JSyWnRJevf7eFO
         SYoVjYNXZZlqFZ2X6KyGjzMqPwinJRsFB2h7D8/ckn/YWXqjPkihVeIRNg8+t4pkE6ab
         K0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741137747; x=1741742547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCS/nNw6mNxVSNW6ZyvtCA2C5M73+qL9HLBJBSb59yY=;
        b=B+nqFSXOKlGYeRRDFgGJnARTAis4fTMvntxz4At2jGfAtiNVtW2iEYob7m7lgV1BGu
         mdfyQWln8jgpl/043RhHm8K7UOBh1JQfdpuDEZwBYtqXIvGIU70eqry/tqIlM+HjfXCh
         KnSHtYTL6c6D9kLdap5WehjKjZ5CAjzkpurHUH4zHRaDYYC2n1d171fYXtmESN5ujq0t
         lNCWJLnkvVkqEiqV/XTJxHuyKR8BbuHfhbLdU16s8ISYX1TUspd9zaqcRmnVWXO/OIrv
         fvGD5INW3A/s3EiR7Qy+AmCe9tKilbtz/WANPYmn8w+PcpcLoUwK6SEpsgiPADNhL6mH
         74FQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3Q0tXqg2pPUTzgxA31S+3oqj925UuKQwZVU5aihdZGRCIz7dLOmf1v9rpjA50+f3Re5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgwFvwkhujH3is0yUoBdI7GfW0Jx0lhEsTzAFbisW8GuaG98VL
	iAkyl1MexEP+7ugYXaNpEZ2tF8j7ad2EHdOw7zV7sXPNwpMnGUPhcQVyHZAYMVvoYhFL7JygDeY
	T5w==
X-Google-Smtp-Source: AGHT+IGJYp2ZLl5wcmz8t5mtTOoaetyDIG/yhDzE4zTGYRR+kewQEAAmX8rVAMwffKV4YIgqaMx4Mf/Jkw0=
X-Received: from pjf14.prod.google.com ([2002:a17:90b:3f0e:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2413:b0:2ff:4bac:6fa2
 with SMTP id 98e67ed59e1d1-2ff4bac7163mr971273a91.16.1741137746768; Tue, 04
 Mar 2025 17:22:26 -0800 (PST)
Date: Tue, 4 Mar 2025 17:22:25 -0800
In-Reply-To: <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com> <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>
Message-ID: <Z8enUUXhfRTr7KCf@google.com>
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com, 
	sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com, 
	like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org, 
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com, 
	davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Xiaoyao Li wrote:
> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> > Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
> > there is no way to fully disable KVM AMD PMU virtualization. Neither
> > "-cpu host,-pmu" nor "-cpu EPYC" achieves this.
> 
> This looks like a KVM bug.

Heh, the patches you sent do fix _a_ KVM bug, but this is something else entirely.

In practice, the KVM bug only affects what KVM_GET_SUPPORTED_CPUID returns when
enable_pmu=false, and in that case, it's only a reporting issue, i.e. KVM will
still block usage of the PMU.

As Dongli pointed out, older AMD CPUs don't actually enumerate a PMU in CPUID,
and so the kernel assumes that not-too-old CPUs have a PMU:

	/* Performance-monitoring supported from K7 and later: */
	if (boot_cpu_data.x86 < 6)
		return -ENODEV;

The "expected" output:

   Performance Events: PMU not available due to virtualization, using software events only.

is a long-standing workaround in the kernel to deal with lack of enumeration.  On
top of explicit enumeration, init_hw_perf_events() => check_hw_exists() probes
hardware to see if it actually works.  If an MSR is unexpectedly unavailable, as
is the case when running as a guest, the kernel prints a message and disables PMU
usage.  E.g. the above message is specific to running as a guest:

	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
		pr_cont("PMU not available due to virtualization, using software events only.\n");

From the KVM side, because there's no CPUID enumeration, there's no way for KVM
to know that userspace wants to completely disable PMU virtualization from CPUID
alone.  Whereas with Intel CPUs, KVM infers that the PMU should be disabled by
lack of a non-zero PMU version, e.g. if CPUID.0xA is omitted.

> Anyway, since QEMU can achieve its goal with KVM_PMU_CAP_DISABLE with
> current KVM, I'm fine with it.

Yeah, this is the only way other than disabling KVM's PMU virtualization via
module param (enable_pmu).

