Return-Path: <kvm+bounces-9964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D9686802C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 801211F23072
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE6712F583;
	Mon, 26 Feb 2024 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hBDh4B6g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F220E12E1D5;
	Mon, 26 Feb 2024 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973796; cv=none; b=DF7QtoWEUhFlyDNVxNhUw4tozPNu2k2p8TSXHbMeWTUEjECDPwsJB4rTjwiTVIZPj4kTEXhwU51OuLH2wH3EO+9wAcetpJjlmNE/2JUiR6401hW0KDnzFN/R+YSuEebjIFkeRUVDeDX22zAQ6r3AUkpqk7eZ9ELSqK68GHxE25Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973796; c=relaxed/simple;
	bh=LHD+JDEOdVWmiSEIxtQemrQnvU3P82mWYGpIuPIt0XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIMO6z2Nq7F9XwK1mKq0+tybJ9vvvCWQPxS3Dw07m05Z2he6htDchEJVC0SUGybDqvWnVFMp5Er1erAHodeJB2WlLGxASWIkFK/dnaouGKpWgGBg83CUvmGsCCRN7de+s33LXYIgyJFj6nbZoKhxkPv6fTqEk1GNS2ArNx8OPPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hBDh4B6g; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973794; x=1740509794;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LHD+JDEOdVWmiSEIxtQemrQnvU3P82mWYGpIuPIt0XY=;
  b=hBDh4B6gjaZrgSufEtAB4JhwjF/lA2j9FiFROtOnIo6dXP+vRwYIBCsW
   3Hw9uUAwtxlaq7d6BTdk2br96A/VUhnYtFd672YiVIzzn6bnwkrG3iidb
   6q2Jh3CH5894Kn5wLJsyByrHb0+3rIx6aqGfXZ3qVGuqHn7gWTsSkjOYf
   9iWW9fXGS8NG7paEP7Vl3V1mH4BUU1jJ33BVlR8KPQFY89c9Srfsi/HSa
   hP0EiROWRsjKIQE+T96mHCvdvNueeJU85yskVFVFfPu+WvXwFWbFKgspf
   GLwKZxUtGys5nQXbPxt0xhvTJdi7j0rx8W7RSomtpE9sC4bsaTw6x/8uI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14719198"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="14719198"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:56:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6909793"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:56:33 -0800
Date: Mon, 26 Feb 2024 10:56:32 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 024/121] KVM: TDX: create/destroy VM structure
Message-ID: <20240226185632.GJ177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <167b3797f5928c580526f388761dcfb342626ad2.1705965634.git.isaku.yamahata@intel.com>
 <20240201083227.vwyqlptrr3bdwr7m@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240201083227.vwyqlptrr3bdwr7m@yy-desk-7060>

On Thu, Feb 01, 2024 at 04:32:27PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

...
> > +static int __tdx_reclaim_page(hpa_t pa)
> > +{
> > +	struct tdx_module_args out;
> > +	u64 err;
> > +
> > +	do {
> > +		err = tdh_phymem_page_reclaim(pa, &out);
> > +		/*
> > +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> > +		 * state.  i.e. destructing TD.
> > +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> > +		 * Because we're destructing TD, it's rare to contend with TDR.
> > +		 */
> > +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
> 
> v16 changed to tdx module 1.5, so here should be TDX_OPERAND_ID_TDR, value 128ULL.

We should handle both RCX(SEPT) and TDR. So I make it err == RCX || err == TDR.

...

> > +static int __tdx_td_init(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages;
> > +	unsigned long *tdcs_pa = NULL;
> > +	unsigned long tdr_pa = 0;
> > +	unsigned long va;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	ret = tdx_guest_keyid_alloc();
> > +	if (ret < 0)
> > +		return ret;
> > +	kvm_tdx->hkid = ret;
> > +
> > +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +	if (!va)
> > +		goto free_hkid;
> > +	tdr_pa = __pa(va);
> > +
> > +	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> > +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +	if (!tdcs_pa)
> > +		goto free_tdr;
> > +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +		if (!va)
> > +			goto free_tdcs;
> > +		tdcs_pa[i] = __pa(va);
> > +	}
> > +
> > +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> > +		ret = -ENOMEM;
> > +		goto free_tdcs;
> > +	}
> > +	cpus_read_lock();
> > +	/*
> > +	 * Need at least one CPU of the package to be online in order to
> > +	 * program all packages for host key id.  Check it.
> > +	 */
> > +	for_each_present_cpu(i)
> > +		cpumask_set_cpu(topology_physical_package_id(i), packages);
> > +	for_each_online_cpu(i)
> > +		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> > +	if (!cpumask_empty(packages)) {
> > +		ret = -EIO;
> > +		/*
> > +		 * Because it's hard for human operator to figure out the
> > +		 * reason, warn it.
> > +		 */
> > +#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> > +		pr_warn_ratelimited(MSG_ALLPKG);
> > +		goto free_packages;
> > +	}
> 
> Generate/release hkid both requests to have "cpumask of at least 1
> cpu per each node", how about add one helper for this ? The helper also
> checks the cpus_read_lock() is held and return the cpumask if at least
> 1 cpu is online per node, thus this init funciotn can be simplified and
> become more easy to review.

We don't need cpumask to release hkid. So only tdx_td_init() needs cpumask
allocation. So I didn't to bother create a helper function with v19.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

