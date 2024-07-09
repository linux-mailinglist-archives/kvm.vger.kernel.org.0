Return-Path: <kvm+bounces-21233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8568D92C3DA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F591C21BEE
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC55182A66;
	Tue,  9 Jul 2024 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LzZZUQq6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE791B86EA
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552818; cv=none; b=jzdDPo/cvpCurdWna0GzvPuhzcYOiFoOkAAZCXaK/jAWHSxEcKplQg8OyyIC2DF5yOUfs5uqNpChrVtRjktHQNNabkzyM1ep9XsSJD33yKDp3B5L16ZgCc2pGdwmSnDzpLmsM7wBMxUV8aWJxlLno+q8wSA2OtNdPgYYZXUieHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552818; c=relaxed/simple;
	bh=Jd7JYArs/TQTl9HJPOsTQhWHLP8ss2/++lVqMXvlBTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ExEev6A+M2c52yyzL7EQkt6htWHzH7/zC5BXmp0UUEys9lzRIhcTryMxNK7B0qnnNZwTMq9Uh2WtO+bJH62ZJn2SVcuwVpCleenll9jX+qqi00dIRvI28odBfSfxQucMHy6pjwwyPKZy9YJgmoi90hSEIxFf4t27yzlKT+0MVT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LzZZUQq6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70b09eb46e4so3239598b3a.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720552817; x=1721157617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IM79Rr2lAgg14FLw9Gp3HGkX+qd75lNMrFkTPAixtTw=;
        b=LzZZUQq6+PLy475hFcPnAMwEYLpJIkQhGwBVxnz0bp9Cl9MTp7PGuQkO6j8y/zq0O3
         WwRcbSlmsbO9pmQTRU69JHkw+nSIGA33yLsaryR73kN5bEjdqxdcXXHZiEjoyDwLP2x9
         sav1dGIx0rOXwzPZ0erqDv6vk11KOnOwW8YDqTrokL1GIy5giFopmhI/bq1p44JUb+kP
         Lsdgu6OxM2Bpfb6MOhUckQW8/x6GDGd5pGjLDMwbEx8pLT1S+Nnux+TAlsX65r8YKrwU
         2Kyg+zCSLl2Ze3FYNx0GUzxfv0Boa4eME8yhRde9tdJzWVg9vy0anL4KBpaqjk0o7iFM
         ajYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720552817; x=1721157617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IM79Rr2lAgg14FLw9Gp3HGkX+qd75lNMrFkTPAixtTw=;
        b=EbS6rQXqvZ3V/efFjAJwFnKDo9C0htVjQT/GuH3V7QGkzNcPvuJB6X3mzSW9/Fyrxr
         zxDgT4bvdv3TpX1Ucj772vmBHgdKKcK0D3w7eAR8QvxxO7QqjSPEbMZ6ob8Fjq1gYlng
         /JYUsCZ84Ii+fgWpYIC9f/IZc2y/d5ZyP/olcp3yNstjdPQqCSKpea+yrOJl2weaPh9p
         7bah15KlcudyyAbSbe7Bm7tkkYKvoP6Fc7DZwAGibZ2G9I5SoxNzOFIU+CxHcmihe/3k
         7MWbfXi9XroipkzsUEhrzKKcQysfqtFxgwsq/As9FOUjjuGH4MXDoKWSjZvqwXlLN86f
         mjjg==
X-Forwarded-Encrypted: i=1; AJvYcCWbelnpOfz/hUPlA2PRFaxTw3OGp5BiimRabUw6oc63D4lqgXhHjSyNtxw/8EHzBAWWq+i8e/O2H1Bld0RZPJAcEksv
X-Gm-Message-State: AOJu0YzpRcGRunqke94rXNlmpOtiP8xEh7KyQxfvkNH1Mxi8fGgDTArE
	uaUZngREeewYn4flloUg4Q61uqm4UNAimeicNqtZmPeZsQ+SQ14qhf8kT/pfzNcdX6UuCCKIlJ5
	XGw==
X-Google-Smtp-Source: AGHT+IHjCzZBm4sD/zaZOSDAjam7OtFqBS8RR62dy/i69AnMU9kLpHwkOAF1xY0lQrXwJe2NTTNAMoj/EQs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3c86:b0:706:6b52:438c with SMTP id
 d2e1a72fcca58-70b4334e8c7mr291373b3a.0.1720552816587; Tue, 09 Jul 2024
 12:20:16 -0700 (PDT)
Date: Tue, 9 Jul 2024 12:20:15 -0700
In-Reply-To: <928f893e5069712a6f93c05a167cf43fa166777c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-47-seanjc@google.com>
 <928f893e5069712a6f93c05a167cf43fa166777c.camel@redhat.com>
Message-ID: <Zo2Nb653OcdDge9N@google.com>
Subject: Re: [PATCH v2 46/49] KVM: x86: Replace (almost) all guest CPUID
 feature queries with cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > +static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
> > +					    unsigned int x86_feature)
> >  {
> >  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> >  	struct kvm_cpuid_entry2 *entry;
> > +	u32 *reg;
> > +
> > +	/*
> > +	 * XSAVES is a special snowflake.  Due to lack of a dedicated intercept
> > +	 * on SVM, KVM must assume that XSAVES (and thus XRSTORS) is usable by
> > +	 * the guest if the host supports XSAVES and *XSAVE* is exposed to the
> > +	 * guest.  Although the guest can read/write XSS via XSAVES/XRSTORS, to
> > +	 * minimize the virtualization hole, KVM rejects attempts to read/write
> > +	 * XSS via RDMSR/WRMSR.  To make that work, KVM needs to check the raw
> > +	 * guest CPUID, not KVM's view of guest capabilities.
> 
> Hi,
> 
> I think that this comment is wrong:
> 
> The guest can't read/write XSS via XSAVES/XRSTORS. It can only use XSAVES/XRSTORS
> to save/restore features that are enabled in XSS, and thus if there are none enabled,
> the XSAVES/XRSTORS acts as more or less XSAVEOPTC/XRSTOR except working only when CPL=0)

Doh, right you are.

> So I don't think that there is a virtualization hole except the fact that VMM can't
> really disable XSAVES if it chooses to.

There is still a hole.  If XSAVES is not supported, KVM runs the guest with the
host XSS.  See the conditional switching in kvm_load_{guest,host}_xsave_state().
Not treating XSAVES as being available to the guest would allow the guest to read
and write host supervisor state.

I'll rewrite the comment to call that.

> Another "half virtualization hole" is that since we have chosen to not
> intercept XSAVES at all, (AMD can't do this at all, and it's slow anyway) we
> instead opted to never support some XSS bits (so far all of them, only
> upcoming CET will add a few supported bits).
> 
> This creates an unexpected situation for the guest - enabled feature (e.g PT)
> but no XSS bit supported to context switch it. x86 arch does allow this
> though.

