Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC65656E02
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiL0Siz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 13:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiL0Siv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 13:38:51 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4592B25DA
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:51 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s2-20020a056a00178200b005810f057e7cso3180084pfg.3
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2HtfRp6XiifK0tdk//ftduJ62QemRXTOXimwerRZPE4=;
        b=nP+BL3QZ/soWmXWQWNvJfvS4AV9H1LKYmljZCWdtGLEmJGFLdVRj+2b/YwAKVutlS9
         RwoWAxpWB5gSBSDtHM/nKkB/TD7Act+i0gECG1eWE8cMIunyOMxH7Wgy1PbM3pb3wiDx
         mf0mUJ0L1jFw52Ux1fCCjqjJrT1eOd3+UysnHzVS5XLV0a456XCnujK7OT9STmzVu754
         1Kk8BSF6xwTjemJ+/Y6NyFa+4hbPCu9guQ/B3Ik1B7it2QU5CYA6d1JQo4bNbE0EAcSM
         a+/LBjPnSJtkEWk5y+AI7FNoAJ5zd5hpLGh8J3hZHTU6kwEHpeBpTFm7jfRFhDpGVBeT
         xU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2HtfRp6XiifK0tdk//ftduJ62QemRXTOXimwerRZPE4=;
        b=g9kf2S52NpFNpkXhSoHmBO+HGoiuQqq+WDI4umLWa4MIkyfSgz7iN6sOi3VJwZWleM
         5Bp70LRM3NteN19AurqqZDRax4uMpPKl+xOQuTDczJolJQrNzblavM8ZOl4RUt4RS6Uz
         Hh8ByxpwO9G5EjFIaTZh7GFTfwd4QXWUP+YLIMVKbjnfqIBCaG3XX1UtjpsdSTAih1th
         JqBSkMqzvZP4bjqytVseF4aOn4chaa8b2wIG48nSLZhFzeBPlh80MCzzarS0uEFoZEDq
         SJ+m2S9CsTyH201Re7ASzx+EJsGYinsuAz3aPyYk6NLRUGWXM0uDPN2ArrGEaWpjEfA7
         7gkw==
X-Gm-Message-State: AFqh2kqLTQzcT5rkStqSYQWDviFgJCJurU7jBtVKiLjN7H5pFYmh9LO4
        Z5/hWZnQeyCoxgDm5TaoYRGQXwO9gNiThuoAiyaA6i05B7GVMxwRz9kpJEIyuqiaQ9+rKI5ItJW
        SptYrc7AIGAnocNe0Ork1GKZrsSOclVXLup8SWXm9cIWt8dgPGT06KW0bE+sRZ/x8NAkk
X-Google-Smtp-Source: AMrXdXv7b7WUWMLPNCw0qh0fa2VreLNNj60GktWYdBf2K4Hz2/I+pwIbzifarBClD5axYxi4PyjqFoNOFpfqgNPG
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:b617:0:b0:578:1bcf:fae7 with SMTP
 id j23-20020a62b617000000b005781bcffae7mr1422607pff.45.1672166330683; Tue, 27
 Dec 2022 10:38:50 -0800 (PST)
Date:   Tue, 27 Dec 2022 18:37:14 +0000
In-Reply-To: <20221227183713.29140-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227183713.29140-3-aaronlewis@google.com>
Subject: [PATCH 2/3] KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

The instructions XGETBV and XSETBV are useful to other tests.  Move
them to processor.h to make them available to be used more broadly.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 19 +++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b1a31de7108ac..34957137be375 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -492,6 +492,25 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	__asm__ __volatile__("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax | ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	__asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
+
 static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b670..4b733ad218313 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -68,24 +68,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
@@ -121,7 +103,7 @@ static inline void check_cpuid_xsave(void)
 
 static bool check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	return xgetbv(0) & XFEATURE_MASK_XTILE;
 }
 
 static void check_xtile_info(void)
@@ -177,9 +159,9 @@ static void init_regs(void)
 	cr4 |= X86_CR4_OSXSAVE;
 	set_cr4(cr4);
 
-	xcr0 = __xgetbv(0);
+	xcr0 = xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
-	__xsetbv(0x0, xcr0);
+	xsetbv(0x0, xcr0);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.39.0.314.g84b9a713c41-goog

