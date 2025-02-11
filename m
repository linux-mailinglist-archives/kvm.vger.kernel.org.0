Return-Path: <kvm+bounces-37923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37137A317D1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA3A6162902
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015F126A1AB;
	Tue, 11 Feb 2025 21:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yt2jK6fM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFBD268FEC
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 21:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739309523; cv=none; b=lY6nA+T7pIz9vc/LxIy9Cddv+M8eBCkvP7RIMCc4q/T2lPVVhwCWnrE03tw4JIn+cmuYJ73KujT4r+LCjsjc8KDNAO07/Fy3T9NbYtyeLnRWXXdJmOJtwXHUFMh7MT5fDoun1Y9GTi5D18uUjUGQE9Oc+/349K9GmD4rept/SUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739309523; c=relaxed/simple;
	bh=+LUKvtaq5+tVeSV8nn8P/esQQflfMiqhA8o10k5cyOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rprljLvSpMwL7d0IcGl2JcItEI5KTZxsVTlhJPv7rmaB2m0/9LLkDnNPGIv3hlQaZ6w5q7xiYZ/IwJ0Z7Jb0i7Q9ed0pEE5CKah5lTJvTL8tsiPoVyvoR1ryJoN5gKDvr7KxVTTeQHLwQZYuxyvrXIK0V9yEB2RrKYBiw7Bc3FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yt2jK6fM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220bc75098fso4172095ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739309516; x=1739914316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkaRbODbKGzYYO3d8B5U658Dnrd7njXNzj1iv9zbjaI=;
        b=Yt2jK6fMaUwYFu0R9BfXwO83HnbAB3nmoxfLcm+fATbbAFSn9X7ilBa+qr+46Ak5wv
         iBBTLZEDyCzyyvBIAQuRe4nFLpU4yySP/Byy2S1Z5yPhuPYoBbjLcFWX4YFBMcHFWhcP
         5Yst1KkcHP+8EKveA5hY8hkId7TjWtpZok0ywaEQVAdRz4aado8DP+BptaqpMn7P6kFI
         gPK1GUc0CdwBK25lpYhSAFb7aC1gR4Cv6u4MKpJJQz3Q/E7J0zACyDAj1wd01JZRspu0
         KX2yG4lTy7WjQjNhjO6+A/aKApo3DiTLZxx+0v8eO6FqzvqBsGIuSsbbEdbtEatj3BtJ
         Kt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739309516; x=1739914316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkaRbODbKGzYYO3d8B5U658Dnrd7njXNzj1iv9zbjaI=;
        b=rdeXLDoS2UwNWiIDeZRU7o3EV5VviP5coZBkEan5Fa1N4+URO4leJCiSqmQ0jRw0sE
         w6scgmRGI1e6/QrS2GzV8YBu/2sGHVoXE5wTJ/LEMn2TWFTzzT0T1RSPJRdDyGRYNGDb
         M2EmC7W9oH27aHBfz0sNqgKfDSKFA9mndoRA0SREiuw5cU+7yCHpGxSzL723WOqnYcM0
         hfQyjTjiY0TDbelC/D1/PBSdCG3tiGyQAFodGQBRn65GRcxKs1/Bnj4dilRUc9LUe5IY
         n8i6E0tiPpy3jkul+jq2kWmBzZwBFTi5KM39eGDyE7rCyH6rm+7KgmGNh8fAZbD6rWiA
         steg==
X-Forwarded-Encrypted: i=1; AJvYcCV363FTXUg6Rs/4lHiQdMTYLcXuxZMWJaZqxfpUFJMQuwEpX9Omud3FALdLTrN7/DNgJew=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLg0ZSRVk1a8+AzE1PCQ3uTUvL9CnyCY2Cz6+pELc7UmdE4w7P
	veAF2HGFrGUSu1OW7XnBOxO3kVN4/311ZY2d8arznhg0cAyPZl/UMweIDHDfhOuDBrZnNvTpqZw
	m8Q==
X-Google-Smtp-Source: AGHT+IF0fRIVtQzGjHRyYmnEnH/8CimtcIxuPGCWLPNdmuUYuFVbVgvZHz2rDvO254ixr09jUnGGcU4Rzps=
X-Received: from pfblb14.prod.google.com ([2002:a05:6a00:4f0e:b0:730:8a7b:24e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d06:b0:1e4:8fdd:8c77
 with SMTP id adf61e73a8af0-1ee5c733c61mr1455053637.8.1739309515854; Tue, 11
 Feb 2025 13:31:55 -0800 (PST)
Date: Tue, 11 Feb 2025 13:31:54 -0800
In-Reply-To: <cover.1739226950.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1739226950.git.ashish.kalra@amd.com>
Message-ID: <Z6vByjY9t8X901hQ@google.com>
Subject: Re: [PATCH v4 0/3] Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com, 
	will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com, 
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, vasant.hegde@amd.com, 
	Stable@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 10, 2025, Ashish Kalra wrote:
> Ashish Kalra (1):
>   x86/sev: Fix broken SNP support with KVM module built-in
> 
> Sean Christopherson (2):
>   crypto: ccp: Add external API interface for PSP module initialization
>   KVM: SVM: Ensure PSP module is initialized if KVM module is built-in

Unless I've overlooked a dependency, patch 3 (IOMMU vs. RMP) is entirely
independent of patches 1 and 2 (PSP vs. KVM).  If no one objects, I'll take the
first two patches through the kvm-x86 tree, and let the tip/iommu maintainers
sort out the last patch.

>  arch/x86/include/asm/sev.h  |  2 ++
>  arch/x86/kvm/svm/sev.c      | 10 ++++++++++
>  arch/x86/virt/svm/sev.c     | 23 +++++++----------------
>  drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
>  drivers/iommu/amd/init.c    | 34 ++++++++++++++++++++++++++++++----
>  include/linux/psp-sev.h     |  9 +++++++++
>  6 files changed, 72 insertions(+), 20 deletions(-)
> 
> -- 
> 2.34.1
> 

