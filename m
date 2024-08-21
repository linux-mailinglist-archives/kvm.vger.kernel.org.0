Return-Path: <kvm+bounces-24688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29252959465
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 08:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB5881F21621
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 06:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C4E16D9AA;
	Wed, 21 Aug 2024 06:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KuSCY8zD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4235216D31C;
	Wed, 21 Aug 2024 06:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724220821; cv=none; b=fFlGDsj40DWigXzifZgeP//dPnfAevLv1gtxeKHdKlj5zc9R6yXwNC9hhPt7hBdE2xpNuTOIrZIGwWDJiwuOK8fa9JkxY23wj7B/haDI/1ZGzeeHM6X4pL6QBNW69QcRCOILhi2ETj6ixmnMU9ZiiMa4eIx0T+OYYNqgPSTQ040=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724220821; c=relaxed/simple;
	bh=AyoaCIrZcZi52TPUfGTOUI23PSvvOHEbTjEngSKmPbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVpNRORyEa1IKmVed2apv7eK5YlBb6Nqmc8NGhsHxPpV17FQoiXO7TBnpdAeJVwW5vJ393RC3HHTu0ZrNidB0MjVexoKRz4pcm9WguK1gerUfTNBREfs4f1iW/jIqudKBWeC11SZNaQTDO/jdxSxYuT1h1z2P2ZpWG1f21tITjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KuSCY8zD; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724220819; x=1755756819;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AyoaCIrZcZi52TPUfGTOUI23PSvvOHEbTjEngSKmPbE=;
  b=KuSCY8zDnxXs+Q4eLpHqdRMqI9UicaElWMr05qcEA/LnVkC8x8BfTEhr
   BcYK46CrM4q35ZWdFCnK+CWYFFv64LgRGJS/jOkr+OLPUszHHQtaOc6xF
   p0nS4TlcWZPp1rTzolumE+grAhjYGBzy0ZkjevYjpy3aoArTakHEoB6Du
   MLBqljtnPctzaMDGPJbu32rAhxYi5LuLRtCZLP1i033idok5DyFrwN29k
   WkVQPIjDpFksquzg6aoIGwGh1r6VZV0WjZczfTPD83AM5ik0ucsd0hCue
   FR4RKLk+EQVKtXoKzGOYWgffbUoxN+ai5+IVLHbjlHq2yiE1IsnLNQE64
   g==;
X-CSE-ConnectionGUID: mwBlvkjRTgqMc7+s3YMAZA==
X-CSE-MsgGUID: LEOjAmC6TyuHbomI2o4Ihw==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="40018112"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="40018112"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 23:13:38 -0700
X-CSE-ConnectionGUID: FQLKngBlSguLqrZGpQG31g==
X-CSE-MsgGUID: bTJ6Aco9Syy5IU9vHQkVbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="65826075"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.248])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 23:13:34 -0700
Date: Wed, 21 Aug 2024 09:13:29 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZsWFiSAwKP8BfOUK@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
 <20240814030849.7yqx3db4oojsoh5k@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814030849.7yqx3db4oojsoh5k@yy-desk-7060>

On Wed, Aug 14, 2024 at 11:08:49AM +0800, Yuan Yao wrote:
> On Mon, Aug 12, 2024 at 03:48:08PM -0700, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +static int __tdx_td_init(struct kvm *kvm)
> > +{
...
> > +	/*
> > +	 * TDH.MNG.CREATE tries to grab the global TDX module and fails
> > +	 * with TDX_OPERAND_BUSY when it fails to grab.  Take the global
> > +	 * lock to prevent it from failure.
> > +	 */
> > +	mutex_lock(&tdx_lock);
> > +	kvm_tdx->tdr_pa = tdr_pa;
> > +	err = tdh_mng_create(kvm_tdx, kvm_tdx->hkid);
> > +	mutex_unlock(&tdx_lock);
> > +
> > +	if (err == TDX_RND_NO_ENTROPY) {
> > +		kvm_tdx->tdr_pa = 0;
> 
> code path after 'free_packages' set it to 0, so this can be removed.
> 
> > +		ret = -EAGAIN;
> > +		goto free_packages;
> > +	}
> > +
> > +	if (WARN_ON_ONCE(err)) {
> > +		kvm_tdx->tdr_pa = 0;
> 
> Ditto.

Yes those seem unnecessary.

> > +	kvm_tdx->tdcs_pa = tdcs_pa;
> > +	for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> > +		err = tdh_mng_addcx(kvm_tdx, tdcs_pa[i]);
> > +		if (err == TDX_RND_NO_ENTROPY) {
> > +			/* Here it's hard to allow userspace to retry. */
> > +			ret = -EBUSY;
> > +			goto teardown;
> > +		}
> > +		if (WARN_ON_ONCE(err)) {
> > +			pr_tdx_error(TDH_MNG_ADDCX, err);
> > +			ret = -EIO;
> > +			goto teardown;
> 
> This and above 'goto teardown' under same for() free the
> partially added TDCX pages w/o take ownership back, may
> 'goto teardown_reclaim' (or any better name) below can
> handle this, see next comment for this patch.
...
> > +teardown:
> > +	for (; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> > +		if (tdcs_pa[i]) {
> > +			free_page((unsigned long)__va(tdcs_pa[i]));
> > +			tdcs_pa[i] = 0;
> > +		}
> > +	}
> > +	if (!kvm_tdx->tdcs_pa)
> > +		kfree(tdcs_pa);
> 
> Add 'teardown_reclaim:' Here, pair with my last comment.

Makes sense, I'll do patch.

Regards,

Tony

