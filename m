Return-Path: <kvm+bounces-24446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B6F9552B1
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 212451C21C72
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF081C57B6;
	Fri, 16 Aug 2024 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="octqA8eo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E01C2316
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 21:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723844963; cv=none; b=pY+xsAIHwa+URYb5srs2NM0VtFzmZvrPr8ieX4iqoD4fmDYHzs3tN59+l5cdeZmvePm9qiU1mfz0pUK83cyiL312qfmiyopBuER/RUH8bESdCaL+r0kJ/K6SyxlW3KAwC34ldFgeP/S+Svi7SOjYk3cvqIeO6qFDQcZYh+YIlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723844963; c=relaxed/simple;
	bh=OGQ7WZrVLTJ0pBljhL5oPE+F/gv8Y+hNJQan50IpCWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SKhuQUniLAOHmB0jEkPb9bV9oXil44JFp31e8Y2YcWRwkfi+yL3/SCXx1y+HRY/rR246wwJffRIqLnTMPxJkjCJHM9P24DuYK4PTL+InopxW5obqGm7LISQ+pGm0kxtC1mOFIslxpkaTMYWZp8bYhn6SgKSKjdGK+7dpXpVOL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=octqA8eo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a28217cfecso1900368a12.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723844961; x=1724449761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cF6TDGuCzVhvL73s1WFyMM+Vfbt+o6ZdWp8+twlWiMY=;
        b=octqA8eooioiHpY4QCJkTcZoHB8qtjeWsjAVgPNBQme1sCu/Zc9Ln2aEdL+TZa+kbs
         YYI42tly7Rx0EeOAmClRtMbr/z1wduWrPICZjx4eEeoghbXljbSbTSp90S4HBGGYMJv0
         SoDGnkEh0Nio4x/LuNb5yh4QNWgTZ1ciMB1ixgqkD/g3R+4kxt+lhbikjuhomVpQwjCj
         B4WvU5bcysET4CYPD2XKdfG+VAIIdEFEFdf7jPCluXfzxa3pYfxR6Zr372Sz3qMMOUkg
         4XYrhXNKloyl2+oQuDJmK48/UQzhAfc2R1jVGDfuScNGsDOSBBSip5CLjSqtWseFk5Ja
         5IuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723844961; x=1724449761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cF6TDGuCzVhvL73s1WFyMM+Vfbt+o6ZdWp8+twlWiMY=;
        b=qTnrHs5f7N6lKwRf3Cw5xzXmpfj9r1ht4Kw3TeZsnFfyiqyLF3b9NQCb2BXYO0/4bN
         4KRhgoA4k6tV6PSd3qt8vWvQkVL8nrFympubWzMkrQfYItYyZpc0dnTSATHm8Zsglaub
         feq6m8R2iQpzGpsBsvf+u6kkF5BFh3OuUMd/Mw5NwEHVderPrKj+scJEYhPf6486fwll
         I14obibIce69yAq7tsb8Z4A6pzcbLflu7+q5QGchg3PqORs4mnUDI4vUkam47+y1NRdF
         PJnaNE28CtNv/2uuagCeudF93lbjVwwBk7jXGWEdIV/2BvYjSU6TWlb5nLHstvVng3a8
         lkeQ==
X-Gm-Message-State: AOJu0YwmDCigeHt4+Po2+N/3Fy9/YxvPbCNzQqTVFg/q9i2Y7WENb7WB
	M4a25IB0CP6urv28tbZvJir1JtaSSnldx9UIBiQ/actpzgshpPhsj18+uVvViYrc28Y7dgf4dFb
	RNQ==
X-Google-Smtp-Source: AGHT+IHYSx+l/bDu509hvMyjrwIbr08u7dqCkl8Nxs9bS1fDGCpHkw1LgDQfzzj9IkuDYKF/rMNtJesxcVo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9506:0:b0:75a:b299:85b6 with SMTP id
 41be03b00d2f7-7c978ce7e4emr7678a12.2.1723844961033; Fri, 16 Aug 2024 14:49:21
 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:49:19 -0700
In-Reply-To: <20240815123349.729017-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-2-mlevitsk@redhat.com>
Message-ID: <Zr_JX1z8xWNAxHmz@google.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ce7c00894f32..2e83f7d74591 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -302,6 +302,31 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>  		       sizeof(kvm_vcpu_stats_desc),
>  };
>  
> +
> +/*
> + * Most x86 arch MSR values which contain linear addresses like

Is it most, or all?  I'm guessing all?

> + * segment bases, addresses that are used in instructions (e.g SYSENTER),
> + * have static canonicality checks,

Weird and early line breaks.

How about this?

/*
 * The canonicality checks for MSRs that hold linear addresses, e.g. segment
 * bases, SYSENTER targets, etc., are static, in the sense that they are based
 * on CPU _support_ for 5-level paging, not the state of CR4.LA57.

> + * size of whose depends only on CPU's support for 5-level
> + * paging, rather than state of CR4.LA57.
> + *
> + * In addition to that, some of these MSRS are directly passed
> + * to the guest (e.g MSR_KERNEL_GS_BASE) thus even if the guest
> + * doen't have LA57 enabled in its CPUID, for consistency with
> + * CPUs' ucode, it is better to pivot the check around host
> + * support for 5 level paging.

I think we should elaborate on why it's better.  It only takes another line or
two, and that way we don't forget the edge cases that make properly emulating
guest CPUID a bad idea.

 * This creates a virtualization hole where a guest writes to passthrough MSRs
 * may incorrectly succeed if the CPU supports LA57, but the vCPU does not
 * (because hardware has no awareness of guest CPUID).  Do not try to plug this
 * hole, i.e. emulate the behavior for intercepted accesses, as injecting #GP
 * depending on whether or not KVM happens to emulate a WRMSR would result in
 * non-deterministic behavior, and could even allow L2 to crash L1, e.g. if L1
 * passes through an MSR to L2, and then tries to save+restore L2's value.
 */

> +
> +static u8  max_host_supported_virt_addr_bits(void)

Any objection to dropping the "supported", i.e. going with max_host_virt_addr_bits()?
Mostly to shorten the name, but also because "supported" suggests there's software
involvement, e.g. the max supported by the kernel/KVM, which isn't the case.

If you're ok with the above, I'll fixup when applying.

