Return-Path: <kvm+bounces-32207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D687A9D4228
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F470B274FD
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813CB1B5337;
	Wed, 20 Nov 2024 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8PNpB1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D316DEB5
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 18:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732128180; cv=none; b=tp6nHKI6IfaLGsRczuiYmc6L79zhFYJUUK5jIdO3qKfkgYhPwvB98f6juLdQeNXhZp23pQHcToh8lyN0m2Al5QBnfKHzzFZAWbdvdQaTKik6cGYfoClxL6s4sqYOVgZ7etupytsSQR7WfyLeSKv/0vyiaRphlUW76DYPYsb/oxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732128180; c=relaxed/simple;
	bh=FAG7Osn8XZtmnlVb+3K/AwNFN0PNCGVxYL/QhmR548c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IKQDhSI46QxoFbjmELopE1lR3mTM4XJySIlQJUJ5MPCCT6HmIVZvye9BzkHUlfpQXmGV1vpU7LhvyCG005zT3sybEU3toHCzy1cNkGFefs3lizLS9Fi13X92ZzkKEK7oM0xPhGdK1dry0WMPdKCQtXpBMsiXkXp0wVOOFbn/+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8PNpB1Z; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-722531f7806so155191b3a.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732128178; x=1732732978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/oFKIZPyQ33M3QhxMDJu1vhmcBP8Nem+7EbpdGy4/cY=;
        b=p8PNpB1ZIX88MKlQtYHFcU3AeHjaCBNNjF83RPpI1sbKBGNdr+6q3jrlTkd2Dr2YG7
         VucLJBAJa0sLfsHK1opSi/kS7CW0PnLRWb6sduwIONKV1WfzRA/4LdFTd7tnX8bRLbWw
         7woadS9WNUIOrCd0aEBONFgZ2QEMrDp904XRXfFecz3AEogA2hyODydX73d/00oKVHjw
         NjzLUSMDATc+g+EKxcjZ81HjEchT7AFMRFAjtY8N8QIKlUN1diPM5Z1hsTVsk9T+C4R8
         t3CMcWe5vQEXyBfTfsdLxtxq/J4DbFQ2NqH0wO9cSniK3nXYCilbjvKxGEw+fpcXA722
         7W9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732128178; x=1732732978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/oFKIZPyQ33M3QhxMDJu1vhmcBP8Nem+7EbpdGy4/cY=;
        b=UXkuvOb2LILXI5G0saNZTMzdwEXOZX/9g+RZGfdFGxjfmB5Y5lLYItLGHcPmw2eHir
         +CfIwuy8Xbrky8KccvmkiBqakH5mSAe/Inesjk5efM4EBZeQBhQ7xUuPVG9pROx+gW6E
         yiDDeQ3Kw5y3sGWPeMBcaGCmIY0SBCLtGwJwbJuAfYHJ/qsxPROnyciuiM0L0Rm03XOW
         kg/ZGhsHWAdqVe1JTPpDyLDCOmGNdTHBtchmuBKJWmPX1+gA5akGEInVN/1AHuHESsVc
         A4YSqky9TKCdTtSOLhregsysX5wLFYgBIgCQnzGZFPGs3CO8LplJ3o238/ZLHHwmHqiP
         Qw0A==
X-Forwarded-Encrypted: i=1; AJvYcCXa3JlAIEkosNI5fj6VMw/VsCoJ0MP5BHekCnXlhSiMq1iFiKIdKqphewU4WKnG41z8ff0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrUzMaRaZM0w+0FG3KlDejMvIXn7Re4VQ1Keo3Pya32E/jS1HS
	MCUNL7u8M97pz4zzzYUDH9V4ZbbyATy9GG8GXsBwaV3+SI+SAdRBIyoS+bHT6cXlRkW2SfiHHQB
	7eg==
X-Google-Smtp-Source: AGHT+IG//LxhiDF25kx95vY3LI5DvKRwadXHFwR8biNKmYDVJfG7r01Rwr82tJGTaq5OB4nI4z5SpF/eY2A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:c3d5:b0:20c:da66:3884 with SMTP id
 d9443c01a7336-2126a44d20dmr19555ad.9.1732128178593; Wed, 20 Nov 2024 10:42:58
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:42:57 -0800
In-Reply-To: <20240801045907.4010984-39-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-39-mizhang@google.com>
Message-ID: <Zz4tsayQblkJUOtG@google.com>
Subject: Re: [RFC PATCH v3 38/58] KVM: x86/pmu: Exclude existing vLBR logic
 from the passthrough PMU
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
> Excluding existing vLBR logic from the passthrough PMU because the it does
> not support LBR related MSRs. So to avoid any side effect, do not call
> vLBR related code in both vcpu_enter_guest() and pmi injection function.

This is unnecessary.  PMU_CAP_LBR_FMT will be cleared in kvm_caps.supported_perf_cap
when the mediated PMU is enabled, which will prevent relevant bits from being set
in the vCPU's PERF_CAPABILITIES, and that in turn will ensure the number of LBR
records is always zero.

If we wanted a sanity check, then it should go in intel_pmu_refresh().  But I don't
think that's justified.  E.g. legacy LBRs are incompatible with arch LBRs.  At some
point we have to rely on us not screwing up.

A selftest for this though, that's a different story, but we already have coverage
thanks to vmx_pmu_caps_test.c.  If we wanted to be paranoid, that test could be
extended to assert that LBRs are unsupported if the mediated PMU is enabled.

