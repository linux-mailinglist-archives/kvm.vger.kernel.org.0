Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130BC54BB3C
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357716AbiFNUJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357781AbiFNUIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020C34EF69
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 190-20020a6306c7000000b004089a651e4eso2362351pgg.20
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fsYs/Bc5rpxse3GLtefGgeT1BXM2hAUZSMcPuFOqZt8=;
        b=UxPNtGzjOcVb4Ln31qKWgNs8Puid2D2l/L8wZdNe8OuZX3epfyZRFQ+nP0x/VYJvSn
         /z2L00Lw2JpwQgHOxM98Ki8H52lWGYrKVJFMO/HPXQz1QmrpMCRlFfqT3gZYu7BTcNMk
         rm+y3KtfVoIdG4NkOgpb4BaZMQJKtiKMERIOryj/lsNUxwvGqBAkb1SNyh18KVpcEqzO
         AXtmOwDRr4nazbksGrnnTYlirI/AATF0b0U/Jl/cSWPLNbd4w3SnJMDN28lV3+AiTwP+
         6NU/Zs3lwCma9KuyKhGR0/uniP3lDIkCilShywwvMUwhZQLptXIoSsn7x/FYyeveTVwk
         GkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fsYs/Bc5rpxse3GLtefGgeT1BXM2hAUZSMcPuFOqZt8=;
        b=EPqAFsCXPPssAz2qszcbE71lsV3Bv6uPiwjCvBnjOPmNkfyKDpLyMPKREh2Rg7NjSd
         ODhkURMu+C9M5YuGZljoValpdJn34zT49jOHBIsl+7Qy7lRPZTM1SXH4CnPnCHtD6IMC
         KSjVyU596BN9lsKF10RGF4C3K/mkMUZXppnf7tl9bl2ieHg2QhnbVfNSefeeY5fGH9DP
         aXD88qgKlYRr6QvmKEryyghtZRVELRmMB7rRRtmuSbgzVFGaOvP197hNGaz+40HStKRH
         WHSTWAebLUExcmnkVXn6wPpdisqfSDJOF4IRzysUZxEAV3Tf/easf4C4J+k9vpDoHDS9
         NNfw==
X-Gm-Message-State: AJIora8YA+kPmKDns6APLBZDSzAmUE6IaGf4YoYAy5ySuoy9dtvqGwRT
        1fnSPFCP1Uadln3I3J5Cehr6h49GWak=
X-Google-Smtp-Source: AGRyM1t5wcpUgvUC0oVchaUGPZJJDC1R53MEqhqZYm/H7uxKLJ6kCZV9nvkk3k8jPOagL2eHu/iHr5ZS0hQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr192604pje.0.1655237288184; Tue, 14 Jun
 2022 13:08:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:56 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-32-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 31/42] KVM: selftests: Set input function/index in raw
 CPUID helper(s)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 617b437ce0f9..ed148607a813 100644
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
index eb73c690edd9..7bce93760cad 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1284,9 +1284,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	/* Before family 17h, the HyperTransport area is just below 1T.  */
 	ht_gfn = (1 << 28) - num_ht_pages;
-	eax = 1;
-	ecx = 0;
-	cpuid(&eax, &ebx, &ecx, &edx);
+	cpuid(1, &eax, &ebx, &ecx, &edx);
 	if (x86_family(eax) < 0x17)
 		goto done;
 
@@ -1295,18 +1293,15 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
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
2.36.1.476.g0c4daa206d-goog

