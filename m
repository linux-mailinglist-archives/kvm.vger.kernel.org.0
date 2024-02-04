Return-Path: <kvm+bounces-7941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87AB3848AFC
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 05:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF42B1F23EEC
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 04:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD85749A;
	Sun,  4 Feb 2024 04:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BirDRneg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E96FA8
	for <kvm@vger.kernel.org>; Sun,  4 Feb 2024 04:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707020573; cv=none; b=m0jpuJZBP3bjEG2CYeJAn/mDK440Ys8JpZVcqAsnuURVvsvktuBYS4lWgzdqOZ04k/5ecBD/gt9V1Zpr7yPu0y4BVasq7kTHfEVuZ6LfbauAKrlNhVGPFQuUSxt/4q100nWxBZzSHzIVjeFW04jYgZdeyBsxLLs2XslmsTTMHrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707020573; c=relaxed/simple;
	bh=ivyjQmXbCTYO/puaNTbK55Wk2s7Pa48bP4R7RrFB7h0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CRTrKKfvmj+kj3Rs1mfdVaYNYV7Ut0spsLDOaFqsnWhnn/NLEdLMDm8jaC3W3Gxiu2QqJaWGiTufuwEisvCJXjkH2TToRbxjrHUZJPukTkdB2ewejaBOkRfxmQjePfroFlpaDZ7Ku2gVJSy+tpZ15CBIWBMzhchNSccgKgjOR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BirDRneg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707020569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PyNa0NcWlAeyikPHcWl9Ahg0XOk5KDcxMhCNpLB7tmE=;
	b=BirDRnegEdPjqCqsay9wodMAZzFrkvK5vdCBZLjbA+2qypI+ZZDB3js6n/HiZRrpILjr0R
	6Grd/TE0olQFxQ50HEtJb+XKrrRDRoopDxsDShU5yKR9pzLSpKr3FRvEiObnuWlw5cW228
	J/xKnawun8b4Nm/S8Av7sFrBPfIQt0o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-lFIv9IaePACHB9z-3phyWw-1; Sat, 03 Feb 2024 23:22:48 -0500
X-MC-Unique: lFIv9IaePACHB9z-3phyWw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e03d38022dso30740b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 20:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707020567; x=1707625367;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyNa0NcWlAeyikPHcWl9Ahg0XOk5KDcxMhCNpLB7tmE=;
        b=o5c04xSJbBBpEcy2eX6rVn92Byjk4A6S6yQaMxyWwB9KvYK+qrg+cje5BOoksgwny8
         B3x5lxUfrnStotXZRPrbxPsrA59hzHk0N3GFrJO3HXZXCIFAjg5G3mlJy1tFrx+iJBJl
         kArA2I6P9mUsYotyuG/ggHP5Kwa5otoP12M5KYvJO61GIF+m21Yix0gt7t2URyRJLu7K
         1RPlVESXmDnrJqCr3+vPLMKIePxlGCwvAKmgSeU3Er3jRcWwgVgOA6p3kK72YF69QXgO
         X5JFt4cJfY+K/47ziLclZg2ZNHIhf4uS3Lji3puUpiMOWdeUD4CanSDQ56PJPlSzWbKa
         Lcxw==
X-Gm-Message-State: AOJu0YxcWyQPLSk4gbP+cR8zbiIxzj3SYLg0VakJn1C1s/zcpNYZmSCM
	lifUYDTX0garvi6WPZtJ8JYo3TkyLlgz918vLHNYeY1OBQy2dHyQC0RhvCwgjcDzNa1IOmemt/2
	oa9AiZ08CZeMjlYovTXRmmMx5ODQOZGIgfzNjx/SKvgYbM7534g==
