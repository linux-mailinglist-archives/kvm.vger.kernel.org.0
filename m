Return-Path: <kvm+bounces-16641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB688BC6E8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7AA01C21110
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50CA142E6B;
	Mon,  6 May 2024 05:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uNG5i3CT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62E7142912
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973484; cv=none; b=XA8U82ZANcfntKwm+K1ACnLUoP3yf3Whq3aAV0ut75byUylvFPD+Y8rdySLxmaXWMn/ZkusNVwTyV4QDjar227V1wcO5sh4tXqyGcYAHfqLZMtklBOQsbMR4zckuKEB+Vg83EveDlSTQx+6mxfZT8CuzjO+Ic1E7CS9+Ksrc3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973484; c=relaxed/simple;
	bh=YTanXM05IHphvqbUN96UEZXYNv7KIGCnmEDrWyKzy6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H983pdybyocPvobGj017hJKzwc5+mcStHfoeipmXYspkMYQb5mIQNQdNLKJxL1djabq9ku7gm3BwSHB+72NhScTFtIfc/LM4DMV1fe0cAp4s9tt86dRqS6rErnC/R6QCyomh2ONTztGnnDAO+RBS+JGkMCriYhphDvkoKWPtj4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uNG5i3CT; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so2585845276.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973482; x=1715578282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0KnMSVPaPzVOvrVjlIbtuGaeyIlEpOBvjlGJeeiwtbA=;
        b=uNG5i3CT+otFMO4RsRU5OCf3+wUwZGSvUM8AmqB4k9PaEBuRXjfaxY0AsSnZciwglf
         VwrXYEmWz4JJ7mbyVcGJNX0/ZJ4B9f6G5Z2xHOmWNHWenmCbesavhMMhwR1d5QeQRPxX
         n8cMbXtthiLVJFVUjJIXNzFI7/4rC60SeyFEASnvWVckP6g5n6SnDC9XTDy9ANxfNkex
         o0jHG2NwMsuvJGXtDYuf6OdRg/9P5UDBdyYz6kocvJlEUHUl1j76nuJ9w1OJVcwYZ2Fi
         KjmMbFxjlPONeSzbNX68LIB6xjJUQeu06ZhBS5GZKt6/lvrcwqTSdIl1M2Kq5KM/Wtnf
         EY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973482; x=1715578282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0KnMSVPaPzVOvrVjlIbtuGaeyIlEpOBvjlGJeeiwtbA=;
        b=mxqluIJTq0GO8mEGirR4JJYVpt9+aA2hqgqjnMlC8IYkuFVn+3W98goXxwDbCu9OUI
         cbb5uizRKkLAXImo+dGxghrC3ERuogHsENjXBsQgOeQFvfHmExUWY6qYqiZJy9PBK8w8
         HLs91yZzFmDvHdvqHwWjqy9bD9LCjln1lf+GUfvUYzV+7rd2QcE4l1Iz6G+/qFWk/ZKJ
         OJsjWauQ+3Eh44DaS6YZOvSFDfTfCYGubNQf4LFRZYIM99A548xVExzbW77Zn/xf04h3
         xBoH19cJJLIZiJzHTDOx4yoEaL3F5+NIWZOA4r99eAb6mEzFRyS5gj/PG/rVH83XM7lq
         xP/g==
X-Forwarded-Encrypted: i=1; AJvYcCVE4Q/bV+z4eQg6hjnz++0YURSrszjPmrAUkRnH/NFpy4mvRFL8fbPBZ4zVZ67jJs3+ags3vFDKAYM0hetJxFopAxlJ
X-Gm-Message-State: AOJu0Yx0a6lwUI4FHcvMjeMleBgux5Eu1pMNBziMxLOvG79HlUXUwnyZ
	OPOwJ4UEcCacPjhZ8SwkxjJOX1AsewicSdBrO+95hL+MIgMGnejLEc32K09qH+D92QK10Cr7xBV
	Zxbp6Aw==
X-Google-Smtp-Source: AGHT+IEeW7oariaEikoFS2RDwOKYRXIhJVDZHIDcuv+ayFWKAyBnYxwVe5wEiIvDG0twVXqTPSuGrbNtT86X
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:2b07:b0:de4:64c4:d90c with SMTP id
 fi7-20020a0569022b0700b00de464c4d90cmr1305649ybb.12.1714973481965; Sun, 05
 May 2024 22:31:21 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:54 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-30-mizhang@google.com>
Subject: [PATCH v2 29/54] KVM: x86/pmu: Introduce PMU operation prototypes for
 save/restore PMU context
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

Plumb through kvm_pmu_ops with these two extra functions to allow pmu
context switch.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 ++
 arch/x86/kvm/pmu.c                     | 14 ++++++++++++++
 arch/x86/kvm/pmu.h                     |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 1b7876dcb3c3..1a848ba6a7a7 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -25,6 +25,8 @@ KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
+KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
+KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e9047051489e..782b564bdf96 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1065,3 +1065,17 @@ void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 {
 	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
 }
+
+void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
+}
+
+void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 63f876557716..8bd4b79e363f 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -42,6 +42,8 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 	bool (*is_rdpmc_passthru_allowed)(struct kvm_vcpu *vcpu);
 	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
+	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
+	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -294,6 +296,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
 bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu);
 void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
+void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu);
+void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


