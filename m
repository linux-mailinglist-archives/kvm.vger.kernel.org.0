Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B45771A6A
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 08:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjHGGaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 02:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjHGG3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 02:29:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363D4172C
        for <kvm@vger.kernel.org>; Sun,  6 Aug 2023 23:29:33 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686f8614ce5so4175564b3a.3
        for <kvm@vger.kernel.org>; Sun, 06 Aug 2023 23:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1691389772; x=1691994572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2KhJcMMHF/QGvcv4V+SvNCxHUnjoV6Ng8+aFfn5AdYA=;
        b=fs7s2Xlp88INcWS7tNQLgGN60cO0nAz+utJVEUemGul8/xSDJ21UtEgMHzUvF5vfwN
         /MDRVb05BOtxTyn1Ffk6dGmYT0bCnCBkqcFGucWJ79bMlE0gv8fBXdqnYmfFWbGA9Gvx
         6GVB3cgElVZYABWqEIW2vs6WaapSGgNOPq/uNw2761ZEIZy2YBWA28cb6uYND80TRlfj
         YcKL2QBM/QagmQnUKlwCjBehlB9fK5uTr2C1FC+LqDEAjclzUUsc4q4ZO98nQlfjpv0x
         63zbbkFZRTsyCLlpuKt3tHEw0Khdy2/tfhu9kZb9Hx4nyXK2lG2Ih7mEjN8mVOWB/pXI
         t0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691389772; x=1691994572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2KhJcMMHF/QGvcv4V+SvNCxHUnjoV6Ng8+aFfn5AdYA=;
        b=Nqu4eKz5zzj0ry/+PCTOW3zuF7YQyeSBgqvdej1WWLdQU1KmNu/gCVzXSwHddZbRt5
         /H6DZUvYmSE1IZoNpYsnABt000TImgCD3x7/vEiYYkQr4ZwxwF8qgRQPHMm1nVu0wBPE
         lnW7ggn1iu/Yi0WtJ7yndp/bH4WR3G84GRWypQVgteCt+kL3WbvlaPKheMv1v6RwK+Je
         ZXCqfQqjJG3clAvBX78acv7G9dXe771SUlcjDehY3BQ/ONHYjO4BQYIyLs0QHFiH/ohK
         psh3yxW5lgvXmWIfKTOgyS0H5D767EiYVeqdqxXfnaxZ3yDzMDIy1J/wDiyYlW4RmecW
         ExVQ==
X-Gm-Message-State: AOJu0YyMGWPub1CKLa9gshzHqrup9WqLy/LlbZuHoEI9XfXR0N1BMpIt
        kyFIip62A/VyAu5e1ig5tD1tR6MnJbvbAx1JGI9eZA==
X-Google-Smtp-Source: AGHT+IEAuY8XGTkyoOcnJC0CLiGG976Ootrt5rrvsyVIzma2je36sHWbmaa2fVHPyHTShPNI42VHsg==
X-Received: by 2002:a05:6a20:244b:b0:140:3554:3f44 with SMTP id t11-20020a056a20244b00b0014035543f44mr8699412pzc.22.1691389772644;
        Sun, 06 Aug 2023 23:29:32 -0700 (PDT)
Received: from localhost.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id s8-20020aa78d48000000b0065a1b05193asm5347392pfe.185.2023.08.06.23.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 23:29:32 -0700 (PDT)
From:   Ake Koomsin <ake@igel.co.jp>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ake Koomsin <ake@igel.co.jp>
Subject: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC access from L2
Date:   Mon,  7 Aug 2023 15:26:11 +0900
Message-ID: <20230807062611.12596-1-ake@igel.co.jp>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM does not expect L1 hypervisor to allow L2 guest to access
APIC page directly when APICv is enabled. When this happens, KVM
emulates the access itself resulting in interrupt lost.

As this kind of hypervisor is rare, it is simpler to inhibit APICv upon
detecting direct APIC access from L2 to avoid unexpected interrupt lost.

Signed-off-by: Ake Koomsin <ake@igel.co.jp>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/mmu/mmu.c          | 33 ++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h          |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..8764b11922a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1188,6 +1188,12 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
 	APICV_INHIBIT_REASON_APIC_BASE_MODIFIED,
 
+	/*
+	 * APICv is disabled because L1 hypervisor allows L2 guest to access
+	 * APIC directly.
+	 */
+	APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS,
+
 	/******************************************************/
 	/* INHIBITs that are relevant only to the AMD's AVIC. */
 	/******************************************************/
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..c1150ef9fce1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4293,6 +4293,30 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
+static int __kvm_faultin_pfn_guest_mode(struct kvm_vcpu *vcpu,
+					struct kvm_page_fault *fault)
+{
+	struct kvm_memory_slot *slot = fault->slot;
+
+	/* Don't expose private memslots to L2. */
+	fault->slot = NULL;
+	fault->pfn = KVM_PFN_NOSLOT;
+	fault->map_writable = false;
+
+	/*
+	 * APICv does not work when L1 hypervisor allows L2 guest to access
+	 * APIC directly. As this kind of L1 hypervisor is rare, it is simpler
+	 * to inhibit APICv when we detect direct APIC access from L2, and
+	 * fallback to emulation path to avoid interrupt lost.
+	 */
+	if (unlikely(slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
+		     kvm_apicv_activated(vcpu->kvm)))
+		kvm_set_apicv_inhibit(vcpu->kvm,
+				      APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS);
+
+	return RET_PF_CONTINUE;
+}
+
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -4307,13 +4331,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 
 	if (!kvm_is_visible_memslot(slot)) {
-		/* Don't expose private memslots to L2. */
-		if (is_guest_mode(vcpu)) {
-			fault->slot = NULL;
-			fault->pfn = KVM_PFN_NOSLOT;
-			fault->map_writable = false;
-			return RET_PF_CONTINUE;
-		}
+		if (is_guest_mode(vcpu))
+			return __kvm_faultin_pfn_guest_mode(vcpu, fault);
 		/*
 		 * If the APIC access page exists but is disabled, go directly
 		 * to emulation without caching the MMIO access or creating a
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 18af7e712a5a..8d77932ee0fb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -683,7 +683,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS)	\
 )
 
 bool avic_hardware_setup(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20..f652397c9765 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8189,7 +8189,8 @@ static void vmx_hardware_unsetup(void)
 	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED)	\
+	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
+	BIT(APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS)	\
 )
 
 static void vmx_vm_destroy(struct kvm *kvm)
-- 
2.41.0

