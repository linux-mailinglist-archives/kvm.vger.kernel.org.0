Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEE553D48E
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350318AbiFDBXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350179AbiFDBXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC3927FE8
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id l2-20020a17090a72c200b001e325e14e3eso4856370pjk.7
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cK8PvxeAQtBNlCjWzChNwkY/gHGJXYhTwM/r3UTKrIg=;
        b=rrNnHpNRfBTyIizsoYBcvfK0rN/c+8gjsJTVPdRJrWlTLJva2ynOjR91LoW3xp4Dhu
         MAyuMIG/9rY6lXHdBe0y2QZbztMbkwZPLqgziWsCjSCUu30D7537YoJZiSDrpc0PuEnd
         jx0ogORprrpM8+JVuTOx72oikRKxJFgwRtdO5qjFcIkDIER6ZfAhlkM9oNtQxKFp0XCG
         LjO0TDOvJEo+oYI98XKUZpRb4WhpU8bLBvzxXoK5IXvL0pqjR7EHZ3HLUYjaJVGohufC
         cUyl8UgW6lFl7a5XTBOBRYKhVz1LR977DCAuonSULBmQmFPWiIHPS9+zI7remx5dCm2n
         ECrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cK8PvxeAQtBNlCjWzChNwkY/gHGJXYhTwM/r3UTKrIg=;
        b=cJZsPJ28jSEw0OUMWnganWOHGICtWLnabEbsXCIQ1ub8kvqybCa75W0hi3L0jAJ15g
         FlbuBnZx/o9IJGQMrphx9IR0e3nDiCpUcXX6NOnPSRxyHi4a7dJ8iXonZ721d1iYRbo0
         62UkFJ4x1bewRP4d+HQ1HP0M8L6al+8PoYuuXeRzIAtsTPwwmaWnnFf/jTcd7uIMuuhg
         faZAnhDeyziFLQ5FqqNbAIXMw13mlMzTysB81tP8Q5v+6CS8TIDCMXSNidPFYtDwE+Bc
         p52S68c/yfUc1A03psxxXey0H6H8NUBzxb8ER67RMUB5i1OLzilX6Jjdezykant+2fRv
         IKCQ==
X-Gm-Message-State: AOAM5322037XpzXLViHmW7l9y21/4sp7zaTPdxyu+2vcsQUqy5nv2P16
        txDxOoMV3eTHBs2a1q5J6pK4X352E/Y=
X-Google-Smtp-Source: ABdhPJxxrC8VUtRL8FfqCb2fIzn8BQ4nfF5atsWQCs5HnznvGnEQTRG+BcHWT9w7RqcOdLb55/ljkjFh/mU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr4683pje.0.1654305715304; Fri, 03 Jun
 2022 18:21:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:47 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-32-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 31/42] KVM: selftests: Set input function/index in raw CPUID helper(s)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the function/index for CPUID in the helper instead of relying on the
caller to do so.  In addition to reducing the risk of consuming an
uninitialized ECX, having the function/index embedded in the call makes
it easier to understand what is being checked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 16 +++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      | 13 ++++---------
 tools/testing/selftests/kvm/x86_64/amx_test.c | 19 ++++---------------
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 11 +++++------
 4 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6c14b34014c2..eb4730bf4e77 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -402,10 +402,13 @@ static inline void outl(uint16_t port, uint32_t value)
 	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
 }
 
-static inline void cpuid(uint32_t *eax, uint32_t *ebx,
-			 uint32_t *ecx, uint32_t *edx)
+static inline void __cpuid(uint32_t function, uint32_t index,
+			   uint32_t *eax, uint32_t *ebx,
+			   uint32_t *ecx, uint32_t *edx)
 {
-	/* ecx is often an input as well as an output. */
+	*eax = function;
+	*ecx = index;
+
 	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
@@ -415,6 +418,13 @@ static inline void cpuid(uint32_t *eax, uint32_t *ebx,
 	    : "memory");
 }
 
+static inline void cpuid(uint32_t function,
+			 uint32_t *eax, uint32_t *ebx,
+			 uint32_t *ecx, uint32_t *edx)
+{
+	return __cpuid(function, 0, eax, ebx, ecx, edx);
+}
+
 #define SET_XMM(__var, __xmm) \
 	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 41cc320d3e34..1d92a1d9a03f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1285,9 +1285,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	/* Before family 17h, the HyperTransport area is just below 1T.  */
 	ht_gfn = (1 << 28) - num_ht_pages;
