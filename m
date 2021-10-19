Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841244330E1
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 10:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhJSIPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 04:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbhJSIPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 04:15:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A374C06161C;
        Tue, 19 Oct 2021 01:13:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so18626327pgl.10;
        Tue, 19 Oct 2021 01:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9p5KOgAyYKQ6mv8A6+kG8/3gLf/WqhzHaO9t6Ws/o2I=;
        b=F3wnNpf7rZTlFVmDHuUD26hwbDFFV1nH41Fx9vbTjORylmTM0ENedMOjhHi7PuaIV2
         1CTDEL/201O3DAKe4ORMgwj5EuVT97rGR8rciYV/Fsk4LIyaKSkWt0r4YkgpjZDgQAOU
         NbZUmUZ/Cpg65oDvLYB7yQQImimeZfzlCt2cvYl5Elak8L7OnfBZqdXRWLn742AD5XA4
         5OSlQdOO+gsoqPXS6adkK55tp1MH4Agc/hb6PdYS6RkbM/NjCZB71Njzmh5sI8f0myOL
         muPNBbtTO7dvhW5Y3hwl3qGKpZVHUPGlA3lKWY3cFimWw6za9ZwnMuyjCgpJJOjxNb7T
         zMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9p5KOgAyYKQ6mv8A6+kG8/3gLf/WqhzHaO9t6Ws/o2I=;
        b=DyMJ0EhujLaYFSHZVEm/1QNm3dqZey6y6fC9nOp0cl/+J35WmMw4zqGP10tS2TcKtS
         9qqtENmXwwC1HfZ6G6lQ6bfCq3CgI6VN1gTN5HVqmCUdwJdhxl650rPZXrO6sEC4V97P
         MXOrGgjIqcjwGLYp/JZ1HoACJ0WToEO8/bY3h/zzlfq1fcSAqxDnEZCizBdsGQC6M7yY
         fFAutu39S9XLILBcz9foWNT10sszeE/4xKDbA8D70OhOMdIHQTWJC0dtdAq/ISJmgzyd
         CTx3o6Bodm9xBUHVRqyrJUnBfX1x8krQePMvx5vht489R9OOp90eyEbnBc1IJs1v0i7t
         +pIw==
X-Gm-Message-State: AOAM531Iav20H7W9XJyc+Muc73qQ9/XymaxpnWh/tQTVjgVlpQLDx9YK
        3kwpiP/sqdr3ryJzhFinxFB4RW1BO3d61w==
X-Google-Smtp-Source: ABdhPJy909ToRg1lkvio4YpUoGsjqsCeoJxqw05T3rY/CDAahY5PbeIMUXb/hcJn5xuwOlkg/Bhy1g==
X-Received: by 2002:a63:7b1e:: with SMTP id w30mr8251228pgc.464.1634631213844;
        Tue, 19 Oct 2021 01:13:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id f15sm3254064pfe.132.2021.10.19.01.13.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 01:13:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 2/3] KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0
Date:   Tue, 19 Oct 2021 01:12:39 -0700
Message-Id: <1634631160-67276-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM section 18.2.3 mentioned that:

  "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of
   any general-purpose or fixed-function counters via a single WRMSR."

It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing,
the value is always 0 for ICX/SKX boxes on hands. Let's fill get_msr
MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior and drop
global_ovf_ctrl variable.

Tested-by: Like Xu <likexu@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Btw, xen also fills get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0.
v1 -> v2:
 * drop 'u64 global_ovf_ctrl' directly

 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/pmu_intel.c    | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..7aaac918e992 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -499,7 +499,6 @@ struct kvm_pmu {
 	u64 fixed_ctr_ctrl;
 	u64 global_ctrl;
 	u64 global_status;
-	u64 global_ovf_ctrl;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10cc4f65c4ef..b8e0d21b7c8a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = pmu->global_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		msr_info->data = pmu->global_ovf_ctrl;
+		msr_info->data = 0;
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -423,7 +423,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!(data & pmu->global_ovf_ctrl_mask)) {
 			if (!msr_info->host_initiated)
 				pmu->global_status &= ~data;
-			pmu->global_ovf_ctrl = data;
 			return 0;
 		}
 		break;
@@ -588,8 +587,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 	}
 
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
-		pmu->global_ovf_ctrl = 0;
+	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
-- 
2.25.1

