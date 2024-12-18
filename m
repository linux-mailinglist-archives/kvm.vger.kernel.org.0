Return-Path: <kvm+bounces-34009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E28049F5ADA
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:00:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDC4D7A3E4A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1401FBEAB;
	Wed, 18 Dec 2024 00:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P7Wkwzwh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36341FBE83
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480006; cv=none; b=n/llw6mXNikdjzQjRJ/5mIySldQ3WUbeXPSZY81IQiCf6iq5FjQ9jaTjaMRKHY9eZ+e6Q0/YbGEUqrL3GuMSEvrl/3qb9LOdmNAgKV0gcs0icaxWO8m1VqnEQvwfcvuPpkhi5yAA5fODe8xcj1Yrtw6uYnK9EJ6vAebSU+cIkz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480006; c=relaxed/simple;
	bh=SleDlVMQqj5Io+jnSUfKNvetPmxTTTd68cIBXfEucIc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aYJ7izMEsYuZ7hxOGvQrKtQIjFTEYPvpVMZTSCvf0jgIqd9kw/4lOwvDtSkdk6Dt/cL1y9Af/aOTdSOuH11w5YK0hnq0c278DC3EamJ95q/iX5RmL/Ra12r3qZy3OJuimeCWN0GBPtLUjX79+tWW46sjrrL6PXR3sVK24ASnOnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P7Wkwzwh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B9qTG2CUzXDnW++v7sE/8F+PXM4P/68p1aafZpzsDtc=;
	b=P7Wkwzwh18pWet1ZH+WW3tkf82jrpRh4JeJ7GYQRXSa1X4DmIzT9sy71EEKA8ZykZf+dYZ
	00YOt2GimirzZe8kswzCeeIfyP6W3ohzgiCDCUO2pKIVhcIIcNU6uxASSxjhZOzR/hrtp6
	xIciOA8empTHHBb8LAbKi+0ABDmoqII=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-PsbKGV9KMtyOUVA1qfWzWw-1; Tue, 17 Dec 2024 19:00:02 -0500
X-MC-Unique: PsbKGV9KMtyOUVA1qfWzWw-1
X-Mimecast-MFC-AGG-ID: PsbKGV9KMtyOUVA1qfWzWw
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9cc5c246bso64941865ab.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480002; x=1735084802;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B9qTG2CUzXDnW++v7sE/8F+PXM4P/68p1aafZpzsDtc=;
        b=oUIDfZCLVUvXf/xbn/N3sXuVqswopbF70QC4PCQ112U29GIg1p3taLxWW8ChSHbzZD
         SW0mRot3HdxQEdUDRqOgECJcCgHcuYkhVum7V/Nf3Zof2ovAfJkg3pnG7686EX+j4sbc
         R7KuxRTuVtUy/SgVRZ+JfCUyfcrK4zt16N3GSgwOzw0ECU/3Mbn+LrKO2Z9SE1nS/OdF
         YV2Hz2ylUXjmQFtgH9ENAv59ziqYIPauPLbyz+qGKc8nOFt3MiEG23TdpMdMrTSSD6Bd
         cD08xR7i9DdqWkKHrEfFwU+plVfhvLdSUfrAPn0GDfvjbf4pL8aypdGm/rEnYbPRP9Wy
         8Q6A==
X-Gm-Message-State: AOJu0YwIqNjuRp2mRHkx+Sg32NeJSqLnIjcMUIg+VrgDCc+BF3FwT2Zj
	c9xd1mGgEZnBUiB87mg3JREF4bSnKjFO8gUpmMLFpK57XgeV5qJ5YB0OVTqwprAZ2uMwWW0gPMD
	VmtY9L+wumIvMB11Y8ysPEPCMkRrw+e8SayCqeBaShUk3tUeXwg==
X-Gm-Gg: ASbGnctpA45R0oLubT3F/iyHU4J+h7woi9msJIsNWb0SgdTisJcCaMaYw1xRC3+hjja
	wbSwRWSy2p/fZfwjdAR4tdrM+2/Tp1xuTv/gP8VUjPS5/V9FCMDohNK5E4tMQ6qNaGhqQkSygbu
	5XNWp38fDzynK5Ek12OzNl5FrwyxnujJPYtdL9F5NaWfZFND6mC4rkI19vx8GE+/dXGr5cFkQ2Y
	ZiyRYt3wNHJAudieUzgHPqo5GRebsQettb5OvtienOdNaORY4oMYkwi
X-Received: by 2002:a05:6e02:1a62:b0:3a7:7124:bd2b with SMTP id e9e14a558f8ab-3bdc437b5a1mr8371055ab.15.1734480001874;
        Tue, 17 Dec 2024 16:00:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjLQr1P+5FhEYSL6bfCst12hiBbYYtqLq49XVoeIDwshRqaVBDwI+REbhW0YHjpYYeYM7tpw==
