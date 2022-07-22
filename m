Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA857EA20
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiGVXC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiGVXCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:02:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FF587C21
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e21-20020aa78c55000000b00528c6cca624so2402353pfd.3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PKYAm/0aV3bhWo2rNA4kUnanHN9tpgw1D3TRbQRB/9o=;
        b=lRI5e0Ox5A5pJzsc8ceHqeriWk/S0n2o4DRYoy+eweCV0NrV2mSJaSneriBwNeCzSl
         EjNuI6u8Lw0Mg0RRaQbudLHcxikI0qQXRNUZFovHPMTpsiTrd6OgMcQEwuhNQRa9pEJN
         Dw4byaxIfon3dRpoBFL9/ccN8ggLzT235AHW65DMUaTfodhQcOltUccfwqJhjpTE03VG
         B4q+0lnOiALPxjpgtnBUhGwOSn2u66VCnbw/quRPfH74J04tQk8H1W3qBxsNynCXNw7s
         Ftjgj57ImdzNUgt/DUFUhV92yk2DtAV4LuhOx6dSSlWkSn+hZnHA9h5sy9BnuKPHgo7O
         vYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PKYAm/0aV3bhWo2rNA4kUnanHN9tpgw1D3TRbQRB/9o=;
        b=n3k/Mnz07vKBsrtjtzEUte4V0Lw2JDIfSR61/Ry+W6g+ApaLMulFY7omddcKsC+uRU
         e0oiLtJK3xI0xPVi7sPFMAecwdXlgzXt/SVU4FnpvYvC/2ONpAmLxNDjOSjkTr6h4baa
         udNMXTC+0Kn9MWjS8omjryoPqh1QpM6ugrJkssFCf37abgaJG7ik1nev/y2fkcotXKEs
         QyFWaF8rJACWv8uAGEjtn9b/NgpFB3sXN7Ua+jj9E79baAcX6Ru+8q0GoAzvyd5in9NS
         Bsd9bx9iJWBTYJzo8RNzH7rUOfMfasEZ+kRI9NEwgTyGuyA5nZi1U7R/B6ncCoJJfQtR
         vqTw==
X-Gm-Message-State: AJIora/7HOds5C6l/YQ9of08IBcfg6LIGf4MxcXY/tkbTQGXzmNb505e
        FQ3Dq7ImdqHe+wDngYZaqhEiMYNL3Gs=
X-Google-Smtp-Source: AGRyM1twrLBpGr4Rz+bwCq0sU1u6HXMQYaN9Ydo7etaUWvEkYD6SXH+Pv7yJf/rikB6rcJ4tVIjl8xKA39o=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:a17:903:11c9:b0:16b:8293:c599 with SMTP id
 q9-20020a17090311c900b0016b8293c599mr1695061plh.136.1658530973354; Fri, 22
 Jul 2022 16:02:53 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:38 -0700
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
Message-Id: <20220722230241.1944655-3-avagin@google.com>
Mime-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 2/5] kvm/x86: add controls to enable/disable paravirtualized
 system calls
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
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

The following change will add a new hypercall to execute host syscalls.

This hypercall is helpful for user-mode kernel solutions such as gVisor
that needs to manage multiple address spaces.

The new hypercall is a backdoor for most KVM users, so it must be
disabled by default. This change introduces a new capability that has to
be set to enable the hypercall. There is another standard way to allow
hypercalls by using KVM_SET_CPUID2. It isn't suitable in this case
because one of the common ways of using it is to request all available
features (KVM_GET_SUPPORTED_CPUID) and let them all together. In this
case, it is a hard requirement that the new hypercall can be enabled
only intentionally.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  3 +++
 arch/x86/kvm/cpuid.c                 | 25 +++++++++++++++++++++++++
 arch/x86/kvm/cpuid.h                 |  8 +++++++-
 arch/x86/kvm/x86.c                   |  4 ++++
 include/uapi/linux/kvm.h             |  1 +
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..84ad13ffc23c 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -37,6 +37,9 @@
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
 
+/* Features that are not controlled by KVM_SET_CPUID2. */
+#define KVM_FEATURE_PV_HOST_SYSCALL	31
+
 #define KVM_HINTS_REALTIME      0
 
 /* The last 8 bits are used to indicate how to interpret the flags field
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index de6d44e07e34..4fdfe9409506 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -104,6 +104,10 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
+	best = cpuid_entry2_find(entries, nent, KVM_CPUID_FEATURES, 0);
+	if (best && (best->eax & (1<<KVM_FEATURE_PV_HOST_SYSCALL)))
+		return -EINVAL;
+
 	/*
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
@@ -273,6 +277,27 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	}
 }
 
+int kvm_vcpu_pv_set_host_syscall(struct kvm_vcpu *vcpu, bool set)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	if (!vcpu->arch.pv_cpuid.enforce)
+		return -EINVAL;
+
+	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	if (!best)
+		return -EINVAL;
+
+	if (set)
+		best->eax |= 1 << KVM_FEATURE_PV_HOST_SYSCALL;
+	else
+		best->eax &= ~(1 << KVM_FEATURE_PV_HOST_SYSCALL);
+
+	kvm_update_pv_runtime(vcpu);
+
+	return 0;
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8a770b481d9d..80721093b82b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -219,10 +219,16 @@ static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
 static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 					 unsigned int kvm_feature)
 {
-	if (!vcpu->arch.pv_cpuid.enforce)
+	if (!vcpu->arch.pv_cpuid.enforce) {
+		if (kvm_feature == KVM_FEATURE_PV_HOST_SYSCALL)
+			return false;
+
 		return true;
+	}
 
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+int kvm_vcpu_pv_set_host_syscall(struct kvm_vcpu *vcpu, bool set);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5fa335a4ea7..19e634768161 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5306,6 +5306,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			kvm_update_pv_runtime(vcpu);
 
 		return 0;
+
+	case KVM_CAP_PV_HOST_SYSCALL:
+		return kvm_vcpu_pv_set_host_syscall(vcpu, cap->args[0]);
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 860f867c50c0..89ed59d13877 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_PV_HOST_SYSCALL 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.37.1.359.gd136c6c3e2-goog

