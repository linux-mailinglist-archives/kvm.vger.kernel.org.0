Return-Path: <kvm+bounces-5601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A41823920
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 00:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A167F1F25B2A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 23:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E6D1F61F;
	Wed,  3 Jan 2024 23:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1hCv1IQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B941EB2D;
	Wed,  3 Jan 2024 23:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3339C433C8;
	Wed,  3 Jan 2024 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704324449;
	bh=3dPFVqfz1/USEV5DQhlEMM+/aJ8Fw/l5eoald+GaiQw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=I1hCv1IQXD7U5e9Kkl/t2bFnhC+m7V3CuOhr+fALuyhDspcrXQizuER3UAyshT8Iy
	 6SkW9QNU2Wk8QSxqJ+ko4K573aUqtma9kAZHUSM3q2kMlxVIlKwIs+qjxEaGN4o6mI
	 HW+Envdx0SJAELzyqNCMUDQay7NIixWLMqBIPqZUzcclchUBZ/TF/pSGsxso2AS9nF
	 ebe1oLZVPC4RgTFI+PvFFsJvJrBEdD2uVkS7fbcXH0DRvZ+Tdzo4556gDjMvsnuMOU
	 X4YIjVANRpwI9kdH7MLmaC73WMWp3IQfJvSpOZSyap/5WqfLF/4EjJv9lh//V5gQgi
	 jO5zdoUQXRnRQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5851ACE08F4; Wed,  3 Jan 2024 15:27:29 -0800 (PST)
Date: Wed, 3 Jan 2024 15:27:29 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>

On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> Since some time between v5.19 and v6.4, long-running rcutorture tests
> would (rarely but intolerably often) have all guests on a given host die
> simultaneously with something like an instruction fault or a segmentation
> violation.
> 
> Each bisection step required 20 hosts running 10 hours each, and
> this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
> is certainly messing with things that could possibly cause all manner
> of mischief, I don't immediately see a smoking gun.  Except that the
> commit prior to this one is rock solid.
> 
> Just to make things a bit more exciting, bisection in mainline proved
> to be problematic due to bugs of various kinds that hid this one.  I was
> therefore forced to bisect among the commits backported to the internal
> v5.19-based kernel, which fingered the backported version of the patch
> called out above.

Ah, and so why do I believe that this is a problem in mainline rather
than just (say) a backporting mistake?

Because this issue was first located in v6.4, which already has this
commit included.

							Thanx, Paul

> Please note that this is not (yet) an emergency.  I will just continue
> to run rcutorture on v5.19-based hypervisors in the meantime.
> 
> Any suggestions for debugging or fixing?
> 
> 							Thanx, Paul

