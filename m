Return-Path: <kvm+bounces-8063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 706AB84AB1D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 01:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB250B23769
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D29A1C06;
	Tue,  6 Feb 2024 00:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SaTdpMxy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353C1373;
	Tue,  6 Feb 2024 00:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707179715; cv=none; b=f35Tqt2G9/tlIAwq5grIVTmYPO5Pzix0UWFMAZMWiEh2WY2Osr0ujmqTFipd/e/xUZWmcexyruB2tsYRgQAAKtNHOYQemnwnS3recBclE6yCxCY2UKYyCZN1HEI0Qf3hTAYsKdZfeWY87HsFPmf0ONjN7jPZFT5x578SdJl1bWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707179715; c=relaxed/simple;
	bh=i6IgYdSK47NjqrE0DfFtF9g60c6Y3zPVvJqi8tx5m+o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPlzyhGjYIg1rpslk0/qam37up9RIwVSnCPMmFH8zl2V10GG4SL8Wd5HwfXPORrVSrm/XF+G6uV/PNKqmfUYy8R5E0o7o+dqo4+c5seoLnW0U/stynAYsxI9kWLVuHZGCt97CFqEg9/J3/S/BB5TK98rZqAPVrhkahnOYN03ox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SaTdpMxy; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707179714; x=1738715714;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i6IgYdSK47NjqrE0DfFtF9g60c6Y3zPVvJqi8tx5m+o=;
  b=SaTdpMxytShS0hzLyK0I1xvmXReVXUpSSwrT4rSFOpqEejPnN31aVkFr
   iERyEh+VlKIA5uliMbUmGexNj8mWUHqon2zxffukab26A+cmBALR78vql
   FZNGX9M0G5wxAfpwkzvM0G9nmb8l1Uwngb496eOfEsZMfRI08wOCub9cZ
   F9fpXeUmnuKLmJXKOXtq69/ZzP/CVF3SlBkT5yeeUpSnVKM36PaSAOaCg
   AFNY7dG4Oskza97cdy8Y+3XVDBCz3Z1Xf1jFt2LIGqtfjuinqICXK82uo
   IgQKmAXtg59jXv5ClqDDs5xjCeuJgV0dgt/x4hIItcZKrO9pPEMRTPuxC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="802967"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="802967"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 16:35:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="5466919"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 16:35:11 -0800
Date: Mon, 5 Feb 2024 16:40:35 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian
 <kevin.tian@intel.com>, maz@kernel.org, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 03/15] x86/irq: Use bitfields exclusively in posted
 interrupt descriptor
Message-ID: <20240205164035.79d10122@jacob-builder>
In-Reply-To: <Zbmm1DZPmbFm8gan@google.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<20240126234237.547278-4-jacob.jun.pan@linux.intel.com>
	<Zbmm1DZPmbFm8gan@google.com>
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

Hi Sean,

On Tue, 30 Jan 2024 17:48:04 -0800, Sean Christopherson <seanjc@google.com>
wrote:

> On Fri, Jan 26, 2024, Jacob Pan wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Mixture of bitfields and types is weird and really not intuitive, remove
> > types and use bitfields exclusively.  
> 
> I agree it's weird, and maybe not immediately intuitive, but that doesn't
> mean there's no a good reason for the code being the way it is, i.e.
> "it's weird" isn't sufficient justification for touching this type of
> code.
> 
> Bitfields almost always generate inferior code when accessing a subset of
> the overall thing.  And even worse, there are subtle side effects that I
> really don't want to find out whether or not they are benign.
> 
> E.g. before this change, setting the notification vector is:
> 
> 	movb   $0xf2,0x62(%rsp)
> 
> whereas after this change it becomes:
> 
> 	mov    %eax,%edx
>    	and    $0xff00fffd,%edx
> 	or     $0xf20000,%edx
>    	mov    %edx,0x60(%rsp)
> 
hmm, that is weird. However, my kernel build with the patch does not
exhibit such code. I am getting the same as before for setting up NV:
 112:   75 06                   jne    11a <vmx_vcpu_pi_load+0xaa>
...
 135:   c6 44 24 22 f2          movb   $0xf2,0x22(%rsp)

However, I do agree having types is more robust, we can also use
this_cpu_write() and friends if needed.

> Writing extra bytes _shouln't_ be a problem, as KVM needs to atomically
> write the entire control chunk no matter what, but changing this without
> very good cause scares me.
> 
> If we really want to clean things up, my very strong vote is to remove the
> bitfields entirely.  SN is the only bit that's accessed without going
> through an accessor, and those should be easy enough to fixup one by one
> (and we can add more non-atomic accessors/mutators if it makes sense to
> do so).
> 
> E.g. end up with
> 
> /* Posted-Interrupt Descriptor */
> struct pi_desc {
> 	u32 pir[8];     /* Posted interrupt requested */
> 	union {
> 		struct {
> 			u16	notification_bits;
> 			u8	nv;
> 			u8	rsvd_2;
> 			u32	ndst;
> 		};
> 		u64 control;
> 	};
> 	u32 rsvd[6];
> } __aligned(64);

Sounds good to me.

Thanks,

Jacob

