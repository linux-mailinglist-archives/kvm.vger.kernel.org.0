Return-Path: <kvm+bounces-15543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E908AD34C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3D521F2247A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4033D153BEE;
	Mon, 22 Apr 2024 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqYLxSrH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B8D15218D;
	Mon, 22 Apr 2024 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713807017; cv=none; b=aoZRgTztKuuGVLxerZ4LysHM32XEXx8i4uKmxRvQHsW9lpJ4qUAuxydqG0XDf5XMy6/CNf8yQn2pf5d8Aj65mjqjrkB8Y/LfagFmGYHoa1SKysKQbBZSAxU35jl2CcX7h1VEPLHOT4DK5odm+s0zykG9gYOFxOM/DEAKERNj3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713807017; c=relaxed/simple;
	bh=5ZRZVW31i+SBd3dvJdxmL6VxYW9DL9+AI1e6G7ZmfhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jY/iGW/gRpDdL03vsE8Engj2+ORT46nAoRq3rH9TuSOlW+saF0r51liwRDHii5/Xzh4PudZCPoxyWs+vxTtTlQ+2VkreAUjBuBLF2ZdF10JwLX8d8tYzJdnebOGEsqw0YW+IPSbwULUUn+jOmHyjmT/y/KPCdRSsjpTKMOjQsPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqYLxSrH; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713807016; x=1745343016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ZRZVW31i+SBd3dvJdxmL6VxYW9DL9+AI1e6G7ZmfhQ=;
  b=DqYLxSrHpl5hv4msVDsU+nzMNrqju5S+YE2fm+4Xd8IpQQ6hqYyArcHX
   QyMxdjXXCDRDLEHVetky4CEbnqZKN+pKw+kkbE7otP/JlGl62tOIcX780
   FAGSTQEQt0OFuWckp5B0d7g/mo6M2vue709yXmdhUrZ78ebStQJWSksRt
   0qyN1pdKuwy7awWpVtoRIRY1V6Rd7mmcKx5RwqV9CZt8JnbB9UGnw1Wui
   GUGLnd6mUoLlTJ2KQQNsrg9bdMLHzIYb9pNRbV8vz38At+fOLapMcapav
   TxGooTOjtziuum7HFlpl31nqhqX1xV1E04HYk2mHReSv/HDFo9b+G5Kak
   Q==;
X-CSE-ConnectionGUID: jUkdocaVQ/u9TKMmsKscsA==
X-CSE-MsgGUID: Jkb0NHm9RDWxucef/1slqA==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13146704"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="13146704"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:30:15 -0700
X-CSE-ConnectionGUID: WwRlqWucQv6CFJy3gFyxyg==
X-CSE-MsgGUID: GMWGYYMdSCWwyx/dRFUh7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="28545389"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:30:14 -0700
Date: Mon, 22 Apr 2024 10:30:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20240422173013.GJ3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <ZiXautOkEweWfUL0@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZiXautOkEweWfUL0@yzhao56-desk.sh.intel.com>

On Mon, Apr 22, 2024 at 11:34:18AM +0800,
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:00AM -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
> > +{
> > +	return sp->private_spt;
> > +}
> > +
> > +static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
> > +{
> > +	sp->private_spt = private_spt;
> > +}
> This function is actually not used for initialization.
> Instead, it's only called after failure of free_private_spt() in order to
> intentionally leak the page to prevent kernel from accessing the encrypted page.
> 
> So to avoid confusion, how about renaming it to kvm_mmu_leak_private_spt() and
> always resetting the pointer to NULL?
> 
> static inline void kvm_mmu_leak_private_spt(struct kvm_mmu_page *sp)
> {
> 	sp->private_spt = NULL;
> }

The older version had a config to disable TDX TDP MMU at a compile time.  Now
we dropped the config so that we don't necessarily need wrapper function with
#ifdef. Now we have only single caller, I'll eliminate this wrapper function
(and related wrapper functions) by open code.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

