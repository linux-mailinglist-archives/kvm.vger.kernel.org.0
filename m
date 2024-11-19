Return-Path: <kvm+bounces-32084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CD89D2C09
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B067028B281
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 17:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1571D0438;
	Tue, 19 Nov 2024 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fR0q9DjD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EBE211C
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732035843; cv=none; b=Up+KEI4SN9kVb4Dg5lgbamsu9PZR7Cp1qrCi5GtILnoRTmRVbN6tNrOmGwP/TGAj9XOeRXogob3ueq7UuVI5ZRlmrJf8jEGDrYY4Ef6GK7o7JrGmPbCVHw+owdOEA50SatseM0Yl27qpNBaijA8N/d3my710OWqQj0ghDQ4GFvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732035843; c=relaxed/simple;
	bh=U54ia5oSk8AQ9Q9yAoVWnEJ65wAHZPeLYyLnyOV2sZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MagFUUu0FJ7A/TcQc5+bHT/nsnr390iQbQqqrjjH93/J/q1FxptQ2diSLMDowCKxh9YpANxexQvz1eUHjS+teytHXtNGqF6ly+V32dKWr8IhTOT64MV7TdGn1umSXZWj3xgXgVcJI+MnTIC6LzbXPt2vDyECQKPTIk3if4Qkqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fR0q9DjD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e38aae1bdb8so2822812276.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 09:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732035840; x=1732640640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pvxmItvmiUYh43bZlZBFfMUnWthWQF/PcFodKRvz7CA=;
        b=fR0q9DjDNT6EB3KPKf8MeuFfpp2IWIOhw17EbeNH5vkavP16eEBL4E6W/nu25z77e9
         l977Q1znOv8oKt35y8RvgABsTh3wakyn8DeCLYn5YELR8IooXOwrLgUgur/iMxWk51E9
         nSAZ2SAmPRXxvbC6G952dtWCTzRAmkKKAewuqXl8izuMZawkbagdHYs8inBIqkb37NxL
         alyM9aNH7KtKpnyodsiiPDhGgBiY96C85YuKSjV34eWSIyMlNY5xlpq1Tfe6i3kIl3Oe
         byebziRx4goBPbUnQZGRl3OntT+hEj+C4SvGs3aOmW8W26wtLXRkGwpS1w0dCMdDr8O2
         38vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732035840; x=1732640640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvxmItvmiUYh43bZlZBFfMUnWthWQF/PcFodKRvz7CA=;
        b=HX3l09nEW7/ytjp6H/O5lxnOaaMXRPSilpbJMi1v3AT3mKK9d7yvQliNsNCBDGj5pb
         cRY6rGOydC9GNdnemFgtkVN9x2sSRWNZT3KLdoH642KrwTGG7Sr2btqvUlihyQuKROP4
         D/YrypjzLc5xGhjhm6BY/uov5kjTBqU0bT/2pLREXk12tLUpKSJztmDXkKH/T2GX/mTt
         nLB8bgEOUJP08f1iSGcxyIrYJFzvquFDk8Obx+zdVv+kjqaiysTgNw7tr3g2Qgw/UALN
         lZH4djGruqGDYVo107y4KbC2hPVoPP1AS1qkydzFecpml/kbZdFeKClg5eWI4QY3L3My
         X/mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyrUR2U4iPRQf2QNNALcuvbqXF45rkMqQT6LTVZoxPTFXjQpD1UepBo99bL9JDBYBcxp8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1cNG9bUQDT26tS4mgxcbP8hWX78KGA8I/grtQDcowy+wuJO5U
	95Pxb9elsJYhVJgHt6bnSq7Xq8UTZGR8DAreNTncTiVQGIrCUE1FPjZrEKodRyc0XuLb3n8WMed
	Zug==
X-Google-Smtp-Source: AGHT+IFr9FloVnBcyn0OfNahrmO7SUDeVY3cuyo62UFJEZZiaYhD1FzNdug9Chl6LRH66ZqPEafnvLNQGos=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ab90:0:b0:e38:c40:380f with SMTP id
 3f1490d57ef6-e3826125c12mr328138276.3.1732035840694; Tue, 19 Nov 2024
 09:04:00 -0800 (PST)
Date: Tue, 19 Nov 2024 09:03:59 -0800
In-Reply-To: <20240801045907.4010984-25-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-25-mizhang@google.com>
Message-ID: <ZzzE_z5x7D_trxnq@google.com>
Subject: Re: [RFC PATCH v3 24/58] KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
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
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
> MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
> perf metrics feature is enabled.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 41a4533f9989..d8317552b634 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
>  #define PT_MODE_HOST_GUEST	1
>  
>  #define PMU_CAP_FW_WRITES	(1ULL << 13)
> +#define PMU_CAP_PERF_METRICS	BIT_ULL(15)

BIT() should suffice.  The 1ULL used for FW_WRITES is unnecessary.  Speaking of
which, can you update the other #defines while you're at it?  The mix of styles
annoys me :-)

#define PMU_CAP_FW_WRITES	BIT(13)
#define PMU_CAP_PERF_METRICS	BIT(15)
#define PMU_CAP_LBR_FMT		GENMASK(5, 0)

>  #define PMU_CAP_LBR_FMT		0x3f
>  
>  struct nested_vmx_msrs {
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

