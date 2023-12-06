Return-Path: <kvm+bounces-3765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B279F807945
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20468B20DE5
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645ED6F62C;
	Wed,  6 Dec 2023 20:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yTwcWeDw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/IhuCefG"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426A4109;
	Wed,  6 Dec 2023 12:19:13 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701893951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6TvwDJnaqqPW4TKCaM9yFlVVCjb/BuENvek6Jb76QA=;
	b=yTwcWeDw7jPqj5+q0Tx4CJX0jhjsa8DXjdRMbR8dfVtqxJ7USOz0OxSri/O/U/KLk1wG/6
	CWdZo5rXeBZ3QgYogA9k01EOEn1ckb6+Y1IhHI6VVbp1oW7DBS/TutaLzgZquJqIqMO0IY
	zD5UQEjc5ugi45SXhRLlkO8gBXAm3xbdvi+syUjCDaryjTeCz6VzH9JooLyiPuldtJ7xi2
	3cHu2IwFbaQ4t2mVJJneP2swPjBaSpCM78mketPCPH1Fr7HNg68ufaHD6G/QTFTssXMYZh
	tkwRktIzScZ3Hs2QrBWMyjHnp578AGAfFMIOB/kLDNwdC20OJW9BnfNa9fpBFA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701893951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R6TvwDJnaqqPW4TKCaM9yFlVVCjb/BuENvek6Jb76QA=;
	b=/IhuCefGBcRqXjbOu3r6B3enCMu7fAlAAfJvyNQkViUERDz3yOwRbSMVuQvwtQRnthcLvo
	ieKXyNIikRBRqRCA==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH RFC 12/13] iommu/vt-d: Add a helper to retrieve PID address
In-Reply-To: <20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
Date: Wed, 06 Dec 2023 21:19:11 +0100
Message-ID: <874jgvuls0.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> When programming IRTE for posted mode, we need to retrieve the
> physical

we need .... I surely did not write this changelog.

> address of the posted interrupt descriptor (PID) that belongs to it's
> target CPU.
>
> This per CPU PID has already been set up during cpu_init().

This information is useful because?

> +static u64 get_pi_desc_addr(struct irq_data *irqd)
> +{
> +	int cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));

The effective affinity mask is magically correct when this is called?


