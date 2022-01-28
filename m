Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158B149F008
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbiA1Axy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344820AbiA1Axl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BDCC061760
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id n185-20020a6227c2000000b004cb97301208so2450931pfn.19
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ldoMrug6/7uSyZ7OKlLwWruZUYkJwaLAkyiaTEJ0iUU=;
        b=mUdnvkN7tH+7otOj0dkAhqTLAcfZ+KC1Q/CJ4/Avi+YlF4wdsJJyLvhzaSt1vl44fv
         r3P/ljme71mSY7D2gj2RHTNnEA54nq4544MbHpQdwTpkN/y9zN+NL6c3v0YxMw61Mefj
         VruGb62kl1ebUw9XdjmqbhtKyv2+hJHjpsFh68HNSnAI3fK5uBgzHBgS65Pb8wdRTqE+
         Q8ePRBp6PwKUh/mkOgcaYUEe9KrRqsw9ehWXekCrmD7q+lV3beXIHncX9JWr3qxtcoFj
         BaHxeuuvJIBNA539Isbnk70Am7vMq6O42GlO7zZp2EMYXlwN0rtBq/4WoqROZ+X8zFGp
         lUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ldoMrug6/7uSyZ7OKlLwWruZUYkJwaLAkyiaTEJ0iUU=;
        b=78cppwaERTu/kc59zF9rIsji9mJyv6grW34Pl5CG7G/DAd/0kWCPMoRsUfAzh9jp+f
         TksMrh+lvAXDBpIHRsKMP3JBasNWtRClaAau+N2tzctfrEXobklWTxGPhG75SJ4DMyG0
         6hPBRCMnGZ8aBj1ui2DLmSfNiCN3kClLVxyslz3S7kIVEXTMpr+BylCFol+vWFlCPZtZ
         23TqQu3zj7AWyV9e6S9jAoagVX3u98YXiZZiowtHa2N85UrewEE4P0G90ZZJSblXl4M3
         zwx0+9qy9HNdyzU4VORS6K23tfyX70GGzlCnvSo28AX2Df3dejmoSNCh1meoLBJ1lSsC
         Hh7g==
X-Gm-Message-State: AOAM5301zTcJh+fBaW7bnjylRa8EYITNyTcEwbLZA0V94gx6PMM1eeEF
        S8FaT5D7S4r59mq7trsJxWRA3q9U/SA=
X-Google-Smtp-Source: ABdhPJxoxaXfQrJ86rto1Je3b2wzdDzQzfiKG9ukjweOcaysI3tbhWDZNMQmALj1SPWHx85HrEiaOdhcyMo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1256:: with SMTP id
 u22mr5882686pfi.82.1643331207256; Thu, 27 Jan 2022 16:53:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:54 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 08/22] KVM: nVMX: Refactor PMU refresh to avoid referencing kvm_x86_ops.pmu_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the nested VMX PMU refresh helper to pass it a flag stating
whether or not the vCPU has PERF_GLOBAL_CTRL instead of having the nVMX
helper query the information by bouncing through kvm_x86_ops.pmu_ops.
This will allow a future patch to use static_call() for the PMU ops
without having to export any static call definitions from common x86, and
it is also a step toward unexported kvm_x86_ops.

Alternatively, nVMX could call kvm_pmu_is_valid_msr() to indirectly use
kvm_x86_ops.pmu_ops, but that would incur an extra layer of indirection
and would require exporting kvm_pmu_is_valid_msr().

Opportunistically rename the helper to keep line lengths somewhat
reasonable, and to better capture its high-level role.

No functional change intended.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 5 +++--
 arch/x86/kvm/vmx/nested.h    | 3 ++-
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2777cea05cc0..fdae31db640c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4796,7 +4796,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl)
 {
 	struct vcpu_vmx *vmx;
 
@@ -4804,7 +4805,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		return;
 
 	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+	if (vcpu_has_perf_global_ctrl) {
 		vmx->nested.msrs.entry_ctls_high |=
 				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high |=
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b69a80f43b37..c92cea0b8ccc 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,7 +32,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..03fab48b149c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -541,7 +541,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
+	nested_vmx_pmu_refresh(vcpu,
+			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
 	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
-- 
2.35.0.rc0.227.g00780c9af4-goog

