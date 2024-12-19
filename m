Return-Path: <kvm+bounces-34169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 819749F7EB3
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:00:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3B267A1B63
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F017E22756E;
	Thu, 19 Dec 2024 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xn5aPA4V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A1C226878
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734623980; cv=none; b=XJx7x8E2DFlSlzAW3STsOhnGFEiaGNVqMhRN0aFDq77dacHSCohJ/4+sbyOowtjfWO6CEVbqhmynPNxTY3DPk1cCHXGZNBffEbUFb9/Wxte9P+Mxb0bWYtd1yUm5NbGDD828NXjwSp2Fgd+vXLEMzdWEXBEL2srbZkwFLtOx0FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734623980; c=relaxed/simple;
	bh=vstkUh+2Dh8QsDKfIb3fgarlbj/1KRA/Pe+Z3osIq20=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dJy3dXdG8+HUaTufhW+RaAIjfZSt0bt2/4A1ud7oabKnWmrohL76QKfiacV1Ni+kjpP1nKMlQjrn3Acxw5fNFO0rkrLol3EO75zJc9T4wwkd0k5Zz8q7v6zroiRWpg7477EdKfde3mX7UYnIyLoyJv7gu5hz81ctcUPDFMUL+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xn5aPA4V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734623976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dxrNaP+mOwWmMIE3wAYCd8ImS2/Ci2QbbaSTvbXTQEs=;
	b=Xn5aPA4VKxCN6/m1S36hbUOMCXIfag/1C+jNcRuTBGdV8BY5uOiCBhtp9ZSD4MRm+qjB//
	1dlxeCz7DA0jRGnoO2WMkUSGwN6zo9hZRAjJm0DKzRTM8heh1nYyJnN3LeRAj8PocfN17F
	E88mmMFINWZQbplTsqFzD+CRgde9zrI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-OTa99QRsNMS-GScQNqQpew-1; Thu, 19 Dec 2024 10:59:35 -0500
X-MC-Unique: OTa99QRsNMS-GScQNqQpew-1
X-Mimecast-MFC-AGG-ID: OTa99QRsNMS-GScQNqQpew
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a9d195e6e5so7850125ab.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734623974; x=1735228774;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dxrNaP+mOwWmMIE3wAYCd8ImS2/Ci2QbbaSTvbXTQEs=;
        b=WICGqGi58fY296C+lV9G3AacTq7Um7whcdpSzNDrwbzeM3YoY5wQf36+wfZSV+un6f
         2cG/FXdzOdiNy7pXwws0OYaDPLHrtz2P/mwgEEwm8fVPlPpPIZ3aNcxKvFuMmkJbnfKK
         s9V0+l5X6BoDECrF8WAWz7KuAO0erIPDK+3wPzLFK53xtj4MW0GslukhsZcNCwmgxM34
         vD+wLEcQg6IspphnYB9mRs4VvYBpqIwdazHkPkZ2dRY1NhQRgCsrWSS2ZvE5kw68XlHL
         bh0VRN8zdlMsVwBPNG+Mzvvlt1xpog86XbAiRb8ujMrGQN4OgS3h7LnmSMMG7YwSrrE4
         cW+Q==
X-Gm-Message-State: AOJu0YzTtMovAJsRSfMtIH9LzKWSnz4RUdHlhMJmRxJ0naHHHVkBuIlo
	Tgs/rtvFwFJtSDMEZj+Y4tmg+l3LZUrzjURA/+lYditBrQ7O0Z49BqiLzvI7droWjINDE36ohwq
	Cb/PrdkhPq7dPr1OYhzVPQLKyHlslLofbx/7fd/iVu4ix1FEvHQ==
X-Gm-Gg: ASbGnctxBaS/0316a0x8R2wl9Vaf7JSuX5QlCghhWgN5FyhITYz7kJWRF1QX/Tg/nW9
	vPGQO4KhxaqRias5nw8KlSFXwioe/LX55IaMMtx88xaXdCWnIo+A/j7R2nzccEr60MNSs0wqnZE
	4IU0LT7Je3Lf3N1b1MgbPNAcbPOzfHSwz/Tu5ggnUMSZZ+8iFS5/2cfy6RMCD53yoi9+nY185L4
	LQQTDKytGOlENr+mbm51ii68HKif+eTUb+oYmFSmiwBeQ/cVH9Zz5dp
X-Received: by 2002:a05:6e02:23c2:b0:3a7:e592:55cd with SMTP id e9e14a558f8ab-3c012205493mr34305855ab.14.1734623974414;
        Thu, 19 Dec 2024 07:59:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7q4OCIWQObaDh6WJ2EVqupo9F0rdQ4zcibZ9hdNHcRzliO0WxMlnVTjBxChbpBhdW5C6RxQ==
X-Received: by 2002:a05:6e02:23c2:b0:3a7:e592:55cd with SMTP id e9e14a558f8ab-3c012205493mr34305675ab.14.1734623974083;
        Thu, 19 Dec 2024 07:59:34 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf64f29sm337134173.43.2024.12.19.07.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 07:59:33 -0800 (PST)
Message-ID: <e7d0218056d9df962bdea8322956e6ec78201515.camel@redhat.com>
Subject: Re: [PATCH 10/20] KVM: selftests: Keep dirty_log_test vCPU in guest
 until it needs to stop
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Thu, 19 Dec 2024 10:59:32 -0500
In-Reply-To: <f2f0fdcd52ed2b11b15a95a569306b3d820fec13.camel@redhat.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-11-seanjc@google.com>
	 <f2f0fdcd52ed2b11b15a95a569306b3d820fec13.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-12-17 at 19:01 -0500, Maxim Levitsky wrote:
