Return-Path: <kvm+bounces-66226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9962CCCAE36
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29520302AA8D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1198F3321C0;
	Thu, 18 Dec 2025 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rd5f9NME"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58D7331A5C;
	Thu, 18 Dec 2025 08:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046677; cv=none; b=DRU41opt9IvYpfVuuHSmqi+TCVbmsoJuy2KfG7Nk8V+r85oE7xsg8vfRn+pfNDZDS4wRduGLHXI561ssJV/+/ULU4id5BMPF7STNL5B80TI/ljQ1P2SjTlcolLOSwIazv/3sjAtBHpDI+PeDQvoyvWehcH/c3DEpHfm3n1Y+l/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046677; c=relaxed/simple;
	bh=X3Pm6WpDTao+VyEigDp3JyFPbIz3m6kNdCOpBeXjY1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nw6+aZ0umWZoibmVw8gvoBB9r1I+e9UrsFqTEURq7e1ETAoSxYcjOk3k24M9mXOIldMUkBAjPTDzWSUCbgXFmCeCba6HfyRQ948+nRHtKf0AGQFryecNJm5gUyxa50wCFzKm7JXy3BPN7+T37/Db4WzGHOZh7nPLwmU9RMNcB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rd5f9NME; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rb1jGLkcv8Xq6Yvu+oLcDAWq4uvoL+KDLxzo3fwEyJY=; b=rd5f9NMEZMPsR6Z2mZxNuVb8BL
	MipG0HiIKRycemdZTx260H1JA5TAkjdXwkCWPtJC4119MHlbawzuiepsWM1nwzmSBWSwUvDOBSA5X
	nXHj/T9xujOgThZuGrYQcpnI+/qNkAU5idFUVemEEvYUNmg+BCF8UwRRJ9eaFyhxVQerQjNaO/psn
	YFR/nXuROijo7TNrmcP/rn3aTnpFXcUwzU2Fl2lG5EtDz3sFbXwQFG2or9OjqCoZXcY4H1kOQ3p5N
	4a3mt/M8O+w0aZszbHdUcDZ9MN3KUNNf632xjyUBZjjfwhJf4h36QSZnpRb9L3IBw/V68JKEuQzeI
	Qzrh/w3g==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW9Ph-00000005qsL-3THl;
	Thu, 18 Dec 2025 08:31:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 40D2D30056B; Thu, 18 Dec 2025 09:31:09 +0100 (CET)
Date: Thu, 18 Dec 2025 09:31:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, seanjc@google.com, sfr@canb.auug.org.au
Cc: linux-tip-commits@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [tip: perf/core] perf: Use EXPORT_SYMBOL_FOR_KVM() for the
 mediated APIs
Message-ID: <20251218083109.GH3707891@noisy.programming.kicks-ass.net>
References: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
 <176597507731.510.6380001909229389563.tip-bot2@tip-bot2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176597507731.510.6380001909229389563.tip-bot2@tip-bot2>

On Wed, Dec 17, 2025 at 12:37:57PM -0000, tip-bot2 for Peter Zijlstra wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index e6a4b1e..376fb07 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -57,6 +57,7 @@
>  #include <linux/task_work.h>
>  #include <linux/percpu-rwsem.h>
>  #include <linux/unwind_deferred.h>
> +#include <linux/kvm_types.h>
>  
>  #include "internal.h"
>  
> @@ -6388,7 +6389,7 @@ int perf_create_mediated_pmu(void)
>  	atomic_inc(&nr_mediated_pmu_vms);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
> +EXPORT_SYMBOL_FOR_KVM(perf_create_mediated_pmu);
>  
>  void perf_release_mediated_pmu(void)
>  {
> @@ -6397,7 +6398,7 @@ void perf_release_mediated_pmu(void)
>  
>  	atomic_dec(&nr_mediated_pmu_vms);
>  }
> -EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
> +EXPORT_SYMBOL_FOR_KVM(perf_release_mediated_pmu);
>  
>  /* When loading a guest's mediated PMU, schedule out all exclude_guest events. */
>  void perf_load_guest_context(void)

Bah, so the !KVM architectures hate on this.

Sean, would something like this be acceptable?

---
Subject: kvm: Fix linux/kvm_types.h for !KVM architectures

As is, <linux/kvm_types.h> hard relies on architectures having
<asm/kvm_types.h> which (obviously) breaks for architectures that don't
have KVM support.

This means generic code (kernel/events/ in this case) cannot use
EXPORT_SYMBOL_FOR_KVM().

Rearrange things just so that <linux/kvm_types.h> becomes usable and
provides the (expected) empty stub for EXPORT_SYMBOL_FOR_KVM() for !KVM.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a568d8e6f4e8..a4cc13e41eec 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -6,6 +6,8 @@
 #include <linux/bits.h>
 #include <linux/export.h>
 #include <linux/types.h>
+
+#ifdef CONFIG_KVM
 #include <asm/kvm_types.h>
 
 #ifdef KVM_SUB_MODULES
@@ -20,13 +22,14 @@
  * if there are no submodules, e.g. to allow suppressing exports if KVM=m, but
  * kvm.ko won't actually be built (due to lack of at least one submodule).
  */
-#ifndef EXPORT_SYMBOL_FOR_KVM
-#if IS_MODULE(CONFIG_KVM)
+#if defined(EXPORT_SYMBOL_FOR_KVM) && IS_MODULE(CONFIG_KVM)
 #define EXPORT_SYMBOL_FOR_KVM(symbol) EXPORT_SYMBOL_FOR_MODULES(symbol, "kvm")
-#else
-#define EXPORT_SYMBOL_FOR_KVM(symbol)
 #endif /* IS_MODULE(CONFIG_KVM) */
-#endif /* EXPORT_SYMBOL_FOR_KVM */
+#endif /* KVM_SUB_MODULES */
+#endif
+
+#ifndef EXPORT_SYMBOL_FOR_KVM
+#define EXPORTEXPORT_SYMBOL_FOR_KVM(symbol)
 #endif
 
 #ifndef __ASSEMBLER__

