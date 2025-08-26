Return-Path: <kvm+bounces-55774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B06B370C8
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 18:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56872366189
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33802D8DDD;
	Tue, 26 Aug 2025 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuvpJ+uR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB8A2D837C;
	Tue, 26 Aug 2025 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756227483; cv=none; b=XXhQxg+Z2zJ7Ls0Vfm5yhmEdAzyN7lyg7Rupp/xJ+CY/Qx7MtmI/+Iu7LJ6mJm5ZjpwOMx96WOEevVEQbTbbD63uChgix+YzdBTA201exvr4Z+D2QxGvwQ3oOxUnDtNL7jt8uNGyXA164c1FZ3zKYKVupuYV0ttdg3pYxdFmQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756227483; c=relaxed/simple;
	bh=fnUtXDAxJfdbxKoWIvjZ0YEMsdquajfs3Wt0vqohrgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubMmnoo2oZu9s6x/EePqUAL6yDQNyPSEn9QLVcp1fDTzFKhnPHdwNItf1KrVl76vYqHNUSo0T4xLsZrxMtzfPtxsYoeWBgZVL2BFKsLWS+Gn86AlRsHZVg5MsrA92wClIOcSii+yml4tMhTKqDDFw9xeLeS1jATQ2bfM51G8L/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuvpJ+uR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82A7C4CEF1;
	Tue, 26 Aug 2025 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756227482;
	bh=fnUtXDAxJfdbxKoWIvjZ0YEMsdquajfs3Wt0vqohrgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fuvpJ+uRtRM9fzHvRv14jD9ZQo0Z+Ik1UILyoPgPF2jz8dNyPROaEFVvlvQAaXz4X
	 ttXYaAtJGkub4HtTxq/BEINhmPDYT0kc4MO9Pt7hSTntGG0uTTAcFEzDYKdGxtFeT2
	 qkjkQ9Njb/UFnPIIvb1+17UQA9vp2juzNUYGm3uywq3v8NTkaS1OlNFYQ09AI39lpx
	 YQaZvSP4SUfRf4YlPPa54Y1tNy/wsF7ZVJVKqynCB7t8JfsAtW1Xvl7gh2NjEvVbqY
	 byeS9jwZXrmVRhx6StAaC2vlVi6HX3Ox4JExT2RQEj9zwDNL3tioAysr1mHqOoXhAg
	 8DUjtPx04KNjg==
Date: Tue, 26 Aug 2025 16:58:00 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Marc Zyngier <maz@kernel.org>,
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
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
Message-ID: <aK3nmOgVl4INJpjG@liuwe-devbox-ubuntu-v2.tail21d00.ts.net>
References: <20250825200622.3759571-1-seanjc@google.com>
 <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
 <aKz_ZMvvF0e9nwSn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKz_ZMvvF0e9nwSn@google.com>

On Mon, Aug 25, 2025 at 05:27:16PM -0700, Sean Christopherson wrote:
> On Mon, Aug 25, 2025, Nuno Das Neves wrote:
> > On 8/25/2025 1:06 PM, Sean Christopherson wrote:
> > > Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> > > deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> > > more generic "virt" APIs (which ideally would have been done when MSHV root
> > > support was added).
> > > 
> > > Assuming all is well, maybe this could go through the tip tree?
> > > 
> > > The Hyper-V stuff and non-x86 architectures are compile-tested only.
> > > 
> > 
> > Thanks Sean, I can test the root partition changes.
> > 
> > A similar change will be needed in mshv_vtl_main.c since it also calls
> > mshv_do_pre_guest_mode_work() (hence the "common" in mshv_common.c).
> 
> Oof, more dependencies.  I suppose the easiest thing would be to send a series
> against
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git queue
> 
> and then route everything through there?

Our fixes branch is on 6.17-rc1. You can use it as a base if you want
to.

> 
> Alternatively, frontload the MSHV fixes (which I'll do regardless) and take those
> through hyperv and the rest through the tip tree?  That seems like an absurd
> amount of juggling though, especially if we want to get the cleanups into 6.18.
> And if none of these lands, it's MSHV that'll suffer the most, so betting it all
> on the hyperv tree doesn't seem terrible.
> 

I'm happy to do it however the community sees fit.

> > Also, is it possible to make all the mshv driver changes in a single patch?
> 
> It's certainly possible, but I'd prefer not do to that.
> 
> > It seems like it would be cleaner than refactoring it in patches 1 & 2 and
> > then deleting all the refactored code in patch 5.
> 
> Only if you don't care about backporting fixes, bisection, or maintaining code.
> 
> E.g. if checking NEED_RESCHED_LAZY somehow causes issues, it would be really nice
> for that to bisect to exactly that patch, not a patch that also switches to a
> completely different set of APIs.
> 
> And if someone is wants the fixes in a pre-6.18 kernel, they don't need to
> backport all of the KVM and entry code changes just to get the fix.

+1 on this.

Thanks,
Wei

> 
> As for the maintenance headache, see above.

