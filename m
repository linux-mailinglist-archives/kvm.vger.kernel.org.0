Return-Path: <kvm+bounces-43944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C98A98D0A
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 284BF3A4E19
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 14:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8238A27F4F4;
	Wed, 23 Apr 2025 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZbhweNAj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D8727CB35
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745418523; cv=none; b=PwzGkRbvZA/uJb5ZHq6WyIUcuAcDFTsKGFPGL8Pb6hjQ/hOqIGPVzoGymK8eLGBAXqbjgkXK5Coirq8z+OJzLrNc6kWcLjDhUVhMaCuvUmiRBQZNu1JnTGEvHfWuNXNpxw0YQVHovGtfKC/I2M2xYOGYQhXcgXnwuSKhkoa5ZtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745418523; c=relaxed/simple;
	bh=olgEi8hkKOP25EqBnRGPkbqDG4k0ZvkVsXbAyxVuiMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hitDm7YBwXP9HGFp1BnSNPe6HYLiCUxxuBc7NV5BqzQFvKuTUAd1zrtsLLcLZ6ahGmnzzt2Gzbxn9jgiPpOxN12g61aYYaWfnncyv8NUAwjQDCNHxaa6vhU2UsvfICLkI4DP4pZ/NW728nsy+owehkEsJ/zzLd1u+3rVDQk8ZNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZbhweNAj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30870e7e4fcso858819a91.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 07:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745418521; x=1746023321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=40rtvLOwDeuUbiOuCoW1t5olyX8gz8CZJ5ahJ10eU+w=;
        b=ZbhweNAj3oT2cEITBANR85a+3AC9Kt8YpgVC+0pS/UdzooqO2KwBAg8PnRDG2w+8V8
         qLox6rQ6BGUGoe3b/N5PTjmCpYwAoHz1scAtDySO/OO++U+IIv/fCY/b2WTSqa4ICql1
         WiIiDOMpIhKQ3+58D9U7phiYIB7CsXdaZox63CJKsMLu08KEtuOwmEvM+ddRmi5Pjhgh
         kSOrUE9BxdriaP9tjWEYTWIkAfttmZeIiL0RgKlYphs6LmDQ2TlevtGepgZwoacX5Tx8
         Egys+nSCqTDinlziB4MkKZqQgUmV+WE37wRkdZq4JtNRtANFxJucZbcim1uDIP9NEFhi
         FVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745418521; x=1746023321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40rtvLOwDeuUbiOuCoW1t5olyX8gz8CZJ5ahJ10eU+w=;
        b=hvomKV7cnDlBU4zMJN16K7krlTGtZg2jivY1cVimblL+qJsk4sgSDxG4Ga6XDvAJIC
         j6feRcKTGOlnCL/WErBDMOqsd1FYYVVUArRNPEX/pvZ61revFmp4HlW8m3zR9kA5Ibf+
         sEn1cWpnHv9gYx4i+9IsEBsVCQaxlFfYGwzIjD6NMmvq8iP7hGP+nzv4AAv5EA/a130i
         njLteYTKyNN2ko/Ups2gCMOpEaqKlUr1Jc6X0q0Ra1libDEHSDzFaMmimUYzDuHP3eRs
         8Q02ppfVhG+vXiQClCxguN5GrRBZvR/9FdEq61iByoFW8l8ij0rJircCY6xkQKDmmsMJ
         fUoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy6R9KvgwtVNe4QxSWfw2HMj/v97PmUwg69kh5jodM1Uwr87sa22h7r7BEzCv1VQbTJHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjBIHG9bZuH9bPjxoy2uiIEbrZFPJOIv4+G33CxfrRKR4fPUFE
	rJ3og8tG2HMSRuXaKJm9xsrT2dKjshmQZNkI+Yfyl6sTJS2gwkYVh11GsmhR38XhpR51effm4sJ
	GAg==
X-Google-Smtp-Source: AGHT+IEHFWhYz0oAsCQCzYVGgs17eJ2RdOv2pA+CJ/89PxdUza1pyAyGtkAfHJad1QU5DCSNGF6B8Gtgtdo=
X-Received: from pjxx4.prod.google.com ([2002:a17:90b:58c4:b0:301:1ea9:63b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2cd:b0:2fa:21d3:4332
 with SMTP id 98e67ed59e1d1-309df187b6dmr4574319a91.12.1745418521285; Wed, 23
 Apr 2025 07:28:41 -0700 (PDT)
Date: Wed, 23 Apr 2025 07:28:39 -0700
In-Reply-To: <20250422082216.1954310-4-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422082216.1954310-1-xin@zytor.com> <20250422082216.1954310-4-xin@zytor.com>
Message-ID: <aAj5F9IZXG7MB0ai@google.com>
Subject: Re: [RFC PATCH v2 03/34] x86/msr: Rename rdpmcl() to rdpmcq()
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org, 
	jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org, 
	namhyung@kernel.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com, 
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com, 
	pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org, 
	boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Xin Li (Intel) wrote:
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  arch/x86/events/amd/uncore.c              |  2 +-
>  arch/x86/events/core.c                    |  2 +-
>  arch/x86/events/intel/core.c              |  4 ++--
>  arch/x86/events/intel/ds.c                |  2 +-
>  arch/x86/include/asm/msr.h                |  2 +-
>  arch/x86/include/asm/paravirt.h           |  2 +-
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 12 ++++++------
>  7 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
> index f231e1078e51..b9933ab3116c 100644
> --- a/arch/x86/events/amd/uncore.c
> +++ b/arch/x86/events/amd/uncore.c
> @@ -152,7 +152,7 @@ static void amd_uncore_read(struct perf_event *event)
>  	if (hwc->event_base_rdpmc < 0)
>  		rdmsrq(hwc->event_base, new);
>  	else
> -		rdpmcl(hwc->event_base_rdpmc, new);
> +		rdpmcq(hwc->event_base_rdpmc, new);

Now that rdpmc() is gone, i.e. rdpmcl/rdpmcq() is the only helper, why not simply
rename rdpmcl() => rdpmc()?  I see no point in adding a 'q' qualifier; it doesn't
disambiguate anything and IMO is pure noise.

