Return-Path: <kvm+bounces-38798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3444CA3E6FE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45147189B946
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD121F03D8;
	Thu, 20 Feb 2025 21:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cihh62xD"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED181EA7ED
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 21:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088266; cv=none; b=f8YMxYrRRhBzxgNANFIarcXs1Hp/JFxNTS/tQWjoiW59Ab+EpiVbZSvOQRZdVehpaeI1QJhd2HOWOH50UuhXrZpykkpmLthedIw/h+njLvrCmkx2bRGIO3NI823sHSgM+eI51rtT6Hxjs1z9lsTwj9DdNCzG0201Fr9QQZ5v7Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088266; c=relaxed/simple;
	bh=POCua1poOqTKX9IA12fXvyapJ0I0k4Fee3XNGMFyIz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljmhwmcWWMWrMfM6WMQuLAunvsIkH9x4Sin7H1J7PTOwOGnLX+xSH8MZLKf+3AI9Ww12IsjLv8SGA5EGddC5fgG4xIW91NfhtTaJokoz4ZqXBzr6HxPUMsg6XX6ODkrX+gldFgeQ+mezcg3PVHbFPbwtvlEMrQEQjyYyK9mVvtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cihh62xD; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Feb 2025 21:50:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740088261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbpaDL5iHMBEhdVqgt+41QrD5QBpl3QLJHFsb3rcje4=;
	b=cihh62xDjZi0fekPiSBQjw0zchMMygB0z6t5P8JOHvuSdrF4J3ouAiiDDeMapd3ict2H9o
	bRXGYm26thKaxMgH9qyxctJxNDzsgMhVdXBTuWQvto/FQ/a0SaPVxMDxAQsl5dKSEvDOZe
	07x6U1LLk/BbqVqooVATKGVvqC8XceQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] IBPB cleanups and a fixup
Message-ID: <Z7ejvk31gYNCIwFv@google.com>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
 <20250220190444.7ytrua37fszvuouy@jpoimboe>
 <Z7eJurYbxS2kAzvk@google.com>
 <20250220204724.y3b6wx7y2ks3fuct@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220204724.y3b6wx7y2ks3fuct@jpoimboe>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 20, 2025 at 12:47:24PM -0800, Josh Poimboeuf wrote:
> On Thu, Feb 20, 2025 at 07:59:54PM +0000, Yosry Ahmed wrote:
> > > static inline void indirect_branch_prediction_barrier(void)
> > > {
> > > 	asm volatile(ALTERNATIVE("", "call write_ibpb", X86_FEATURE_IBPB)
> > > 		     : ASM_CALL_CONSTRAINT
> > > 		     : : "rax", "rcx", "rdx", "memory");
> > > }
> > > 
> > > I also renamed "entry_ibpb" -> "write_ibpb" since it's no longer just
> > > for entry code.
> > 
> > Do you want me to add this in this series or do you want to do it on top
> > of it? If you have a patch lying around I can also include it as-is.
> 
> Your patches are already an improvement and can be taken as-is:
> 
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> I'll try to dust off my patches soon and rebase them on yours.

SGTM, thanks!

> 
> -- 
> Josh

