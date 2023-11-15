Return-Path: <kvm+bounces-1850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E97B27ED146
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 21:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FFDF1F26447
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 20:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F113EA7B;
	Wed, 15 Nov 2023 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHnN7qk+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D2DB8;
	Wed, 15 Nov 2023 12:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700078425; x=1731614425;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xSL9O7OKfhn47lCIAHNJi6bJYd3MBeV1ItF7Yks3P7s=;
  b=nHnN7qk+AZottYhB1OsBP7OEiaY3e3oG09ypuRyrQjjJFZz1OKPJJItX
   GLc72J8zEi9atLVKOJk8L1J1PCdrxvv5lcPqejWl/Mr/0rgbo0OTpo7JQ
   IQuwVVn8oYhPi0HXWuV2rqPhxghJe5Vz22kLfPylSiAi+CV31eUy/w1cs
   CJenHEioY3mk6jS+yL0yErpxD43aBdPPrfr3thHHanTO3R6XImV/W8192
   YYmNZv5qv2FBqS4uVy2cw2VY095GHYvGqWdu1xCfdJh+D7pBYVTLFVTkr
   pGbsCI1zzkwbvl6O3g1NWdmw2E76Nu+ysMZTLHVI4Mv5wwYPQzSy/fPjs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="455235706"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="455235706"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 12:00:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="758596162"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="758596162"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 12:00:24 -0800
Date: Wed, 15 Nov 2023 12:05:06 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, maz@kernel.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 09/13] x86/irq: Install posted MSI notification
 handler
Message-ID: <20231115120506.0571103d@jacob-builder>
In-Reply-To: <20231115124221.GE3818@noisy.programming.kicks-ass.net>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-10-jacob.jun.pan@linux.intel.com>
	<20231115124221.GE3818@noisy.programming.kicks-ass.net>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Peter,

On Wed, 15 Nov 2023 13:42:21 +0100, Peter Zijlstra <peterz@infradead.org>
wrote:

> On Sat, Nov 11, 2023 at 08:16:39PM -0800, Jacob Pan wrote:
> 
> > +static __always_inline inline void handle_pending_pir(struct pi_desc
> > *pid, struct pt_regs *regs) +{
> > +	int i, vec = FIRST_EXTERNAL_VECTOR;
> > +	u64 pir_copy[4];
> > +
> > +	/*
> > +	 * Make a copy of PIR which contains IRQ pending bits for
> > vectors,
> > +	 * then invoke IRQ handlers for each pending vector.
> > +	 * If any new interrupts were posted while we are processing,
> > will
> > +	 * do again before allowing new notifications. The idea is to
> > +	 * minimize the number of the expensive notifications if IRQs
> > come
> > +	 * in a high frequency burst.
> > +	 */
> > +	for (i = 0; i < 4; i++)
> > +		pir_copy[i] = raw_atomic64_xchg((atomic64_t
> > *)&pid->pir_l[i], 0);  
> 
> Might as well use arch_xchg() and save the atomic64_t casting.
will do

> 
>  [...]  


Thanks,

Jacob

