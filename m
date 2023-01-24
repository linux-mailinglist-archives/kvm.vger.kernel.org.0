Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED62567A731
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbjAXXtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbjAXXtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:49:25 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0B9518ED
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:21 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id s14-20020a17090302ce00b00192d831a155so9691276plk.11
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=etFpX/482XpVxpk8+X7x9LZK6GHklrmOWmBG2Y9l9JY=;
        b=PaPFcjkY84c1BKENp3ubJyva/NBLjPo7sEgZagcT9qRPJXepm8n4k89Wf8MPHqwKV2
         xL2OgFZmaF2JpR1nfmxlaWEWDb0SwBh4jQ84r9tWNS3F4rOTph2CtS2Ud0rtf2oY/pk+
         65GpkRiNS+I9N4JGjXmB5WmUJe4XN0xc9GAjoJiJNVAMjRnWDoc2gK7HW6T6w8zwXL3O
         553HY1KeSy3AINSbZpAOVOFSwHpc2Tin9dHIK7KsOMQXnKKLDahp8tBeTiCMoPoChrwY
         5GpuYETk271PwyEYZ7xzfyOBnY6mgTYC88yDxdYQTM2LFZt6YibyDdBDND7jAHi3UFpA
         p4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etFpX/482XpVxpk8+X7x9LZK6GHklrmOWmBG2Y9l9JY=;
        b=eScVSMCkwhAk35DLITkGQWF5bHgv+u+LQjJK1WRVmx+tl2SPpjcezI3A5HQGQeECx0
         gi3D7Fz/q7OYmZtZ+8juHmoKyoXOcAGsPrLZGo2qiAUtvdD2sXoNYd7Mv0+h8atG1QHf
         lWtgygqh7s1+uWJdHfN2LuBTu6gkikHuq7NLPv7LR0QTFSmf+VCp9N6j1KUJZQpZN0xR
         1ecRMJsuTRD8d+yYTdxglM99T5YNOQVcnJ/tzWgI5vrhFiQF2ntHPWLbVJEkZK604AQU
         eiP7fNcxMx4q0KndJ+9lwRyyfofDYr5ai8jHzwGhANPofaMAJQsvbER6ARBzXMhkE5qa
         mh2Q==
X-Gm-Message-State: AO0yUKWkhvaPk7TgXLASIjSznceASXLIzoaSIfy6P7tEfLkhbIqin1BJ
        njtJ5G7xnFGXMBQ1Fkh3EHeueE5J8wk=
X-Google-Smtp-Source: AK7set8SaE2MZIRg9LgmCIwbSkWZ/LgOB2ipKmhXTLetCVx/z8v1pT85QcQW4E3nEHJMgo6DIweuCZPB1ls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:131e:0:b0:4d9:ed5e:5e99 with SMTP id
 i30-20020a63131e000000b004d9ed5e5e99mr11422pgl.69.1674604161397; Tue, 24 Jan
 2023 15:49:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Jan 2023 23:49:04 +0000
In-Reply-To: <20230124234905.3774678-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230124234905.3774678-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230124234905.3774678-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: x86/pmu: Don't tell userspace to save MSRs for
 non-existent fixed PMCs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Limit the set of MSRs for fixed PMU counters based on the number of fixed
counters actually supported by the host so that userspace doesn't waste
time saving and restoring dummy values.

Signed-off-by: Like Xu <likexu@tencent.com>
[sean: split for !enable_pmu logic, drop min(), write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd0151e6af62..adb92fc4d7c9 100644
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
index 25da2cc09e55..3c49c86b973d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7055,6 +7055,11 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		    kvm_pmu_cap.num_counters_gp)
 			return;
 		break;
+	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+		if (msr_index - MSR_ARCH_PERFMON_FIXED_CTR0 >=
+		    kvm_pmu_cap.num_counters_fixed)
+			return;
+		break;
 	case MSR_IA32_XFD:
 	case MSR_IA32_XFD_ERR:
 		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
-- 
2.39.1.456.gfc5497dd1b-goog

