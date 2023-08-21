Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C7B783573
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjHUWNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 18:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 18:13:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF0130
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:13:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589c2516024so54478927b3.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692656032; x=1693260832;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V2VrZ5gW7utnbjbOxdiGfBvyeRDz8hJlNQenFiZ1OR8=;
        b=B11b06edE2oc2EFcditrzVd0hMOc/3YFL9N4Xs1pG2zM4dYdyEvyu/53HS9LCOxnI9
         QKp5BLOfPUPrSNghFzLlbJEPFKlRTuoNibvunXO7gZQVlQKSRMiHY3rFfl6Zk2gD/PMH
         y1j+4SBhqFZ2y81/FgvtF6DoVLIcdzY8k7u4HkQrQQTaTymMkZqFsID0kJ0ZmUxO/63k
         Rw21Q/QWqSZW4TKn/pIJwG+wIiexfg4zeWhpXeMWO8QLc0gLTs/BRcGdaTyTfJgH05eE
         ma1VeFvmgIhmDTnd394Auv9/40aHUTREsu2xhugb5I8dKCVBeeI/sCkRf39WXOK/+qn2
         5/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692656032; x=1693260832;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V2VrZ5gW7utnbjbOxdiGfBvyeRDz8hJlNQenFiZ1OR8=;
        b=K3RAGk6Iie0UfOJ92NgNbLM2ojQEC5Y45nNQRaz8tCs1MzsWp/GwGbDkDHIvDbT+Zp
         1nGfm2REn68P2zXwGJbC7bYX1psSBl6e/C4nBGK3agmT6cJMxUbKI4qMhKfX1lP+nUC1
         b5XefzXpArnSyyTNWeiUHZ5nuwLnSIXb7Via+K4Sip5TkSXTFQk2PXyTpJSB5UGg8xzf
         QDLVxRdjg2GmXYn1etW8E89WHChHAuuxJAfQYAmr0BsHq1K1WJYqfXVWg6L/lxYMaFji
         mwMpjUoMxnN3jlFVkt0690d9QOEPomZHIzG7YBmHZreEEh0/SaDq/OTTwveRqhmSDTGA
         1frQ==
X-Gm-Message-State: AOJu0Yy7LGqag9ttoWC87rWEXlZSOB/6UCaj4vTPDuUr6paLiMRRGP/M
        Y8lrwyMqvyA+B7e91v3IAJvDeW1Pf299XKwm3A==
X-Google-Smtp-Source: AGHT+IGWYxlsFF/uU/zuMlkHCoh2a2aGliuaWfLsPhqG8qCBxMeFybRotvOSFB3cqCqIyjVvviJwUW4JsR8QUprnPg==
X-Received: from riemann.sea.corp.google.com ([2620:15c:100:201:61be:5074:9774:e5b])
 (user=srutherford job=sendgmr) by 2002:a81:ae1c:0:b0:57a:e0b:f63 with SMTP id
 m28-20020a81ae1c000000b0057a0e0b0f63mr66032ywh.7.1692656031829; Mon, 21 Aug
 2023 15:13:51 -0700 (PDT)
Date:   Mon, 21 Aug 2023 15:13:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821221317.868509-1-srutherford@google.com>
Subject: [PATCH] x86/sev: Make enc_dec_hypercall() accept a size instead of npages
From:   Steve Rutherford <srutherford@google.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com,
        pankaj.gupta@amd.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com,
        Steve Rutherford <srutherford@google.com>
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

enc_dec_hypercall() accepted a page count instead of a size, which
forced its callers to round up. As a result, non-page aligned
vaddrs caused pages to be spuriously marked as decrypted via the
encryption status hypercall, which in turn caused consistent
corruption of pages during live migration. Live migration requires
accurate encryption status information to avoid migrating pages
from the wrong perspective.

Fixes: 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption status is changed")
Signed-off-by: Steve Rutherford <srutherford@google.com>
---
 arch/x86/include/asm/mem_encrypt.h |  4 ++--
 arch/x86/kernel/kvm.c              |  4 +---
 arch/x86/mm/mem_encrypt_amd.c      | 13 ++++++-------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 7f97a8a97e24..8a7871ebbcdf 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -50,8 +50,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
-void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
-					    bool enc);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr,
+					    unsigned long size, bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6a36db4f79fd..b8ab9ee5896c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -966,10 +966,8 @@ static void __init kvm_init_platform(void)
 		 * Ensure that _bss_decrypted section is marked as decrypted in the
 		 * shared pages list.
 		 */
-		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
-					PAGE_SIZE);
 		early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
-						nr_pages, 0);
+						__end_bss_decrypted - __start_bss_decrypted, 0);
 
 		/*
 		 * If not booted using EFI, enable Live migration support.
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 54bbd5163e8d..6faea41e99b6 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -288,11 +288,10 @@ static bool amd_enc_cache_flush_required(void)
 	return !cpu_feature_enabled(X86_FEATURE_SME_COHERENT);
 }
 
-static void enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
+static void enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
 {
 #ifdef CONFIG_PARAVIRT
-	unsigned long sz = npages << PAGE_SHIFT;
-	unsigned long vaddr_end = vaddr + sz;
+	unsigned long vaddr_end = vaddr + size;
 
 	while (vaddr < vaddr_end) {
 		int psize, pmask, level;
@@ -342,7 +341,7 @@ static bool amd_enc_status_change_finish(unsigned long vaddr, int npages, bool e
 		snp_set_memory_private(vaddr, npages);
 
 	if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
-		enc_dec_hypercall(vaddr, npages, enc);
+		enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
 
 	return true;
 }
@@ -466,7 +465,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
-	early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
+	early_set_mem_enc_dec_hypercall(start, size, enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -482,9 +481,9 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
-void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
 {
-	enc_dec_hypercall(vaddr, npages, enc);
+	enc_dec_hypercall(vaddr, size, enc);
 }
 
 void __init sme_early_init(void)
-- 
2.42.0.rc1.204.g551eb34607-goog

