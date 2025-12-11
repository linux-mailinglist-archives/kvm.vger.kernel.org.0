Return-Path: <kvm+bounces-65755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AABE7CB58FC
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD2EB301D593
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1B7306B3C;
	Thu, 11 Dec 2025 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qzWNnb3v"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA74317D;
	Thu, 11 Dec 2025 10:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450267; cv=none; b=eB7GfH9vZBxyKPW2lAFlJMsiYotwq3scCK2LEHgmdhwGccaJCtx7es29uzz/yM4iYVlgE4R8tmUftfeaDmrBKPE5u+76wDnPtrfHTG00JuMT11P99uXO3RcpHczkpxIBDGe+MlGB8JBwadqtIGTzKIixkTkqLjZhEE/Px9w1P+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450267; c=relaxed/simple;
	bh=GWygM3x7+hqXAz+c7Pscc3NwAUM7JoNWjc70ap7XnOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjtsyjIQ+Y2sM6r8bKamOzPHX6V3is9EKOuSiQeE3hdMw6cE0llxGhDS9hjphS65oVY3wPySDPGubdRPNv22Yp8cniw+oYp+su+Bq9LQE+RzB3wNDH3M4kID41axh7568iS7F9FaX6EuwjfIF4YS6tp2nbP4hkQ0XV8SV8qjlaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qzWNnb3v; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TtlbzqbRLXFDNB23fI071mEx9a4si+wr83gFgHx75fk=; b=qzWNnb3vDUtOmby/6rRXEF7QKT
	GS9yh3t/Pf9pYR2EDfORT1wdcR3e3IyHexNzLc4euHhiRpxqbWbIlFjjAt8H5n7UfNT5CZFEOo2d5
	CII+rHjVrVpvl5ITy4At0zBf93ruwAHWb7Nb6+6NERA4SWagpZ8AqjV1WBYQ0KdhcIxxvW6imMUvi
	tJcy5Shpzyg9Yz70sUtvPvehf5nrJ1Yv5rVxbCQ97KEd/adqKyi5631aBfZR88bW0o66aAhQZUHk6
	QmcR89EwwrwvT0UB/hlRYMSKhNgi4sfeZMyiGEM3+IO82nnBK1KNYqMrt5d/tNjXBq9xPKld2FvBd
	QNxpB4QA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTeG3-0000000E8Ht-3Ghx;
	Thu, 11 Dec 2025 10:50:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6402730301A; Thu, 11 Dec 2025 11:50:50 +0100 (CET)
Date: Thu, 11 Dec 2025 11:50:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 6/9] x86/vmscape: Use static_call() for predictor flush
Message-ID: <20251211105050.GB3707891@noisy.programming.kicks-ass.net>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>

On Mon, Dec 01, 2025 at 10:20:14PM -0800, Pawan Gupta wrote:
> Adding more mitigation options at exit-to-userspace for VMSCAPE would
> usually require a series of checks to decide which mitigation to use. In
> this case, the mitigation is done by calling a function, which is decided
> at boot. So, adding more feature flags and multiple checks can be avoided
> by using static_call() to the mitigating function.
> 
> Replace the flag-based mitigation selector with a static_call(). This also
> frees the existing X86_FEATURE_IBPB_EXIT_TO_USER.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/Kconfig                     | 1 +
>  arch/x86/include/asm/cpufeatures.h   | 2 +-
>  arch/x86/include/asm/entry-common.h  | 7 +++----
>  arch/x86/include/asm/nospec-branch.h | 3 +++
>  arch/x86/kernel/cpu/bugs.c           | 5 ++++-
>  arch/x86/kvm/x86.c                   | 2 +-
>  6 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fa3b616af03a2d50eaf5f922bc8cd4e08a284045..066f62f15e67e85fda0f3fd66acabad9a9794ff8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2706,6 +2706,7 @@ config MITIGATION_TSA
>  config MITIGATION_VMSCAPE
>  	bool "Mitigate VMSCAPE"
>  	depends on KVM
> +	select HAVE_STATIC_CALL

That can't be right.

