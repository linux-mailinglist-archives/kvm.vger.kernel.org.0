Return-Path: <kvm+bounces-12468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7FD886641
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 06:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65C191F218C4
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 05:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D289EAE6;
	Fri, 22 Mar 2024 05:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ge6kxgZi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E858F6F;
	Fri, 22 Mar 2024 05:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711085542; cv=none; b=bapQwfmWMF7YVwFP21hDQbkJTHi9RgTjrQKCs7XnR1a6db/OMhzIChK9qV5sB/fF/YlQZKyWuTuPgXkDkkzm4WOW+dSe3JeemYkpOngJu2HL949La51Y84ltdSyQN/eYmd6qpiFCbF6/6a5wxUVJRSfynPyAlHdyVOecVnCI5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711085542; c=relaxed/simple;
	bh=KZ5svcnIx6Xazm1dxwaTFRgKe3CroIgI71z59w7maVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIVxKZAGc6F+AvLcB4GuGvI9CFgtA5B5aJWCBdjjHZ8dIWVe1dSj6zW3u8oxW0X37NqTrwaix1FmX9xtFURIUkFc9dMWZV/SRKowWja3trmma7RWuRoQu1HDL044JT5ckm15d2/jM5su7RlYVC0lwrnYHS4qsacWFWcjFewPA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ge6kxgZi; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711085541; x=1742621541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KZ5svcnIx6Xazm1dxwaTFRgKe3CroIgI71z59w7maVY=;
  b=ge6kxgZiiKdVcP9KclxKa2lc7hV3swAnKmyZXPwQ6GRu+kJjw9X6hLmV
   +M4AF7dayHv8bvGmWgQ3eXU//y5pgu5qJkeb65IurigY83n5IhGJJPSEc
   YjTMF+9SKMfmWC7UKe2wmzAkoUJKh6JIEKaPUEuy3HaYS578qDp/WgeBP
   nI+OVyPDuZCNnfe+TbDvJEdtp+UbqUb+N7n4mDVZ6jf2MSHUn4ywE9aYJ
   fooHlF+kkrsy7+2nUyoGQ6vZcz2uo9bB9MkUDQkGxZDIbSvYqWJhpfqCV
   pL2FK5X30j/cdswURQ3RGVh5jPM8RWHzzURe1XhAqjd3vMGGJBwPYFuVL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6010273"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6010273"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 22:32:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="14772995"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 22:32:16 -0700
Date: Fri, 22 Mar 2024 13:32:15 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240322053215.kwuyj3xpljxk5wgh@yy-desk-7060>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
 <20240322034641.cuxuxiejy5ovteid@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240322034641.cuxuxiejy5ovteid@yy-desk-7060>
User-Agent: NeoMutt/20171215

