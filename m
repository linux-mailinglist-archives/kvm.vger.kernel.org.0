Return-Path: <kvm+bounces-13483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E05897740
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 19:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C367E1C20E55
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3EB156966;
	Wed,  3 Apr 2024 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0oxLq6H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E92156886;
	Wed,  3 Apr 2024 17:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712165061; cv=none; b=jkLF0mzhlGzN7i/taFzbkTIPfLo/sW2jbr50lgVU05lMEUNKq+2E1nhEYgn0WKCE3s3CRmb8oSksnQn8g6qHduxNqy31o497vxG8Cv+GnvuykcsBB795PlfdNyFvZUcp6v35dxRXvw+E5ZVyUWob7nV3SIzHQ6GNyltCNKuZhPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712165061; c=relaxed/simple;
	bh=guiIxGTSK6Jw1CTYZifG+HXUJ2jyUvSv+qYpZ0k2AGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPbpsO3bYCgrOeOTRDdOsf6Ji4gTSb41Jsb41iEtQE1ZT4BITY5QUiXQ+m/NqsFjyTnqd8/rFSxc4UF0NaGX8VCefqM7LXmLv3sQWjm/RzacgTvYHsct22g064yvV0s/h4NwmDo/Rd4eBr5/KwqF7VcPbQYr5wSuFu3QDeOVtW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0oxLq6H; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712165059; x=1743701059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=guiIxGTSK6Jw1CTYZifG+HXUJ2jyUvSv+qYpZ0k2AGE=;
  b=B0oxLq6Hq1+Gz9rjy/geud+VEa3zIdFXx5yNlAVnrcZMbb7o0Vju9/ke
   Z24foWqrUb7509Fxf0Ykgm7zRCiOSlgwehQdrlX7h9VFQSM9pj3vcHrBR
   Q4qC+oWE/14KMevV97ZLty8IlAlDligUloPS3mcImNepy/wXlQNKAkfPa
   V1cMPmsK7DU/XJt026leOjTJ74tdfj0S97QUhsETFNLgSb6LlExKX+blh
   PXGzhu0e07pdiePwVqTabfQsFSMEsfmczdSh3/v9qCl2qHwdDtOA1XdLV
   oJmAMN3S8eeVpQ+MEIqOiJIzHkKRcC7mv5Shg9Rb1xTviK9148sy/90kY
   Q==;
X-CSE-ConnectionGUID: 5c8iTgRWS2mIk2BdtmCUCQ==
X-CSE-MsgGUID: fnNzaGJFSFK3Loaf3pDyWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7337333"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7337333"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 10:24:18 -0700
X-CSE-ConnectionGUID: qIjzXJ3GQoG7ygvdxCKZ/w==
X-CSE-MsgGUID: vV7dlDYUTkyv3asHQNHDBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="23194376"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 10:24:18 -0700
Date: Wed, 3 Apr 2024 10:24:17 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240403172417.GE2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <9f5c6259-78e1-4470-a013-91392bf3cea5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f5c6259-78e1-4470-a013-91392bf3cea5@intel.com>

