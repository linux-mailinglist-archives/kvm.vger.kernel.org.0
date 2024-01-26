Return-Path: <kvm+bounces-7208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2045B83E371
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF94BB21457
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 20:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29019241F8;
	Fri, 26 Jan 2024 20:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mh8DV9+m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049622630
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706301593; cv=none; b=Zv3IihYGbBvfa6Ca9wDcFnqkcbzEtMnvMKFE1cFnRi9H1cdhnRdyZWIw6LCjN+M3Mdym2f/FQJS/0xnjmqGItn2VtPJaBLACHn71YYK7GeHr1KJOz3zb77+AyQP6WfuVBrrKHrsFXT88yreXidmLs2EooY+rYaafSjUPtDuiawA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706301593; c=relaxed/simple;
	bh=AO6L3IB+/tB5oDWWSXxze00gnN5V1ePdwi3VLyZrN2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G2PffbRjsGrqVjCfbly2RIVmUtQpt3Ij0uMs4OqO8mWfkHOcDbs7aqcS2N6gZsyYTMJIkykGRuSMAmOEJk5ufWOC8oZFI3epLYUUjiNJ5s31lN+Ch+lEpJYaP8YWGmfNYpj1oYulihsPMDKoy4fGtFMEGr5dOiPwsq/Is39F/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mh8DV9+m; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc3645c083aso1331370276.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 12:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706301591; x=1706906391; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GqMyCLqNKyHqL0nQVHAmoPNusJPV7BEDYWUHd+DjFH4=;
        b=Mh8DV9+mquJYbGK+y3Xs4nyJ0ruZuhe9jXcyIWyGhFCE283Oc1/sXPcIm/lSArNNaI
         ABlsax1S1ezoODut6v/4Bi58bvIvGuDPLuolEEn+RaST7RpjSJ6ElglXDpF+/j5vQs/k
         k5ssxkEjuYGoCSTadijbi+mr9FxjuvSDqiVrEbKHMB4BMuGYn++PJjLaITjxCoGacK2a
         44hR1xGrWTCoZHIJtYnXCNDOdaEVf0YKK3ZZYgkosBRUuD8cG/ECONixHhSunaEmIbHF
         RxqIQOU1PDRYG9Dq2ASNZPKRWKxkm1TkWonPTfNH8kDu43CCTWUxaC2akXtFUAuY0c/v
         QElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706301591; x=1706906391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GqMyCLqNKyHqL0nQVHAmoPNusJPV7BEDYWUHd+DjFH4=;
        b=TEvo7VM2HUVIUOVfA+Ec5HbM9PKOl1C0H1H4X7PoB0NNcsANXAT17AtSDguSfHHu4Q
         xM4An6zk3fTuNMpL/VE0kbw3sy8LSDtV4CgoNDqBu1O6jVw998XBaPkOtx3YWMUk0P2k
         w+wwthYg6xjYPpa/e2UcItT8f8JWeVIahVjDuXS3Ff4ke/HTDb5FgWc23z2r8vaHbOrz
         JEfKbN7zSbzzGPrcbrmLzqIdi26KWDZ1YqiSi6UXgVOZEOxN7Wl+bimtp9HGYHTIJ93C
         UNs7p+PnTp+dHVyZ7ZEmuJ6TNondPFj2NaU92yFcYgt9Li/csOtdegWSyU5S5OCXgri+
         5+wQ==
X-Gm-Message-State: AOJu0YyzV/yRJHT9eneQOq/TeX7mJZGZto/HDMz+iLXOpPSYbUnJny66
	ti26wmmeioWgahRDqADeFKbofYiJMlOAUFU6QZ2xqgMkmMM7wLEqOwyFOxT55KT2fjOmpHN3ZqC
	3gQ==
X-Google-Smtp-Source: AGHT+IFLughycvtwJ2vdv0nbGCnIP0rNi56Mz1WfgzS6Yu6YYDcAAkGBrxpOpe72tMV1YrUp9KDM1z1A74g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:13cd:b0:dc6:4f35:5bb9 with SMTP id
 y13-20020a05690213cd00b00dc64f355bb9mr211214ybu.2.1706301590842; Fri, 26 Jan
 2024 12:39:50 -0800 (PST)
Date: Fri, 26 Jan 2024 12:39:49 -0800
In-Reply-To: <20240122064053.2825097-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122064053.2825097-1-tao1.su@linux.intel.com>
Message-ID: <ZbQYlYz5aCPFal5f@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix dirty_log_page_splitting_test as
 page migration
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

+David

On Mon, Jan 22, 2024, Tao Su wrote:
> In dirty_log_page_splitting_test, vm_get_stat(vm, "pages_4k") has
> probability of gradually reducing before enabling dirty logging. The
> reason is the backing sources of some pages (test code and per-vCPU
> stacks) are not HugeTLB, leading to the possibility of being migrated.
> 
> Requiring NUMA balancing be disabled isn't going to fix the underlying
> issue, it's just guarding against one of the more likely culprits.
> Therefore, precisely validate only the test data pages, i.e. ensure
> no huge pages left and the number of all 4k pages should be at least
> equal to the split pages after splitting.
> 
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
> Changelog:
> 
> v2:
>   - Drop the requirement of NUMA balancing
>   - Change the ASSERT conditions
> 
> v1:
>   https://lore.kernel.org/all/20240117064441.2633784-1-tao1.su@linux.intel.com/
> ---
>  .../kvm/x86_64/dirty_log_page_splitting_test.c     | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> index 634c6bfcd572..63f9cd2b1e31 100644
> --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> @@ -92,7 +92,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	uint64_t host_num_pages;
>  	uint64_t pages_per_slot;
>  	int i;
> -	uint64_t total_4k_pages;
> +	uint64_t split_4k_pages;
>  	struct kvm_page_stats stats_populated;
>  	struct kvm_page_stats stats_dirty_logging_enabled;
>  	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
> @@ -166,9 +166,8 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	memstress_destroy_vm(vm);
>  
>  	/* Make assertions about the page counts. */
> -	total_4k_pages = stats_populated.pages_4k;
> -	total_4k_pages += stats_populated.pages_2m * 512;
> -	total_4k_pages += stats_populated.pages_1g * 512 * 512;
> +	split_4k_pages = stats_populated.pages_2m * 512;
> +	split_4k_pages += stats_populated.pages_1g * 512 * 512;
>  
>  	/*
>  	 * Check that all huge pages were split. Since large pages can only
> @@ -180,11 +179,13 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	 */
>  	if (dirty_log_manual_caps) {
>  		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
> -		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
> +		TEST_ASSERT(stats_clear_pass[0].pages_4k >= split_4k_pages,
> +			    "The number of 4k pages should be at least equal to the split pages");
>  		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
>  	} else {
>  		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
> -		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
> +		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k >= split_4k_pages,
> +			    "The number of 4k pages should be at least equal to the split pages");
>  	}
>  
>  	/*
> @@ -192,7 +193,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
>  	 * memory again, the page counts should be the same as they were
>  	 * right after initial population of memory.
>  	 */
> -	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
>  	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
>  	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);

Isn't it possible that something other than guest data could be mapped by THP
hugepage, and that that hugepage could get shattered between the initial run and
the re-population run?

The test knows (or at least, darn well should know) exactly how much memory is
being dirty logged.  Rather that rely *only* on before/after heuristics, can't
we assert that the _delta_, i.e. the number of hugepages that are split, and then
the number of hugepages that are reconstituted, is greater than or equal to the
size of the memslots being dirty logged?

>  }
> 
> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> -- 
> 2.34.1
> 

