Return-Path: <kvm+bounces-34017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 681D59F5B01
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC28A1887AC1
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCD0189BBF;
	Wed, 18 Dec 2024 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ch9AO4Nh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2231E495
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480181; cv=none; b=NZQkoffXMf4KN6rrFfuYxjI07IqKEcQmmncNbtBpaY5bNd8cfHn6Lik7qiubq5MtPA5MiONwCUgQ2X4742PKPGqh3+yjE613UYeZgC0HpwALK5MazSaU1eAZXeRWf6Xk0FJwdFFfEcLpsd7d/0/nEYYfJeTiHQKekchRCUSG7G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480181; c=relaxed/simple;
	bh=FsozFYKSw64t1IC87qXIPAfB11JHhmbprN5KJscGNwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EF8L3m6MZwIupII4N3qMaArkyQ2LV8aUK0T41spuxt02jKiLNxCvfPNAKZvmDXN494KTjq25UMkSIcu4AbjWsHOiA5NkKMLpSKOEA58W/1B7VdQN5YN+0m/RPCxXQH4uAXy5w9/p/IGQSF3b3vI0hP4ayycUt/P0ae6X8AD36EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ch9AO4Nh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oy8ZDLJw1QkJ4PxJcxL0y9DkDZxPpsMmuhcLibDgiaE=;
	b=Ch9AO4Nh4+17bA5Sz4iXYtdkmX4rr2mWzjiY/StgL+fT4ZzGRU7+ef+8t5aP7BNxPEp1Lj
	eHJQBL3Zh35Fl03rNYD6M05vd3YRA64gvxWk/KptbRPjljIRqjoGEqdYy5T9p5gIizUUUs
	+Cpf2ZQiWYWhaiQJCCbnVR1y40M3K6g=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-1dt8W0kDOQKx2fecz3oQgg-1; Tue, 17 Dec 2024 19:02:57 -0500
X-MC-Unique: 1dt8W0kDOQKx2fecz3oQgg-1
X-Mimecast-MFC-AGG-ID: 1dt8W0kDOQKx2fecz3oQgg
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a817e4aa67so54956585ab.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:02:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480176; x=1735084976;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oy8ZDLJw1QkJ4PxJcxL0y9DkDZxPpsMmuhcLibDgiaE=;
        b=Xzk5Mib+N2Tsf7QtOXINgHdZhmlH4gng+K0/Mgc/rpiKxZRgUvCPQgBplYkmsnDPXZ
         RXZo/dkmKhRcy/cKKuUZLoviEgEm5qYwT4VwRVbDzYl4MPCzOpqmESCXKtDtRTacAWPp
         ZMxJutwUbO3oYhQ3b5fDecXNPgcJRB+JniYRhgLm3VnlRsiqstbvZPYDyMqgy6tJczVt
         7XmW6Girt7lcMIgeN2ZopP2Q5H19t/hS1X02MEmt7jGQiuiNDqLk9Q9tvFdX/t2YOCLA
         HHpbFefVSlLas02HLSIAa0kmcYOub0ALAV6VmzVGO7+v0MzCjfNwAbGZ91aLRLfi11jw
         yp1Q==
X-Gm-Message-State: AOJu0YxA+QVENJitg2eUWcKz6CBBwHrQJ1N3XPCWsJ+mFjwK4fpC4Ckl
	ilWTHsO8X8VaM93itrkYJQ1mn3gKi/BC5IpQ4FRJGuPsnJxo6lzvW8jhSkFDuYU2ODrMqFrnRiC
	toWDyrShXumJEGxpQ/XO5GhdPIouGk3RxEaXD+Xo0waTeJYua+w==
X-Gm-Gg: ASbGncvQmL8YDaO15xeHlAQWZImPlWPiebqqnmjhW2uTK91FVTW/OJBCSAJ56TQ2Nzo
	0rKi3nxpuCF7qoSjCJ4f+RUbcW0LbKoM0qfKcVn3dKQr1D6ZbKKIpxIzU3lTphb1wtPFnVQt6LQ
	xPatM63fbE8MhINQTczS5eaXqRJzzjN/XrF9wwFHjY7eGGhypBdnuY6C9O9qq6ck/jwahPcVnjS
	cP7/6b8UPQTw2Epbx+Lo56lKvsFjW3SF8UYOh+KNxxY6cBly2yqubF0
