Return-Path: <kvm+bounces-34015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FAD9F5AF3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E03EB1622EF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF90156C72;
	Wed, 18 Dec 2024 00:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YYWOJ1sz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1DB3597E
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480164; cv=none; b=FKhbWXW6spOkaNG7nxmgtY8+2En3kLVPkpXZKuX2f5yDRqLrW4mZrEnMmveCq4CW99c33FTnglnduQVOUbL25707luSjNtPN/+0HZ75RAA0OG5Zy4ogkj2spaJEkNTgZ6MlPB2b9c2h0R1722oYM/Kfk8DAFEDjvCcGakofazeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480164; c=relaxed/simple;
	bh=S3SCLWoXQwHZo2kSu1wrWKjjz5SnbUGBclaXC5Sxf4A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8jW5NQZ+dmQ5fVJ0ZJoxl+UrBovDSZm/i0LgXSHTU4NZqG20nCZ00HWyxD886lr5RXz6HV24upybviaVYmKbFOw+ZjlAruSuaVln6uyOS0HetbAeu84VyzKvuMiCP6szO1yK5DU7YeIAvbIZJAngGluER1hQYQhsy4mkRL4RT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YYWOJ1sz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CyL4nRJhmzW+z3afA3hRy1CQI6jPqM1//VoxCiIxgC8=;
	b=YYWOJ1szW8HhvzCP9oWkG3JegtRvWSp+eng+hEL2xyHB9xPjHz4EqC62M8MaOaKbWytwHc
	FCU1BN7o9AGH2NGC1/nvSStQD5PHErQI58sEm0oDz57JHDj/pmD9LzS7P0nUaPMmru5EF0
	3jWBCiDKJM/+WvKfbsljxhynOjEmA8Q=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613--6CFvE9sP-eIamoknqH1pA-1; Tue, 17 Dec 2024 19:02:40 -0500
X-MC-Unique: -6CFvE9sP-eIamoknqH1pA-1
X-Mimecast-MFC-AGG-ID: -6CFvE9sP-eIamoknqH1pA
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-844d2dc4839so23197939f.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480159; x=1735084959;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CyL4nRJhmzW+z3afA3hRy1CQI6jPqM1//VoxCiIxgC8=;
        b=ITipaGVLKRWpuv6fhzvJPkD2P0OEYWoes7VQB1OZp0EiFWWRrMDueV+lXN47IhHf+y
         M002a7V/UiVH8gYx8KCgJihQ4ckfH8EGFlT1rnqId+cYos9l2WquwWFLIXw9Spnka77S
         uf41YIOPd3K9JSDdQOtrGun6Xa1whiY3psozAtICB7UjA7LvGMMhI/sTOD7mQHvBCpAZ
         R7gwRolox3AjeR5ehXFt59y6N6fH7H6eLzDMgOzx7SkVWPGB4yY3I59w//7D6gqWzOFR
         BF0MRbSljIBxJOPoqqVCCzn9I5UN3PdS48/R7jy38w5su1dKH5nfWdqdRwKYwlIB49/D
         28WQ==
X-Gm-Message-State: AOJu0YxZ5Lr/pYiNYikPfc+1lV+y0myElfs4qHmmD0Ig4TuL6a45I7Ws
	GrbLnkFjCXr0jWUTzwGioQuYcnks3QhrTAOylAqNsJEB7j/kppzckpTAj4EXXclD1IuiZ66o85F
	6p2U74cKo9ufExXr3KNQY171Wh8fZSedvRdbBX5XCjQyw+PaO2A==
X-Gm-Gg: ASbGncsRSeGOU87cwzb7sWic6bnRt0+6oQcwFBdg4DEI4mPMO3B73T3zIOJ2ZXe+v+d
	1xZKuxkaRSLODJztP1rKDFc32n/eQPMmw9pPzldDMqmGgB7QtP+g3+OOeEywvVQrmPwRAvtSlDm
	LzFulshQlyRqt6fDel8h1caXoCO36B3ND9tbDCeDsz/hjxQNwU0cFw2QiQqUXrMQsof6b4e/ykC
	AbNkDwdtniP1jJhDCU7wVcGpmhnCP1TPZQi1FeqPaWUYyXsNvLGc86S
