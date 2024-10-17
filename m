Return-Path: <kvm+bounces-29104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D43159A2ADE
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B6CC1F221FB
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8311DFE1A;
	Thu, 17 Oct 2024 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="L0Gevzpo"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9305E1DFDB5;
	Thu, 17 Oct 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729185960; cv=none; b=rwrznJq896if183++MEaWx5CjWkIYUSYKMDbUSX7HE2Nr2Y9LN0eFgyOydYASwl8uv58zY5ujC5Xj7lEe9IYg7BuXtOrDTXuIkFH614lcxbw1tjpN8EvKXz6SNUsHXeWUaIxilSS7xVaKWN6jDaRXD+oSaIwXAPpjPinOzA2MT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729185960; c=relaxed/simple;
	bh=oxTupLXSgxbLn39ngHQOrPR9z7y/bIXj7Kei68yHNAM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IZ7EGhZL6B0C655twwLjyqemPjJ/oZtWVwGI8pf+IdKAbY+O1c+J3s6qv955YiFP9tguJklg7fMqCs96/bmnqhK3pOI+ZIi7ogxexUbF73AzfrOyOPpq3hlBGvgtsfvQ4jpzKrr4WYJYWwtO0chaEb2E6X0fbsG/wOpoaxvoIVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=L0Gevzpo; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729184074;
	bh=oxTupLXSgxbLn39ngHQOrPR9z7y/bIXj7Kei68yHNAM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=L0GevzpoDEAMzElBztpL1IWC/IxrvBuA849C4ewpzp9+I63Bjnl8V7oWWsDEi6x4u
	 WXrb3V16oKlo/eebJBlEyHBU7XvC3VUmG7PzBVRAUR9VOlQ9nJrOZQg1XHxnszu91C
	 Bv7KsLgC8BHeV1vx5Y1ITmA/7Wz6lNZzOUUmX/bk=
Received: by gentwo.org (Postfix, from userid 1003)
	id C754540280; Thu, 17 Oct 2024 09:54:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C5197400C9;
	Thu, 17 Oct 2024 09:54:34 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:54:34 -0700 (PDT)
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
In-Reply-To: <87frowr0fo.fsf@oracle.com>
Message-ID: <a07fb08b-d9d0-c9cc-8e03-3857d0adffdf@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com> <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org> <Zw6dZ7HxvcHJaDgm@arm.com> <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com> <2c232dc6-6a13-e34b-bdcc-691c966796d4@gentwo.org> <87frowr0fo.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 16 Oct 2024, Ankur Arora wrote:

> > The other core will wake our core up by sending an IPI. The IPI will
> > invoke a scheduler function on our core and the WFE will continue.
>
> Why? The target core is not sleeping. It is *polling* on a memory
> address (on arm64, via LDXR; WFE). Ergo an IPI is not needed to tell
> it that a need-resched bit is set.

The IPI is sent to interrupt the process that is not sleeping. This is
done so the busy processor can reschedule the currently running process
and respond to the event.

It does not matter if the core is "sleeping" or not.



