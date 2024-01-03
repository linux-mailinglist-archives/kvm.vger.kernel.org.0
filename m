Return-Path: <kvm+bounces-5599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 291F78237D9
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 23:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0A692843E4
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 22:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA021F945;
	Wed,  3 Jan 2024 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfSg7HGf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D801F617;
	Wed,  3 Jan 2024 22:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64094C433C8;
	Wed,  3 Jan 2024 22:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704320544;
	bh=Xqh8mRMTZjVBQ4W72hW9xL1GK2MfD1+kMbsRptHMHmE=;
	h=Date:From:To:Cc:Subject:Reply-To:From;
	b=MfSg7HGffmUNqmVb8SnoYQnRUSfHRKdvaTVTmVyXSK4o2Ph8l3qk20AmyjZzYXIAJ
	 kDelRQbE0X6pkFnKmcISSLMIfyItVAVHGeXNUnxKTzIjGzBTUERVwNZP0qioZYBp8d
	 hWTCXsXiNJBNtRmfUB4T7iSIEO1ZTp0wm5GXpZMHvV06+a5wOt+j0v4VcfuLMVcI2w
	 hBpSdndVY79I3RwvYd/KxwBOGc1HiyEcByxUH3LkmeXFEUvoz4WFxd8vYbu4i26iK+
	 7UWQHVgGW5ygPdbDrCT9F7/dRmAW4vcDiLqkSu+JeM3IMEe85o6Gb2dWpvFvh3yVQ7
	 LiY46smhkmW7g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id F1E49CE08F4; Wed,  3 Jan 2024 14:22:23 -0800 (PST)
Date: Wed, 3 Jan 2024 14:22:23 -0800
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
Subject: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
Reply-To: paulmck@kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

Since some time between v5.19 and v6.4, long-running rcutorture tests
would (rarely but intolerably often) have all guests on a given host die
simultaneously with something like an instruction fault or a segmentation
violation.

Each bisection step required 20 hosts running 10 hours each, and
this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
is certainly messing with things that could possibly cause all manner
of mischief, I don't immediately see a smoking gun.  Except that the
commit prior to this one is rock solid.

Just to make things a bit more exciting, bisection in mainline proved
to be problematic due to bugs of various kinds that hid this one.  I was
therefore forced to bisect among the commits backported to the internal
v5.19-based kernel, which fingered the backported version of the patch
called out above.

Please note that this is not (yet) an emergency.  I will just continue
to run rcutorture on v5.19-based hypervisors in the meantime.

Any suggestions for debugging or fixing?

							Thanx, Paul

