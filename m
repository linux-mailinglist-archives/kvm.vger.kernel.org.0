Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB324701DE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242458AbhLJNkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbhLJNkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:03 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F37C0698CB;
        Fri, 10 Dec 2021 05:36:20 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 137so8126499pgg.3;
        Fri, 10 Dec 2021 05:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/7Zcr+HyNanLEf+1i+3zWybEdEC4GFJeQgtkWfdckoI=;
        b=aS6XBadUQ6B2eQCf7H//l13oPlNMi3AL+2GzrBfSGHB8iXerWOFwChhVv+Tklw3rVM
         2l1HcicB5uNpf3qc4/4kaavq9pt0hfngH7uA0GfdsK43d7/+fgGUKsP9adrtD8lQT4OT
         rGbxUAK6jgd2J1/3AhPUeKthVsEpBGEyQ+NEs+FJoQFuupT1FxE/P4VduEoUpHyeF9gP
         nSbYlPuMYtVMU3QVLcpuitnMmMJeJxFyrxI6n78sfLPAWqFOpTm8L6GFw+0Sr1mbjWK9
         rXdLf3Vll/0HsmV7yP7MVQZAqKiS2l3E461QJTrZUPbgtgaTDC8EhOQ4+Fi1cB1BOpvd
         p/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7Zcr+HyNanLEf+1i+3zWybEdEC4GFJeQgtkWfdckoI=;
        b=LRcxLzEpfSx8ryDi2rRpjN1hHv4n8+r4yitpSv3DBgfWGluKK8xapwsVGM9/4bsTS5
         DmQefUiaf9ACV98RnUusJNlkClgG7a8FLUFG1kLFIvOFboClsjB9VWB1+2UraGNvFwZv
         /7BSH41W1d/C9DrjGZcjHH4TPA7mHHOsswtYqFrg84ljJSoFbWRnu0YEnvpb4jLpx/DB
         xcR7suUv5VDwyQzqJSjD/EGn5i4KT5Z1gvFdciXNFJcA81ZUan1NMeNvd4+r+Qhve6I6
         Wt2GIw1pjfxA4jMKtnAUrbLGz2+T7RuJkYbTXhnjDVjlqwtGFlBtNvDuDYWQzobi70mG
         jv7w==
X-Gm-Message-State: AOAM532guIZ6ohYrU5B6AQL8oF4AtjRUG1kOF/0wfEYx4GUvE58n8aaC
        YtiDQoc3SVL7zoUPyC53a90wbstjm/E=
X-Google-Smtp-Source: ABdhPJw9Lbxu0BLR1WbEkFE19tmV+uwmmh4CxUX2s4cmLzzudWJ0rK1DcgZKA+VpICcmSV9ha3DkyQ==
X-Received: by 2002:a65:654f:: with SMTP id a15mr39924814pgw.195.1639143380451;
        Fri, 10 Dec 2021 05:36:20 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:20 -0800 (PST)
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
Subject: [PATCH v11 12/17] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Fri, 10 Dec 2021 21:35:20 +0800
Message-Id: <20211210133525.46465-13-likexu@tencent.com>
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

The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
	1 = PEBS is not supported.
	0 = PEBS is supported.

A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
is enabled. Some PEBS drivers in guest may care about this bit.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10de5815deca..10424dacb53d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -591,6 +591,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -604,6 +605,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd331f2e123b..d7201762c1b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3480,7 +3480,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE: {
 		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
-		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
+			MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
+
+		/* RO bits */
+		if (!msr_info->host_initiated &&
+		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
+			return 1;
 
 		/*
 		 * For a dummy user space, the order of setting vPMU capabilities and
-- 
2.33.1

