Return-Path: <kvm+bounces-29279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B03EC9A677B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72078283029
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D681EABDE;
	Mon, 21 Oct 2024 12:03:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E451E9090;
	Mon, 21 Oct 2024 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512184; cv=none; b=XnmGjtJAn8uXyKl8roHPuTnKweicvgyX6OyV4NBz37m/16eiOlzKXsrs6NkE9LL5za0f3c8TOMDAciIKRJDWSKgQUNBl1AaUZaMzUlhIJUVTojib4O/IEwFmC5zWjtdIuB3OLPDl3lxin0VvGle+z1pSwVcxN9mhNV2VN6Oiu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512184; c=relaxed/simple;
	bh=wLc56yfBrI+GsGTQNi0QL709D7IVdO7b1wOCRHOM9O0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYAB7k/hL3rI/kL387S57VWg5OFsel3XjOvq6IJKMd81Vq6X1vKbRMck6pB7lPOt9QcAmwQzZSn1JOeAcIe+H2r/WUYdw0Fd5odYxOuau5iX40oV4PfeEdXjx0zk1CsjG/6gq1/0I0WSHsUbiZta3rBq7x67UPJmgiJYccNz6aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E27C4CEE6;
	Mon, 21 Oct 2024 12:02:58 +0000 (UTC)
Date: Mon, 21 Oct 2024 13:02:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "Okanovic, Haris" <harisokn@amazon.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>,
	"cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
	"daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <ZxZC8Pg1qwULeirJ@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
 <ZxEYy9baciwdLnqh@arm.com>
 <87h69amjng.fsf@oracle.com>
 <ZxJBAubok8pc5ek7@arm.com>
 <87jze5kzhp.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jze5kzhp.fsf@oracle.com>

On Fri, Oct 18, 2024 at 12:00:34PM -0700, Ankur Arora wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Thu, Oct 17, 2024 at 03:47:31PM -0700, Ankur Arora wrote:
> >> So maybe the right thing to do would be to keep smp_cond_load_timeout()
> >> but only allow polling if WFxT or event-stream is enabled. And enhance
> >> cpuidle_poll_state_init() to fail if the above condition is not met.
> >
> > We could do this as well. Maybe hide this behind another function like
> > arch_has_efficient_smp_cond_load_timeout() (well, some shorter name),
> > checked somewhere in or on the path to cpuidle_poll_state_init(). Well,
> > it might be simpler to do this in haltpoll_want(), backed by an
> > arch_haltpoll_want() function.
> 
> Yeah, checking in arch_haltpoll_want() would mean that we can leave all
> the cpuidle_poll_state_init() call sites unchanged.
> 
> However, I suspect that even acpi-idle on arm64 might end up using
> poll_idle() (as this patch tries to do:
> https://lore.kernel.org/lkml/f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com/).
> 
> So, let me try doing it both ways to see which one is simpler.
> Given that the event-stream can be assumed to be always-on it might just
> be more straight-forward to fallback to cpu_relax() in that edge case.

I agree, let's go with the simplest. If one has some strong case for
running with the event stream disabled and idle polling becomes too
energy inefficient, we can revisit and add some run-time checks.

-- 
Catalin

