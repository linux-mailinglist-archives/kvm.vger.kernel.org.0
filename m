Return-Path: <kvm+bounces-48666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BED13AD0690
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F54D3B1CDA
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A06B289E35;
	Fri,  6 Jun 2025 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0TDxS94L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F690289E1B
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749226992; cv=none; b=QO+UOBTWed+Ppe8dIEdwueMkHeUywuo4P83I2ke2EXzc3C/JVZtcVolbmXPj5viar9M/+cr4ZpJcZo8+71FehDJdAj6y8QXdBQBBzGY+f/eouNBdFYsQqvxhFF+vKNqKt6pHVtqsJTiz+shTzKSKXByi58slIzRKs8xQQmtAFxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749226992; c=relaxed/simple;
	bh=M1jOEuhivTZKy/mwihHb5k9W7LK7MVVycL5m83PizRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=stczGaZ2CCKHWglNW/5Cj881pYgfhbFZvKJPpHkL6K3LD9H8Mgd3vP6GCN59pxOtdYUZ9O0upNDt8iMuMS2VgFdu1Zda53/bFR7P9t8BkZx11PxaL0w3lblowNyUDUQu/d5jyp/0ZbPZgwhJ7YQ8UVGF6LsaJZqfvz0sn3lDdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0TDxS94L; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235f77f86f6so14132985ad.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 09:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749226990; x=1749831790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iqr00pI7lwlLVWJXPD39OYX7ZXcxb0u30DdjvVVkUqE=;
        b=0TDxS94L+nmcB5yYQB7tpxOMLs7UB49L6oEYGdkvtwuXPeRNhNZ4ljFNT+rv1aB33/
         DqrNBGsrmg0k6F0zIMxCVLq8xbBpuAWcZqnXjsNFW+//CrW24h3oNxIPtUGF3QRB+ujX
         XXRBlZ02jlceqo6mTy9fLZb8tZQkmA0dc2r4dW/YBJ0OIzihYFQQv9dOhDyDGIve35nV
         iv8qIB3Ah2eocrXfmA4TtSIvbmcTlGPnmE829mPXJTlm9lbvWhHKayJ9j7Q2jRTkPdM7
         b3OtYyGj9LZmLZmCTwTvv952HOXO66tdpmssQzOVH0v+TI5HOzxtFHQmgodmbeAUSOEm
         Si3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749226990; x=1749831790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iqr00pI7lwlLVWJXPD39OYX7ZXcxb0u30DdjvVVkUqE=;
        b=CrORDDh6GWImL5UCknyWI5jGYh4iFBP5dWkSb6J++LPLLNMBKIqrjRJ0RlWTRWds/w
         vKZnAZR/Rs9w2TTC1y6OgSS1amZMUZJqm9YzIPMfS0EJytdgnQR5RVL96Elj8YfCGJEE
         GqsO/uws1bxdfO9wCocSBlg6lCZzZJH2WxgL8lDJ4mheaaX+RVVyje6CDCr6taDqzg56
         z3D5SD5K//yZbvs8L+W/hN/3SEe8vBCQWAFSXK++83NE5SEC0tnYPZE4XMopsSKUysME
         Z8u0CaJ/sgbDM409ytR00VwIOpiuHyT8SVb4ltSAC26a3hts9rHOtVJ3dzdpFzYZf4uK
         DeAw==
X-Forwarded-Encrypted: i=1; AJvYcCX3xg56XH+y0WhKKTwIy72f/QvB2BchcJPz+ALf4dSTDnaVk34El7d3ZqEmZbUt/fnkruU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9+987XE4adh55XXJbwq9YVsskpnwFDD5RRxqf3Im5mENRFvVc
	NIrj6lru7CQq9TWTSILOkB46YaF9TQYaLFGC1wjqVRRYtCAyL5hRUNVNdaHZ+QK+YQ+ccMkp2E/
	64hxXkA==
X-Google-Smtp-Source: AGHT+IEbdeG1/EtRym+qW1Vn8WnmqKEc3a8Vg6fFl1bLllc5eruW4ye1N0jRNWJY9KZzuwW5IEBvBc5bSDQ=
X-Received: from plbmi16.prod.google.com ([2002:a17:902:fcd0:b0:234:dbbb:e786])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2451:b0:234:aa98:7d41
 with SMTP id d9443c01a7336-23601d977fcmr50980545ad.42.1749226990318; Fri, 06
 Jun 2025 09:23:10 -0700 (PDT)
