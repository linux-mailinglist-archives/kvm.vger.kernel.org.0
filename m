Return-Path: <kvm+bounces-28958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 650E099FBFF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 01:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C5271F26067
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 23:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8321D63FD;
	Tue, 15 Oct 2024 23:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="CgWL/MaV"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43A51B6D02;
	Tue, 15 Oct 2024 23:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033250; cv=none; b=pd1w+LGDOlAZVdvNI2sZ/l2XKUZu3CXzQhGDqgyfe6pmeFIu7e5LpASUp2uSTsxYoLlmFg3gr0lzVGAey7xB5mLYixSJnjxepXcaLcK/paMsahdwLVV1Q/krIBms7JosdfY7IBIxU2OR9zTBgrqcGrdwoxnRTQd6ePvR8hDJeOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033250; c=relaxed/simple;
	bh=s2sAgDifVxh2D70yrHm8O3djooQiAhAi3w3ifnOaOSg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HC9SqzCxdvAXyeihm4XR6McKsLx/7ibfZ4mxp9qONBM4V6XCcmwUVzkxvvE7BVtA1KrVV0xbaROv9BdNr6IToTV9IdsxILV3H2G8Vvp4TGkPn5mSQvvvbF90tj0qHnbPQg8Cz091Yh2Yo7whmQBG6EVQe33dh7uav/8DhMctwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=CgWL/MaV; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729031330;
	bh=s2sAgDifVxh2D70yrHm8O3djooQiAhAi3w3ifnOaOSg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=CgWL/MaVR5Nl/nikdOSwGmIaDEuJOg+LkR+mHcUDRPxCPlkNnHE7sOphB+16UAIBr
	 mtgNiGU7q46cXWSKrFqpTXY8yV+vN3KArXdyJHxJHI07pSdduYzm/3gVsbJ/sjkGTy
	 63ToLMRltTHWVL3uyl1O2DQXvro83S627eWEJvVc=
Received: by gentwo.org (Postfix, from userid 1003)
	id 78E29401D1; Tue, 15 Oct 2024 15:28:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 77708400C9;
	Tue, 15 Oct 2024 15:28:50 -0700 (PDT)
Date: Tue, 15 Oct 2024 15:28:50 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-pm@vger.kernel.org, 
    kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <87jze9rq15.fsf@oracle.com>
Message-ID: <2c232dc6-6a13-e34b-bdcc-691c966796d4@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com> <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org> <Zw6dZ7HxvcHJaDgm@arm.com> <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 15 Oct 2024, Ankur Arora wrote:

> > Alternatively, if we get an IPI anyway, we can avoid smp_cond_load() and
> > rely on need_resched() and some new delay/cpu_relax() API that waits for
> > a timeout or an IPI, whichever comes first. E.g. cpu_relax_timeout()
> > which on arm64 it's just a simplified version of __delay() without the
> > 'while' loops.
>
> AFAICT when polling (which we are since poll_idle() calls
> current_set_polling_and_test()), the scheduler will elide the IPI
> by remotely setting the need-resched bit via set_nr_if_polling().

The scheduler runs on multiple cores. The core on which we are
running this code puts the core into a wait state so the scheduler does
not run on this core at all during the wait period.

The other cores may run scheduler functions and set the need_resched bit
for the core where we are currently waiting.

The other core will wake our core up by sending an IPI. The IPI will
invoke a scheduler function on our core and the WFE will continue.

> Once we stop polling then the scheduler should take the IPI path
> because call_function_single_prep_ipi() will fail.

The IPI stops the polling. IPI is an interrupt.



