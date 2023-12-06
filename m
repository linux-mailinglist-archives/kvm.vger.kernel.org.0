Return-Path: <kvm+bounces-3753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6496807853
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4320A281559
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F3A4E63D;
	Wed,  6 Dec 2023 19:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NAl/1Smb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2+VnuYp6"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D3684;
	Wed,  6 Dec 2023 11:03:00 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701889379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Uendxf/jowTS9LGYuYHBvubM7ESVge9EsyeuiLQyeQ=;
	b=NAl/1SmbFM7n/y8d/m6HtA8j8xq9DaEoRraEShtTyWrD33rdQjeS5Sch7gnW4+VfCDwyoM
	WfHYuO7ZrQ2YqT7O7fKQNjlZeqOvIb7gZwEwb5eGrQ0hcAdrhIDwU2ERUjGwRf4UDZxvvE
	3TVdMvLxbzKJ2PRoPlquAILAHwhF+IyO8d3AbUfcvrZtSWL6lAVK4IuNf06rosnJi1X0/1
	hwHb/DPoTTUPE/YT79wtt7Km1WH4MMEXot6uBk1fFcrnREOdFsNP+OIa/k2x0DTyYvDadJ
	nmwHyN9Ue1r/4DtV244b6VCI+oXZtmEsF0z32t4oW4wSvDbd3ZMxGuLlNICGUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701889379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Uendxf/jowTS9LGYuYHBvubM7ESVge9EsyeuiLQyeQ=;
	b=2+VnuYp627Xrq/4voPsnP5pt1wB5MDLdjYYI2IxY9MR4F1tsOwbjhnupr9rPW8c1PM9A71
	uqQLIPjVAQjWW9BQ==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH RFC 07/13] x86/irq: Add helpers for checking Intel PID
In-Reply-To: <20231112041643.2868316-8-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-8-jacob.jun.pan@linux.intel.com>
Date: Wed, 06 Dec 2023 20:02:58 +0100
Message-ID: <87il5bupb1.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:

That 'Intel PID' in the subject line sucks. What's wrong with writing
things out?

       x86/irq: Add accessors for posted interrupt descriptors

Hmm?

> Intel posted interrupt descriptor (PID) stores pending interrupts in its
> posted interrupt requests (PIR) bitmap.
>
> Add helper functions to check individual vector status and the entire bitmap.
>
> They are used for interrupt migration and runtime demultiplexing posted MSI
> vectors.

This is all backwards.

  Posted interrupts are controlled by and pending interrupts are marked in
  the posted interrupt descriptor. The upcoming support for host side
  posted interrupts requires accessors to check for pending vectors.

  Add ....

>  #ifdef CONFIG_X86_POSTED_MSI
> +/*
> + * Not all external vectors are subject to interrupt remapping, e.g. IOMMU's
> + * own interrupts. Here we do not distinguish them since those vector bits in
> + * PIR will always be zero.
> + */
> +static inline bool is_pi_pending_this_cpu(unsigned int vector)

Can you please use a proper name space pi_.....() instead of this
is_...() muck which is horrible to grep for. It's documented ....

> +{
> +	struct pi_desc *pid;
> +
> +	if (WARN_ON(vector > NR_VECTORS || vector < FIRST_EXTERNAL_VECTOR))
> +		return false;

Haha. So much about your 'can use the full vector space' dreams .... And
WARN_ON_ONCE() please.

> +
> +	pid = this_cpu_ptr(&posted_interrupt_desc);

Also this can go into the declaration line.

> +
> +	return (pid->pir[vector >> 5] & (1 << (vector % 32)));

  __test_bit() perhaps?

> +}

> +static inline bool is_pir_pending(struct pi_desc *pid)
> +{
> +	int i;
> +
> +	for (i = 0; i < 4; i++) {
> +		if (pid->pir_l[i])
> +			return true;
> +	}
> +
> +	return false;

This is required because pi_is_pir_empty() is checking the other way
round, right?

> +}
> +
>  extern void intel_posted_msi_init(void);
>  
>  #else
> +static inline bool is_pi_pending_this_cpu(unsigned int vector) {return false; }

lacks space before 'return'

> +
>  static inline void intel_posted_msi_init(void) {};
>  
>  #endif /* X86_POSTED_MSI */

