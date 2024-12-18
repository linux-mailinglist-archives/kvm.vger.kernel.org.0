Return-Path: <kvm+bounces-34011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D279F5ADF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F172516579C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE702AF06;
	Wed, 18 Dec 2024 00:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dkz43h48"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32022EAF9
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480075; cv=none; b=XnomJlB5j8LXm/HhWId/vlVDtJNDcTKRivONHPLJALytF6Vb9fTrbGFcnToplfumBMvCeEK+pKvery3Xxy5xn7zXJR29whkR+a/lCZDpbbQ3oDvAap8+xmQu5wzwe5yHCILNU3TsKpf7hQ6RUt2wuaQSIoRKU/QgDeNQT0Tf6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480075; c=relaxed/simple;
	bh=Y7B93kZ4ubuLJty/fkbTjImMyI1OknKK0109YgfX6N4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aN4VvHcZ3ZY7F+ZrGGCQKR8WvP8Oe6FJq1PIOdn8Xjf2jQ2O1BuOr0ahIOm62ksSc+m7n08SLKHGrFKeBNJkofK7O/O4sr6UqIL+oKuybBNU61k6cafATLo19MiPZ3ID8GxBWDQFF7NumipRfXNxXotci4aqYFdWU130webg3dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dkz43h48; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bo/RUCct0KIkYzDrZWYOaagFHcqmpMYIqMZsuD7r9TM=;
	b=Dkz43h48A9kcD2Mi+6Um6rccgFVF3PFsFj7sfYWOQ42Muuv8rkQX/6y1eedsI6tzymz822
	dE0YWf0wekNNn4YQineeX1zGWcNB/Uv6h5PQTmD+Yh2RtI0qinU+KMMs8Ad5pNvBShbodG
	RhPOYxRqdy5wGX3ea9eq39QtvjZLvCU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225--jUuXPCKO4yfD0sOsJf2gw-1; Tue, 17 Dec 2024 19:01:10 -0500
X-MC-Unique: -jUuXPCKO4yfD0sOsJf2gw-1
X-Mimecast-MFC-AGG-ID: -jUuXPCKO4yfD0sOsJf2gw
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a81357cdc7so2581875ab.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480070; x=1735084870;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bo/RUCct0KIkYzDrZWYOaagFHcqmpMYIqMZsuD7r9TM=;
        b=D71pMq/CP/VPN2u2vdmVw9BRaLaknYFKa9+IIBtXrl/eukJq6+gTvBABmiETr6U81D
         a5sSas7x6Ws/pTEoeLUJ6YiTkHtmUTzQjANoO2gpH+cLxMsBdPjRh+eOjOJUssuLullH
         tGSkYjKLkrCDpoSPVzinEaY9q0mtvdVsTYa4sgdkmUPIm7j+M+3kHxiQLEz8gJC++RUd
         AdD2Oa+yct+wmGiFRCPFCFI47Mhcl3ZryespofVkoLnkhpxCsFaZaRDDZCei+Nye1qdB
         /wcYboYo/TQ0KKz3CoXTU3ODEytMa85cyCn+6XcKIevSpRwkmOz29zfUt7iUH3jg3dca
         zIhw==
X-Gm-Message-State: AOJu0Yzuxtd4B9wpYj4OIjByCGrLtgIxKaO99zpmwtxEaYlDEfUR7c+c
	OegZsrnC71ecIKPhM4MeWPy2IbTx0pJQXkTDZZ0DcQlXpyBN8+8mBdxCIfs05AiA7A9RitQYym9
	oCeKXFstbK5KEa6Qva89ncrTap/jN68GZb0U3V4ysVTp1gjFygg==
X-Gm-Gg: ASbGncs15ZNlv7PVTus5NPoreo9xFB6UII4Z7wYpsN0PSdyubXHVCFWcYdJRvyoFjTv
	YZkL4g8XBV42m+DJDtT3xsQLHSs7LNPNbMaFyRYg2hjIdRIKGcXGZlNnkGpZvB9meDcNooxt+bW
	0vRAqMIV+mv05ez/KZ/Y7BaVbU2DXRo5xbWBtHYPLKQPTEXfhpPhVCUZUTWmFvS6nw00OFH3hjM
	LuTd+gNOUhBzlFMV0BsfCmTTKETZg9TNOKsWXVx+F0SnynMl75FoVDx
X-Received: by 2002:a05:6e02:1c81:b0:3a7:7bab:33f8 with SMTP id e9e14a558f8ab-3bb0ac12cbamr52858825ab.12.1734480070160;
        Tue, 17 Dec 2024 16:01:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwPxvtR0YHy3yL4zTEl4QvwE7PEyoVWytKRX324x9QG27BIsE935rwQFZVXy70I2ydwLMH2w==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:7bab:33f8 with SMTP id e9e14a558f8ab-3bb0ac12cbamr52858475ab.12.1734480069843;
        Tue, 17 Dec 2024 16:01:09 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a3360sm1933269173.106.2024.12.17.16.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:01:09 -0800 (PST)
