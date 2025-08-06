Return-Path: <kvm+bounces-54081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A52EB1BF12
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 05:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60B77627948
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 03:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB691DFE26;
	Wed,  6 Aug 2025 03:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xuk2v2hZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AEE1DEFF5;
	Wed,  6 Aug 2025 03:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754450021; cv=none; b=p4JDC6AjK6cew9h5u4U/dzAWY+/KMe4LqK2L/Cymtz5T/NculxvQtaXyrkGt43vIemPgc5qsWZMZdoarrHQfJF0WkWB16f9r6kr3T5pq1uUl1lZDjSOCm6cPuibEHiTsv4YY3K5rm7mz9eczg6bsmb2uWlU/heJ1YphlDAe1Jlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754450021; c=relaxed/simple;
	bh=FIcC/HNmPTiAO+Z06G95G1OuS8Y+G39qJToe+fbZl1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rohU18+okR6Vvm8cC9SixWsogxePXVWw+9oabm41WlZ+OSsaJvH0MqBLRO5N4VP69PdIUgHv2PqaS7bG/7PfT5kXciH1N7IqfASUYK94FLghwr3K/PMTFbqusAjD6+2c/z4df8r1MCebyPfqCYqLWyDxa5Ap3DWXlHo1t88eVog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xuk2v2hZ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754450018; x=1785986018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FIcC/HNmPTiAO+Z06G95G1OuS8Y+G39qJToe+fbZl1A=;
  b=Xuk2v2hZfhl9SZGK3Ao0qdKxdyxyiXcapotM5bhO/q1Pg1MgTcY7kfdN
   MEf9oRIWKK6LueE/A3pqft2bu/C2MQucs5W+GTV1l5vQsFfa9zIByEoYg
   4yRrLh5eW8F0R47rV8cSOVdd+9ClIQCXSijSJ4Pq1lCVe6idySo/CGnSH
   dURd+k0eYpJn/1DSMYaBtmyIVWBEcs3bBlu3GzB3tXZWJfaOR2wnRce5N
   pkuPHHAmQxYAy/3vvlS4saJtXc68AA+0d8rPSDtgQcL1zqac1MkLPv/XP
   lIgds8sZNPfZ/xyNTY4S+W0jZm/1iqasfjMjr0xYDUw/ez+uQEYvcXct1
   w==;
X-CSE-ConnectionGUID: imhHRvqbTauuOhPYFkLV3g==
X-CSE-MsgGUID: Dt5fEP8oTuuIRUerDvXS4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="74218271"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="74218271"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 20:13:38 -0700
X-CSE-ConnectionGUID: 5KGgxhw7TpuNy/uWze/qsA==
X-CSE-MsgGUID: XFQl7BZ+SOSfoo6JUSuPLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169924374"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 05 Aug 2025 20:13:33 -0700
Date: Wed, 6 Aug 2025 11:03:54 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>,
	linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org,
	pbonzini@redhat.com, eddie.dong@intel.com,
	kirill.shutemov@intel.com, dave.hansen@intel.com,
	kai.huang@intel.com, isaku.yamahata@intel.com,
	elena.reshetova@intel.com, rick.p.edgecombe@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Message-ID: <aJLGGoleGIEwb8Ee@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
 <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
 <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
 <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
 <aJFUspObVxdqInBo@google.com>
 <6891826bbbe79_cff99100f7@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6891826bbbe79_cff99100f7@dwillia2-xfh.jf.intel.com.notmuch>

On Mon, Aug 04, 2025 at 09:02:51PM -0700, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > On Mon, Aug 04, 2025, dan.j.williams@intel.com wrote:
> > > Xu Yilun wrote:
> > > > So my idea is to remove tdx_tsm device (thus disables tdx_tsm driver) on
> > > > vmxoff.
> > > > 
> > > >   KVM                TDX core            TDX TSM driver
> > > >   -----------------------------------------------------
> > > >   tdx_disable()
> > > >                      tdx_tsm dev del
> > > >                                          driver.remove()
> > > >   vmxoff()
> > > > 
> > > > An alternative is to move vmxon/off management out of KVM, that requires
> > > > a lot of complex work IMHO, Chao & I both prefer not to touch it.
> > 
> > Eh, it's complex, but not _that_ complex.
> > 
> > > It is fine to require that vmxon/off management remain within KVM, and
> > > tie the lifetime of the device to the lifetime of the kvm_intel module*.
> > 
> > Nah, let's do this right.  Speaking from experience; horrible, make-your-eyes-bleed
> > experience; playing games with kvm-intel.ko to try to get and keep CPUs post-VMXON
> > will end in tears.
> > 
> > And it's not just TDX-feature-of-the-day that needs VMXON to be handled outside
> > of KVM, I'd also like to do so to allow out-of-tree hypervisors to do the "right
> > thing"[*].  Not because I care deeply about out-of-tree hypervisors, but because
> > the lack of proper infrastructure for utilizing virtualization hardware irks me.
> > 
> > The basic gist is to extract system-wide resources out of KVM and into a separate
> > module, so that e.g. tdx_tsm or whatever can take a dependency on _that_ module
> > and elevate refcounts as needed.  All things considered, there aren't so many
> > system-wide resources that it's an insurmountable task.
> >
> > I can provide some rough patches to kickstart things.  It'll probably take me a
> > few weeks to extract them from an old internal branch, and I can't promise they'll
> > compile.  But they should be good enough to serve as an RFC.
> > 
> > https://lore.kernel.org/all/ZwQjUSOle6sWARsr@google.com
> 
> Sounds reasonable to me.
> 
> Not clear on how it impacts tdx_tsm implementation. The lifetime of this
> tdx_tsm device can still be bound by tdx_enable() / tdx_cleanup(). The

I assume with VMXON outside of KVM, tdx tsm driver could actively call
tdx_bringup(), which includes VMXON, tdx_enable() and cpuhp handling.
I.e, tdx_tsm device lifetime won't have to be bound to any other
component, it could keep living until tdx_tsm module ends.

> refactor removes the need for the autoprobe hack below. It may also
> preclude async vmxoff cases by pinning? Or does pinning still not solve

not by pinning, by cpuhp handling async vmxoff won't affect seamcall
execution.

> the reasons for bouncing vmx on suspend/shutdown?

Thanks,
Yilun

