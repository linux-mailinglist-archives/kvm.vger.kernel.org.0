Return-Path: <kvm+bounces-53884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B071B19BF0
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDC2118898CB
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 07:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B6F23507E;
	Mon,  4 Aug 2025 07:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X8EFAfPo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613451DFE0B;
	Mon,  4 Aug 2025 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754291422; cv=none; b=ac0r4kHUHOrpG5PYV8m/ycKm0RdLITsSRJDpKQvL1jD2yVjIWgRgww6OkNVRmZRmIHwU6Das5HZtEadzArgPfL8uQTInrg1DeutJuFiliTzbxwvWC/SwUfTI2RIAgC0DMPtzA/4maU628EeLDicD+sV8oyKOnkeep1JtipU9Os8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754291422; c=relaxed/simple;
	bh=rZyea0tu1SNXXUMLdNWyhscMNRkf6r3aNbHQWaTsxM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uD7jM0ajFVXw/J/2HdVIS2RMbxCx1XB89xZdU+9ZdjcbHw6BLqTb9KezMo2j1W328/Knx1O04E6nwuGPQlAEeNslhNjsiUKCp2RIUWkqmJiqHrvgFS6gwIAi8RqpATZxZJWjdSgLLVNq/mMp0EktPvYyxdxDTtI6vcEDEQ1fF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X8EFAfPo; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754291420; x=1785827420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rZyea0tu1SNXXUMLdNWyhscMNRkf6r3aNbHQWaTsxM0=;
  b=X8EFAfPoyAcOkR4pCropi07+O5mz4aDbGdAyySOS+BT2cmvNVBucpi7F
   B0xAZCLQwZ/nUjp9UAN814OBHu6L0ZxyW0RlPqpajhhz/WtrYnFCRvjAV
   0h5v7OJauqmavgnc44pQJPl71XXm7ArpTxc/Z+h1G0CiNz9Xgx6Sl6sH8
   yubWcD4I1pmN+DmaAmAMy4LQnM1ER7OH55zLTq7mTQBZWHOGBgHQXk91D
   4v6KKp1PQwc5IDxJSvTYvpHpmIgZi6YcvRjv1fH7hQMcgYZawiZX3kMBr
   Hn4hCqVBDhoeO7cpKS5PzScXBdcbpnOT2FVn795/pDkQMD7MFQjzj8wdO
   A==;
X-CSE-ConnectionGUID: 13nw8w5oTWi3FHZUOjioEw==
X-CSE-MsgGUID: E3NlS4PeSEOYVa9aSEmhBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="74131950"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="74131950"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:10:20 -0700
X-CSE-ConnectionGUID: V8xmCoh9RrCcKM/D/dWyaQ==
X-CSE-MsgGUID: jWFChVK2TZmgrKGwhNDQag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164873821"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 04 Aug 2025 00:10:15 -0700
Date: Mon, 4 Aug 2025 15:00:42 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
	x86@kernel.org, kvm@vger.kernel.org, seanjc@google.com,
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
Message-ID: <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
 <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>

> > > - Create drivers/virt/coco/tdx-tsm/bus.c for registering the tdx_subsys.
> > >   The tdx_subsys has sysfs attributes like "version" (host and guest
> > >   need this, but have different calls to get at the information) and
> > >   "firmware" (only host needs that). So the common code will take sysfs
> > >   groups passed as a parameter.
> > > 
> > > - The "tdx_tsm" device which is unused in this patch set can be
> > 
> > It is used in this patch, Chao creates tdx module 'version' attr on this
> > device. But I assume you have different opinion: tdx_subsys represents
> > the whole tdx_module and should have the 'version', and tdx_tsm is a
> > sub device dedicate for TDX Connect, is it?
> 
> The main reason for a tdx_tsm device in addition to the subsys is to
> allow for deferred attachment.

I've found another reason, to dynamic control tdx tsm's lifecycle.
tdx_tsm driver uses seamcalls so its functionality relies on tdx module
initialization & vmxon. The former is a one way path but vmxon can be
dynamic off by KVM. vmxoff is fatal to tdx_tsm driver especially on some
can-not-fail destroy path.

So my idea is to remove tdx_tsm device (thus disables tdx_tsm driver) on
vmxoff.

  KVM                TDX core            TDX TSM driver
  -----------------------------------------------------
  tdx_disable()
                     tdx_tsm dev del
                                         driver.remove()
  vmxoff()

An alternative is to move vmxon/off management out of KVM, that requires
a lot of complex work IMHO, Chao & I both prefer not to touch it.


That said, we still want to "deal with bus/driver binding logic" so faux
is not a good fit.

> 
> Now, that said, the faux_device infrastructure has arrived since this
> all started and *could* replace tdx_subsys. The only concern is whether
> the tdx_tsm driver ever needs to do probe deferral to wait for IOMMU or
> PCI initialization to happen first.

The tdx_tsm driver needs to wait for IOMMU/PCI initialization...

> 
> If probe deferral is needed that requires a bus, if probe can always be
> synchronous with TDX module init then faux_device could work.

... but doesn't see need for TDX Module early init now. Again TDX Module
init requires vmxon, so it can't be earlier than KVM init, nor the
IOMMU/PCI init. So probe synchronous with TDX module init should be OK.

But considering the tdx tsm's lifecycle concern, I still don't prefer
faux.

Thanks,
Yilun

