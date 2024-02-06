Return-Path: <kvm+bounces-8074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C225084ADD9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 06:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00EFC1C22897
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 05:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EA97A727;
	Tue,  6 Feb 2024 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMy8qoU1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA41C77F2A;
	Tue,  6 Feb 2024 05:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707196484; cv=none; b=TmEmEjj4crXrMyGByBJfh2CQXEK6FPGlZysJ2+NvqAnwdYC2NBzrc3g0ncxLS0lCmBPAQ3HrpdOMXuumOWwb0NybFWRTs6ON+0x90CEhuvVos/1gNeoP0oGDlLimULsZsUuEWDyQIiiO8N2DZxAgTXjfLJIoTke3JifME9IAonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707196484; c=relaxed/simple;
	bh=vSJhso2JZf75lQS3y3aRewHIckrS3lQXcRZxC1OiZpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2tnfFg0XSw4LgvyELlkxP7JhIjGTMhNZG6gYkBHURB4t9gitV6WAGECF9xCUxgLzXbeDV1cbVPYP0oR1oK3MsM3i2fwlCVlVN1MDaUniAWWnfGHJvjHeffYUS14M6CZH2Y3krGe2QmGkgh8gyjMWKXVs4gHH7u1PT0uxNSXMuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMy8qoU1; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707196482; x=1738732482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vSJhso2JZf75lQS3y3aRewHIckrS3lQXcRZxC1OiZpM=;
  b=gMy8qoU1qxaky/Vi9+FqHbBaFViUuJxQi/JuLATurPxIzCV+r0wbZ717
   m7Ql3ofzizqRyXwVRTPDnblAuQNjvGikiLjEZjkIPl+9Bp6gL4GnbAa8k
   EMjIBGBTd9xfP5ZvnIpH31SsDO/VC8914QCWzls30jzD2agb2LOOX+URg
   3Hu/8gd5Cbm//EuiGPhFJkJIPHGhQ4Cn0xmvtjYvi8o53rPTEitC3cVz/
   XIFP5YHvhAl9wTBJToBh81BR0YTyQvaqHcjmec1M6j1F/LMRNrfH6djBz
   BvGLZ5uKiyc35WWLV/D6w/IB6P6FfCC4HrGcmnTBXr9IfJn2bD2XBdKOT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="555200"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="555200"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 21:14:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="5518282"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 21:14:22 -0800
Date: Tue, 6 Feb 2024 13:11:24 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH] KVM: selftests: Don't assert on exact number of 4KiB in
 dirty log split test
Message-ID: <ZcG/fB5me7wWUNQL@linux.bj.intel.com>
References: <20240131222728.4100079-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131222728.4100079-1-seanjc@google.com>

On Wed, Jan 31, 2024 at 02:27:28PM -0800, Sean Christopherson wrote:
> Drop dirty_log_page_splitting_test's assertion that the number of 4KiB
> pages remains the same across dirty logging being enabled and disabled, as
> the test doesn't guarantee that mappings outside of the memslots being
> dirty logged are stable, e.g. KVM's mappings for code and pages in
> memslot0 can be zapped by things like NUMA balancing.
> 
> To preserve the spirit of the check, assert that (a) the number of 4KiB
> pages after splitting is _at least_ the number of 4KiB pages across all
> memslots under test, and (b) the number of hugepages before splitting adds
> up to the number of pages across all memslots under test.  (b) is a little
> tenuous as it relies on memslot0 being incompatible with transparent
> hugepages, but that holds true for now as selftests explicitly madvise()
> MADV_NOHUGEPAGE for memslot0 (__vm_create() unconditionally specifies the
> backing type as VM_MEM_SRC_ANONYMOUS).
> 
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Reported-by: Tao Su <tao1.su@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
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

Here should print stats_dirty_logging_enabled.pages_4k, not stats_clear_pass[0].pages_4k.

Everything else looks great.

Reviewed-by: Tao Su <tao1.su@linux.intel.com>

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
> base-commit: f0f3b810edda57f317d79f452056786257089667
> -- 
> 2.43.0.429.g432eaa2c6b-goog
> 