X-Received: by 2002:a05:6e02:1a62:b0:3a7:7124:bd2b with SMTP id e9e14a558f8ab-3bdc437b5a1mr8370895ab.15.1734480001524;
        Tue, 17 Dec 2024 16:00:01 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a2dfdsm1919571173.105.2024.12.17.16.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:00:01 -0800 (PST)
Message-ID: <af58ea9d81bff3d0fece356a358ee29b1b76f080.camel@redhat.com>
Subject: Re: [PATCH 07/20] KVM: selftests: Continuously reap dirty ring
 while vCPU is running
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:00:00 -0500
In-Reply-To: <20241214010721.2356923-8-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-8-seanjc@google.com>
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
> Continue collecting entries from the dirty ring for the entire time the
> vCPU is running.  Collecting exactly once all but guarantees the vCPU will
> encounter a "ring full" event and stop.  While testing ring full is
> interesting, stopping and doing nothing is not, especially for larger
> intervals as the test effectively does nothing for a much longer time.
> 
> To balance continuous collection with letting the guest make forward
> progress, chunk the interval waiting into 1ms loops (which also makes
> the math dead simple).
> 
> To maintain coverage for "ring full", collect entries on subsequent
> iterations if and only if the ring has been filled at least once.  I.e.
> let the ring fill up (if the interval allows), but after that contiuously
> empty it so that the vCPU can keep running.
> 
> Opportunistically drop unnecessary zero-initialization of "count".
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 63 ++++++++++++++------
>  1 file changed, 46 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 5a04a7bd73e0..2aee047b8b1c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -340,8 +340,6 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
>  	struct kvm_dirty_gfn *cur;
>  	uint32_t count = 0;
>  
> -	dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
> -
>  	while (true) {
>  		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
>  		if (!dirty_gfn_is_dirtied(cur))
> @@ -360,17 +358,11 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
>  	return count;
>  }
>  
> -static void dirty_ring_continue_vcpu(void)
> -{
> -	pr_info("Notifying vcpu to continue\n");
> -	sem_post(&sem_vcpu_cont);
> -}
> -
>  static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
>  					   void *bitmap, uint32_t num_pages,
>  					   uint32_t *ring_buf_idx)
>  {
> -	uint32_t count = 0, cleared;
> +	uint32_t count, cleared;
>  
>  	/* Only have one vcpu */
>  	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
> @@ -385,9 +377,6 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
>  	 */
>  	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
>  		    "with collected (%u)", cleared, count);
> -
> -	if (READ_ONCE(dirty_ring_vcpu_ring_full))
> -		dirty_ring_continue_vcpu();
>  }
>  
>  static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -404,7 +393,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
>  		sem_post(&sem_vcpu_stop);
>  		pr_info("Dirty ring full, waiting for it to be collected\n");
>  		sem_wait(&sem_vcpu_cont);
> -		pr_info("vcpu continues now.\n");
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
>  	} else {
>  		TEST_ASSERT(false, "Invalid guest sync status: "
> @@ -755,11 +743,52 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
>  
>  	while (iteration < p->iterations) {
> +		bool saw_dirty_ring_full = false;
> +		unsigned long i;
> +
> +		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
> +
>  		/* Give the vcpu thread some time to dirty some pages */
> -		usleep(p->interval * 1000);
> -		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
> -					     bmap, host_num_pages,
> -					     &ring_buf_idx);
> +		for (i = 0; i < p->interval; i++) {
> +			usleep(1000);
> +
> +			/*
> +			 * Reap dirty pages while the guest is running so that
> +			 * dirty ring full events are resolved, i.e. so that a
> +			 * larger interval doesn't always end up with a vCPU
> +			 * that's effectively blocked.  Collecting while the
> +			 * guest is running also verifies KVM doesn't lose any
> +			 * state.
> +			 *
> +			 * For bitmap modes, KVM overwrites the entire bitmap,
> +			 * i.e. collecting the bitmaps is destructive.  Collect
> +			 * the bitmap only on the first pass, otherwise this
> +			 * test would lose track of dirty pages.
> +			 */
> +			if (i && host_log_mode != LOG_MODE_DIRTY_RING)
> +				continue;
> +
> +			/*
> +			 * For the dirty ring, empty the ring on subsequent
> +			 * passes only if the ring was filled at least once,
> +			 * to verify KVM's handling of a full ring (emptying
> +			 * the ring on every pass would make it unlikely the
> +			 * vCPU would ever fill the fing).
> +			 */
> +			if (READ_ONCE(dirty_ring_vcpu_ring_full))
> +				saw_dirty_ring_full = true;
> +			if (i && !saw_dirty_ring_full)
> +				continue;
> +
> +			log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
> +						     bmap, host_num_pages,
> +						     &ring_buf_idx);
> +
> +			if (READ_ONCE(dirty_ring_vcpu_ring_full)) {
> +				pr_info("Dirty ring emptied, restarting vCPU\n");
> +				sem_post(&sem_vcpu_cont);
> +			}
> +		}
>  
>  		/*
>  		 * See vcpu_sync_stop_requested definition for details on why

This looks reasonable.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




