Return-Path: <kvm+bounces-62920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1ADC53E8A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 806183447EB
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055C334B408;
	Wed, 12 Nov 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ino744AJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956483451D1;
	Wed, 12 Nov 2025 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971883; cv=none; b=WjOFUPcS4QKABRkxTq9OoObWaJOlaD4aq3gbGWMy8h8GoH/BS88x2rJdSf1cy6qMC63Es703AsvoDb7cQ/lUhqQZWOk0QZwpfdNDDKxgWrIXukXUKjow9v3vNXOzWTvtxrGtEJdO+sIY6HUgsIpuSXXOWSbvosrpcKI5OTD4MdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971883; c=relaxed/simple;
	bh=IWByMhcBEVGO1q2CUX2wnKZSyBUhuihycTfOsSlR/O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fz9jjsko2EPYYnXuF89Fk0zfqAu38q/25/xkxprYdQcSzy1KZfgtNRH3fiGAEaJAHLffgPscUUaQQl7A7fM8cbCODvpL9+8m6XQjTJ2PV9gDtDccBtGfpZDQbfObPSIVqL1pqaxJ7ZP2QK0pZQvqvlM/hFVRQVklesi2En1txas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ino744AJ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762971882; x=1794507882;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IWByMhcBEVGO1q2CUX2wnKZSyBUhuihycTfOsSlR/O8=;
  b=Ino744AJ8NPcXDIdiisz2fEUynuqEZtBxQd75K0w7Se92pEnBW/1ewDg
   g2j4qdKg8ngiWipb9cehXgrNedZFUL+2j5HrnOdFGSn++8UEUWP1AehW5
   i55vkAp36KKhdz2i2MRsbWbG9h7TxkvKrlUsmdvNuHjaHLQU8oiqzrqG7
   HcM1+B+2ECK5OzlVGFG3ACYNKADXWxSNxtP9mHl+cV9RxnKTT1t+hp40H
   2p4fz7DUcr1FzA+kSmliix5T3NH0Oh4TaFEC2eONnVtT9U/xZWx/bI9P5
   HBM+Q6qPXcO7yWg7Y8QDkL/8koBRwt5XNWrQuCWZYMz7urlEvV7KsrRfE
   A==;
X-CSE-ConnectionGUID: YwvNZ16nR4C45j9rzmaMIw==
X-CSE-MsgGUID: ZdPHkW33TPampU9Qw1ec3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76503000"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76503000"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:24:41 -0800
X-CSE-ConnectionGUID: RlvbgsRNSJe30YkqPUgNLw==
X-CSE-MsgGUID: K9OyEaFbSsWoa1nTotGOkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189136444"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:24:41 -0800
Date: Wed, 12 Nov 2025 10:24:35 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the
 MMIO Stale Data mitigation
Message-ID: <20251112182435.od5oelwiitdueork@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-4-seanjc@google.com>
 <20251112144655.GZaRSd32GC0lZdDOWg@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112144655.GZaRSd32GC0lZdDOWg@fat_crate.local>

On Wed, Nov 12, 2025 at 03:46:55PM +0100, Borislav Petkov wrote:
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 7129eb44adad..d1d7b5ec6425 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -501,6 +501,7 @@
> >  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
> >  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> >  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> > +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/
> 							   ^^^^^^^
> 
> Yes, you can break the line and format it properly. :-)
> 
> Also, this should be called then
> 
> X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO
> 
> as it is a VM-thing too.

+1. This is a VM-only flag.

