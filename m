Return-Path: <kvm+bounces-34161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F019F7DC2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BD8D163480
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE0122655D;
	Thu, 19 Dec 2024 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HKKxdaTI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2322619B
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734621070; cv=none; b=CtUKuH8tmFAsfVmbPe78wRKoe1S4vjbYfQ7abAUskVMQxf+egU4eJlcvJG6kKEa7huXJ3t5CTHTvLQR8BLGSid4Uif9UW2SgmJ26CZ7nfiXyHWRdldvKNqw2Ey30HOsU40fdyH2mSXZOkP1wyUGdKYHei9S5WaI1AZorvIukcts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734621070; c=relaxed/simple;
	bh=yGTIs/EKjFkM6KUjXgNR/dSGhVhfIj5acfUAd2KLinI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SyF9iBA+9GQup4uNKUxJnVKNoQqmf7QRZ5SJzCaPs0MQCBiKyHfa7vZXsm9i0d5NxVqqZLBhL3fTQlwoagPyPimFe5XCRWW4LrEmPNMLWWziDUX6tYggVXOhr/1b9QYx0rABEp1co5QVYJtrjEKN0cxTo/lv9EAJNCHDwAOx6dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HKKxdaTI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734621067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iu7fhtXPcdFzC/hegaXQPvjqwvRi2n+6vI2yRsHarTI=;
	b=HKKxdaTIMXYhZmcwmyXTwWYOnwNBWrmQDbRRVT8bpskcR/5izW9kZSTyyheRTzh4fYMO+M
	ekloIiJSFy7p1O1YuC5LNG8IjUTk6fH1L4cxyajoU48FgLJl0akt7c9hmNjZrqPniXbbdL
	T5+i8XhFwkf1p2WhJj/9vKTqm2UjEbg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-VqD9EAkLNhan9XSZ-UR_rw-1; Thu, 19 Dec 2024 10:11:06 -0500
X-MC-Unique: VqD9EAkLNhan9XSZ-UR_rw-1
X-Mimecast-MFC-AGG-ID: VqD9EAkLNhan9XSZ-UR_rw
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a81570ea43so7416985ab.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734621065; x=1735225865;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iu7fhtXPcdFzC/hegaXQPvjqwvRi2n+6vI2yRsHarTI=;
        b=QrrzUpuDwrP8dipQSV8F9+jLz3X8KBeMWujA/WWPofp4Zwc1vBzPBl5dKhT/mspmgV
         m1QTybVyuqkrOrUhgP5Tl9DelOOmBFcsfSMp+3s9iD74gdeWXDlsmb4GELUz+u4ImjwP
         JMQFM7cOauIRXnHcmHAfDuOMhq1ub8YHlvm72UBZcuJkji9psDK2e1wzSkDnnhVJDUxw
         XoqnV0QMgFDC7qpg+nUpLcZQy3W6MrkiAMgzwRe7YP63byX4ZAC3vBAn6RaTVoxLKoEt
         OPopX5VpiZ3sYWvAKqWnZ6YZgW/vP9sEoQzls8t2kbUfn28+zI285bMecsodvehABY98
         l7IA==
X-Forwarded-Encrypted: i=1; AJvYcCVxv9OI4k0gIPYKH0xWwtH9Wzl6pS5DhNY4LvOSjo3mJu1y+gpcV6PcaRxQ3aTJlbXSt/8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyywjd2puwqozRbEm5G/bg5iYCDQonM5xP5u/OG4TKfkBL1CsZO
	uIZJOesHuqdVM406LqMJsMrIJVRRK2LynsQEvhlkRaCIdRnLjZirv4tYxTxBNlTM0yUb1HmrTqj
	mz9Kh+4+OocihCEh2Oor/c0Mmih3LzuS1MaVJAmkg787M/LOLgddpytqo1g==
X-Gm-Gg: ASbGncu3ZzmGZKTZYxiLSGndR1GcD4Pqv3O5zQr2HRkzrtcgafco0HCJdZ+6iClQ2Qu
	I6SHsq9qDwdtPAR9eE0P7hnv1YjBb8IcUsdlZ+68NTTU5CO3M55btC/D31YkpGrHyVN6wY7hV78
	VWrPJVmdHGw3RkgJKnvHqbWsJ7UWjQasIQSqGqz59NgC+YT+CifHD0efLjj4oAxEMk6uY0j1yqq
	V91tOwacWu/VU7FuJZsKi9L3Wpio1hOCG7aWzLUMDOvPK/0Z8xf77yc
X-Received: by 2002:a05:6e02:12cd:b0:3ab:1b7a:593e with SMTP id e9e14a558f8ab-3bdc4659f97mr75083255ab.19.1734621065046;
        Thu, 19 Dec 2024 07:11:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfj0tO6tQB6lCjORiyzYKcsLEPLUe8+lv6dV1/+NEgzmo1+7Uv6bzv3dCbpIvc8MYawsVBAg==
X-Received: by 2002:a05:6e02:12cd:b0:3ab:1b7a:593e with SMTP id e9e14a558f8ab-3bdc4659f97mr75082875ab.19.1734621064740;
        Thu, 19 Dec 2024 07:11:04 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf5073dsm322423173.29.2024.12.19.07.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 07:11:04 -0800 (PST)
Message-ID: <9d4aa4b90ee005683c14ddcaba28c11f35cf9e6b.camel@redhat.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Sync dirty_log_test iteration to
 guest *before* resuming
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Date: Thu, 19 Dec 2024 10:11:03 -0500
In-Reply-To: <Z2NAeH4wXTr-bvcb@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-3-seanjc@google.com>
	 <f91364794fd3d08e2eb142b53a4e18c5b05cb7c4.camel@redhat.com>
	 <Z2NAeH4wXTr-bvcb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-12-18 at 13:36 -0800, Sean Christopherson wrote:
> On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > > Sync the new iteration to the guest prior to restarting the vCPU, otherwise
> > > it's possible for the vCPU to dirty memory for the next iteration using the
> > > current iteration's value.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index cdae103314fc..41c158cf5444 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -859,9 +859,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >  		 */
> > >  		if (++iteration == p->iterations)
> > >  			WRITE_ONCE(host_quit, true);
> > > -
> > > -		sem_post(&sem_vcpu_cont);
> > >  		sync_global_to_guest(vm, iteration);
> > > +
> > > +		sem_post(&sem_vcpu_cont);
> > >  	}
> > >  
> > >  	pthread_join(vcpu_thread, NULL);
> > 
> > AFAIK, this patch doesn't 100% gurantee that this won't happen:
> > 
> > The READ_ONCE that guest uses only guarntees no wierd compiler optimizations
> > are used.  The guest can still read the iteration value to a register, get
> > #vmexit, after which the iteration will be increased and then write the old
> > value.
> 
> Hmm, right, it's not 100% guaranteed because of the register caching angle.  But
> it does guarantee that at most only write can retire with the previous iteration,
> and patch 1 from you addresses that issue, so I think this is solid?
> 
> Assuming we end up going with the "collect everything for the current iteration",
> I'll expand the changelog to call out the dependency along with exactly what
> protection this does and does not provide
> 
> > Is this worth to reorder this to decrease the chances of this happening? I am
> > not sure, as this will just make this problem rarer and thus harder to debug.
> > Currently the test just assumes that this can happen and deals with this.
> 
> The test deals with it by effectively disabling verification.  IMO, that's just
> hacking around a bug. 
> 

OK, let it be, but the changelog needs to be updated to state that the race is still
possible.

Best regards,
	Maxim Levitsky


