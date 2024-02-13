Return-Path: <kvm+bounces-8635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E3E853B4F
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04CDF286B83
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 19:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15FD60B9E;
	Tue, 13 Feb 2024 19:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eucP4j5R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B360B95;
	Tue, 13 Feb 2024 19:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707853173; cv=none; b=MsxtiJb2kjFi+QpdaKXwGXklAqwvug5gnKpH342EsYFk4oQPhs+rEvNzSxn7Mg+g7QqH+wnJrorDXNJMav1OGjWf0Q+XV0Or58gUYhlFJUKEtm4gO4Jg5ws2dqGPdL5LRLqVZmt1z1/xqk4FOqj7PGQH4R1UmMwz6TEMx9iOxmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707853173; c=relaxed/simple;
	bh=0WYqFpS6lVIKr0IPitF5mhy3240hE8VfeutslmE3sd4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFQZ7H4CjAW+/G20Jx9Aqs9z9dQZ8an1kjC+tnNwBL0PKFWnE0rvfA4wUjfV0n2JXdpeeT4OPEmk5K9yazI+bAiwTFNGauTIOA6WgpzyUAuope2IqS7sMWYXryVDigRENS4+8fG23eBf1KCYyI0xH73bcoSYewWpj8yAhKvKGgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eucP4j5R; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707853172; x=1739389172;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0WYqFpS6lVIKr0IPitF5mhy3240hE8VfeutslmE3sd4=;
  b=eucP4j5RnGCEyxDPXZaR/8iJLZ0+dxZqtt/8weGZfA8duZyMcegAbeRt
   Fr56FuKU0FCgZoSIYtSPJqKiyiLQhNiS2Tzmq0fuwGsb2Q0idSD0y5p0J
   6WVOCM/gly3MuBYL62IgBiNQ7REaxEvVZ1cebo8c9H7D6O+kTAfx0iYEA
   1fzsTYUNKK02JJY6AHmH/EAvGPAifTFqCIAxPQPV4k88SwyHYoHeqatUV
   qF/ev2H6P4jDMck/V5aLqHTvlsHU9bkRGSHCRKQSZ2/nNYc7UGT44AtHq
   Vxcf5irGzU5Zn6sB0E5lalfzNj2RD3aXkP+qzEpM3bTxFqGu8opGWbuIr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1784956"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="1784956"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 11:39:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="26149137"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 11:39:29 -0800
Date: Tue, 13 Feb 2024 11:44:57 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, "Lu Baolu" <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, "Borislav Petkov"
 <bp@alien8.de>, "Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, "Robin Murphy" <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com, oliver.sang@intel.com
Subject: Re: [PATCH 06/15] x86/irq: Set up per host CPU posted interrupt
 descriptors
Message-ID: <20240213114457.64a056a8@jacob-builder>
In-Reply-To: <20240126234237.547278-7-jacob.jun.pan@linux.intel.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<20240126234237.547278-7-jacob.jun.pan@linux.intel.com>
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


On Fri, 26 Jan 2024 15:42:28 -0800, Jacob Pan
<jacob.jun.pan@linux.intel.com> wrote:
I have made a couple of mistakes here, caught by LKP testing.
Reported by Oliver Sang.

>  
> +#ifdef CONFIG_X86_POSTED_MSI
> +
> +/* Posted Interrupt Descriptors for coalesced MSIs to be posted */
> +DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);
> +
> +void intel_posted_msi_init(void)
> +{
> +	struct pi_desc *pid = this_cpu_ptr(&posted_interrupt_desc);
> +
> +	pid->nv = POSTED_MSI_NOTIFICATION_VECTOR;
> +	pid->ndst = this_cpu_read(x86_cpu_to_apicid);
Based on VT-d specification 9.11, middle portion of the 32 bit field
are used in xAPIC mode instead of the lowest 8 bit. Not sure why it was
designed this way, making sure people ready the spec carefully :)

xAPIC Mode (Physical): 
 319:304 - Reserved (0)
 303:296 - APIC DestinationID[7:0]
 295:288 - Reserved (0)
x2APIC Mode (Physical):
 319:288 - APIC DestinationID[31:0]

So it should be something like:
	pid->ndst = x2apic_enabled() ? apic_id : apic_id << 8;

> +}
> +}
partitioning mistake, will fix.

> +#endif /* X86_POSTED_MSI */

Thanks,

Jacob

