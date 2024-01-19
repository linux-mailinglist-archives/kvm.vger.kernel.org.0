Return-Path: <kvm+bounces-6464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF84832482
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 07:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C1FA1C23657
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 06:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64925256;
	Fri, 19 Jan 2024 06:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/FiRT+/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4EB10E4
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 06:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705644538; cv=none; b=XAG4bIT6SQ1O4/GYwxMkYQ+06x1mCRPZ8IiUFuyQ4fuA62DE6LmeBo+FYG25zDtl65VHludJHwSqkOq5OkLswfnDJYAMvUuM5TJiHfLApPoY0NKvzy4KbDtXa+pYKoyr9ArMpLTLhG8YJOSYpZsFLhVErsSgSjyCPH3bdxOmsok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705644538; c=relaxed/simple;
	bh=CDHc9WTwr3cH5AHRZJMKA7s/HAV8henIWnvASfAil2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvl1ZvxjKwPoBpahrgfOl8aflcx20NyQPK6PN8Zdrba1jc+xCLT+rli3vteHgpT6WNjmIgBchISAxXf2fkaizOyFcGtv1KqDdz56Zvv5TZR5X9ulqhRLjIozAzazmLXKktd3CcoOppEJOyshTIhG5piJ328JTqlISbncB3o/qpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/FiRT+/; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705644536; x=1737180536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CDHc9WTwr3cH5AHRZJMKA7s/HAV8henIWnvASfAil2Q=;
  b=C/FiRT+/XatbgMlVYBNjsnvSXgqzli/TBHjRMfbsCWxk6Ah7yTKqxZYQ
   ez3rSceNgIXjuPnI2wq8a8d1GaGFAWk3ZAFOczS/WcsEGKasPpD8J50Mj
   308yJq3K6UfxrUdzU9jYETIVTVrhzpo50ZlSf0LN4MhrUj4yWipdyoESy
   jy35pV/6yjAgfrJ7nT4s1OoJFBPy+wMrMeSd8koWFLJo6Oxx9+Hf2kxbj
   k4NqQmqTsauYIm/PZ+hiityoUQjc1XoGWtbG0VP/n6EIfIXHcM9fcliEd
   n31iVjnvE7bpYmiyEM2fYuvh+x1Ifg0fjo6ksQu+3PiKROoT3u3XD9NPt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="397837765"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="397837765"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 22:08:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="515884"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 22:08:53 -0800
Date: Fri, 19 Jan 2024 14:05:52 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: selftests: Add a requirement for disabling numa
 balancing
Message-ID: <ZaoRQOE0XsDSzjUw@linux.bj.intel.com>
References: <20240117064441.2633784-1-tao1.su@linux.intel.com>
 <ZafuSNu3ThHY8rfG@google.com>
 <Zai6hJgTRegDaSfx@linux.bj.intel.com>
 <Zalg6UGBrCe68P-i@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zalg6UGBrCe68P-i@google.com>

On Thu, Jan 18, 2024 at 09:33:29AM -0800, Sean Christopherson wrote:
> +David
> 
> On Thu, Jan 18, 2024, Tao Su wrote:
> > On Wed, Jan 17, 2024 at 07:12:08AM -0800, Sean Christopherson wrote:
> > 
> > [...]
> > 
> > > > diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > > > index 634c6bfcd572..f2c796111d83 100644
> > > > --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > > > +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > > > @@ -212,10 +212,21 @@ static void help(char *name)
> > > >  
> > > >  int main(int argc, char *argv[])
> > > >  {
> > > > +	FILE *f;
> > > >  	int opt;
> > > > +	int ret, numa_balancing;
> > > >  
> > > >  	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
> > > >  	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> > > > +	f = fopen("/proc/sys/kernel/numa_balancing", "r");
> > > > +	if (f) {
> > > > +		ret = fscanf(f, "%d", &numa_balancing);
> > > > +		TEST_ASSERT(ret == 1, "Error reading numa_balancing");
> > > > +		TEST_ASSERT(!numa_balancing, "please run "
> > > > +			    "'echo 0 > /proc/sys/kernel/numa_balancing'");
> > > 
> > > If we go this route, this should be a TEST_REQUIRE(), not a TEST_ASSERT().  The
> > > test hasn't failed, rather it has detected an incompatible setup.
> > 
> > Yes, previously I wanted to print a more user-friendly prompt, but TEST_REQUIRE()
> > can’t customize the output…
> 
> __TEST_REQUIRE()

Got it.

> 
> > > Something isn't right though.  The test defaults to HugeTLB, and the invocation
> > > in the changelog doesn't override the backing source.  That suggests that NUMA
> > > auto-balancing is zapping HugeTLB VMAs, which AFAIK shouldn't happen, e.g. this
> > > code in task_numa_work() should cause such VMAs to be skipped:
> > > 
> > > 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
> > > 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
> > > 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
> > > 			continue;
> > > 		}
> > > 
> > > And the test already warns the user if they opt to use something other than
> > > HugeTLB.
> > > 
> > > 	if (!is_backing_src_hugetlb(backing_src)) {
> > > 		pr_info("This test will only work reliably with HugeTLB memory. "
> > > 			"It can work with THP, but that is best effort.\n");
> > > 	}
> > > 
> > > If the test is defaulting to something other than HugeTLB, then we should fix
> > > that in the test.  If the kernel is doing NUMA balancing on HugeTLB VMAs, then
> > > we should fix that in the kernel.
> > 
> > HugeTLB VMAs are not affected by NUMA auto-balancing through my observation, but
> > the backing sources of the test code and per-vCPU stacks are not Huge TLB, e.g.
> > __vm_create() invokes
> > 
> >         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> > 
> > So, some pages are possible to be migrated.
> 
> Ah, hmm.  Requiring NUMA balancing be disabled isn't going to fix the underlying
> issue, it's just guarding against one of the more likely culprits.  The best fix
> is likely to have the test precisely validate _only_ the test data pages.  E.g.
> if we double down on requiring HugeTLB, then the test should be able to assert
> that it has at least N hugepages when dirty logging is disabled, and at least M
> 4KiB pages when dirty logging is enabled.

I see, I will update the ASSERT conditions, thanks for your guidance.

Thanks,
Tao

