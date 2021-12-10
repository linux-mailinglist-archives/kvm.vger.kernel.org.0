Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BE34701E2
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhLJNko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242224AbhLJNkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:05 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830CC0698D6;
        Fri, 10 Dec 2021 05:36:27 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso9512439pji.0;
        Fri, 10 Dec 2021 05:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vPcywwDI80XWm65XvS6+OezyG8cofR5d4jSZRNFSCg=;
        b=iPK43PJ1joZstn5EzhT/YX7udUz1jMCrtvsCaTxBQElPJpusW2i4olXqdiGgeiO5ZJ
         nkEHELHx3LVC7kts5HcH9/e/fNKH25WnR+bRj4VN3w6Y2aGejmStIncDe6o4uDuWYe+a
         LJyrXDy7Y4wQ+nw97+SeXQ7xAkPu44SagrenJXtOFtg1V+FDx75FuHO3WtoQliRFVfIL
         SfuZWUP6F4KmgmmgRXjyLzj9jqttEfGWCK3OTVNIVEwsvdfL3mfF9hqGcrd2LG1r1pja
         jOBUA/9CV67Et+vOkTREAXfuUDjj03GY8bfiFZ3xp3j3I0uk5KTcC1wUggeKPJsQ+WSG
         aZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vPcywwDI80XWm65XvS6+OezyG8cofR5d4jSZRNFSCg=;
        b=ijBNypLhmEdVnt4KpdMPFCgPFJc039iO4Lf1thZm+07Lgr9GRpEOlRz47grN94hYgo
         hLNHsrbik+d6kOT9jdyFl216tY8ysYDpt/PMElgK+atY+LmVO/S3wC91X1A3SyOhro+l
         JDF7LeD/6ViqIs7fowuhE+bY7LQJQTHtLBuJCQeQ2mw/IA765Dzxv1JKI0B5ujeZXrxP
         BfoIiEJmC5r0QyviAi9aCGm9108kibmXEJ8J34+bq+/2DmDGU67H2aCy85RDQ5RHnD1u
         YgMmqDLw9dXpPuXjmDDO4Gwlll/i2y0WJ+myJNrZa2MLozcM5M4KK4DZ55JGUu6Rh0kl
         x92g==
X-Gm-Message-State: AOAM530UOtjSIUcbsksfOkxFtmlofCBzc5rEIStWaz22mpSzyiqYdJpD
        k8XfvGHD3xFG1hOMvDVDk6bWVlEtiRs=
X-Google-Smtp-Source: ABdhPJwR8PLN7lQC0Y9avwqxdoc9TBzl2+LU97whYPcw3CyWw93+zOXTS3kdyd/xAnZDnXBvaZRbPw==
X-Received: by 2002:a17:902:6b07:b0:142:852a:9e1f with SMTP id o7-20020a1709026b0700b00142852a9e1fmr75266839plk.29.1639143386739;
        Fri, 10 Dec 2021 05:36:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:26 -0800 (PST)
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
Subject: [PATCH v11 14/17] KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
Date:   Fri, 10 Dec 2021 21:35:22 +0800
Message-Id: <20211210133525.46465-15-likexu@tencent.com>
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

The guest PEBS will be disabled when some users try to perf KVM and
its user-space through the same PEBS facility OR when the host perf
doesn't schedule the guest PEBS counter in a one-to-one mapping manner
(neither of these are typical scenarios).

The PEBS records in the guest DS buffer are still accurate and the
above two restrictions will be checked before each vm-entry only if
guest PEBS is deemed to be enabled.

Suggested-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 11 +++++++++--
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index afc20ae1c3cb..af5ccf6b35c6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4030,8 +4030,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
 	};
 
-	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-	arr[0].guest |= arr[*nr].guest;
+	if (arr[pebs_enable].host) {
+		/* Disable guest PEBS if host PEBS is enabled. */
+		arr[pebs_enable].guest = 0;
+	} else {
+		/* Disable guest PEBS for cross-mapped PEBS counters. */
+		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+		arr[global_ctrl].guest |= arr[pebs_enable].guest;
+	}
 
 	return arr;
 }
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c07d33895612..e0565e556767 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -524,6 +524,15 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
+	/*
+	 * If a guest counter is cross-mapped to host counter with different
+	 * index, its PEBS capability will be temporarily disabled.
+	 *
+	 * The user should make sure that this mask is updated
+	 * after disabling interrupts and before perf_guest_get_msrs();
+	 */
+	u64 host_cross_mapped_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10424dacb53d..3bd53e6e93e3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -772,6 +772,26 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+{
+	struct kvm_pmc *pmc = NULL;
+	int bit;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
+			 X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) ||
+		    !pmc_is_enabled(pmc))
+			continue;
+
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx)) {
+			pmu->host_cross_mapped_mask |=
+				BIT_ULL(pmc->perf_event->hw.idx);
+		}
+	}
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.pmc_is_enabled = intel_pmc_is_enabled,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 050e843820d3..8d0df12a608c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6556,6 +6556,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
+	pmu->host_cross_mapped_mask = 0;
+	if (pmu->pebs_enable & pmu->global_ctrl)
+		intel_pmu_cross_mapped_check(pmu);
+
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
 	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6c2c1aff1c3d..1b2daf6b9c10 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -94,6 +94,7 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-- 
2.33.1

