Return-Path: <kvm+bounces-29108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CF39A2BF0
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 20:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045791C25B02
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE101E9079;
	Thu, 17 Oct 2024 18:15:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED601E6DEE;
	Thu, 17 Oct 2024 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729188911; cv=none; b=JNoSmlRiyHG/aKsrjT3NZm2KhbBTAQakBet6xG57IxA9ph87GdqKp6BWJWEq+3uhFcApe4bVVrmaBOqp8gGkFEA2C4g4A6sQuQuFgGx4swtSmZOoU0cKiTwqYMRj8mgy5KRMvPD+zxns2sfMAt5KOnFd56W60rd9LhLT2FY6CzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729188911; c=relaxed/simple;
	bh=DWbh7o5fAItWiyCuJA1KUkrKPiQSchGKhClzB5QlL/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aeadpiCJtp0VSxTlLZV8KxfbsbwxiSqdOMMqFoqzOuCdSx+emmnuPh5X1mguXS7Fakzo6Naq00jY3zSTHkQrsAAs9TV1MrSFiWQ98kLwnTs9vXFdoNooKfW333NtzjiErzSsUwLIlmrBxtFyYlNBvFEtUBTtJXlSKaBgpXcszOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BA1C4CEC3;
	Thu, 17 Oct 2024 18:15:05 +0000 (UTC)
Date: Thu, 17 Oct 2024 19:15:03 +0100
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
Message-ID: <ZxFUJ05EYumCUUY3@arm.com>
References: <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com>
 <87jze9rq15.fsf@oracle.com>
 <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org>
 <Zw-Nb-o76JeHw30G@arm.com>
 <53bf468b-1616-3915-f5bc-aa29130b672d@gentwo.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53bf468b-1616-3915-f5bc-aa29130b672d@gentwo.org>

On Thu, Oct 17, 2024 at 09:56:13AM -0700, Christoph Lameter (Ampere) wrote:
> On Wed, 16 Oct 2024, Catalin Marinas wrote:
> > The behaviour above is slightly different from the current poll_idle()
> > implementation. The above is more like poll every timeout period rather
> > than continuously poll until either the need_resched() condition is true
> > _or_ the timeout expired. From Ankur's email, an IPI may not happen so
> > we don't have any guarantee that WFET will wake up before the timeout.
> > The only way for WFE/WFET to wake up on need_resched() is to use LDXR to
> > arm the exclusive monitor. That's what smp_cond_load_relaxed() does.
> 
> Sorry no. The IPI will cause the WFE to continue immediately and not wait
> till the end of the timeout period.

*If* there is an IPI. The scheduler is not really my area but some
functions like wake_up_idle_cpu() seem to elide the IPI if
TIF_NR_POLLING is set.

But even if we had an IPI, it still feels like abusing the semantics of
smp_cond_load_relaxed() when relying on it to increment a variable in
the condition check as a result of some unrelated wake-up event. This
API is meant to wait for a condition on a single variable. It cannot
wait on multiple variables and especially not one it updates itself
(even if it happens to work on arm64 under certain conditions).

My strong preference would be to revive the smp_cond_load_timeout()
proposal from Ankur earlier in the year.

-- 
Catalin

