Return-Path: <kvm+bounces-37395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 705B5A29A1B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 20:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0948E165CD2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F8E1FECD1;
	Wed,  5 Feb 2025 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bnl3bEL0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC81B200111
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 19:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738783919; cv=none; b=LHXWg6Q6I0uXIyBjW/kUwIpd/BS835yGDz2Jw+eZSygnkgu/auPWulTxPv2oNoaP2sAG5owDPgjFwNRS1qK2LEg23Y4jxtblOqALXmiIk8tHSBqLQsY/oDYRbR0GYtQT97DbUPsNtNVk0QKT67f/H6+yOlCg2EkzQlH6K7VD3rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738783919; c=relaxed/simple;
	bh=2rxoVBPGkYRdke7t02zWdPgQ6HfJzuAcVvL+PkSrGoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=USb0mwepXtOKW3dqiEH42QxxmBKNQbmetsYkvoNJ7EAR91XyDKIuu2FEZGQUIXr/s/qg/5jXoK5c4WeEAAae+SB+vOIBlhuQNt4lIoNjqYFUS26CHF4qOdOxH5h74D13+c17FbE6OoL8RcFLWP1PU84xSqEVXvWpxaBwjlCgBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bnl3bEL0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f9f2bf2aaeso126218a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 11:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738783917; x=1739388717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ityHFYbQHjCJ1n0TCLpdhG0BGuuO1UwpdTT8iBBDxQE=;
        b=Bnl3bEL0/CYG6FgGetK3sqtOL/Fp32lYz2doPwIARyb0A+IZMy6B2kL2EcpUsop67C
         wcLTkTPGKWRK9s/LZ1ixGJKS+mOr5DyoY0RUFy+VVvjFtagADdiiv1TXnIOioD5iZNt1
         stTrcV485A3nZ42zvrqdSp3nNh73rvOuR/cuGeyd5jaLnxBtjzgTDGgU+iZcy34bYFSS
         nGYGS/vN+Zvp0EpoRT+aYKXjCSwzbPZsTPnl8GgIsZVEWItWAjtOVYupCMNnMAoC7lBc
         /u8zGCVU2cuGRhDZlC3JOZTa37aXBDDYSuDLIYlHHcDUd/seyAkq1NVRE1RLM6/HI9Hu
         V7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738783917; x=1739388717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ityHFYbQHjCJ1n0TCLpdhG0BGuuO1UwpdTT8iBBDxQE=;
        b=Fg3MMUIlnN3aHo5K011Hjs6wUzles53gUQVCngu+Rzb8spY18cWjk5F+k1cSM7Ji+J
         XA+NOgJogHtE+1sYqVOIgEClThrig9Zm7m99VWFKScxkHs95gSO8PGIuXgN2xqF+h9XX
         pNd2zD4qzJOhCfKoIQj27zJr6L0TZy282Eo/7sUa8UN+WIRCNXob7mnDVzkJ4dcWxHTF
         jxOeVbEtjjzzE6Pu7WoeyltfXW6zwLh42qfCWLvCeBFqIQI1wGZe03oGRsVFjW/tcVGr
         bIi/Nj31q3bE4e8d4UgHaHRS0LwW4RAkRE/qClXuhsm0z6xm6HNQDB3BjVfl2tfAl5Qe
         RNOg==
X-Forwarded-Encrypted: i=1; AJvYcCXDJIgmPMjyNlU+QiTRungOeYSgJN5i7QLnsUvRAQhqy6sEIcdFBdM8F3rI6cZmNjlp5vA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHuqET7MSmbqq1uvOlw4ZmtmlTHR7crFddX8KaQrRIrbGEXZ12
	6urGzi/c2moHNmo2F9JsTk5oSvLO8sfWpqUzJQiwUoVSrSzcCHGpZHkvvgN2t2elUHVQ11zdMx5
	9iw==
X-Google-Smtp-Source: AGHT+IGYpR9H2o7CsrEfJdhduqV6CItDd+RRnz38obHEp/U4zWkL8bbKIHK5OX1zzdtql3FDGJLnjb3ZcYY=
X-Received: from pfwy2.prod.google.com ([2002:a05:6a00:1c82:b0:72f:f548:3e09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:28cc:b0:725:f1b1:cbc5
 with SMTP id d2e1a72fcca58-730350f96demr7928023b3a.3.1738783917255; Wed, 05
 Feb 2025 11:31:57 -0800 (PST)
Date: Wed, 5 Feb 2025 11:31:51 -0800
In-Reply-To: <8f7822df-466d-497c-9c41-77524b2870b6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738618801.git.ashish.kalra@amd.com> <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com> <8f7822df-466d-497c-9c41-77524b2870b6@amd.com>
Message-ID: <Z6O8p96ExhWFEn_9@google.com>
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, will@kernel.org, robin.murphy@arm.com, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 05, 2025, Vasant Hegde wrote:
> On 2/5/2025 8:47 PM, Sean Christopherson wrote:
> > On Wed, Feb 05, 2025, Vasant Hegde wrote:
> >>> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
> >>>  		ret = state_next();
> >>>  	}
> >>>  
> >>> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> >>
> >>
> >> I think we should clear when `amd_iommu_snp_en` is true.
> > 
> > That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
> > will be %false (its init value) and the RMP will be uninitialized, i.e.
> > CC_ATTR_HOST_SEV_SNP will be incorrectly left set.
> 
> You are right. I missed early failure scenarios :-(
> 
> > 
> > And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
> > and RMP is wrong as well.  Such a host is probably hosed regardless, but from
> > the CPU's perspective, SNP is supported and enabled.
> 
> So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
> clear for all failures?

I honestly don't know, because the answer largely depends on what happens with
hardware.  I asked in an earlier version of this series if IOMMU initialization
failure after the RMP is configured is even survivable.

For this series, I think it makes sense to match the existing behavior, unless
someone from AMD can definitively state that we should do something different.
And the existing behavior is that amd_iommu_snp_en and CC_ATTR_HOST_SEV_SNP will
be left set if the IOMMU completes iommu_snp_enable(), and the kernel completes
RMP setup.

