Return-Path: <kvm+bounces-32079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B39BA9D2A91
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 17:12:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3490B2A42C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F7D70827;
	Tue, 19 Nov 2024 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mULPKh8e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3F51D097F
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030992; cv=none; b=tPdMr+DQLiWjfoad4PGjx+k4DHSJi2hB9pKDa4clF8Y0y6yLE2u4+61AWv1l2HYv/41MysGWeXRTf8udZXn0ogzp82qBCzRIDCkLRaM8icMq/jUJmKtsG/RoZvou26K3VsKre5NDlKTPQSKB3TQkY1UGgca+VWXw5ZO66MlobqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030992; c=relaxed/simple;
	bh=KjKAUisPP4PTwPSuoMZH56lWV/0EBojMgOmHPXphLGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N/E/cgoV4abUODwMTgAqIujKv9r5CF/7uV7/8Yj1lFcIxD6IX2STaNUcXgT0/pDktZFK9MtF4QMG8cKC2ThoDMVwRDQG3Nz5elXsWu/nojL/waox3yEuH2wOQUraOPKhq6ojirZ48iPT0fzveqQuigRMcYoweU3rB/RNdNtDVes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mULPKh8e; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e3826e5c0c0so1818400276.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 07:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732030990; x=1732635790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHYzDNeBKakJG8hRVBgbLBhXsiM23myvHWLb6lBUBoU=;
        b=mULPKh8eQiesuEd2kTFpxz6W1Vy5fWohVEJ6QOBsOAtUNGhS7m7P00yd1HcdxWWiPp
         5lPvx3/RZDTbjkVUWKgjrxmrxtkqrKrOauhcWHQAOsqGJ13X71InDlUFwScGJYy6ACQY
         9no4jjJ2m767vXZWWebvJ+Dy4AU1/OLh4NPhGkJHul9rjA6pv91YXET0UzP18I1frMGM
         WITQUEFrWknTqQ4c0fXOxSW3PmMppfDVpACaYkRvAdZHaEUlK+/ffxd+xJbAK+uewK8c
         cO8wNs7p04Uxvf5PFyafHcs69IRIIJqZBOuy6VT08lQtiVuannsqr9Kh81O2hS8BZ8pH
         rgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732030990; x=1732635790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHYzDNeBKakJG8hRVBgbLBhXsiM23myvHWLb6lBUBoU=;
        b=qu7AwC3tve5ppswA2Nq8h13tIBgsL1Zu9tE3bw9EIXR4gFTB71S+d1tEQuTdWHgV5r
         GOko9dIlF1esZ7kivnQw4pAvN9f/1PoLaGhzqeH9DsPJ7dPDPacyPOX22CMFhD1SNwIT
         0FD4ZlnAyA21QVDnOI+BGY+ivZbo2sYWkp2u3Rhr17v+dLQ4CHyKyKbqck+9vkGVgrLW
         uhc1h5gA/b52o4BxZgAa+baXcSBeEF2UZAHkx2x9DF8/W/YlT/dQNL9VwW9ZlEew9SYF
         /TtDrz/nL4DpzUzyFe82EVkfsKlbGcgG/9IYYsmvqy/DLFU4XElCWaZ99BQjuirRFhu6
         F8Og==
X-Forwarded-Encrypted: i=1; AJvYcCWp6ivHRiKQu8OVnT6Kimnsx2FusKVYvxqvAuAKAMxVNalU2m3HnUWHuCVEsxFGhAA06us=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3mv1T/oFqi4eIxW8Sh2x/GVUxUzRKhOxIi0oNDU3GrT9czP1k
	BPpdUObpEkMkUtkf06EI2PivevoeH0HRfNBUjCFcoJuyChwyMNlFxiyrpuCp4R8bol/RpoA1peV
	fbA==
X-Google-Smtp-Source: AGHT+IGqou6Wkgd/f8arnHNLYAjcsv42Bk6ENu0WspAXb1XpNYseCu3msu9X2fK8hbCplo8+EwidHJLGx0s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:e84:b0:e38:7c92:33b0 with SMTP id
 3f1490d57ef6-e387c9234d7mr42958276.9.1732030989964; Tue, 19 Nov 2024 07:43:09
 -0800 (PST)
Date: Tue, 19 Nov 2024 07:43:08 -0800
In-Reply-To: <20240801045907.4010984-23-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-23-mizhang@google.com>
Message-ID: <ZzyyDC7nh_5XGaHa@google.com>
Subject: Re: [RFC PATCH v3 22/58] KVM: x86/pmu: Add host_perf_cap and
 initialize it in kvm_x86_vendor_init()
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
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c40f551130e..6db4dc496d2b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -239,6 +239,9 @@ EXPORT_SYMBOL_GPL(host_xss);
>  u64 __read_mostly host_arch_capabilities;
>  EXPORT_SYMBOL_GPL(host_arch_capabilities);
>  
> +u64 __read_mostly host_perf_cap;
> +EXPORT_SYMBOL_GPL(host_perf_cap);

In case you don't get a conflict on rebase, this should go in "struct kvm_host_values"
as "perf_capabilities".

>  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	KVM_GENERIC_VM_STATS(),
>  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
> @@ -9793,6 +9796,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>  		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
>  
> +	if (boot_cpu_has(X86_FEATURE_PDCM))
> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> +
>  	r = ops->hardware_setup();
>  	if (r != 0)
>  		goto out_mmu_exit;
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

