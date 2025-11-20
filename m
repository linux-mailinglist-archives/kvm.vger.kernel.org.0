Return-Path: <kvm+bounces-63987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A71C767EF
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B10BB345013
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 22:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C6C302766;
	Thu, 20 Nov 2025 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LiTaIXeY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F0F2E6106
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763677700; cv=none; b=umlWZFZu1Pd+fKQGhuZ7Y8S4jfIt9GaSMnvvpkrnvzCho38jVEhPj/0V+LjLj1139wQc9Hl0+I0ul0PViZy9UZ5ysp+rFJ8q2KMc7jOxaLMyPFD3PDL2ggrUVZo6sXz4RqhMRbK9Zx56e3Sdou3DY6htuYy2vjOH2Y/wIBcwuyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763677700; c=relaxed/simple;
	bh=gHkndrwE3aeOl5dKHNZlNMtlYpGRZdT0ebvgHoBIsAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G9M8KssEoXfT9psQhSAMyTNRDV4UJ3p2imeXDyQ/ZuFofQx6erA2dwkKdjplvHeXPw/HET58QTXItovI3Ttw8mewdstBX+dGw+J5vw9WUhmPGWsdScWUcNAyXnmY3zONu7P8n7xP+jHUaWtl191k7pvKNrDY0b8Re+sS4OhLSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LiTaIXeY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3437f0760daso3253523a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 14:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763677698; x=1764282498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O+Pj8EeLfFWjLLVIPwvJQtCu/Nn8pyxPWAQRnkUACEM=;
        b=LiTaIXeYrxx7wn+0ZG2J3+krct+soeiS4XkV/E9FFH7zWj6SoC05SQIjwUUd5O9rPG
         Ly46h+t1qZChNe/REKrEQ9BprStUvaOMZwtz0WGznU1k4tApSPAq8dK2l+RzRIcFS+Qs
         le8Pg1M5GRu4loHpmO9H9a3y3E3Ky8S5z/cizfkYr1fl3kgwep4pQjkswbx5uGzEP1hz
         OdQ51oTqpnIBuW0aHustagqjvvUJc+eFIKZG1BqTjH/V0s72jjbIeugDx3fob5V3UJWn
         h8EhSzyN+vRNLyuldCenKkLoGPlOJjFwOovNPNMXEk8fUDCdVOsi+BYefUIi49MTlHXd
         siwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763677698; x=1764282498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O+Pj8EeLfFWjLLVIPwvJQtCu/Nn8pyxPWAQRnkUACEM=;
        b=puoWPApGJMclBAlqBTeK3oBAL65F+tdrTxwLS4hc5SpY2Uu0mxEDD7g52UIBdymRt2
         82yXix3tWiyyrn41K3Dus4DtvD62KRdrO/+jfDmlcekCNPpSc47nCma1XU7p6PopFAaq
         O1Z4f0V7kPgwpEd0tvVMBkZpZ+CE1r5jzXmmiDxvibBT1OjsgzQ5l7JSnwjvq3UZgGyk
         7iTM6pI2TX/L9rZKJl8Ya8T1uAyNOGkTPuvDJcoTfRouflWUPC2daDsBJM5M9gqAPawB
         PtK5latQcCbakFXX9HwyP0d5cak65Rdw7NKKfueGX8PKOnhi9VoKq84Jk1IOvMUV3g0F
         2nPg==
X-Forwarded-Encrypted: i=1; AJvYcCWs+Xr0o6GiM40cTyqxZ0xUZsIzqmnNvIKDZeLh6njYzgTHd9Ckd+bjUwZpg56Idx8C/QI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFwRVkSYc92IeoWzvDO349SoV6G6D4xm3PCA3wmsB+srtAF/A8
	4VvxKVyBZ23EhFdLnxtxnO4a1JKh4L+doy1Na+VGzV0XyLjPGAZvnHVRYgmFjvH6avdSyYhmjx2
	CYume+A==
X-Google-Smtp-Source: AGHT+IH0eSK5wJNozGCkR5ENA56F1JpPTsyure8RWeLLRXMvsUoQd8vkhCL5grjBX7xJ018NnMgWkzKNwQc=
X-Received: from pjbpd15.prod.google.com ([2002:a17:90b:1dcf:b0:340:bc7b:2b2f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390a:b0:341:88c9:6eb2
 with SMTP id 98e67ed59e1d1-34733e4cb5emr69727a91.1.1763677698306; Thu, 20 Nov
 2025 14:28:18 -0800 (PST)
Date: Thu, 20 Nov 2025 14:28:16 -0800
In-Reply-To: <20250903064601.32131-4-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com> <20250903064601.32131-4-dapeng1.mi@linux.intel.com>
Message-ID: <aR-WAGVNZwNh7Xo8@google.com>
Subject: Re: [kvm-unit-tests patch v3 3/8] x86/pmu: Fix incorrect masking of
 fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>, 
	Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 03, 2025, Dapeng Mi wrote:
> From: dongsheng <dongsheng.x.zhang@intel.com>
> 
> The current implementation mistakenly limits the width of fixed counters
> to the width of GP counters. Corrects the logic to ensure fixed counters
> are properly masked according to their own width.
> 
> Opportunistically refine the GP counter bitwidth processing code.
> 
> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  x86/pmu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 04946d10..44c728a5 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -556,18 +556,16 @@ static void check_counter_overflow(void)
>  		int idx;
>  
>  		cnt.count = overflow_preset;
> -		if (pmu_use_full_writes())
> -			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
> -
>  		if (i == pmu.nr_gp_counters) {
>  			if (!pmu.is_intel)
>  				break;
>  
>  			cnt.ctr = fixed_events[0].unit_sel;
> -			cnt.count = measure_for_overflow(&cnt);

Per commit 7ec3b67a ("x86/pmu: Reset the expected count of the fixed counter 0
when i386"), re-measuring for the fixed counter is necessary when running a 32-bit
guests.  I didn't see failures (spotted this by inspection), but I don't see any
point in making this change without good reason.

> -			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
> +			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
>  		} else {
>  			cnt.ctr = MSR_GP_COUNTERx(i);
> +			if (pmu_use_full_writes())
> +				cnt.count &= (1ull << pmu.gp_counter_width) - 1;
>  		}
>  
>  		if (i % 2)
> -- 
> 2.34.1
> 

