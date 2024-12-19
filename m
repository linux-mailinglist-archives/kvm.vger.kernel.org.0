Return-Path: <kvm+bounces-34160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A68119F7DAB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC0D1889234
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B6022757B;
	Thu, 19 Dec 2024 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkfWZsNI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2B226899
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734620845; cv=none; b=aA7953uwaIoQ4y+9FD/sFMjfzEhTPX4lt4TWOYwQiCTPCDlubLbIwxiSSO7Fm42AUpFs7ZHWHZOp7sH6Tm0iXcGeLYWbYVaBHlHjkGyglBmXomlUTlbuN/ONHVHBufmx5QSpjlNs6HbSo7sC3c/aAO4j2kZcVFMQRBUi5jyjSbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734620845; c=relaxed/simple;
	bh=8irCQirKPQiFAzbtbNv0AfV7e384HfZBF8nMbyJIdRM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O6iGEnlC4CvbaC75CWoBFt+MlRpXvTKBOfptyhm1a9OoTcZC5hS2N3eguzXaTwywARYJdDJNjZIuO0l9ipEWNuT5kgeveSJMhNvce/0wt9dHwouuwQuWbe5IffNexXskh2hDHap0c6T8iheHmBJ8aOkGXXl20nqwgG/ht2Hv+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FkfWZsNI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734620843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+DIRGNjZXJHlxz/hC3BMQtq/IRnJsZSFVmCnegRI9o=;
	b=FkfWZsNIDuifLEWQviaqMBFqZkETLjPLn9VziLUZQb11xf/jh7EkJqCx94eopognrAIN+A
	hVSLlfAnVIHtdJi43SMT81Nu3io/lRwuI7ZcRpIsxV06M1LZepEZZ+WWy4lakCWSYzZcGd
	AojEOSswwcwiMi5p/Vqcbx2SnKjl0+I=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-yj6fixkwPGyPS9BaJP9LIg-1; Thu, 19 Dec 2024 10:07:22 -0500
X-MC-Unique: yj6fixkwPGyPS9BaJP9LIg-1
X-Mimecast-MFC-AGG-ID: yj6fixkwPGyPS9BaJP9LIg
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a81777ab57so7324715ab.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:07:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734620840; x=1735225640;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+DIRGNjZXJHlxz/hC3BMQtq/IRnJsZSFVmCnegRI9o=;
        b=Lv3F8qGFn82v3RAOsq6pJ0TiizebfCoUqww9DgxJ5kusYHanISV83GEgeElOMhQJ7y
         y6NW1zRmd6sJwpCU9rN6K8nDBwKoclKyXo5/YjxGffbSo5RIWtQcpnb9VVbPCNSe8mTM
         1FV2NaRPJUIK7GlHYa1XmO9TM+UzX/tGzi15h/GU1XlrEV+aXXh85OZg+ujE4kRtd4au
         HdLsUe7QkqzdoMvtHEGij4XfVQKTaIlFaS2e2XjiY6TnGelqJ8RqN1Cu8rY0RMmZ2lCU
         /pRKFm9DoRTphYSrz3muULBoL2E9AL3sY83ZWZTF49feoaesD47PYqXKNYD6FJy6AiRY
         8IGw==
X-Forwarded-Encrypted: i=1; AJvYcCVbZfqDrdOjoy6H27vjNu04H3WnPtiuboR39RnI52WOeTy/6bw58R+Q3r9V3kBxNZ92/+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBuAt1Xi58CddUaouSvUc3ZrFSvbvtJhEsgizdiMeKZ3N48o+J
	kvFKFsiliO362CbSLlBgfG6K2g9otDFOp5BvAX7HKqgoHAtip994yBKq1ZXj/gxobfEibJEaehj
	b8eirZJbr6YK8oJQuQReXkpx+LlgZV29P69DOaCfx+rOJCcztRg==
X-Gm-Gg: ASbGncuDGF9uQWBsp1+0Fz6Z2Gy21mADNPgin+b/EHZ7pZDPx7e8EVu89AOc+O1t6iz
	yri0jcpNBVo2bo9Q+hY5ge5Vq1QWZLTAEY25AsmEiyfFMz3LtOL+MMxpVTFnfa+YSLla/SzEhO0
	UobsW636MvOc0n2C5qIJ3InSov83W6rqLketGniGWfdw9v4mqrzOSrgIV2RD0ooJNk+V/Qn2hKg
	T+ZSdFJylr5MCcV3XZNEwnXzjkttE4NdUHcNW0fUyUYqzo454EcylEm
