Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF74783609
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjHUW7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 18:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjHUW7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 18:59:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C4E198
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:59:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7494be34f8so2601507276.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692658782; x=1693263582;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WojTsyHJlQQoruGt5rJF23KrHwn53DulZRTBhsYqmPM=;
        b=Xt4OmnWTg7A1bjVlc1q8eZptmz5K2KqmSUzXT/8gqV5GOaACpuxw0gxMfS2/kZRwWA
         +YeRpkFzN58QNhMU52t3YOip8FLYfk2phrZLdia6BQO9c5kjd2RLX/Pz65dm8u/htRmO
         IEu22y/b+4NYqo9L2Yfdd0CoerUxwwqhUpljSpwKXYuOqJOutMCzXlDAa2+XvRBhpYCz
         VykoD2C8Z0ZXtgz8SSsXLmHMX1tWxok5N4GsxB8a3yvKNxVVwE5v6yab9cw0tVusGKPW
         bAorv2RHU/G/1/Qga2eUAC0X++45x/Eq0N9gi0m609JJVkvPmGjRhXss35lR2STNX41I
         EVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692658782; x=1693263582;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WojTsyHJlQQoruGt5rJF23KrHwn53DulZRTBhsYqmPM=;
        b=HQMfVkUrXUrQwHsX6Fit1OuA86jTNAabzd9am26cgbWuxrh5P7WMGsPRD0qgZqWVCc
         Be+6+zq4g/qHnv1dqaeCDemNGTzkgTu0EP6KZW2PWn7GgpnaySIS6pmQvewxHCoXnqGR
         kZ22vpWa55CkUCTnP6tUKG4CCLvU1dj6KaEMS6CzPcZMTpksU0smhIOd4L9hCPHhgXtl
         jEyuvA2deEXXRKduovM5mWSrxcfnXpVghufu0PeArfqY/p+yhTdHbRodWVeDEpM4k06G
         fbaDMPr0MsKoutl13kPnm8i+pb/815YoS7KWeGaCzObS1GQ1BaNfoxvvozsIjKnhVXIC
         HUxQ==
X-Gm-Message-State: AOJu0Yxa630c2iU3wwwvZLvdvumr8TOArSsjKNx4z4HLYTQhQYaIxnyB
        4SQQBC9y6poa+soNabXTkrLGIAwCXGUluidNbg==
X-Google-Smtp-Source: AGHT+IF0Ms/Uieqvin5sgKbBWkvCy9IWIrxUUGRBd6tv8X2fNrhb6Ijj2ZCUahyed72rzlUp+zhVkPwpTiB73Kz99A==
X-Received: from riemann.sea.corp.google.com ([2620:15c:100:201:61be:5074:9774:e5b])
 (user=srutherford job=sendgmr) by 2002:a05:6902:1141:b0:d58:6cea:84de with
 SMTP id p1-20020a056902114100b00d586cea84demr87039ybu.11.1692658782154; Mon,
 21 Aug 2023 15:59:42 -0700 (PDT)
Date:   Mon, 21 Aug 2023 15:58:59 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821225859.883120-1-srutherford@google.com>
Subject: [PATCH v2] x86/sev: Make enc_dec_hypercall() accept a size instead of npages
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
 arch/x86/include/asm/mem_encrypt.h |  6 +++---
 arch/x86/kernel/kvm.c              |  4 +---
 arch/x86/mm/mem_encrypt_amd.c      | 13 ++++++-------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 7f97a8a97e24..473b16d73b47 100644
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
 
@@ -85,7 +85,7 @@ early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0;
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline void __init
-early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
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

