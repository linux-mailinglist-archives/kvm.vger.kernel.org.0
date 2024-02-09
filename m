Return-Path: <kvm+bounces-8455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D421C84FB27
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6F46B2BB3A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A515F7EF02;
	Fri,  9 Feb 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FvLE7B9r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAE87BB02;
	Fri,  9 Feb 2024 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707500264; cv=none; b=fdaEBZEMxmbdVn0J1xLpL7HGZcJ9EAfyw14WyamllSLD31XIyIbELLTOyBjb6+reQ1dXgUGjoS+HBNSJm0tImt6IAI5/x9+BEN1fyL8CcEl1t6QSIWTUTYVORkc21U9vfik3ZHx8hTJId++9xwr6o/C/I+76+VZgzSmkeIfsDq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707500264; c=relaxed/simple;
	bh=BdMU0oTnFjGtXUkF18CMrDZ2Abb+uhhOf90zFBp26sI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIBN6KllF7tSDL+vMY9cD+tnoRFzeBrX65oM3+CB6gpzQ9Yt/HetiDZL3OI4mAMYqHrDrht15p4nGBNIuuo/6NsceTKV5iz1+GbXDg+PBdnqEJ4ePvdGUscrr+rWCP2bTcYonVL8XyJ6GbcFzpKO8/Bg1/OY52zNTLwneIz9A6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FvLE7B9r; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707500263; x=1739036263;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BdMU0oTnFjGtXUkF18CMrDZ2Abb+uhhOf90zFBp26sI=;
  b=FvLE7B9r64Cf5HwFrVqxSUlkc8EgCPio+r1ihw6WDqJ6Ctpz7LEXvcO0
   GS6tpViQR7ZPFAeFXxmGRwHiwtbQt/4Z1Ug7IAK1Vl5Fpt7FsB7y0gNlx
   s7d+/e5emBRaJcFkymWr1qq4VSULi547U6V22z+2SuAFd9jnaTcPmj1wc
   AnarZdv25nhIhwonBZpIlxKICPpvaqC8ksDOI/s7ZKIe11hOAaIRNkwHi
   lYqilQtEeCxF62mnx7yfl3R/66Va4Vq15c/N+NIJO7QZNpoJUIPtdUT5U
   1xgceavC1CpbkXU015a2zQK/dD+QpIjXzOU9elegemGwoMfgplVzpTkC2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="436609814"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="436609814"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 09:37:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="6744517"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 09:37:41 -0800
Date: Fri, 9 Feb 2024 09:43:07 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Message-ID: <20240209094307.4e7eacd0@jacob-builder>
In-Reply-To: <051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
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

Hi Jens,

On Thu, 8 Feb 2024 08:34:55 -0700, Jens Axboe <axboe@kernel.dk> wrote:

> Hi Jacob,
> 
> I gave this a quick spin, using 4 gen2 optane drives. Basic test, just
> IOPS bound on the drive, and using 1 thread per drive for IO. Random
> reads, using io_uring.
> 
> For reference, using polled IO:
> 
> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> IOPS=20.37M, BW=9.95GiB/s, IOS/call=31/31
> 
> which is abount 5.1M/drive, which is what they can deliver.
> 
> Before your patches, I see:
> 
> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> 
> at 2.82M ints/sec. With the patches, I see:
> 
> IOPS=14.73M, BW=7.19GiB/s, IOS/call=32/31
> IOPS=14.90M, BW=7.27GiB/s, IOS/call=32/31
> IOPS=14.90M, BW=7.27GiB/s, IOS/call=31/32
> 
> at 2.34M ints/sec. So a nice reduction in interrupt rate, though not
> quite at the extent I expected. Booted with 'posted_msi' and I do see
> posted interrupts increasing in the PMN in /proc/interrupts, 
> 
The ints/sec reduction is not as high as I expected either, especially
at this high rate. Which means not enough coalescing going on to get the
performance benefits.

The opportunity of IRQ coalescing is also dependent on how long the
driver's hardirq handler executes. In the posted MSI demux loop, it does
not wait for more MSIs to come before existing the pending IRQ polling
loop. So if the hardirq handler finishes very quickly, it may not coalesce
as much. Perhaps, we need to find more "useful" work to do to maximize the
window for coalescing.

I am not familiar with optane driver, need to look into how its hardirq
handler work. I have only tested NVMe gen5 in terms of storage IO, i saw
30-50% ints/sec reduction at even lower IRQ rate (200k/sec).

> Probably want to fold this one in:
>  
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 8e09d40ea928..a289282f1cf9 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -393,7 +393,7 @@ void intel_posted_msi_init(void)
>   * instead of:
>   *		read, xchg, read, xchg, read, xchg, read, xchg
>   */
> -static __always_inline inline bool handle_pending_pir(u64 *pir, struct
> pt_regs *regs) +static __always_inline bool handle_pending_pir(u64 *pir,
> struct pt_regs *regs) {
>  	int i, vec = FIRST_EXTERNAL_VECTOR;
>  	unsigned long pir_copy[4];
> 
Good catch! will do.

Thanks,

Jacob

