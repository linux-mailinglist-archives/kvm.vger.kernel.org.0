Return-Path: <kvm+bounces-18360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F3B8D4474
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 06:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD7F4285715
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 04:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891F0143880;
	Thu, 30 May 2024 04:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g/bI36lK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4AB28E7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 04:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717042813; cv=none; b=FlfSu9azviSeQhAuULL2kjxXGvI9u3iHct2EwOvmD3gRW/0IeNZrdrPJWNp4PnYTk65HG6+0YsY8gugBqrSuDpf1XhFgLlQW8w4Ka0aswSD6IuqFwGbgc6SGvCbGsoJvRojh0GtR6sbSDxLsTJc4Fq9oi6YpyaGpNGsu+EyXTfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717042813; c=relaxed/simple;
	bh=ScqQnDhIZzazEaKjt9igUl5O8hNKM9pHSKP3vMPQWRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+2JlsRK1guHwtW6UyzQgAzRVCS8IyVD0rXluWD56jTXzzXkmJta4kdFGp8ST8S8Tk9RxvoVlNPnCTCbDDMpr3YIGm9ul3isOMY+IXRgvjgcv+Ef9EXPg5IdP3EeqhhZpUHIbF+aBIYDKfzT9IiGtIfxwwZRvbUBS+ugzEufXW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g/bI36lK; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f48bd643a0so3305015ad.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 21:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717042812; x=1717647612; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4WJSvfiaNoa/0OJgyCquaiLAw0pNXvsnSprBpQ0sIk=;
        b=g/bI36lKjBZRM5Pzk5xwDfbeKdd8a+OHQmQLwDNZceoYzQadTeAF0pKd4KCRrxcNi8
         WQZjUtOimOUiya9xIY56qbrsckjfJ3LtnYKyT4l3yptZo7OSlujTvXOO8gXMdkc2rTLG
         jtK0EFL3qip9t0pRJNscAAWAznSWQx8/X/fePYZqNiMwdgGlIZKdr6Qo7G9314XAdrx+
         BwD0xeu+btX2uhnWJ5maO5hGglyVVTa4bX9UHOtkiOtxBRXwYogU1k0we0gi5qODN5+y
         a/nPb4HIKeRWtVD+sY0XmDKiuRNZiI0pr6yCK6WaV2lHJQun9nOlgmsqzhsbx4H584KQ
         h5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717042812; x=1717647612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4WJSvfiaNoa/0OJgyCquaiLAw0pNXvsnSprBpQ0sIk=;
        b=GzId2gu85KRlSedpFaO+difuibSq7OxZryj8XqENbO1gRgUefPKuPUgJ5ZMNlOtcyR
         YeGpv0GzxoHqCi+4/p7gR/MlY+zYF8eBX+2qE+51fqqQEx4MrexV5GXG+ojkKDeTBLfC
         yKWpDzmvswYYOfO1dNjd4bF6kjNz+fkYf82aqtYyQeBIPe8/CzF3a3xBFJ/2nFZJQP5g
         Z/XatI/DszF53MUVHXNP7x/zz/pfMw60rO3fttXEYUdaS1m0Hz99basbCSDmX8HR8tKI
         y462MNE9Qk9fdljXm7rOsVcHlW455Jp7cfRfuiKus2YVp3HtbwdYkCXgTIALEK89thPR
         u+EQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3daAsSd19aCadyGhg2CpO63GgMcDjAaVxJP44p/N0DkPW8Uv435o/9du8P1dRxaS2YNmFjORFsy/++uy3XQUPh61S
X-Gm-Message-State: AOJu0YzpEfW4+eKylHM+3R9N/4HN7dJtwONF1S/5klX4HMiFRM/GV1Vl
	m7HHHtLGWML92QIlHdHeparYTo9agWRhqnMYCYNPVbatIDKw3SbzcVX2fdWgEQ==
X-Google-Smtp-Source: AGHT+IHcHdJN5a1tCHgmcM6XidNqutFz/wGDogXr9yfTIAKOQU98fE+WRy4+w4q6LGuowy6wzly2wA==
X-Received: by 2002:a17:902:ce90:b0:1f4:64d6:919d with SMTP id d9443c01a7336-1f619b2d1e4mr10272365ad.66.1717042811349;
        Wed, 29 May 2024 21:20:11 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7b7d3csm107899505ad.93.2024.05.29.21.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 21:20:10 -0700 (PDT)
Date: Thu, 30 May 2024 04:20:07 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: "Chen, Zide" <zide.chen@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter
 increment for passthrough PMU
Message-ID: <Zlf-d8p2yzNFOr0-@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-43-mizhang@google.com>
 <8da387e4-0c44-4402-8103-fc232600cb02@intel.com>
 <7c17fd63-d3b1-4438-b6d8-11417321c56e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c17fd63-d3b1-4438-b6d8-11417321c56e@linux.intel.com>

On Thu, May 09, 2024, Mi, Dapeng wrote:
> 
> On 5/9/2024 2:28 AM, Chen, Zide wrote:
> >
> > On 5/5/2024 10:30 PM, Mingwei Zhang wrote:
> >> @@ -896,6 +924,12 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
> >>  		return;
> >>  
> >>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> >> +		if (is_passthrough)
> >> +			is_pmc_allowed = pmc_speculative_in_use(pmc) &&
> >> +					 check_pmu_event_filter(pmc);
> >> +		else
> >> +			is_pmc_allowed = pmc_event_is_allowed(pmc);
> >> +
> > Why don't need to check pmc_is_globally_enabled() in PMU passthrough
> > case? Sorry if I missed something.
> 
> Not sure if it's because the historical reason. Since pmu->global_ctrl
> would be updated in each vm-exit right now, we may not need to skip
> pmc_is_globally_enabled() anymore. Need Mingwei to confirm.
> 
yeah, this is a historical reason and how it becomes a bug. I will fix
that in next version.

