Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C834701BC
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbhLJNjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241957AbhLJNj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E97C061746;
        Fri, 10 Dec 2021 05:35:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so7522601pjq.4;
        Fri, 10 Dec 2021 05:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYHdcTPi3/jM1X5j4Gx7CjYP+sWJhBQMekhqXrERTF4=;
        b=aJz7/B8AsM83EH9VcezOIORcEIr4NpiixpL1NlVzYsM8gNAr8aSwvAJyvZVBLJkUXH
         1XyMYKr8zVk/tTFg7Evmq3iOkrzhgd7JdMtYT9mSNb2FYE2Q7ELNsvGAzWQK3j29qYRV
         w10rG2AeRsVKKbwwDU68W0aPeBa9GQ7aFJxvghDpETRrCId7ihtBvHANCchCsmeAcKSV
         AbjCfCrE0oakBwg8kaCrRwbZPywWiWY+wMHeh9Ey9r27ECcenfazYuAyxnLR0FbkvEWH
         gJv1vLstaTRvRE8ub1n0oA0+C2z6pRUKIXosztj/N15YS+VXrgXEeQJGEGcL++pEe18B
         AiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYHdcTPi3/jM1X5j4Gx7CjYP+sWJhBQMekhqXrERTF4=;
        b=LWfwf4MLSVA3xbgmQIcQdL29uclUFmlw6txjCW7RZLvRuY5cPhr93oQ4frYKsrgxFY
         5qFP4phGaiat337A7f9LnyjQPRT/iYPjs9ux8TL3qumcwS1NGU9LuRyY3harzJ6ROAao
         zMWXNkN2c8deGezbtoPsVY1Fl5ukucZ5C6+t7rMG7fNa2oaj7o9MU1bRuzz6NJJPCgPU
         9WHBYXGBt1qPpR0VA3xCjU+9ezmggE9ClvqY+oPE+4OuaU1/ICtXM0TRhtF3+MlDkJuE
         FMGrQxS4OOTPEMnj8+WN8yELZ8EmoIuCScFCLbOgNHY7GpuQfFbd1n1s0rPVEc6W6tf1
         0qjA==
X-Gm-Message-State: AOAM533QsNFzNjj8kq+MwsSCLR6aYrtqdzuhnW68mfjX4DNzwIGtlrz9
        7yFqJ0cImYCS8Y2BGYby57A=
X-Google-Smtp-Source: ABdhPJwi0mbZNwnkjSYWJyynFCPfkbs0hbR1EpQv1hh6ExVPOHwKO6c6XrXPNdKoqPLBQOZma8b/3A==
X-Received: by 2002:a17:902:9882:b0:143:91ca:ca6e with SMTP id s2-20020a170902988200b0014391caca6emr75765096plp.64.1639143351485;
        Fri, 10 Dec 2021 05:35:51 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 03/17] perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
Date:   Fri, 10 Dec 2021 21:35:11 +0800
Message-Id: <20211210133525.46465-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

Splitting the logic for determining the guest values is unnecessarily
confusing, and potentially fragile. Perf should have full knowledge and
control of what values are loaded for the guest.

If we change .guest_get_msrs() to take a struct kvm_pmu pointer, then it
can generate the full set of guest values by grabbing guest ds_area and
pebs_data_cfg. Alternatively, .guest_get_msrs() could take the desired
guest MSR values directly (ds_area and pebs_data_cfg), but kvm_pmu is
vendor agnostic, so we don't see any reason to not just pass the pointer.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/core.c            | 4 ++--
 arch/x86/events/intel/core.c      | 4 ++--
 arch/x86/events/perf_event.h      | 2 +-
 arch/x86/include/asm/perf_event.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c            | 3 ++-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 03133e96ddb0..f3a00fe25fc3 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -693,9 +693,9 @@ void x86_pmu_disable_all(void)
 	}
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr);
+	return static_call(x86_pmu_guest_get_msrs)(nr, data);
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1f8fe07d5cb7..6721ccd9067b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3954,7 +3954,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -3987,7 +3987,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index fdda099867c2..21f84cc6a827 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -894,7 +894,7 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 42d7bcf1a896..bf61beaa7906 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -492,10 +492,10 @@ static inline void perf_check_microcode(void) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	return -1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63615d242bdf..050e843820d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6554,9 +6554,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
-	msrs = perf_guest_get_msrs(&nr_msrs);
+	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
 		return;
 
-- 
2.33.1

