Return-Path: <kvm+bounces-48307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C26ACCA28
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A91A63A33AD
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B0F23C51A;
	Tue,  3 Jun 2025 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EEXJxnfz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FC23C4F7
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748964518; cv=none; b=ceSAiksSk6qbgNDzZzgDqu2XU3ZpKDriyWLMMGIzc5FwwFXvSv/FRx5s64T689OizCHAziiKahedAydd84zdj0f4u58VBYlFDtkK3qTYYr9WzXqMQykPtHg+S3DF5fLX8tWXzleKG12Jb8pLohDuOhVsXeF/6FYXkqaaGC5SNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748964518; c=relaxed/simple;
	bh=qmPdDWSTOwTSot8fCLtTTdaZtqWsv6aeSE2dPEdSZEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AaflBpgXs/F5H0Z2u1Yzz473NjT1FThG54BFBvrh9xFyFFdlG4h4wotcnog36Sm3dm87StFmxHYE8Tx97GUoH3lxIhqU7eIEbnWgxp1UgqqR8UJDSAAjdrltgqvk2uYDpy2euYGBKR7wIDWwoN3NOSgBTR5qw4kAyn+kY6n7Me8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EEXJxnfz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25163so5325871a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748964516; x=1749569316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLkVKQg4yOg2dr4pMLuqSISZP1MeYrKX1y9HX2oJJOI=;
        b=EEXJxnfznvF6PkyQrsg6t6zCT5Y+JP9Gtl9maMIXLuOJiwF/3e3+i05qOce1l4+yfG
         57rxBTKD/9dD6/1Ga8ovC6ReMbJDNgpUUdIwbKWVo+u19/8efJBcxtyI9wZR2O01BE+D
         WuZ4hbIJxJZsrS/gKmXBoZTf9BTTBE4stvZywaxc4jkKb58G4MDBmXekQPiYgTcZQklV
         Y47H7ScInUNnRniigAbMdZMUBA9Qv/i1as6nUmbw00tLM0XDn/S5EVhpJklWaGLdyzbR
         fQMOCdFwjc3KwrzCvyjQse9iELXlGAdzUQzqhtpisZv7ky391MATVf7KTqEVDhROkuRI
         S+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748964516; x=1749569316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jLkVKQg4yOg2dr4pMLuqSISZP1MeYrKX1y9HX2oJJOI=;
        b=egO19cEFwimElS6/SwGG1H/DHWmAf0y4oKif+hBAS59djP3C74HRYpHuujosM5LsSx
         dBYbFAbGFlsxjRdJF1IFGdPbjVI62Xoxgq6hCSeudIhLLjSPdQML54dLsvYdUG7z7HeR
         RWkByO6jhLxDIcOYqOKpEsJplvDzazzaPSMrBUTd0zZZs+z5i0poU65ezdbL6P/VsgmL
         WvTRMKHXrXWxLGC6F/YWCmh5zmDM+tPOhx/YTyCvDblZrNRkaS3Q6S5NCHw+4iChQ+aX
         0PPKDBjZo8uJDJdqD3BY7dnh5rNFZW64n8w8ROcjntoilZtakFM830EQhTssUbKUh8a+
         s9dw==
X-Forwarded-Encrypted: i=1; AJvYcCVbsRBX1WZ9p7iwrRqeQPYvcDVx26L6gSelBM0kDpDqk6VPNeMvz73fMuJvuVroOznBprA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH4cXSVeutnFF1t8TqR/gbdksnNIz0NZTAs6z39Z+TmevVh/Dv
	4FlFjMF3upS+AwNVwA9HRrzT+/869mJQJhPFt/odGDqGviZCo2RtIQLn9/e9Yj/pPhqzm46U4a2
	kizMwmw==