On Fri, Mar 22, 2024 at 11:46:41AM +0800, Yuan Yao wrote:
> On Thu, Mar 21, 2024 at 07:17:09AM -0700, Isaku Yamahata wrote:
> > On Wed, Mar 20, 2024 at 01:12:01PM +0800,
> > Chao Gao <chao.gao@intel.com> wrote:
...
> > > >+static int __tdx_td_init(struct kvm *kvm)
> > > >+{
> > > >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > >+	cpumask_var_t packages;
> > > >+	unsigned long *tdcs_pa = NULL;
> > > >+	unsigned long tdr_pa = 0;
> > > >+	unsigned long va;
> > > >+	int ret, i;
> > > >+	u64 err;
> > > >+
> > > >+	ret = tdx_guest_keyid_alloc();
> > > >+	if (ret < 0)
> > > >+		return ret;
> > > >+	kvm_tdx->hkid = ret;
> > > >+
> > > >+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > >+	if (!va)
> > > >+		goto free_hkid;
> > > >+	tdr_pa = __pa(va);
> > > >+
> > > >+	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> > > >+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > > >+	if (!tdcs_pa)
> > > >+		goto free_tdr;
> > > >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > > >+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > >+		if (!va)
> > > >+			goto free_tdcs;
> > > >+		tdcs_pa[i] = __pa(va);
> > > >+	}
> > > >+
> > > >+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> > > >+		ret = -ENOMEM;
> > > >+		goto free_tdcs;
> > > >+	}
> > > >+	cpus_read_lock();
> > > >+	/*
> > > >+	 * Need at least one CPU of the package to be online in order to
> > > >+	 * program all packages for host key id.  Check it.
> > > >+	 */
> > > >+	for_each_present_cpu(i)
> > > >+		cpumask_set_cpu(topology_physical_package_id(i), packages);
> > > >+	for_each_online_cpu(i)
> > > >+		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> > > >+	if (!cpumask_empty(packages)) {
> > > >+		ret = -EIO;
> > > >+		/*
> > > >+		 * Because it's hard for human operator to figure out the
> > > >+		 * reason, warn it.
> > > >+		 */
> > > >+#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> > > >+		pr_warn_ratelimited(MSG_ALLPKG);
> > > >+		goto free_packages;
> > > >+	}
> > > >+
> > > >+	/*
> > > >+	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> > > >+	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> > > >+	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> > > >+	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> > > >+	 * caller to handle the contention.  This is because of time limitation
> > > >+	 * usable inside the TDX module and OS/VMM knows better about process
> > > >+	 * scheduling.
> > > >+	 *
> > > >+	 * APIs to acquire the lock of KOT:
> > > >+	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> > > >+	 * TDH.PHYMEM.CACHE.WB.
> > > >+	 */
> > > >+	mutex_lock(&tdx_lock);
> > > >+	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> > > >+	mutex_unlock(&tdx_lock);
> > > >+	if (err == TDX_RND_NO_ENTROPY) {
> > > >+		ret = -EAGAIN;
> > > >+		goto free_packages;
> > > >+	}
> > > >+	if (WARN_ON_ONCE(err)) {
> > > >+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> > > >+		ret = -EIO;
> > > >+		goto free_packages;
> > > >+	}
> > > >+	kvm_tdx->tdr_pa = tdr_pa;
> > > >+
> > > >+	for_each_online_cpu(i) {
> > > >+		int pkg = topology_physical_package_id(i);
> > > >+
> > > >+		if (cpumask_test_and_set_cpu(pkg, packages))
> > > >+			continue;
> > > >+
> > > >+		/*
> > > >+		 * Program the memory controller in the package with an
> > > >+		 * encryption key associated to a TDX private host key id
> > > >+		 * assigned to this TDR.  Concurrent operations on same memory
> > > >+		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> > > >+		 * mutex.
> > > >+		 */
> > > >+		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> > >
> > > the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
> > > create TDs, the same set of CPUs (the first online CPU of each package) will be
> > > selected to configure the key because of the cpumask_test_and_set_cpu() above.
> > > it means, we never have two CPUs in the same socket trying to program the key,
> > > i.e., no concurrent calls.
> >
> > Makes sense. Will drop the lock.
>
> Not get the point, the variable "packages" on stack, and it's
> possible that "i" is same for 2 threads which are trying to create td.
> Anything I missed ?

Got the point after synced with chao.
in case of using for_each_online_cpu() it's safe to remove the mutex_lock(&tdx_mng_key_config_lock[pkg]),
since every thread will select only 1 cpu for each sockets in same order, and requests submited
to same cpu by smp_call_on_cpu() are ordered on the target cpu. That means removing the lock works for
using for_each_online_cpu() but does NOT work for randomly pick up a cpu per socket.

Maybe it's just my issue that doesn't realize what's going on here, but
I think it still worth to give comment here for why it works/does not work.

>
> >
> >
> > > >+		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> > > >+				      &kvm_tdx->tdr_pa, true);
> > > >+		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> > > >+		if (ret)
> > > >+			break;
> > > >+	}
> > > >+	cpus_read_unlock();
> > > >+	free_cpumask_var(packages);
> > > >+	if (ret) {
> > > >+		i = 0;
> > > >+		goto teardown;
> > > >+	}
> > > >+
> > > >+	kvm_tdx->tdcs_pa = tdcs_pa;
> > > >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > > >+		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> > > >+		if (err == TDX_RND_NO_ENTROPY) {
> > > >+			/* Here it's hard to allow userspace to retry. */
> > > >+			ret = -EBUSY;
> > > >+			goto teardown;
> > > >+		}
> > > >+		if (WARN_ON_ONCE(err)) {
> > > >+			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> > > >+			ret = -EIO;
> > > >+			goto teardown;
> > > >+		}
> > > >+	}
> > > >+
> > > >+	/*
> > > >+	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> > > >+	 * ioctl() to define the configure CPUID values for the TD.
> > > >+	 */
> > > >+	return 0;
> > > >+
> > > >+	/*
> > > >+	 * The sequence for freeing resources from a partially initialized TD
> > > >+	 * varies based on where in the initialization flow failure occurred.
> > > >+	 * Simply use the full teardown and destroy, which naturally play nice
> > > >+	 * with partial initialization.
> > > >+	 */
> > > >+teardown:
> > > >+	for (; i < tdx_info->nr_tdcs_pages; i++) {
> > > >+		if (tdcs_pa[i]) {
> > > >+			free_page((unsigned long)__va(tdcs_pa[i]));
> > > >+			tdcs_pa[i] = 0;
> > > >+		}
> > > >+	}
> > > >+	if (!kvm_tdx->tdcs_pa)
> > > >+		kfree(tdcs_pa);
> > > >+	tdx_mmu_release_hkid(kvm);
> > > >+	tdx_vm_free(kvm);
> > > >+	return ret;
> > > >+
> > > >+free_packages:
> > > >+	cpus_read_unlock();
> > > >+	free_cpumask_var(packages);
> > > >+free_tdcs:
> > > >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > > >+		if (tdcs_pa[i])
> > > >+			free_page((unsigned long)__va(tdcs_pa[i]));
> > > >+	}
> > > >+	kfree(tdcs_pa);
> > > >+	kvm_tdx->tdcs_pa = NULL;
> > > >+
> > > >+free_tdr:
> > > >+	if (tdr_pa)
> > > >+		free_page((unsigned long)__va(tdr_pa));
> > > >+	kvm_tdx->tdr_pa = 0;
> > > >+free_hkid:
> > > >+	if (is_hkid_assigned(kvm_tdx))
> > >
> > > IIUC, this is always true because you just return if keyid
> > > allocation fails.
> >
> > You're right. Will fix
> > --
> > Isaku Yamahata <isaku.yamahata@intel.com>
> >
>

