Return-Path: <kvm+bounces-32091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E14179D2EA9
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A35CAB305E8
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72F81D26FE;
	Tue, 19 Nov 2024 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXMYaDS8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B751D131B
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732042693; cv=none; b=kkB5UCgjfnsycvTadqL/0oQwXmbCnKBXcfM6QRHCv6Og5c8UJU78q3hyEAzJ110pNgz8PqdlDO1lo2CCgHKkxrVvY79ocMtKLWOQ4Clrw+9Jk2Y2y3AB0QBsO8krAbjFETMv+zuJjyzjH95NoXd2128MlI+2aPUVES7rJndlxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732042693; c=relaxed/simple;
	bh=CaYHRLlMx9K3LpAcOJBVj9TCZ1ssxrlQJHunKlqrLME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKiqfXwxtHRuWJSkWYLmdO/VWYL5Tju4r9q2Xmr8RD28so81BfbCviBSZxuKasqyHXz4VuigaSK+AO7lWyQ7tNOQr+T9nexUAWgneNq7IkICQaX8AIW6GwtTVZGdSjw4ZaMyYFsEOktGUcpAltSL9cDY7Epqlmpw3CIV/U7+r6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXMYaDS8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e7858820eso4835493b3a.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732042691; x=1732647491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG7IW976n3LuBX649AhgR5w6x9Lne3c1qlRCMTLNQN4=;
        b=EXMYaDS8IIljAcsoUxuHJEMhkoS190+ofWY82ilvULcC0b1VNuQTFo1C6At5VhSXhx
         kvTa1EDgTlQ2Cm5tct5o4IX6sBdJKzxP6iUs2bXrBt1yQn3/vlaGHCvMNxE+dCqucidW
         d53sTI9WIzZWGYkhR9HjIC0QMuSzHKRfGjQ5slvDn3pEMS2xxb2fYHtluoyFj19dvfj0
         tAeKQDqGpCF/FThwCRoQwPYY9aY3n4Ck13Drc0rHjL5G5WPnbfAUZNmHnDpC9CqC1Kqn
         vBEiaeH+muRa62vzwgeaMD9HRX01JQQGC96pItWY7/D66A3xN1S+91oFujsDZSCAcfCT
         fwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732042691; x=1732647491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JG7IW976n3LuBX649AhgR5w6x9Lne3c1qlRCMTLNQN4=;
        b=bdj6AwQ5Sv/09Ffx8reOYyMaUjIgA+ksldC29ezem/vdTxjpJx5Fu0ii4SJI2CQXn3
         64WvXQgUENdNXqvvFtanu6wJtrsTiTsQfz9u5tA8jM9tslYV6Ctw8/McUODzUzPyvxMB
         skjNG9nYfkMVA3XPlIJHv59aFCGBwviEea+aK54nI5OKE7wRpSZb//Bc8qwuGYKgfbq3
         A3RdmT299usss2/Du65jBsbF0vtqWsHUbQv196GPb+yPxCI7S+YsVd3IoGvjlvRw7J5u
         G5na39TFx5CSw+F2r0hruag6eSZRN7EzfbS0pvxUP4LzkG31enIfKP+qREl+TX4l1zp5
         nzVA==
X-Forwarded-Encrypted: i=1; AJvYcCWFr7aw6Ku88sklhGMMUbYrhgNfio4c/o/35CxjZydQw0Ly7cdcx54D50GkM2ES7oUO1L8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1kbQMnNrKMG3oj5YXkKkUTEFzPrvw3jFBz8Eva6GKI+zvDCdG
	on1Jx8HFP9nzcixXaKZVy+z37B79oAoE3u5ZW7vBas6x2NXhWW6glIxHnKy/NJStw4vuAD874iG
	ANg==
X-Google-Smtp-Source: AGHT+IGh3uwc4FqgofMvnZ95XtOkh7u8u7xHwAaxoNHCP5bZH7ShLaMyJ8JrAlCfywT8H8d0O+ZA7pn99Tg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:2311:b0:212:475e:2e8f with SMTP id
 d9443c01a7336-212475e37camr121295ad.9.1732042690706; Tue, 19 Nov 2024
 10:58:10 -0800 (PST)
Date: Tue, 19 Nov 2024 10:58:09 -0800
In-Reply-To: <20240801045907.4010984-32-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-32-mizhang@google.com>
Message-ID: <ZzzfwXefHP7SG-Vy@google.com>
Subject: Re: [RFC PATCH v3 31/58] KVM: x86/pmu: Add counter MSR and selector
 MSR index into struct kvm_pmc
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Please squash this with the patch that does the actual save/load.  Hmm, maybe it
should be put/load, now that I think about it more?  That's more consitent with
existing KVM terminology.

Anyways, please squash them together, it's very difficult to review them separately.

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Add the MSR indices for both selector and counter in each kvm_pmc. Giving
> convenience to mediated passthrough vPMU in scenarios of querying MSR from
> a given pmc. Note that legacy vPMU does not need this because it never
> directly accesses PMU MSRs, instead each kvm_pmc is bound to a perf_event.
> 
> For actual Zen 4 and later hardware, it will never be the case that the
> PerfMonV2 CPUID bit is set but the PerfCtrCore bit is not. However, a
> guest can be booted with PerfMonV2 enabled and PerfCtrCore disabled.
> KVM does not clear the PerfMonV2 bit from guest CPUID as long as the
> host has the PerfCtrCore capability.
> 
> In this case, passthrough mode will use the K7 legacy MSRs to program
> events but with the incorrect assumption that there are 6 such counters
> instead of 4 as advertised by CPUID leaf 0x80000022 EBX. The host kernel
> will also report unchecked MSR accesses for the absent counters while
> saving or restoring guest PMU contexts.
> 
> Ensure that K7 legacy MSRs are not used as long as the guest CPUID has
> either PerfCtrCore or PerfMonV2 set.
> 
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/svm/pmu.c          | 13 +++++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c    | 13 +++++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4b3ce6194bdb..603727312f9c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -522,6 +522,8 @@ struct kvm_pmc {
>  	 */
>  	u64 emulated_counter;
>  	u64 eventsel;
> +	u64 msr_counter;
> +	u64 msr_eventsel;

There's no need to track these per PMC, the tracking can be per PMU, e.g.

	u64 gp_eventsel_base;
	u64 gp_counter_base;
	u64 gp_shift;
	u64 fixed_base;

Actually, there's no need for a per-PMU fixed base, as that can be shoved into
kvm_pmu_ops.  LOL, and the upcoming patch hardcodes INTEL_PMC_FIXED_RDPMC_BASE.
Naughty, naughty ;-)

It's not pretty, but 16 bytes per PMC isn't trivial. 

Hmm, actually, scratch all that.  A better alternative would be to provide a
helper to put/load counter/selector MSRs, and call that from vendor code.  Ooh,
I think there's a bug here.  On AMD, the guest event selector MSRs need to be
loaded _before_ PERF_GLOBAL_CTRL, no?  I.e. enable the guest's counters only
after all selectors have been switched AMD64_EVENTSEL_GUESTONLY.  Otherwise there
would be a brief window where KVM could incorrectly enable counters in the host.
And the reverse that for put().

But Intel has the opposite ordering, because MSR_CORE_PERF_GLOBAL_CTRL needs to
be cleared before changing event selectors.

And so trying to handle this entirely in common code, while noble, is at best
fragile and at worst buggy.

The common helper can take the bases and shift, and if we want to have it handle
fixed counters, the base for that too.

