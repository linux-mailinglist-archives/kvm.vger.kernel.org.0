Return-Path: <kvm+bounces-30073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A1C9B6BE9
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 216251F223B4
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FDC1CEACB;
	Wed, 30 Oct 2024 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spd94i9O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4EB1C461C;
	Wed, 30 Oct 2024 18:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730312058; cv=none; b=b5aTN/rOzeZbekJysiqyMNV8R94JcflLzyY0eqj+YtYL39pY7+MfvWEN5NDsIyK0l78dm6+BODtU70hB3VG4CQxDXoF1lQOizU0Hapve7J7VAFZRE7LvRIj4Unjo2NKEzlKe/tpTpWrqkpCkdQlWmLB7jGbxfHVdvtjcvnLl1+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730312058; c=relaxed/simple;
	bh=Hp4P5E8ely9zsB83xiSQXu4DK6HwPjHt34n6+iI16kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cs2bx72ZeJepf8djEyIzrPvOo6uZrUaBGljYioHvm4FXuT+UEXInFHC6MgWjGuJiUQQaMZwp47OTif7eMUtGKMCMVmUPOJBYIFQ5IuUCCa+wndNMY2C10J3YjmRnLJABXjfHvvxrVRTbayiZv7b9oP2QOQAKzsShzgwDvLFdggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spd94i9O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98360C4CECE;
	Wed, 30 Oct 2024 18:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730312057;
	bh=Hp4P5E8ely9zsB83xiSQXu4DK6HwPjHt34n6+iI16kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spd94i9OUodgg7FbaNHdc7Lz92HUvi9IstXOX9DMPMlG7CR1cuZLV+ZDgwaZW3NIE
	 iqSWWdMXfM5ZEe5WanBcpiOVVS5rW5scAHWvhDm7B0CBls8amAzzGcsblbruo35zf3
	 lqU7wVfFUY/hi1Ihqx48Z80CBjoy3Za/SkCDMXpstS5oWmvNx8KSQ2e85ENy5wHfeu
	 k8ZVqy5WWuYXKnAFPt11Ys1e307uT2SUGH1/V01THA8OB2tNMZU0kIQqeeCk3hSorH
	 UrsxOLEMyeA5/OpMsNKHS2Mslo9DygZ7OlfrUUKuk+5lk09Z+Gsbnn3WIz2Z8HSnxq
	 xm1MwgY56tvvg==
Date: Wed, 30 Oct 2024 08:14:16 -1000
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Luca Boccassi <bluca@debian.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	linux-kernel@vger.kernel.org
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
Message-ID: <ZyJ3eG8YHeyxqOe_@slm.duckdns.org>
References: <ZyAnSAw34jwWicJl@slm.duckdns.org>
 <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>
 <ZyF858Ruj-jgdLLw@slm.duckdns.org>
 <CABgObfYR6e0XV94USugVOO5XcOfyctr1rAm+ZWJwfu9AHYPtiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYR6e0XV94USugVOO5XcOfyctr1rAm+ZWJwfu9AHYPtiA@mail.gmail.com>

Hello,

On Wed, Oct 30, 2024 at 01:05:16PM +0100, Paolo Bonzini wrote:
> On Wed, Oct 30, 2024 at 1:25 AM Tejun Heo <tj@kernel.org> wrote:
> > > I'm not sure if the KVM worker thread should process signals.  We want it
> > > to take the CPU time it uses from the guest, but otherwise it's not running
> > > on behalf of userspace in the way that io_wq_worker() is.
> >
> > I see, so io_wq_worker()'s handle signals only partially. It sets
> > PF_USER_WORKER which ignores fatal signals, so the only signals which take
> > effect are STOP/CONT (and friends) which is handled in do_signal_stop()
> > which is also where the cgroup2 freezer is implemented.
> 
> What about SIGKILL? That's the one that I don't want to have for KVM
> workers, because they should only stop when the file descriptor is
> closed.

I don't think SIGKILL does anything for PF_USER_WORKER threads. Those are
all handled in the fatal: label in kernel/signal.c::get_signal() and the
function just returns for PF_USER_WORKER threads. I haven't used it myself
but looking at io_uring usage, it seems pretty straightforward.

> (Replying to Luca: the kthreads are dropping some internal data
> structures that KVM had to "de-optimize" to deal with processor bugs.
> They allow the data structures to be rebuilt in the optimal way using
> large pages).
> 
> > Given that the kthreads are tied to user processes, I think it'd be better
> > to behave similarly to user tasks as possible in this regard if userspace
> > being able to stop/cont these kthreads are okay.
> 
> Yes, I totally agree with you on that, I'm just not sure of the best
> way to do it.
> 
> I will try keeping the kthread and adding allow_signal(SIGSTOP).  That
> should allow me to process the SIGSTOP via get_signal().

I *think* you can just copy what io_wq_worker() is doing.

Thanks.

-- 
tejun

