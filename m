Return-Path: <kvm+bounces-22846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A623794425A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14AE8B22FE3
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C401494C1;
	Thu,  1 Aug 2024 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ec3olsbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6AF149012
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488377; cv=none; b=ZS2ztYZIXncJk50Z2/HwiYQVUSSHfIH4GU4EoP1RvBr4jC1QNoIObURVi5aewbCdlgix1vDihM3jprvRdnaFjOuTr0P2GnTWVvYvGKoTWNa51ZJb8Y8rjE0JBkZCYD3ex7yvrjfWKaawkLYkqNKMnPIFjOggh6bxYQy+iJ08P9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488377; c=relaxed/simple;
	bh=ZFJd+NLNdnT0l3kLUsJ2QtMJkhs1k5mrwO9pnFY/Pko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u/LAM5ke6dWfqvGNlQqp3EAm9d0Hl5QLg+Xih+huPT80SM70L4wuK9w4MdAfmRvA4mREoP5pNP9MpJA6xkLvq74igS9ulzL1xKHhj48o8u1Vlbnl01HOn5z42Jzbm6j0glACbg/Fp5sWhZ9QaTy3kCoyFvGqRxZZ8WBId5C9cf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ec3olsbU; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b7922ed63so7350782276.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488375; x=1723093175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=REfxQKHiuWvfLVYbjy5X6aAAeE6tA/w4QJFbbRv9Hss=;
        b=ec3olsbUPXhNNSG+vhNYYY0VwX6tRg2jbwUMHF//YZTxpeGISisjHZ9VNSXBw9XGKE
         b4wB4HprdNDXtuTQJzTlmfgm1DY/rgwHiYX/jsC83fv16wnLI4mKWO923ChZtxRd+DhJ
         pWa5R5R5rSxjyNalt2FCVIBWfO9HvALgDNaoYdhcuZHxoTKrUeFv3fLFnEhkbEe64rUy
         VES2w54FJSIfoNtH2a+YBVSu4HpDTVoY6SbNPeeGI8vtWVoVdOPfnL3SfKZHWtRY/UZe
         vt0bllfP0knndn8s0J0K6Ehpu5KMK3cVyCIN1wWyGIBntTs9cVFZoUlf7P8Lv3FrgtRQ
         SL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488375; x=1723093175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REfxQKHiuWvfLVYbjy5X6aAAeE6tA/w4QJFbbRv9Hss=;
        b=e6rrWXurPvSKf9CUUG6i5Sh2Smow8ofFII8y2n2A/SnyQXDU5JAhtum1C+FZCWRKAs
         5rZ0e+93HUqdwEywubNOT/WhrAELQ+nkXsh/m8GTEXaRooEWokWmVXERIsKYNAKPE76a
         mQ7dHGStfJH8QUyA/p3Pv+FMKNgMQ6uITT1XeV/GRCf1d7KwZEGk4mMcEDgEhvvpKjfF
         81Z6r3VzcQ7ayDZFR4a1bmVwa0bhRJ51T8jAkChxVPlE7Dr0PSjgvIIPUfbbhx/BNiij
         9gdM38aicfADRUswYolKbAnEOMgo3WuDF5Ns3XyvW7vJbJNhOJoNseR5qage4wxlcBc0
         3zzw==
X-Forwarded-Encrypted: i=1; AJvYcCXmw14cBOwMFkW9EvW3NT5NT9mZ0mwAyaPKH2QLsWhCJZ+R0dL55ONozsBG8q/hT5aTzE6LnvvW26Q57CpcJjtmIF8Y
X-Gm-Message-State: AOJu0YwdcqnIWXDSawAEGKWYYlbXQDI6P0QC9F8/W3ePpBHl6pBbkQTZ
	w4ZZrJxQkcIlMu4OdT7EdI2A1tdyT+WQUIlCTUl6tK9I6GACrty8Qj5oTNAB9OU3KWzKb6PJ49D
	S9F1SSA==
X-Google-Smtp-Source: AGHT+IF5ZGeKkM/HeBRl1kZxTX4360lX8K5MNcIZn2sb2skkVgd4NCRm8ugb9lwNZdcMkg0PxPcK/P4Zp9sH
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:724:b0:e03:a2f7:72e with SMTP id
 3f1490d57ef6-e0bccf824demr2951276.0.1722488375074; Wed, 31 Jul 2024 21:59:35
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:22 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-14-mizhang@google.com>
Subject: [RFC PATCH v3 13/58] KVM: x86/pmu: Register KVM_GUEST_PMI_VECTOR handler
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

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Add function to register/unregister guest KVM PMI handler at KVM module
initialization and destroy. This allows the host PMU with passthough
capability enabled can switch PMI handler at PMU context switch.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c9e4281d978..f1d589c07068 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13946,6 +13946,16 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+static void kvm_handle_guest_pmi(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return;
+
+	kvm_make_request(KVM_REQ_PMI, vcpu);
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
@@ -13980,12 +13990,14 @@ static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
+	x86_set_kvm_irq_handler(KVM_GUEST_PMI_VECTOR, kvm_handle_guest_pmi);
 	return 0;
 }
 module_init(kvm_x86_init);
 
 static void __exit kvm_x86_exit(void)
 {
+	x86_set_kvm_irq_handler(KVM_GUEST_PMI_VECTOR, NULL);
 	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
 }
 module_exit(kvm_x86_exit);
-- 
2.46.0.rc1.232.g9752f9e123-goog