On Thu, Mar 28, 2024 at 12:33:35PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > +	kvm_tdx->tdr_pa = tdr_pa;
> > +
> > +	for_each_online_cpu(i) {
> > +		int pkg = topology_physical_package_id(i);
> > +
> > +		if (cpumask_test_and_set_cpu(pkg, packages))
> > +			continue;
> > +
> > +		/*
> > +		 * Program the memory controller in the package with an
> > +		 * encryption key associated to a TDX private host key id
> > +		 * assigned to this TDR.  Concurrent operations on same memory
> > +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> > +		 * mutex.
> > +		 */
> 
> IIUC the race can only happen when you are creating multiple TDX guests
> simulatenously?  Please clarify this in the comment.
> 
> And I even don't think you need all these TDX module details:
> 
> 		/*
> 		 * Concurrent run of TDH.MNG.KEY.CONFIG on the same
> 		 * package resluts in TDX_OPERAND_BUSY.  When creating
> 		 * multiple TDX guests simultaneously this can run
> 		 * concurrently.  Take the per-package lock to
> 		 * serialize.
> 		 */

As pointed by Chao, those mutex will be dropped.
https://lore.kernel.org/kvm/ZfpwIespKy8qxWWE@chao-email/
Also we would simplify cpu masks to track which package is online/offline,
which cpu to use for each package somehow.


> > +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> > +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> > +				      &kvm_tdx->tdr_pa, true);
> > +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> > +		if (ret)
> > +			break;
> > +	}
> > +	cpus_read_unlock();
> > +	free_cpumask_var(packages);
> > +	if (ret) {
> > +		i = 0;
> > +		goto teardown;
> > +	}
> > +
> > +	kvm_tdx->tdcs_pa = tdcs_pa;
> > +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> > +		if (err == TDX_RND_NO_ENTROPY) {
> > +			/* Here it's hard to allow userspace to retry. */
> > +			ret = -EBUSY;
> > +			goto teardown;
> > +		}
> > +		if (WARN_ON_ONCE(err)) {
> > +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> > +			ret = -EIO;
> > +			goto teardown;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> > +	 * ioctl() to define the configure CPUID values for the TD.
> > +	 */
> 
> Then, how about renaming this function to __tdx_td_create()?

So do we want to rename also ioctl name for consistency?
i.e. KVM_TDX_INIT_VM => KVM_TDX_CREATE_VM.

I don't have strong opinion those names. Maybe
KVM_TDX_{INIT, CREATE, or CONFIG}_VM?
And we can rename the function name to match it.

> > +	return 0;
> > +
> > +	/*
> > +	 * The sequence for freeing resources from a partially initialized TD
> > +	 * varies based on where in the initialization flow failure occurred.
> > +	 * Simply use the full teardown and destroy, which naturally play nice
> > +	 * with partial initialization.
> > +	 */
> > +teardown:
> > +	for (; i < tdx_info->nr_tdcs_pages; i++) {
> > +		if (tdcs_pa[i]) {
> > +			free_page((unsigned long)__va(tdcs_pa[i]));
> > +			tdcs_pa[i] = 0;
> > +		}
> > +	}
> > +	if (!kvm_tdx->tdcs_pa)
> > +		kfree(tdcs_pa);
> 
> The code to "free TDCS pages in a loop and free the array" is done below
> with duplicated code.  I am wondering whether we have way to eliminate one.
> 
> But I have lost track here, so perhaps we can review again after we split
> the patch to smaller pieces.

Surely we can simplify it.  Originally we had a spin lock and I had to separate
blocking memory allocation from its usage with this error clean up path.
Now it's mutex, we mix page allocation with its usage.


> > +	tdx_mmu_release_hkid(kvm);
> > +	tdx_vm_free(kvm);
> > +	return ret;
> > +
> > +free_packages:
> > +	cpus_read_unlock();
> > +	free_cpumask_var(packages);
> > +free_tdcs:
> > +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > +		if (tdcs_pa[i])
> > +			free_page((unsigned long)__va(tdcs_pa[i]));
> > +	}
> > +	kfree(tdcs_pa);
> > +	kvm_tdx->tdcs_pa = NULL;
> > +
> > +free_tdr:
> > +	if (tdr_pa)
> > +		free_page((unsigned long)__va(tdr_pa));
> > +	kvm_tdx->tdr_pa = 0;
> > +free_hkid:
> > +	if (is_hkid_assigned(kvm_tdx))
> > +		tdx_hkid_free(kvm_tdx);
> > +	return ret;
> > +}
> > +
> >   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_tdx_cmd tdx_cmd;
> > @@ -215,12 +664,13 @@ static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> >   static int __init tdx_module_setup(void)
> >   {
> > -	u16 num_cpuid_config;
> > +	u16 num_cpuid_config, tdcs_base_size;
> >   	int ret;
> >   	u32 i;
> >   	struct tdx_md_map mds[] = {
> >   		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> > +		TDX_MD_MAP(TDCS_BASE_SIZE, &tdcs_base_size),
> >   	};
> >   	struct tdx_metadata_field_mapping fields[] = {
> > @@ -273,6 +723,8 @@ static int __init tdx_module_setup(void)
> >   		c->edx = ecx_edx >> 32;
> >   	}
> > +	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> > +
> 
> Round up the 'tdcs_base_size' to make sure you have enough room, or put a
> WARN() here if not page aligned?

Ok, will add round up. Same for tdvps_base_size.
I can't find about those sizes and page size in the TDX spec.  Although
TDH.MNG.ADDCX() and TDH.VP.ADDCX() imply that those sizes are multiple of PAGE
SIZE, the spec doesn't guarantee it.  I think silent round up is better than
WARN() because we can do nothing about those values the TDX module provides.



> >   	return 0;
> >   error_out:
> > @@ -319,13 +771,27 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> >   	struct tdx_enabled enable = {
> >   		.err = ATOMIC_INIT(0),
> >   	};
> > +	int max_pkgs;
> >   	int r = 0;
> > +	int i;
> 
> Nit: you can put the 3 into one line.
> 
> > +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> > +		pr_warn("MOVDIR64B is reqiured for TDX\n");
> 
> It's better to make it more clear:
> 
> "Disable TDX: MOVDIR64B is not supported or disabled by the kernel."
> 
> Or, to match below:
> 
> "Cannot enable TDX w/o MOVDIR64B".

Ok.


> > +		return -EOPNOTSUPP;
> > +	}
> >   	if (!enable_ept) {
> >   		pr_warn("Cannot enable TDX with EPT disabled\n");
> >   		return -EINVAL;
> >   	}
> > +	max_pkgs = topology_max_packages();
> > +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> > +				   GFP_KERNEL);
> > +	if (!tdx_mng_key_config_lock)
> > +		return -ENOMEM;
> > +	for (i = 0; i < max_pkgs; i++)
> > +		mutex_init(&tdx_mng_key_config_lock[i]);
> > +
> 
> Using a per-socket lock looks a little bit overkill to me.  I don't know
> whether we need to do in the initial version.  Will leave to others.
> 
> Please at least add a comment to explain this is for better performance when
> creating multiple TDX guests IIUC?

Will delete the mutex and simply the related logic.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

