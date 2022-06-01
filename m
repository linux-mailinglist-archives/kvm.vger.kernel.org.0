Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6B539B8E
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 05:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349295AbiFADTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 23:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344235AbiFADTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 23:19:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512AF8B0AE;
        Tue, 31 May 2022 20:19:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a10so739049pju.3;
        Tue, 31 May 2022 20:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HWM4zuHZMlVlloTmo8iISWSBoICOOIq97NK5vJSN5mU=;
        b=NI1X0gOWwMWhW7vHycpTM6ByU5mtiMkajNw3q2SJYFHNF6y65N8SWmkniRbbkGu3H/
         hfTCZ5ZkUsE3ODXpdVatdw560hPGd/oxrmA31aXa3caEhHrYlnZy7f+GWd89AAfQVMnN
         d8KOOAU/UpcJXc0lG3nAeGmiuqDNHR/Mpt8ktZFUzJ8HxcZ8Z0sMktICIbdcEFv6miYa
         PTG5IZDEV4ME1k0xKNnvP6+U356r8PbWyCKRfdE4JFP5ktSP1A/nPH186zlzodDEkYp8
         Y3vnS6hCpn9bpugd2+oRUdKcQdqKyxWKeefZMUdH+BMUMvgxHr2iZqJQKA7AoFMLo+Bj
         UDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HWM4zuHZMlVlloTmo8iISWSBoICOOIq97NK5vJSN5mU=;
        b=5lUeRqbVwYojgLb+OFOt2yZm84V4nVqnXLslkxX1NycvCgqqdg1x1XM5PIVeVONqKe
         6wL0ZiWBWE966BugeDXHGAHKGCRv+FzsioN/OIhbgPQedKiZC8JqK1ARcDVNAJ1CWAII
         bXUv30Cil8J3zNIQ2eekGBwPRg8a9rSEqAv4E9+Cpwgw9tdDKReNlrsMOj0lx12i6nqK
         S3FbNE+ANB30fTwQp8DAOjlZVWBr5Ix/o+Q4QK4g7LzPl6diBljxcs8oCY6Tl5s097CY
         +IUIX8ypf+1mXNdBbvWNA1cLxcN5gE97OJ5e8hikjo7xvNRU1Ak+dWHPA8m0F0Y7Wzft
         qjZA==
X-Gm-Message-State: AOAM5313waeHWlVLQyM5r/kqPnr/VHghE2u0/ahPVMrWFuULr/YhdGUc
        cVTNMr5GYR25JyPW4fbXRKg=
X-Google-Smtp-Source: ABdhPJz0WwOvL8UTIuOTGR6LbqDQqUFkm9wE6C1Rul96QUPJcAJbwlxjfPU7pYEEklC7CSnXmU+HVA==
X-Received: by 2002:a17:90b:1bca:b0:1e2:c0a2:80f7 with SMTP id oa10-20020a17090b1bca00b001e2c0a280f7mr19642798pjb.162.1654053572814;
        Tue, 31 May 2022 20:19:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.23])
        by smtp.gmail.com with ESMTPSA id i13-20020a056a00004d00b0050dc76281d3sm184691pfk.173.2022.05.31.20.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 20:19:32 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/pmu: Restrict advanced features based on module enable_pmu
Date:   Wed,  1 Jun 2022 11:19:24 +0800
Message-Id: <20220601031925.59693-2-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601031925.59693-1-likexu@tencent.com>
References: <20220601031925.59693-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Once vPMU is disabled, the KVM would not expose features like:
PEBS (via clear kvm_pmu_cap.pebs_ept), legacy LBR and ARCH_LBR,
CPUID 0xA leaf, PDCM bit and MSR_IA32_PERF_CAPABILITIES, plus
PT_MODE_HOST_GUEST mode.

What these associative features have in common is that their use
relies on the underlying PMU counter and the host perf_event as a
back-end resource requester or sharing part of the irq delivery path.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Follow up: a pmu_disable kvm-unit-test will be proposed later.

 arch/x86/kvm/pmu.h              | 6 ++++--
 arch/x86/kvm/vmx/capabilities.h | 6 +++++-
 arch/x86/kvm/vmx/vmx.c          | 7 +++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d59e1cb3b5dc..8fbce2bc06d9 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -167,9 +167,11 @@ static inline void kvm_init_pmu_capability(void)
 	  * For Intel, only support guest architectural pmu
 	  * on a host with architectural pmu.
 	  */
-	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp) {
-		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
 		enable_pmu = false;
+
+	if (!enable_pmu) {
+		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
 	}
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index dc2cb8a16e76..96d025483b7b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -7,6 +7,7 @@
 #include "lapic.h"
 #include "x86.h"
 #include "pmu.h"
+#include "cpuid.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -415,6 +416,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 	u64 perf_cap = PMU_CAP_FW_WRITES;
 	u64 host_perf_cap = 0;
 
+	if (!enable_pmu)
+		return 0;
+
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
@@ -426,7 +430,7 @@ static inline u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
 		perf_cap &= ~PMU_CAP_LBR_FMT;
 
 	return perf_cap;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6927f6e8ec31..11bad594fedd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7575,11 +7575,14 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
 	}
-	if (!cpu_has_vmx_arch_lbr()) {
+	if (!enable_pmu || !cpu_has_vmx_arch_lbr()) {
 		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
 		supported_xss &= ~XFEATURE_MASK_LBR;
 	}
 
+	if (!enable_pmu)
+		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
+
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
 		kvm_cpu_cap_clear(X86_FEATURE_SGX_LC);
@@ -8269,7 +8272,7 @@ static __init int hardware_setup(void)
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
-	if (!enable_ept || !cpu_has_vmx_intel_pt())
+	if (!enable_ept || !enable_pmu || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 	if (pt_mode == PT_MODE_HOST_GUEST)
 		vmx_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
-- 
2.36.1

