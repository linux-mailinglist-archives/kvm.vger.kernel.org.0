Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C4058CC58
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243664AbiHHQrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243316AbiHHQrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E30140F3
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y9-20020a17090322c900b0016f8fdcc3b1so6026050plg.6
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=hIaJdYwtWj4ZMPuNUWe2bTErIBaOCWanLkuGFNwjboc=;
        b=F0y/mv/n/yhUTbNVd/f6QhQODoCryg9GOvPbP8loKHk9PZkh4xL0wFpBTlvTBE2OJ6
         5M3swKczTdE1AMoUEQy9RlOgFAmbVS/Zc3/B1Eo2gcRnGIqLsX3SfDmhIBsPHfH0UKuc
         iT1dl08BKz+VfQkkGxmD/K8NqBSIfizK/5GivCAgl1Adfnuwq6CqbxKhOJkY5NX8tLQt
         twHOTwzo9h7Z4ta5PMiwc527l/cgRFlI4Pk7fmxoVeTv5C2nNcJrJ7evHcm5oX30hJDy
         OwqeULHnBIC5n49rj6o/4P9gUSIPDX23b3GULu/tTEFIucKNVUtDHjMHbk81Sx0ky226
         bP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=hIaJdYwtWj4ZMPuNUWe2bTErIBaOCWanLkuGFNwjboc=;
        b=m6P/15HGgyQjtsIUiyskc7aFineUVCF7H6nh5wf/Eb5drMGMQ0SjqQ15XXIWXhA7in
         K1Rw7cryaf3vm0GzIv2i2JJzpN3HljKZakOqaDJsJ/I8z5ee8E6gu4gsliU0kGVb/zqO
         T/2Sf5fcHk6wuFOiWP7EdG17i1W+vAJztq1N6JU9ppty9XCiir93baZqfoH6DCgh0k8A
         n6KdniVXs8xo52HoWVvITskei0dCjeWKvGFc4BplW93nQxIPc7l+Fr0ux5Tb2ytJ9VPy
         nmrYEfV8EaXo+GlTKC2jFXlAWPohsaMCfsQYkdvrxlL0oQR2+sPCskWPCpZ9nXN93U4C
         kpwQ==
X-Gm-Message-State: ACgBeo1LUUKg0RLHtYYVpfhoRWd2yThJCtXEZAr85ZcmQaPivJZMa59x
        BU0EeCkneGy1Is62SHFAzd4Mhowvo8w=
X-Google-Smtp-Source: AA6agR5rZZ3Immqywmibkw9j0HPfrrXYjdZTbjmS2Uv/2f2dP0MKJnvXDPhRaQbRnhh0kgMz9Aocmf36gCY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d585:b0:1f4:f9a5:22a9 with SMTP id
 v5-20020a17090ad58500b001f4f9a522a9mr30409956pju.49.1659977236565; Mon, 08
 Aug 2022 09:47:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:04 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 4/7] x86: Add helper to detect if forced
 emulation prefix is available
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

Add a helper to detect whether or not KVM's forced emulation prefix is
available.  Use the helper to replace equivalent functionality in the
emulator test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h | 14 ++++++++++++++
 x86/emulator.c | 15 +--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 8f708fd..c023b93 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -106,6 +106,20 @@ typedef struct  __attribute__((packed)) {
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define ASM_TRY_FEP(catch) __ASM_TRY(KVM_FEP, catch)
 
+static inline bool is_fep_available(void)
+{
+	/*
+	 * Use the non-FEP ASM_TRY() as KVM will inject a #UD on the prefix
+	 * itself if forced emulation is not available.
+	 */
+	asm goto(ASM_TRY("%l[fep_unavailable]")
+		 KVM_FEP "nop\n\t"
+		 ::: "memory" : fep_unavailable);
+	return true;
+fep_unavailable:
+	return false;
+}
+
 /*
  * selector     32-bit                        64-bit
  * 0x00         NULL descriptor               NULL descriptor
diff --git a/x86/emulator.c b/x86/emulator.c
index 6dc88f1..e1272a6 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -17,10 +17,6 @@
 
 static int exceptions;
 
-/* Forced emulation prefix, used to invoke the emulator unconditionally.  */
-#define KVM_FEP_LENGTH 5
-static int fep_available = 1;
-
 struct regs {
 	u64 rax, rbx, rcx, rdx;
 	u64 rsi, rdi, rsp, rbp;
@@ -1121,12 +1117,6 @@ static void test_illegal_movbe(void)
 	handle_exception(UD_VECTOR, 0);
 }
 
-static void record_no_fep(struct ex_regs *regs)
-{
-	fep_available = 0;
-	regs->rip += KVM_FEP_LENGTH;
-}
-
 int main(void)
 {
 	void *mem;
@@ -1136,9 +1126,6 @@ int main(void)
 	unsigned long t1, t2;
 
 	setup_vm();
-	handle_exception(UD_VECTOR, record_no_fep);
-	asm(KVM_FEP "nop");
-	handle_exception(UD_VECTOR, 0);
 
 	mem = alloc_vpages(2);
 	install_page((void *)read_cr3(), IORAM_BASE_PHYS, mem);
@@ -1190,7 +1177,7 @@ int main(void)
 	test_ltr(mem);
 	test_cmov(mem);
 
-	if (fep_available) {
+	if (is_fep_available()) {
 		test_mmx_movq_mf(mem);
 		test_movabs(mem);
 		test_smsw_reg(mem);
-- 
2.37.1.559.g78731f0fdb-goog

