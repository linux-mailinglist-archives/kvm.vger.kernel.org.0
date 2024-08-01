Return-Path: <kvm+bounces-22865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DFC94426E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CA2FB238D7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F0C145B1E;
	Thu,  1 Aug 2024 05:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qlG/T+Be"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548714D44E
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488412; cv=none; b=XfHUCxOQGzTB0zv5VEGpkbEVor9d4HHTOnA7KjUcbyuDSTEvcQ698Skf19rZjoGqftY+pcxE/Wythz+wooW7VH2a3FFnIxNB8TZ+Unjar/vkWe2gQIJTUcqBEgDLp4UfF/bOGoT74oSXsDEb1CSnKsi2Mgy5TRlbz7X4Lku5g9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488412; c=relaxed/simple;
	bh=vp0TPcxz9YqnISsMUjuvll8W3kOGdLZrO0ZGdpIQdlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jNqtHmUCswtUErmK/qS8xewWWoPM+SOl38mDEeNuakqvdsoki2YcsUj5WWy1tVdpKkaFfZJgpiScUBSEYXifpN9IDfUpelghtNk0RsdW1WvuwcVCFc6yS+u0NCqdyfOotwiiDOJ6hhS4BRs4UHFZFTsxL7b6izTogEA+3CRZcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qlG/T+Be; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-72c1d0fafb3so4604372a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488410; x=1723093210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NFo9WM0gmtF5x3FaTooid3tzFZdwq4T5Qe1FVRaD2ZQ=;
        b=qlG/T+BefVKCzj1MilqKXlBFgawrz8O7R78WHOpnXbe6I/EAYICJ64FIFZZW7/ulIS
         /RdJ+i0UVdz4SCOeys+HNPNC+sf/+XmGsIgiOPIbfVEpQu1PyWNVPLh/9cjGLyKMxaHQ
         6oRye+vFy7FyzwK3EGXkDwsvgNlho1lpLu6XsdGUgrZb6DYqjSGYxfvLkmHK8qqKESx1
         fxPVf6sTR5vW2+TetlXbhsZkSKepUZaIamTQo7tWvEJKnibbPCCS690IwranTwTgLWmG
         94UocLm69FkfNLQkUXKzSI4jgKUUd+4c1NaBKskQIZJzDE6ywpXgsHW6SeqFFUC9td7O
         J/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488410; x=1723093210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NFo9WM0gmtF5x3FaTooid3tzFZdwq4T5Qe1FVRaD2ZQ=;
        b=QvyDccmk9NUaD5eXnh+bjo7/G9P0uAt5etWtmebhH96k2kgJS1N6vb01thwvwzjwhB
         AZzFAZDg5yNRuDuAQiv+YUs4ERFSUVt9lrBJx6/Is6/YkSFY2hUCFpuhFHl44RZdK8EM
         0WF4dpnNp3yJ0TuwYy8lzjTRLU80FqqqxkYvHtDT3YH6OnIEdxkqOkFmyiZCtaQdPqNW
         oigjerA/nMAiPPAguCzKdtypluWgl2MPqSKDWxCVnRGvAy46PKqaD2Qfl+L9g/TxUnEi
         FcH5sGo9K1aWpGfvM8n7nIf4WIweMOP+wNzJ32wZ3W7QfQ4UcXe5SpTs+A8yhC/gRXkq
         bmpw==
X-Forwarded-Encrypted: i=1; AJvYcCWPfK251k5RZy35eBG+K5fl10JywBjjk+zTvasYgRpgT6pJEKbM9BAxqPEC55hmknsQV03Jnf9TwbHiI4nBFPej6wJz
X-Gm-Message-State: AOJu0YwsOfyE35JHB0s9eW/GzWIuqLvl1VM3DgCdx7RES8AaEUmyC3Fd
	QvZKuhGRDe14OKpl6Dujfqvv9bPWPHgfHNbLQvwDE2MtIUrkJCDQIA60lrd2j+54bsfxH20MKng
	L0iFF7A==
X-Google-Smtp-Source: AGHT+IG/SIUMZioOPfnMc/e+wMajqFKhBd8J8lwB4YBsAnJW0/bHsfIAXMn9IMG0Q/qSI/c/2u4pNu8tjdKw
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:d491:b0:1fb:27bd:82e2 with SMTP id
 d9443c01a7336-1ff4d1ffd25mr1126205ad.8.1722488409791; Wed, 31 Jul 2024
 22:00:09 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:41 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-33-mizhang@google.com>
Subject: [RFC PATCH v3 32/58] KVM: x86/pmu: Introduce PMU operation prototypes
 for save/restore PMU context
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb through kvm_pmu_ops with these two extra functions to allow pmu
context switch.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
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
2.46.0.rc1.232.g9752f9e123-goog


