Return-Path: <kvm+bounces-48854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8F6AD4305
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5BC0164CE5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D8E264A74;
	Tue, 10 Jun 2025 19:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dtdgQTeR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAC5238C20
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584561; cv=none; b=hRUdWZgCSFwKCeqm8Gq+X/5Nmsal7yUI4Re1+NKZBlOcMhIqxQFhjwv9h4qeEsvlEvyb1eyWmw/LlaSAalbCZx70/D5G46JFt/X3yTi9whcjjRkn8uHbFWmzIgOrempFr0RB6/FqvhMU1nfGCSS13YLhwXLO4Z04Bw8+gkEQ61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584561; c=relaxed/simple;
	bh=BNhw0XBfXHMOeaPgTMY/f9mkfBnPLyvADW3B1BmbS2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hfjGUO5d5FSFfdne82rkwvb6jsoukoGKbL6ViSDA0uoKsQoPCF97kXcXcXZTK9JneL5qCGmvn0YVjFrAVcA96n/dbfQHdecCBTV1TocXL7iqy3kIReGqGLkLMVzJbFwIZRyFWAR7TYHCFUzkuel1uEHSYB4YYvGPuWehXRxZplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dtdgQTeR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so1505551a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584559; x=1750189359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKLltdt/WLKHq128Ze0+XQKxN6okQr6D2NCcuRhNDJo=;
        b=dtdgQTeRpOkeqnNZxz9YfX/UBVwMGybwHCsds6BD/CrRfbg3FPd3iJeCaqgiOWI9Qn
         wK7VGv2BPcdKeCjznQsOl54JETp6OM7XVsVSgFuC2ntxm6aC+VAZkw1aJT3yhuvWH1kG
         njAikuu5GyaSHSxdwUT/GKD5aPuDt1pvA6NQAGHz1jTRqT6VPE6F397q9v84NWEnh3GE
         2sUIptXQ79IzUFbmRCyOsw5C932BfzKi+lrW4KF5ktgYjuszgIpbJlwSju2Fw4PLjCH2
         ViumX2pudRvAxBWk2IC/eokLXO8by36xH+HUK67rtFDwxrTxGdfSPerX0/nDQzwF7xGo
         kpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584559; x=1750189359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKLltdt/WLKHq128Ze0+XQKxN6okQr6D2NCcuRhNDJo=;
        b=CPlknZmMSBFX0s6TGwNU0gcEkvN3MmaGNIwCFD7WVquvaoOz6Q+Y1x1gVTsexZE5xi
         alaR7wzkU+Rt3FCp6j2NPmF1vQTBQ7RxnF5d+f17JML1p2o4t4rg8knoaF2hUGxb5QWV
         akB6fM85nW3gpIyhypmld+MxhhG57u9Fu9c+kageIpwkOvu2dyNuyu1Mg9WzV1RfoNIN
         jKC+2zQkwrbthD7eU4OIw1qK+NLDzwcSFfZGQcY/wa5XxV67hzZkQYzplN1H7D83ZyFB
         brGi2He4Uf+M2meI8dafepVERnOTNskPs2qeR8BJTzOVriz8Tl+FvoBwOCPmRZFRHuib
         nqqw==
X-Gm-Message-State: AOJu0YzTHSraswECYe34oNslU2eVoJTZQ70xe/VyP+UtPX0FW6SkehRs
	BH+HVqylG0CUOciuc0rKx5kTs5Heu248Dr/3SwWhcgabRI2dzNGQ83/Ph3vmigK5RXnx8ngcivA
	wPe4LlA==
X-Google-Smtp-Source: AGHT+IF3lN1xqZpfLKDStwxaRuGouawxqx2dgLEoer8Pvy8mBY//DiSnV53VrdVqUjSCJXEwMfILIQyL95s=
X-Received: from pjbpx1.prod.google.com ([2002:a17:90b:2701:b0:311:a879:981f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5291:b0:311:c5d9:2c79
 with SMTP id 98e67ed59e1d1-313af23dc38mr871005a91.21.1749584559644; Tue, 10
 Jun 2025 12:42:39 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:15 -0700
In-Reply-To: <20250424052201.7194-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250424052201.7194-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958165124.102860.1466726781633621770.b4-ty@google.com>
Subject: Re: [PATCH] x86/pmu_pebs: Initalize and enable PMU interrupt (PMI_VECTOR)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 24 Apr 2025 05:22:01 +0000, Dapeng Mi wrote:
> PMU interrupt is not correctly initialized and enabled in pmu_pebs test.
> It leads to the APIC_LVTPC mask bit is never cleared after first PMI and
> all subsequential PEBS PMIs are suppressed.
> 
> Although it doesn't impact pmu_pebs test results since current pmu_pebs
> test checks PEBS records by polling instead of PMI driving, it's still an
> incorrect behavior and could cause some unexpected false positives.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/pmu_pebs: Initalize and enable PMU interrupt (PMI_VECTOR)
      https://github.com/kvm-x86/kvm-unit-tests/commit/389dfda487f9

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

