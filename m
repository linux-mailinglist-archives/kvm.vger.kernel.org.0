Return-Path: <kvm+bounces-5670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B60248248F3
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BFC5285EE9
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624752C695;
	Thu,  4 Jan 2024 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meNwmT0f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30A2C681;
	Thu,  4 Jan 2024 19:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC73C433C8;
	Thu,  4 Jan 2024 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704396233;
	bh=onmE/RNN+R0R622Kj1gpfjhJTPdyiEEgXOtbnFDL9vM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=meNwmT0f40fUdUnCGT+x2YGTjJ2yCdYWGp93Q0I+AgpYXrr2udoKh2wGh7o51MNlh
	 xVdhFdmRHIg/iJ2usoZ5K8UPEmrX9dKKCul6s5S9e+4pRH70PvbwiVfoKBcxpDdcU2
	 8uIyf1AVz0CaGWyDFfECIqiTWgdFKoGwq/II3NMorJm6KyYDSiia2G7ToXF/+e24pU
	 5YE59CNdkvNFam7dar7dZEhVbi1lZg/XXBSsbshDBUWq0MDdYMl/JPFRGTwNzkqcNc
	 /WaiUESmmiFJy7DiU4/s6UjRbnANjVtZHo854wjfMLvmhPUZQkyWwyRyqq4cC0ymJ7
	 3KzuCBOe47+rA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 8F2C6CE06FA; Thu,  4 Jan 2024 11:23:52 -0800 (PST)
Date: Thu, 4 Jan 2024 11:23:52 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <acb26142-622a-4f5d-aba6-c92601f95fbf@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
 <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
 <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>
 <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>
 <b327b546-4a5f-462d-baeb-804a33bd3f6a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b327b546-4a5f-462d-baeb-804a33bd3f6a@redhat.com>

On Thu, Jan 04, 2024 at 05:32:34PM +0100, Paolo Bonzini wrote:
> On 1/4/24 17:06, Paul E. McKenney wrote:
> > Although I am happy to have been able to locate the commit (and even
> > happier that Sean spotted the problem and that you quickly pushed the
> > fix to mainline!), chasing this consumed a lot of time and systems over
> > an embarrassingly large number of months.  As in I first spotted this
> > bug in late July.  Despite a number of increasingly complex attempts,
> > bisection became feasible only after the buggy commit was backported to
> > our internal v5.19 code base.  🙁
> 
> Yes, this strikes two sore points.
> 
> One is that I have also experienced being able to bisect only with a
> somewhat more linear history (namely the CentOS Stream 9 aka c9s
> frankenkernel [1]) and not with upstream.  Even if the c9s kernel is not a
> fully linear set of commits, there's some benefit from merge commits that
> consist of slightly more curated set of patches, where each merge commit
> includes both new features and bugfixes.  Unfortunately, whether you'll be
> able to do this with the c9s kernel depends a lot on the subsystems involved
> and on the bug.  Both are factors that may or may not be known in advance.

I guess I am glad that it is not just me.  ;-)

> The other, of course, is testing.  The KVM selftests infrastructure is meant
> for this kind of white box problem, but the space of tests that can be
> written is so large, that there's always too few tests.  It shines when you
> have a clear bisection but an unclear fix (in the past I have had cases
> where spending two days to write a test led me to writing a fix in thirty
> minutes), but boosting the reproducibility is always a good thing.

Agreed, validation never will be perfect, and so improving the test
suite based on production experience is a good thing, as is creating
test cases based on the behavior of important production workloads for
those who run them.

> > And please understand that I am not casting shade on those who wrote,
> > reviewed, and committed that buggy commit.  As in I freely confess that
> > I had to stare at Sean's fix for a few minutes before I figured out what
> > was going on.
> 
> Oh don't worry about that---rather, I am going to cast a shade on those that
> did not review the commit, namely me.  I am somewhat obsessed with Boolean
> logic and *probably* I would have caught it, or would have asked to split
> the use of designated initializers to a separate patch.  Any of the two
> could, at least potentially, have saved you quite some time.

We have all done similar things.  I certainly have!

> > Instead, the point I am trying to make is that carefully
> > constructed tests can serve as tireless and accurate code reviewers.
> > This won't ever replace actual code review, but my experience indicates
> > that it will help find more bugs more quickly and more easily.
> 
> TBH this (conflict between virtual addresses on the host and the guest
> leading to corruption of the guest) is probably not the kind of adversarial
> test that one would have written or suggested right off the bat.  But it
> should be written now indeed.

Very good, looking forward to seeing it!

							Thanx, Paul

> Paolo
> 
> [1]
> https://www.theregister.com/2023/06/30/enterprise_distro_feature_devconf/
> 

