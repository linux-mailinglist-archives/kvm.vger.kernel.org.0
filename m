Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F886C3F9F
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCVBQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjCVBP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:15:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3A55A6F1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j11-20020a25230b000000b00b6871c296bdso10841368ybj.5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679447724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WKp3cWIz4EB3TSxmAohTftvSjLswbqRY4EZ6PCZ/cQw=;
        b=SZzJVjS73HjISYGSqDl5X10T5A6vxZwc8w9BaiTNsBSO0cSNyB4hlwaM9sKizC4ghB
         YDRUGjRaM4MzLZ4G5+W5IAV2W19DJGyDRDcPXvhb3f3SqjoKsnvIYKT8KW8R/4xVV+H6
         RSugV8g6sUBq5chuQC3PsCeCghkYlm+xXE0o4X6rHCbn6QvhYmjpw8YtsPRNt/suO3VU
         gZfRSe1rwJCkvO3LNXWIp88QcFwDwTVMzZjFikJ6bDs9LRsjMr54Cf4DAC56UN7Ts3Vz
         EtqGl2A2qZlAFhHKJw59aMgVCZDNFW6pplnwFeTCUoKrP2ES/9Yc5H5OuoP3UvGc5AGY
         A8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKp3cWIz4EB3TSxmAohTftvSjLswbqRY4EZ6PCZ/cQw=;
        b=77Y/SvMsZnuGjjg75oSnOUXdeP16IKeUp/GlLd3q6diWFKV3KJsG0yapbE209h2dpy
         9y+dscTs84Qd0aaeIsvQigoQjrQC4YfBk7U7TbqrQhlVmysy89QZCvyujei2JpIrMuQL
         4XlluDpHFx4izhcYxu0OhWdu/thsKKsR6fF0uuFxlsZTrfVEZ4NiHe2S5QbxUb81lAdD
         wbZNv9kijTyoOKROve3JwvapBLizyUvLFvSP9SzYwvk29ixPM+cuBsu/fxFPOcDsNukL
         GCqgbZjf5k7w18UBW1dwE6QwohkyCNSW68tsE+G9TP7tfa4Sbid6XvNB1JbtIZAgLCwi
         tHhg==
X-Gm-Message-State: AAQBX9dk5Jt56UbswmXAsQ1r2e+aJTlhHbnwTXeZIOsi/EA0F0PCwEwp
        vhs2U94lwnUbDlnvl+fiKG5VZqa1d4M=
X-Google-Smtp-Source: AKy350bODg0yg1Ds22N+XsPtajs1sxEVcp7uCpy/Qzri1NtkVKUYP4coiqPgFy52W7qxjc83WnVLcP6v3+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b285:0:b0:541:8291:5237 with SMTP id
 q127-20020a81b285000000b0054182915237mr352609ywh.0.1679447724562; Tue, 21 Mar
 2023 18:15:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 18:14:39 -0700
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322011440.2195485-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough MSR_IA32_FLUSH_CMD
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtualize FLUSH_L1D so that the guest can use the performant L1D flush
if one of the many mitigations might require a flush in the guest, e.g.
Linux provides an option to flush the L1D when switching mms.

Passthrough MSR_IA32_FLUSH_CMD for write when it's supported in hardware
and exposed to the guest, i.e. always let the guest write it directly if
FLUSH_L1D is fully supported.

Forward writes to hardware in host context on the off chance that KVM
ends up emulating a WRMSR, or in the really unlikely scenario where
userspace wants to force a flush.  Restrict these forwarded WRMSRs to
the known command out of an abundance of caution.  Passing through the
MSR means the guest can throw any and all values at hardware, but doing
so in host context is arguably a bit more dangerous.

Link: https://lkml.kernel.org/r/CALMp9eTt3xzAEoQ038bJQ9LN0ZOXrSWsN7xnNUD%2B0SS%3DWwF7Pg%40mail.gmail.com
Link: https://lore.kernel.org/all/20230201132905.549148-2-eesposit@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c      |  2 +-
 arch/x86/kvm/svm/svm.c    |  5 +++++
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    |  5 +++++
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 arch/x86/kvm/x86.c        | 12 ++++++++++++
 6 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 599aebec2d52..9583a110cf5f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -653,7 +653,7 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 85bb535fc321..b32edaf5a74b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -95,6 +95,7 @@ static const struct svm_direct_access_msrs {
 #endif
 	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
 	{ .index = MSR_IA32_PRED_CMD,			.always = false },
+	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
 	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
@@ -4140,6 +4141,10 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
 				     !!guest_has_pred_cmd_msr(vcpu));
 
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
+				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
 	if (sev_guest(vcpu->kvm)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bc2b80273c9..f63b28f46a71 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -654,6 +654,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 29807be219b9..56e0c7ae961d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -164,6 +164,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
 	MSR_IA32_PRED_CMD,
+	MSR_IA32_FLUSH_CMD,
 	MSR_IA32_TSC,
 #ifdef CONFIG_X86_64
 	MSR_FS_BASE,
@@ -7720,6 +7721,10 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
 					  !guest_has_pred_cmd_msr(vcpu));
 
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
+					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2acdc54bc34b..cb766f65a3eb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -369,7 +369,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c83ec88da043..3c58dbae7b4c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3628,6 +3628,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
 		break;
+	case MSR_IA32_FLUSH_CMD:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
+			return 1;
+
+		if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1D_FLUSH))
+			return 1;
+		if (!data)
+			break;
+
+		wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
-- 
2.40.0.rc2.332.ga46443480c-goog

