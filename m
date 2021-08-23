Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563663F5156
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhHWTiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 15:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbhHWTiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 15:38:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E785CC061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i32-20020a25b2200000b02904ed415d9d84so17447405ybj.0
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nveAaHVBnxnUKFG18sU+pbtyM6YzqpNesv6ZkGb2ois=;
        b=FESYWZLplFRiwGN7ZdpF8Zt3Em90s6rELCzxVhSuao3d4FHG4O/BO1naEpOYe382vy
         DfLssZIIfld5lOwYekPdJ/pzAdsi134TnJIbfzHq30gcAh7KuqhR+MwXbrvLmzulssji
         jdGpP9DrZr4cvn3CSB0+Su/X0Kh3S9s6xFXVNBOILP5PrrnQrhXqgwNdYErN7TLqBDQw
         EdQb+z0ssxUFDDrUYAXK6QjjUl6P4u66PcZ8lks5VKF/qoPFqIxskLw24VmFdbfkLHfA
         IfMOZ6vCVh50YFl9PSBKFuV9Ve2R2iagixzuFnQWdgt+LMknP39ti9+Z+IjlzVBAPyBb
         2azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nveAaHVBnxnUKFG18sU+pbtyM6YzqpNesv6ZkGb2ois=;
        b=pA9ViH33UsQGdciV6FShetvPC51+vmS02aUWtn++v1X/YQ8OQaLXeBWh0st4fSWFDt
         Zmc5MlBv+KPcNEq8GPlWdkp4W77UdEebE1XdrOCJEis15e+ESDjxbtCfEGP0d7WJrM7G
         70LHMdMBOK8GVG1aDX/s0zy9Hzos7D8Dv1EnRf26lCJamnx3jRnxcujS0Va4CpH+qfA7
         mkNk1EWJhRV7xTLNIZu4phQ6QIpgMXuAe1PPqtWaBJUwgRCkjRKka0T5fyMqdEOoeNOz
         wIZQhV0VX7tNBHXJRPoLTKX83Pi/wEseXnD/40szlPa9OLTDJJTdyVd6lFiaCsCweXT9
         lHvA==
X-Gm-Message-State: AOAM5326vdTYBGpkQPFo7VfNBQTfBz9p7R7yoRQjI59S1aAsAM6HPn3G
        dMV8oTtN+wbIJj7cGRRNgF/AufEwHQc=
X-Google-Smtp-Source: ABdhPJxvZl6SBIhaEOMBBZQbGAROAi1buHgHmkkQbX8vm8I8czB32i+RxswGTkU2VMdtvEVQSiWDz8nDpy8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:109c:7eb8:d5ed:2e59])
 (user=seanjc job=sendgmr) by 2002:a25:7bc5:: with SMTP id w188mr47700735ybc.285.1629747445204;
 Mon, 23 Aug 2021 12:37:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Aug 2021 12:37:07 -0700
In-Reply-To: <20210823193709.55886-1-seanjc@google.com>
Message-Id: <20210823193709.55886-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210823193709.55886-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 1/3] KVM: x86: Register perf callbacks after calling vendor's hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wait to register perf callbacks until after doing vendor hardaware setup.
VMX's hardware_setup() configures Intel Processor Trace (PT) mode, and a
future fix to register the Intel PT guest interrupt hook if and only if
Intel PT is exposed to the guest will consume the configured PT mode.

Delaying registration to hardware setup is effectively a nop as KVM's perf
hooks all pivot on the per-CPU current_vcpu, which is non-NULL only when
KVM is handling an IRQ/NMI in a VM-Exit path.  I.e. current_vcpu will be
NULL throughout both kvm_arch_init() and kvm_arch_hardware_setup().

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Artem Kashkanov <artem.kashkanov@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..fb6015f97f9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8426,8 +8426,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
@@ -8461,7 +8459,6 @@ void kvm_arch_exit(void)
 		clear_hv_tscchange_cb();
 #endif
 	kvm_lapic_exit();
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
@@ -11064,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
@@ -11091,6 +11090,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