X-Received: by 2002:a05:6e02:1aa6:b0:3a7:d84c:f2a0 with SMTP id e9e14a558f8ab-3bdc0ad2b96mr8370245ab.7.1734480176494;
        Tue, 17 Dec 2024 16:02:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBZuELW1Y66tYCiTErQpDFwPIVVaAfPI8SAvM3CSLNbY2tysakmVtv5/nMA67EocL3N5a6Ug==
X-Received: by 2002:a05:6e02:1aa6:b0:3a7:d84c:f2a0 with SMTP id e9e14a558f8ab-3bdc0ad2b96mr8369995ab.7.1734480176131;
        Tue, 17 Dec 2024 16:02:56 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e67428d17csm250617173.57.2024.12.17.16.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:02:55 -0800 (PST)
Message-ID: <09fffc1c382a477cc97f5b28b051700707dacd20.camel@redhat.com>
Subject: Re: [PATCH 16/20] KVM: selftests: Ensure guest writes min number of
 pages in dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:02:54 -0500
In-Reply-To: <20241214010721.2356923-17-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-17-seanjc@google.com>
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
> Ensure the vCPU fully completes at least one write in each dirty_log_test
> iteration, as failure to dirty any pages complicates verification and
> forces the test to be overly conservative about possible values.  E.g.
> verification needs to allow the last dirty page from a previous iteration
> to have *any* value, because the vCPU could get stuck for multiple
> iterations, which is unlikely but can happen in heavily overloaded and/or
> nested virtualization setups.
> 
> Somewhat arbitrarily set the minimum to 0x100/256; high enough to be
> interesting, but not so high as to lead to pointlessly long runtimes.
> 
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 30 ++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 500257b712e3..8eb51597f762 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -37,6 +37,12 @@
>  /* Interval for each host loop (ms) */
>  #define TEST_HOST_LOOP_INTERVAL		10UL
>  
> +/*
> + * Ensure the vCPU is able to perform a reasonable number of writes in each
> + * iteration to provide a lower bound on coverage.
> + */
> +#define TEST_MIN_WRITES_PER_ITERATION	0x100
> +
>  /* Dirty bitmaps are always little endian, so we need to swap on big endian */
>  #if defined(__s390x__)
>  # define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
> @@ -72,6 +78,7 @@ static uint64_t host_page_size;
>  static uint64_t guest_page_size;
>  static uint64_t guest_num_pages;
>  static uint64_t iteration;
> +static uint64_t nr_writes;
>  static bool vcpu_stop;
>  
>  /*
> @@ -107,6 +114,7 @@ static void guest_code(void)
>  	for (i = 0; i < guest_num_pages; i++) {
>  		addr = guest_test_virt_mem + i * guest_page_size;
>  		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
> +		nr_writes++;
>  	}
>  #endif
>  
> @@ -118,6 +126,7 @@ static void guest_code(void)
>  			addr = align_down(addr, host_page_size);
>  
>  			vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
> +			nr_writes++;
>  		}
>  
>  		GUEST_SYNC(1);
> @@ -665,6 +674,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	host_dirty_count = 0;
>  	host_clear_count = 0;
>  	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
> +	WRITE_ONCE(nr_writes, 0);
> +	sync_global_to_guest(vm, nr_writes);
>  
>  	/*
>  	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
> @@ -683,10 +694,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
>  
> -		/* Give the vcpu thread some time to dirty some pages */
> -		for (i = 0; i < p->interval; i++) {
> +		/*
> +		 * Let the vCPU run beyond the configured interval until it has
> +		 * performed the minimum number of writes.  This verifies the
> +		 * guest is making forward progress, e.g. isn't stuck because
> +		 * of a KVM bug, and puts a firm floor on test coverage.
> +		 */
> +		for (i = 0; i < p->interval || nr_writes < TEST_MIN_WRITES_PER_ITERATION; i++) {
> +			/*
> +			 * Sleep in 1ms chunks to keep the interval math simple
> +			 * and so that the test doesn't run too far beyond the
> +			 * specified interval.
> +			 */
>  			usleep(1000);
>  
> +			sync_global_from_guest(vm, nr_writes);
> +
>  			/*
>  			 * Reap dirty pages while the guest is running so that
>  			 * dirty ring full events are resolved, i.e. so that a
> @@ -760,6 +783,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  			WRITE_ONCE(host_quit, true);
>  		sync_global_to_guest(vm, iteration);
>  
> +		WRITE_ONCE(nr_writes, 0);
> +		sync_global_to_guest(vm, nr_writes);
> +
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
>  
>  		sem_post(&sem_vcpu_cont);

This makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


