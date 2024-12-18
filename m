Return-Path: <kvm+bounces-34012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4F99F5AE0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4BD7188F4EA
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE2518E2A;
	Wed, 18 Dec 2024 00:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFWRz30L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD1F4409
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480099; cv=none; b=ldkjnYthJ8+7afK487cCWYzhFY2+rcZ+jRuQA7V/L59oa8B7K8Ywryy9Aig9SxOJM9BiAGQhLLZM3VafRChQnDQrTN1vSr+9oCD/G04VNesce9R3Ssk6Hq5foAw0UVUuQNC6GMnUXiD4DbZELioqmocoowEEPdybNfg0YRxC4D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480099; c=relaxed/simple;
	bh=vVMSarTL4N2s340QMRcYgMbsinxaLhfegPanrb6aBgw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SmdeiPnJUPwvCSBWcCuYSXZtjdeHg2qyhqcetAz9LYA/CCxFSExzjd4H3y8NcE8K9nXU7DWRDbT3FnJSt+/w15aWZ7OsWoTp1jVfJl28EC2wChoY1AACYkiOraMR8WsDX7G+zAXnSnT6X0uPLxhoWJqmKOoI7CJn+ZC0HfOCWE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFWRz30L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nvgZx2crNsqZt4BsRhiMLfgvWFUrdaXN/HwK/dKUNkw=;
	b=HFWRz30LzCyztuBmYOxayhzT/UZv1K7fffXFUaCk/1FFCPEGYo85a6yClGpOsIlsZBMF10
	ItXmm62V/bOtwRkwfkGaxNYP6l629k/7LyEoZvOY/8OXvqUscrcceDJ/K8CI+K0N+jK7gh
	f2eySnNIewTREVINIyam7IYq6BspkHU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-sDhaAKmiNAy3yt8xzpZSaA-1; Tue, 17 Dec 2024 19:01:35 -0500
X-MC-Unique: sDhaAKmiNAy3yt8xzpZSaA-1
X-Mimecast-MFC-AGG-ID: sDhaAKmiNAy3yt8xzpZSaA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844db0decffso21466939f.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480095; x=1735084895;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nvgZx2crNsqZt4BsRhiMLfgvWFUrdaXN/HwK/dKUNkw=;
        b=jrFz5IxQJMlHyaX5NCmqnNY9TFQ5Z4Ff51XCrBqejN0VgzcApWhXIqwq7lIzLBYOCS
         2Zat6Ds3E9+wGYKQJ0VNHAGIKz7zwF7MmtJmYwEH/YeRgKPKJM5UhdqmxrRo8KqNrX6+
         Mi3fOL7Io+P+VDiEzVyquPUUDrhNbzKauh+EEyuoiRjgBXyDOn9Epnscguv1RqZCvPjc
         obG6BOfMeXJnnr5oZ71PZc5JDfOExshKd3FM8+4B3EkYoTFFhwHAQ7//dGwRCE069lpU
         XOVDs7PGNkhXktSHNTtqTxlTB4Ah8NCMUzhiAmzShJsk/z6w5X8rHwAMMsNq01aqkoP2
         3r1A==
X-Gm-Message-State: AOJu0YzMzhIByqBrKMf9GGwKgp71eOXgfqw4DIlTASQzD3cyPApZPhSC
	3RK/X0VZ8AAuqvDjJ6tAmOlP/fjlUv9uOCY27QFAFbS0cbV8DBWDR3x212GhUDBpWOs+gPgjnWg
	n8CqV+vjeP7vhwU/DSeImne4Bt7yOvgsez3s/HxxhHLmj3PjVQg==
X-Gm-Gg: ASbGncukjDGIC6yoGXSdQW6iAc3Ti4ldvKG7P6ORXMXXyaCgJLCN40y1RSBeKHP/Vwl
	PsXRsDjWdZgfkiO+FigT03dnFGTUE/a8gQwjGidDkLfufnSYtX0rl5BUUYIvY7IYautxCMT9dsP
	bpKJc0hgYRG1Yhc5KH52j/+UoOvegwm5dJrfdw2ABjtVB8fvNzOr4i+fcklTOT5FWeeZLnGGXAB
	m7nYHhi6x/CUNgJzfxjZDMBYYsMZjIEJLrrlnN/UXUBy8JkNmgE4eMr
