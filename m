Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4604701BA
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241944AbhLJNjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241943AbhLJNjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5D9C061746;
        Fri, 10 Dec 2021 05:35:48 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p18so6268157plf.13;
        Fri, 10 Dec 2021 05:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WhxWgL0+NlveoahZPABKS+nvP2UibJwzczVR+3A9i0Q=;
        b=Oy/FMcEdBjcvO8QhVbLQEzmRofWxXMNcrygfrYhjKibhUZFyZn9PxMc2U9zGxOMleL
         oZMqRl86h4SQkaNbxhyXgQ1qXz+IKhGsAEJhlOYR5JlIsvwXe8Bdi+/131eN7mlRiRZD
         CUxd7UMbsGBalGWWzEboRVNzbMEXL4zI9GXJ9Twzr0INMbouDtKm76hIYEkT1F794FgN
         BjNU03VwdKGP7yalUfZHDmJEyZtR/HIe/cCZqnfUWdGU/mTwKO/sIkP1HQ1h4wGKUjH5
         QtpKH5Q1w0cEFiXdgouAgkPgMGlIC3tjNjGgMbj3Kh4wKzL/bJSHA2OtKiuJ2r9KJa5u
         +2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhxWgL0+NlveoahZPABKS+nvP2UibJwzczVR+3A9i0Q=;
        b=P3jxUtvNuxDLmUvveIf4AQNxZDqTqcBSR+HNTa5pFBi/r7hlNAxbm8XkVI7u9rRGxS
         A/W+yHHWS2TLI30tNJVHpl2DlTWaJSvRskMuuJJRtmG9jq/66nFzDGDvAggtb7dw9iKH
         M8eWpjJKk1OlwTc3mBbOL1BVtgQr2HJdOQx9kUrveBUmOV6Mzc0ksFPF10uzgO4cST13
         E+bW1I/xD0gHji1xuqbF++Pe9vajer5PFkebQPsYUe8xLW4SbzCwXHTziX8A4RwOAmp0
         f8wpGdUDsVAGhAnmyN506vzLF3Ybk2r2ygGjZNRjNucMw7Z+ax/z/JYWn/KcxWEMVHvM
         oFZg==
X-Gm-Message-State: AOAM53158wvaxKFtHbGaDA0DgGAThVAltHf+F0IcLf4I8OEjhA7Wd7Xb
        XcHpW99khYFWNBWuZIZSHysnOKUYtX8=
X-Google-Smtp-Source: ABdhPJwHaA9cg6OrdMkDK0VB20cK+zmYGHGuziyLhpc+YqFiwhKl98+7+MMz7FzrKAVzl6Z2tUYylw==
X-Received: by 2002:a17:902:b588:b0:143:b732:834 with SMTP id a8-20020a170902b58800b00143b7320834mr76026040pls.22.1639143348107;
        Fri, 10 Dec 2021 05:35:48 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:47 -0800 (PST)
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
Subject: [PATCH v11 02/17] perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
Date:   Fri, 10 Dec 2021 21:35:10 +0800
Message-Id: <20211210133525.46465-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With PEBS virtualization, the guest PEBS records get delivered to the
guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
to distinguish whether the PMI comes from the guest code like Intel PT.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The fake event causes the KVM PMI callback to
be called, thereby injecting the PEBS overflow PMI into the guest.

KVM may inject the PMI with BUFFER_OVF set, even if the guest DS is
empty. That should really be harmless. Thus guest PEBS handler would
retrieve the correct information from its own PEBS records buffer.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 869684ed55b1..1f8fe07d5cb7 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2831,6 +2831,47 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+/*
+ * We may be running with guest PEBS events created by KVM, and the
+ * PEBS records are logged into the guest's DS and invisible to host.
+ *
+ * In the case of guest PEBS overflow, we only trigger a fake event
+ * to emulate the PEBS overflow PMI for guest PEBS counters in KVM.
+ * The guest will then vm-entry and check the guest DS area to read
+ * the guest PEBS records.
+ *
+ * The contents and other behavior of the guest event do not matter.
+ */
+static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
+				      struct perf_sample_data *data)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	struct perf_event *event = NULL;
+	int bit;
+
+	if (!unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest()))
+		return;
+
+	if (!x86_pmu.pebs_vmx || !x86_pmu.pebs_active ||
+	    !guest_pebs_idxs)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
+			 INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, data, regs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		break;
+	}
+}
+
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
@@ -2882,6 +2923,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		u64 pebs_enabled = cpuc->pebs_enabled;
 
 		handled++;
+		x86_pmu_handle_guest_pebs(regs, &data);
 		x86_pmu.drain_pebs(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
-- 
2.33.1

