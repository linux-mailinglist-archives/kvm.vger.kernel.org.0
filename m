Return-Path: <kvm+bounces-37752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7A1A2FCDC
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B01F188841E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F434250BEF;
	Mon, 10 Feb 2025 22:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SN105Hcd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C453324C699
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739225830; cv=none; b=KCRHC0MkuT0wm56fFJw3NxgbvV+bUuKJrcC4DypH9PNjzpj30QFKxO2m2NGbr5W0taPDSALDlU7w4rOvwfZZOKH6FChC79n82JH3pO6M+RZvM51BO/EBfJvEPpyfQH9nNRGjfC/4NSO52O6NFu97GL+Wy2jH21kIDagIVhhLgpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739225830; c=relaxed/simple;
	bh=6lE5Mnx/T7Poj2YlCWXbpUyGGnjq5GAq+vZkbcngMo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ig1zDpuIS0PyckkjAbf67JcuuVW6Fz4zd6zgxhmlUwp9bOSnH7Xr2I9Mt2Fo8yh8hKOf70uoLHYeiQnDa6z/RUiFo3SUgim7fCp8oUtEjWiJ4DXZ44uWhLcp0j5gyoiB+qv4MgENWhU8QHLz8e5bzH69ZEVX2iAyFBA8HMDTQf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SN105Hcd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa38f90e4dso9313168a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 14:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739225827; x=1739830627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NiQktNxQxsAHB60qGvEjY4Wnpw2CpSJgOu9uKXQ/mCE=;
        b=SN105HcdZqBq3UL/IWci7pYMJ4YGTrlwiVO39EfCsQ4Ng9nLBigcN7izudPSGLvcJC
         hG16WI5bFgGoF7K3VyHsNQzlqrIBeX/qztOTWJDZzepY9fg31au59BW+4aKvsnxzISqh
         OvHf+OUA15jYXW/EkspkVu6b0kLOslBisBGZFK5KZDiBcUSDng7cR0tvbAd4CrwI7If6
         TRHPovVVvlVoxZYNtY3qI7LUnvQOaFL0fj7vUfXKQ5o8xSGd4AAVoiVHuVR2fnW0Ay56
         S6LR/wt9hGbtC5dce7u5PH5orrqK4MksMSpLFbRfgyIMkCRpeYQLokRxlt2812C+T6fX
         vKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739225827; x=1739830627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiQktNxQxsAHB60qGvEjY4Wnpw2CpSJgOu9uKXQ/mCE=;
        b=ugLT10tPbXOlkbfCiIKXs/Dd9FzjjOIh1uOqIS9WqM3IEno96uc1WqeDJqaxI/DmwL
         jJ4M6jA+/P/xRaRTKDPAR4DBPvabGHqPLvVzVOkmT0E4zfd5bnzNwjOGYmqZDnky4Xwi
         H9Fc7sGd5xIWHCh/r0PXCKtMdgeRgcAg4tHNZFXsYHBhv6zOdep0OoiArrMWI7ZVcl69
         C9C3cvXJV7w8kFKwZ3Wvh6/Osq63RdxbcNLT0kJvwyixPFfIg9COyrc5FhQvsvzSP/rp
         b/9clmUgZOEWuaZMygIVFcsUOYHpj4cvh8SPFo5/vMACFmTcV13uDHFIDyt1I9XxZ3S3
         K2uA==
X-Forwarded-Encrypted: i=1; AJvYcCWRILBFUOmEBoKeOg00UCmEVnetE5vKN6B32dTCHdeF68JgLWZzYv9xnonAzjb3QoKM40s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ/8gM4aF6XRBtsOsprdS51aMS4g4Yw2nkI7IzIe3d/YlJN0eB
	3I0XGdtod6GPObKAbHMb4z/z8dwHbGbRbRugKRUpyi/luiofMqIWXfwJKHbKoSuwHpxfl6QJSFN
	+Xw==
X-Google-Smtp-Source: AGHT+IFUr8B406UlqTbwQn8/a3DnwXEDSVRHSHvADMnY9/DAsyJd87DA1vBUl7os5VL41nbcjyiEKpkvFTw=
X-Received: from pjbnc15.prod.google.com ([2002:a17:90b:37cf:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3143:b0:2ee:b0b0:8e02
 with SMTP id 98e67ed59e1d1-2fa243f0272mr23783490a91.28.1739225827007; Mon, 10
 Feb 2025 14:17:07 -0800 (PST)
Date: Mon, 10 Feb 2025 14:17:05 -0800
In-Reply-To: <Z6bBoZOynhI3eV+Q@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207030640.1585-1-yan.y.zhao@intel.com> <20250207030810.1701-1-yan.y.zhao@intel.com>
 <Z6Yg0pORbMyC-9xA@google.com> <Z6bBoZOynhI3eV+Q@yzhao56-desk.sh.intel.com>
Message-ID: <Z6p64UaZnYg-qfNU@google.com>
Subject: Re: [PATCH 2/4] KVM: x86/tdp_mmu: Merge the prefetch into the
 is_access_allowed() check
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 08, 2025, Yan Zhao wrote:
> On Fri, Feb 07, 2025 at 07:03:46AM -0800, Sean Christopherson wrote:
> > On Fri, Feb 07, 2025, Yan Zhao wrote:
> > > Merge the prefetch check into the is_access_allowed() check to determine a
> > > spurious fault.
> > > 
> > > In the TDP MMU, a spurious prefetch fault should also pass the
> > > is_access_allowed() check.
> > 
> > How so? 
> > 
> >   1. vCPU takes a write-fault on a swapped out page and queues an async #PF
> >   2. A different task installs a writable SPTE
> >   3. A third task write-protects the SPTE for dirty logging
> >   4. Async #PF handler faults in the SPTE, encounters a read-only SPTE for its
> >      write fault.
> > 
> > KVM shouldn't mark the gfn as dirty in this case.
> Hmm, but when we prefetch an entry, if a gfn is not write-tracked, it allows to
> mark the gfn as dirty, just like when there's no existing SPTE, a prefetch fault
> also marks a gfn as dirty.

Yeah, but there's a difference between installing a SPTE and overwriting a SPTE.

> If a gfn is write-tracked, make_spte() will not grant write-permission to make
> the gfn dirty.
> 
> However, I admit that making the new SPTE as not-accessed again is not desired.
> What about below?
> 
> @@ -983,7 +983,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>                 return RET_PF_RETRY;
> 
>         if (is_shadow_present_pte(iter->old_spte) &&
> -           is_access_allowed(fault, iter->old_spte) &&
> +           (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
>             is_last_spte(iter->old_spte, iter->level))
>                 return RET_PF_SPURIOUS;

Works for me.

