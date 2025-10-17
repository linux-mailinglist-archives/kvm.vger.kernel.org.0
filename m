Return-Path: <kvm+bounces-60349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3124ABEAEA9
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 950C07C4620
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E3B29B77C;
	Fri, 17 Oct 2025 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tLQVfkBp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BAE29B77E
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717905; cv=none; b=VZYbGP5lDFaLXxJTL2V6AvUQWJz/R/QLNHJgo5IRoffheobFFoRQQBme/Tcava8M8YoWWcsIB0lMXdZg1y0icb1r8MrTpxexT7u758sQ233EzDIgQKTNgaft2lNG7/sQwp1MqhJUrP0D6uyS1iKa1B6VHNeBXdjOy02f7+lpWgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717905; c=relaxed/simple;
	bh=dCo1MGrJD9Z3p+JSjI9DqLCn1a7bM1B+iqCsSzHDk9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZduhaE2wzzeLpuBAYzdFPkuV592mXv4gJEbtj/BJboEtL5JU51eW/coqZlAPADPu8Oi6Up0pCRgkOXVPWnhSpy/9mjVuNFOVtrKN4krR/EYCJO3YQ57GBFYlvU7JtNaYzPRH2m8ACdjuyvrOQpuab2KQbNL2yTbGkWp42LwQK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tLQVfkBp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc5bso2937229a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760717903; x=1761322703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h2EFLTX0PYpEWD6o7KiV0FgHN4LA5AiygCdXWH4JDp8=;
        b=tLQVfkBpLAaGNjHwtoPVFwOJETN6rUCRoY6D4s9S1LFW52BVYV2deK9rRDfJglugxu
         bAexH/r6WUZGOsCkWXaMBA2oB/MqLgvZcRcCo0OTIGcnsRQTqMaF6GGmSiYlJJ8XnSGW
         LC/7cPp9r/77iwuzewxMCDU4pMHQ8zQT2bU0fcLrFJrbXswY8cByQa4URn2cr6NAKHSf
         wuTydf7RRnUB9Y8ZLHkrXRl9PjAVGtCV8xH8NzDRT1nHx0q2noBB5ZfqbRu2sWa2za0a
         1ruJEABt9EhDgelN4b0XBEJ7Eok6aUgXRufQ87HyQtzSaPW2lE0pkX1+77CvajCsatxb
         52iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717903; x=1761322703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2EFLTX0PYpEWD6o7KiV0FgHN4LA5AiygCdXWH4JDp8=;
        b=mrCGvzwEJLGioqap0IY/N5XyJq2zQu15mLfjAJHyIhY4lpvtMRlC7l5R5RPaKeaDyo
         kW0WhKWq4TpRK7JSVWYLICo9Ah1UnDYJfGC1pn/ZHwTcBL+BTtS5ZyU1KrE67M4Iw8St
         sZYjoDRH1l2mZoIUM26lcKDDZjXUUDhPkrEKFFJMQ9+4rFxY4D2GPKg8tVbZWYYlxbh6
         Be3exVi3Ux3LBd8iEdKLR2wJ3FD7v8AcHLcPIcokzU7bVelXpnW8TsCCVYsfmkTJ20Ev
         DCBUh72ZG8ba7sV/hvKXAFEwTML+1KKiunF/z0KpZeGapL54l8mJ91KyHNlSZPdxT7lR
         PkfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFI9LwMa5YcjSsheadrj7COMAG59ClpFYJqiBTRtquBLYvzzSPRyX3dlT4xan2lCb57hY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZSgBpRg+kqavDPVFc8iD8dW6Fw0bv07d73qv6I+MiEPDGViul
	B7jjYrl8bvXwQH445wvRtpOBvyUYfJz2CpBKkNjwXW2L7ORkZR8uu7G4j78ZqnHhNR0VQIbc4iy
	3J2g8Yg==
X-Google-Smtp-Source: AGHT+IFaZEr2a3gvr9j34mwQCkJH9r0m1tq7ki6LSm2/57IK1g+qw40tWnhbdWwdpyVbTfr8muq81KAy8bI=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:332:5712:5242])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8b:b0:327:ba77:a47
 with SMTP id 98e67ed59e1d1-33bcf87b356mr4450218a91.15.1760717902777; Fri, 17
 Oct 2025 09:18:22 -0700 (PDT)
Date: Fri, 17 Oct 2025 09:18:21 -0700
In-Reply-To: <5303684f-3acf-402a-8154-a02a2194ce34@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <20251016172853.52451-10-seanjc@google.com>
 <5303684f-3acf-402a-8154-a02a2194ce34@amd.com>
Message-ID: <aPJsTVxajpP6-vKV@google.com>
Subject: Re: [PATCH v13 09/12] KVM: selftests: Use proper uAPI headers to pick
 up mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Shivank Garg wrote:
> 
> 
> On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> > Drop the KVM's re-definitions of MPOL_xxx flags in numaif.h as they are
> > defined by the already-included, kernel-provided mempolicy.h.  The only
> > reason the duplicate definitions don't cause compiler warnings is because
> > they are identical, but only on x86-64!  The syscall numbers in particular
> > are subtly x86_64-specific, i.e. will cause problems if/when numaif.h is
> > used outsize of x86.
> > 
> > Opportunistically clean up the file comment as the license information is
> > covered by the SPDX header, the path is superfluous, and as above the
> > comment about the contents is flat out wrong.
> > 
> > Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
> >  1 file changed, 1 insertion(+), 31 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
> > index aaa4ac174890..1554003c40a1 100644
> > --- a/tools/testing/selftests/kvm/include/numaif.h
> > +++ b/tools/testing/selftests/kvm/include/numaif.h
> > @@ -1,14 +1,5 @@
> >  /* SPDX-License-Identifier: GPL-2.0-only */
> > -/*
> > - * tools/testing/selftests/kvm/include/numaif.h
> > - *
> > - * Copyright (C) 2020, Google LLC.
> > - *
> > - * This work is licensed under the terms of the GNU GPL, version 2.
> > - *
> > - * Header file that provides access to NUMA API functions not explicitly
> > - * exported to user space.
> > - */
> > +/* Copyright (C) 2020, Google LLC. */
> 
> Given this file got a complete overhaul in this series, Should the copyright be 2020, 2025?
> Not entirely sure what the rules are for this.

Me either.  I just figure I can't really go totally wrong by doing nothing :-)

