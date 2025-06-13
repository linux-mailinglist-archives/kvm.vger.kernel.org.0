Return-Path: <kvm+bounces-49390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97009AD83A6
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C7BF7AAD0B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB1325B1C4;
	Fri, 13 Jun 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XpRr+gSf"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2671EE7C6;
	Fri, 13 Jun 2025 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749798398; cv=none; b=g9IdsBEvnWDNOpfEZI1OraYDjB6MuIyQTe52MRrL+CFMCXL+2obR+JEmatf0dG+JuawlO3SPF8oMMKOjZ+5sVMF3SvXW9b0TjLX6cLinAArPtdQNuTk4mK2sKZEUVf4qt3vo6ylFiM9Hs/4F0wfCVGIYaqnjGRZwLKB+nkZaABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749798398; c=relaxed/simple;
	bh=IHAV7nN6wCNIFQtTRtd4JrisWL7tQ9SP/C8Yiz9z6NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4CyhQMgyUQr776wjy6rB6kFoEtQAUG2Bd2HOCxpkUwtxsBxYErGGWEEaKI7WQ/4eaRylHnO8yJkeC7B2QsbAuiV76HZjWw2iQT86ESweclL/Rq5pMrTzMKwYNwGB4mPuk6uu5ElAnx6tBqsR83U6pYzaUuZbbOCElNIFD1DgZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XpRr+gSf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UgEEh5fEgXDb+CnFS0SJsFPqsYxRiY/6CHzoXKuVSq0=; b=XpRr+gSf7eHZm/SvMSk2BRK55i
	zvnTYKkkC7UhTM8baykOP0fG89XftqUEIJloIJ4aaUPnObzFpe+DTVSsj82sLbztMVoAFD5qBCgQF
	Coeq/L+duldKcBhXbKAgQPbwU3W4mbxU0zzEA7iPmRuFo0eD53oqnXwF53Yr8hRVHfGIwVaef8NKy
	dmh3P4kPB3j0WtLBnRvPaOgEt1jeA3hQkwcPQ93IMlD2GylVDpKMNKiSPc50+OyjGUGF/oMspCSBp
	uwzdSgTgti/cYWtaAx352O5rqlxqRBzcKA5i/GLYcmTQbhLRj6KRpTkz6hv08xFllPEFop+1e8Tk0
	4Ey7LRQA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPyUZ-00000002sn4-1cF9;
	Fri, 13 Jun 2025 07:06:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 273C530BC56; Fri, 13 Jun 2025 09:06:19 +0200 (CEST)
Date: Fri, 13 Jun 2025 09:06:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
	kvm@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
 FRED
Message-ID: <20250613070619.GF2273038@noisy.programming.kicks-ass.net>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>

On Thu, Jun 12, 2025 at 02:48:39PM -0700, Sohil Mehta wrote:

> Jacob Pan (1):
>   perf/x86: Enable NMI-source reporting for perfmon
> 
> Sean Christopherson (1):
>   x86/fred: Provide separate IRQ vs. NMI wrappers for entry from KVM
> 
> Sohil Mehta (8):
>   x86/fred: Pass event data to the NMI entry point from KVM
>   x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
>   x86/nmi: Extend the registration interface to include the NMI-source
>     vector
>   x86/nmi: Assign and register NMI-source vectors
>   x86/nmi: Add support to handle NMIs with source information
>   x86/nmi: Prepare for the new NMI-source vector encoding
>   x86/nmi: Enable NMI-source for IPIs delivered as NMIs
>   x86/nmi: Print source information with the unknown NMI console message

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>