X-Received: by 2002:a05:6602:148e:b0:835:3dfc:5ba5 with SMTP id ca18e2360f4ac-84747e25760mr539017239f.5.1734480159440;
        Tue, 17 Dec 2024 16:02:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHoVSkieDp0vwiRRlgTfjS5Wjj+EBL8loorLJymBphNkRjpa+9PGo2TP0vvP4veR2BJWz/nfw==
X-Received: by 2002:a05:6602:148e:b0:835:3dfc:5ba5 with SMTP id ca18e2360f4ac-84747e25760mr539014439f.5.1734480159067;
        Tue, 17 Dec 2024 16:02:39 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a2ce7sm1967631173.96.2024.12.17.16.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:02:38 -0800 (PST)
Message-ID: <fb179759bdc224431f6b031eaa9747c1897d296b.camel@redhat.com>
Subject: Re: [PATCH 14/20] KVM: selftests: Collect *all* dirty entries in
 each dirty_log_test iteration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:02:38 -0500
In-Reply-To: <20241214010721.2356923-15-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-15-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Collect all dirty entries during each iteration of dirty_log_test by
> doing a final collection after the vCPU has been stopped.  To deal with
> KVM's destructive approach to getting the dirty bitmaps, use a second
> bitmap for the post-stop collection.
> 
> Collecting all entries that were dirtied during an iteration simplifies
> the verification logic *and* improves test coverage.
> 
>   - If a page is written during iteration X, but not seen as dirty until
>     X+1, the test can get a false pass if the page is also written during
>     X+1.
> 
>   - If a dirty page used a stale value from a previous iteration, the test
>     would grant a false pass.
> 
>   - If a missed dirty log occurs in the last iteration, the test would fail
>     to detect the issue.
> 
> E.g. modifying mark_page_dirty_in_slot() to dirty an unwritten gfn:
> 
> 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> 		unsigned long rel_gfn = gfn - memslot->base_gfn;
> 		u32 slot = (memslot->as_id << 16) | memslot->id;
> 
> 		if (!vcpu->extra_dirty &&
> 		    gfn_to_memslot(kvm, gfn + 1) == memslot) {
> 			vcpu->extra_dirty = true;
> 			mark_page_dirty_in_slot(kvm, memslot, gfn + 1);
> 		}
> 		if (kvm->dirty_ring_size && vcpu)
> 			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
> 		else if (memslot->dirty_bitmap)
> 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> 	}
> 
> isn't detected with the current approach, even with an interval of 1ms
> (when running nested in a VM; bare metal would be even *less* likely to
> detect the bug due to the vCPU being able to dirty more memory).  Whereas
> collecting all dirty entries consistently detects failures with an
> interval of 700ms or more (the longer interval means a higher probability
> of an actual write to the prematurely-dirtied page).

While this patch might improve coverage for this particular case,
I think that this patch will make the test to be much more deterministic,
and thus have less chance of catching various races in the kernel that can happen.

In fact in my option I prefer moving this test in
other direction by verifying dirty ring while the *vCPU runs* as well,
in other words, not stopping the vCPU at all unless its dirty ring is full.

Best regards,
	Maxim Levitsky


> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 149 ++++++-------------
>  1 file changed, 45 insertions(+), 104 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index fe8cc7f77e22..3a4e411353d7 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -134,7 +134,6 @@ static uint64_t host_num_pages;
>  /* For statistics only */
>  static uint64_t host_dirty_count;
>  static uint64_t host_clear_count;
> -static uint64_t host_track_next_count;
>  
>  /* Whether dirty ring reset is requested, or finished */
>  static sem_t sem_vcpu_stop;
> @@ -422,15 +421,6 @@ struct log_mode {
>  	},
>  };
>  
> -/*
> - * We use this bitmap to track some pages that should have its dirty
> - * bit set in the _next_ iteration.  For example, if we detected the
> - * page value changed to current iteration but at the same time the
> - * page bit is cleared in the latest bitmap, then the system must
> - * report that write in the next get dirty log call.
> - */
> -static unsigned long *host_bmap_track;
> -
>  static void log_modes_dump(void)
>  {
>  	int i;
> @@ -491,79 +481,52 @@ static void *vcpu_worker(void *data)
>  	return NULL;
>  }
>  
> -static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
> +static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
>  {
>  	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
>  	uint64_t step = vm_num_host_pages(mode, 1);
> -	uint64_t min_iter = 0;
>  
>  	for (page = 0; page < host_num_pages; page += step) {
>  		uint64_t val = *(uint64_t *)(host_test_mem + page * host_page_size);
> +		bool bmap0_dirty = __test_and_clear_bit_le(page, bmap[0]);
>  
> -		/* If this is a special page that we were tracking... */
> -		if (__test_and_clear_bit_le(page, host_bmap_track)) {
> -			host_track_next_count++;
> -			TEST_ASSERT(test_bit_le(page, bmap),
> -				    "Page %"PRIu64" should have its dirty bit "
> -				    "set in this iteration but it is missing",
> -				    page);
> -		}
> -
> -		if (__test_and_clear_bit_le(page, bmap)) {
> +		/*
> +		 * Ensure both bitmaps are cleared, as a page can be written
> +		 * multiple times per iteration, i.e. can show up in both
> +		 * bitmaps, and the dirty ring is additive, i.e. doesn't purge
> +		 * bitmap entries from previous collections.
> +		 */
> +		if (__test_and_clear_bit_le(page, bmap[1]) || bmap0_dirty) {
>  			nr_dirty_pages++;
>  
>  			/*
> -			 * If the bit is set, the value written onto
> -			 * the corresponding page should be either the
> -			 * previous iteration number or the current one.
> +			 * If the page is dirty, the value written to memory
> +			 * should be the current iteration number.
>  			 */
> -			if (val == iteration || val == iteration - 1)
> +			if (val == iteration)
>  				continue;
>  
>  			if (host_log_mode == LOG_MODE_DIRTY_RING) {
> -				if (val == iteration - 2 && min_iter <= iteration - 2) {
> -					/*
> -					 * Short answer: this case is special
> -					 * only for dirty ring test where the
> -					 * page is the last page before a kvm
> -					 * dirty ring full in iteration N-2.
> -					 *
> -					 * Long answer: Assuming ring size R,
> -					 * one possible condition is:
> -					 *
> -					 *      main thr       vcpu thr
> -					 *      --------       --------
> -					 *    iter=1
> -					 *                   write 1 to page 0~(R-1)
> -					 *                   full, vmexit
> -					 *    collect 0~(R-1)
> -					 *    kick vcpu
> -					 *                   write 1 to (R-1)~(2R-2)
> -					 *                   full, vmexit
> -					 *    iter=2
> -					 *    collect (R-1)~(2R-2)
> -					 *    kick vcpu
> -					 *                   write 1 to (2R-2)
> -					 *                   (NOTE!!! "1" cached in cpu reg)
> -					 *                   write 2 to (2R-1)~(3R-3)
> -					 *                   full, vmexit
> -					 *    iter=3
> -					 *    collect (2R-2)~(3R-3)
> -					 *    (here if we read value on page
> -					 *     "2R-2" is 1, while iter=3!!!)
> -					 *
> -					 * This however can only happen once per iteration.
> -					 */
> -					min_iter = iteration - 1;
> +				/*
> +				 * The last page in the ring from this iteration
> +				 * or the previous can be written with the value
> +				 * from the previous iteration (relative to the
> +				 * last page's iteration), as the value to be
> +				 * written may be cached in a CPU register.
> +				 */
> +				if (page == dirty_ring_last_page ||
> +				    page == dirty_ring_prev_iteration_last_page)
>  					continue;
> -				} else if (page == dirty_ring_last_page ||
> -					   page == dirty_ring_prev_iteration_last_page) {
> -					/*
> -					 * Please refer to comments in
> -					 * dirty_ring_last_page.
> -					 */
> -					continue;
> -				}
> +			} else if (!val && iteration == 1 && bmap0_dirty) {
> +				/*
> +				 * When testing get+clear, the dirty bitmap
> +				 * starts with all bits set, and so the first
> +				 * iteration can observe a "dirty" page that
> +				 * was never written, but only in the first
> +				 * bitmap (collecting the bitmap also clears
> +				 * all dirty pages).
> +				 */
> +				continue;
>  			}
>  
>  			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu) "
> @@ -574,36 +537,13 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			nr_clean_pages++;
>  			/*
>  			 * If cleared, the value written can be any
> -			 * value smaller or equals to the iteration
> -			 * number.  Note that the value can be exactly
> -			 * (iteration-1) if that write can happen
> -			 * like this:
> -			 *
> -			 * (1) increase loop count to "iteration-1"
> -			 * (2) write to page P happens (with value
> -			 *     "iteration-1")
> -			 * (3) get dirty log for "iteration-1"; we'll
> -			 *     see that page P bit is set (dirtied),
> -			 *     and not set the bit in host_bmap_track
> -			 * (4) increase loop count to "iteration"
> -			 *     (which is current iteration)
> -			 * (5) get dirty log for current iteration,
> -			 *     we'll see that page P is cleared, with
> -			 *     value "iteration-1".
> +			 * value smaller than the iteration number.
>  			 */
> -			TEST_ASSERT(val <= iteration,
> -				    "Clear page %lu value (%lu) > iteration (%lu) "
> +			TEST_ASSERT(val < iteration,
> +				    "Clear page %lu value (%lu) >= iteration (%lu) "
>  				    "(last = %lu, prev_last = %lu)",
>  				    page, val, iteration, dirty_ring_last_page,
>  				    dirty_ring_prev_iteration_last_page);
> -			if (val == iteration) {
> -				/*
> -				 * This page is _just_ modified; it
> -				 * should report its dirtyness in the
> -				 * next run
> -				 */
> -				__set_bit_le(page, host_bmap_track);
> -			}
>  		}
>  	}
>  
> @@ -639,7 +579,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	struct test_params *p = arg;
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> -	unsigned long *bmap;
> +	unsigned long *bmap[2];
>  	uint32_t ring_buf_idx = 0;
>  	int sem_val;
>  
> @@ -695,8 +635,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>  
> -	bmap = bitmap_zalloc(host_num_pages);
> -	host_bmap_track = bitmap_zalloc(host_num_pages);
> +	bmap[0] = bitmap_zalloc(host_num_pages);
> +	bmap[1] = bitmap_zalloc(host_num_pages);
>  
>  	/* Add an extra memory slot for testing dirty logging */
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> @@ -723,7 +663,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	WRITE_ONCE(host_quit, false);
>  	host_dirty_count = 0;
>  	host_clear_count = 0;
> -	host_track_next_count = 0;
>  	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
>  
>  	/*
> @@ -774,7 +713,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				continue;
>  
>  			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
> -						     bmap, host_num_pages,
> +						     bmap[0], host_num_pages,
>  						     &ring_buf_idx);
>  		}
>  
> @@ -804,6 +743,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		 * the flush of the last page, and since we handle the last
>  		 * page specially verification will succeed anyway.
>  		 */
> +		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
> +					     bmap[1], host_num_pages,
> +					     &ring_buf_idx);
>  		vm_dirty_log_verify(mode, bmap);
>  
>  		/*
> @@ -824,12 +766,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pthread_join(vcpu_thread, NULL);
>  
> -	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
> -		"track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
> -		host_track_next_count);
> +	pr_info("Total bits checked: dirty (%lu), clear (%lu)\n",
> +		host_dirty_count, host_clear_count);
>  
> -	free(bmap);
> -	free(host_bmap_track);
> +	free(bmap[0]);
> +	free(bmap[1]);
>  	kvm_vm_free(vm);
>  }
>  



