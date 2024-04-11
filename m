Return-Path: <kvm+bounces-14318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3259D8A1F55
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62F711C23131
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39A614AA7;
	Thu, 11 Apr 2024 19:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ji3XyGUr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2053D9E
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863075; cv=none; b=R0VH6bUH+DbJklCse9atx85N99+0bN244g3QgYSW2aQEHAT7Ld8b4tVUtY0/bC7ngc7Vb+INO6rWeD7pZ12cKWx5iGLp4fW1jDINaH5r/r6zonUCj90zOVc1FugU0Musen3uDNnlTA07w09f4cqJAqO5jSfzZuabudjXlQuX544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863075; c=relaxed/simple;
	bh=sD4t/uLxUXQneloPRvioqFpGGr++WQw2Vhn8idLNvnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aK268+UbdnlaoFJtVoDUQS5q5Eg4+OgfGJtoTXAQTeT56koHFGV9HnZ7ldH+TB7lR18dN0On2HEEO9H3ImXVXWIrsOYG7mPQpLZAEfl1WapbbI9zW1sPaEtVHSzqxnn5cTsK2Rox+UNqpl1Uc0a/2STj5FDU3NSE3jfYy3qG3BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ji3XyGUr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so159746a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712863073; x=1713467873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LMIixoIt6lY2SkR94o/u4nUsQeakPmVSC2HlUkV0a60=;
        b=ji3XyGUrxqhwI1zj90rfih7kd0TW0YjfCRz3T346bA7OGtMLhT8NjY06BjnAlzBUw+
         OxmiuMvYQsMKttH0jSge8uOcp1izuIXfV0D95sHdFR4wdoPqy2XYPE90nxjtX5K/VzIu
         e9LDyPKnA5GBaAjeLP5jhU6cynBesB37QYvftHmbNu56NLvDWcpX6JEaoK+0qo5bafBT
         1VpIOOmXkSLuX0rzH+ZkkbGOV9LVJROgKSDeOb2EEU5gqmMd2NE+TfCHetXQvjPTOX50
         r9OljLwy2I+wPKi8np1FQUxXuqOCRZBD/k+uC8XIUeAvFRtiONSfzONu1P20xbkYsYkl
         XwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712863073; x=1713467873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMIixoIt6lY2SkR94o/u4nUsQeakPmVSC2HlUkV0a60=;
        b=iqSwI1/rTCQ1K545En2qW1oA5ARpQ/W7mfbJzWOBkX2it/WnIqOjh39fmkXV1NIHfF
         FAbSlbSIV8VDR9jXjhbKb+sgvLZ5kAz32/LiARLUgManWVlFLLITJh7YnryhM7hkGno2
         XD4DPJ9csBink5+PACAJp83cpfWLbzAo4x8aGa4Pujq+Pr2s5m/7loB48zCUg40fMTBi
         xSlEqMXy5t466ZccwkfrEt67TZgZplVSKrpFa/ALPW8LkGuSweGIOiSIdcGLbzZfR31Z
         +EfeLJZceOtsPjbSn+avS7rvcqsv1m58bdeJyfilm8LE5GxKjMpfFC+9VpLpbloxRjkG
         hgAA==
X-Forwarded-Encrypted: i=1; AJvYcCUoMKH/+NA6/1HGNmfDkRF8W+tJrd7CbzzZt16wwJ3rbNqO+RSlGKQ5lZsJodRje3WWctlZJUOQm/GyTI0Pqlbup7td
X-Gm-Message-State: AOJu0YydJJzpXz+OhQPq2Eq6U3+VO6DTg6nDKK3M+l+HdtU+SpEVwItc
	Ebb8Qvbk8ZBj1Y53oRQj3GkAyG0VGZ65nWZRCfKk5KIv3LWlr3OzsG6KlTmrqytjCuxjZMxj3S9
	e+g==
X-Google-Smtp-Source: AGHT+IFguQvCmFsdS9wZt2947ESaktoib4WjScGApUlH985d9Wk7VnVVsEw7G9iuNo+2wFb72ko/YplirSU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1761:0:b0:5e4:292b:d0eb with SMTP id
 33-20020a631761000000b005e4292bd0ebmr1192pgx.2.1712863073071; Thu, 11 Apr
 2024 12:17:53 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:17:51 -0700
In-Reply-To: <20240126085444.324918-7-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-7-xiong.y.zhang@linux.intel.com>
Message-ID: <Zhg3X_5A6BslIg-u@google.com>
Subject: Re: [RFC PATCH 06/41] perf: x86: Add function to switch PMI handler
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
> 
> Add function to switch PMI handler since passthrough PMU and host PMU will
> use different interrupt vectors.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/events/core.c            | 15 +++++++++++++++
>  arch/x86/include/asm/perf_event.h |  3 +++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 40ad1425ffa2..3f87894d8c8e 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -701,6 +701,21 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>  }
>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>  
> +void perf_guest_switch_to_host_pmi_vector(void)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +}
> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
> +
> +void perf_guest_switch_to_kvm_pmi_vector(void)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
> +}
> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);

Why slice and dice the context switch if it's all in perf?  Just do this in
perf_guest_enter().  

