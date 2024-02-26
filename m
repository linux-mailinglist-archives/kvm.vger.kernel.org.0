Return-Path: <kvm+bounces-9959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DF7867FFE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC4791F2A6C5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C3F12F398;
	Mon, 26 Feb 2024 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aWKluxCG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AACF12BEAC;
	Mon, 26 Feb 2024 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973219; cv=none; b=c6jyZVEbexMAA+tS8gBFzkNkc8dXl70d+cAfvmSuUbKZItIqBB8D4ojXoImXCZnu3tnhp37U+1xL2VB3QHhl71H5fsd9lZ/UEriCJMSycWkH2hjOVaru3l7Z1LPQazdQLxeVs00/n7MSNN5jj4HHVNeYfpiPxKlKsyY/Lljr0zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973219; c=relaxed/simple;
	bh=IEHN+hbJJ2pkcDOFbDZUNs1LJ5lMb5GwZOaxnquvMI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ce1+gP5kuhQa7FFWoARxVE54GkfqZkev5nX7hPvP98bDqkNvwNem5YICgoJUruEBAqEbx6idbRrcjFrSHwNlMHF28uG4rWQ1z6eQHIMl5B9KDKlyh1PoWzbQ7cojmwauztUn1Rglo+EpT0a1i4BmWkLi5ACLmHwRVFNQTwMA900=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aWKluxCG; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973216; x=1740509216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IEHN+hbJJ2pkcDOFbDZUNs1LJ5lMb5GwZOaxnquvMI8=;
  b=aWKluxCGffHd+IZ9pMuO1gv6eJ132N3wufiUGDaP6Ing6yPkFBLVVKOA
   S/DpIQjO+moaoAEt4OwLdv5g9/MhI3bCiqDM4Tcmk2IXawxcWfAKHaoAS
   YWlFbB3CWd17JFO9ZHX0wNPA6DT3LnP8a3jw2DElxA+zVz8QpfhOg3uDK
   EJCiox8aZBIZ/MnHcHoU3mwhMXY2TMPvNRU/BF9GkCqjD4qk13J9GflvK
   tC+g1of3b2wzNBgSTX06GSLV7xTzybrBiIOrIvk7Z56QdJytoz2C1bA+n
   zi1ZnVO4hKm7n3ercLbUZBPvtbn9zrjLS1+XiL7aDyZb2t80YUMJlzypl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3408157"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3408157"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:46:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7298753"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:46:55 -0800
Date: Mon, 26 Feb 2024 10:46:54 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 001/121] x86/virt/tdx: Export TDX KeyID information
Message-ID: <20240226184654.GG177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <fed47cd35b32ee66f7ec55bdda6ccab12c139e85.1705965634.git.isaku.yamahata@intel.com>
 <20240201015729.6n5uavy7rxdjtqwc@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240201015729.6n5uavy7rxdjtqwc@yy-desk-7060>

On Thu, Feb 01, 2024 at 09:57:29AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jan 22, 2024 at 03:52:37PM -0800, isaku.yamahata@intel.com wrote:
> > From: Kai Huang <kai.huang@intel.com>
> >
> > Each TDX guest must be protected by its own unique TDX KeyID.  KVM will
> > need to tell the TDX module the unique KeyID for a TDX guest when KVM
> > creates it.
> >
> > Export the TDX KeyID range that can be used by TDX guests for KVM to
> > use.  KVM can then manage these KeyIDs and assign one for each TDX guest
> > when it is created.
> >
> > Each TDX guest has a root control structure called "Trust Domain Root"
> > (TDR).  Unlike the rest of the TDX guest, the TDR is protected by the
> > TDX global KeyID.  When tearing down the TDR, KVM will need to pass the
> > TDX global KeyID explicitly to the TDX module to flush cache associated
> > to the TDR.
> >
> > Also export the TDX global KeyID for KVM to tear down the TDR.
> >
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> The variables exported by this patch are used first time in patch 18 IIUC...
> So how about move this one just before the patch 18 ?

With v19, I put those tdx host patches in the first part.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

