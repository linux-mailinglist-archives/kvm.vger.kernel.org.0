Return-Path: <kvm+bounces-46160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 366A5AB340B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2F64188AD10
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CB525F7AB;
	Mon, 12 May 2025 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPg9TV6b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A0178C91;
	Mon, 12 May 2025 09:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043621; cv=none; b=moXnDzaDlkvaBLu3ayZKNwigH4Ii0/HWbc4mL+aFdftM61GJdRuFnEILnk+is7TzFgHSX6Rr+401KllkIs8atbryPEfWbKaAIKF73x2LyPHugac3ppm1Qy1pkQpcQACpzUQYwoV6z+ui08WF6SJxgh4GmuFC8Pj/c2LZc/w+J6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043621; c=relaxed/simple;
	bh=SOxH7Hqd2ybseJwnxHwBjL35f2Y2n3jhnTDRRq43r8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3xaEkj+ztV2ERaDUS2xugWwbATvkj04c967ObtGF6b5V7zF1GNikswQxSEepLIz4z8XVlIlU+rd9Eg0cy3vuQ+P3/qc5nae+Cbztif4rx7dNAyMlpOPqH1g/YIFGyBOILee6CGXa2hN4n/NZmakIeUqJmA/HukDvabZigJIWR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPg9TV6b; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747043620; x=1778579620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=SOxH7Hqd2ybseJwnxHwBjL35f2Y2n3jhnTDRRq43r8I=;
  b=FPg9TV6bSm7x1nNoueYYdOdTQgPGCdCWtDkkI2jVQzpDM9IeISWwlVO6
   P+7Xq1pjzFDVn1ebUqY/K4C/f4GptcvMfvVZfAIWI7u93gjIxhl7UMil+
   q3inCwsiipkWl1Qcrn1arB3zoq/z5ljyD0ls+baygq6kym1TxQ/BSSkq4
   nMefsKhBikmH+nWqF5GE7/EFjl+ccH+6O5Yea8LJi7P35DdtlhgdhcW83
   0RcsE8WvdR6WuQq2kyYKnRM8TWN7PdY4lXacGzrm+EpaLHjh3ewnPfcOD
   lfggUsGFA56ohK8PmgsuOzxZcaDirWDxGYTp+WCgHIvs0S+oJiaBSfObK
   w==;
X-CSE-ConnectionGUID: W5aWTZ0/RP64bQQcTCdcCA==
X-CSE-MsgGUID: 3kprWbCWQrS6nyTyJF2dog==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48827876"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="48827876"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:53:40 -0700
X-CSE-ConnectionGUID: NUBCmbi5TIuvQW6bHzphqg==
X-CSE-MsgGUID: f9wLzr17SQ28qxP/VuYFVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="137788290"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 12 May 2025 02:53:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id C40E319D; Mon, 12 May 2025 12:53:34 +0300 (EEST)
Date: Mon, 12 May 2025 12:53:34 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <pboxqhwxvrm3llyhqtmemvlci5g7xjr5cgbi7ixjtl5gzoafoo@bwcxtpz4nq4o>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
 <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>
 <zyqk4zyxpcde7sjzu5xgo7yyntk3w6opoqdspvff4tyud4p6qn@wcnzwwq7d3b6>
 <e3f91c2cac772b58603bf4831e1b25cd261edeaa.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3f91c2cac772b58603bf4831e1b25cd261edeaa.camel@intel.com>

On Fri, May 09, 2025 at 01:06:05AM +0000, Huang, Kai wrote:
> On Thu, 2025-05-08 at 16:03 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Mon, May 05, 2025 at 11:05:12AM +0000, Huang, Kai wrote:
> > > 
> > > > +static atomic_t *pamt_refcounts;
> > > > +
> > > >   static enum tdx_module_status_t tdx_module_status;
> > > >   static DEFINE_MUTEX(tdx_module_lock);
> > > >   
> > > > @@ -1035,9 +1038,108 @@ static int config_global_keyid(void)
> > > >   	return ret;
> > > >   }
> > > >   
> > > > +atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> > > > +{
> > > > +	return &pamt_refcounts[hpa / PMD_SIZE];
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);
> > > 
> > > It's not quite clear why this function needs to be exported in this patch.  IMO
> > > it's better to move the export to the patch which actually needs it.
> > > 
> > > Looking at patch 5, tdx_pamt_get()/put() use it, and they are in KVM code.  But
> > > I think we should just put them here in this file.  tdx_alloc_page() and
> > > tdx_free_page() should be in this file too.
> > > 
> > > And instead of exporting tdx_get_pamt_refcount(), the TDX core code here can
> > > export tdx_alloc_page() and tdx_free_page(), providing two high level helpers to
> > > allow the TDX users (e.g., KVM) to allocate/free TDX private pages.  How PAMT
> > > pages are allocated is then hidden in the core TDX code.
> > 
> > We would still need tdx_get_pamt_refcount() to handle case when we need to
> > bump refcount for page allocated elsewhere.
> 
> Hmm I am not sure I am following this.  What "page allocated" are you referring
> to?  I am probably missing something, but if the caller wants a TDX page then it
> should just call tdx_alloc_page() which handles refcount bumping internally. 
> No?

Pages that get mapped to the guest is allocated externally via
guest_memfd and we need bump refcount for them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

