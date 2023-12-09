Return-Path: <kvm+bounces-3979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F023480B0EA
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 01:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB4EF281BF3
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 00:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB0264D;
	Sat,  9 Dec 2023 00:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQD899gs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD571989;
	Fri,  8 Dec 2023 16:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702081424; x=1733617424;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=piv1ufn8iwzW/IVvizlJtD5QiZOF1k8OCC/NJ5zGeeU=;
  b=fQD899gsJ44xOKKWkcO9XlQRouWvqwCEhMpevieIShferUUUKmoF/FOY
   Yhqz3KvPVfk2RwSFwiP0r8RxwoHyecTVUlw7jFV8XfoFTlo9Xx+7wVoeY
   5CYapWya3ApSj5vy4RS6smAX5Dp4RfVdcYdu5X/VwGPIHco1QRlws+Iwo
   0C6dAwDYdyhS8oqYa3I9nTiJS1y6OJlbuTtJ0ViSJxw+as9USAUqjKrGi
   mEBHztQUDZ6z+PqZQPbWdRHNp5qL9tcTi1K/Km/+E5GwL0EVk/YJaZ0LR
   b9HPfSyOvNozypr6Ku0YpXyD8Av6CtgG/khs4VJpq+Am3M3/C7HyamAWe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="374644195"
X-IronPort-AV: E=Sophos;i="6.04,262,1695711600"; 
   d="scan'208";a="374644195"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 16:23:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="1019534298"
X-IronPort-AV: E=Sophos;i="6.04,262,1695711600"; 
   d="scan'208";a="1019534298"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 16:23:43 -0800
Date: Fri, 8 Dec 2023 16:28:35 -0800
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
Subject: Re: [PATCH RFC 01/13] x86: Move posted interrupt descriptor out of
 vmx code
Message-ID: <20231208162835.1505f927@jacob-builder>
In-Reply-To: <875y19t507.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-2-jacob.jun.pan@linux.intel.com>
	<87wmtruw87.ffs@tglx>
	<20231207205431.75a214c2@jacob-builder>
	<875y19t507.ffs@tglx>
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

On Fri, 08 Dec 2023 10:31:20 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Thu, Dec 07 2023 at 20:54, Jacob Pan wrote:
> > On Wed, 06 Dec 2023 17:33:28 +0100, Thomas Gleixner <tglx@linutronix.de>
> > wrote:  
> >> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> >> 	u32			rsvd[6];
> >> } __aligned(64);
> >>   
> > It seems bit-fields cannot pass type check. I got these compile error.  
> 
> And why are you telling me that instead if simply fixing it?
I guess we can fix it like this to use the new bitfields:

 void intel_posted_msi_init(void)
 {
-       this_cpu_write(posted_interrupt_desc.nv, POSTED_MSI_NOTIFICATION_VECTOR);
-       this_cpu_write(posted_interrupt_desc.ndst, this_cpu_read(x86_cpu_to_apicid));
+       struct pi_desc *pid = this_cpu_ptr(&posted_interrupt_desc);
+
+       pid->nv = POSTED_MSI_NOTIFICATION_VECTOR;
+       pid->ndst = this_cpu_read(x86_cpu_to_apicid);

It is init time, no IOMMU posting yet. So no need for atomics.


Thanks,

Jacob