X-Received: by 2002:a05:6e02:1807:b0:3a7:e4c7:ad18 with SMTP id e9e14a558f8ab-3c013de6b31mr34676275ab.18.1734620840228;
        Thu, 19 Dec 2024 07:07:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7TsF4vRYF+HgMSRVu32kDJQ7SkIY4/XQCsiiMpEKQxJRRcypopHZTFbdGQnXejkYo7wEXsw==
X-Received: by 2002:a05:6e02:1807:b0:3a7:e4c7:ad18 with SMTP id e9e14a558f8ab-3c013de6b31mr34675915ab.18.1734620839885;
        Thu, 19 Dec 2024 07:07:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c19990fsm317691173.80.2024.12.19.07.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 07:07:19 -0800 (PST)
Message-ID: <faccf4390776ca78da25821e151a4827b1f8b3a9.camel@redhat.com>
Subject: Re: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty
 ring test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Date: Thu, 19 Dec 2024 10:07:18 -0500
In-Reply-To: <Z2N-SamWEAIeaeeX@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-10-seanjc@google.com>
	 <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
	 <Z2N-SamWEAIeaeeX@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-12-18 at 18:00 -0800, Sean Christopherson wrote:
> On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > > Now that the vCPU doesn't dirty every page on the first iteration for
> > > architectures that support the dirty ring, honor vcpu_stop in the dirty
> > > ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
> > > allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
> > > periodically exit to userspace just to see if it should stop.
> > 
> > This is very misleading - by the very nature of this test it all runs in
> > userspace, so every time KVM_RUN ioctl exits, it is by definition an
> > userspace VM exit.
> 
> I honestly don't see how being more precise is misleading.

"Exit to userspace" is misleading - the *whole test* is userspace.

You treat vCPU worker thread as if it not userspace, but it is *userspace* by the
definition of how KVM works.

Right way to say it is something like 'don't pause the vCPU worker thread when its not needed'
or something like that.

Best regards,
	Maxim Levitsky


>   I'm happy to reword
> the changelog, but IMO just saying "exit" doesn't make it clear that the goal is
> to avoid the deliberate exit to the selftest's userspace side of things.  The
> vCPU is constantly exiting to KVM for dirty logging, so to me, "periodically exit
> just to see if it should stop" is confusing and ambiguous.
> 
> > > Add a comment explaining that marking all pages as dirty is problematic
> > > for the dirty ring, as it results in the guest getting stuck on "ring
> > > full".  This could be addressed by adding a GUEST_SYNC() in that initial
> > > loop, but it's not clear how that would interact with s390's behavior.
> > 
> > I think that this commit description should be reworked to state that s390
> > doesn't support dirty ring currently so the test doesn't introduce a regression.
> 
> Can do.
> 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/dirty_log_test.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index 55a385499434..8d31e275a23d 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -387,8 +387,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
> > >  
> > >  	/* A ucall-sync or ring-full event is allowed */
> > >  	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
> > > -		/* We should allow this to continue */
> > > -		;
> > > +		vcpu_handle_sync_stop();
> > >  	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
> > >  		/* Update the flag first before pause */
> > >  		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
> > > @@ -697,6 +696,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >  #ifdef __s390x__
> > >  	/* Align to 1M (segment size) */
> > >  	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
> > > +
> > > +	/*
> > > +	 * The workaround in guest_code() to write all pages prior to the first
> > > +	 * iteration isn't compatible with the dirty ring, as the dirty ring
> > > +	 * support relies on the vCPU to actually stop when vcpu_stop is set so
> > > +	 * that the vCPU doesn't hang waiting for the dirty ring to be emptied.
> > > +	 */
> > > +	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
> > > +		    "Test needs to be updated to support s390 dirty ring");
> > 
> > This not clear either, the message makes me think that s390 does support dirty ring.
> > The comment above should state stat since s390 doesn't support dirty ring,
> > this is fine, and when/if the support is added,then the test will need to be updated.
> 
> How about this?
> 
> 	/*
> 	 * The s390 workaround in guest_code() to write all pages prior to the
> 	 * first iteration isn't compatible with the dirty ring test, as dirty
> 	 * ring testing relies on the vCPU to actually stop when vcpu_stop is
> 	 * set.  If the vCPU doesn't stop, it will hang waiting for the dirty
> 	 * ring to be emptied.  s390 doesn't currently support the dirty ring,
> 	 * and it's not clear how best to resolve the situation, so punt the
> 	 * problem to the future.
> 	 */
> 	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
> 		    "Test needs to be updated to support dirty ring on s390; see comment for details");
> 



