Return-Path: <kvm+bounces-66227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69404CCAF02
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA25530572D4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A61D2ECEBB;
	Thu, 18 Dec 2025 08:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FnufwIZz"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356DB2147FB;
	Thu, 18 Dec 2025 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046841; cv=none; b=cXULk4xZAp+Jz6gwG3qnQ7kb3/WhJkTjVBaHmV0R19ft0LCYYKLTJb1Wkw5sS7P+lXpUXAUiyaqHvFJxqDPTECXpZqAD6cy2deMzSfzG6EQmp8y9DYStjVs7zyENgIl6g7D96vlnDxHo5IHIXox/PkhrC//E09+FdZtHFsOGYE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046841; c=relaxed/simple;
	bh=A9HEH6e9DfkdNSl+qx4MSHwGrDpvTREJchXDMev3nWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmPfsFxoi8DbMrp1tSpWfG8gi9wevqnT68u+r9jV6H2tpeJ/LhrE/ncYpr9QZpn8XQGEg5f1Zn4MxhWpYH60Yj3u23sG6CQ28bQI9eBrmwI6bHucCjXHtKY+0j2i/CQDisKb+92LuI82NzZqqtxEaXMt3QGLebuk81u9h1OW+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FnufwIZz; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=udKtZC5V08ugl6h8GymizkRPGV7cNBOnmpw7k4Dc21k=; b=FnufwIZzi2TPpsqyx0z46oDcLK
	f5r3rcSxKZsPqGdYhuMFCG9lCDNi08OQx6Tyo2e/tJX2SeNw8+boIsCUaPhyy/VGLLunUOaChARxA
	yJdmIAbD+mdHWfth2kKYZ8MJu5IDrk28bo2ADgOVD60oscfIgu2VUz6fSAWjD1p60Yvp189DS+MEs
	8IRDi55x8cu03bdQRprVzvhEDWM+6lR7+RHL4y5UJSdsFDKw4C/yH5Va3LPk9mz3v9ad8MFK1nq71
	XcjsKez6fhg8Mcufei0NrAeutnwLJrtu+3QOAjcC1jYNyClmqMz1BsTcR+2ld7HeCXUmMIt1hb6Tf
	VbofWLeA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW8an-00000008Lue-2EHo;
	Thu, 18 Dec 2025 07:38:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8891E30056B; Thu, 18 Dec 2025 09:33:46 +0100 (CET)
Date: Thu, 18 Dec 2025 09:33:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, seanjc@google.com, sfr@canb.auug.org.au
Cc: linux-tip-commits@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [tip: perf/core] perf: Use EXPORT_SYMBOL_FOR_KVM() for the
 mediated APIs
Message-ID: <20251218083346.GG3708021@noisy.programming.kicks-ass.net>
References: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
 <176597507731.510.6380001909229389563.tip-bot2@tip-bot2>
 <20251218083109.GH3707891@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083109.GH3707891@noisy.programming.kicks-ass.net>

On Thu, Dec 18, 2025 at 09:31:09AM +0100, Peter Zijlstra wrote:
> On Wed, Dec 17, 2025 at 12:37:57PM -0000, tip-bot2 for Peter Zijlstra wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index e6a4b1e..376fb07 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -57,6 +57,7 @@
> >  #include <linux/task_work.h>
> >  #include <linux/percpu-rwsem.h>
> >  #include <linux/unwind_deferred.h>
> > +#include <linux/kvm_types.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -6388,7 +6389,7 @@ int perf_create_mediated_pmu(void)
> >  	atomic_inc(&nr_mediated_pmu_vms);
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
> > +EXPORT_SYMBOL_FOR_KVM(perf_create_mediated_pmu);
> >  
> >  void perf_release_mediated_pmu(void)
> >  {
> > @@ -6397,7 +6398,7 @@ void perf_release_mediated_pmu(void)
> >  
> >  	atomic_dec(&nr_mediated_pmu_vms);
> >  }
> > -EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
> > +EXPORT_SYMBOL_FOR_KVM(perf_release_mediated_pmu);
> >  
> >  /* When loading a guest's mediated PMU, schedule out all exclude_guest events. */
> >  void perf_load_guest_context(void)
> 
> Bah, so the !KVM architectures hate on this.
> 
> Sean, would something like this be acceptable?

Hmm, the other option is doing something like so:

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 376fb07d869b..014d832e8eaa 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -57,7 +57,6 @@
 #include <linux/task_work.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/unwind_deferred.h>
-#include <linux/kvm_types.h>
 
 #include "internal.h"
 
@@ -6325,6 +6324,8 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
 EXPORT_SYMBOL_GPL(perf_event_pause);
 
 #ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+#include <linux/kvm_types.h>
+
 static atomic_t nr_include_guest_events __read_mostly;
 
 static atomic_t nr_mediated_pmu_vms __read_mostly;

> ---
> Subject: kvm: Fix linux/kvm_types.h for !KVM architectures
> 
> As is, <linux/kvm_types.h> hard relies on architectures having
> <asm/kvm_types.h> which (obviously) breaks for architectures that don't
> have KVM support.
> 
> This means generic code (kernel/events/ in this case) cannot use
> EXPORT_SYMBOL_FOR_KVM().
> 
> Rearrange things just so that <linux/kvm_types.h> becomes usable and
> provides the (expected) empty stub for EXPORT_SYMBOL_FOR_KVM() for !KVM.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index a568d8e6f4e8..a4cc13e41eec 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -6,6 +6,8 @@
>  #include <linux/bits.h>
>  #include <linux/export.h>
>  #include <linux/types.h>
> +
> +#ifdef CONFIG_KVM
>  #include <asm/kvm_types.h>
>  
>  #ifdef KVM_SUB_MODULES
> @@ -20,13 +22,14 @@
>   * if there are no submodules, e.g. to allow suppressing exports if KVM=m, but
>   * kvm.ko won't actually be built (due to lack of at least one submodule).
>   */
> -#ifndef EXPORT_SYMBOL_FOR_KVM
> -#if IS_MODULE(CONFIG_KVM)
> +#if defined(EXPORT_SYMBOL_FOR_KVM) && IS_MODULE(CONFIG_KVM)
>  #define EXPORT_SYMBOL_FOR_KVM(symbol) EXPORT_SYMBOL_FOR_MODULES(symbol, "kvm")
> -#else
> -#define EXPORT_SYMBOL_FOR_KVM(symbol)
>  #endif /* IS_MODULE(CONFIG_KVM) */
> -#endif /* EXPORT_SYMBOL_FOR_KVM */
> +#endif /* KVM_SUB_MODULES */
> +#endif
> +
> +#ifndef EXPORT_SYMBOL_FOR_KVM
> +#define EXPORTEXPORT_SYMBOL_FOR_KVM(symbol)
>  #endif
>  
>  #ifndef __ASSEMBLER__

