Return-Path: <kvm+bounces-46720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C23AB8FA8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 21:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CDEA16A80C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3FA296D2E;
	Thu, 15 May 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u8gD5bD3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83FE257452
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 19:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747335978; cv=none; b=KOK+js0BuXWL4RxmHnKQmHf7Oe/ozWlMte3KCk7EA9XU0fCo94O49mEOneKHvLqx7jMmWDyOii1Rw5auHssNA3KR6W4+atfQ/PHjbQMktuDwwBrRfunHqCQcdEzqDpooXErV2B/YbwAdk/rA9ePLJ5BS6MQ4SOQnqcPf8kTQCOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747335978; c=relaxed/simple;
	bh=CnL0sloZkje+Gy9jckN96zccVLpEiTSNRW+B4JDbs5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=av+7+4P6WN297TcsL4aQ2GcXWfsfNF2LWuVDG7BAPzwk/n/WyqqXLe2JI2Dw/znYFC0zElLb3aR7hnb/KaGxHiwa41dCtDvvIux0ml1RC2sKR6F9KxbVoEhltlMjd5YPBEj5McawjJ3A4VCxndvH9HlhFI/EEY7fYaJzyfvkMdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u8gD5bD3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c371c34e7so1492876a91.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 12:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747335976; x=1747940776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zLPqD/um8R1X6WXUHjnXwyW6WNUpCfKj1WPzSpe7c+Y=;
        b=u8gD5bD3RAgyHbZ1P3Jn/KcnmSX3vkdx+bnKAQwKXR28uwazNcms5KIhHp5s9oNOw4
         HS6XvFMJfbcsyXanK3tiLlvZ/1uEAACC7bR0+BPvMAf7FE6038rVmPkTD/S68SfLUa7x
         VbKtnUX+hiqIO6Kj+/KfEBhfU0c9gcXXqwYsjNqDwBNLpEVEbPW04ANS62azcBDPJoli
         /InLMeGWY/WTQdm5rGjp6QIzk8Ndex8bZtY7BmYZbZ84ssxOVkn+RoxVXhklVc2owJV7
         +z1UBYskUDlpQMEKor9LqERun0P2RdvYvBLUJcd6yB8QsQUi/F902L12tBv0b7mjoOE5
         n4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747335976; x=1747940776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLPqD/um8R1X6WXUHjnXwyW6WNUpCfKj1WPzSpe7c+Y=;
        b=IttZvJ9/1npdZH44aZBYNXYxlKAPr6dcleXDMuWhqsyP53G9yfBtNChF8hdlN6wodM
         afIB4KIsHBekiM9lxbPOzS3XUC8l5PSbLcwRJNvV/9hsjpIb/2zstdwUMdI6q8SIHe93
         JLYzAPOy+XPcPj7yS0rOqXxTG/L4F+/b5N4/tqBB7R2+7IssWmkvvsVdHiydPESem+uo
         XfRj+BCD9FJu1j5Ij7DoluJ4N0EzFNrWkfY0G55QtC+YJKSql8dbSrBYlSJk7eBJmdDU
         3i88no3cBimqzKvigI4ElIvEknTHeA+jw00RXqMbzYmNU13UkEHp7h1uPZAT8WZAPu++
         ApSg==
X-Forwarded-Encrypted: i=1; AJvYcCUXyVKATJaBsqsL+99r8AWZHP+FMUUb9dmq0uCy+S+C4QSnILk1BVDaqkLgnVGOKLu+MIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLIlCBwRNRxdDBu6gaNR0MyKkZNuxWZENgvL/Vdr7Vh3Kuqea1
	EFZm2Dh9FaAx5w7rtFiB6rKtqiSgBR1GlbToZjJkx/D+d7c7WC8GdXE3fGH59kJIgQhRgYn554a
	S3dmcRA==
X-Google-Smtp-Source: AGHT+IENNFvaXlYo+BqzOoVnfUajKC5r6pRv5u9QDBMqQirkEdvSRp0jQC+k8xHSU7HIox0eXH/Z7cf4jZY=
X-Received: from pjn12.prod.google.com ([2002:a17:90b:570c:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:301:c5cb:7b13
 with SMTP id 98e67ed59e1d1-30e7d501e03mr664683a91.3.1747335975881; Thu, 15
 May 2025 12:06:15 -0700 (PDT)
Date: Thu, 15 May 2025 12:06:14 -0700
In-Reply-To: <bac13842-9d15-4664-a20d-4916abcdc3e7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-24-mizhang@google.com>
 <aCU4Uuhzo_ovR7r8@google.com> <bac13842-9d15-4664-a20d-4916abcdc3e7@linux.intel.com>
Message-ID: <aCY7JkJA25D2HfXF@google.com>
Subject: Re: [PATCH v4 23/38] KVM: x86/pmu: Configure the interception of PMU MSRs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 15, 2025, Dapeng Mi wrote:
> On 5/15/2025 8:41 AM, Sean Christopherson wrote:
> >> +	if (kvm_mediated_pmu_enabled(vcpu) && kvm_pmu_has_perf_global_ctrl(pmu) &&
> > Just require the guest to have PERF_GLOBAL_CTRL, I don't see any reason to support
> > v1 PMUs.  It adds complexity and weirdness, and I can't imagine there's a use case.

I take that back, there absolutely are use cases, especially for AMD.  Any VM
shape that exists today should be compatible with the mediated PMU.  And I was
dead wrong about adding complexity; KVM already needs to intercept GLOBAL_CTRL
if the guest has fewer PMCs than hardware, so incorporating this check is all of
two lines of code.

