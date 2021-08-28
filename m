Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC9B3FA253
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhH1Ah0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhH1AhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 20:37:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E60C06179A
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso5172362ybm.8
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J1gV9tKuEUW347bCpCRKYVIA3sPFQNKnByLeTysAe1c=;
        b=QQC9kCQqRwL40ouGUsJ6vhRZON2TPobzHX8Wq8NP7Mf7/RKw30MhddUWUdztQM8ka7
         Ewe++e/HjV2jGw30ZO9LaCG2WpwNsAvCft0FNwp9j2VxNuY0jXVJogAA4hui8IIZ1qr9
         T7Ay+2a4aRkadNU1ca0JCC87XvjH4ea9fD4ReM/qOgy67MxneR4EHRBEt1lUd0VOX2+/
         aMIald+U354j6b4DBU7OSxpd/vJmRGaMfQXYZFeXtKK7qkfMyGqETcknapO+6PjS0TvX
         f2FLBBpeqGMiBMtBIznPS2E0O9iUn3iZeMA1csLuIwLQaPaZSBmpT2biwVLtTLrwW9db
         1vRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J1gV9tKuEUW347bCpCRKYVIA3sPFQNKnByLeTysAe1c=;
        b=ACx5iQSueMJnvJ+QNYqcO1wpTmuRN8eJDLfUyZjcKHNW8+9AdVVqNUiixjzaZhUbpg
         y7C+3+NQydES+BwKCqolg6wgi9hUngiCiq6Jg9FEK6NJq6TMKTQoU9/4v11+g1l3HED5
         XEANt4IPgrvG5jrAaUXB1423Pxg/t5OzOcoLwrClWuMtZotZcZmDHES188jNe27iRsoB
         yEXvKqNtGgIAwIr85KGGNwWsqjSLXekFRzqPn71NDLycJ3SMu5EIgnJt5dlmMcdmcf67
         EpxN5m9PU2EyXeEIQwZVA6RUpgO0UVc5s40M/weFgiYf0tc8KL4zn9TGpn56H09HLlbe
         lHyA==
X-Gm-Message-State: AOAM533Z/BW7JFJ5WkVwXTrGF+KZ2fSi9veFzsh6bY9RNbJCidNrZ8N2
        740eUFvRljK40cNG6arg8b1HggmZ+ZQ=
X-Google-Smtp-Source: ABdhPJycwxh1le3BAg4292rl1ZqiFoDJidbv03xd08RKtKGj0W0JQHpqPcTgq5axIHXDILJ1EM67ZM2iLac=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a25:d307:: with SMTP id e7mr8478177ybf.119.1630110990084;
 Fri, 27 Aug 2021 17:36:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Aug 2021 17:35:47 -0700
In-Reply-To: <20210828003558.713983-1-seanjc@google.com>
Message-Id: <20210828003558.713983-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210828003558.713983-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 02/13] KVM: x86: Register perf callbacks after calling
 vendor's hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
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
2.33.0.259.gc128427fd7-goog