X-Google-Smtp-Source: AGHT+IF82nqL2mUxTftf8FQtLee3AahcOHV8xncjfgA2yaeSu4fuvqQFrUW7Lah+3mDq1caaIw2qikGWIBw=
X-Received: from pjbqj7.prod.google.com ([2002:a17:90b:28c7:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c6:b0:312:3af8:d4fd
 with SMTP id 98e67ed59e1d1-31250413c8fmr27065472a91.18.1748964515892; Tue, 03
 Jun 2025 08:28:35 -0700 (PDT)
Date: Tue, 3 Jun 2025 08:28:34 -0700
In-Reply-To: <aD6hhTABOQstdlBL@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-2-seanjc@google.com>
 <aD6hhTABOQstdlBL@intel.com>
Message-ID: <aD8UolpjmE2zYOEB@google.com>
Subject: Re: [PATCH 01/28] KVM: SVM: Don't BUG if setting up the MSR intercept
 bitmaps fails
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 03, 2025, Chao Gao wrote:
> On Thu, May 29, 2025 at 04:39:46PM -0700, Sean Christopherson wrote:
> >WARN and reject module loading if there is a problem with KVM's MSR
> >interception bitmaps.  Panicking the host in this situation is inexcusable
> >since it is trivially easy to propagate the error up the stack.
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> >---
> > arch/x86/kvm/svm/svm.c | 27 +++++++++++++++------------
> > 1 file changed, 15 insertions(+), 12 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >index 0ad1a6d4fb6d..bd75ff8e4f20 100644
> >--- a/arch/x86/kvm/svm/svm.c
> >+++ b/arch/x86/kvm/svm/svm.c
> >@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
> > 	}
> > }
> > 
> >-static void add_msr_offset(u32 offset)
> >+static int add_msr_offset(u32 offset)
> > {
> > 	int i;
> > 
> >@@ -953,7 +953,7 @@ static void add_msr_offset(u32 offset)
> > 
> > 		/* Offset already in list? */
> > 		if (msrpm_offsets[i] == offset)
> >-			return;
> >+			return 0;
> > 
> > 		/* Slot used by another offset? */
> > 		if (msrpm_offsets[i] != MSR_INVALID)
> >@@ -962,17 +962,13 @@ static void add_msr_offset(u32 offset)
> > 		/* Add offset to list */
> > 		msrpm_offsets[i] = offset;
> > 
> >-		return;
> >+		return 0;
> > 	}
> > 
> >-	/*
> >-	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
> >-	 * increase MSRPM_OFFSETS in this case.
> >-	 */
> >-	BUG();
> >+	return -EIO;
> 
> Would -ENOSPC be more appropriate here?

Hmm, yeah.  IIRC, I initially had -ENOSPC, but switched to -EIO to be consistent
with how KVM typically reports its internal issues during module load.  But as
you point out, the error code isn't propagated up the stack.

> And, instead of returning an integer, using a boolean might be better since
> the error code isn't propagated upwards.

I strongly prefer to return 0/-errno in any function that isn't a clear cut
predicate, e.g. "return -EIO" is very obviously an error path (and -ENOSPC is
even better), whereas understanding "return false" requires reading the rest of
the function (and IMO this code isn't all that intuitive).

> > }
> > 
> >-static void init_msrpm_offsets(void)
> >+static int init_msrpm_offsets(void)
> > {
> > 	int i;
> > 
> >@@ -982,10 +978,13 @@ static void init_msrpm_offsets(void)
> > 		u32 offset;
> > 
> > 		offset = svm_msrpm_offset(direct_access_msrs[i].index);
> >-		BUG_ON(offset == MSR_INVALID);
> >+		if (WARN_ON(offset == MSR_INVALID))
> >+			return -EIO;
> > 
> >-		add_msr_offset(offset);
> >+		if (WARN_ON_ONCE(add_msr_offset(offset)))
> >+			return -EIO;
> > 	}
> >+	return 0;
> > }
> > 
> > void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
> >@@ -5511,7 +5510,11 @@ static __init int svm_hardware_setup(void)
> > 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
> > 	iopm_base = __sme_page_pa(iopm_pages);
> > 
> >-	init_msrpm_offsets();
> >+	r = init_msrpm_offsets();
> >+	if (r) {
> >+		__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
> 
> __free_pages(iopm_pages, order);

Oh, yeah, good call.

> And we can move init_msrpm_offsets() above the allocation of iopm_pages to
> avoid the need for rewinding. But I don't have a strong opinion on this, as
> it goes beyond a simple change to the return type.

I considered that too.  I decided not to bother since this code goes away by the
end of the series.  I thought about skipping this patch entirely, but I kept it
since it should be easy to backport, e.g. if someone wants make their tree more
developer friendly, and on the off chance the patches later in the series need to
be droppped or reverted.

