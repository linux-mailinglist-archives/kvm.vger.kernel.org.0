Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA93F91A0
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbhH0A7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 20:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243999AbhH0A6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:58:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E5BC0613A3
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q13-20020a25820d000000b0059a84a55d89so4874970ybk.23
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=URtT+dB+jST+gZg2WrKoRMxEnnvOGJ2KoTQrrGCl7oY=;
        b=QMyMyW8S+UdMR+QA1dMUWcj1nvV4awF9BhU25l5pymBfzXZEUMcpGdZL0BxhsVUTrH
         wwnMpXfbLu54yCHCCtgV2+evWSEDbv+dXSyufVgmFg3L3pcb8KjT8SWqp9r8G6c8kSxp
         pLoenRdXaSghZld5WzFyBNBLJKTOW1nT55C2Sva+2Zv2/tE3SOwtK+UMfx8kFjDDzDJK
         t9N4Z7NvWPgoYl3X+kWUq4jXGlgLXhzG/pWtR82HNRigu9ZhzdlUBMpgi1gtDf4WrxBF
         kafWIVt0+yu4zS7kftTHzy2ydn7SjePf/9Jkus2cGK2V680+vkX5sdV4/U0/KQUCmBkV
         IaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=URtT+dB+jST+gZg2WrKoRMxEnnvOGJ2KoTQrrGCl7oY=;
        b=SsOhWII4FJjMfNbkneSCVCQicnadeYcOO9K9iek/9YlgF8A3MdO4F9BRBF5Vt/M83V
         TjW0zyhdv84oe0nJNDU2pB5UpaKnGSFfRx6An8rw310n3P6uRY2cAU+RbG3XKJmj4gsA
         4BdLsFb7kVtbprE332fm5K29rsly8rDM9cbYIqxmlOsDpJOQntRDbbkr0PvvbM0uD6D6
         PvbhYqfpM9N5DpEpKPEROuHuAGbPDw1EkrrLYwbCAIXtMn1PNm1C4qu0ZkUv5YqFqhXg
         jOOyDvw4+M5G5gpEeXUSlhejJwdvk3w8tFw5qx6P9hbqQ3eFcDt0SDrgrfL+4GpdwPUp
         AZkw==
X-Gm-Message-State: AOAM533dZPHyHHRpKag0JznkTarJGfY56xKEjAr79g0A7CVNkRpWOtZR
        LEgGFJ4mwFtHp87/ny6mgtbbCGI1E2E=
X-Google-Smtp-Source: ABdhPJx9DS89m5L71YrEHQukjJpAjWUrBsdJUeHGSEcBnJIrikQ0Z8d/TNTUFittLfnOlgJyGEhI291z6yw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:afcd:: with SMTP id d13mr1863343ybj.504.1630025869822;
 Thu, 26 Aug 2021 17:57:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:12 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 09/15] KVM: arm64: Register/unregister perf callbacks at vcpu load/put
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register/unregister perf callbacks at vcpu_load()/vcpu_put() instead of
keeping the callbacks registered for all eternity after loading KVM.
This will allow future cleanups and optimizations as the registration
of the callbacks signifies "in guest".  This will also allow moving the
callbacks into common KVM as they arm64 and x86 now have semantically
identical callback implementations.

Note, KVM could likely be more precise in its registration, but that's a
cleanup for the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++-
 arch/arm64/kvm/arm.c              |  5 ++++-
 arch/arm64/kvm/perf.c             | 36 ++++++++++++++-----------------
 3 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ed940aec89e0..007c38d77fd9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -671,7 +671,17 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
 void kvm_perf_init(void);
-void kvm_perf_teardown(void);
+
+#ifdef CONFIG_PERF_EVENTS
+void kvm_register_perf_callbacks(void);
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	__perf_unregister_guest_info_callbacks();
+}
+#else
+static inline void kvm_register_perf_callbacks(void) {}
+static inline void kvm_unregister_perf_callbacks(void) {}
+#endif
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..ec386971030d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -429,10 +429,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	kvm_register_perf_callbacks();
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_unregister_perf_callbacks();
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
@@ -2155,7 +2158,7 @@ int kvm_arch_init(void *opaque)
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_perf_teardown();
+
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 039fe59399a2..2556b0a3b096 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,33 +13,30 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
+#ifdef CONFIG_PERF_EVENTS
 static int kvm_is_in_guest(void)
 {
-        return kvm_get_running_vcpu() != NULL;
+	return true;
 }
 
 static int kvm_is_user_mode(void)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	vcpu = kvm_get_running_vcpu();
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	if (vcpu)
-		return !vcpu_mode_priv(vcpu);
-
-	return 0;
+	return !vcpu_mode_priv(vcpu);
 }
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	vcpu = kvm_get_running_vcpu();
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	if (vcpu)
-		return *vcpu_pc(vcpu);
-
-	return 0;
+	return *vcpu_pc(vcpu);
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
@@ -48,15 +45,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.get_guest_ip	= kvm_get_guest_ip,
 };
 
+void kvm_register_perf_callbacks(void)
+{
+	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+#endif /* CONFIG_PERF_EVENTS*/
+
 void kvm_perf_init(void)
 {
 	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
 		static_branch_enable(&kvm_arm_pmu_available);
-
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-}
-
-void kvm_perf_teardown(void)
-{
-	perf_unregister_guest_info_callbacks();
 }
-- 
2.33.0.259.gc128427fd7-goog

