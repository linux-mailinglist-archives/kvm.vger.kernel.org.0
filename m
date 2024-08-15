Return-Path: <kvm+bounces-24222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C44E9952725
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 02:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 881DC285A25
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2754C69;
	Thu, 15 Aug 2024 00:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Do76opnJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49517C9;
	Thu, 15 Aug 2024 00:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723682886; cv=none; b=rtZHmT1Gqg7WLikbspYVpPTiPJmK8jvMmtdnypu+Ii1IAMmYzKkIrHWpb2qsnvcnh4UUGfD3xzOIOozVpZJA2G+eSXDZTOwxqwcwZ05wu37MNGrvt+HI47rvE7nVJRLcH3+qTSxnxHqD2dHyp5CfThBybAFL9OFOR2mX4Kqo4zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723682886; c=relaxed/simple;
	bh=rd3ohXZlR4ekQpGjKEUBH0ZclZPnXOq0KAl2DRONsZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9WEmGTU0Ov+WvTZ7unFsjtF0VlEJAIjhg8obhl8ZrLg8piPGhRbt9ttL8+KU1oL3otR0Mog2x86ZIqlZK8wgsjoaSY4MihS4rjhyFy2dc213CCzISBI4kEu2yQhaAeJUs2N9EhP58iedg5Knh+kZsbEMXQAXnZjvNRpX2yM1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Do76opnJ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723682884; x=1755218884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rd3ohXZlR4ekQpGjKEUBH0ZclZPnXOq0KAl2DRONsZU=;
  b=Do76opnJ3zSNyUH5vqI7Lp5M9PR2WmTjNd4FW+dEwc8l5hoaswg5HZYx
   HpUIsW258p0O0S7IqU9dcGN0CnFr2IOtQ0TygXYN7DGYtUsrFjyEkRg4V
   eQxG8VBhPQBD9aNURtxBUsOWfCTLpCrdt6VWuAfF8ttOtAowfvOe6wDu5
   v6Iya7v9P+FXaNXTM3+AYYxE6MeWxyYcRsNqaGGJjlPAP40EUkWzIm/ec
   ljE52eNzPzkOD454YiogpTMON3uH8oU1mXcQN3duydsHSi88dHuVfnfK0
   b3u5FVUrAwJk9uMFFLr+GGrkX5d7ik/j1TSNscnoc4ztBzhvKHmhXyck2
   Q==;
X-CSE-ConnectionGUID: DjkjZLLLQEyGyYxYa+avvQ==
X-CSE-MsgGUID: F3wtjDN5Qni5aym1KgmACQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="33076862"
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="33076862"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 17:47:35 -0700
X-CSE-ConnectionGUID: uP7n1/BLTmqjlfz3k3moEQ==
X-CSE-MsgGUID: GNUZ3rjNQZ+iWP1dwzUelQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="58826983"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 17:47:32 -0700
Date: Wed, 14 Aug 2024 17:47:32 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <Zr1QJHj8W8L2BlvN@ls.amr.corp.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
 <ZruWBHdNwIAwm7QE@ls.amr.corp.intel.com>
 <20240814012006.tqxrfb3mu7wfsrqb@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814012006.tqxrfb3mu7wfsrqb@yy-desk-7060>

On Wed, Aug 14, 2024 at 09:20:06AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> > > > +		ret = -EIO;
> > > > +		pr_tdx_error(TDH_VP_CREATE, err);
> > > > +		goto free_tdvpx;
> > > > +	}
> > > > +
> > > > +	for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> > > > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > > +		if (!va) {
> > > > +			ret = -ENOMEM;
> > > > +			goto free_tdvpx;
> > >
> > > It's possible that some pages already added into TD by
> > > tdh_vp_addcx() below and they won't be handled by
> > > tdx_vcpu_free() if goto free_tdvpx here;
> >
> > Due to TDX TD state check, we can't free partially assigned TDCS pages.
> > TDX module seems to assume that TDH.VP.ADDCX() won't fail in the middle.
> 
> The already partially added TDCX pages are initialized by
> MOVDIR64 with the TD's private HKID in TDX module, the above
> 'goto free_tdvpx' frees them back to kernel directly w/o
> take back the ownership with shared HKID. This violates the
> rule that a page's ownership should be taken back with shared
> HKID before release to kernel if they were initialized by any
> private HKID before.
> 
> How about do tdh_vp_addcx() afer allocated all TDCX pages
> and give WARN_ON_ONCE() to the return value of
> tdh_vp_addcx() if the tdh_vp_addcx() won't fail except some
> BUG inside TDX module in our current usage ?

Yes, that makes sense.  Those error recovery paths need to be simplified.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