-	eax = 1;
-	ecx = 0;
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(1, &eax, &ebx, &ecx, &edx);
 	if (x86_family(eax) < 0x17)
 		goto done;
 
@@ -1296,18 +1294,15 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 	 * reduced due to SME by bits 11:6 of CPUID[0x8000001f].EBX.  Use
 	 * the old conservative value if MAXPHYADDR is not enumerated.
 	 */
-	eax = 0x80000000;
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
 	max_ext_leaf = eax;
 	if (max_ext_leaf < 0x80000008)
 		goto done;
 
-	eax = 0x80000008;
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(0x80000008, &eax, &ebx, &ecx, &edx);
 	max_pfn = (1ULL << ((eax & 0xff) - vm->page_shift)) - 1;
 	if (max_ext_leaf >= 0x8000001f) {
-		eax = 0x8000001f;
-		cpuid(&eax, &ebx, &ecx, &edx);
+		cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 		max_pfn >>= (ebx >> 6) & 0x3f;
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bcf535646321..866a42d07d75 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -122,9 +122,7 @@ static inline void check_cpuid_xsave(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
-	eax = 1;
-	ecx = 0;
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(1, &eax, &ebx, &ecx, &edx);
 	if (!(ecx & CPUID_XSAVE))
 		GUEST_ASSERT(!"cpuid: no CPU xsave support!");
 	if (!(ecx & CPUID_OSXSAVE))
@@ -140,10 +138,7 @@ static bool enum_xtile_config(void)
 {
 	u32 eax, ebx, ecx, edx;
 
-	eax = TILE_CPUID;
-	ecx = TILE_PALETTE_CPUID_SUBLEAVE;
-
-	cpuid(&eax, &ebx, &ecx, &edx);
+	__cpuid(TILE_CPUID, TILE_PALETTE_CPUID_SUBLEAVE, &eax, &ebx, &ecx, &edx);
 	if (!eax || !ebx || !ecx)
 		return false;
 
@@ -165,10 +160,7 @@ static bool enum_xsave_tile(void)
 {
 	u32 eax, ebx, ecx, edx;
 
-	eax = XSTATE_CPUID;
-	ecx = XFEATURE_XTILEDATA;
-
-	cpuid(&eax, &ebx, &ecx, &edx);
+	__cpuid(XSTATE_CPUID, XFEATURE_XTILEDATA, &eax, &ebx, &ecx, &edx);
 	if (!eax || !ebx)
 		return false;
 
@@ -183,10 +175,7 @@ static bool check_xsave_size(void)
 	u32 eax, ebx, ecx, edx;
 	bool valid = false;
 
-	eax = XSTATE_CPUID;
-	ecx = XSTATE_USER_STATE_SUBLEAVE;
-
-	cpuid(&eax, &ebx, &ecx, &edx);
+	__cpuid(XSTATE_CPUID, XSTATE_USER_STATE_SUBLEAVE, &eax, &ebx, &ecx, &edx);
 	if (ebx && ebx <= XSAVE_SIZE)
 		valid = true;
 
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 2b8ac307da64..a4c4a5c5762a 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -31,10 +31,9 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 	u32 eax, ebx, ecx, edx;
 
 	for (i = 0; i < guest_cpuid->nent; i++) {
-		eax = guest_cpuid->entries[i].function;
-		ecx = guest_cpuid->entries[i].index;
-
-		cpuid(&eax, &ebx, &ecx, &edx);
+		__cpuid(guest_cpuid->entries[i].function,
+			guest_cpuid->entries[i].index,
+			&eax, &ebx, &ecx, &edx);
 
 		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
 			     ebx == guest_cpuid->entries[i].ebx &&
@@ -46,9 +45,9 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 
 static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
 {
-	u32 eax = 0x40000000, ebx, ecx = 0, edx;
+	u32 eax, ebx, ecx, edx;
 
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(0x40000000, &eax, &ebx, &ecx, &edx);
 
 	GUEST_ASSERT(eax == 0x40000001);
 }
-- 
2.36.1.255.ge46751e96f-goog

