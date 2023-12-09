Return-Path: <kvm+bounces-3989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D34B80B691
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 22:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22907280FC2
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 21:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5151D525;
	Sat,  9 Dec 2023 21:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Onj3uzuv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4862FA;
	Sat,  9 Dec 2023 13:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702158539; x=1733694539;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sea+AaFEK98QBlB5fM4xmc+AbrfvzYwLtKGM/n9l59s=;
  b=Onj3uzuvPaZn+qWPI4WjgAZNxihyErbGakk7Ifp81TWY8f3rYqeCs6P7
   2mHJ35YRqu5YNgsNAlrb2bKt3mbsez3p/XYhs5N2MJQIwKK7WI+gVt4Bv
   qYzQR+8ucs+CCGAuApLKCJdMruIGe5C4DI3zssBL2yZkL4ujUX9wvL474
   O8+eBMSC82VeF8RpjM0jUg+MEJzV6B6M9dvNbY+F1SHRqCXlThYFd2IV+
   rTCcVEQcjGKLCEKs3SItMEaOdLLjUG8uNDYTgp3ogLivQ8pDJjr92gqO2
   bHaX2PPaGH6XYQ+aK0ChbtOJE0ZR9r99qyqcFhDofviQZ0IjJ3TtVWhOF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10919"; a="7885464"
X-IronPort-AV: E=Sophos;i="6.04,264,1695711600"; 
   d="scan'208";a="7885464"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2023 13:48:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10919"; a="890575789"
X-IronPort-AV: E=Sophos;i="6.04,264,1695711600"; 
   d="scan'208";a="890575789"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2023 13:48:57 -0800
Date: Sat, 9 Dec 2023 13:53:50 -0800
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
Subject: Re: [PATCH RFC 03/13] x86: Reserved a per CPU IDT vector for posted
 MSIs
Message-ID: <20231209135350.4424e019@jacob-builder>
In-Reply-To: <87r0jzuvlg.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-4-jacob.jun.pan@linux.intel.com>
	<87r0jzuvlg.ffs@tglx>
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

On Wed, 06 Dec 2023 17:47:07 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> 
> $Subject: x86/vector: Reserve ...
> 
> > Under posted MSIs, all device MSIs are multiplexed into a single CPU  
> 
> Under?
Will change to "When posted MSIs are enabled, "
 
> > notification vector. MSI handlers will be de-multiplexed at run-time by
> > system software without IDT delivery.
> >
> > This vector has a priority class below the rest of the system vectors.  
> 
> Why?
I was thinking system interrupt can preempt device posted MSIs. But if
nested interrupt is not an option, there is no need.

> > Potentially, external vector number space for MSIs can be expanded to
> > the entire 0-256 range.  
> 
> Don't even mention this. It's wishful thinking and has absolutely
> nothing to do with the patch at hand.
will remove.

> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  arch/x86/include/asm/irq_vectors.h | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/irq_vectors.h
> > b/arch/x86/include/asm/irq_vectors.h index 3a19904c2db6..077ca38f5a91
> > 100644 --- a/arch/x86/include/asm/irq_vectors.h
> > +++ b/arch/x86/include/asm/irq_vectors.h
> > @@ -99,9 +99,22 @@
> >  
> >  #define LOCAL_TIMER_VECTOR		0xec
> >  
> > +/*
> > + * Posted interrupt notification vector for all device MSIs delivered
> > to
> > + * the host kernel.
> > + *
> > + * Choose lower priority class bit [7:4] than other system vectors such
> > + * that it can be preempted by the system interrupts.  
> 
> That's future music and I'm not convinced at all that we want to allow
> nested interrupts with all their implications. Stack depth is the least
> of the worries here. There are enough other assumptions about interrupts
> not nesting in Linux.
> 
Then, should we allow limited interrupt priority inversion while processing
posted MSIs?

In the current code, without preemption, we effectively already allow one
low priority to block higher ones.

I don't know the other worries caused by nested interrupts, still
experimenting/studying, but here I am thinking it is just one-deep nesting.
Posted MSI notifications are not allowed to nest, so does other system
interrupts.

> > + * It is also higher than all external vectors but it should not matter
> > + * in that external vectors for posted MSIs are in a different number
> > space.  
> 
> This whole priority muck is pointless. The kernel never used it and will
> never use it.
OK. Perhaps I didn't make it clear, I am just trying to let system
interrupt, such as timer, to preempt posted MSI. Not TPR/PPR etc.

> > + */
> > +#define POSTED_MSI_NOTIFICATION_VECTOR	0xdf  
> 
> So this just wants to go into the regular system vector number space
> until there is a conclusion whether we can and want to allow nested
> interrupts. Premature optimization is just creating more confusion than
> value.
Make sense, for this patchset I didn't include the preemption patch since I
am not sure yet.
I should use the next system vector.


Thanks,

Jacob

