Return-Path: <kvm+bounces-45854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8B1AAFB33
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33C601C07391
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6767522B8AF;
	Thu,  8 May 2025 13:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MTHfcspn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F817BA5;
	Thu,  8 May 2025 13:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710515; cv=none; b=PPBMIzTms3TSpI5PO4kLLzVcXMrnoY/oHJxhd378ZWGBp56EJmcEqInBTc1CkAwRFnduUMPW2gWc/BKKFZCumKOljFD0kITzJ5btjmFaI/9P+ovIUWObkSj1sgk6Yrc4O32sIQrB4/STB3y4Wmsa12Wkm2VTnqSoZTxnSAgUFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710515; c=relaxed/simple;
	bh=cy8Qc4ngMqBHIyfiq9amKDZY+4DjHcjHkgkdKV6rx3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9W/+migEek0PjpuIKgkiZjIEwNe+yn+JWtNr99fC3tFy/rFgzeZrjtSBMJfL4YFB2Mtso3mo4QRiY9np4hZWg4XX5L9i5dXJwmXc2VLg5JXHcvmPmdGocFldqGcV25woUzfPDZYkg9fCSFxvkRA+c0y2hGnH+GsTVMteozHxTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MTHfcspn; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746710514; x=1778246514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cy8Qc4ngMqBHIyfiq9amKDZY+4DjHcjHkgkdKV6rx3k=;
  b=MTHfcspntNC0d3AJgO286QWJScvPmWly5vUrij2P4dk2Ktzn9BZCN0ek
   EwAMs+gT0ijIRvGUGL1bDExtXinOL977wHMjRPOBPI98h6rE+posazN/4
   og9ilFw5yrChK46Q3ekpphdwd/uJDadyu/w03BDzG3r+6nzRL3Lg3msYa
   SKW1ZsYZwxnhPtSaOQqj8QP00gv6lDuYwWg/OnCT3vMvsHUEJhbZ8VS5n
   J89cnulb6D/Gi3wjsAVlFZKYPxKXNWW3ZF1G4P90d+3eWGI94kuwgn2yb
   wzAEiukkIHZTBpA0NIT67VewnzSjMALni1A7yYVPWOq3DWTfwjndUxmSA
   g==;
X-CSE-ConnectionGUID: PLdpVGFtRiW4UE8h/u8eVA==
X-CSE-MsgGUID: ksKO5Y2KQiqmGM89BJaRVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="73871414"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73871414"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:21:53 -0700
X-CSE-ConnectionGUID: LvBCSwrPQnuJxdW3yjK1kQ==
X-CSE-MsgGUID: n+puAlwHQXaXL5SYu6DMRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="167375171"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 08 May 2025 06:21:50 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 9B3291D7; Thu, 08 May 2025 16:21:48 +0300 (EEST)
Date: Thu, 8 May 2025 16:21:48 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <u6f6jbgbbz2judwuvwtelxdkhbl2dsqc2fqi2n4uvfwhszan75@2kvbsreeywrb>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
 <4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com>
 <aBwSICZBrgiKX2UF@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBwSICZBrgiKX2UF@yzhao56-desk.sh.intel.com>

On Thu, May 08, 2025 at 10:08:32AM +0800, Yan Zhao wrote:
> On Wed, May 07, 2025 at 09:31:22AM -0700, Dave Hansen wrote:
> > On 5/5/25 05:44, Huang, Kai wrote:
> > >> +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > >> +			struct list_head *pamt_pages)
> > >> +{
> > >> +	u64 err;
> > >> +
> > >> +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> > >> +
> > >> +	spin_lock(&pamt_lock);
> > > Just curious, Can the lock be per-2M-range?
> > 
> > Folks, please keep it simple.
> > 
> > If there's lock contention on this, we'll fix the lock contention, or
> > hash the physical address into a fixed number of locks. But having it be
> > per-2M-range sounds awful. Then you have to size it, and allocate it and
> > then resize it if there's ever hotplug, etc...
> In patch 2, there're per-2M-range pamt_refcounts. Could the per-2M-range
> lock be implemented in a similar way?
> 
> +static atomic_t *pamt_refcounts;
> +atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> +{
> +       return &pamt_refcounts[hpa / PMD_SIZE];
> +}

But why? If no contention, it is just wasteful.

> > Kirill, could you put together some kind of torture test for this,
> > please? I would imagine a workload which is sitting in a loop setting up
> > and tearing down VMs on a bunch of CPUs would do it.
> > 
> > That ^ would be the worst possible case, I think. If you don't see lock
> > contention there, you'll hopefully never see it on real systems.
> When one vCPU is trying to install a guest page of HPA A, while another vCPU
> is trying to install a guest page of HPA B, theoretically they may content the
> global pamt_lock even if HPA A and B belong to different PAMT 2M blocks.

This contention will be be momentary if ever happen.

> > I *suspect* that real systems will get bottlenecked somewhere in the
> > page conversion process rather than on this lock. But it should be a
> > pretty simple experiment to run.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

