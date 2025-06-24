Return-Path: <kvm+bounces-50547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A712AE6FED
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C6813AEBF2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840532EE27B;
	Tue, 24 Jun 2025 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kGmKdgch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2142D2E92B1
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794109; cv=none; b=TYZRwlVBpqmbf9aFjaFiM+geawBI1/WBwUQrqkB5N7kFXsKMfZCmpaphjJoIUP7HQa/xyXV0sX1RUCU5JX/anGaKyO3l6wHKca6uPvTuRA0R7tqwOmqNoQPH25i97yflDl1F8BSLNsyUIudD+GrDjto5VQtOVHiFhT8ClNmhYHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794109; c=relaxed/simple;
	bh=FTTRIldhGkByLvjO2kxWvCHu0NM0nVVVeJJdj3ADGzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JDI8poC78UK1qi3ZTfrYKfv7Z7j1dSqEKAbCCe5rVEYQ7s3vHTtp0+89kEjRdixnUOb/lO5fUu694+Wy8BxwoTbqziJ0GSgiJRz7WhoqQ5GLWQyyF6aTc4vpTxShO2mrr+EUxeY7FYHJHltVFJLxVs+XPklQoHPqqps6SsSnxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kGmKdgch; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235f6b829cfso49265005ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794107; x=1751398907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OnEd2xV3VxW/TvoPWA9aDKAYF8qpz72nxTYDpmjJX/4=;
        b=kGmKdgch9AtqzaDvhUf0/ymZ6DcTOAhaPz1ZN7X4GYl0X3bdGYjZDhd4QQPzSOUY/P
         X2DyzVClPuaqO8akjzBzPfLnUNnX5kRT2mttA6gru5D/cN+GjLj2STs4VklnHz6fGPxG
         svbzUjqbIAij3bO4Dzzrd/D8R1qKQrpx/8u0TyPlDSkEk/jjdMdyOovgfhuVkNxGkK7P
         La2qN+yZ2bzwpRWrztLhGH95J+FbJgRyveTp1o+51p01GjiA536PcMtJB5b8XFhcngua
         +sSvfklov8h4aa4ovghj0t+lz5rBz0t/CpM4wPZY9GS1dG5Kl3I2JgrXQg0DUtj1L9le
         y4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794107; x=1751398907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OnEd2xV3VxW/TvoPWA9aDKAYF8qpz72nxTYDpmjJX/4=;
        b=vacAHrwFQvy1CgVhC1tkBzEmZVAanGlUUBJJKDACREzZXm90YF/yCOxSTbobtwwUy8
         HbuuObZQ4j2A7XcR+0DiLvZCz6tE+81Oog8b57sT3STFkPsCIcn4LMHNaRMPsImf/YO2
         c2IdBXEwvK1YDvY5+XxvPYK5dC/Cwc+tugn4sco7TkKJRyeQJOT32FizfZdhygIZgvoG
         KY9N3W47zCVNJ0tRurynq8Y1VekYy0U4yscEHk+PrlgxPr/2drmbrNLCg8azYiPrLzLz
         n1sh+xi57DE9wYa0inaoQvjTBcQVCq/C6Mc0egGVZuDvHC9N2OS/dw8zIlOteFdyJKdG
         wnsQ==
X-Gm-Message-State: AOJu0Yy5Vzc70q+R/rY+lvACRGkOOka4I5Xhd6m41ZgJ8kUDSoVZo1EI
	rVgKHmA2WUc+xHVo52z3xW4E/GRxH/2o3VTIlb8rfMNDPvW4r+ofu9BA4L/XmZDjRxdy3BdngeD
	kVmY8vw==
X-Google-Smtp-Source: AGHT+IEJB9G+bAtW22AFPU+en9HzYU77bZJ3ZLcUmffMymYS1bchY8w1qMGeDjuTE5uzJxDnW9TJ3JknT2w=
X-Received: from pgbda1.prod.google.com ([2002:a05:6a02:2381:b0:b31:c299:6723])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec91:b0:235:7c6:ebbf
 with SMTP id d9443c01a7336-23824047541mr9989625ad.35.1750794107362; Tue, 24
 Jun 2025 12:41:47 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:32 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079324569.521185.10145114338048189462.b4-ty@google.com>
Subject: Re: [PATCH v2 00/32] KVM: x86: Clean up MSR interception code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 10 Jun 2025 15:57:05 -0700, Sean Christopherson wrote:
> Clean up KVM's MSR interception code (especially the SVM code, which is all
> kinds of ugly).  The main goals are to:
> 
>  - Make the SVM and VMX APIs consistent (and sane; the current SVM APIs have
>    inverted polarity).
> 
>  - Eliminate the shadow bitmaps that are used to determine intercepts on
>    userspace MSR filter update.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/32] KVM: SVM: Disable interception of SPEC_CTRL iff the MSR exists for the guest
        https://github.com/kvm-x86/linux/commit/674ffc650351
