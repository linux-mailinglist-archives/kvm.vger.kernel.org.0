Return-Path: <kvm+bounces-3988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C880A80B67E
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 22:20:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DA8CB20B6E
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 21:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9651CF9A;
	Sat,  9 Dec 2023 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gg55S386"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22E710D;
	Sat,  9 Dec 2023 13:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702156794; x=1733692794;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6IJ+P3FQWdDDt3IqhiNR/nma3yK9Ko8IttBCqvVavD4=;
  b=Gg55S386CmQgl2W3w8UdVzKvAuMVTdeYBmeUDcqNULvDww96mw6rLovE
   YBVPT1OChyQKhdMEaLxa6hSw9sC12A96dnhnPW01gGykDg3XwgiApUZJN
   uu0cJMRAqv7WRq4YrdXtYVA8xLBFY8WSxpyfk5ENwqlId/pco1xr/MN+L
   v8xPUx8yn6asnKvf+nLYF2GM0ff/xoHELMI/Kz3Av6b+i1UCUqj3lFGLJ
   a21TRjFpVB8xgIPnaIt1zrILV5ZNNNS5qg7wtvoJFg+bvb1mLpMfbpkw7
   ujzdFfYrsGc6Hu1HZDNq8AS1S43fmQzZxGuPsYqM1JTyQWEDSGPEe8boh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10919"; a="1399847"
X-IronPort-AV: E=Sophos;i="6.04,264,1695711600"; 
   d="scan'208";a="1399847"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2023 13:19:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10919"; a="863269212"
X-IronPort-AV: E=Sophos;i="6.04,264,1695711600"; 
   d="scan'208";a="863269212"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2023 13:19:52 -0800
Date: Sat, 9 Dec 2023 13:24:46 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 02/13] x86: Add a Kconfig option for posted MSI
Message-ID: <20231209132446.62b07ca6@jacob-builder>
In-Reply-To: <87ttovuw4u.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-3-jacob.jun.pan@linux.intel.com>
	<87ttovuw4u.ffs@tglx>
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

Hi Thomas,

On Wed, 06 Dec 2023 17:35:29 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> > This option will be used to support delivering MSIs as posted
> > interrupts. Interrupt remapping is required.  
> 
> The last sentence does not make sense.
will remove, superfluous statement.

> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  arch/x86/Kconfig | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 66bfabae8814..f16882ddb390 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -463,6 +463,16 @@ config X86_X2APIC
> >  
> >  	  If you don't know what to do here, say N.
> >  
> > +config X86_POSTED_MSI
> > +	bool "Enable MSI and MSI-x delivery by posted interrupts"
> > +	depends on X86_X2APIC && X86_64 && IRQ_REMAP
> > +	help
> > +	  This enables MSIs that are under IRQ remapping to be
> > delivered as posted  
> 
> s/IRQ/interrupt/
OK, will replace this and IRQs below.

> This is text and not Xitter.
> 
> 
> > +	  interrupts to the host kernel. IRQ throughput can
> > potentially be improved
> > +	  by coalescing CPU notifications during high frequency IRQ
> > bursts. +
> > +	  If you don't know what to do here, say N.
> > +
> >  config X86_MPPARSE
> >  	bool "Enable MPS table" if ACPI
> >  	default y  


Thanks,

Jacob

