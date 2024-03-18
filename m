Return-Path: <kvm+bounces-12037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DC887F35E
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A1A1C211E8
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208C45A7B1;
	Mon, 18 Mar 2024 22:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVmSTA/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE45A4FF
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802245; cv=none; b=KfM8hOu7j4nzuKV436IYCaeT41ZTpSdJz7+EcyM6LrEWFT+6sv1aWbxP5SPLkgyxGCCw21tmC+/eKKaWEdhLjHelbFTkBavBB52xcOGzmPCDjknEKfDIohRhrmfUl9A0L/E8IlbA69DnPhNKc9TUg301/ilUkMHU6yP3UX26qrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802245; c=relaxed/simple;
	bh=+ZOk4bVSRifoj+sbTssU81wJKNOhcrPwJpjGcFBL5Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMKfPgF96E8xPX0gzCpNhiHPqmgHq1k3V/aUheT1g1y8ENg8a+XJOioxbtnLEaMLGVkPVYBpnajOENk90ueq/Nq+VaEnNserx4LJhjOY/3PorV9WwktvITgsJLWN7jt8+OBXb7oRcCKiEsT/2JIdocmSulnSxqg4H0KORhiMy1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVmSTA/Y; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dddaa02d22so24679305ad.2
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710802243; x=1711407043; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqfEoWmEnfydY1iESygtrZED0/3Qp9DI+FcFENiGi3Y=;
        b=MVmSTA/YsiIzGJDPuilpBmJBBOHOoT5+Q+rzP5n8JlWiD18lGI9d97h1JGgEaQa4KX
         He/Uzb0UKTyq9kaHkypqLLOI+R64KQjPR1+tVzjyCibve7RhgSMI7Hk4uJW7Ib9KfT0V
         W11HtxAdK1jhEnrJCItX8IuTSbdj2vMi227UoqmV5VQBpd3/fFC5evHDLk2yswB2Oa1F
         e5YjFPe9A8y/OHnlPYAUCEMNqsQCGkyg27la4182sSLvI+T34Uo3Sb8MihHEnji4DeL3
         Dzt1iDVjsl13HqooQwoKzwgtHQyZQjBn15XWpCzYrCTG6lndcSmctur8kFP/2Ry6jC4T
         22aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802243; x=1711407043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqfEoWmEnfydY1iESygtrZED0/3Qp9DI+FcFENiGi3Y=;
        b=rp7lWma4DBYKsKH6EZxWBSsWqVuromb1F9/5gbqi36W5nzSM78noRH2TG8900q/gTk
         FB2vDhWdZHPgVyUeukGsv8SMFde5pFewuMmrfJsuxeQJxHosFTJdNsAx/yh+A3HvqIQV
         6fygKGoPyDPdxuXFkk8fJx/y+Nlr3Z4d3UpA+NsGIfkslrTnmUKQ5HDwgw5/aJD12/R4
         5lmmbhQZSjc60fdk1DvBn8HetlTkv22tDa3QyxMnE3EOqov6WRz2NSuX2lBuQZ3nNEaU
         XG6wE2gkR69Qy+TtnxyptD+iMin+KxKQYTLOu8X7CxTjS3NH1tOgk3JazgtF/gkCR+96
         GJ/A==
X-Forwarded-Encrypted: i=1; AJvYcCUXTVO/SmucudHlOWKspUh2u5PlTCV6kLSqmrXkS1aNFaQ8W/cEn9sy1HjEgneFC6Srrxwcs5/B/2HskQF0VEAlQOiP
X-Gm-Message-State: AOJu0Yy3i80zH0V20IathoxLG0jLKdtO3jyHe5nP3/XhqGCgmTYLrR7J
	0SDPNNm1h/uqNZm6qy45CWmF5+rIDklSZFX78qy+iO6CWpPfrk0nYcXF5SieMA==
X-Google-Smtp-Source: AGHT+IH1kOVXzNpj/i2DpqTZUYLKt8uVnZKDqtS2XqjTIJWyCPqL1u+b7kFKVV3yiJRygxa8exrphg==
X-Received: by 2002:a17:902:e882:b0:1e0:1bfd:c1cd with SMTP id w2-20020a170902e88200b001e01bfdc1cdmr5073679plg.54.1710802242904;
        Mon, 18 Mar 2024 15:50:42 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id i17-20020a170902c95100b001dd59b54f9fsm4203830pla.136.2024.03.18.15.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:50:42 -0700 (PDT)
Date: Mon, 18 Mar 2024 22:50:39 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/3] perf/x86/intel: Expose existence of callback support
 to KVM
Message-ID: <ZfjFP7E0ME5yHJZC@google.com>
References: <20240307011344.835640-1-seanjc@google.com>
 <20240307011344.835640-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307011344.835640-3-seanjc@google.com>

On Wed, Mar 06, 2024, Sean Christopherson wrote:
> Add a "has_callstack" field to the x86_pmu_lbr structure used to pass
> information to KVM, and set it accordingly in x86_perf_get_lbr().  KVM
> will use has_callstack to avoid trying to create perf LBR events with
> PERF_SAMPLE_BRANCH_CALL_STACK on CPUs that don't support callstacks.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/events/intel/lbr.c       | 1 +
>  arch/x86/include/asm/perf_event.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> index 78cd5084104e..4367aa77cb8d 100644
> --- a/arch/x86/events/intel/lbr.c
> +++ b/arch/x86/events/intel/lbr.c
> @@ -1693,6 +1693,7 @@ void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>  	lbr->from = x86_pmu.lbr_from;
>  	lbr->to = x86_pmu.lbr_to;
>  	lbr->info = x86_pmu.lbr_info;
> +	lbr->has_callstack = x86_pmu_has_lbr_callstack();
>  }
>  EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
>  
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 3736b8a46c04..7f1e17250546 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -555,6 +555,7 @@ struct x86_pmu_lbr {
>  	unsigned int	from;
>  	unsigned int	to;
>  	unsigned int	info;
> +	bool		has_callstack;
>  };
>  
>  extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
> -- 
> 2.44.0.278.ge034bb2e1d-goog
> 

