Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE5D5F5E12
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJFAwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJFAvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E94F390
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7-20020a25bac7000000b006bca90f4fa0so401505ybk.13
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ft+KFkM5mqo7VfAKnon3TcoqES4XGWXqzb5qqE7B/TY=;
        b=WyxJY3zCdp1FKSVdL3AXIDvui6/2CH3/nfinLpnnLsaov28EDKxX3430cl+/qG4E/5
         6el6QicwTywvVtdMSKG4JqK+I8Ze4G3vPfedjcbsp5q38C6yj9F3K0m9lFmw6d6/yih1
         6ti4vuK+3MDq0tlZttt99utBt9DvI9bhoBjtW7ZorVIixqfA1tqUhKIwyUlfBWI0HCp5
         aQuFLKjuciUgPa0L4/38Iuogx2PGKxEnAfjB92tEfsp/uCdkIUWTve9dBJmZbCUwOpb4
         hX+z3Cm5YVPfxgTN0jYrmuResxy0LpSDtujDL1jEhc3REsGfN4J4KJ13LyGtM1NODuGe
         HZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ft+KFkM5mqo7VfAKnon3TcoqES4XGWXqzb5qqE7B/TY=;
        b=1Sk0Y9bjaO6hAmUrsa9enbM00NQjJaeoFvc+jdkooPUDwE8gqqi9mCqIu5ZVRqFK8L
         ugPw2jw70D4LakIb2zYgAI90v54gga7Q/0oAKOb5RZ11Xc2VgR60gTqBwEmGhXIgF5gg
         3Aagoe4oHFUI3pTJYOlkR+Y0w6o6guJW7ra+XhpjJzH46xibdqnH12tfszsy/Y+Xhlpx
         9utfHpjvv1Ltcog5CqGm3aEgCzcQNVQfFzf6WwVqF2AqLxfkWAIcRNQGAAoQI5mdXazm
         BJZc5Zt4bk5RPDLpKbKGvto7kRLm4DqPxZuFo4bn8GIbvck2+ZFktmkByqvwOEbmLyBt
         C7XQ==
X-Gm-Message-State: ACrzQf0sT4UieA7uDkdFlOMXCvWIku1d+UuBv9LbFbNmMah844fNmZ50
        PnTwSy5ql9H3TD22vch14XLwS20vAMw=
X-Google-Smtp-Source: AMsMyM4NqyLKGcwHQXJCREJuJq2HIQXRjfMjc54ylDn2wohi4CPLt1/Vh8TkyepPVbEvHhiEv6b53xZ2WsY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ba8a:0:b0:6bc:a37:17f2 with SMTP id
 s10-20020a25ba8a000000b006bc0a3717f2mr2692437ybg.252.1665017500103; Wed, 05
 Oct 2022 17:51:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:20 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-8-seanjc@google.com>
Subject: [PATCH 07/12] KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add and use x86 "properties" for the myriad AMX CPUID values that are
validated by the AMX test.  Drop most of the test's single-usage
helpers so that the asserts more precisely capture what check failed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |   9 ++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 105 ++++--------------
 2 files changed, 33 insertions(+), 81 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b2babda9eac8..15200afd7dc6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -200,6 +200,15 @@ struct kvm_x86_cpu_property {
 })
 
 #define X86_PROPERTY_MAX_BASIC_LEAF		KVM_X86_CPU_PROPERTY(0, 0, EAX, 0, 31)
+#define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0	KVM_X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
+#define X86_PROPERTY_XSTATE_MAX_SIZE		KVM_X86_CPU_PROPERTY(0xd,  0, ECX,  0, 31)
+#define X86_PROPERTY_XSTATE_TILE_SIZE		KVM_X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
+#define X86_PROPERTY_XSTATE_TILE_OFFSET		KVM_X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
+#define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	KVM_X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
+#define X86_PROPERTY_AMX_BYTES_PER_TILE		KVM_X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
+#define X86_PROPERTY_AMX_BYTES_PER_ROW		KVM_X86_CPU_PROPERTY(0x1d, 1, EBX, 0,  15)
+#define X86_PROPERTY_AMX_NR_TILE_REGS		KVM_X86_CPU_PROPERTY(0x1d, 1, EBX, 16, 31)
+#define X86_PROPERTY_AMX_MAX_ROWS		KVM_X86_CPU_PROPERTY(0x1d, 1, ECX, 0,  15)
 
 #define X86_PROPERTY_MAX_KVM_LEAF		KVM_X86_CPU_PROPERTY(0x40000000, 0, EAX, 0, 31)
 
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index dadcbad10a1d..21de6ae42086 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -39,11 +39,6 @@
 #define XFEATURE_MASK_XTILEDATA		(1 << XFEATURE_XTILEDATA)
 #define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | XFEATURE_MASK_XTILEDATA)
 
