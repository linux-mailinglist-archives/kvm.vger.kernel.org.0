Return-Path: <kvm+bounces-63105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6530C5AA3E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DF7F3AFE01
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA2F32C92A;
	Thu, 13 Nov 2025 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S1I3YAKE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06F131D380
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076945; cv=none; b=rJ3f0JneKSK8a3AGh7otqm4xUdFCCegZ+vhzKdpIi7FIQry+QpfLMvttN7HqW7tsCw7pJDEdDW5FIIcJTDz8esVKJQ5Dk3aQXEuQFYYt2pVk+LsPVskqq/ChHnjpQWx9o9uaVReeBG0gIc/EdA2LY8wiyz0NDRZCqYs+8yhuwCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076945; c=relaxed/simple;
	bh=iZwbsjBlUGB/L7Tt4aRhcCGUMR1cTPa3EF2l5Ki/nAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UYCv71vs93uEkJ/VxtfCWS++8AJ+YC1uQKmYUOBTit6EAvBW+QM+/NRYqHl+E8UnPigz8jISYt4TZ0pBxL8L8VzhvFdsVbtQ2MFKeaLuVrNadLegdUCKdbpfoK/WV4nYe+eaz5IuCW3U0jN9aoYD1q84AwNOSn9/FhjqsGuFmgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S1I3YAKE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29848363458so33820975ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763076943; x=1763681743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U9bY2qG6GLBD8ld0AXT/mnVjS4VslzGu1FqILp2o5yc=;
        b=S1I3YAKEZsS++gGiW8sOcYMb/z+O5sa7y3n8DBcn/d4nC2HNrrcvhdCMFq7CI7NZHx
         tm/71h4w9Z8HCfOisDmMCyLJc+yuKvBXDPAlv1PwXVo89zMvtdoCmJHMcql6wdbM25Ls
         nTHwLjdjpf8IK6gCsYC/3Nk0Gp+7u7o2uY3kroeqFn71vC6uyNIJhSX0hPvurP/Bx9sM
         eO4KHTPIdiadJukFXs2671wv0oetY6SIlQW8ugN/EOC1s7q2pWxrCA6DkXu4MXiZhzsR
         x54fti7caG0eQP3Cg1XG0MCjnUH4dzwzfUpKaU1JjwOBoPxPNpMQybcfv289iodKwll6
         oxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763076943; x=1763681743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U9bY2qG6GLBD8ld0AXT/mnVjS4VslzGu1FqILp2o5yc=;
        b=gINRlcuLnFa6GF0NhV18Ofye43dAOgKtXENgHCW80WnCFS7XQXqYVC/jM4Mb58CvO5
         Pa67QtSVHlfWZMFIGjGf1Vu52in6I4d595YQUePEmHaNdtigyvZihHi2aBDNaEVodCMm
         w8/v4z6jKuxM7xfERMcrUJMNPVre0Y+RS3Ike+Px5ZV96hpsuMmebbT6hkNgSLIjH0jG
         ND/05AL7S675hovh/T7wyJGaJhxham/S2a59X5YA7lJBzIVJXpAjgIpTR8YUkxPO3xvy
         wiHngCwkq0iwfrmz0AchiuPj7fE71j2Duj1zf/d5qmdhL0/raeF8H89jxI+akMXCLhwD
         0O2w==
X-Forwarded-Encrypted: i=1; AJvYcCWz12bCf9jegbGexigfRreGrkWvk4r31a0dt76GBQkgSANlo7xJcZwXMUZcdYm6ZCbeLc0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJOKZKMtuuX9kasHYGz2XQfxVeq9V8efb0EH21B1O8OfQyjIOK
	DtZHnbv3dPDm6e6cMQmc+a26X6MExzM+fii1Hy1a6/eHPMXWEnhNGDum28h03uwPvw/DSg3DzVX
	7mvxAZw==
X-Google-Smtp-Source: AGHT+IHiEXultMrBzWQBw6MQatdUadNItuUPOf3mN9tETlZpsd9HGNR80a/bTNqX66s75+oFG4xEuoH7iS4=
X-Received: from plcz19.prod.google.com ([2002:a17:903:4093:b0:297:d486:2aa3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e783:b0:262:cd8c:bfa8
 with SMTP id d9443c01a7336-2986a741baemr8297665ad.34.1763076943007; Thu, 13
 Nov 2025 15:35:43 -0800 (PST)
Date: Thu, 13 Nov 2025 15:35:41 -0800
In-Reply-To: <ellmjkhqmgpsbhc4if3emhn3fzbqd3ji4u2dnyvmub6bjgfnti@vtvjhn5cjwrs>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com> <20251113225621.1688428-4-seanjc@google.com>
 <ellmjkhqmgpsbhc4if3emhn3fzbqd3ji4u2dnyvmub6bjgfnti@vtvjhn5cjwrs>
Message-ID: <aRZrTdgOagDSjrUO@google.com>
Subject: Re: [PATCH 3/9] KVM: SVM: Add a helper to detect VMRUN failures
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Yosry Ahmed wrote:
> On Thu, Nov 13, 2025 at 02:56:15PM -0800, Sean Christopherson wrote:
> > Add a helper to detect VMRUN failures so that KVM can guard against its
> > own long-standing bug, where KVM neglects to set exitcode[63:32] when
> > synthesizing a nested VMFAIL_INVALID VM-Exit.  This will allow fixing
> > KVM's mess of treating exitcode as two separate 32-bit values without
> > breaking KVM-on-KVM when running on an older, unfixed KVM.
> > 
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 16 +++++++---------
> >  arch/x86/kvm/svm/svm.c    |  4 ++--
> >  arch/x86/kvm/svm/svm.h    |  5 +++++
> >  3 files changed, 14 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index ba0f11c68372..8070e20ed5a7 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1134,7 +1134,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
> >  	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
> >  
> > -	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
> > +	if (svm_is_vmrun_failure(vmcb12->control.exit_code))
> 
> This was flipped, wasn't it?

Ugh, yes.  Hrm, I'm surprised this wasn't caught by svm_nested_soft_inject_test.c.

Oof.  We should probably also extend svm_is_vmrun_failure() (in the future) to
detect any failure, e.g. VMEXIT_INVALID_PMC might be relevant soon?

> >  		nested_save_pending_event_to_vmcb12(svm, vmcb12);

