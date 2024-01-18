Return-Path: <kvm+bounces-6417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0D783127D
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 06:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 582F21F22E08
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 05:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D78A8F60;
	Thu, 18 Jan 2024 05:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gPEZ+Vsw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E588483
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 05:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705556814; cv=none; b=LcMyDuYuk43qyIBwtDJzP/OI2lgMeZEEFeUrDt8yIxaeZkFDhinnCo2rdLhfhUJ1/ALh7x4+jLpGq5cLX6u1ryIqIXeYy+5YidaryBEuftwaOeLVC57NumRRe/lS8nZgx6kipfIimtVjxmMNYcL111Vyx/XGB7yizOsFcb4qnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705556814; c=relaxed/simple;
	bh=uvXlub0r9Oz9z+LH2XHlKK4IRBaGasEBXw91t+mcZlk=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To; b=anFDpecSSs7VtvRrObcv6NArIcNVvctxmQ5JmvsIKriWWWBHEz1ZSKg5nU+r1pqU/VOS/g2YR6AyhSJyDuPy67jtoSyDFmuIl0CHCUI2Vxpps6dJ3NULMh88m3SZIDyOKaTgYq4k4+A5i3y2avHTX5QkOlH9vn6ibY9l6Z6gKcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gPEZ+Vsw; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705556813; x=1737092813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uvXlub0r9Oz9z+LH2XHlKK4IRBaGasEBXw91t+mcZlk=;
  b=gPEZ+Vsws2EtsdZwDPxI9SEMccyGTcA0yTf8gLK2T2m+/iyq6tfdlxXc
   OLVyVQWuCeZOqoIwaI34Kve4czSS0WOPRxO8lR4tLH+oPD+L3rEJpyczT
   NPedbEVKcpHlOJ9kWtTZAVIZ1L8RfdPhZJOzEzBidyYE2NWf+rze5nbLY
   RVj9NPNoAXvJ/OlKrCpyYcOM+L0lw2y+8ealrTDb9v8yNMeMjiF4OYeCs
   DJ+8PLT22cX9HimoMzB8PeOr2TjzR04aLxX3PDdM/oazccTIJOzK0C0bz
   5RPTIqFPNqcriwO6Wcxxo8UhQ6VttYXytLfeCpcogvBOCg44I4V1nj9ut
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390804492"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390804492"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 21:46:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="928020510"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="928020510"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 21:46:36 -0800
Date: Thu, 18 Jan 2024 13:43:32 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
	yi1.lai@intel.com
Subject: Re: [PATCH] KVM: selftests: Add a requirement for disabling numa
 balancing
Message-ID: <Zai6hJgTRegDaSfx@linux.bj.intel.com>
References: <20240117064441.2633784-1-tao1.su@linux.intel.com>
 <ZafuSNu3ThHY8rfG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZafuSNu3ThHY8rfG@google.com>

On Wed, Jan 17, 2024 at 07:12:08AM -0800, Sean Christopherson wrote:

[...]

> > diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > index 634c6bfcd572..f2c796111d83 100644
> > --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> > @@ -212,10 +212,21 @@ static void help(char *name)
> >  
> >  int main(int argc, char *argv[])
> >  {
> > +	FILE *f;
> >  	int opt;
> > +	int ret, numa_balancing;
> >  
> >  	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
> >  	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> > +	f = fopen("/proc/sys/kernel/numa_balancing", "r");
> > +	if (f) {
> > +		ret = fscanf(f, "%d", &numa_balancing);
> > +		TEST_ASSERT(ret == 1, "Error reading numa_balancing");
> > +		TEST_ASSERT(!numa_balancing, "please run "
> > +			    "'echo 0 > /proc/sys/kernel/numa_balancing'");
> 
> If we go this route, this should be a TEST_REQUIRE(), not a TEST_ASSERT().  The
> test hasn't failed, rather it has detected an incompatible setup.

Yes, previously I wanted to print a more user-friendly prompt, but TEST_REQUIRE()
can’t customize the output…

> 
> Something isn't right though.  The test defaults to HugeTLB, and the invocation
> in the changelog doesn't override the backing source.  That suggests that NUMA
> auto-balancing is zapping HugeTLB VMAs, which AFAIK shouldn't happen, e.g. this
> code in task_numa_work() should cause such VMAs to be skipped:
> 
> 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
> 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
> 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
> 			continue;
> 		}
> 
> And the test already warns the user if they opt to use something other than
> HugeTLB.
> 
> 	if (!is_backing_src_hugetlb(backing_src)) {
> 		pr_info("This test will only work reliably with HugeTLB memory. "
> 			"It can work with THP, but that is best effort.\n");
> 	}
> 
> If the test is defaulting to something other than HugeTLB, then we should fix
> that in the test.  If the kernel is doing NUMA balancing on HugeTLB VMAs, then
> we should fix that in the kernel.

HugeTLB VMAs are not affected by NUMA auto-balancing through my observation, but
the backing sources of the test code and per-vCPU stacks are not Huge TLB, e.g.
__vm_create() invokes

        vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);

So, some pages are possible to be migrated.

In dirty_log_page_splitting_test, if sleep 3s before enabling dirty logging:

        --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
        +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
        @@ -124,6 +124,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
                memstress_start_vcpu_threads(VCPUS, vcpu_worker);

                run_vcpu_iteration(vm);
        +       sleep(3);
                get_page_stats(vm, &stats_populated, "populating memory");

                /* Enable dirty logging */

I got these logs:

        # ./x86_64/dirty_log_page_splitting_test
        Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
        __vm_create: mode='PA-bits:ANY, VA-bits:48,  4K pages' pages='2710'
        Guest physical address width detected: 52
        guest physical test memory: [0xfffff7fe00000, 0xfffffffe00000)
        Added VCPU 0 with test mem gpa [fffff7fe00000, fffffffe00000)
        Added VCPU 1 with test mem gpa [fffff7fe00000, fffffffe00000)

        Page stats after populating memory: 4K: 0 2M: 1024 1G: 0 huge: 1024

        Page stats after enabling dirty logging: 4K: 524288 2M: 0 1G: 0 huge: 0

        Page stats after dirtying memory: 4K: 525334 2M: 0 1G: 0 huge: 0

        Page stats after dirtying memory: 4K: 525334 2M: 0 1G: 0 huge: 0

        Page stats after disabling dirty logging: 4K: 1046 2M: 0 1G: 0 huge: 0

        Page stats after repopulating memory: 4K: 1046 2M: 1024 1G: 0 huge: 1024
        ==== Test Assertion Failure ====
          x86_64/dirty_log_page_splitting_test.c:196: stats_populated.pages_4k == stats_repopulated.pages_4k
          pid=2660413 tid=2660413 errno=0 - Success
             1  0x0000000000402d4b: run_test at dirty_log_page_splitting_test.c:196 (discriminator 1)
             2  0x0000000000403724: for_each_guest_mode at guest_modes.c:100
             3  0x00000000004024ef: main at dirty_log_page_splitting_test.c:246
             4  0x00007fd72c229d8f: ?? ??:0
             5  0x00007fd72c229e3f: ?? ??:0
             6  0x00000000004025b4: _start at ??:?
          0 != 0x416 (stats_populated.pages_4k != stats_repopulated.pages_4k)

Thanks,
Tao

