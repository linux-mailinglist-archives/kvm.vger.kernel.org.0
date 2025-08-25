Return-Path: <kvm+bounces-55697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F695B34F08
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:26:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87A9B486350
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5EE29B766;
	Mon, 25 Aug 2025 22:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWhRXs6C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B189393DD1;
	Mon, 25 Aug 2025 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756160801; cv=none; b=gz9f7KqydZHWUcB86tkU+PIDKrNgI99SdR77d6b8R555VQc8qDjKudLevrwcrucey/5AfPPT/lCD8X/nX8vT1E63bDxZSRjxktQsHW4Jh7jjJTztNCGtmb5QC9fD9Ry+3oKUz7RXYW7BcAP/74H/7gObqfQOfqI4UbozLMEsPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756160801; c=relaxed/simple;
	bh=GoT/IDAj0/zl52GctB7u4AkgxxaowB1GBSt3qSkJ1E4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUj+aOxb6taEO7eOvnxmRMsk58NN2WRKrdfUOJF32tZARV+xxUnCCJMC8WcSwzFJiII6BhulK9HLHK9gRVODQuVP2N+YqulJ4Mu8MsnE2tP3JTbWrzThXOrf3OgyvyU9nd1cMEyvw+eQS3CX+O396F2xwXQw31z95rW86eFT20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWhRXs6C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FEDC4CEED;
	Mon, 25 Aug 2025 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756160800;
	bh=GoT/IDAj0/zl52GctB7u4AkgxxaowB1GBSt3qSkJ1E4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NWhRXs6Cbt9IBasNjzbrSoMfcGqD7tsG+V408f534nn6Bx+XQJj85bVx7NsFSy+yU
	 TmOztuBY/wqLhaH+5EZk96/TwXUXIkZZXJhymLz/XqCycTtAp21dM7xDlt7u77Efi9
	 i650eYZ5SRgcoXWnDHonuVKfPSVk7N9gIJBPt4VR0KeDj/UrZnQxBpWGz/KEXpMEC5
	 KC+SFUbdvyPM/aYHhQlv8UHOZRNBZQnoYRbhwKGap+ReS6crF/1t/uenNLY9qNSDYf
	 irJDfpr3g/Zb1UeuMJWMPgi888bpBrHyT/dBPpbUsGxoLlDL0YFx55ub3z9UObaIVS
	 hCBvdVm4TTUeA==
Date: Mon, 25 Aug 2025 22:26:38 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
Message-ID: <aKzjHjtI2fbFjBpe@liuwe-devbox-ubuntu-v2.tail21d00.ts.net>
References: <20250825200622.3759571-1-seanjc@google.com>
 <20250825222319.GO3419281@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825222319.GO3419281@noisy.programming.kicks-ass.net>

On Tue, Aug 26, 2025 at 12:23:19AM +0200, Peter Zijlstra wrote:
> On Mon, Aug 25, 2025 at 01:06:17PM -0700, Sean Christopherson wrote:
> > Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> > deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> > more generic "virt" APIs (which ideally would have been done when MSHV root
> > support was added).
> > 
> > Assuming all is well, maybe this could go through the tip tree?
> > 
> > The Hyper-V stuff and non-x86 architectures are compile-tested only.
> 
> I suspect there's more of this wreckage in the new VTL driver that
> they just put in:
> 
>   https://lore.kernel.org/all/20250729051436.190703-3-namjain@linux.microsoft.com/
> 
> although ideally they rip that thing out. I don't know how that code can
> ever be correct.

Please give us some time, Peter. I have asked the corresponding team to
respond to your comments.

Wei

