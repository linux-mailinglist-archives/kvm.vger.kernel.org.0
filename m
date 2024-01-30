Return-Path: <kvm+bounces-7433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCE5841D34
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29BCF1F25118
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5500256B98;
	Tue, 30 Jan 2024 08:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sq6EuKKo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA0D55E68
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 08:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602055; cv=none; b=J2Cu1+BAef+hAGycAYWHNMoLz32h8ML0R0XCozYWqxeIIHoadA2TFExvZIm9RSjQhYWAKn/Wo5W+IgZiKCcmqX5U2IQb4A7ALx63r/q0eSW4kos/fGt/pJP6tK17S4d89+jfl557Lu31u6WuSyL4q4SOUguR+RKFOmYDvmaSCrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602055; c=relaxed/simple;
	bh=f2pyzKUZrJjXxOwRN9oPjTXzg5AHYOXbxAml1AfL/G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyD+IVXh6/oKlPcq3CB8pjiMCw18gzaU2trDpWR0Z3G4pD5kdkGI89uc+oRFhKnT+azx0rKl5SF21aPjsbnT2CjtgRNglbl3tLfDwkLBd+SaV83a9PH8lQlBodYdWJQHVifQiqOphVdo1E+b8PxBd5vhFpurPqXUMQlH2lSWQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sq6EuKKo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706602054; x=1738138054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=f2pyzKUZrJjXxOwRN9oPjTXzg5AHYOXbxAml1AfL/G4=;
  b=Sq6EuKKo4PsohZjLLPwRI6wMqYON38VUg0U4intoZe/tlsg9AmR7Bfwy
   P7zw4n+hppfA2zOYJ/QFl85Aa6Gk4LKG83sMNx0ZtLCbaue5lzYbKUO1N
   oK4CNA24JJYEGRcNPWFlxPf5KT96IxHt7Ge7fcEAyk6wjrtKriqNauQ34
   cxW0NlRBr76bd/HzGVVLv6fKl90/nxhBb8IIuMUA6ral77ey1K/oylF+F
   QeTXQe8KKvhsQS0PPpuGkdRnatscdEnDp1hdaj4ME2Be1S/EYXazCQZHV
   83B3IOj4WUUce+IMmCIYRaGscdRjgPY4jb0iX4NRE62/MAU1UIe7oZ+7v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="9841351"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="9841351"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:07:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="878358465"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="878358465"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:07:30 -0800
Date: Tue, 30 Jan 2024 16:04:30 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix dirty_log_page_splitting_test as
 page migration
Message-ID: <ZbitjvfJANo404Ah@linux.bj.intel.com>
References: <20240122064053.2825097-1-tao1.su@linux.intel.com>
 <ZbQYlYz5aCPFal5f@google.com>
 <Zbdf+GSYU+5EGfBL@linux.bj.intel.com>
 <ZbfhH1ubtrql2Mt5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbfhH1ubtrql2Mt5@google.com>

On Mon, Jan 29, 2024 at 09:32:15AM -0800, Sean Christopherson wrote:
> On Mon, Jan 29, 2024, Tao Su wrote:
> > On Fri, Jan 26, 2024 at 12:39:49PM -0800, Sean Christopherson wrote:
> > > +David
> > > 
> > 
> > [ ... ]
> > 
> > > >  
> > > >  	/*
> > > > @@ -192,7 +193,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
> > > >  	 * memory again, the page counts should be the same as they were
> > > >  	 * right after initial population of memory.
> > > >  	 */
> > > > -	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
> > > >  	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
> > > >  	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
> > > 
> > > Isn't it possible that something other than guest data could be mapped by THP
> > > hugepage, and that that hugepage could get shattered between the initial run and
> > > the re-population run?
> > 
> > Good catch, I found that if the backing source is specified as THP, all hugepages
> > can also be migrated.
> 
> The backing source for the test slots?  Using THP is inherently fragile for this
> test, and IMO is firmly out of scope.

Yes, the user can optionally specify the backing source of test slots, e.g.,

    ./x86_64/dirty_log_page_splitting_test -s anonymous_thp

but we already have a hint: “This test will only work reliably with HugeTLB memory.
It can work with THP, but that is best effort.”

> I was talking about any memslots allocated by the core library, e.g. for the
> test's code and page tables.  Those should be forced to be MADV_NOHUGEPAGE,
> though if the allocations are smaller than 2MiB (I forget how much we allocate),
> that would suffice for now.

The "other" memslot is more than 2MiB, and in this test, the memory that the guest
can touch in "other" memslot also exceeds 2MiB. It seems that the existing code has
forced the memory of VM_MEM_SRC_ANONYMOUS to MADV_NOHUGEPAGE, e.g.,
in vm_userspace_mem_region_add():

    ret = madvise(region->host_mem, npages * vm->page_size,
		          src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);

> 
> If we ensure the other memslots can only use 4KiB, then it's only the *.pages_4k
> checks that are problematic.  Then the hugepage counts can be precise.

Yes, I see.

> 
> Something like this is what I'm thinking (again, assuming the "other" memslot
> created by the library can't use THP).

The below code looks good to me and test PASS in our machine.

Thanks,
Tao

> 
> ---
>  .../x86_64/dirty_log_page_splitting_test.c    | 21 +++++++++++--------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> index 634c6bfcd572..4864cf3fae57 100644
> --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> @@ -92,7 +92,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	uint64_t host_num_pages;
>  	uint64_t pages_per_slot;
>  	int i;
> -	uint64_t total_4k_pages;
>  	struct kvm_page_stats stats_populated;
>  	struct kvm_page_stats stats_dirty_logging_enabled;
>  	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
> @@ -107,6 +106,9 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
>  	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>  	pages_per_slot = host_num_pages / SLOTS;
> +	TEST_ASSERT_EQ(host_num_pages, pages_per_slot * SLOTS);
> +	TEST_ASSERT(!(host_num_pages % 512),
> +		    "Number of pages, '%lu' not a multiple of 2MiB", host_num_pages);
>  
>  	bitmaps = memstress_alloc_bitmaps(SLOTS, pages_per_slot);
>  
> @@ -165,10 +167,8 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	memstress_free_bitmaps(bitmaps, SLOTS);
>  	memstress_destroy_vm(vm);
>  
> -	/* Make assertions about the page counts. */
> -	total_4k_pages = stats_populated.pages_4k;
> -	total_4k_pages += stats_populated.pages_2m * 512;
> -	total_4k_pages += stats_populated.pages_1g * 512 * 512;
> +	TEST_ASSERT_EQ((stats_populated.pages_2m * 512 +
> +			stats_populated.pages_1g * 512 * 512), host_num_pages);
>  
>  	/*
>  	 * Check that all huge pages were split. Since large pages can only
> @@ -180,19 +180,22 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	 */
>  	if (dirty_log_manual_caps) {
>  		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
> -		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
> +		TEST_ASSERT(stats_clear_pass[0].pages_4k >= host_num_pages,
> +			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
> +			    host_num_pages, stats_clear_pass[0].pages_4k);
>  		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
>  	} else {
>  		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
> -		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
> +		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k >= host_num_pages,
> +			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
> +			    host_num_pages, stats_clear_pass[0].pages_4k);
>  	}
>  
>  	/*
>  	 * Once dirty logging is disabled and the vCPUs have touched all their
> -	 * memory again, the page counts should be the same as they were
> +	 * memory again, the hugepage counts should be the same as they were
>  	 * right after initial population of memory.
>  	 */
> -	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
>  	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
>  	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
>  }
> 
> base-commit: 0762cdfe8ee16e4035b0ad27418686ef0452932f
> -- 
> 

