Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986EC4701C0
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242041AbhLJNjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242038AbhLJNji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:38 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F380C061D76;
        Fri, 10 Dec 2021 05:35:58 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z6so8483075pfe.7;
        Fri, 10 Dec 2021 05:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8587tQ45k2WukqplN/nd9/AOQH8Rgtn1yhiBRCc/n+U=;
        b=dtkz8GlvJpg0rz7WQ13oPfUTAfeLiLE9uoGhS6nicZy5uTWMKXVx1/wPFMSadI4Qr9
         P5Iffk8N8C1BOr43eVmqHRHbaR58hh5vkGdorrswQnCA2eZQvasHsh6Kado5VYzDNveC
         CX1jfgMAmPJKRgtk5sUeRRQ60o2Ole/UNAqBfKxX5Mk4NbKeNdCzedj0kOl+4yUgjIT/
         6D8ZNYSNo7iLf7Pb+I52gAK+Avl7Dr4GtS06qfGSIEjct64VFceU/FhM9nA468jl1E75
         U0zQ0w4yOM5yvWSddJ0lAVaTthiux50Rpy72wPd9yUNTyxljQA2D7lfUQeUq8L4cXEZN
         Gw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8587tQ45k2WukqplN/nd9/AOQH8Rgtn1yhiBRCc/n+U=;
        b=KqmEzU+RUWgEP5It6HQ7DPMQLS8tEKfaiS4BDj6qg2t2QT7LS9gSISDLaZfHDy9grB
         Ml4yFyu0VZAPgsgC9C6dhWzvFwIDTNL1E3KDZQuYf91GqKTkam8v/J9d7KNw7JoHD8f4
         dNUDG/IdBNg03+Yzag8oqFTqgAPcoZHHYlMUs6WpGSi6FlDUiwKEuyaWIZGDanjXrhRD
         Bm9CzLyii3chV1USBJT/SqgdNX5ylZVayTIehXmFGY+ARiGdk4BAIdWb9T914kF+SA6R
         72cS8XeZf3gpGCvDRi8gWFPWgqqw5B+V/ud2VlF3cDrsUMpmiZBST9zwVLhja92LAe8R
         XSFA==
X-Gm-Message-State: AOAM532V/n8DouV+p6bxuHwT9R5ZG75BxqQqcK+u2GxIfKz9OzOLnGTB
        wm4OPQw3h00lA/jFWZ8KLn7kfmPdqWw=
X-Google-Smtp-Source: ABdhPJye40o04ubQPLmtB7vViZr1n7OHYSBYJWkBpNgt2yLvXKnVSj3uN5EpZqZD3Ngu108JVktsIQ==
X-Received: by 2002:a62:d10f:0:b0:4b1:3bd6:533 with SMTP id z15-20020a62d10f000000b004b13bd60533mr3708923pfg.8.1639143357632;
        Fri, 10 Dec 2021 05:35:57 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:57 -0800 (PST)
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
Subject: [PATCH v11 05/17] KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
Date:   Fri, 10 Dec 2021 21:35:13 +0800
Message-Id: <20211210133525.46465-6-likexu@tencent.com>
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

The mask value of fixed counter control register should be dynamic
adjusted with the number of fixed counters. This patch introduces a
variable that includes the reserved bits of fixed counter control
registers. This is a generic code refactoring.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d225fb2c0187..9cee034445e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -503,6 +503,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
 	u64 counter_bitmask[2];
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8b9a7686f264..b76210622232 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -388,7 +388,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		if (pmu->fixed_ctr_ctrl == data)
 			return 0;
-		if (!(data & 0xfffffffffffff444ull)) {
+		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
 			reprogram_fixed_counters(pmu, data);
 			return 0;
 		}
@@ -472,6 +472,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	int i;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -479,6 +480,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->fixed_ctr_ctrl_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -514,6 +516,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
-- 
2.33.1

