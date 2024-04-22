Return-Path: <kvm+bounces-15577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2543A8AD746
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB0121F21F59
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62752335BA;
	Mon, 22 Apr 2024 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lyg8Kl2L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003F02E410;
	Mon, 22 Apr 2024 22:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713824896; cv=none; b=mwoKYhxR5Qi4lbCaGT6sl+o0qVWsA+L+LQLmbFbeYrmu3PeF/WbDXH1K8iqCeNEYhQdQU6BRqVpHqOq5fZneNU++YK4PzM1pzLtfjDX1kW3Da7r7bpEuZ4E/TzmDkAjxvF88tVrVecrpUcQZK9glsA3gF7hRpZWF/L7+FEtAwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713824896; c=relaxed/simple;
	bh=LBIdcLeL+hwX+jq1w+Grr6K8OGAVBmubNTZAhnNesCc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o3AQcDFqloN0ObBruuL3XuPfphFCG55JqQjy1P4sWsPHImfqh6mlGVAJRhyTPzadGmJFlYH4hE0BuBlxCMJy/mn6pKQzoX7j4pjUGN8nyih7SJihRbyy31aSrn+HndE+8CAX4ug/BSDbE75OKcRFOW39XZmSaE2bY6uUChP5/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lyg8Kl2L; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713824895; x=1745360895;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LBIdcLeL+hwX+jq1w+Grr6K8OGAVBmubNTZAhnNesCc=;
  b=lyg8Kl2LrAjDWVwCqqku2vrUGzJnd6u5G/DqkFYnuNRRNRuvKbGcrF2p
   pM/cn49/aWPV4c77UkTXAu0tG7FXQ27efEcSucamuZaHfZP3v4jshV0fM
   rFHrUgWKiePOd33fmH2tNCJtgUju8Ov2MLfLsWTIyKycAtJgXccUiNwKb
   7SRx3tM0Nz9Y038G4+dgHwvh+u/mVtN4MQFpbJzISPWpDiOs6VTlHCe/g
   DQqR1z5T/G6xLHBFtnrNfhSVut04vuzM5uY5L/gdE+3Rh7K69FAy2tSp7
   158QAFUVsG9G03kessByudmuFl1BKb2yd51h/AMt4wpcEmwAnCxfV877T
   A==;
X-CSE-ConnectionGUID: 2cWVlGeqSa+DE5FMXrp93w==
X-CSE-MsgGUID: ATsrUpmySm28GBu+rUI5qw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13172313"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="13172313"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 15:28:14 -0700
X-CSE-ConnectionGUID: 4GsBA0hISUKUrp2D78M5JQ==
X-CSE-MsgGUID: g4pAQOoBQwCivuS3JEs+Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="28971902"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 15:28:14 -0700
Date: Mon, 22 Apr 2024 15:32:50 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 kan.liang@intel.com, "Kleen, Andi" <andi.kleen@intel.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
Message-ID: <20240422153250.07331f49@jacob-builder>
In-Reply-To: <ZiLO9RUdMsNlCtI_@x1>
References: <20240415134354.67c9d1d1@jacob-builder>
	<87jzkuxaqv.ffs@tglx>
	<ZiLO9RUdMsNlCtI_@x1>
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

Hi Arnaldo,

On Fri, 19 Apr 2024 17:07:17 -0300, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:

> > > On a second thought, if we make system IRQ vector determined at
> > > compile time based on different CONFIG options, will it break
> > > userspace tools such as perf? More importantly the rule of not
> > > breaking userspace.  
> 
> The rule for tools/perf is "don't impose _any requirement_ on the kernel
> developers, they don't have to test if any change they do outside of
> tools/ will break something inside tools/."
>  
> > tools/arch/x86/include/asm/irq_vectors.h is only used to generate the
> > list of system vectors for pretty output. And your change already broke
> > that.  
> 
> Yeah, I even moved that from tools/arch/x86/include/asm/irq_vectors.h
> to tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h (for next
> merge window).

So I will not add anything to the tools directory for my next version.
Just a heads-up for adding this new vector.

Thanks,

Jacob

