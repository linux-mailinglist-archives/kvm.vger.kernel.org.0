Return-Path: <kvm+bounces-32059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6805A9D28A2
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26164282D3D
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E771CF2A1;
	Tue, 19 Nov 2024 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oHjRfWxE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EDD43179
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732028061; cv=none; b=LjAX96ddHz63sFJEhj2Ks8xK3sGgNAA59q0IyO18uBGS/0bLMjZ2gUU5YVZxenPzJPc2s74LcjVeIXOZ/O3yzkpSboJMbj1n/QysOLCcovwvfLDmimE2pNFGrn/wp6cUyUADgJYuGFcmjgsnGw88x45E7dIeZd+U8I49dY4cpHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732028061; c=relaxed/simple;
	bh=9128xCGIuXvaU49NjF1mWOVwIXLIuhSsSSvvDia+hRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BJhCVKtGyuM3aW+wRSen8/gEET0n0hdnGGWYlhc+Wg8ZQX3Jk91igIE3krc3qHQREpU/L/CZyLaVCWsGmtR07GxiN4mwszLZPAJX+X46I7Vkli+GIJgm4lRJgHRqTtT23j6joAY0pGdwU5wzRoWdSU3CHiIB+iE3bvof20GdxAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oHjRfWxE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e38bf015434so712472276.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 06:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732028059; x=1732632859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ng0ADcAUF9BEyC9uJKl/YJ6KNTlUn/uj3eRa3WTv12c=;
        b=oHjRfWxErSqPwtqb12j0vCL79W1CkdyjN1yCvKdrGJ9qRw+EoqDkxLRyfA7mQjujqy
         1Buv15KL3HAvGer7XOwxTbgn8dw6o6ed022FmLvrFmHKM7h1mFi5x0YqGj7TMQapfZxd
         0nvB352crXsBCuQ61G840u76kyImV3deMwbEG3WC/MJ2t+s+CawbsZZV2+tl8yKFCk+k
         3KnIdMQLjObrEnxnJsY39ODdixwnHNpA2snI5g7CacDE32R6fGEhHJQ3epbKfVu1waMa
         1HNM0QZe/wvA5qvErjMmBVdrLGbHkzoOj2bmmK/qYBfUEkdiglhs3LST2b6Cx+Alt3Ha
         IRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732028059; x=1732632859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ng0ADcAUF9BEyC9uJKl/YJ6KNTlUn/uj3eRa3WTv12c=;
        b=uHc+ifmqSH3EmQxHKUXt2pf6bI+TAFvwBUGMKFUHRoD7Li7oJvLEldw83oagUKMFB7
         d4+2Ysmo7oCpUcE0GoLA20gEC5sleHp6FoEz7DyLIGb37H43WT01reun5ktxob1DdXBJ
         CfauzWX4qopxMYrDh0TmXKw2EsKvcbytFRARGZDrrsXzaLfZ1iA7+PtzJWREGuUA6itO
         EjeVccULEgfIz/9Pw9Fx830KpVfsK7PDrufJLNA28SdhvgPGN5edI2tOA+d1GUbkEQUg
         yXY5JSLuD7aIbS3eKCQiot/sltNIHD23pDay2znStiax+sQzIC3SNIQiAGvuwNE6F1kX
         MZ+A==
X-Forwarded-Encrypted: i=1; AJvYcCVSEaDgBwEm9tL/dv9LdbuIZBlAnANPv6bs6s7ic666PYvFU9BG3Y4TtJZlgsrSdHQsgUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUzO2nTQjTNw1mtM1Ztkjggxn8/2xaJ6BDb/UoF8Aak5oDvGs6
	8rWCNBwyIDdHHgHoC8Aazr6mre5ZCE8wQ4i/hJEa99o0EzVIxxSD8nFB1f57uDPBRKha2twMlhy
	C5Q==
X-Google-Smtp-Source: AGHT+IHiBjarvPBtAHSxJkTUMY7pwcio1/kissXeruut+bT10tYNA48Ju6CocKcSJ83LEgeAx93OLOCj1yQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:acd3:0:b0:e38:c43:3002 with SMTP id
 3f1490d57ef6-e38263d33ddmr171019276.10.1732028058911; Tue, 19 Nov 2024
 06:54:18 -0800 (PST)
Date: Tue, 19 Nov 2024 06:54:17 -0800
In-Reply-To: <20240801045907.4010984-20-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-20-mizhang@google.com>
Message-ID: <ZzymmUKlPk7gHtup@google.com>
Subject: Re: [RFC PATCH v3 19/58] KVM: x86/pmu: Plumb through pass-through PMU
 to vcpu for Intel CPUs
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
> vcpu created. Note that enabling PMU is decided by VMM when it sets the
> CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
> in intel_pmu_refresh().

Why?  As with the per-VM snapshot, I see zero reason for this to exist, it's
simply:

  kvm->arch.enable_pmu && enable_mediated_pmu && pmu->version;

And in literally every correct usage of pmu->passthrough, kvm->arch.enable_pmu
and pmu->version have been checked (though implicitly), i.e. KVM can check
enable_mediated_pmu and nothing else.