[02/32] KVM: SVM: Allocate IOPM pages after initial setup in svm_hardware_setup()
        https://github.com/kvm-x86/linux/commit/fb96d5cf0fda
[03/32] KVM: SVM: Don't BUG if setting up the MSR intercept bitmaps fails
        https://github.com/kvm-x86/linux/commit/5ebd73730832
[04/32] KVM: SVM: Tag MSR bitmap initialization helpers with __init
        https://github.com/kvm-x86/linux/commit/f886515f9ba2
[05/32] KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
        https://github.com/kvm-x86/linux/commit/b241c50c4e30
[06/32] KVM: SVM: Kill the VM instead of the host if MSR interception is buggy
        https://github.com/kvm-x86/linux/commit/6353cd685c69
[07/32] KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
        https://github.com/kvm-x86/linux/commit/b1bccf788390
[08/32] KVM: SVM: Massage name and param of helper that merges vmcb01 and vmcb12 MSRPMs
        https://github.com/kvm-x86/linux/commit/925149b6d054
[09/32] KVM: SVM: Clean up macros related to architectural MSRPM definitions
        https://github.com/kvm-x86/linux/commit/16e9584cc0a8
[10/32] KVM: nSVM: Use dedicated array of MSRPM offsets to merge L0 and L1 bitmaps
        https://github.com/kvm-x86/linux/commit/9b72c3d59f42
[11/32] KVM: nSVM: Omit SEV-ES specific passthrough MSRs from L0+L1 bitmap merge
        https://github.com/kvm-x86/linux/commit/f21ff2c8c997
[12/32] KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's "always passthrough"
        https://github.com/kvm-x86/linux/commit/4879dc9469e6
[13/32] KVM: SVM: Add helpers for accessing MSR bitmap that don't rely on offsets
        https://github.com/kvm-x86/linux/commit/c38595ad69ce
[14/32] KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
        https://github.com/kvm-x86/linux/commit/6b7315fe54ce
[15/32] KVM: SVM: Pass through GHCB MSR if and only if VM is an SEV-ES guest
        https://github.com/kvm-x86/linux/commit/3a0f09b361e1
[16/32] KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
        https://github.com/kvm-x86/linux/commit/cb53d079484c
[17/32] KVM: x86: Move definition of X2APIC_MSR() to lapic.h
        https://github.com/kvm-x86/linux/commit/405a63d4d386
[18/32] KVM: VMX: Manually recalc all MSR intercepts on userspace MSR filter change
        https://github.com/kvm-x86/linux/commit/8a056ece45d2
[19/32] KVM: SVM: Manually recalc all MSR intercepts on userspace MSR filter change
        https://github.com/kvm-x86/linux/commit/160f143cc131
[20/32] KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
        https://github.com/kvm-x86/linux/commit/4ceca57e3f20
[21/32] KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it intercepts specific
        https://github.com/kvm-x86/linux/commit/049dff172b6d
[22/32] KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
        https://github.com/kvm-x86/linux/commit/40ba80e4b043
[23/32] KVM: SVM: Merge "after set CPUID" intercept recalc helpers
        https://github.com/kvm-x86/linux/commit/4880919aaf8d
[24/32] KVM: SVM: Drop explicit check on MSRPM offset when emulating SEV-ES accesses
        https://github.com/kvm-x86/linux/commit/2f89888434bc
[25/32] KVM: SVM: Move svm_msrpm_offset() to nested.c
        https://github.com/kvm-x86/linux/commit/5c9c08476363
[26/32] KVM: SVM: Store MSRPM pointer as "void *" instead of "u32 *"
        https://github.com/kvm-x86/linux/commit/7fe057804118
[27/32] KVM: nSVM: Access MSRPM in 4-byte chunks only for merging L0 and L1 bitmaps
        https://github.com/kvm-x86/linux/commit/52f82177429e
[28/32] KVM: SVM: Return -EINVAL instead of MSR_INVALID to signal out-of-range MSR
        https://github.com/kvm-x86/linux/commit/5904ba517246
[29/32] KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
        https://github.com/kvm-x86/linux/commit/54f1c770611b
[30/32] KVM: SVM: Add a helper to allocate and initialize permissions bitmaps
        https://github.com/kvm-x86/linux/commit/73be81b3bb7c
[31/32] KVM: x86: Simplify userspace filter logic when disabling MSR interception
        https://github.com/kvm-x86/linux/commit/bea44d199240
[32/32] KVM: selftests: Verify KVM disable interception (for userspace) on filter change
        https://github.com/kvm-x86/linux/commit/0792c71c1c94

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

