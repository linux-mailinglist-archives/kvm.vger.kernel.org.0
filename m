Return-Path: <kvm+bounces-48741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C9EAD20F0
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 16:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D2D03A9116
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 14:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A8B25D90C;
	Mon,  9 Jun 2025 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNGVlTLA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC43225D209
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749479647; cv=none; b=omitYNsVAZQj/VL5C8YnWxFxBprLSZNUu8c256ezYqVWXyfyROAD93qwaV0oDhd1FaMG3T0Nhv6vGRbyhlBA1AXbvYZTD17sWrltmSMuFDzhRF1ezTkNDJUpqL3/QbRR7nQ0FPkb+jfe5PjPWaTnLY9GUW8ajo1J5AfljhGNxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749479647; c=relaxed/simple;
	bh=RncucRipf1cYTuMs00M4ActoK6bvKzfNJNtvT9JpgjU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkyMZTiIyzox37V7GkaXBz8rRK7CwPWW0ntxHkocDXFlvz2iNUTAM5dz1FlUTHy0KzvyFc0u8cIoeKqg0v92kO9S+VwTICCecYwBXnqch7rkEdw/527jVtJJ5SBzaAiv99TvFsbhjcrr8owPIEpiO/icZb9Jqx70ERCQb1oWR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNGVlTLA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234aceaf591so29514565ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 07:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749479645; x=1750084445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=skrVgnKxd0KDctgtNsrczTFq3oqZuzABurM/ZDk3Ink=;
        b=tNGVlTLAOWVhh49MatYphHt8c38PXeIXC/VlqluEaGDCaoyMJqVzC66HbKX7dnIciH
         0PGoW11+LTlJaPuNgr72xM74cHpJJlgoUrAhEKIDBHCNDumx7T3cqAAkYiYSz9umdvd6
         kmZNaJ5To8WX0ozlVBlRWrfhJ3a92+7UAlxZr/NJzam14jVHklQ532oHIGlYi0Ok/Mzs
         Nq4VrgdsXK1fLnnkmsPK8l1DyGNrromCWfsrO934lBnczO0qHs3RFnoFkz8pNDt4nbMC
         ZONo2klPV1pEDG0x5E7WXJXaakcJM99AclD53gZJ24apACkzx17/9LVDmGt7crsgw3Du
         yLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749479645; x=1750084445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skrVgnKxd0KDctgtNsrczTFq3oqZuzABurM/ZDk3Ink=;
        b=veKsN8QwpDU/sSwjbCFP59HPlZRLSLDGXgOfn4DVd4EmxaktckughhplLe0rFii5QZ
         QM//dGL9zrxjt+W4Pu9Zx2QGZNMLMaqDOwdBTLz6mK/aif1SbXQZSFDqpu1Ljwj8oapX
         n/PBpEoozQtagjcCbVQaHYveHAfROTq0pkijppCv0jRxz2xor+LXg9C6VRj86nexQMbW
         uUe5rQuRZbmB57IwDwSXSSIX7Gn5269Ya9yOuNeu3aNlDOp0O5PEq551IwtH0EEfnD5O
         qqGGJSLLgx2xJxycXBmj8MoqzWugqBDHLPXfnEin9qxFaGnEGPdP8XtioN9lIQgP5ple
         AKkA==
X-Forwarded-Encrypted: i=1; AJvYcCWLrcetCzOoegc6i8yHCrXId6sXOMobEWG5yveqWk5+/2NUhygqyZfkJSuYOnOaV1YzkWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAPp2PFPmdvH0XhECzx4evsORrZYmlUlTEZs26GkBEJRqFS8hs
	pvwtHq0bZ6uWj+bQOggMReGu1+H81mh8HaoGcg/etkHOJ8voRuYE+mVltW+BEQC7elE/Ds6t7WJ
	N/8Eqjw==
X-Google-Smtp-Source: AGHT+IG0JGW+2ERvh9VAKD2SYT7EuVC5l/3/Q6a8vdYy73LZU6rmVVJeO2/2xeSR1j2Z/GlfjJU6yRXE7Fs=
X-Received: from pjbsg3.prod.google.com ([2002:a17:90b:5203:b0:30e:6bb2:6855])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c950:b0:234:b430:cea7
 with SMTP id d9443c01a7336-23601cff140mr191326735ad.22.1749479645053; Mon, 09
 Jun 2025 07:34:05 -0700 (PDT)
Date: Mon, 9 Jun 2025 07:34:03 -0700
In-Reply-To: <20250609122050.28499-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com> <20250609122050.28499-1-sarunkod@amd.com>
Message-ID: <aEbw2zBUQwJZ3D98@google.com>
Subject: Re: [PATCH v2 00/59] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: baolu.lu@linux.intel.com, dmatlack@google.com, dwmw2@infradead.org, 
	francescolavra.fl@gmail.com, iommu@lists.linux.dev, joao.m.martins@oracle.com, 
	joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mlevitsk@redhat.com, pbonzini@redhat.com, vasant.hegde@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 09, 2025, Sairaj Kodilkar wrote:
> Hi Sean,
> 
> Sorry for the delay in testing. All sanity tests are OK. I reran the performance 
> test on the V2 and noticed that V2 has significantly more GALOG entries than V1
> for all three cases. I also noticed that the Guest Nvme interrupt rate has
> dropped for the 192 VCPUS.

Hmm, I don't see any obvious bugs or differences (based on a code diffed between
v1 and v2).  I'll poke at the GALogIntr behavior just to double check, but my
guess is that the differences are due to exernal factors, e.g. guest behavior,
timing, scheduling, etc.

IOPS are all nearly identical, so I'm not terribly concerned.
 
> I haven't figured out what is causing this.

Might just be slight differences in guest behavior?  E.g. did you change the guest
kernel?  

> I will continue my investigation further.
> 
>                           VCPUS = 32, Jobs per NVME = 8
> ==============================================================================================
>                                          V2                         V1          Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts               124,260,796                 124,559,110             -0.20%
> IOPS (in kilo)                            4,790                       4,796             -0.01%

Uber nit, the percent change should be -0.10%

> GALOG entries                              8117                         169              4702%
> ----------------------------------------------------------------------------------------------
> 
> 
>                           VCPUS = 64, Jobs per NVME = 16
> ==============================================================================================
>                                          V2                         V1          Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts              102,394,358                   99,800,056             2.00% 
> IOPS (in kilo)                           4,796                        4,798            -0.04% 
> GALOG entries                           19,057                       11,923            59.83%
> ----------------------------------------------------------------------------------------------
> 
> 
>                          VCPUS = 192, Jobs per NVME = 48
> ==============================================================================================
>                                          V2                         V1          Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts               68,363,232                  78,066,512             -12.42%
> IOPS (in kilo)                           4,751                       4,749              -0.04%

Uber nit #2, percent change should be postive 0.04%?  4,751 > 4,749.

> GALOG entries                           62,768                      56,215              11.66%
> ----------------------------------------------------------------------------------------------
> 
> Thanks
> Sairaj

