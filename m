Return-Path: <kvm+bounces-7240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE3183E6F2
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9AE8B24986
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979CB5914C;
	Fri, 26 Jan 2024 23:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LEp07/0+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA4224CF;
	Fri, 26 Jan 2024 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706311551; cv=none; b=jgrGRmvs7bMcixXtVtJewkXvjRMCu9MHE7UUill1RUSy/7sM8LsK3jgzkjgBfk1eEkTOlr6DsJJBqs4E+yfDJoCnXroulcUOE5C1cq5FQL89Mc8QfZKkNSAkTskhJahLYjtZ7KQ1DBG/wyENt7zdRyGwabTBMfvuXj7VwKmsUWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706311551; c=relaxed/simple;
	bh=OT63v6nV293o1ccgnhbVK00HEvGSO8K/GxmBZEmDAWM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyBUg/Xn0nmnSkN4FsZUznA+piv1XTVz7d1KzN+PGI26Pa4yllru98UprMUyvJatBoU3lc75XfP5MT2Y/jv+lEHbG8T154/+RC+pjNzyhsUJfn1TdH6CLKxP4B4ieUOrAzaDWzlxEoNfcKtDEXa/8VZC2D34NjQYa/IKQtk9lHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LEp07/0+; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706311550; x=1737847550;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OT63v6nV293o1ccgnhbVK00HEvGSO8K/GxmBZEmDAWM=;
  b=LEp07/0+/69DLaGxN9FvpiLz3w2IlkIwAgDffihYL7rfofRH/qA48cJQ
   oufZuSiT9IELyZ4qJPuMIf7sCnFXm7/FjPBA/g/WdYhfl8YW7WqzMEDQQ
   TrxyxtjIURiASUBdnVy52oKwLEG8uqmMOT24M1zCtIdN2k9j7up8V0Fy1
   2/85Gu/v8N+pn29tI+xMSl1FokMUHr2MKo45ugncNblKWfEp12SJTwWm3
   aIoXGs9ALvT3lL8kZ1o2Rk6jeZJo+uqTWBEZ0Gdp0D9IZtWQ0Bng8KHr3
   w/ojkj61x+EYW5xVQ3OSsOvTwfXU6A6L1AjW9b5pZvAd/EoFd2L7ekzev
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="433757928"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="433757928"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:25:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="910489872"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="910489872"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:25:48 -0800
Date: Fri, 26 Jan 2024 15:31:08 -0800
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
Subject: Re: [PATCH RFC 07/13] x86/irq: Add helpers for checking Intel PID
Message-ID: <20240126153108.2a6bbb9e@jacob-builder>
In-Reply-To: <87il5bupb1.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-8-jacob.jun.pan@linux.intel.com>
 <87il5bupb1.ffs@tglx>
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

On Wed, 06 Dec 2023 20:02:58 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> 
> That 'Intel PID' in the subject line sucks. What's wrong with writing
> things out?
> 
>        x86/irq: Add accessors for posted interrupt descriptors
> 
will do.

> Hmm?
> 
> > Intel posted interrupt descriptor (PID) stores pending interrupts in its
> > posted interrupt requests (PIR) bitmap.
> >
> > Add helper functions to check individual vector status and the entire
> > bitmap.
> >
> > They are used for interrupt migration and runtime demultiplexing posted
> > MSI vectors.  
> 
> This is all backwards.
> 
>   Posted interrupts are controlled by and pending interrupts are marked in
>   the posted interrupt descriptor. The upcoming support for host side
>   posted interrupts requires accessors to check for pending vectors.
> 
>   Add ....
> 
> >  #ifdef CONFIG_X86_POSTED_MSI
> > +/*
> > + * Not all external vectors are subject to interrupt remapping, e.g.
> > IOMMU's
> > + * own interrupts. Here we do not distinguish them since those vector
> > bits in
> > + * PIR will always be zero.
> > + */
> > +static inline bool is_pi_pending_this_cpu(unsigned int vector)  
> 
> Can you please use a proper name space pi_.....() instead of this
> is_...() muck which is horrible to grep for. It's documented ....
> 
good idea, will do.

> > +{
> > +	struct pi_desc *pid;
> > +
> > +	if (WARN_ON(vector > NR_VECTORS || vector <
> > FIRST_EXTERNAL_VECTOR))
> > +		return false;  
> 
> Haha. So much about your 'can use the full vector space' dreams .... And
> WARN_ON_ONCE() please.
> 
yes, will do. Not enough motivation for the full vector space.

> > +
> > +	pid = this_cpu_ptr(&posted_interrupt_desc);  
> 
> Also this can go into the declaration line.
will do

> 
> > +
> > +	return (pid->pir[vector >> 5] & (1 << (vector % 32)));  
> 
>   __test_bit() perhaps?
> 
> > +}  
> 
> > +static inline bool is_pir_pending(struct pi_desc *pid)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < 4; i++) {
> > +		if (pid->pir_l[i])
> > +			return true;
> > +	}
> > +
> > +	return false;  
> 
> This is required because pi_is_pir_empty() is checking the other way
> round, right?
> 
This function is not needed anymore in the next version. I was thinking
performance is better if we bail out while encountering the first set bit.

> > +}
> > +
> >  extern void intel_posted_msi_init(void);
> >  
> >  #else
> > +static inline bool is_pi_pending_this_cpu(unsigned int vector) {return
> > false; }  
> 
> lacks space before 'return'
> 
will fix.
> > +
> >  static inline void intel_posted_msi_init(void) {};
> >  
> >  #endif /* X86_POSTED_MSI */  


Thanks,

Jacob

