Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE67656220
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiLZLRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 06:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiLZLRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 06:17:33 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E94562CB;
        Mon, 26 Dec 2022 03:17:32 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b2so10490036pld.7;
        Mon, 26 Dec 2022 03:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cyx9dY3OzBvOxLsd6YY1TSqE0kQ174iZYU6DkzM6T5g=;
        b=IOAhnnmlAmDC8ZsvQQvXRZns9yfUaGkgc4DCIh8yVpCdRHbZMQ2AjgwWu/I0tTUmu7
         w/8DXg2bRGVIML1f4BXjYv8Az2s1oN+jRAWm/awGXBYy6AdcL7V2kSbcP2eOcnZfL5w0
         Waf76luqWB3mKN4yZ4l+x8y/b7cED3OfQNC1auuXdEbhqMhMv1vb5t+KSJGYnEixVuXF
         7VRhS6VMR3cMP1or/g8MEcfeN5dd5sguTy2rLp047Od8JpOQaYUS4pINPoe+7Wv8IKDe
         +3OIUcyG2fjz0mbdXO9n4xk7beFXIL3ILMV/X1g0yIp/x3jcGvajXHVE6jiKdjo33bOR
         CodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cyx9dY3OzBvOxLsd6YY1TSqE0kQ174iZYU6DkzM6T5g=;
        b=RaN2vpJxZFIwfVLVQ4cJaeytzKwEsC7ObL1CkBOgq1VxOPwo8YtUIMgBijTQwdifz7
         2xUDIkmzRA1G4a2HYqk6STQWe+mARRGgCoBLH5sMPn5I1Bc8Vw2/khz/3S6oLtwPQTPb
         M97tNe+fXlomUHbF/EefB571zYRO/SL2Wzmwtph13FzJJ6/b7NMIT1GLj/rri2Y0x5sB
         iq0ua1J4RmiRI0HdfYueWZ69u5bO1x+9fJgQAq4xvs564zFKhkmTjbCaVLgBCJYJ8oFy
         a1eS2+AG5mWueMkUjsczbCW6hlO2uyeglU0do+/vfZLVvfHN5LSvTKrC+n4Ojiz3F8AP
         V3xA==
X-Gm-Message-State: AFqh2kpVxPvQtcVX8qxaKxz2YMcHLT//pudvVAZZf634U7SWXipXUHym
        6bYcF3LRPk6i7WT2UtSteqw=
X-Google-Smtp-Source: AMrXdXuMhvGXOMVD/fJn5i91tKHpg9vLFgvIRjneHXzUMVBrfqe+G6LlCpiqPo3yr8KaFOtUB7EyIg==
X-Received: by 2002:a17:90a:598f:b0:21a:1b9b:139c with SMTP id l15-20020a17090a598f00b0021a1b9b139cmr20716416pji.47.1672053452068;
        Mon, 26 Dec 2022 03:17:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id dw6-20020a17090b094600b00223f495dc28sm6281490pjb.14.2022.12.26.03.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 03:17:31 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: [PATCH 1/3] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST if !enable_pmu
Date:   Mon, 26 Dec 2022 19:17:08 +0800
Message-Id: <20221226111710.51831-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221226111710.51831-1-likexu@tencent.com>
References: <20221226111710.51831-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When the PMU is disabled, don't bother sharing the PMU MSRs with
userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out
so userspace doesn't have to keep track of them.

Note that 'enable_pmu' is read-only, so userspace has no control over
whether the PMU MSRs are included in the list or not.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f35f1ff4427b..2ed710b393eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -514,6 +514,7 @@ struct kvm_pmc {
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
+#define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c3ce39cdccb..f570367463c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7054,15 +7054,32 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
+			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
+			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
+		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
+			    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))
+				continue;
+			break;
+		case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
+		case MSR_CORE_PERF_FIXED_CTR_CTRL:
+		case MSR_CORE_PERF_GLOBAL_STATUS:
+		case MSR_CORE_PERF_GLOBAL_CTRL:
+		case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		case MSR_IA32_DS_AREA:
+		case MSR_IA32_PEBS_ENABLE:
+		case MSR_PEBS_DATA_CFG:
+			if (!enable_pmu)
+				continue;
+			break;
 		case MSR_IA32_XFD:
 		case MSR_IA32_XFD_ERR:
 			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
@@ -13468,3 +13485,4 @@ static void __exit kvm_x86_exit(void)
 	 */
 }
 module_exit(kvm_x86_exit);
+
-- 
2.39.0

