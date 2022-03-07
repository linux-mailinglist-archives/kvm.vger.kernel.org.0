Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688824CFD8C
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbiCGMAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbiCGMA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:00:29 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2348435DE1;
        Mon,  7 Mar 2022 03:59:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 132so13367046pga.5;
        Mon, 07 Mar 2022 03:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/EMLF1R9r/YKE+oa6QtyVdk68sk+v4ow2FbEx9G/RBI=;
        b=jgYUMhrZwzXavAuCfGUIbXkI+59MNG7CQYuBPYvcCdKdmTESp9y2GvGE2P7E3tESoj
         swiZJebnMb45yClzZRQn73n22R/cVlOVqxphHPAN7ouRtkdSSgX6jiCqz46k1nwtAvVX
         6PdntuTProQ9U1lYfdwAleIzozBCvMYA8EUEMfyoQrwpxNKAahCaKSQNXZIYQ3ZSTDiz
         I033HyyKZtcFdC1ybleiI9olT28q/7Cl/itz0MrTaL4O3cr+ksw56yIuR4A4uULqKXYN
         tFEH+FenFsoS3lH6DV84AZ1xPtjD0psSds93cYaZgPo8NxlTSKXtRCOjdz3KPmac2LCY
         ZyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EMLF1R9r/YKE+oa6QtyVdk68sk+v4ow2FbEx9G/RBI=;
        b=hg48bSOEtoaLubmEAdId0jQXYqoRFhVMNTU5KronvgNAfQlznoCM+jCmkcH5C/VKmh
         Gbuv1awb8ovE5b2tbHTCEP1S8jPLr0r158wtx9rTrEKeONT5+aCUT7ImDRkIt/hkxC1y
         vFl/c3QxIdhaTyy6MLJ6bJUubDXnt2f06o629aIodd2WWEoO+2q8ryMiUPFkbhh8lnT4
         LUAAc19TVmWgEPuTlsz9XNFtZLpk21NK+YDbyrV3zM1wsqtu/Ft318a3qs9cndXoLeY7
         Br1zGMGvY8w/4Nrml7zQUXeM91dBhIokBioxvV8YVrq6l/ZgEBWpYOaUQrCCZaX17Y/G
         Iwmw==
X-Gm-Message-State: AOAM531m7cJ5cVO7IHVADjhWMB3P4zxL43yveif1uYlLXKTCjXeNvcZs
        W7qgDh97yYawtQkRGsrEhTA=
X-Google-Smtp-Source: ABdhPJx+7fIX8dvU8TtQUo49IAIiR4zoO305johadrm1ALjshXH0yvqwjg1tzEa94yZbatBmewPf8A==
X-Received: by 2002:a63:c1d:0:b0:365:7d16:f648 with SMTP id b29-20020a630c1d000000b003657d16f648mr9636253pgl.517.1646654375692;
        Mon, 07 Mar 2022 03:59:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm15323164pfh.153.2022.03.07.03.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:59:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
Date:   Mon,  7 Mar 2022 19:59:19 +0800
Message-Id: <20220307115920.51099-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307115920.51099-1-likexu@tencent.com>
References: <20220307115920.51099-1-likexu@tencent.com>
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

The pmu_ops should be moved to kvm_x86_init_ops and tagged as __initdata.
That'll save those precious few bytes, and more importantly make
the original ops unreachable, i.e. make it harder to sneak in post-init
modification bugs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +--
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fdb62aba73ef..5d7297d1d71b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1448,8 +1448,6 @@ struct kvm_x86_ops {
 	int cpu_dirty_log_size;
 	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
 
-	/* pmu operations of sub-arch */
-	const struct kvm_pmu_ops *pmu_ops;
 	const struct kvm_x86_nested_ops *nested_ops;
 
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
@@ -1520,6 +1518,7 @@ struct kvm_x86_init_ops {
 	unsigned int (*handle_intel_pt_intr)(void);
 
 	struct kvm_x86_ops *runtime_ops;
+	struct kvm_pmu_ops *pmu_ops;
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d4de52409335..d4876e6708c5 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -320,7 +320,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_pmu_ops amd_pmu_ops = {
+struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc5222a0f506..21d85c8929d5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4613,7 +4613,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.sched_in = svm_sched_in,
 
-	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
@@ -4887,6 +4886,7 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.runtime_ops = &svm_x86_ops,
+	.pmu_ops = &amd_pmu_ops,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4e5b1eeeb77c..2c783ad122b9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -715,7 +715,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-struct kvm_pmu_ops intel_pmu_ops = {
+struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8963f5af618..06088e26adae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7823,7 +7823,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
-	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
 	.pi_update_irte = vmx_pi_update_irte,
@@ -8078,6 +8077,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vmx_x86_ops,
+	.pmu_ops = &intel_pmu_ops,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcaeedeef675..0a76f7281e74 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11536,7 +11536,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		return r;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
-	memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
+	memcpy(&kvm_pmu_ops, ops->pmu_ops, sizeof(kvm_pmu_ops));
 	kvm_ops_static_call_update();
 
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
-- 
2.35.1

