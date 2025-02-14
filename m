Return-Path: <kvm+bounces-38196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C50A36739
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A89A81895317
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15191D8E07;
	Fri, 14 Feb 2025 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfZ8jA/k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36CB17E
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567262; cv=none; b=adsl3ElzATEJbZLE8ZiG+hDqLBRV0PWFB8d6i+LoBO0SSrVoymhUvk7jcLiGoZkk/vpeF8bSO+7iPQK6r0yFydwKdvw1PTktgt7350bKFuyZEO77UIGjtStGpPCTgkjfc3o2JGTOn3mdMXks6zZ9vwa4+2WGzYjRCLkgmicxTvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567262; c=relaxed/simple;
	bh=tRw04Zc6nB0hKmcczDfw0vEBfoaXJ3mvh5r6w/08lPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LJpv2LeLfTLandOsuA/PeS7O/OBpWmtXSwzZvHhEMn6nTA1gPiuViEG/2BADo2RwD4BMEev2fiVSmC3qfWxezCgGsVzqjHA0dNIHiSIJuiVXsmezP7RIAcHr15/QhFHSgJyLv0ZWdgUhv1RtzPtjRHxuOUMLKQLZXO7zVylu9nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfZ8jA/k; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220caea15ccso82683535ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739567260; x=1740172060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AC7fVstT5F1rq5M5653hsrO6Cb664wpeHll3UY0p88I=;
        b=bfZ8jA/kgtMlt0jb7DNATvttL4y1i+q4yHtcZZ16GJ3rNhdBAWEcPzJG/Y1qQj4sZp
         cw16syA28WajhFgLKff2qD7Xl7+lP72rLxTVNhdmRYHxJ2rWzqC965Hg2MIIaWLmxzzK
         pM4+5L3sMEZY/C0qY2ubbOvT35k4KCytYglJwilnWsx2YjKmcmrpmyGL4O4L2n0AcA6O
         1QUtXtzF9ngWCF2/aUCBo//gzFX8/z0SRUxc83lxoFN9V1GWpDfLE3ruuzzLR11YDlvN
         6Fjxel4Ybio/bop5phya+RJ0BFQ94Qo8jtJCbD/6uvmJRLv4vC7FkCXI/6hOauaHC1lw
         S0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739567260; x=1740172060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AC7fVstT5F1rq5M5653hsrO6Cb664wpeHll3UY0p88I=;
        b=azSh+7V1+irdTNNO5BEmqQU6eCfijwWAmrD2x/dGSHKhHs5RKIBvfA7kmcxbH1lyRl
         +ZtoyJcMkMluj0VNU39vkMEe7gF80UGg2k1CkARvxLPnnEccL29lH7BJhJ2e0TvZivdZ
         kbBiGDavTE9Vc4nwO+sF/6CAGcFDny5qBkjNLRjIahpfL9h1wTTePiVR6wK5jRcyRLI5
         Qu/Qa50eVmvKITqUsKuFnyFyB6HIwMcJCF010Kv3J9F33YjgwZ0G1BDEPKiw6v6sSXkQ
         aO7gGdi1/5GWE2py5hYui9lOjJJCDOQCHMm0A9Elf2N5WsKmo2w0jbifEV57w3eVX8Bn
         3cLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeXee0DJ8WBtRS/YJRg2oxU2edQNJI4rNeqQs9VGUCt36ChWPnvKZ+o4sEogFoGzjABJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ccUaDTZbfwzUdzD2L9u6wMHdSAeEXl9uoPAICra8BmoLb5T/
	rEfRSmvOONGKSmghUSfyD5I2gkorBrKgXXXoopmhhK+dgHviuoYCrscu2dpW0CjFxwQFx2U5WMf
	gfw==
X-Google-Smtp-Source: AGHT+IE9Jbt4JSPrreEaB1Q3EmmUg93YKUTtLFr9V5SkpAw9E3BaKzT3FXoT1l1q7YyUtqbLzNjBQxkgnDY=
X-Received: from pfbgj13.prod.google.com ([2002:a05:6a00:840d:b0:730:7d23:bc34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a9:b0:1ee:69c8:8d03
 with SMTP id adf61e73a8af0-1ee8cc07bf6mr1992372637.36.1739567260120; Fri, 14
 Feb 2025 13:07:40 -0800 (PST)
Date: Fri, 14 Feb 2025 13:07:38 -0800
In-Reply-To: <20240914101728.33148-8-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com> <20240914101728.33148-8-dapeng1.mi@linux.intel.com>
Message-ID: <Z6-wmhr5JDNuDC7D@google.com>
Subject: Re: [kvm-unit-tests patch v6 07/18] x86: pmu: Fix potential out of
 bound access for fixed events
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 14, 2024, Dapeng Mi wrote:
> @@ -744,6 +753,12 @@ int main(int ac, char **av)
>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>  
> +	fixed_counters_num = MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events));
> +	if (pmu.nr_fixed_counters > ARRAY_SIZE(fixed_events))
> +		report_info("Fixed counters number %d > defined fixed events %ld. "

Doesn't compile on 32-bit builds.  Easiest thing is to cast ARRAY_SIZE, because
size_t is different between 32-bit and 64-bit.

> +			    "Please update test case.", pmu.nr_fixed_counters,
> +			    ARRAY_SIZE(fixed_events));
> +
>  	apic_write(APIC_LVTPC, PMI_VECTOR);
>  
>  	check_counters();
> -- 
> 2.40.1
> 

