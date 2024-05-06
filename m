Return-Path: <kvm+bounces-16659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D0E8BC6FB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A81041C20E1F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFED1448C3;
	Mon,  6 May 2024 05:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q2JId6xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EE814431F
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973517; cv=none; b=hMm2dQ5HpeNQJQQjfKcCkZQ55QTyqMcS7dkD05Zcwvrrg9MtNgNNoDOS+feew1Jh5n0RJw6QduLRxox/KdNKmMnez1384wanCbKFz7B5XVfVzCc3RWVhlC6u9ef3z3JG21zBJDHpG3he5w7oGRdFAAIrg+Y0PNob/Gh5vbVg5Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973517; c=relaxed/simple;
	bh=u8UNKgsAMVA3G0emeM9UShJfp8LEpOAWl/TGmBa/fow=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d++iyas68zRaYO4yzx5LJS0E8OF//acr+sjAnN/1jqbSwPvNqQdyKLfv6oMMaeVmF7uUfJyEGUQ0itbP4jrVwy3oqCoRNrDz5Rj1XNG6i4NlXxBCUKkRmjBTo6Hpb6FHwi10nKEV7PUQZG1XRFn0Ohsz3TfqVM4xDLCL9FFi5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q2JId6xq; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be25000a4so35362867b3.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973516; x=1715578316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XH0pM0BIJqnCQsB9pz0DrMm6xibHkg+QmD8ju5qJDLQ=;
        b=Q2JId6xqVt7wihBlzZFazE0voMcscc7S2zfDLXP3NDTzw2zLedVXN3VZ7ZPYdDk3uO
         ma/YQK6zRUScbepX/cyzjHTloa7IZO1cMkEG+II0WRmZXL+t9Gh752TjG/VtENpahvvF
         9vkoBkNkqxtj2JuXDgX/eIscKf0sWkZNeBIbp14R7xrsNMurBI//JvKLcf/AHGY6vEak
         NzHtBxBwqNEmoRivQLcpYEs/R+BJlYgWQX8woFV9yRQuqDrmOp4ctltjVS3PY+N9Nxxn
         CBJHIfLKjMFm5Bw+ur8nLasJh7uUbPFXIfq2P59OfyyFHkviNqxfnMyZE6kq5B7uVlZt
         xz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973516; x=1715578316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XH0pM0BIJqnCQsB9pz0DrMm6xibHkg+QmD8ju5qJDLQ=;
        b=dNCZeYkm4GwxKJApjF5vKM8eE/UseuGXIsQqzOzWIdoOT25fs4jbtorY2HsJsJMxX2
         7rqTTWAz+580Dl3+q+sxlHa0iiGsMrfsV8ZyvaYGTr7TNOPefs5wZ8Zvr/FGA5kWLy6p
         LKS6el7m+ioLrXr7XyATYBeuU0UaHhwDr50ktPci8+v5UhTGUjbwju8x/XDLMiyKSQ/1
         aUlVhlAs0yfc7I2ZRwsaToVQJ1MgiQb6hETVLpHNz7FxRJ+94V0BV2CWgCIaOPvz2gt1
         zfle6zLeMJgc8x+Pi/6/cVhLa5TeuEKXewsbqllSpSNi9m+TpYZvRV1//60suuuWpRsW
         ubnA==
X-Forwarded-Encrypted: i=1; AJvYcCXGPLcOsGEFYCOC3Xhgd3srEn8CaHnCgoEAOo9qesoVkyPCbGDgUEG9nvRT18d304tRSyFBbh7Ehxyxi72VS2puoErV
X-Gm-Message-State: AOJu0YxkQG+Ui3h/9pJg35gEBWMee5EcN9mg7OATiI+O7APK+3eu8Y6r
	XLn3RShYJ7iHq1gi66/PVLtTrqvnL+n09yS7QGDsdF+LlSG+6sm47ipY6WttVVZn3YT7XqLg1U/
	8NyHZNw==
X-Google-Smtp-Source: AGHT+IEyYC00BtOAv9l6Lo3nfm2HRh3Y5pes3JM0WfFjFXPl8xbFNX0q+wLMbOixIL2P8fWX+N/5lhvRdEOM
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:110d:b0:de4:845b:8f08 with SMTP id
 o13-20020a056902110d00b00de4845b8f08mr2993637ybu.2.1714973515792; Sun, 05 May
 2024 22:31:55 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:12 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-48-mizhang@google.com>
Subject: [PATCH v2 47/54] KVM: x86/pmu/svm: Set passthrough capability for vcpus
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Pass on the passthrough PMU setting from kvm->arch into kvm_pmu for each
vcpu. As long as the host supports PerfMonV2, the guest PMU version does
not matter.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 447657513729..385478103f65 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -211,6 +211,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	pmu->passthrough = vcpu->kvm->arch.enable_passthrough_pmu;
 
 	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


