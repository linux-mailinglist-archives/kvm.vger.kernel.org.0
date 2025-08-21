Return-Path: <kvm+bounces-55327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C587CB3000E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC2CCA2106F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7492DE6EE;
	Thu, 21 Aug 2025 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wEKp1cdH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901762E1F1B
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755793599; cv=none; b=gCHG1FjAgSqGbxBiMCxb+1wsz2jBTV+1jctZONGG4so1jVD4HDVpAV5P66bF1BR8W0LCiBXe8KRADI0+DPM3+OJaqONcDP0mQ9H76oOnt0mxNrPp/fYhZszVNlKG7Kw3gTOg+HlGwDVwSc1xwuTz4K+ZRPYHgmGC8k1DvoDIFY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755793599; c=relaxed/simple;
	bh=BGQfjv+3ECSbNnEBjSjHcyVlkv1M+/afrif7mCZ1NAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VUbHHozmRbLTOU+i13g0KA0OAKDqFbebKoIoc2yLF0Wly4qP+CRIQmBBso91xmXfehQHsGIIgaiJksaxeLHISEuukygqrcIB6M8YwuBRHVH5c++0xd/bkP/OwV8uCRZw4CT3geZ4UDFbKopROoAaTdDBQ8rPqAgsGn0Z23CWTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wEKp1cdH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32515a033b6so86619a91.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755793598; x=1756398398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9RvlD8X4SEG9tahkKerzt/w1Sov/ZfSlXlYzBetr28=;
        b=wEKp1cdHNkQRwaMic2/rMYkNueHTUdj1mt/RcLkud/E4m02Pz1/mdPuqugE/03tkJr
         1AF6kDx4UhCbbd8YpgJ3g0Bft2c3V9Ih6UicqvU5ZFrpWROv5zf4ibOo4tG1D3QW3Kq7
         H+q2RrEHXKZabSA+UF5S60OAFTTfo6KUETuinogdAysHlHw/P3XUiRKSDSJKnl2JPARs
         YwFEMEsSaBJKoJXO6PKKvYYKa734ya2ELIMfYD++Xbcf5w2N28R5/tuwEgHqYVyVEPoy
         4uvJ+jqyVOCsOZwc6bUQZUwqZPsRh7wdcyidqn06clu8zShw+71MCgWC2+n1PSXnXw+4
         NOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793598; x=1756398398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9RvlD8X4SEG9tahkKerzt/w1Sov/ZfSlXlYzBetr28=;
        b=LQAhlKWyP/gQOcR69xcD9UNN01r0c75CIVn9P9UOxQGYbDST7VVHuy8RQ+w8FOxGxY
         C4RaPqMEnR3cW05Ycj+c1Wk/WvArgqSJNRwd3kxVLWaR6L2tymSI9b9qmp0k7tMZpy4I
         1AIGRp8JXbVtr9FvA3eLbYQF7cjDHjjIqwgwHs8/8udaQFV/xzT6LMW5Czz+tED8L8Lo
         /v2ynrZzxEqKCiFlNknhhaNCitufurEY14mV2HlBCxWdCu44M7KZz15+f7fEO0GpGowC
         MsUlogL5RXFk0PU8hF1nLxacNOZljr66NH70xcfXpD3XN8fvosQRU6W22tdVnyVDFk+t
         nK5w==
X-Forwarded-Encrypted: i=1; AJvYcCXhOQrK2ggtFGYvFBXg27fliOzkh7n/3OFKNYSqxIS1OY4+IXZmpwTphhuS+2/MUm6i6dY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjvoFC3ofTWef5u+rD7lavaAssDVtg8V1uUmkRNVGVGQmqltIq
	+nqJcqnt+1e1J5TMmVzQmfqQ+EK5Pe+/3+ee9uWCWnB1PyzCxsl1THIJRVEWOjTvZwJn/o8WiqH
	nT6BS4Q==
X-Google-Smtp-Source: AGHT+IFBzpbYhwtJlmCT1TvGVIG96QJUu8LcbjOprwCjwMSjfpsP8VmuBfeFO4PBSHGBmzi0dYxbX/ODjm4=
X-Received: from pjbqa5.prod.google.com ([2002:a17:90b:4fc5:b0:321:c2d6:d1c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258c:b0:325:11d1:1fb
 with SMTP id 98e67ed59e1d1-32515ee12ffmr160940a91.6.1755793597571; Thu, 21
 Aug 2025 09:26:37 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:26:36 -0700
In-Reply-To: <20250816101308.2594298-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org>
Message-ID: <aKdIvHOKCQ14JlbM@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Colin Percival <cperciva@tarsnap.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Aug 16, 2025, David Woodhouse wrote:
> In https://lkml.org/lkml/2008/10/1/246 VMware proposed a generic standard
> for harmonising CPUID between hypervisors. It was mostly shot down in
> flames, but the generic timing leaf at 0x4000_0010 didn't quite die.
> 
> Mostly the hypervisor leaves at 0x4000_0xxx are very hypervisor-specific,
> but XNU and FreeBSD as guests will look for 0x4000_0010 unconditionally,
> under any hypervisor. The EC2 Nitro hypervisor has also exposed TSC
> frequency information in this leaf, since 2020.
> 
> As things stand, KVM guests have to reverse-calculate the TSC frequency
> from the mul/shift information given to them in the KVM clock to convert
> ticks into nanoseconds, with a corresponding loss of precision.

I would rather have the VMM use the Intel-define CPUID.0x15 to enumerate the
TSC frequency.  I would also love, love, love reviews on that series.

https://lore.kernel.org/all/20250227021855.3257188-36-seanjc@google.com

