Return-Path: <kvm+bounces-28929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B5199F43A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE65E1F24CDF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B505D1FAEF5;
	Tue, 15 Oct 2024 17:40:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D81F6690;
	Tue, 15 Oct 2024 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729014020; cv=none; b=MWxiuil4uGLipEe2D0mhxdqfnIou/YUPKjSY9cB+ru6Sg7QzxeNY1pEQkO55jDsE38i8CGNAHgJ5HHe9Gu8T3OSG1Y+RZ3Z5Cvt50jsg8qd4STtn72hHHtkfwOlCFO1biS62bz5ACiyxtSzsYZN2paImWxvJTIQXj45Ip+QRtGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729014020; c=relaxed/simple;
	bh=SXa0grFaq7RR+AfMviCRfUEadq71ICMwPBX1B8iFRoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY/VWKCRpJ0XvG7ft0fbYpMCkBVZxV453sV3WjiZMkKZ6URBGtEfUss0nHYEO1TrNp9nLkVRuo9u+foO7t5ngi8f9GexY210FMoU7eIbvmgdjvdUeO5EaNZxibMA6NWOTwPYrTNMw0clNL6++WJmoD5MHa6hoGxsLSGlCPJ4+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD607C4CEC6;
	Tue, 15 Oct 2024 17:40:14 +0000 (UTC)
Date: Tue, 15 Oct 2024 18:40:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
	wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
	daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
	lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
	mtosatti@redhat.com, sudeep.holla@arm.com,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <Zw6o_OyhzYd6hfjZ@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>

On Tue, Oct 15, 2024 at 10:17:13AM -0700, Christoph Lameter (Ampere) wrote:
> On Tue, 15 Oct 2024, Catalin Marinas wrote:
> > > Setting of need_resched() from another processor involves sending an IPI
> > > after that was set. I dont think we need to smp_cond_load_relaxed since
> > > the IPI will cause an event. For ARM a WFE would be sufficient.
> >
> > I'm not worried about the need_resched() case, even without an IPI it
> > would still work.
> >
> > The loop_count++ side of the condition is supposed to timeout in the
> > absence of a need_resched() event. You can't do an smp_cond_load_*() on
> > a variable that's only updated by the waiting CPU. Nothing guarantees to
> > wake it up to update the variable (the event stream on arm64, yes, but
> > that's generic code).
> 
> Hmm... I have WFET implementation here without smp_cond modelled after
> the delay() implementation ARM64 (but its not generic and there is
> an additional patch required to make this work. Intermediate patch
> attached)

At least one additional patch ;). But yeah, I suggested hiding all this
behind something like smp_cond_load_timeout() which would wait on
current_thread_info()->flags but with a timeout. The arm64
implementation would follow some of the logic in __delay(). Others may
simply poll with cpu_relax().

Alternatively, if we get an IPI anyway, we can avoid smp_cond_load() and
rely on need_resched() and some new delay/cpu_relax() API that waits for
a timeout or an IPI, whichever comes first. E.g. cpu_relax_timeout()
which on arm64 it's just a simplified version of __delay() without the
'while' loops.

-- 
Catalin

