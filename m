Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF5E6D71AA
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbjDEApz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbjDEApn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1E34200
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-546422bd3ceso165437047b3.21
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bZtl93ldMr9OOkgRDj/Fj0OOXpGgF15cFMR2dIgZs2w=;
        b=hzlhVYMhCOCJy1ylKcFVYwb8V7aQ32ComHcrKgecVtklfF+xeCqWCl7zkLdMj/dpKo
         B/dYa0eJGXLuFhItVzhTkf5ZJeRKx623SLbhX7OsAh7JJe/D7ljkU3cCtQCn4VcGks3M
         Kv/+S6Uuf9z8OftkfWwAgQAFdK9IneXHKeOG6CtUqzuo0ifOWpqdeenVCIC6PyQ5+inu
         gRwNb9oUdgSKVUW1STe3Xgism2DNc4clF8vZ854ex4Sg5MYgwPzETW485pdeZfM5rFdi
         8DOZSBPvE9KwsXCEUUFkl+zrurn00B3N2Z3dAyBMCeH3wWROLnmQqiaZ5QTB70kmSKoq
         yeUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZtl93ldMr9OOkgRDj/Fj0OOXpGgF15cFMR2dIgZs2w=;
        b=MTWahQiq8krE/bUzCmPEbEvKT7/7B4lp2kaURe1/tJ8VNnk9zcCpUcqLd3N6pN9lh/
         1F5r4rYJ9XRjzwjIyOWwIsoyZ+2fVB7gt5aYfs1r0rr2g4kfGpiszQZr+9kDuRNBEdgS
         yIRs3BUH66xHEXwiUUjbl4aoxExMYpbTgwKSama95s1FDV//58v3wWFd7S4vFfKNrnEZ
         aR9HvxEXH++rUDOP/JAsn3+Ae86UW62zkXOQCEY+3vq+ddRVLInJgFFhYmJTaLpnP4OD
         FJ4/9oaBnmXluhGUb9RKUOJ9bZs6AbD2Vyr8dUC5RsNLOOufPLxfLyq1CrQdjk+5h+mO
         uF3A==
X-Gm-Message-State: AAQBX9f+BTX3inYeAmxkEMahvaQKabsRglvmegk9HuUeuhQVFTO8rYt7
        GKd0FapaFwok8Yqym3GUOYdi6YZtwiY=
X-Google-Smtp-Source: AKy350boLu1qHyH7zQNuSVx+g5/tgWpxUnZCAAD6lFExfWA4pZjGLHNb3iUDeGNHAcA7mCsbFBGntErsF3Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b627:0:b0:544:d154:fd3c with SMTP id
 u39-20020a81b627000000b00544d154fd3cmr2596017ywh.1.1680655532028; Tue, 04 Apr
 2023 17:45:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:19 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-6-seanjc@google.com>
Subject: [PATCH v4 5/6] KVM: selftests: Add all known XFEATURE masks to common code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

From: Aaron Lewis <aaronlewis@google.com>

Add all known XFEATURE masks to processor.h to make them more broadly
available in KVM selftests.  Relocate and clean up the exiting AMX (XTILE)
defines in processor.h, e.g. drop the intermediate define and use BIT_ULL.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 25 ++++++++----
 tools/testing/selftests/kvm/x86_64/amx_test.c | 38 ++++++++-----------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 41d798375570..187309f3e7e9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -60,6 +60,23 @@ struct xstate {
 	u8				extended_state_area[0];
 } __attribute__ ((packed, aligned (64)));
 
+#define XFEATURE_MASK_FP		BIT_ULL(0)
+#define XFEATURE_MASK_SSE		BIT_ULL(1)
+#define XFEATURE_MASK_YMM		BIT_ULL(2)
+#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
+#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
+#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
+#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
+#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
+#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
+#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+
+#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
+					 XFEATURE_MASK_ZMM_Hi256 | \
+					 XFEATURE_MASK_Hi16_ZMM)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA | \
+					 XFEATURE_MASK_XTILE_CFG)
+
 /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
 enum cpuid_output_regs {
 	KVM_CPUID_EAX,
@@ -1138,14 +1155,6 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
-#define XSTATE_XTILE_CFG_BIT		17
-#define XSTATE_XTILE_DATA_BIT		18
-
-#define XSTATE_XTILE_CFG_MASK		(1ULL << XSTATE_XTILE_CFG_BIT)
-#define XSTATE_XTILE_DATA_MASK		(1ULL << XSTATE_XTILE_DATA_BIT)
-#define XFEATURE_XTILE_MASK		(XSTATE_XTILE_CFG_MASK | \
-					XSTATE_XTILE_DATA_MASK)
-
 #define PFERR_PRESENT_BIT 0
 #define PFERR_WRITE_BIT 1
 #define PFERR_USER_BIT 2
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index a0f74f5121a6..11329e5ff945 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -34,12 +34,6 @@
 #define MAX_TILES			16
 #define RESERVED_BYTES			14
 
-#define XFEATURE_XTILECFG		17
-#define XFEATURE_XTILEDATA		18
-#define XFEATURE_MASK_XTILECFG		(1 << XFEATURE_XTILECFG)
-#define XFEATURE_MASK_XTILEDATA		(1 << XFEATURE_XTILEDATA)
-#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | XFEATURE_MASK_XTILEDATA)
-
 #define XSAVE_HDR_OFFSET		512
 
 struct tile_config {
@@ -172,25 +166,25 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
 	 */
-	xstate->header.xstate_bv = XFEATURE_MASK_XTILEDATA;
-	__xsavec(xstate, XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILEDATA));
-	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILEDATA);
+	xstate->header.xstate_bv = XFEATURE_MASK_XTILE_DATA;
+	__xsavec(xstate, XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
+	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA);
 
 	/* xfd=0x40000, disable amx tiledata */
-	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
 	/*
 	 * XTILEDATA is cleared in xstate_bv but set in xcomp_bv, this property
 	 * remains the same even when amx tiledata is disabled by IA32_XFD.
 	 */
-	xstate->header.xstate_bv = XFEATURE_MASK_XTILEDATA;
-	__xsavec(xstate, XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILEDATA));
-	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILEDATA));
+	xstate->header.xstate_bv = XFEATURE_MASK_XTILE_DATA;
+	__xsavec(xstate, XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
+	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
 	GUEST_SYNC(6);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
@@ -202,14 +196,14 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 
 void guest_nm_handler(struct ex_regs *regs)
 {
-	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
+	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
 	GUEST_SYNC(7);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_SYNC(8);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
@@ -233,7 +227,7 @@ int main(int argc, char *argv[])
 	 * Note, all off-by-default features must be enabled before anything
 	 * caches KVM_GET_SUPPORTED_CPUID, e.g. before using kvm_cpu_has().
 	 */
-	vm_xsave_require_permission(XFEATURE_MASK_XTILEDATA);
+	vm_xsave_require_permission(XFEATURE_MASK_XTILE_DATA);
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
-- 
2.40.0.348.gf938b09366-goog

