Return-Path: <kvm+bounces-12537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1978875E1
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945821C22F38
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1BF82D61;
	Fri, 22 Mar 2024 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m9ImPoKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894BB7F7C0;
	Fri, 22 Mar 2024 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711151046; cv=none; b=TRv7tLVi7FUlWF2eRy5uHBmebUqzd2itMkY1uPkiGStTZK2HzfrIpLuLYBdAtezpNngjIJ4bK1OkVOcsYMppEppovHYdirJRnqVyJ2xbwc9zHE5scIlNLL307JHpcGmQKTw1gY5aj2yTBxsxPki31LmEaxkRURrMOgXm7/TrQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711151046; c=relaxed/simple;
	bh=RpP+L4Uawo0+lz9nURllkpIA7cQGPMNGAeNQYy/CeWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyHZsWKbo7v47MkPsmzRW/qgu8+utKccWPZ+zi6hOx3vvIXoJec3EvIK9sVE7bHLilzNqLZtbEvluZ6HoESW17XTBltytAVl0HQvYtotUAiC+b7X9QkKe9r3ceoF9qwtk9Q6jGbabLQ+5YouBvM0V0GRSV2mGnxT4q9De5JE/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m9ImPoKr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711151045; x=1742687045;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RpP+L4Uawo0+lz9nURllkpIA7cQGPMNGAeNQYy/CeWs=;
  b=m9ImPoKr8r949e8wi2uydI70jupx2f313bkZfsKD/XbO6epYKnbK+XGF
   /BA1XfjLRml4mkp7FmAYNzk9m9hXWtVFA/ItV084w03ckqqW4aqV60WA9
   Uc9c32Feu+qw0Fd2Dzu56MC/AcHRAVhTwjw0jTd4+TfTRvqKPJuzVCn6v
   bYDoJxX1DQcVsIxRqXDkQuzMaoApbUB9CmLXk18bNyzafbo1v+RYQCi8Y
   yXuZr9+LOCeyi6AemkYNXujubdcyt/8F9E0hzXkPm5puOEXG5u71WbnR1
   ksMLAm1202FUcL0pROiwTCKbfuIl7yxGUxbxFXgxvOQIRV/rf66Ffdcov
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="17611568"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="17611568"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:44:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="19753519"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:44:04 -0700
Date: Fri, 22 Mar 2024 16:44:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240322234403.GH1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
 <20240322034641.cuxuxiejy5ovteid@yy-desk-7060>
 <20240322053215.kwuyj3xpljxk5wgh@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240322053215.kwuyj3xpljxk5wgh@yy-desk-7060>

