Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6933D4FB957
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345299AbiDKKWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345287AbiDKKWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757A642A1D;
        Mon, 11 Apr 2022 03:20:04 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z128so13796874pgz.2;
        Mon, 11 Apr 2022 03:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OB+LpKcxSFlv6LK5hGv3awHZDk5VXJS4MYFby3FUGPA=;
        b=liIgWyupUgy3HIe9mst7uJAzZ+vUN4xxzUoG3svtL+/V/KCvDO6SJTLMtRYaX2d8it
         1m5/pbjyqrtG0LuNpH8ul+ZQwJLOGNCquA+Psu6MRivZGENhmfssaZz7G3SQcjVqWV6q
         QLb+dQD6yRNNILPesozfwLeFQ7zowz+r1COrb+j5yzkVmkyxVlZjaM2z66N96EvlBnUS
         CXpS/zoi/9LkSZQfxN1uX7HGpfm5ZYMpjyYmQem7Om+KjGyPSZMBoaZ/61xGqKkJjJF7
         7zNc9tdzu6GeFMg4v2JgW+1d5OEAo78/8FB1RJ6cwEoGPX7+CfuoGf77Oasf+vzBz5wl
         LTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OB+LpKcxSFlv6LK5hGv3awHZDk5VXJS4MYFby3FUGPA=;
        b=Ns9XJuJkfUSSsLR0X01aYTgHFggGzDhqGNA/vlGmS8+IyJyMNh7cZd/xfRv97JI3Q3
         Rc8o8Yc9EzyBOeY/tBLtQFyt1Dwbcbz1BTgv0q6xYBhARbfpuKOwB5QoLUuUUxc9O1qd
         xRItpbf4/JSxSeuUou4IcKBErYQ6ntojvT7yXzgGvJ+zlqlKVjmFvjKIBMQt0duuLVJ+
         VFVPr0UhU1vV9O4SZllrvrWVgz3WOP00sIrlw/+JT3aT7Q7diiXNqNbRB5xZ3IYb0qI0
         jVuxpw/ZLIwTCVPx2Ho1x5v7TwMCK7Lyf2/qjChXd+uJQzOoB6kNWZyqhsEX6QYMIMbj
         YU6g==
X-Gm-Message-State: AOAM530251mQRAkWW0ilD/TLx0aMzmqndMr5wWeeIq7/0vgtNGEBCkex
        dSGdiLm3QbfK+qFAUITJUn4=
X-Google-Smtp-Source: ABdhPJycPqc3FDFhUjMIfQFHsFqqInC4WtiOAV2W3kuzIg+Qtn7Rrs/HCWlngsmr2RCB03jXBsLEzg==
X-Received: by 2002:a05:6a00:23d2:b0:4fa:f262:719 with SMTP id g18-20020a056a0023d200b004faf2620719mr32205922pfc.4.1649672404407;
        Mon, 11 Apr 2022 03:20:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:04 -0700 (PDT)
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
Subject: [PATCH RESEND v12 04/17] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Mon, 11 Apr 2022 18:19:33 +0800
Message-Id: <20220411101946.20262-5-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
detect whether the processor supports performance monitoring facility.

It depends on the PMU is enabled for the guest, and a software write
operation to this available bit will be ignored. The proposal to ignore
the toggle in KVM is the way to go and that behavior matches bare metal.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 arch/x86/kvm/x86.c           | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9db662399487..e101406dafa3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -502,6 +502,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
 	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..4b64b3ff5b67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3550,9 +3550,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
 		break;
-	case MSR_IA32_MISC_ENABLE:
+	case MSR_IA32_MISC_ENABLE: {
+		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON;
+
+		/*
+		 * For a dummy user space, the order of setting vPMU capabilities and
+		 * initialising MSR_IA32_MISC_ENABLE is not strictly guaranteed, so to
+		 * avoid inconsistent functionality we keep the vPMU bits unchanged here.
+		 */
+		data &= ~pmu_mask;
+		data |= old_val & pmu_mask;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
-		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
+		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
@@ -3561,6 +3571,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
 		break;
+	}
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
 			return 1;
-- 
2.35.1

