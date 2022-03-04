Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14B04CD0A5
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiCDJFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiCDJFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9781A06C1;
        Fri,  4 Mar 2022 01:04:51 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q11so7156958pln.11;
        Fri, 04 Mar 2022 01:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ltug4OiVK89L6kwQRotAn5EqybAI6kqhGBm3g+G26+Y=;
        b=UG0wYmPnUlKLM2WLoBTCeIDe4a4yeRhJzeQ/B+Rfl1HTOKXSb86ymRSbwQn9+wwzGM
         ri8qP5J9KETqZDHlXVwkHVerU5+f15SyDm0YyVKNXvfhAYAQidBbDYcfdIEpy9o17BlC
         7xUdX/JDU628Wr2wWG4t7gJKpIerJLZv/ZSsVpwB3rdBBT98Sli9Z0fC1fmxYoDH+lMX
         2D/YOgi6ikjUsGoiqtJHMUo4pALR/0Oxq79Za92prKWFoX6N1GvAzxTia61OoftkbyrA
         I2jVNastkOOakJ1Iiid7arglmHQQ1xczlrFNWn07m+pASReuZmcG2K0YQpUScCs+CJtS
         BXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ltug4OiVK89L6kwQRotAn5EqybAI6kqhGBm3g+G26+Y=;
        b=4E/+aAEEXyiT6Rnm0Wy9YKxrmU5JQguZO+xo/tSuNIPzICD7KMTnUShNI2Ua+omYED
         wE/PwUFNk37uIxvb/sO2wukgchdkSdx7K6xkbtYQTyzLoN9yv22DcgL2a5MmMy0+i+fD
         /H7TB59KLobcvHr5W9bwN48NSA2YaQHaXQ1EL2Czk/Z67ZXRscCLkpNQ93zhS35jm5uZ
         J8QKeNBOiBcpSmAArADFxtVZhlSAL9fSj4+LYq6a8akxZdm42ONIiaCKuXTTuyHoZrDZ
         TlDz2sN32F2uXkL8JmEAw0Uc8tuBtuohpDYFF47mf7D+JgCj34jACsOjaZBWsi+urJS/
         3C5g==
X-Gm-Message-State: AOAM533AYG/b2MDyJxusx67SXafC9/2f2WNnM+8zUDQF2Y/4nXK5lpn7
        F/hJc/n6BWZ8cPOgynCmIw4=
X-Google-Smtp-Source: ABdhPJzhtSO8JdhyFvSdRI9RUXClLP4CkAQbe+6DqQ7RFuDZkHvMvUSbuSgGqnOQlZCG4/+WpAPhxQ==
X-Received: by 2002:a17:903:285:b0:14f:daea:e8d9 with SMTP id j5-20020a170903028500b0014fdaeae8d9mr39727542plr.128.1646384690716;
        Fri, 04 Mar 2022 01:04:50 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:50 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 03/17] perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
Date:   Fri,  4 Mar 2022 17:04:13 +0800
Message-Id: <20220304090427.90888-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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
index 7e3d0a019444..0ce9493cc110 100644
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
index da4b77f6c6a4..820f9fb9339b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3951,7 +3951,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -3984,7 +3984,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 0998742760c8..bf23cbe4f6cf 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -900,7 +900,7 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 2c9dce37d095..729658f00ee6 100644
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
index b325f99b2177..8fb29bbfe875 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6710,9 +6710,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
2.35.1