X-Received: by 2002:a05:6a00:1d0a:b0:6e0:289e:e182 with SMTP id a10-20020a056a001d0a00b006e0289ee182mr3350621pfx.0.1707020567014;
        Sat, 03 Feb 2024 20:22:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0IWLPV9X8xVOCdb2HdkLIVdBu0/yn9+Us/XbcpUulOgDCh/26Q+o/3WqXVJRRkOKXlGg58A==
X-Received: by 2002:a05:6a00:1d0a:b0:6e0:289e:e182 with SMTP id a10-20020a056a001d0a00b006e0289ee182mr3350602pfx.0.1707020566576;
        Sat, 03 Feb 2024 20:22:46 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUYeUGVWEw40iaTavJzWEdI6BkQSKin8qEsbx1Lp1bcOjQdxKTRQaGm2/6pSArDWRz80mZSTaCnXAkTrIDZF4M/CvQI4OzQPEnkYWKcXfFriSO/286No3YJPLZFJ68Yqo5U
Received: from [10.72.116.41] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q14-20020a62ae0e000000b006e03bababf5sm358449pff.123.2024.02.03.20.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 20:22:45 -0800 (PST)
Message-ID: <17eefa60-cf30-4830-943e-793a63d4e6f1@redhat.com>
Date: Sun, 4 Feb 2024 12:22:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240202231831.354848-1-seanjc@google.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240202231831.354848-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sean,

Thanks for your better solution to fix this issue, I've tested your 
patch, it actually fix the problem I encounter. Thanks.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