> On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > In the dirty_log_test guest code, exit to userspace
> 
> Once again, "exit to userspace" is misleading.

OK, I understand now, this patch does make sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> 
> >  only when the vCPU is
> > explicitly told to stop.  Periodically exiting just to check if a flag has
> > been set is unnecessary, weirdly complex, and wastes time handling exits
> > that could be used to dirty memory.
> > Opportunistically convert 'i' to a uint64_t to guard against the unlikely
> > scenario that guest_num_pages exceeds the storage of an int.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c | 43 ++++++++++----------
> >  1 file changed, 22 insertions(+), 21 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index 8d31e275a23d..40c8f5551c8e 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -31,9 +31,6 @@
> >  /* Default guest test virtual memory offset */
> >  #define DEFAULT_GUEST_TEST_MEM		0xc0000000
> >  
> > -/* How many pages to dirty for each guest loop */
> > -#define TEST_PAGES_PER_LOOP		1024
> > -
> >  /* How many host loops to run (one KVM_GET_DIRTY_LOG for each loop) */
> >  #define TEST_HOST_LOOP_N		32UL
> >  
> > @@ -75,6 +72,7 @@ static uint64_t host_page_size;
> >  static uint64_t guest_page_size;
> >  static uint64_t guest_num_pages;
> >  static uint64_t iteration;
> > +static bool vcpu_stop;
> >  
> >  /*
> >   * Guest physical memory offset of the testing memory slot.
> > @@ -96,9 +94,10 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
> >  static void guest_code(void)
> >  {
> >  	uint64_t addr;
> > -	int i;
> >  
> >  #ifdef __s390x__
> > +	uint64_t i;
> > +
> >  	/*
> >  	 * On s390x, all pages of a 1M segment are initially marked as dirty
> >  	 * when a page of the segment is written to for the very first time.
> > @@ -112,7 +111,7 @@ static void guest_code(void)
> >  #endif
> >  
> >  	while (true) {
> > -		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
> > +		while (!READ_ONCE(vcpu_stop)) {
> >  			addr = guest_test_virt_mem;
> >  			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
> >  				* guest_page_size;
> > @@ -140,14 +139,7 @@ static uint64_t host_track_next_count;
> >  /* Whether dirty ring reset is requested, or finished */
> >  static sem_t sem_vcpu_stop;
> >  static sem_t sem_vcpu_cont;
> > -/*
> > - * This is only set by main thread, and only cleared by vcpu thread.  It is
> > - * used to request vcpu thread to stop at the next GUEST_SYNC, since GUEST_SYNC
> > - * is the only place that we'll guarantee both "dirty bit" and "dirty data"
> > - * will match.  E.g., SIG_IPI won't guarantee that if the vcpu is interrupted
> > - * after setting dirty bit but before the data is written.
> > - */
> > -static atomic_t vcpu_sync_stop_requested;
> > +
> >  /*
> >   * This is updated by the vcpu thread to tell the host whether it's a
> >   * ring-full event.  It should only be read until a sem_wait() of
> > @@ -272,9 +264,7 @@ static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
> >  /* Should only be called after a GUEST_SYNC */
> >  static void vcpu_handle_sync_stop(void)
> >  {
> > -	if (atomic_read(&vcpu_sync_stop_requested)) {
> > -		/* It means main thread is sleeping waiting */
> > -		atomic_set(&vcpu_sync_stop_requested, false);
> > +	if (READ_ONCE(vcpu_stop)) {
> >  		sem_post(&sem_vcpu_stop);
> >  		sem_wait(&sem_vcpu_cont);
> >  	}
> > @@ -801,11 +791,24 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  		}
> >  
> >  		/*
> > -		 * See vcpu_sync_stop_requested definition for details on why
> > -		 * we need to stop vcpu when verify data.
> > +		 * Stop the vCPU prior to collecting and verifying the dirty
> > +		 * log.  If the vCPU is allowed to run during collection, then
> > +		 * pages that are written during this iteration may be missed,
> > +		 * i.e. collected in the next iteration.  And if the vCPU is
> > +		 * writing memory during verification, pages that this thread
> > +		 * sees as clean may be written with this iteration's value.
> >  		 */
> > -		atomic_set(&vcpu_sync_stop_requested, true);
> > +		WRITE_ONCE(vcpu_stop, true);
> > +		sync_global_to_guest(vm, vcpu_stop);
> >  		sem_wait(&sem_vcpu_stop);
> > +
> > +		/*
> > +		 * Clear vcpu_stop after the vCPU thread has acknowledge the
> > +		 * stop request and is waiting, i.e. is definitely not running!
> > +		 */
> > +		WRITE_ONCE(vcpu_stop, false);
> > +		sync_global_to_guest(vm, vcpu_stop);
> > +
> >  		/*
> >  		 * NOTE: for dirty ring, it's possible that we didn't stop at
> >  		 * GUEST_SYNC but instead we stopped because ring is full;
> > @@ -813,8 +816,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  		 * the flush of the last page, and since we handle the last
> >  		 * page specially verification will succeed anyway.
> >  		 */
> > -		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
> > -		       atomic_read(&vcpu_sync_stop_requested) == false);
> >  		vm_dirty_log_verify(mode, bmap);
> >  
> >  		/*



