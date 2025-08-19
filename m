Return-Path: <kvm+bounces-55056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA3AB2CFAF
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207CF628452
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B184627A45C;
	Tue, 19 Aug 2025 23:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rt+oUgFt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E227280C
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645250; cv=none; b=rute4BDMrwGftlsvJRcoc+G2kupSkAhUckdM/nSRaUZnRkqYIlmsE3KRzydgjaL+wjYHOmwtO3oOWA98RJuo3Xb+Mj8vSGAgqLeAXmGhW0ND5A0krmVflxkXC1pOr3pePT8BIBqrBAf1LM/ny7qPnnBQ4mkIGjaibcGZ3a51df8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645250; c=relaxed/simple;
	bh=r1bT3KQpL5rlUPzGIefr+G7x3Fyb5KoPkPiPBLvdfDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CKbdpX8QaldVEi8VUBhXzqYBh8UWYxEl9ieZkgK4Ro6dwXPZU2v7sX1Z/8NbNnvqtrnDp7EitSFxblqEUlQ8O+nQ1BKks46TJxu9tNpOqKUrNKNbq4Heg1lJ4zEm9sZLP2Ddv+gjlrRTmp/ZfG7XDZtQVFaNJHrf2NhkCRHOlVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rt+oUgFt; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e60221fso13149464b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645249; x=1756250049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBfhOd1/j1SijzHioK0Kidj1qJEFw7epUtuJ7lG3GoU=;
        b=Rt+oUgFtPNj6lzY3U3cP9oOPE48SNsnihPfQPCiFsv2vKMLfPdO++q8/f6xWVRBWh+
         gERmFbCDd+BG9oyUMnV4IJX2LkbOoRqVCu09McrcIeK3vlrNMKL2v1pD07yjpgNXMmPY
         LZkNjRs1V7NeDK7IFxBmE0HRwHKCHYReR7roGltchjt/EaAYxd3flQabSA0xgDy6G8x8
         CeMnNRTIF/HrrDY7FOs4lqSZAExyuB9Tul0y5qmoLp1uKwU2asM9/b/FqxwFazChc5px
         jA6eqn21eEQR3gTAqHnu6mTHz0HLwUJf1DXuolQcjuBQfnk7fkc2idxNDkgFOdZsHMv7
         M2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645249; x=1756250049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBfhOd1/j1SijzHioK0Kidj1qJEFw7epUtuJ7lG3GoU=;
        b=VHx/wJX/YZaXFBy+SpqfnchomK2pcNUuK0Afz73iNc7Vd6t7s8NX6kXeNZH1xuz7SL
         7ukrRJD6t90XhrMGMaxM016/xbiQl0QFZ5NtiZTUpZAEu3XsPF63naBeNT68pHSPl334
         VblWIrQDNnJMIVSq9sYy9V1Hga3HN5bGnS+5S4gBllvfRt9lnH5v7jh/pUpb7OaTXZuy
         F+/mTUAwtjiJYicZqtJ39iixSuHKAQdtpuL2133ZKLFiOdH7AxvMl6Xxe0mXJvTmTfwT
         6rNn00T50xkWlvHldIeKn+mPOpyEE3koGWZUXPM+UVu1YzzKAI5NphB4o+tiwxdfFmWZ
         b/Jw==
X-Gm-Message-State: AOJu0YwKT48+ldbSt+jv2ORnp9JoUja9eJEb/qvBa0fUMJtteZtTINKP
	ZWtHl7nl2kkHh89Hd4ERwQ37RlOUo150HqHW6AMyQ7H6mtDKSimuDI/2oMKP+Xc/GscEsDzl4u4
	/xmemXA==
X-Google-Smtp-Source: AGHT+IEKCoRqAMc/f4iB5AJQOguXNLumRWLvD7jp4GBK6HZKhyz1B49plLp8M59RK1CG0fCbxXOCOG75XdQ=
X-Received: from pgbfq28.prod.google.com ([2002:a05:6a02:299c:b0:b47:3914:9769])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a0:b0:1f5:72eb:8b62
 with SMTP id adf61e73a8af0-2431b7bb318mr1490210637.20.1755645248846; Tue, 19
 Aug 2025 16:14:08 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:59 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564464232.3065542.6062884759434886265.b4-ty@google.com>
Subject: Re: [PATCH 00/18] KVM: x86: Fastpath cleanups and PMU prep work
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 05 Aug 2025 12:05:08 -0700, Sean Christopherson wrote:
> This is a prep series for the mediated PMU, and for Xin's series to add
> support for the immediate forms of RDMSR and WRMSRNS (I'll post a v3 of
> that series on top of this).
> 
> The first half cleans up a variety of warts and flaws in the VM-Exit fastpath
> handlers.  The second half cleans up the PMU code related to "triggering"
> instruction retired and branches retired events.  The end goal of the two
> halves (other than general cleanup) is to be able bail from the fastpath when
> using the mediated PMU and the guest is counting instructions retired, with
> minimal overhead, e.g. without having to acquire SRCU.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/18] KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
        https://github.com/kvm-x86/linux/commit/0910dd7c9ad4
[02/18] KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
        https://github.com/kvm-x86/linux/commit/15daa58e78ce
[03/18] KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
        https://github.com/kvm-x86/linux/commit/777414340085
[04/18] KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
        https://github.com/kvm-x86/linux/commit/aeeb4c7fff52
[05/18] KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath exits
        https://github.com/kvm-x86/linux/commit/0a94b2042419
[06/18] KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be skipped
        https://github.com/kvm-x86/linux/commit/aebcbb609773
[07/18] KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
        https://github.com/kvm-x86/linux/commit/aa2e4f029341
[08/18] KVM: x86: Fold WRMSR fastpath helpers into the main handler
        https://github.com/kvm-x86/linux/commit/d618fb4e43a0
[09/18] KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
        https://github.com/kvm-x86/linux/commit/a3e80bf73ee1
[10/18] KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
        https://github.com/kvm-x86/linux/commit/43f5bea2639c
[11/18] KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
        https://github.com/kvm-x86/linux/commit/5dfd498bad5f
[12/18] KVM: x86/pmu: Rename pmc_speculative_in_use() to pmc_is_locally_enabled()
        https://github.com/kvm-x86/linux/commit/6b6f1adc4332
[13/18] KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
        https://github.com/kvm-x86/linux/commit/e630bb52d27f
[14/18] KVM: x86/pmu: Drop redundant check on PMC being globally enabled for emulation
        https://github.com/kvm-x86/linux/commit/58baa649ea09
[15/18] KVM: x86/pmu: Drop redundant check on PMC being locally enabled for emulation
        https://github.com/kvm-x86/linux/commit/8709656514c1
[16/18] KVM: x86/pmu: Rename check_pmu_event_filter() to pmc_is_event_allowed()
        https://github.com/kvm-x86/linux/commit/3eced8b07bb9
[17/18] KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
        https://github.com/kvm-x86/linux/commit/8bb8b60c95c5
[18/18] KVM: x86: Add a fastpath handler for INVD
        https://github.com/kvm-x86/linux/commit/6c3d4b917995

--
https://github.com/kvm-x86/linux/tree/next

