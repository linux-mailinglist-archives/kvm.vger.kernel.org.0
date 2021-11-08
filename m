Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F13447E8F
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbhKHLNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239024AbhKHLNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7EBC061764;
        Mon,  8 Nov 2021 03:10:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so8541803pje.0;
        Mon, 08 Nov 2021 03:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FWDD7U5T1WcrJwl6pQa+h0PSq1RnVU3eKyaFAF8L5xY=;
        b=FOGfOXSbF3NETUtUwFL6yABlqXRXPJm7+TmBzYElCbewOKUX988Kh8HQfAS9g9ZqWY
         waBn0zjOPnKm2JI/vq903BGJ0r0rbsueqc+T1hn5uzUpOewmu5YoBfCwDkimwDeXlqVK
         7aDYS+vDFMoUOJkxZaWGQBwNGZnpnhU3PfZckanfVzG/55/nXBgxCqFSgUSeh9aR0qQT
         9Ah2x9exvVQw5+/JES0uwItahKiuBJyZG3TPwENNc2pXlCRnbG9xH839/6FHNrVa12K2
         pzQeNSHfZK8nuGm2EeKLbgoZ263ShByPcWvsl7OmQf0JsWngk3GSwdgRHrkpcdbF2z9f
         ZdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FWDD7U5T1WcrJwl6pQa+h0PSq1RnVU3eKyaFAF8L5xY=;
        b=GSPxtcYVDgMamNsrR9QeWSe6G6P9Dbq/EJidwGR/aI31ZvCWEdLKt37ihExX+87QqS
         d3yJqIBMjGuJgX5J9HNo3AptfNxg35/h1Fz0bMKeE/AxUWptEKMrBM000YNp82REZ9NL
         z72aGae/vmOAmkiOUK6QJ6vvFr/YjnlmYCIN4EnO7LMLDBO3SJfNNOm7JxTnvZ0m6x57
         XiG98K5yrCCequ+AdOK9eW7GtnyRcLCInPQM+WMIA1oPHhiHZkk/m+HCzOBmI7yJbJ3O
         kCOoFFSBhP1xBudvAGZ9yiRlwsRRgHeJm3B/M6TgsjsLMfscbuafoWeB6H3ZnUxNaLxd
         WT3A==
X-Gm-Message-State: AOAM530KLYJtRThJyCrPsXo68B6GTS4QS3H28s1FK/klBJdcovUmBH9j
        /7wtFlWMwSr3Imj64ezwSIM=
X-Google-Smtp-Source: ABdhPJxTBZGnQqvy/uNTvHf1dPikXZ+3SMPWqLBbIGbFxXhzRXIaV2TnzAs7CzsVjdrOC/o74UewAw==
X-Received: by 2002:a17:902:6b47:b0:142:82e1:6c92 with SMTP id g7-20020a1709026b4700b0014282e16c92mr4725669plt.84.1636369857815;
        Mon, 08 Nov 2021 03:10:57 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:57 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tagged as __initdata
Date:   Mon,  8 Nov 2021 19:10:30 +0800
Message-Id: <20211108111032.24457-6-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2d4ee2973c5..00760a3ac88c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1436,8 +1436,7 @@ struct kvm_x86_ops {
 	int cpu_dirty_log_size;
 	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
 
-	/* pmu operations of sub-arch */
-	const struct kvm_pmu_ops *pmu_ops;
+	/* nested operations of sub-arch */
 	const struct kvm_x86_nested_ops *nested_ops;
 
 	/*
@@ -1516,6 +1515,7 @@ struct kvm_x86_init_ops {
 	int (*hardware_setup)(void);
 
 	struct kvm_x86_ops *runtime_ops;
+	struct kvm_pmu_ops *pmu_ops;
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fdf587f19c5f..4554cbc3820c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -319,7 +319,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_pmu_ops amd_pmu_ops = {
+struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.find_arch_event = amd_find_arch_event,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..8834d7d2b991 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4681,7 +4681,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.sched_in = svm_sched_in,
 
-	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
@@ -4717,6 +4716,7 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.runtime_ops = &svm_x86_ops,
+	.pmu_ops = &amd_pmu_ops,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b8e0d21b7c8a..c0b905d032c8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -703,7 +703,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-struct kvm_pmu_ops intel_pmu_ops = {
+struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104..ce787d2e8e08 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7680,7 +7680,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
 
-	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
@@ -7922,6 +7921,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.hardware_setup = hardware_setup,
 
 	.runtime_ops = &vmx_x86_ops,
+	.pmu_ops = &intel_pmu_ops,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca9a76abb6ba..70dc8f41329c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11323,7 +11323,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		return r;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
-	memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
+	memcpy(&kvm_pmu_ops, ops->pmu_ops, sizeof(kvm_pmu_ops));
 	kvm_ops_static_call_update();
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-- 
2.33.0