X-Received: by 2002:a05:6602:148e:b0:835:3dfc:5ba5 with SMTP id ca18e2360f4ac-84747e25760mr538484839f.5.1734480094821;
        Tue, 17 Dec 2024 16:01:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgUSvLxLx8Jacs3zu4xrTuXPccVSmb7WefXa01BGBXeUW42nLC3tU6OvQezOhmtr+LiEBtEQ==
X-Received: by 2002:a05:6602:148e:b0:835:3dfc:5ba5 with SMTP id ca18e2360f4ac-84747e25760mr538481939f.5.1734480094471;
        Tue, 17 Dec 2024 16:01:34 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844f626a910sm199272439f.17.2024.12.17.16.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:01:33 -0800 (PST)
Message-ID: <336741c9f992bb340aa075f65578a0d4a68b0193.camel@redhat.com>
Subject: Re: [PATCH 11/20] KVM: selftests: Post to sem_vcpu_stop if and only
 if vcpu_stop is true
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:01:32 -0500
In-Reply-To: <20241214010721.2356923-12-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-12-seanjc@google.com>
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
> When running dirty_log_test using the dirty ring, post to sem_vcpu_stop
> only when the main thread has explicitly requested that the vCPU stop.
> Synchronizing the vCPU and main thread whenever the dirty ring happens to
> be full is unnecessary, as KVM's ABI is to actively prevent the vCPU from
> running until the ring is no longer full.  I.e. attempting to run the vCPU
> will simply result in KVM_EXIT_DIRTY_RING_FULL without ever entering the
> guest.  And if KVM doesn't exit, e.g. let's the vCPU dirty more pages,
> then that's a KVM bug worth finding.

This is probably a good idea to do sometimes, but this can also reduce coverage because
now the vCPU will pointlessly enter and exit when dirty log is full.

Best regards,
	Maxim Levitsky


> 
> Posting to sem_vcpu_stop on ring full also makes it difficult to get the
> test logic right, e.g. it's easy to let the vCPU keep running when it
> shouldn't, as a ring full can essentially happen at any given time.
> 
> Opportunistically rework the handling of dirty_ring_vcpu_ring_full to
> leave it set for the remainder of the iteration in order to simplify the
> surrounding logic.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 40c8f5551c8e..8544e8425f9c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -379,12 +379,8 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
>  		vcpu_handle_sync_stop();
>  	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
> -		/* Update the flag first before pause */
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
> -		sem_post(&sem_vcpu_stop);
> -		pr_info("Dirty ring full, waiting for it to be collected\n");
> -		sem_wait(&sem_vcpu_cont);
> -		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
> +		vcpu_handle_sync_stop();
>  	} else {
>  		TEST_ASSERT(false, "Invalid guest sync status: "
>  			    "exit_reason=%s",
> @@ -743,7 +739,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
>  
>  	while (iteration < p->iterations) {
> -		bool saw_dirty_ring_full = false;
>  		unsigned long i;
>  
>  		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
> @@ -775,19 +770,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  			 * the ring on every pass would make it unlikely the
>  			 * vCPU would ever fill the fing).
>  			 */
> -			if (READ_ONCE(dirty_ring_vcpu_ring_full))
> -				saw_dirty_ring_full = true;
> -			if (i && !saw_dirty_ring_full)
> +			if (i && !READ_ONCE(dirty_ring_vcpu_ring_full))
>  				continue;
>  
>  			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
>  						     bmap, host_num_pages,
>  						     &ring_buf_idx);
> -
> -			if (READ_ONCE(dirty_ring_vcpu_ring_full)) {
> -				pr_info("Dirty ring emptied, restarting vCPU\n");
> -				sem_post(&sem_vcpu_cont);
> -			}
>  		}
>  
>  		/*
> @@ -829,6 +817,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  			WRITE_ONCE(host_quit, true);
>  		sync_global_to_guest(vm, iteration);
>  
> +		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
> +
>  		sem_post(&sem_vcpu_cont);
>  	}
>  



