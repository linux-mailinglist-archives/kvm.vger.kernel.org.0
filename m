Return-Path: <kvm+bounces-30242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6509B83E5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34C53B21109
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF611C7B62;
	Thu, 31 Oct 2024 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hrhgrof2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5354F1465B4
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404826; cv=none; b=lOH28JyVb6l/U7ke8kSqlOBrHqIp+zwxJdEK+6lZJoHQ2TSBU/BiE6sHNcsLinhsCjD/QRrtBK0Yx1rlyktInqAMiARk+yWdkIYLtDWEdvP9Lx/8YIZvq3vOAz6mhlZ43LaqxSLSGo0N+jAAx8lCzc7U6xrCceUq09PjoM0mb5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404826; c=relaxed/simple;
	bh=zac5tECCZ+2hkAkLwkJPyOhq3zwtGkq5DKIb7eG/CQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OtQz/QiA9/5UNmFXElY/p5hOODupSjSix5OvRO0nFXttKrq2L+PWAxSw4S1DOSv2CrQtQ0cJ2AtTiOmxbugwldKp9w0y9HeBRyK0tRY4wu9j2IYsmtHKaHtA05O9OF+vsBoi/k3Uv2/uZlB4ecnVZ8oGdD4qrqQwf7uq9BDJmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hrhgrof2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2fb583e4cso1573597a91.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 13:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404823; x=1731009623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FpwPxjJzeooRz07SKSO5nraJTuWvMLmzD1+H6hUBWMw=;
        b=Hrhgrof2N6km3Kx81E3r1YWa+yqp1J5yxr9FZnBty4ftJ3PekaiaKoZC+jjLAGAZBw
         N+3nHx8hHS7836SAt88PAMs8+BgBEqfZ8/RD5n3g/hBd+fL7N63zPZu1N6afS3SORTd2
         20ryHGYrExZ/UaxBeXcRIHbSJ/97E5rhaAYrjH1pDzO1hIIaMVd1BMbh6alZkDYEu+py
         gKM9SKDMInQf8R9c8d2cQEisps2QYasoSKxxwnQLn1q2MlfLCNG+idsw+sDSrB+k/dC5
         HaOB8r9VRE/gTvscqrhuxh9pia+I/h+tagn8HfWJredKO7prFVp7wtP8voWpdUkePnG5
         eAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404823; x=1731009623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FpwPxjJzeooRz07SKSO5nraJTuWvMLmzD1+H6hUBWMw=;
        b=BdUCHrp00XFUV2PKDaZuI1sK8gcuxaqL0u2YPE5b0qxamB33zGUbpt6fO4tgIuLcKv
         qX0y8c29ouJP+6kXFoGzMxZkkn0d6WS/3+dCnaLD8BiKsoyddvSjHFnCq2SGyuG8b6Ye
         AfKMfk/gBcSHtBMwBl4R8VZ6pUR4WOV+1WfrnCcRZJdNgG0HuT3F147uTWlywdAriv3B
         iKVoWewObgmql7HaxFHWBfJnzEQcNHgM01xMM6cQpGiLRhZPFPegKL5Nnm0TnViM2ffR
         ZV9GC1iXk45h4UY8tdMS0VseQRjH9X3Ik2E5s49Rr4ZH1ztTRPnUW2foNrctugeJhNtM
         YALg==
X-Forwarded-Encrypted: i=1; AJvYcCWVJWQjsMSlbLfjTzMJ/4yXLH2ggRYkC6CFgMHjnfPGTmQQbd2S2iTQU0rMDTjtxjMUnnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy27nO5ONBPWRe05J00EjyjLtYyS6DTiDI9BAXJWU7dAXYf9AC2
	QSPq7WjT2/UU5e2gTncGLbqH8XAhAQ0LAAwvf69ZI8tlxnHi8iXwQhR09/Mi/PgmnzRvU9AYPs8
	5aQ==
X-Google-Smtp-Source: AGHT+IGcnRyQTYSmsVPQsBmNa2lNRelM00ivU7678Q9L5jhj6IvHRBmjGrs4VnkYXZDxVV0uM0cn6s3ZqbA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:249:b0:2e2:ca33:1633 with SMTP id
 98e67ed59e1d1-2e8f104cab8mr41417a91.1.1730404823666; Thu, 31 Oct 2024
 13:00:23 -0700 (PDT)
Date: Thu, 31 Oct 2024 13:00:22 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
Message-ID: <ZyPh1nARL4vThB4J@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Optimize TDP MMU huge page recovery
 during disable-dirty-log
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, David Matlack wrote:
> Rework the TDP MMU disable-dirty-log path to batch TLB flushes and
> recover huge page mappings, rather than zapping and flushing for every
> potential huge page mapping.
> 
> With this series, dirty_log_perf_test shows a decrease in the time it takes to
> disable dirty logging, as well as a decrease in the number of vCPU faults:
> 
>  $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g
> 
>  Before: Disabling dirty logging time: 14.334453428s (131072 flushes)
>  After:  Disabling dirty logging time: 4.794969689s  (76 flushes)
> 
>  Before: 393,599      kvm:kvm_page_fault
>  After:  262,575      kvm:kvm_page_fault
> 
> v2:
>  - Use a separate iterator to walk down to child SPTEs during huge page
>    recovery [Sean]
>  - Return SHADOW_NONPRESENT_VALUE in error conditions in
>    make_huge_spte() [Vipin][off-list]
> 
> v1: https://lore.kernel.org/kvm/20240805233114.4060019-8-dmatlack@google.com/
> 
> David Matlack (6):
>   KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
>   KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
>   KVM: x86/mmu: Refactor TDP MMU iter need resched check
>   KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of
>     zapping
>   KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
>   KVM: x86/mmu: WARN if huge page recovery triggered during dirty
>     logging
> 
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu/mmu.c          |  16 ++--
>  arch/x86/kvm/mmu/mmu_internal.h |   3 +-
>  arch/x86/kvm/mmu/spte.c         |  43 +++++++++--
>  arch/x86/kvm/mmu/spte.h         |   5 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 129 +++++++++++++++++---------------
>  arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>  arch/x86/kvm/x86.c              |  18 ++---
>  8 files changed, 128 insertions(+), 94 deletions(-)

FYI, these are sitting in kvm-x86 mmu, but will be rebased next week, at which
point I'll send the "official" thank yous.

[1/8] KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
      https://github.com/kvm-x86/linux/commit/8ccd51cb5911
[2/8] KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
      https://github.com/kvm-x86/linux/commit/35ef80eb29ab
[3/8] KVM: x86/mmu: Check yielded_gfn for forward progress iff resched is needed
      https://github.com/kvm-x86/linux/commit/d400ce271d9c
[4/8] KVM: x86/mmu: Demote the WARN on yielded in xxx_cond_resched() to KVM_MMU_WARN_ON
      https://github.com/kvm-x86/linux/commit/012a5c17cba4
[5/8] KVM: x86/mmu: Refactor TDP MMU iter need resched check
      https://github.com/kvm-x86/linux/commit/cb059b9e2432
[6/8] KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of zapping
      https://github.com/kvm-x86/linux/commit/13237fb40c74
[7/8] KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
      https://github.com/kvm-x86/linux/commit/1d2a6d0b6438
[8/8] KVM: x86/mmu: WARN if huge page recovery triggered during dirty logging
      https://github.com/kvm-x86/linux/commit/ed5ca61d995f

