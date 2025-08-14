Return-Path: <kvm+bounces-54660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B0FB26310
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 284493BAD20
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 10:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3002F39C7;
	Thu, 14 Aug 2025 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZGgRear0"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54FB2264CF;
	Thu, 14 Aug 2025 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755168134; cv=none; b=iShjIcye4AVU1fnm2i3xNXYWeogQgk4kOqwE0mG6rPD1rjZcBY6XcAksHlFMDYm7MBfq08fuqh144lBjt75iLCX+dy0xtYu0R8T7zUPrMIhgHJg9Wtg3UI1yRcbwpvziNOaEfFQJwYCSu0ezHuHItuLean5PLA8a2xFq+k4HauE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755168134; c=relaxed/simple;
	bh=FtwTDWHhm6FvAD2+bKOXe4xQIL/YdU0DRKhvxTod5WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RjCU3WoQsUMzw+0eNHivtmEDFxPWe4seEMzkgD3fe2oe1plwGMajLliraQJAc1rkshC4ezAt2ybpPBuig0H0H8ZhANCwwhtFdEPRi7meB2uetaWbpyv0XzDq4tw97dt0m5FB4IJ6Yoq/rygTKzwByIs7ghS3tUIwKThT4Bb2Ixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZGgRear0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l8uwEsQZKUpDteaOoWXKM3kL2chesBMD7e+UzFSX47U=; b=ZGgRear02ftVnHNFzb8OW1OJgj
	GiW7xotNcv4ks6ksDWgFRUq1zcng2KwP5wOnU5LF9/7DLcMsxKu3e0nx3Jm4CgWcrEz4YuwhTwMeW
	NuEazVgjoFbfZZjhWnpRc861wSsCclqVdaTdjTALZQeRiuJcl75vIB4gree/UC+fwpnMPNBep25WT
	MJhGhT364xmc5sNfZWE5ASsu+nsJS4MCmxRb9OL5T9oJSqBW1g7NNivBRa8/wMmcfg2ns9pR2N0Tz
	aYOavTxXD6o7r3oHMW3TfQBPZRBHxnKeqSe3FLaUqwQdBIvQL8SZmfxx910MvJI9//3280ZLBjAXc
	2bhZyZXw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umVPA-0000000HGJN-1phW;
	Thu, 14 Aug 2025 10:41:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6F4B43002C5; Thu, 14 Aug 2025 12:41:56 +0200 (CEST)
Date: Thu, 14 Aug 2025 12:41:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "Guo, Wangyang" <wangyang.guo@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [????] RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism
 to virt_spin_lock
Message-ID: <20250814104156.GV4067720@noisy.programming.kicks-ass.net>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
 <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
 <bb474c693d77428eb0336566150a1ea3@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb474c693d77428eb0336566150a1ea3@baidu.com>

On Thu, Aug 14, 2025 at 03:10:46AM +0000, Li,Rongqing wrote:
> > On 8/13/2025 10:33 PM, Peter Zijlstra wrote:
> > > On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
> > >> When multiple threads waiting for lock at the same time, once lock
> > >> owner releases the lock, waiters will see lock available and all try
> > >> to lock, which may cause an expensive CAS storm.
> > >>
> > >> Binary exponential backoff is introduced. As try-lock attempt
> > >> increases, there is more likely that a larger number threads compete
> > >> for the same lock, so increase wait time in exponential.
> > >
> > > You shouldn't be using virt_spin_lock() to begin with. That means
> > > you've misconfigured your guest.
> > >
> > > We have paravirt spinlocks for a reason.
> > 
> > We have tried PARAVIRT_SPINLOCKS, it can help to reduce the contention cycles,
> > but the throughput is not good. I think there are two factors:
> > 
> > 1. the VM is not overcommit, each thread has its CPU resources to doing spin
> > wait.
> 
> If vm is not overcommit, guest should have KVM_HINTS_REALTIME, I think native qspinlock should be better
> Could you try test this patch
> https://patchwork.kernel.org/project/kvm/patch/20250722110005.4988-1-lirongqing@baidu.com/

Right, that's the knob.

> Furthermore, I think the virt_spin_lock needs to be optimized.

Why would virt_spin_lock() need to be optimized? It is the fallback
case; but it is terrible in all possible ways.

