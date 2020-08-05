Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4F123D181
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 22:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHEUB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 16:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgHEQkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:40:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B87C0086CF;
        Wed,  5 Aug 2020 07:15:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y206so12491410pfb.10;
        Wed, 05 Aug 2020 07:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+xqqce3bt1Dd6YXyCPFzN+2GzEUcHoRk0/h1IH691fM=;
        b=vAw9kGgbL9KkM2+HjZkFVCiAEauRuoyizHa2DE6NIt/H/ukbr4biFl6FGaPLzqYR1m
         Y8feBgiVM4qSu50iFsGj6seA3Q+j9oLVsC7ZTIW301zQZQePILt51nINe00B/lm8asGU
         PKFIcoHfyTy1Yx46R8iwO4Rxoy5FpkzLWDtvWhOqdK9bSIiQs6/5DuDW7e0ipqsIoY0A
         08il6ksimfsPfvDVAGglj0SYwjOIfKLZxarQPN2FahhOz43Is6/czXHIMgMCOgMr4y04
         vhwJqQOnsRjbTh6jrbJbOGh7SYE4nuYoF8PVX7nrKYDnKxHNrLHLJczLHyu9B/gQ/KA7
         GRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+xqqce3bt1Dd6YXyCPFzN+2GzEUcHoRk0/h1IH691fM=;
        b=bRSBgwUsoZJA+v2asKhhrB0Q6JOGDp+Ykwbvb5CrNSQaZhPP675pt3f6D8R4fqdKp+
         LAaeJPAlRVFqvwa0ysLPtO7c66We2P366giN0AR81qYVVzguwoaoZyXOvu7cHVUhlfQ9
         nUTanDYeXJb4ETE3aWDfUpZBOfdZYl5D8Tb4w0Ut5WomoXYzXqExMs2xjepXvUgi8UrV
         5gN+vh0eshD5/ehUs/kwbLjCJkFIQXVMS2yWY9R24gOg4/kYIVP6q2ZdPR1sNYU5Fyii
         jX/I9t4sQyqMRYgVNRJunhmvNkWfvMdfcxWjHudZRKYBClqFS9haijnnpWPD2tWczB6u
         /08Q==
X-Gm-Message-State: AOAM533zPAOCh9O5T70rmqZA9opE0BjCDZxblhpRgnOlqeFXeUCh1KBa
        ZYVQLt9r+8SmxpYqxPgbnmY=
X-Google-Smtp-Source: ABdhPJwbuUbGXm01c54qPcEJaJWwHBAtthhYKl/qC5Dq5fmWMZtf+rrnJZ29JSqA4wwniCL3ChsA7g==
X-Received: by 2002:a62:6842:: with SMTP id d63mr3551252pfc.82.1596636907357;
        Wed, 05 Aug 2020 07:15:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id g12sm3197172pjd.6.2020.08.05.07.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:15:06 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 8/9] Introduce kvm module parameter global_tdp to turn on the direct build EPT mode
Date:   Wed,  5 Aug 2020 22:15:56 +0800
Message-Id: <20200805141556.9430-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
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
index 7063b9d2cac0..a8c219fb33f5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1368,6 +1368,8 @@ extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
 
+extern bool global_tdp;
+
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
  *			userspace I/O) to indicate that the emulation context
@@ -1698,6 +1700,8 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #endif
 }
 
+inline bool boot_cpu_is_amd(void);
+
 #define put_smstate(type, buf, offset, val)                      \
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 485f7287aad2..f963a3b0500f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4630,7 +4630,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 }
 EXPORT_SYMBOL_GPL(reset_shadow_zero_bits_mask);
 
-static inline bool boot_cpu_is_amd(void)
+inline bool boot_cpu_is_amd(void)
 {
 	WARN_ON_ONCE(!tdp_enabled);
 	return shadow_x_mask == 0;
@@ -6471,6 +6471,9 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
 	kvm_pfn_t pfn;
 	int host_level;
 
+	if (!global_tdp)
+		return 0;
+
 	if (!kvm->arch.global_root_hpa) {
 		struct page *page;
 		WARN_ON(!tdp_enabled);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37e11b3588b5..abe838240084 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -162,6 +162,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+bool __read_mostly global_tdp;
+module_param_named(global_tdp, global_tdp, bool, S_IRUGO);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -3403,7 +3406,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -9675,6 +9681,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
+	if ((tdp_enabled == false) || boot_cpu_is_amd())
+		global_tdp = 0;
+
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-- 
2.17.1

