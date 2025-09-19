Return-Path: <kvm+bounces-58074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4053FB8773D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA5E4627F9E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C8919D89E;
	Fri, 19 Sep 2025 00:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SAhtkkWg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86756450F2
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758240699; cv=none; b=Op7LM2ugQBn7oDRLr1uhRHd8o1GQ+D7ED7W+QV0YBialX5e4o/lMuZaifCMoEsJD3LcGJt7n+1kA/sjsZbZ6tvVxa6dlfQ4kCJRnnNyGCDK03dYuNj/h9GaM6S//IaMavzW7Qz+Tvgms9tWC8X7CkGXUz4PQi6CZMm+d1CIuTzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758240699; c=relaxed/simple;
	bh=9ggq31TuElkvdeTP2ZjS79K/WX3d9QrheK9IIUaFVzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FxaehBHNPxXAplWnED6Iz3S+mKE5gXC+8tx89UcVksvcK/3Giy//1dDRnmcBQAqHFopigAuS+U+RmO/YcdqeSSxSqpmBSn0YewP7PeeY6uz2XnmWeFeXz5LZg4awOEGWH5mGJWJfUarECN/pIIPBgMeTyL8GVuYOtVAAVIScSaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SAhtkkWg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7761dc1b36dso2894347b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758240697; x=1758845497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5pHZG9bcElhtMtIe02tLqtkF2uGVTgQcC3bk12Urlxs=;
        b=SAhtkkWgcse++AEPWR74HEShFUe9VH+05txFueYp2JCv7mm8qhH8mlemOGyNOqoJbl
         5DyQiUh6xFYWc7dMdwKodlIK3slknjHhdYEAaqQmVuvxlVRis+U+Jf6CwmyyKAaNWkKL
         9UcszJocNIZ+nsbMeRJrgwAO2NLfqugw9bPvZToo/1NRp9vAsgH+lQk7OyOIXeGtOT4o
         QJue9QUqD3xQ6M9fRVvqq7DFBtIUHx1hM8Bt9w6c0UfxHu6URnYP7BU9bkYrj/CZeo1G
         93G0uoep/qFL7/qUefNwrvyOpwrase91gvSbTAn5A5Lmhip+wmrbHIG3M788A9H2thf/
         6P0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758240697; x=1758845497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pHZG9bcElhtMtIe02tLqtkF2uGVTgQcC3bk12Urlxs=;
        b=s67zJyxd/l9p28Z7G5tgnbXK/B4i8xspwyFWcRvRrGdifvxOBCDp/x0mpEUi8z3l/8
         jCl6srWwIV6XXjJR3ogveZBR9i3eLQze5tkiNJEufgxvsjtOAc5Vi+0oh+Wbt199Cjfr
         jB2A7O9EcQg9NqS9J9vRwFHcMOrR+Fh6DF6w+ZPHEZjnaHafR2zR3kedSfopCCSHq/2U
         bVy+uKm+G6rvt0BWCQ7/QlsKh0LVoK3dk4IhQy90QEPp9vatsWj3TpVND+mDsIhEtH8c
         LDoZQmvy7qqkRpGodq9Yu3TIK0pn4dgiAXr8pADDVwfdpU80vLW4DjISA7Q7AKyBijRx
         p8DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrKN5cB3m+OlzlA/AJvhKH0d+5/RdDBCDeKD+ofNbZBjUiKvbLSmxN1NWBW5K9zICat3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxiz1Ba4LAl+wnP2y2nlYNyF8y/dMW2zXFwMd27Psr3xyIWIGl1
	FcTLoGp+T7SSco+JV7ApE6tbdYQGClmKZqOXD2H0adKo+PBqvLOvQzCsdRtuoUHf/nLNiEVb/as
	cENXiaA==
X-Google-Smtp-Source: AGHT+IHL6wVIYMVXo/qF+C7m2xAthhi9wrZHJ6iKg3qq/wSUNMfIVTHCzCbvYXSzkHH/AND/3vPqEr/ALak=
X-Received: from pjyf16.prod.google.com ([2002:a17:90a:ec90:b0:330:75c7:341c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a8:b0:252:3c5e:45cc
 with SMTP id adf61e73a8af0-2925d5abc4cmr2117916637.19.1758240696687; Thu, 18
 Sep 2025 17:11:36 -0700 (PDT)
Date: Thu, 18 Sep 2025 17:10:50 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <175824021167.1343722.9290387002572827825.b4-ty@google.com>
Subject: Re: [PATCH v5 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Aug 2025 12:56:22 -0700, Sean Christopherson wrote:
> This series is based on the fastpath+PMU cleanups series[*] (which is based on
> kvm/queue), but the non-KVM changes apply cleanly on v6.16 or Linus' tree.
> I.e. if you only care about the perf changes, I would just apply on whatever
> branch is convenient and stop when you hit the KVM changes.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> [...]

Applied a subset (roughtly 1/4) of the KVM patches to kvm-x86 misc, as the full
thing is far too late for 6.18.  In a nutshell, all of the random prep work and
cleanups that aren't directly related to mediated PMU support.

I want to get "setup VMCS prior to kvm_x86_vendor_init()" in particular landed
to establish the order of setup operations.  The in-progress CET series moves
the _nested_ VMCS setup later, and I had a moment of panic that I was creating
incompatible patches.

[14/44] KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
        https://github.com/kvm-x86/linux/commit/4687a2c4e6a6
[15/44] KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
        https://github.com/kvm-x86/linux/commit/e3d1f2826da6

[17/44] KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
        https://github.com/kvm-x86/linux/commit/51f34b1e650f

[22/44] KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
        https://github.com/kvm-x86/linux/commit/1e24bece2681
[23/44] KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
        https://github.com/kvm-x86/linux/commit/cdfed9370b96
[24/44] KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS
        https://github.com/kvm-x86/linux/commit/6057497336bb
[25/44] KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
        https://github.com/kvm-x86/linux/commit/5a1a726e68ff
[26/44] KVM: VMX: Add helpers to toggle/change a bit in VMCS execution controls
        https://github.com/kvm-x86/linux/commit/2bff2edf69ed

[29/44] KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
        https://github.com/kvm-x86/linux/commit/30c0267f1581
[30/44] KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
        https://github.com/kvm-x86/linux/commit/9bae7a086394
[31/44] KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to PMU v2+
        https://github.com/kvm-x86/linux/commit/c49aa9837686

--
https://github.com/kvm-x86/linux/tree/next

