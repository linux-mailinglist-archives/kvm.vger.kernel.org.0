Return-Path: <kvm+bounces-54589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AA7B24C22
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 16:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D72D8835B0
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 14:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DB72FD1D8;
	Wed, 13 Aug 2025 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QeaVwn15"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B882BAF4;
	Wed, 13 Aug 2025 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755095634; cv=none; b=PcRcRtvFyUPc9xXQKy6QeF2lU5fjzto0WvKAkn3cNIhXffdx16gl+V4Hh5Tk104v2bu/by6N4EP2x3Wy5u8dm4XlUOxURCctMC1+a9xz2ph3S0NY5jShMdmlquv7CTcAJGdzpyXyH43CEBdFt+UHCzoQ/ZbTmy8z0PvgtnaXKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755095634; c=relaxed/simple;
	bh=Fu+RO8WAVcA0Zgbx8mN8inbozvoqAmdcqJjFd6RhOmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZ5SYiIYrvt9WMELnWEjg0Bk0o/eay78V08TPVR/QcEF+JF9BT0YhPSYF+pr5TKGyqa1ShLFvwJFgF6NJMcoF7nB4vVsdJTYDaiiN5otWX1cpl6gDto6eHXtNts7gdTXAlnYpy6s12ueJCZbcolzaA/7LnYwnQ8tyN6u8H48pec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QeaVwn15; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2oQFx/uIzAJByJDLz7BCZdxaMe1kWH0lqCl+hID0USE=; b=QeaVwn15tTMOR+A0F5FFKliQhr
	VnKTkzX3it99On2GwX4H8vh60Lc01pMfPk9aMSej8u0eBlh7yGxEmSkbREYm5Xic4bEoLY7DuZgNF
	SPcCbARPSvcBe3rXBimuqxkxt+OyPHmy3WcY6V4G+OseEDFYk38/j5daZnkIs5V+Z2uVSuhqKMsJy
	UmHBFQJpRyTrFqVclFT8wkVHW93frfFzqaZgAXSn2k9frSgS7EJ7cFRj+kMmmBoMWxCtLXnjtu3rR
	rMR75/a6X5fCLrsfF16cIhsa3BLpIdaDP+i84/uVUIymjKw7zGKO7R21YMav3Ss5kujzC6onRsHoG
	LNBAATqA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umCXs-00000009Uvw-2xnJ;
	Wed, 13 Aug 2025 14:33:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DDB553002C5; Wed, 13 Aug 2025 16:33:40 +0200 (CEST)
Date: Wed, 13 Aug 2025 16:33:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Wangyang Guo <wangyang.guo@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tianyou Li <tianyou.li@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Message-ID: <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813005043.1528541-1-wangyang.guo@intel.com>

On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
> When multiple threads waiting for lock at the same time, once lock owner
> releases the lock, waiters will see lock available and all try to lock,
> which may cause an expensive CAS storm.
> 
> Binary exponential backoff is introduced. As try-lock attempt increases,
> there is more likely that a larger number threads compete for the same
> lock, so increase wait time in exponential.

You shouldn't be using virt_spin_lock() to begin with. That means you've
misconfigured your guest.

We have paravirt spinlocks for a reason.

