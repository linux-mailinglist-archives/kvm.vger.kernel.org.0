Return-Path: <kvm+bounces-34091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF0A9F726D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AD0A1657E7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D708632A;
	Thu, 19 Dec 2024 02:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5hkpfaP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F15D477
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734573644; cv=none; b=e0Odf5oEcqvAdvC9OdCZe1L37LrWJHrrvrYZu6R/WfNXW15JK1fTJnnU62wJCWO+/MidB/igzcZT4dnR1i17+Be2ey3O7r2Ijt8sFjU4JdOPdspaIYAchanEJ1Q49iMjPdfpD9OkAsMFKmgHkhX+THNg89ISfj0P7TdGSWQdBEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734573644; c=relaxed/simple;
	bh=6iYk8tp5iweUqouZM32221VfsqlAj53R/0rXDWBMNos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AxN/Ae2dNeafU44oDOo7CJ4SDloM15hrLYzHOI9I/nVP/ZteXpQeeMStmoPvW0Q9q7cmpwXcNH1eLk9rxfQiGNHVfc5ilJVOQHRhwv5Hycum1nlydHMM45lvXcHwHvIzTUkYOGQWR3KdCIa5LuUK3fHxIlYN1qkQcer9KE3X+gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T5hkpfaP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725e3c6ad0dso470051b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734573643; x=1735178443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ+L7roE6KPgJ2ylxUuiDIvrT0uuzVazgLVoAcXK3UA=;
        b=T5hkpfaPmT6Swa4Fi4eV/RQOOVpg78HRoZGhlAZCAGBQajmtGQ6IF7eBYxPmbhdUEf
         lAJ3ZhGTQVCMBGmWfRFPKWOiIx8t8gDeQH97MNTmITV9sHslZBjeTLjy87t3Nu1acNzJ
         FhMvTa3K+vheuuUZ+LWvWyPBZeKqxAwYXYGdTaOR/WfpOyeKEfa5lYNZAtQyFc4xS0/v
         ONtrqRN1A1RrjBSoHxWjcMZmnQlpv7V0bGbMWYRVx+3Q9f0KzLiimXatVdmOrbguOpWV
         loMYsfknsH571/c3p1GgXlM4Ndxp7rgMEUo2TrbVQZgaZVVnvZMHRfpIv3h42Cf0X9jj
         gqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734573643; x=1735178443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ+L7roE6KPgJ2ylxUuiDIvrT0uuzVazgLVoAcXK3UA=;
        b=bk5NGvBUfTVr00vy4SdT5Vj+XJJkYOXBXvXb02zpn8bb3vTy1ubJLtWrP646p2nIk8
         9giFV4Q3G6SlyBleTVWAQzF0jqLcsPNPpl6X/xWnNxVTfUp7EI/YGypRy176gAnAKe3f
         5S/6QrZnIQ8ELgTZl8wSUpe8DmbgjLrrH71OkFCsZ9dCLEZ7ktszsJzYFmI9RJvhgTLg
         lwfE566y7Wb7s6DfPIq1i4Qc/3v41mJLmgM0Ye/4h0AAeGli37XvG4z4BCT4BWBuUcF4
         7nSEO4/+GlPNsGvRw6PBung7xauSa0Ruzo9Zbv0dITyrvt8ccECkH5dquqJiO4IgFO8K
         29KQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA8m/g1hQE36EwMfYIj5rza/SiekVEtxazlz1oOU0sGDgut6DQYvYzIUkfdjSRSdzdMvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKQIGQSoPXqnyMjqw+Ak2DDNc+mnCDcp1dF3SVRSMHzJ7Y2Iwb
	Eitep2WOg32wNgPWH3G7X0AdnEYdWkGCaP1iz3yS/lf/3xfUMlpIIImbT0H1gfdTtlqSNI434KG
	Z3A==
X-Google-Smtp-Source: AGHT+IHXDAFCOLOJhGyMBJ/ocAQLcV6zAn1gzs2qkd9IFQrbChcdoamBSPIVwkZukDIfKOv3n2sIwUsU3b0=
X-Received: from pgbfu11.prod.google.com ([2002:a05:6a02:4a8b:b0:7fd:5569:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1582:b0:1e0:d6d5:39c3
 with SMTP id adf61e73a8af0-1e5b45ff7camr9297733637.8.1734573642615; Wed, 18
 Dec 2024 18:00:42 -0800 (PST)
Date: Wed, 18 Dec 2024 18:00:41 -0800
In-Reply-To: <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com> <20241214010721.2356923-10-seanjc@google.com>
 <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
Message-ID: <Z2N-SamWEAIeaeeX@google.com>
Subject: Re: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty ring test
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > Now that the vCPU doesn't dirty every page on the first iteration for
> > architectures that support the dirty ring, honor vcpu_stop in the dirty
> > ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
> > allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
> > periodically exit to userspace just to see if it should stop.
> 
> This is very misleading - by the very nature of this test it all runs in
> userspace, so every time KVM_RUN ioctl exits, it is by definition an
> userspace VM exit.

I honestly don't see how being more precise is misleading.  I'm happy to reword
the changelog, but IMO just saying "exit" doesn't make it clear that the goal is
to avoid the deliberate exit to the selftest's userspace side of things.  The
vCPU is constantly exiting to KVM for dirty logging, so to me, "periodically exit
just to see if it should stop" is confusing and ambiguous.

> > Add a comment explaining that marking all pages as dirty is problematic
> > for the dirty ring, as it results in the guest getting stuck on "ring
> > full".  This could be addressed by adding a GUEST_SYNC() in that initial
> > loop, but it's not clear how that would interact with s390's behavior.
> 
> I think that this commit description should be reworked to state that s390
> doesn't support dirty ring currently so the test doesn't introduce a regression.

Can do.

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index 55a385499434..8d31e275a23d 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -387,8 +387,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
> >  
> >  	/* A ucall-sync or ring-full event is allowed */
> >  	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
> > -		/* We should allow this to continue */
> > -		;
> > +		vcpu_handle_sync_stop();
> >  	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
> >  		/* Update the flag first before pause */
> >  		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
> > @@ -697,6 +696,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  #ifdef __s390x__
> >  	/* Align to 1M (segment size) */
> >  	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
> > +
> > +	/*
> > +	 * The workaround in guest_code() to write all pages prior to the first
> > +	 * iteration isn't compatible with the dirty ring, as the dirty ring
> > +	 * support relies on the vCPU to actually stop when vcpu_stop is set so
> > +	 * that the vCPU doesn't hang waiting for the dirty ring to be emptied.
> > +	 */
> > +	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
> > +		    "Test needs to be updated to support s390 dirty ring");
> 
> This not clear either, the message makes me think that s390 does support dirty ring.
> The comment above should state stat since s390 doesn't support dirty ring,
> this is fine, and when/if the support is added,then the test will need to be updated.

How about this?

	/*
	 * The s390 workaround in guest_code() to write all pages prior to the
	 * first iteration isn't compatible with the dirty ring test, as dirty
	 * ring testing relies on the vCPU to actually stop when vcpu_stop is
	 * set.  If the vCPU doesn't stop, it will hang waiting for the dirty
	 * ring to be emptied.  s390 doesn't currently support the dirty ring,
	 * and it's not clear how best to resolve the situation, so punt the
	 * problem to the future.
	 */
	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
		    "Test needs to be updated to support dirty ring on s390; see comment for details");

