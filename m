Return-Path: <kvm+bounces-55696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4865DB34EFE
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 232D37A7AED
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE02299AB4;
	Mon, 25 Aug 2025 22:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dl7NKkPg"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0754A33;
	Mon, 25 Aug 2025 22:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756160617; cv=none; b=WPfJ2D6cDmsZ/+vKScAP61BwNYbj/RvG8MEPfRPtKlbVrotv3ao9BGmXZldQ/iOr9loY8N2qcUB6g5PWBp5s7F9LTrzka3mGf7GUzvhyyXFpR4ieevGs4AMc7lU9HiqPujRx1/BplGRP/Q5InFWEJKJYjIQZ7CZO8qNppUigMxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756160617; c=relaxed/simple;
	bh=ltPPFTSWmfdBvpaDHQpaoONLfLSrk3U+ciaVt7etUWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDzGFhbsFAKbLzlYLAUMvc3YimhxWRQaFJJk26G3IOD1REMTbD6qsBree4CBK6Q/K2jvnQjZXkkmncE1+c1KiIjT9Niyqq4yISpcr6z1iFP2jThceqvDkIOWhBCNHNtG86vKSYLQMI0u7NnGOwKfExjYQiOkdCjHtPnkzGu/sak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dl7NKkPg; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VQ6ZxU9qPw4vkvXRX5Uv3LAGHE1s7LId4Lk2ftW+5fQ=; b=Dl7NKkPggz+LyLx3g8yECmKY46
	frByDzPrm1d7k7r6fUYBr7sJ1/gtI3/xuCZztOdzBTfXHZW5dLTfoeezOIGEPointBsAmd03xk48d
	WlEM/iwO4pRpd/cRbRKw3fHveNo5GXY5PxTUSJ8+GZzhKGoxCHx2gpOCpjkylBAeqT/2dyKgrAimm
	+dCTSl+QYVkt2M0A4NwjYvWM4SBpo+zMRuLXJJRssy7tLZ5SJF8r5hIe+zRkvyqcggHxDm1LnCjKo
	AkoKfXPmuduAgVkKtztmrNNPM5r0DScPdhFhgKU4NzqG9y6QY6PhELbLGykH30oOt1dX2dZTR1OUR
	AnNYWLvA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqfay-000000024iA-1xRz;
	Mon, 25 Aug 2025 22:23:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0C1983002C5; Tue, 26 Aug 2025 00:23:19 +0200 (CEST)
Date: Tue, 26 Aug 2025 00:23:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20250825222319.GO3419281@noisy.programming.kicks-ass.net>
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
> Assuming all is well, maybe this could go through the tip tree?
> 
> The Hyper-V stuff and non-x86 architectures are compile-tested only.

I suspect there's more of this wreckage in the new VTL driver that
they just put in:

  https://lore.kernel.org/all/20250729051436.190703-3-namjain@linux.microsoft.com/

although ideally they rip that thing out. I don't know how that code can
ever be correct.

