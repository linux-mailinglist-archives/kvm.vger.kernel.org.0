Return-Path: <kvm+bounces-12749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6C088D5DC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D182D1F2546C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 05:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056A6134A5;
	Wed, 27 Mar 2024 05:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k419Lh9f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA9079C4
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 05:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711517420; cv=none; b=G6UtE61u/9mXcek7zPDX3FKfahQgoRA1Sge7T/JwpOz+IrAXZjAwpjObMJf4+rO6nAO4i3FrIOq6an1hnJDw5STOnuaa8wrZSpbAzmWk6TehsGWI9gGMVARBghOFSb9jMvrOk7HSKoaX8E0MdcDGGEP3wXKlWJ6lHHiOvNtu6NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711517420; c=relaxed/simple;
	bh=NQc7nRPv1d9S3Xkgl83x4eUWpFOJrO1ZnLvgPWT83h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HByF/jUSlNB1hL/uaJNOCwNMmSu+f38EeaWB5D3py3Z9/c5JCORoz4tpf2Sr8fopUSvwhPfAq88ugETVfnrjXFLf/lV++rdN1CI50Sov0XC9CZvZSNP8a+CfsczH2YRpLasQKw8qqzqA5jxlyfkoS5eGuQNcaZlZdx+voPK9r7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k419Lh9f; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ce2aada130so4505651a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 22:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711517418; x=1712122218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kVMXtjqW+QAkMGD+S/kOxyuhWzew87XrBM54rG8SDqk=;
        b=k419Lh9f2tiioctwLHMaSjGEC9861SF+kzimK+oDK+nG/hBwok+RFV1MVenzr7ug6Y
         1gJYgDj3CT6j5ufXbnXOLhiKf4Rlzl1UntTViubQ5/Eivo3WSYAmqD6BtUffmkuhJ/33
         heZDNFAwDQ3byHccrhnqEH1RkcRRJV37iI7YGcmOga4/E50jsyVItUvysKDKfCwIUnJk
         9bxNBNfjNlEfWMptN2ER1QvU0LhFdP00GMauoTcYCqYtccx/KrP2r5CpJ/cydeoXrxgK
         O8Ft+cgpevudVVZ6JKcwBoh9KibBruXhKsnaRdGx9IIbq+1wEx6V9Zk9n3BAXSrjxqWj
         v7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711517418; x=1712122218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVMXtjqW+QAkMGD+S/kOxyuhWzew87XrBM54rG8SDqk=;
        b=iXp20b0XzfPOe6IC/4AbNv29txyY3i/Oa5NORwoG5kwLluQ748Pz8RRYadKHRrb5Bk
         39ZG1/5zPcn47xsB8f+uqK47ac9yan4x5YBrW3o6e83vZuPbp/gdYDjNTIkV0Az/u1EW
         pZIkogjGfHuoDkOA81dDbQsU2/QJMuCu3B3EQtvClFcLAgk8If4GHpR9d8hnVjsrhQS1
         bzM0Yi2LEydy9EMAzaoqApJA1PusWdEjI6Z72KmS71Q1ZUiuY2lZEjoVCBCfr2YBMD9h
         yWqsP4ToUufpAVmEIDZl4g63F7FfwtMHjoDFT/+Aryg/aVw8ofcBmi8XrXGbK1ykutVE
         MCHw==
X-Forwarded-Encrypted: i=1; AJvYcCVInKodtFvgLih9zk0k6XET1/lYGI47TfuMNO4TQ4z8KcRiobZ+xzuPqNodZomhZvYZJKgTWqAZTl0xSUO/Kv7J1eJw
X-Gm-Message-State: AOJu0YwsAyyPZW38lQ0QCbQZNVaYPaVE2GRUyNfNn/YX/6r29Wp+T1QX
	i/DcG/2OkdMGGySIUOMOvyy2PVxtm09Mz1ERgGLhgnXJZdg173cZr/Szl1tc0w==
X-Google-Smtp-Source: AGHT+IHhkks7dIOvaFXe2jmlSHjqEQtmU6xHx/LKBsOUAj+YdfH3VVrKnf/kxA0qJ5GUlcEYRTkyZw==
X-Received: by 2002:a05:6a21:350f:b0:1a3:e297:ff17 with SMTP id zc15-20020a056a21350f00b001a3e297ff17mr1455211pzb.50.1711517417622;
        Tue, 26 Mar 2024 22:30:17 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902cecf00b001defd404efdsm5338953plg.13.2024.03.26.22.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 22:30:16 -0700 (PDT)
Date: Wed, 27 Mar 2024 05:30:12 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 03/11] x86: pmu: Add asserts to warn
 inconsistent fixed events and counters
Message-ID: <ZgOu5PP2qXhbflRc@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> Current PMU code deosn't check whether PMU fixed counter number is
> larger than pre-defined fixed events. If so, it would cause memory
> access out of range.
> 
> So add assert to warn this invalid case.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  x86/pmu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a13b8a8398c6..a42fff8d8b36 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>  		for (i = 0; i < gp_events_size; i++)
>  			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>  				return &gp_events[i];
> -	} else
> -		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
> +	} else {
> +		int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
maybe unsigned int is better?
> +
> +		assert(idx < ARRAY_SIZE(fixed_events));
> +		return &fixed_events[idx];
> +	}
>  
>  	return (void*)0;
>  }
> @@ -245,6 +249,7 @@ static void check_fixed_counters(void)
>  	};
>  	int i;
>  
> +	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>  	for (i = 0; i < pmu.nr_fixed_counters; i++) {
>  		cnt.ctr = fixed_events[i].unit_sel;
>  		measure_one(&cnt);
> @@ -266,6 +271,7 @@ static void check_counters_many(void)
>  			gp_events[i % gp_events_size].unit_sel;
>  		n++;
>  	}
> +	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>  	for (i = 0; i < pmu.nr_fixed_counters; i++) {
>  		cnt[n].ctr = fixed_events[i].unit_sel;
>  		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
> -- 
> 2.34.1
> 

