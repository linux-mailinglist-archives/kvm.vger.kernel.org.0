Return-Path: <kvm+bounces-54659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FCCB262FC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 704F91891A90
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 10:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE292F83C1;
	Thu, 14 Aug 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BKYY7Wsn"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA95318133;
	Thu, 14 Aug 2025 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755168005; cv=none; b=uQBuDvPKWy9sVSFMlxgTrV78jTPaRoWuCANxo+qYnwtXKtIvacqeNx2y7f7+/v0vrl1ks2xJ9IKgSdPOB934oS9SH/7J9vmpVulf9yOvmpemZqvA1D7YKrWHt+7IvAjSSPiHDmVB0DYJx/i1LCF2iAYj7/ZkRMZ4cMUs3JEQnhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755168005; c=relaxed/simple;
	bh=4z5aJDqdUGD8a9K3p88yavYummtGNzNjWqsrw44KwiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/KdArrUcWFE5KAfpLu/u7A7g3Jhze1me3aev9EoSWJR28yYnVnDojZVRCE3DSgtyx4yzq4WlgI2qyhbkXhw3Cb83leuPtvbavs/C9tGgG0wD10DtEUg4qbA8+RDgaEy2MSVOJ7s8dWkeJ6ss1byQ4D/0sMHhcRPklrWU6Xb/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BKYY7Wsn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FZaP3+hCbIl4kDYSfEdBVeoYqO8r7N96D5qhwPiPeJw=; b=BKYY7WsnLBbjPgqf52BM+YQxNR
	TECoXnoVtI8uy2uOc3yeMpDVqJJI+vTl4dl/WqJ5x4TRtlJPTmH++dRzjD0olUUKbxpeydSZMmT9o
	RPYKnw54eC2rHhBuEYWAi5izQEGHBOOzbz8eekOKfJGMFANzSeSl9nqDuvEE8PXtsW5Kv9amOSfKx
	nuvoGO+isZA7dvoz0kMXdRdVLXGnpbS9iv7SfEEoTraOrJ8CNTHMOmhFc1SPQ3Fk4LO3b9afP/JWU
	hSlTbbciIDoNWZn9PoiLITh99+da54FDae8RnFna++Lpk0R2LMy5udPnYTqVOLW8qk7KY9mn5c1yO
	ddIJyZRA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umVND-0000000GMhI-0tdD;
	Thu, 14 Aug 2025 10:39:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6AFD83002C5; Thu, 14 Aug 2025 12:39:53 +0200 (CEST)
Date: Thu, 14 Aug 2025 12:39:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Guo, Wangyang" <wangyang.guo@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
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
Subject: Re: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Message-ID: <20250814103953.GU4067720@noisy.programming.kicks-ass.net>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
 <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>

On Thu, Aug 14, 2025 at 01:26:59AM +0000, Guo, Wangyang wrote:
> On 8/13/2025 10:33 PM, Peter Zijlstra wrote:
> > On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
> >> When multiple threads waiting for lock at the same time, once lock owner
> >> releases the lock, waiters will see lock available and all try to lock,
> >> which may cause an expensive CAS storm.
> >>
> >> Binary exponential backoff is introduced. As try-lock attempt increases,
> >> there is more likely that a larger number threads compete for the same
> >> lock, so increase wait time in exponential.
> > 
> > You shouldn't be using virt_spin_lock() to begin with. That means you've
> > misconfigured your guest.
> > 
> > We have paravirt spinlocks for a reason.
> 
> We have tried PARAVIRT_SPINLOCKS, it can help to reduce the contention cycles, but the throughput is not good. I think there are two factors:
> 
> 1. the VM is not overcommit, each thread has its CPU resources to doing spin wait.

In the non-overcommit, physically pinned case, there is a knob to use
native spinlocks.

