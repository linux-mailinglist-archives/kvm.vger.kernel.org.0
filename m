Return-Path: <kvm+bounces-22515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F6B93F992
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1FD2B2296C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B24E15A849;
	Mon, 29 Jul 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="imN75jyn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3866158A3C
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722267299; cv=none; b=dzYtMzGFtzwQvU7srAc8JsrC8Rh1uPVlGjsX1HaYhJyCiyMUt2yuofKsj7JqmffwuJ0FuBOyidNzwdQ3BHAnnzgBVVplFPR0CT2bhT5y2+xOR69IBy4vsFYIJUafZ6Pjtrrg7C+IEyMnwB+kAnsuD4PyQzyqkC4SUzYjIjKF8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722267299; c=relaxed/simple;
	bh=St2oF3CEhrw25LU2LpX/lf+cvRv7TUHNtWwkHL5vmIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kHz81aWaXMg8R0MOhXYm5NQ6DAwBxJ3ekGuzetxapltHy7JpJ2LFhvT1pQ4Num2SZHjGA1vo/iT50jGjbADvu0Ve8fteOnAgCa097UedB76GbCLgkpCxk3A++rbmPjHdtFMOJP1dq/dS3noB7Q2b4ly75iNQYu3hSCtlH7GZ9n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=imN75jyn; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66c0f57549fso73828017b3.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 08:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722267297; x=1722872097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5BO85kKfrP3kPw9rl6zi5w//RZnq6rehhthruUWfX8=;
        b=imN75jynXgiAfBZkddT5zvTOcnFaXG7xuErJuhRJi04wvvk0lfCB/2PYfdrcXjC6jL
         P25sAC4CoBn/aT+HnDa1AdcEVfSuTjyMmJrB6b4TdfJwqDJXWxyk0qwYH1up3fM35Ps7
         vJoUtxwSVvKVqKsHaCKna51H7kMsYEvUUs2FVF8kyweR3L+dfX97xAKhjPGPXBAOpq78
         YNPg7VL8ysu2ejAUr1elmYzNPwEMXV01DQbAMeVyR15uZ04pnxOdcA8jwnBfUgpLT9M1
         C/5eExUBi2EpWl7nxSAbiQkf5cyRM60eSq+3w09uBhsahQFIYt5Bc7TcdELyKUkF28uN
         cgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722267297; x=1722872097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5BO85kKfrP3kPw9rl6zi5w//RZnq6rehhthruUWfX8=;
        b=a6olc/rwdAecv6U5JsxAK0QU/0fKxyj6UA/RXOpFtsITLDj8/YiH8dJKm7SI85GV0v
         hhCRzTyo1/FvfW3RNidymdCEe6ksybIgALvbmE5ARR0HiMO9QphAfkK9q4t4EJoTWZM0
         jy3Ct36fBT2UZiqSnntfB/HYpK+pqdtaNQ+Ip409pgfpVP8RlueV6Jw4oMo6PZ025Kd+
         2+RxDF9X6JNlIkH9KJUWNVjnqUg5aLsnK+/LTSvvgzSSg4y58f6H41526T+WeDn6qioN
         oh2Rqw+McJGFp5UxcRBJ/YqNRIRblbLmkleRI4KKWsqf+vYaIvQyo0wytWuh9xgEvWCn
         RoxA==
X-Forwarded-Encrypted: i=1; AJvYcCUunX9/GmV3ExOzItBFF6dnTd4mvsLqCyDHU5VONonLK1MTCNC9tefqcrK15OlJRJQti/Q8nMcx6CqCR+WQFMkzHvD9
X-Gm-Message-State: AOJu0Ywum2Qe+3uv3zICqOeVDs+p9VOs+adNxZSEb1UNxXLAgHN5nlON
	0BCay1CZZjb3d7UiTWILAt4L9IoQykXaYSgtG90fKK7zKFtOb/vlXsDYM0/TTsHdyUFoKYTX0Ps
	Wfg==
X-Google-Smtp-Source: AGHT+IGGp7Xu/kWdEKL3yO6fLEKcGo5tqaTPTzr2R/VUyXOa/WPokijfHNwntnFNTXLNUiGFfxA29lz41fc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:14:b0:622:cd7d:fec4 with SMTP id
 00721157ae682-67a0a5185c6mr1924627b3.9.1722267297035; Mon, 29 Jul 2024
 08:34:57 -0700 (PDT)
Date: Mon, 29 Jul 2024 08:34:55 -0700
In-Reply-To: <f9b2f9e949a982e07c9ea5ead316ab3809e40543.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-41-seanjc@google.com>
 <030c973172dcf3a24256ddc8ddc5e9ef57ecabcb.camel@redhat.com>
 <Zox_4OoDmGDHOaSA@google.com> <f9b2f9e949a982e07c9ea5ead316ab3809e40543.camel@redhat.com>
Message-ID: <Zqe2n4e4HtdgUWgm@google.com>
Subject: Re: [PATCH v2 40/49] KVM: x86: Initialize guest cpu_caps based on KVM support
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 17:10 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0e64a6332052..dbc3f6ce9203 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -448,7 +448,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >                 if (!entry)
> >                         continue;
> >  
> > -               cpuid_func_emulated(&emulated, cpuid.function);
> > +               cpuid_func_emulated(&emulated, cpuid.function, false);
> >  
> >                 /*
> >                  * A vCPU has a feature if it's supported by KVM and is enabled
> > @@ -1034,7 +1034,8 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
> >         return entry;
> >  }
> >  
> > -static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
> > +static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func,
> > +                              bool only_advertised)
> 
> I'll say, lets call this boolean, 'include_partially_emulated', 
> (basically features that kvm emulates but only partially,
> and thus doesn't advertise, aka mwait)
> 
> and then it doesn't look that bad, assuming that comes with a comment.

Works for me.  I was trying to figure out a way to say "emulated_on_ud", but I
can't get the polarity right, at least not without ridiculous verbosity.  E.g.
include_not_emulated_on_ud is awful.

