Return-Path: <kvm+bounces-25928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD8996D305
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BECFB20FAD
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B99197A9B;
	Thu,  5 Sep 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGTOpYDa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B7192B94;
	Thu,  5 Sep 2024 09:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528148; cv=none; b=fhGVL8t/XVu/oBVeoYxHe3ia3WAMdOuWZNQWYfXhm79yS/qPViV3Gv9MeB2gGWwoZ70j7M6ZIan+JQkAbB14mi7E+c0dy0IqWqwtWjpoFlzkozrR8SGK/sJH94ECc+2IW0zmpfpc/YvhMtvuGRYEXqV+lLRqULVsbWkF41bAXeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528148; c=relaxed/simple;
	bh=1Vz6IzeJ7CeYav9C4VmbTfWx/w8/kafVYBgh4fUe+qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvoHs/ZVFlMvTeOwQcutjsOLAehqJ4v6HMVriqurBJaxynZQIesDyv9JEF/LUvexVfitw4v2gMtLGqLX6JriBfIzKYN5E1wijlQbEv6Zu8gaa/LkqxdG6IE73oBrSJApHZamgZv5AkQEg7L1Mx2AZpxKmFiYJ3r+ptMeILuqiqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGTOpYDa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso3898375e9.1;
        Thu, 05 Sep 2024 02:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725528145; x=1726132945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LgmwilwZTv00oKOBkFrZ/42OcenxN7DIQ4qoy+ip1I=;
        b=NGTOpYDaZhCjv3H/pa0YFGWpapjogOf5E6c3qV0d1iQl/Ys0oyrx9XEI0MZOdXvATh
         wlzGPW1viTFwE8Pvc5VNEYqadVIsRgcLPGe2r+2sS43/WYIYj+zCrRnMzPkHDazcs2OY
         qOBKiGzGLkxuyoVhGXfgdVUbR4fkE6XTUE+0eIio70ePvOS19iR8duoVcAHpNtftxWIc
         UG/nPV3iZhlU81p+e/nInyTAmRvTanHJnUuAfIp8PzU5pPiiFtbwkBzBcY0mHlfRNw3y
         wHM/Q+PDvpFUjzNJTHGHVJwuCiO0SttJjgxWgzEstORDO4NCtPD7hcBDhXw0g7GNqewd
         ZM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725528145; x=1726132945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LgmwilwZTv00oKOBkFrZ/42OcenxN7DIQ4qoy+ip1I=;
        b=ut3rl8tYBa/aKF0iHNPKRcdBwiIu5K1UXHiD1Caava0sXJgKcwvHnxWsYRWMnaWAux
         eAx36WZMpSs92evYwVWSTt2OEdd4eaaH7QC6PhAcNQsm/ZQhknA8vWhE7XTUtb43HJ6d
         SyCSiIP7LkxUIxQ+C3pCk9s1+FJxd1zvdIDYW75eqFglyeoMOZ2ccbb68U/Qhwx5TOJs
         fx7n1aCQRYsHr8cyDPhICL2VsYTh+c51SRkuK4957eTMUQX9fhNJx8UeVI9mp7I33a2F
         KjxEIEGjiEET/2scRUfnkZr1j4zIP85pxIenrrH0z/KGlGrBmTvU1VZCw51v+VfseOR5
         fQnw==
X-Forwarded-Encrypted: i=1; AJvYcCUswI9efc+Quy5GWJlwq9WhUJBXv3zLyjlCBsK+MacVaq3B1nMk2br/MWGxorQczBIB5rV11yHsOhyPIg==@vger.kernel.org, AJvYcCWRPhcUILh8Ya3yFYVj4nQtWYslUuD6oVp/KLiqp4laN0ozZKHu+9se9j4K5AeZXbg0tn+gL1c61yENpgs=@vger.kernel.org, AJvYcCXgj5CE+pEpgTtScajAr4i7vShRaYuDUMnZM5cOdzobHiYdmFGV1Y+Cg32s9uI9//tMeKrpKJecdYBsk2U7WmfOSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTmGUhoseBX7fcpcYvhyoHZYPbhP/gz2tLJGakHmSC8Uxpsg6f
	4Giisxu9dQ8XYfoS/oqAWnIYg6FVWhEwgks+B43y3Ch4mIchRdi5
X-Google-Smtp-Source: AGHT+IFUdfGNW49G4+DfGHtef+3iH+rTqtv4vp7wb8eaC9NCVgAim+dCJf5aeZgCMrKkgfBOdEZuqg==
X-Received: by 2002:a05:600c:19d2:b0:427:fa39:b0db with SMTP id 5b1f17b1804b1-42c8de9ddb6mr49602095e9.27.1725528144107;
        Thu, 05 Sep 2024 02:22:24 -0700 (PDT)
Received: from gmail.com (1F2EF525.unconfigured.pool.telekom.hu. [31.46.245.37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba6425a77sm266553755e9.45.2024.09.05.02.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 02:22:23 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 5 Sep 2024 11:22:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: perf: Refactor misc flag assignments
Message-ID: <Ztl4TDI98tnCkH0X@gmail.com>
References: <20240904204133.1442132-1-coltonlewis@google.com>
 <20240904204133.1442132-5-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904204133.1442132-5-coltonlewis@google.com>


* Colton Lewis <coltonlewis@google.com> wrote:

> Break the assignment logic for misc flags into their own respective
> functions to reduce the complexity of the nested logic.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
>  arch/x86/include/asm/perf_event.h |  2 ++
>  2 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 760ad067527c..87457e5d7f65 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2948,16 +2948,34 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
>  	return regs->ip + code_segment_base(regs);
>  }
>  
> +static unsigned long common_misc_flags(struct pt_regs *regs)
> +{
> +	if (regs->flags & PERF_EFLAGS_EXACT)
> +		return PERF_RECORD_MISC_EXACT_IP;
> +
> +	return 0;
> +}
> +
> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> +{
> +	unsigned long guest_state = perf_guest_state();
> +	unsigned long flags = common_misc_flags();
> +
> +	if (guest_state & PERF_GUEST_USER)
> +		flags |= PERF_RECORD_MISC_GUEST_USER;
> +	else if (guest_state & PERF_GUEST_ACTIVE)
> +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> +
> +	return flags;
> +}
> +
>  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  {
>  	unsigned int guest_state = perf_guest_state();
> -	int misc = 0;
> +	unsigned long misc = common_misc_flags();

So I'm quite sure this won't even build at this point ...

Thanks,

	Ingo