On 2/3/24 07:18, Sean Christopherson wrote:
> When finishing the final iteration of dirty_log_test testcase, set
> host_quit _before_ the final "continue" so that the vCPU worker doesn't
> run an extra iteration, and delete the hack-a-fix of an extra "continue"
> from the dirty ring testcase.  This fixes a bug where the extra post to
> sem_vcpu_cont may not be consumed, which results in failures in subsequent
> runs of the testcases.  The bug likely was missed during development as
> x86 supports only a single "guest mode", i.e. there aren't any subsequent
> testcases after the dirty ring test, because for_each_guest_mode() only
> runs a single iteration.
> 
> For the regular dirty log testcases, letting the vCPU run one extra
> iteration is a non-issue as the vCPU worker waits on sem_vcpu_cont if and
> only if the worker is explicitly told to stop (vcpu_sync_stop_requested).
> But for the dirty ring test, which needs to periodically stop the vCPU to
> reap the dirty ring, letting the vCPU resume the guest _after_ the last
> iteration means the vCPU will get stuck without an extra "continue".
> 
> However, blindly firing off an post to sem_vcpu_cont isn't guaranteed to
> be consumed, e.g. if the vCPU worker sees host_quit==true before resuming
> the guest.  This results in a dangling sem_vcpu_cont, which leads to
> subsequent iterations getting out of sync, as the vCPU worker will
> continue on before the main task is ready for it to resume the guest,
> leading to a variety of asserts, e.g.
> 
>    ==== Test Assertion Failure ====
>    dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>    pid=14854 tid=14854 errno=22 - Invalid argument
>       1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
>       2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>       3   (inlined by) run_test at dirty_log_test.c:802
>       4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>       5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>       6  0x0000ffff9be173c7: ?? ??:0
>       7  0x0000ffff9be1749f: ?? ??:0
>       8  0x000000000040206f: _start at ??:?
>    Didn't continue vcpu even without ring full
> 
> Alternatively, the test could simply reset the semaphores before each
> testcase, but papering over hacks with more hacks usually ends in tears.
> 
> Reported-by: Shaoqin Huang <shahuang@redhat.com>
> Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/dirty_log_test.c | 50 +++++++++++---------
>   1 file changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index babea97b31a4..eaad5b20854c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -376,7 +376,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
>   
>   	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
>   
> -	/* Cleared pages should be the same as collected */
> +	/*
> +	 * Cleared pages should be the same as collected, as KVM is supposed to
> +	 * clear only the entries that have been harvested.
> +	 */
>   	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
>   		    "with collected (%u)", cleared, count);
>   
> @@ -415,12 +418,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
>   	}
>   }
>   
> -static void dirty_ring_before_vcpu_join(void)
> -{
> -	/* Kick another round of vcpu just to make sure it will quit */
> -	sem_post(&sem_vcpu_cont);
> -}
> -
>   struct log_mode {
>   	const char *name;
>   	/* Return true if this mode is supported, otherwise false */
> @@ -433,7 +430,6 @@ struct log_mode {
>   				     uint32_t *ring_buf_idx);
>   	/* Hook to call when after each vcpu run */
>   	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
> -	void (*before_vcpu_join) (void);
>   } log_modes[LOG_MODE_NUM] = {
>   	{
>   		.name = "dirty-log",
> @@ -452,7 +448,6 @@ struct log_mode {
>   		.supported = dirty_ring_supported,
>   		.create_vm_done = dirty_ring_create_vm_done,
>   		.collect_dirty_pages = dirty_ring_collect_dirty_pages,
> -		.before_vcpu_join = dirty_ring_before_vcpu_join,
>   		.after_vcpu_run = dirty_ring_after_vcpu_run,
>   	},
>   };
> @@ -513,14 +508,6 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
>   		mode->after_vcpu_run(vcpu, ret, err);
>   }
>   
> -static void log_mode_before_vcpu_join(void)
> -{
> -	struct log_mode *mode = &log_modes[host_log_mode];
> -
> -	if (mode->before_vcpu_join)
> -		mode->before_vcpu_join();
> -}
> -
>   static void generate_random_array(uint64_t *guest_array, uint64_t size)
>   {
>   	uint64_t i;
> @@ -719,6 +706,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	struct kvm_vm *vm;
>   	unsigned long *bmap;
>   	uint32_t ring_buf_idx = 0;
> +	int sem_val;
>   
>   	if (!log_mode_supported()) {
>   		print_skip("Log mode '%s' not supported",
> @@ -788,12 +776,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	/* Start the iterations */
>   	iteration = 1;
>   	sync_global_to_guest(vm, iteration);
> -	host_quit = false;
> +	WRITE_ONCE(host_quit, false);
>   	host_dirty_count = 0;
>   	host_clear_count = 0;
>   	host_track_next_count = 0;
>   	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
>   
> +	/*
> +	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
> +	 * that the main task and vCPU worker were synchronized and completed
> +	 * verification of all iterations.
> +	 */
> +	sem_getvalue(&sem_vcpu_stop, &sem_val);
> +	TEST_ASSERT_EQ(sem_val, 0);
> +	sem_getvalue(&sem_vcpu_cont, &sem_val);
> +	TEST_ASSERT_EQ(sem_val, 0);
> +
>   	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
>   
>   	while (iteration < p->iterations) {
> @@ -819,15 +817,21 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
>   		       atomic_read(&vcpu_sync_stop_requested) == false);
>   		vm_dirty_log_verify(mode, bmap);
> +
> +		/*
> +		 * Set host_quit before sem_vcpu_cont in the final iteration to
> +		 * ensure that the vCPU worker doesn't resume the guest.  As
> +		 * above, the dirty ring test may stop and wait even when not
> +		 * explicitly request to do so, i.e. would hang waiting for a
> +		 * "continue" if it's allowed to resume the guest.
> +		 */
> +		if (++iteration == p->iterations)
> +			WRITE_ONCE(host_quit, true);
> +
>   		sem_post(&sem_vcpu_cont);
> -
> -		iteration++;
>   		sync_global_to_guest(vm, iteration);
>   	}
>   
> -	/* Tell the vcpu thread to quit */
> -	host_quit = true;
> -	log_mode_before_vcpu_join();
>   	pthread_join(vcpu_thread, NULL);
>   
>   	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
> 
> base-commit: d79e70e8cc9ee9b0901a93aef391929236ed0f39

-- 
Shaoqin


