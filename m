Return-Path: <kvm+bounces-14339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0878A20D0
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47198287048
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3523A1C5;
	Thu, 11 Apr 2024 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TU0mMUxw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758FD3612D
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712870503; cv=none; b=CnTVV9Kqjhi+P56rVusckogfpldiarT0ZwaRFtr+kSrWlUPMQOXeKlnSBOzD9TKRx5xyK5O1XZjjKSjZeJ4o+ML8T/7bNlCblrLuOrFwJkTYyoMXImOqZ360YMozIblhVjB1yEJmwMmHPOy1uMM/CGBCvh+/EZQ2U4wOWWVyALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712870503; c=relaxed/simple;
	bh=1Yt5ENkVhst0n9ZblcD8w6pNSh69TM4WW67na6WBHPc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uax+v7LXhII8rjKYL8npcuQ1lsWxMS1IjIjzhjR0i/RlKHt0bbP9j/LTrdijNaaSw8IznRxzr7xQeGArLKTDbuyvcXKmxwK96lqtvuiruaCY2gkbZGCUQMrd6hCOZ+to2b+N0Z5DdoRE5llXQnbvdfK9rct7HxKO2wCTIFk4eLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TU0mMUxw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4a2cace80so179660a91.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712870502; x=1713475302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AWKnmEZY12gpQ4Ag1Ryj6TuaNWeuWlvES9pOMpv+NIA=;
        b=TU0mMUxwG23VZFcRe6MbdEosUzaDyOlOkQyhbfUwurPaT0bKEq51rJQQJ1o9xBQawM
         LqjnIuoENECrueqUfcdtTJGGpaIqsn2Jh49A4B7Qf3O8PuZgNXslP95s/a9DxQnQhBUS
         Ut7Xv1R3z/56kZeWPJM36586UluhDyEn5mQYk/9FW3xMWnh0gtMuWG3iiEcAlwm/uHOf
         UF+rrktpSEN6nQf1VjKwPwmq+TZh87KrG+UbVrKeolM/Roj5OGXbcbi+mPv3/gJcmHvI
         WHLnkbTmwb6EtwpdWGmWjnegWCKnMOyF6M+K8xg95gQ4mmWCRW4oDIaPXGPoX7vUSs0r
         TXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712870502; x=1713475302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AWKnmEZY12gpQ4Ag1Ryj6TuaNWeuWlvES9pOMpv+NIA=;
        b=j5VQzvbA6aa/RtUYM4DGCyKg9n4vsJDuBKY6Pr5Atz/x63Gx9AsfJUtCElZZ4jzSU4
         6Or8iE4dIb9AAymIAvMrvAdDfk8Zc+xsex0347NsgiKM1aqiw7JY/2c0V5vXayQRromU
         bplJ/K5LRu+K6ZGjomEW/un2/YxHgS3yakRv12Bas2vvJs/F+ugKadIVxYkKQi8OF1jR
         FsEPelgvKy/vJlq+70MAbX8ouVy0ElpBdE5xO4zPhu0yFGRT4qDYrnDMWz7VDrCN4TnS
         lQM7LiLCfCmLroHaFdhA18qrpJ5MkuA/p7GhXJsyG85cD7fJ6daNQNkOkH+9KgvwZVEJ
         olvg==
X-Forwarded-Encrypted: i=1; AJvYcCVKSrfRSNWZh/+gF8hvA6Xf/FRWKBJDYP5r4/0dI9HZ1bdbJJBbbGVXEs2nw6LlVrq/QK19qPzqyqVkKoIdot13K4Gn
X-Gm-Message-State: AOJu0YxeCH88yas/j7wiEhD7q7oIfMWA9L/b7svj/335hWOW0+N5Rwa4
	+XvJUtJt9kuvuAD+v9NgdrKPWKig9XgvPA33FVucwDfC47Vil3aY5v/iqvDWXK4fJe1LivwtrZN
	/xA==
X-Google-Smtp-Source: AGHT+IGH2cSIpCjJg5VVgi0MM3UOWFBb+tltx0R/3kd58Fx7yV5e38NRCJBGLw8haD00EsMwrzrM9fVPYi8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:50b:b0:2a5:366a:30fa with SMTP id
 r11-20020a17090b050b00b002a5366a30famr2077pjz.3.1712870501701; Thu, 11 Apr
 2024 14:21:41 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:21:40 -0700
In-Reply-To: <20240126085444.324918-16-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-16-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhUZJ7rE0SbE6Vv@google.com>
Subject: Re: [RFC PATCH 15/41] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
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
> +	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
> +		/*
> +		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
> +		 */
> +		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> +			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
> +		else {
> +			i = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest,
> +						       MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = vmx->msr_autoload.guest.nr++;
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT,
> +					     vmx->msr_autoload.guest.nr);
> +			}
> +			vmx->msr_autoload.guest.val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			vmx->msr_autoload.guest.val[i].value = 0;

Eww, no.   Just make cpu_has_load_perf_global_ctrl() and VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL
hard requirements for enabling passthrough mode.  And then have clear_atomic_switch_msr()
yell if KVM tries to disable loading MSR_CORE_PERF_GLOBAL_CTRL.

