Return-Path: <kvm+bounces-32310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8EA9D533B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21433281FFF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72AE1D90BC;
	Thu, 21 Nov 2024 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OLhaRYtK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2B21D86E8
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215450; cv=none; b=kCBG0rT+th5OV7LY6KNo+Xt1jbx0X7hPqtItA0CEM4o8knPTiNeTa+SbUTSHHDp4Y7bcqL4Xtv20pYa2Yc27p9pi13+UFQpbL0bWUCKQ7S5ka5fSGVQHN6F9osas8K6EqSzqrxmeDGH6bJ+ys1zsb/kNxmPwD16x/RLWwiZdU18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215450; c=relaxed/simple;
	bh=SqxVB5S9ZnCXmJwg3D51+w4alkfmGLlr9ardQuDdsLk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJy372Nrf7chn7RYvdOSjk9vVTA9gkOOdiuSmT1q894Bw5trSwJQ8C1UfuIyY0nTfGVCE1QIG8nBwfz79K7qfP9Ln8TiipHwy8xZPfQnaCP5YqXPgfRZmCKo2KFVaIA5HS/b/wPi96NSupUCvNaWnBtlPnevsM7o90qGBskFjxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OLhaRYtK; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e38100afa78so2301463276.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215447; x=1732820247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qtljJXMaf+UWOpBKMnoIRrXFTJsECASm8jaTE6OQZlo=;
        b=OLhaRYtKBYtoKl8xugwH9pZFyLgIyz5kRDXmQb023WpiZ1kQStJyb2GdQ/oFIcZe/v
         SKdj1HGfcU47Vm9IRH+L3YLrsxa6jd5vmUaN2U/uwnZZh3RCMJbQz20/q3zkRRgt4NnP
         7x2HWR9tHIG9X4SP3DD8Qp+jP51uzz48ge7zEYLCNnzCUJFhhUIsurAeN6YeC0E3OnhP
         bgh1bmgQxspL1znlxbGPV12Zcnm/LOSeLh5Euk8NHKkKtc0uM70Q8iobopjeIZsLIo56
         hg1mDssrx3Zrm80gChfo9spAKK1cOxlp5YyMtE5w40dG5TU6t1sLzAd4vaqGnuSSCGjV
         T1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215447; x=1732820247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtljJXMaf+UWOpBKMnoIRrXFTJsECASm8jaTE6OQZlo=;
        b=lsmwGV6AeXwNYgvaikFKp+O/8aE2ph6Dj7fgCfz9XSQAjxHRKExQbJO4bNUDesQPE3
         P9NN05XFfQHUzTAK4s8PyecAraZ7EryU629kpaqbH81REHfDAeOOhAXnU9PM1f5K5GA7
         zob1LbBygQqgBmJoGo1LF/5iN7MTadakYk4APnDy7GNmBhvRRk0LjUWzGIfTOIQxKlRV
         11z/hULn0LgHBBmwiRhe4YRKBUoSziXqlZLowISc446R8k0s+oUKFpwA5q8Sz0xKqYHR
         kMsjFSYCv+/LFyERIQgyQvja+dMuODcHQJMkxBLsGrBd2Z2FEycnAguZYphTJGw08Ltc
         eSig==
X-Forwarded-Encrypted: i=1; AJvYcCW8zaovdmfTb2g2cCXkl5xSqcA0vSGpvheayDUtfsdDFb0GA6/FzqE9x0/9IkQXGZohTUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy73uOtivQ3OOCvJ5hrg9iyxl+NWxCPRhsKDhWW6t4SIPaOfz1v
	Q5OR/OKb+JwgEV4m6ZVGhZhTJNBruTqTz30A0L1XRgcDwI6+81bV2M8SRODYjDm+SvPSDnMxHlm
	HCA==
X-Google-Smtp-Source: AGHT+IFPhgD0+tZ8PuaJ5SHJ0gWlfVSVuDvUHEavOi5mjZNLvxVtFKB7zcRQ023335iVTGSmRK5UXkZAsBQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8811:0:b0:e38:b1c7:f48e with SMTP id
 3f1490d57ef6-e38cb533507mr11963276.1.1732215447374; Thu, 21 Nov 2024 10:57:27
 -0800 (PST)
Date: Thu, 21 Nov 2024 10:57:26 -0800
In-Reply-To: <3aeeed2f4ccca6ddd404553984f22bf1b72e45cf.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-6-seanjc@google.com>
 <6a8aee9425a47290c7401d4926041c0611d69ff6.camel@redhat.com>
 <Zow_BmpOGwQJ9Yoi@google.com> <3aeeed2f4ccca6ddd404553984f22bf1b72e45cf.camel@redhat.com>
Message-ID: <Zz-ClqMVuOrFlIZK@google.com>
Subject: Re: [PATCH v2 05/49] KVM: selftests: Assert that the @cpuid passed to
 get_cpuid_entry() is non-NULL
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 19:33 +0000, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > > Add a sanity check in get_cpuid_entry() to provide a friendlier error than
> > > > a segfault when a test developer tries to use a vCPU CPUID helper on a
> > > > barebones vCPU.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > > > index c664e446136b..f0f3434d767e 100644
> > > > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > > > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > > > @@ -1141,6 +1141,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
> > > >  {
> > > >  	int i;
> > > >  
> > > > +	TEST_ASSERT(cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
> > > > +
> > > >  	for (i = 0; i < cpuid->nent; i++) {
> > > >  		if (cpuid->entries[i].function == function &&
> > > >  		    cpuid->entries[i].index == index)
> > > 
> > > Hi,
> > > 
> > > Maybe it is better to do this assert in __vcpu_get_cpuid_entry() because the
> > > assert might confuse the reader, since it just tests for NULL but when it
> > > fails, it complains that you need to call some function.
> > 
> > IIRC, I originally added the assert in __vcpu_get_cpuid_entry(), but I didn't
> > like leaving get_cpuid_entry() unprotected.  What if I add an assert in both?
> > E.g. have __vcpu_get_cpuid_entry() assert with the (hopefully) hepful message,
> > and have get_cpuid_entry() do a simple TEST_ASSERT_NE()?
> > 
> 
> This looks like a great idea.

Circling back to this, I actually like your initial suggestion better.  Asserting
in get_cpuid_entry() is unnecessary paranoia, e.g. it's roughly equivalent to
asserting that any and all pointers are non-NULL.   The __vcpu_get_cpuid_entry()
assert though makes a lot more sense, because it's not all that obvious that
vcpu->cpuid is (usually) initialized elsewhere.