-#define TILE_CPUID			0x1d
-#define XSTATE_CPUID			0xd
-#define TILE_PALETTE_CPUID_SUBLEAVE	0x1
-#define XSTATE_USER_STATE_SUBLEAVE	0x0
-
 #define XSAVE_HDR_OFFSET		512
 
 struct xsave_data {
@@ -129,71 +124,26 @@ static bool check_xsave_supports_xtile(void)
 	return __xgetbv(0) & XFEATURE_MASK_XTILE;
 }
 
-static bool enum_xtile_config(void)
+static void check_xtile_info(void)
 {
-	u32 eax, ebx, ecx, edx;
-
-	__cpuid(TILE_CPUID, TILE_PALETTE_CPUID_SUBLEAVE, &eax, &ebx, &ecx, &edx);
-	if (!eax || !ebx || !ecx)
-		return false;
-
-	xtile.max_names = ebx >> 16;
-	if (xtile.max_names < NUM_TILES)
-		return false;
-
-	xtile.bytes_per_tile = eax >> 16;
-	if (xtile.bytes_per_tile < TILE_SIZE)
-		return false;
-
-	xtile.bytes_per_row = ebx;
-	xtile.max_rows = ecx;
-
-	return true;
-}
-
-static bool enum_xsave_tile(void)
-{
-	u32 eax, ebx, ecx, edx;
-
-	__cpuid(XSTATE_CPUID, XFEATURE_XTILEDATA, &eax, &ebx, &ecx, &edx);
-	if (!eax || !ebx)
-		return false;
-
-	xtile.xsave_offset = ebx;
-	xtile.xsave_size = eax;
-
-	return true;
-}
-
-static bool check_xsave_size(void)
-{
-	u32 eax, ebx, ecx, edx;
-	bool valid = false;
-
-	__cpuid(XSTATE_CPUID, XSTATE_USER_STATE_SUBLEAVE, &eax, &ebx, &ecx, &edx);
-	if (ebx && ebx <= XSAVE_SIZE)
-		valid = true;
-
-	return valid;
-}
-
-static bool check_xtile_info(void)
-{
-	bool ret = false;
-
-	if (!check_xsave_size())
-		return ret;
-
-	if (!enum_xsave_tile())
-		return ret;
-
-	if (!enum_xtile_config())
-		return ret;
-
-	if (sizeof(struct tile_data) >= xtile.xsave_size)
-		ret = true;
-
-	return ret;
+	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0));
+	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0) <= XSAVE_SIZE);
+
+	xtile.xsave_offset = this_cpu_property(X86_PROPERTY_XSTATE_TILE_OFFSET);
+	GUEST_ASSERT(xtile.xsave_offset == 2816);
+	xtile.xsave_size = this_cpu_property(X86_PROPERTY_XSTATE_TILE_SIZE);
+	GUEST_ASSERT(xtile.xsave_size == 8192);
+	GUEST_ASSERT(sizeof(struct tile_data) >= xtile.xsave_size);
+
+	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_AMX_NR_TILE_REGS));
+	xtile.max_names = this_cpu_property(X86_PROPERTY_AMX_NR_TILE_REGS);
+	GUEST_ASSERT(xtile.max_names == 8);
+	xtile.bytes_per_tile = this_cpu_property(X86_PROPERTY_AMX_BYTES_PER_TILE);
+	GUEST_ASSERT(xtile.bytes_per_tile == 1024);
+	xtile.bytes_per_row = this_cpu_property(X86_PROPERTY_AMX_BYTES_PER_ROW);
+	GUEST_ASSERT(xtile.bytes_per_row == 64);
+	xtile.max_rows = this_cpu_property(X86_PROPERTY_AMX_MAX_ROWS);
+	GUEST_ASSERT(xtile.max_rows == 16);
 }
 
 static void set_tilecfg(struct tile_config *cfg)
@@ -238,16 +188,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 {
 	init_regs();
 	check_cpuid_xsave();
-	GUEST_ASSERT(check_xsave_supports_xtile());
-	GUEST_ASSERT(check_xtile_info());
-
-	/* check xtile configs */
-	GUEST_ASSERT(xtile.xsave_offset == 2816);
-	GUEST_ASSERT(xtile.xsave_size == 8192);
-	GUEST_ASSERT(xtile.max_names == 8);
-	GUEST_ASSERT(xtile.bytes_per_tile == 1024);
-	GUEST_ASSERT(xtile.bytes_per_row == 64);
-	GUEST_ASSERT(xtile.max_rows == 16);
+	check_xsave_supports_xtile();
+	check_xtile_info();
 	GUEST_SYNC(1);
 
 	/* xfd=0, enable amx */
@@ -317,8 +259,9 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA));
 
-	/* Get xsave/restore max size */
-	xsave_restore_size = kvm_get_supported_cpuid_entry(0xd)->ecx;
+	TEST_ASSERT(kvm_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE),
+		    "KVM should enumerate max XSAVE size when XSAVE is supported");
+	xsave_restore_size = kvm_cpu_property(X86_PROPERTY_XSTATE_MAX_SIZE);
 
 	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

