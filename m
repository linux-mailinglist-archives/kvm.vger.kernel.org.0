Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9584701C4
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbhLJNj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242094AbhLJNjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC33C061B38;
        Fri, 10 Dec 2021 05:36:11 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so6343660plp.0;
        Fri, 10 Dec 2021 05:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMl7iCyjWVC2UjWSkbmB6H7VL1m/OAQQFLOxg2FdNS8=;
        b=k1KuzysRNSDujbGEXpjxfMV2SJXKNmZnM/BUaNJmCEt7W0BI+0hqymohQq7k583F1y
         0N+SDsf9BmSv0rQDzv6jEs7DZbfpgw5Ae3hf4uauTDEtV0ELPyACLiPEIBdShlyLqhGy
         4Hf0fYaXuRWI5X6yag/5yxFxQrh4FCvEkDRR/ozC5aRCE8C3AevFtG+l8HVfsX9qeuui
         07s2bdom1HJnRJKBPWAp9+mOFb1oVrFSwQGQzzmcGVOcBcoqTBetvwJKYPORWpnJKPlL
         sgQsW1ioC3qjpM0jyHsD70IVjDEzVMOiZIGCOljDbFyQGLsAhIcqt5sssHfmq4lxNpuU
         F1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMl7iCyjWVC2UjWSkbmB6H7VL1m/OAQQFLOxg2FdNS8=;
        b=pk0m7Yk0I9tBhzfJaf8awEdYKukQA/8DPSK3Iix2AoqWp2D7fQvQDsX/liyWrhF6SQ
         2Z+5YZYDbVu1djLQtfBFDFL+rD66NUzH5nS1VqdL+udmOjIIZ7ALswtN/KtR9PccEdpM
         /awUum42iGVsx9Ou4fq85rH99a+TvZjboew5ibH9hE/s4M+rYulcC99cSUcRGqQ++4Lk
         z3oIbyQ0F/eG9OIww5duPHs67cHW5ObP5/hWDjFx8waY81cZ+BKKQK6mmPFvzE82VEqh
         cfmTt2LoetUcTPM/CRzqLfu6+Yab0XQ3/Ymspj3dBuuVYJxkrtUaL/99CciBC6Ju6t2p
         Wgdg==
X-Gm-Message-State: AOAM5329UiMADNXs/QbnT+V+nKE48m4NGTG4a40iXgcwhLSQluNi9UD+
        DsNvxvniWYutdXQCSQdTpeg=
X-Google-Smtp-Source: ABdhPJwr78E/QebMD/vaAln5DmloXkH5THmZnNpdenNSAyge9wMJaCiBE1GMqMEJE1VWp2tQyxS7Qg==
X-Received: by 2002:a17:902:8a93:b0:142:30fe:dd20 with SMTP id p19-20020a1709028a9300b0014230fedd20mr75925945plo.29.1639143371005;
        Fri, 10 Dec 2021 05:36:11 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:10 -0800 (PST)
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
Subject: [PATCH v11 09/17] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Fri, 10 Dec 2021 21:35:17 +0800
Message-Id: <20211210133525.46465-10-likexu@tencent.com>
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

The PEBS-PDIR facility on Ice Lake server is supported on IA31_FIXED0 only.
If the guest configures counter 32 and PEBS is enabled, the PEBS-PDIR
facility is supposed to be used, in which case KVM adjusts attr.precise_ip
to 3 and request host perf to assign the exactly requested counter or fail.

The CPU model check is also required since some platforms may place the
PEBS-PDIR facility in another counter index.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 2 +-
 arch/x86/kvm/pmu.c           | 2 ++
 arch/x86/kvm/pmu.h           | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2860be9f3887..67ff6823dd62 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4006,8 +4006,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 
 	if (!x86_pmu.pebs_vmx)
 		return arr;
-	pebs_enable = (*nr)++;
 
+	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 8934261e9563..a780b84b431d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -147,6 +147,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c91d9725aafd..267be4f5d9d5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -4,6 +4,8 @@
 
 #include <linux/nospec.h>
 
+#include <asm/cpu_device_id.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -16,6 +18,11 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 #define MAX_FIXED_COUNTERS	3
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
 
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
-- 
2.33.1

