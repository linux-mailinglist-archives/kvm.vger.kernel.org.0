Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C1C258E95
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgIAMuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgIAL4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:56:50 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC4C061246;
        Tue,  1 Sep 2020 04:56:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mm21so501855pjb.4;
        Tue, 01 Sep 2020 04:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6PscAPz6fJLdJCbTjR01ipVe7lAs+7UBRAQ+T/hUa/I=;
        b=BkBIHA6iylmK2/Gte+vvVSLgPmncidY9zzYNBNG9P3Qahsca2Doj2FbECMoQQX8tWC
         kHN6QBfedZ2llxGqOk3xexWi9gDsBYGSIlttQh6U3BtFenZMjtI3pQCriJRMBXVdaWmV
         gfsuodcbx8HwM24s4+LNhbpJiR59MTuaV8FEcBFh6UaglAoIsTT6OKKLhQBtIQ3JD/+Y
         8YUE+9c6RXwqzy+Ss0l8EDBEQRTAsBqyss7SwHOrOyrNhMFqLupV/vc6G4XX37eUVPWu
         da0MAMdVWuvOTP13pdBw6g7Q23xlDByXOzE1K0AvHVu6sRZXjZZfZOda0igPAX/njBDj
         FkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6PscAPz6fJLdJCbTjR01ipVe7lAs+7UBRAQ+T/hUa/I=;
        b=FN1hDaB2MuxM/XQwDR8xH80dx7gYJgIii9zaqKJep62iurPBhrlztyQ4iKS3D/3uh4
         03Dp5denaHmOmwt/lhLAb+eH2s0hJ8NUIE5UE8xhDnIy4sBikT+MCjPkBktXAHqkFhq5
         jkAHtP0exy5JzogWSWAXtROVwmUVMsEcgMRkNQERCm2dRhouHCWWI/6hMRo75nnqJa/y
         99WcGgOJmG9lWyOMOdGq/gz3vigW57I+cObhu9W0LrM0Vd7QDGSFg8FAHb0JF0E6S+eH
         4sa83Eh5WQuynsnGosSDVZM42+l8nXFeZ5UhkmUpnaJXyO/ahah/+EjKCXkVPNNKRqcc
         XnPw==
X-Gm-Message-State: AOAM533RnW53V8oEjoPA4Z2YtHotQ2eMphVgLWDfS3A+d+tK4OjnxkH2
        Io9TkdnxrkLwEqM098qIn48=
X-Google-Smtp-Source: ABdhPJyyX1YalBgcnSdcnKVOeaXxXVMHVXACebJC7SOJGm7YpRRxC5ouTKV6Ni+uKIPsId1VUyrK+w==
X-Received: by 2002:a17:90a:5216:: with SMTP id v22mr1225391pjh.97.1598961392461;
        Tue, 01 Sep 2020 04:56:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id 31sm931534pgo.17.2020.09.01.04.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:56:32 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 8/9] Introduce kvm module parameter global_tdp to turn on the direct build EPT mode
Date:   Tue,  1 Sep 2020 19:57:11 +0800
Message-Id: <1c628ce7f4f068fccfaafdf1e2d30b96753ff370.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Currently global_tdp is only supported on intel X86 system with ept
supported, and it will turn off the smm mode when enable global_tdp.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/mmu.c          |  5 ++++-
 arch/x86/kvm/x86.c              | 11 ++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 429a50c89268..330cb254b34b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1357,6 +1357,8 @@ extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
 
+extern bool global_tdp;
+
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
  *			userspace I/O) to indicate that the emulation context
@@ -1689,6 +1691,8 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #endif
 }
 
+inline bool boot_cpu_is_amd(void);
+
 #define put_smstate(type, buf, offset, val)                      \
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f03bf8efcefe..6639d9c7012e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4573,7 +4573,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 }
 EXPORT_SYMBOL_GPL(reset_shadow_zero_bits_mask);
 
-static inline bool boot_cpu_is_amd(void)
+inline bool boot_cpu_is_amd(void)
 {
 	WARN_ON_ONCE(!tdp_enabled);
 	return shadow_x_mask == 0;
@@ -6497,6 +6497,9 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
 	kvm_pfn_t pfn;
 	int host_level;
 
+	if (!global_tdp)
+		return 0;
+
 	if (!kvm->arch.global_root_hpa) {
 		struct page *page;
 		WARN_ON(!tdp_enabled);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee898003f22f..57d64f3239e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -161,6 +161,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+bool __read_mostly global_tdp;
+module_param_named(global_tdp, global_tdp, bool, S_IRUGO);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -3539,7 +3542,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
+		if (global_tdp)
+			r = 0;
+		else
+			r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
@@ -9808,6 +9814,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
+	if ((tdp_enabled == false) || boot_cpu_is_amd())
+		global_tdp = 0;
+
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-- 
2.17.1