On Fri, Mar 22, 2024 at 01:32:15PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Fri, Mar 22, 2024 at 11:46:41AM +0800, Yuan Yao wrote:
> > On Thu, Mar 21, 2024 at 07:17:09AM -0700, Isaku Yamahata wrote:
> > > On Wed, Mar 20, 2024 at 01:12:01PM +0800,
> > > Chao Gao <chao.gao@intel.com> wrote:
> ...
> > > > >+static int __tdx_td_init(struct kvm *kvm)
> > > > >+{
> > > > >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > >+	cpumask_var_t packages;
> > > > >+	unsigned long *tdcs_pa = NULL;
> > > > >+	unsigned long tdr_pa = 0;
> > > > >+	unsigned long va;
> > > > >+	int ret, i;
> > > > >+	u64 err;
> > > > >+
> > > > >+	ret = tdx_guest_keyid_alloc();
> > > > >+	if (ret < 0)
> > > > >+		return ret;
> > > > >+	kvm_tdx->hkid = ret;
> > > > >+
> > > > >+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > > >+	if (!va)
> > > > >+		goto free_hkid;
> > > > >+	tdr_pa = __pa(va);
> > > > >+
> > > > >+	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> > > > >+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > > > >+	if (!tdcs_pa)
> > > > >+		goto free_tdr;
> > > > >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > > > >+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > > >+		if (!va)
> > > > >+			goto free_tdcs;
> > > > >+		tdcs_pa[i] = __pa(va);
> > > > >+	}
> > > > >+
> > > > >+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> > > > >+		ret = -ENOMEM;
> > > > >+		goto free_tdcs;
> > > > >+	}
> > > > >+	cpus_read_lock();
> > > > >+	/*
> > > > >+	 * Need at least one CPU of the package to be online in order to
> > > > >+	 * program all packages for host key id.  Check it.
> > > > >+	 */
> > > > >+	for_each_present_cpu(i)
> > > > >+		cpumask_set_cpu(topology_physical_package_id(i), packages);
> > > > >+	for_each_online_cpu(i)
> > > > >+		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> > > > >+	if (!cpumask_empty(packages)) {
> > > > >+		ret = -EIO;
> > > > >+		/*
> > > > >+		 * Because it's hard for human operator to figure out the
> > > > >+		 * reason, warn it.
> > > > >+		 */
> > > > >+#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> > > > >+		pr_warn_ratelimited(MSG_ALLPKG);
> > > > >+		goto free_packages;
> > > > >+	}
> > > > >+
> > > > >+	/*
> > > > >+	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> > > > >+	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> > > > >+	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> > > > >+	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> > > > >+	 * caller to handle the contention.  This is because of time limitation
> > > > >+	 * usable inside the TDX module and OS/VMM knows better about process
> > > > >+	 * scheduling.
> > > > >+	 *
> > > > >+	 * APIs to acquire the lock of KOT:
> > > > >+	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> > > > >+	 * TDH.PHYMEM.CACHE.WB.
> > > > >+	 */
> > > > >+	mutex_lock(&tdx_lock);
> > > > >+	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> > > > >+	mutex_unlock(&tdx_lock);
> > > > >+	if (err == TDX_RND_NO_ENTROPY) {
> > > > >+		ret = -EAGAIN;
> > > > >+		goto free_packages;
> > > > >+	}
> > > > >+	if (WARN_ON_ONCE(err)) {
> > > > >+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> > > > >+		ret = -EIO;
> > > > >+		goto free_packages;
> > > > >+	}
> > > > >+	kvm_tdx->tdr_pa = tdr_pa;
> > > > >+
> > > > >+	for_each_online_cpu(i) {
> > > > >+		int pkg = topology_physical_package_id(i);
> > > > >+
> > > > >+		if (cpumask_test_and_set_cpu(pkg, packages))
> > > > >+			continue;
> > > > >+
> > > > >+		/*
> > > > >+		 * Program the memory controller in the package with an
> > > > >+		 * encryption key associated to a TDX private host key id
> > > > >+		 * assigned to this TDR.  Concurrent operations on same memory
> > > > >+		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> > > > >+		 * mutex.
> > > > >+		 */
> > > > >+		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> > > >
> > > > the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
> > > > create TDs, the same set of CPUs (the first online CPU of each package) will be
> > > > selected to configure the key because of the cpumask_test_and_set_cpu() above.
> > > > it means, we never have two CPUs in the same socket trying to program the key,
> > > > i.e., no concurrent calls.
> > >
> > > Makes sense. Will drop the lock.
> >
> > Not get the point, the variable "packages" on stack, and it's
> > possible that "i" is same for 2 threads which are trying to create td.
> > Anything I missed ?
> 
> Got the point after synced with chao.
> in case of using for_each_online_cpu() it's safe to remove the mutex_lock(&tdx_mng_key_config_lock[pkg]),
> since every thread will select only 1 cpu for each sockets in same order, and requests submited
> to same cpu by smp_call_on_cpu() are ordered on the target cpu. That means removing the lock works for
> using for_each_online_cpu() but does NOT work for randomly pick up a cpu per socket.
> 
> Maybe it's just my issue that doesn't realize what's going on here, but
> I think it still worth to give comment here for why it works/does not work.

It's deserves comment. Will add it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