Date: Fri, 6 Jun 2025 09:23:09 -0700
In-Reply-To: <20250401161106.790710-11-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-11-pbonzini@redhat.com>
Message-ID: <aEMV7awKTSXEkLqu@google.com>
Subject: Re: [PATCH 10/29] KVM: share statistics for same vCPU id on different planes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> Statistics are protected by vcpu->mutex; because KVM_RUN takes the
> plane-0 vCPU mutex, there is no race on applying statistics for all
> planes to the plane-0 kvm_vcpu struct.
> 
> This saves the burden on the kernel of implementing the binary stats
> interface for vCPU plane file descriptors, and on userspace of gathering
> info from multiple planes.  The disadvantage is a slight loss of
> information, and an extra pointer dereference when updating stats.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/arm.c                 |  2 +-
>  arch/arm64/kvm/handle_exit.c         |  6 +--
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c |  4 +-
>  arch/arm64/kvm/mmio.c                |  4 +-
>  arch/loongarch/kvm/exit.c            |  8 ++--
>  arch/loongarch/kvm/vcpu.c            |  2 +-
>  arch/mips/kvm/emulate.c              |  2 +-
>  arch/mips/kvm/mips.c                 | 30 +++++++-------
>  arch/mips/kvm/vz.c                   | 18 ++++-----
>  arch/powerpc/kvm/book3s.c            |  2 +-
>  arch/powerpc/kvm/book3s_hv.c         | 46 ++++++++++-----------
>  arch/powerpc/kvm/book3s_hv_rm_xics.c |  8 ++--
>  arch/powerpc/kvm/book3s_pr.c         | 22 +++++-----
>  arch/powerpc/kvm/book3s_pr_papr.c    |  2 +-
>  arch/powerpc/kvm/powerpc.c           |  4 +-
>  arch/powerpc/kvm/timing.h            | 28 ++++++-------
>  arch/riscv/kvm/vcpu.c                |  2 +-
>  arch/riscv/kvm/vcpu_exit.c           | 10 ++---
>  arch/riscv/kvm/vcpu_insn.c           | 16 ++++----
>  arch/riscv/kvm/vcpu_sbi.c            |  2 +-
>  arch/riscv/kvm/vcpu_sbi_hsm.c        |  2 +-
>  arch/s390/kvm/diag.c                 | 18 ++++-----
>  arch/s390/kvm/intercept.c            | 20 +++++-----
>  arch/s390/kvm/interrupt.c            | 48 +++++++++++-----------
>  arch/s390/kvm/kvm-s390.c             |  8 ++--
>  arch/s390/kvm/priv.c                 | 60 ++++++++++++++--------------
>  arch/s390/kvm/sigp.c                 | 50 +++++++++++------------
>  arch/s390/kvm/vsie.c                 |  2 +-
>  arch/x86/kvm/debugfs.c               |  2 +-
>  arch/x86/kvm/hyperv.c                |  4 +-
>  arch/x86/kvm/kvm_cache_regs.h        |  4 +-
>  arch/x86/kvm/mmu/mmu.c               | 18 ++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c           |  2 +-
>  arch/x86/kvm/svm/sev.c               |  2 +-
>  arch/x86/kvm/svm/svm.c               | 18 ++++-----
>  arch/x86/kvm/vmx/tdx.c               |  8 ++--
>  arch/x86/kvm/vmx/vmx.c               | 20 +++++-----
>  arch/x86/kvm/x86.c                   | 40 +++++++++----------
>  include/linux/kvm_host.h             |  5 ++-
>  virt/kvm/kvm_main.c                  | 19 ++++-----
>  40 files changed, 285 insertions(+), 283 deletions(-)

...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index dbca418d64f5..d2e0c0e8ff17 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -393,7 +393,8 @@ struct kvm_vcpu {
>  	bool ready;
>  	bool scheduled_out;
>  	struct kvm_vcpu_arch arch;
> -	struct kvm_vcpu_stat stat;
> +	struct kvm_vcpu_stat *stat;
> +	struct kvm_vcpu_stat __stat;

Rather than special case invidiual fields, I think we should give kvm_vcpu the
same treatment as "struct kvm", and have kvm_vcpu represent the overall vCPU,
with an array of planes to hold the sub-vCPUs.

Having "kvm_vcpu" represent a plane, while "kvm" represents the overall VM, is
conceptually messy.  And more importantly, I think the approach taken here will
be nigh impossible to maintain, and will have quite a bit of baggage.  E.g. planes1+
will be filled with dead memory, and we also risk goofs where KVM could access
__stat in a plane1+ vCPU.

Documenting which fields are plane0-only, i.e. per-vCPU, via comments isn't
sustainable, whereas a hard split via structures will naturally what fields are
scope to the overall vCPU, versus what is per-plane, and will force us to more
explicitly audit the code.  E.g. ____srcu_idx (and thus srcu_depth) is something
that I think should be shared by all planes.  Ditto for preempt_notifier, vcpu_id,
vcpu_idx, pid, etc.

Aha!  And to prove my point, this series breaks legacy signal handling, because
sigset_active and sigset are accessed using the plane1+ vCPU in kvm_vcpu_ioctl_run_plane(),
but KVM_SET_SIGNAL_MASK is only allowed to operated on plane0.  And I definitely
don't think the answer is to let KVM_SET_SIGNAL_MASK operate on plane1+, because
forcing userspace to duplicate the sigmal masks to all planes is pointless.

Yeeeaaap.  pid and pid_lock are also broken.  As is vmx_hwapic_isr_update()
and kvm_sched_out()'s usage of wants_to_run.  And guest_debug.

Long term, I just don't see this approach as being maintainable.  We're pretty
much guaranteed to end up with bugs where KVM operates on the wrong kvm_vcpu
structure due to lack of explicit isolation in code.  And those bugs are going
to absolutely brutal to debug (or even notice).  E.g. failure to set "preempted"
on planes 1+ will mostly manifest as subtle performance issues.

Oof.  And that would force us to document that duplicating cpuid and cpu_caps to
planes1+ is actually necessary, due to dynamic CPUID features (ugh).  Though FWIW,
we could dodge that by special casing dynamic features, which isn't a bad idea
irrespective of planes.

Somewhat of a side topic: unless we need/want to explicitly support concurrent
GET/SET on planes of a vCPU, I think we should make vcpu->mutex per-vCPU, not
per-plane, so that there's zero chance of having bugs due to thinking that holding
vcpu->mutex provides protection against a race.

Extracing fields to a separate kvm_vcpu_plane will obviously require a *lot* more
churn, but I think in the long run it will be less work in total, because we won't
spend as much time chasing down bugs.

Very little per-plane state is in "struct kvm_vcpu", so I think we can do the big
conversion on a per-arch basis via a small amount of #ifdefs, i.e. not be force to
immediatedly convert all architectures to a kvm_vcpu vs. kvm_vcpu_plane world.

