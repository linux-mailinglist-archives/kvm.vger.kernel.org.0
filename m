Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C94FB95F
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345363AbiDKKX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345406AbiDKKWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:40 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2A4433AD;
        Mon, 11 Apr 2022 03:20:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c2so13767095pga.10;
        Mon, 11 Apr 2022 03:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L0MhK9PPLx2ef+AAuUU4lyKe3grecX7ljWd/YJK+ko4=;
        b=aBxoxMqACF7mABq4CmwecwDKPTJ8Nm7m07H0t1XpEW0qnvxvo7lrlC51BCm7j1D4Vw
         XEvLOsfnDUKaaCTz4UB8DEtiO5f0gdOV07X1op03tTrHi2X0Gi21bZCam1uev+LHy9H7
         7Mi2ajmTmXUqgUgCpFKfIjjN64uMIGE1GBdoTTebK2y8vRLhEG+ujRYGjZxxDvU2vZ2z
         Tr3QGhAtnDyrkmKJ12/iTwq6m4qY0EQMG57OtOVcbyTiW9dVjrB5KKnRgRJsa8fWSvYS
         MAlBdvuorUV7tPyVML7tuIIOVMRdHDjg1NH9cYGCjEDCdOjQaQ5oVxWt2fC0CPcb+dL0
         2UZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L0MhK9PPLx2ef+AAuUU4lyKe3grecX7ljWd/YJK+ko4=;
        b=0a3Z7l4qd2Ma1UXwVfe+urNHNEoTyDZiwDMzkt62djbdO0nXAJoRNtjg8j2a2j1Odg
         SmeTKGYW9OwHoxRLiSSt/LLui8ti06pNwNjjzzsTlLvL9BPkaaP0iZWNTDy5C8/PL2xT
         VqjN7naGIJsWTnlXeiZsOhpGuAytnojwgZj7iv1Z5qBjMvLO9xwQgFAMCFInbeMVaeSh
         3+u/LqXACnRQ67JkBEMOhjtjmgt13vuc+8UXmcPc6WIPmCE7fH+fW6VxkRGOPn6BbmPO
         sX2fxqjohYXN4A5uJoGVETyU66kDkFCV2XJXagZI20jttRCROJqtkKjDyI0De9M5Dwkh
         ViCA==
X-Gm-Message-State: AOAM533gNFJ4TwxkhX3o0aFLKHxs8WCierXUQnkCQHAepYehObc7RdPV
        /dQlNasAkEm0CxP8wJvhVesjXK8oVhc=
X-Google-Smtp-Source: ABdhPJyMVmD8BV0ERMT4XZC76RDq6DToaHMV3Ux3qlvvT8zLymKA5Zybj1yJ78W/wCtzlAznGBc77w==
X-Received: by 2002:a65:4185:0:b0:399:4c59:e3b1 with SMTP id a5-20020a654185000000b003994c59e3b1mr25372115pgq.154.1649672419910;
        Mon, 11 Apr 2022 03:20:19 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 09/17] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Mon, 11 Apr 2022 18:19:38 +0800
Message-Id: <20220411101946.20262-10-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.h           | 8 ++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 270356df4add..45f3bab5d423 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4024,8 +4024,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 
 	if (!x86_pmu.pebs_ept)
 		return arr;
-	pebs_enable = (*nr)++;
 
+	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 36487088f72c..c1312cd32237 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -175,6 +175,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 2a53b6c9495c..06e750824da1 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -4,6 +4,8 @@
 
 #include <linux/nospec.h>
 
+#include <asm/cpu_device_id.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -15,6 +17,12 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
-- 
2.35.1

