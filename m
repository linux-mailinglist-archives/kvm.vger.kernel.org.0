Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB88D3FA272
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhH1AiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhH1Ahz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 20:37:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21990C0611C6
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q80-20020a25d953000000b0059a45a5f834so8330996ybg.22
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8sgYBBoPv+2JwgnSGYhHNhVlG76cGIWAxgCtg/V/coQ=;
        b=H5N4ryA5hWTUAeyuBk5XizZ7N0trA7JIKj0csm/SnRrBSvZI4fvOfdylQj2HI9uGWb
         FlgA7RqivFC20QT3Fgdghq9BURCUg84MC8EYToh6OEPEn485kgBO2eBqSmuI+BgUif0L
         X0t7BSgnBR2SJjDLf8mzg4n0cr87GdYxedcIPWDQMs1CgXbr3dAKzNI+Ec51COkbfFee
         M/XLorZxISoZWBr6d43w4+OCYBUTM9KVOhPDBEHcmSrOb67+e2vyyj7m1qI8rapB1/sj
         sUKaaIlY0oFXPavLrApCVJnrUrYLouBq/sRrV1srDbUivxaMXuuYz/XSg705ezUGG1EI
         utYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8sgYBBoPv+2JwgnSGYhHNhVlG76cGIWAxgCtg/V/coQ=;
        b=hvRrhjJtT58kbJ2Y5YapGLLAH3v4ndf5Gjqb7sXUlwsXLSHzyf9Lo3Dk1BpGBnN4se
         bGYil332b6mtHbMwL5qhl1X9mbbFGrT/TdeF+NoPGbcdMSmOEqRIK2FqD84uvpJaRPS6
         t5uXyf0BcgF2guPY7xyl5fjSx2BpAX3/FoKvGfUlujCrscCGO+DSNP0KTaZxav6wezDw
         5AjiUp6zNDRJb26mLri+coeZwKmby6WM9uAUQyNiL157So1ejkPazKaWo0RyrgHY/aUd
         VKNmshVwux97z4sgz5l6DTh9+1gIPAilMpwghnaLcS2TIH+99dh9RB3GOac/JjyYvV6s
         LI6Q==
X-Gm-Message-State: AOAM530KU9It3KHL33UW5Ri2dhbFeOJHG52yna+kUakc2P3p9UnU21/p
        aatUPuw13ctg0Q38Mx7CJQY0rTRt+98=
X-Google-Smtp-Source: ABdhPJzymXWQza3vAsItF0sAPdCE8iLSMVzwPpM+LtdWMA9TXI8otz549S9ZetrsOJXPExeTt/x3hD0mXJY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a25:bb48:: with SMTP id b8mr7895492ybk.275.1630111012286;
 Fri, 27 Aug 2021 17:36:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Aug 2021 17:35:57 -0700
In-Reply-To: <20210828003558.713983-1-seanjc@google.com>
Message-Id: <20210828003558.713983-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210828003558.713983-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 12/13] KVM: arm64: Convert to the generic perf callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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

Drop arm64's version of the callbacks in favor of the callbacks provided
by generic KVM, which are semantically identical.  Implement the "get ip"
hook as needed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++++
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/perf.c             | 34 ++-----------------------------
 3 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ed940aec89e0..73dc402ded1f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -673,6 +673,18 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 void kvm_perf_init(void);
 void kvm_perf_teardown(void);
 
+#ifdef CONFIG_PERF_EVENTS
+#define __KVM_WANT_PERF_CALLBACKS
+static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
+{
+	/* Any callback while a vCPU is loaded is considered to be in guest. */
+	return !!vcpu;
+}
+#else
+static inline void kvm_register_perf_callbacks(void) {}
+static inline void kvm_unregister_perf_callbacks(void) {}
+#endif
+
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..2b542fdc237e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -500,6 +500,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu_mode_priv(vcpu);
 }
 
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
+{
+	return *vcpu_pc(vcpu);
+}
+
 /* Just ensure a guest exit from a particular CPU */
 static void exit_vm_noop(void *info)
 {
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 893de1a51fea..0b902e0d5b5d 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,45 +13,15 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-static unsigned int kvm_guest_state(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-	unsigned int state;
-
-	if (!vcpu)
-		return 0;
-
-	state = PERF_GUEST_ACTIVE;
-	if (!vcpu_mode_priv(vcpu))
-		state |= PERF_GUEST_USER;
-
-	return state;
-}
-
-static unsigned long kvm_get_guest_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return *vcpu_pc(vcpu);
-}
-
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.state		= kvm_guest_state,
-	.get_ip		= kvm_get_guest_ip,
-};
-
 void kvm_perf_init(void)
 {
 	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
 		static_branch_enable(&kvm_arm_pmu_available);
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+	kvm_register_perf_callbacks(NULL);
 }
 
 void kvm_perf_teardown(void)
 {
-	perf_unregister_guest_info_callbacks();
+	kvm_unregister_perf_callbacks();
 }
-- 
2.33.0.259.gc128427fd7-goog

