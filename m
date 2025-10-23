Return-Path: <kvm+bounces-60887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E5EC01B29
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 16:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D512518825D4
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 14:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B9A329C6A;
	Thu, 23 Oct 2025 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QTgeDPgE"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF848328B5F;
	Thu, 23 Oct 2025 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761228973; cv=none; b=YEBZMo7y0EWPnluFeMxGwMlkZFdfXQK4gHS8xFfoq9Uik+jbnopt40NqHnRnfRFh1775bO+aKfqNurSSmhzsy8qDyuW+MEanLCrf+pu4PsQkWrRWZTaMMJXZNLDPQrfOz5wuByXzhXn4/6RkzVoj9JQucysCUv8uyS0VisVWlMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761228973; c=relaxed/simple;
	bh=t5oB8u6KOBHxdh8uj3il37PAEyxoN25MKxzOJAmB3Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mx4SUawmZAvyXxuLk0mlckfAjymOFx/dQ8g0ZgOqzP4oskzQgCtHgW80EqJlDt6S4Rerqk12NOsJKfYZ8Rh6itVtKIE0vdwt5ojyhwLhxxcF+16nNv69yeUehwLaIsX3IHonAMy5UcOM8KrPF9AEbbOWLvqSwvhEYqj+zLm5DXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QTgeDPgE; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uQSt7hl0x/heUJPTydNKzraeSQQOcHq+GQp+Qtdpe+s=; b=QTgeDPgEJ1OJ0mwomA/hngBZUw
	fmlS9WzhTA9qfGd9KIAkwXefVgOd0BNCGUqQ3rvC4CfK5bBEppHW+QDM5a03ACNAIarBHLwThqbm8
	YdTUMQ9ZOG6Pxi+vZjKDzqXOMrxNimGMLAtZOsO6l6bpABn/ABV6Nx5DHrcdc9TlZ6w5CSvshybQ5
	5kHE/oON7+n8qB94yW4fNr44eO5kNJlP58V9ohvVYTofmFuxpaWPls/FUUYJVQOrUOkdHCNTJA5LR
	A4pNlYYxF7hyhUN9ZRXbx0B1lyP5CvgoRNtqR0eCx79qRNTjmYT1/wVyeeG0DFaCCChDLB6aE5S4A
	+2D7GC1w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBw6b-00000004vem-04lr;
	Thu, 23 Oct 2025 14:15:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EF70630039F; Thu, 23 Oct 2025 16:15:52 +0200 (CEST)
Date: Thu, 23 Oct 2025 16:15:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
	hch@infradead.org
Subject: Re: [PATCH v8 05/21] x86/cea: Export API for per-CPU exception
 stacks for KVM
Message-ID: <20251023141552.GA3245006@noisy.programming.kicks-ass.net>
References: <20251023080627.GV3245006@noisy.programming.kicks-ass.net>
 <C28589B9-F758-4851-A6FD-41001C99137D@zytor.com>
 <aPo2xlsq0PFdx31u@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPo2xlsq0PFdx31u@google.com>

On Thu, Oct 23, 2025 at 07:08:06AM -0700, Sean Christopherson wrote:
> On Thu, Oct 23, 2025, Xin Li wrote:
> > 
> > >> FRED introduced new fields in the host-state area of the VMCS for stack
> > >> levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
> > >> per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
> > >> fields each time a vCPU is loaded onto a CPU.
> > > 
> > >> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
> > >> +{
> > >> +    return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
> > >> +}
> > >> +EXPORT_SYMBOL(__this_cpu_ist_top_va);
> > > 
> > > This has no business being a !GPL export. But please use:
> > > 
> > > EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_val, "kvm");
> > > 
> > > (or "kvm-intel", depending on which actual module ends up needing this
> > > symbol).
> > 
> > Will do “kvm-intel” because that is the only module uses the APIs.
> 
> Alternatively, what about a slightly more automated approach, at the cost of some
> precision?  The below adds EXPORT_SYMBOL_FOR_KVM and only generates exports for
> pieces of KVM that will be build as a module.  The loss of precision is that a
> symbol that's used by one KVM module would get exported for all KVM modules, but
> IMO the ease of maintenance would be worth a few "unnecessary" exports.  We could
> also add e.g. EXPORT_SYMBOL_FOR_KVM_{AMD,INTEL}, but I don't think that adds much
> value over having just EXPORT_SYMBOL_FOR_KVM().

Works for me.