Message-ID: <f2f0fdcd52ed2b11b15a95a569306b3d820fec13.camel@redhat.com>
Subject: Re: [PATCH 10/20] KVM: selftests: Keep dirty_log_test vCPU in guest
 until it needs to stop
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:01:08 -0500
In-Reply-To: <20241214010721.2356923-11-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-11-seanjc@google.com>
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
> In the dirty_log_test guest code, exit to userspace

Once again, "exit to userspace" is misleading.

>  only when the vCPU is
> explicitly told to stop.  Periodically exiting just to check if a flag has
> been set is unnecessary, weirdly complex, and wastes time handling exits
> that could be used to dirty memory.

> 
> Opportunistically convert 'i' to a uint64_t to guard against the unlikely
> scenario that guest_num_pages exceeds the storage of an int.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 43 ++++++++++----------
>  1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 8d31e275a23d..40c8f5551c8e 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -31,9 +31,6 @@
>  /* Default guest test virtual memory offset */
>  #define DEFAULT_GUEST_TEST_MEM		0xc0000000
>  
> -/* How many pages to dirty for each guest loop */
> -#define TEST_PAGES_PER_LOOP		1024
> -
>  /* How many host loops to run (one KVM_GET_DIRTY_LOG for each loop) */
>  #define TEST_HOST_LOOP_N		32UL
>  
> @@ -75,6 +72,7 @@ static uint64_t host_page_size;
>  static uint64_t guest_page_size;
>  static uint64_t guest_num_pages;
>  static uint64_t iteration;
> +static bool vcpu_stop;
>  
>  /*
>   * Guest physical memory offset of the testing memory slot.
> @@ -96,9 +94,10 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
>  static void guest_code(void)
>  {
>  	uint64_t addr;
> -	int i;
>  
>  #ifdef __s390x__
> +	uint64_t i;
> +
>  	/*
>  	 * On s390x, all pages of a 1M segment are initially marked as dirty
>  	 * when a page of the segment is written to for the very first time.
> @@ -112,7 +111,7 @@ static void guest_code(void)
>  #endif
>  
>  	while (true) {
> -		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
> +		while (!READ_ONCE(vcpu_stop)) {
>  			addr = guest_test_virt_mem;
>  			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
>  				* guest_page_size;
> @@ -140,14 +139,7 @@ static uint64_t host_track_next_count;
>  /* Whether dirty ring reset is requested, or finished */
>  static sem_t sem_vcpu_stop;
>  static sem_t sem_vcpu_cont;
> -/*
> - * This is only set by main thread, and only cleared by vcpu thread.  It is
> - * used to request vcpu thread to stop at the next GUEST_SYNC, since GUEST_SYNC
> - * is the only place that we'll guarantee both "dirty bit" and "dirty data"
> - * will match.  E.g., SIG_IPI won't guarantee that if the vcpu is interrupted
> - * after setting dirty bit but before the data is written.
> - */
> -static atomic_t vcpu_sync_stop_requested;
> +
>  /*
>   * This is updated by the vcpu thread to tell the host whether it's a
>   * ring-full event.  It should only be read until a sem_wait() of
> @@ -272,9 +264,7 @@ static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
>  /* Should only be called after a GUEST_SYNC */
>  static void vcpu_handle_sync_stop(void)
>  {
> -	if (atomic_read(&vcpu_sync_stop_requested)) {
> -		/* It means main thread is sleeping waiting */
> -		atomic_set(&vcpu_sync_stop_requested, false);
> +	if (READ_ONCE(vcpu_stop)) {
>  		sem_post(&sem_vcpu_stop);
>  		sem_wait(&sem_vcpu_cont);
>  	}
> @@ -801,11 +791,24 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		}
>  
>  		/*
> -		 * See vcpu_sync_stop_requested definition for details on why
> -		 * we need to stop vcpu when verify data.
> +		 * Stop the vCPU prior to collecting and verifying the dirty
> +		 * log.  If the vCPU is allowed to run during collection, then
> +		 * pages that are written during this iteration may be missed,
> +		 * i.e. collected in the next iteration.  And if the vCPU is
> +		 * writing memory during verification, pages that this thread
> +		 * sees as clean may be written with this iteration's value.
>  		 */
> -		atomic_set(&vcpu_sync_stop_requested, true);
> +		WRITE_ONCE(vcpu_stop, true);
> +		sync_global_to_guest(vm, vcpu_stop);
>  		sem_wait(&sem_vcpu_stop);
> +
> +		/*
> +		 * Clear vcpu_stop after the vCPU thread has acknowledge the
> +		 * stop request and is waiting, i.e. is definitely not running!
> +		 */
> +		WRITE_ONCE(vcpu_stop, false);
> +		sync_global_to_guest(vm, vcpu_stop);
> +
>  		/*
>  		 * NOTE: for dirty ring, it's possible that we didn't stop at
>  		 * GUEST_SYNC but instead we stopped because ring is full;
> @@ -813,8 +816,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		 * the flush of the last page, and since we handle the last
>  		 * page specially verification will succeed anyway.
>  		 */
> -		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
> -		       atomic_read(&vcpu_sync_stop_requested) == false);
>  		vm_dirty_log_verify(mode, bmap);
>  
>  		/*



