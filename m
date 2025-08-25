Return-Path: <kvm+bounces-55684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1F3B34E3F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FB881A8707E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C112E298CA7;
	Mon, 25 Aug 2025 21:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WehF5ftN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12326290;
	Mon, 25 Aug 2025 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158355; cv=none; b=hdFfzTrW7nakp6Fdk4vehspuTA9nTLArvCpIfQAZHaH1HNAFNO43QNIf1bfeWBNHzLCHg8o6xdk8s/4SUeVnBm7r3ibEbNvIV4fp+GzJREjQMAUQlb3RyXPfHyGWoAbBeEgiQTkZbZEAC+zXYinIvagUMG9ftqFjPceLq8qHC+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158355; c=relaxed/simple;
	bh=z2K4pTnpiDqLqYIH8QVc9PQKE3DH+YA71ZyqVbqxW6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LONqsWp/LDezsMAEnFrenRga02z/ihQeYlpSR5zsALSc+kzGABF8fgIVGE1IAcbc3NyOo0SsaiJcbXqQ9CQpBF3NAqTwCm9pK5JedNDWwi2eyUa+NZ5zQQC7HiQp7QcTxwt58NLNinBsKxchETtpUewfKo+yVbG/mfM70KV6nIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WehF5ftN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AD6C4CEED;
	Mon, 25 Aug 2025 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756158354;
	bh=z2K4pTnpiDqLqYIH8QVc9PQKE3DH+YA71ZyqVbqxW6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WehF5ftNNXRo0ktcAvTwwGNFGV/EAJ74RPmJHCc1/Z17l1QEglTKoK3ibLL8gnc4t
	 NlKz6k7fz2lmrzWRP6K+pj3xu5efQX0yAcStIUphpdlkE0hXvX1O/hxV14uaFfM9Il
	 teNGWS4vL/IPlA1GKik4UxLjNusOjbU5D/OewsXrWcI/Ynet9r+J6j0h0Qw9udbcdx
	 Jt5qZw5UoaBh5E3LiK4rJTYYyfwi5l7H9dDZXLKpcynQANDbCwVWm46jM36cUflkSE
	 TgteF7/ksdzao8dEBvyhS4bxR3OBEL/v0WKy2lffmwCnCK3v1xmgFX8nRRpGli6jrU
	 9ptYFqpFDYbDA==
Date: Mon, 25 Aug 2025 21:45:52 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
	mrathor@linux.microsoft.com, nunodasneves@linux.microsoft.com
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
Message-ID: <aKzZkItq-8_OmxJ0@liuwe-devbox-ubuntu-v2.tail21d00.ts.net>
References: <20250825200622.3759571-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825200622.3759571-1-seanjc@google.com>

On Mon, Aug 25, 2025 at 01:06:17PM -0700, Sean Christopherson wrote:
> Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> more generic "virt" APIs (which ideally would have been done when MSHV root
> support was added).
> 

It is nice to have a common infrastructure.

Cc Mukesh and Nuno for review and test.

Thanks,
Wei

> Assuming all is well, maybe this could go through the tip tree?
> 
> The Hyper-V stuff and non-x86 architectures are compile-tested only.
> 
> Sean Christopherson (5):
>   Drivers: hv: Move TIF pre-guest work handling fully into mshv_common.c
>   Drivers: hv: Handle NEED_RESCHED_LAZY before transferring to guest
>   entry/kvm: KVM: Move KVM details related to signal/-EINTR into KVM
>     proper
>   entry: Rename "kvm" entry code assets to "virt" to genericize APIs
>   Drivers: hv: Use common "entry virt" APIs to do work before running
>     guest
> 
>  MAINTAINERS                                 |  2 +-
>  arch/arm64/kvm/Kconfig                      |  2 +-
>  arch/arm64/kvm/arm.c                        |  3 +-
>  arch/loongarch/kvm/Kconfig                  |  2 +-
>  arch/loongarch/kvm/vcpu.c                   |  3 +-
>  arch/riscv/kvm/Kconfig                      |  2 +-
>  arch/riscv/kvm/vcpu.c                       |  3 +-
>  arch/x86/kvm/Kconfig                        |  2 +-
>  arch/x86/kvm/vmx/vmx.c                      |  1 -
>  arch/x86/kvm/x86.c                          |  3 +-
>  drivers/hv/Kconfig                          |  1 +
>  drivers/hv/mshv.h                           |  2 --
>  drivers/hv/mshv_common.c                    | 22 ---------------
>  drivers/hv/mshv_root_main.c                 | 31 ++++-----------------
>  include/linux/{entry-kvm.h => entry-virt.h} | 19 +++++--------
>  include/linux/kvm_host.h                    | 17 +++++++++--
>  include/linux/rcupdate.h                    |  2 +-
>  kernel/entry/Makefile                       |  2 +-
>  kernel/entry/{kvm.c => virt.c}              | 15 ++++------
>  kernel/rcu/tree.c                           |  6 ++--
>  virt/kvm/Kconfig                            |  2 +-
>  21 files changed, 49 insertions(+), 93 deletions(-)
>  rename include/linux/{entry-kvm.h => entry-virt.h} (83%)
>  rename kernel/entry/{kvm.c => virt.c} (66%)
> 
> 
> base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
> -- 
> 2.51.0.261.g7ce5a0a67e-goog
> 

