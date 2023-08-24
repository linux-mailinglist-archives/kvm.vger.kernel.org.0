Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39CD787B8E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 00:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbjHXWiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 18:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243939AbjHXWhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 18:37:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA6E7B
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:37:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c8cbf0a0dso29043417b3.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 15:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692916665; x=1693521465;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UMFl4tquwwjAqS1w3i0zThSN3MgU1gooXrvOwfPzxiY=;
        b=Dl/FB9cQAooD+5xmfvVkbd+RWJKasgFxWZ2KnhM7gWtqQS2A+Th+gfhgfoVdw+yGBD
         mYbzABOrt/V+AYVwlcDMGJkT3fWxPaNC5WDQ3oUtROEpYeiNRHJJVzBaoW/HI3wQybTv
         Y8p/5T7hLQ1GJ9TCE4PBEunEGsBjvOu0GH6hwVMDXSHGwuXTV7FZTU0zH6ixYJhS8zhD
         X9lFj+ZI/5OvoJ/+DxT5hjWkaC0rwH+BPS8PIoTrkiPnjdWxgQNE/2LQo2Uo6qeCkkDB
         Vchv+Sh4SesvmENbHOtNekx8pvUbPjDtfXT6xuB5SSWi5b38xG3rMzWsL9O4zquBpoDF
         JALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692916665; x=1693521465;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UMFl4tquwwjAqS1w3i0zThSN3MgU1gooXrvOwfPzxiY=;
        b=NtYBLS2IN0RelvUx4hi3xdUyMPTbHifOSxfqqvEdvu9M1b8SVbgmW0kk+Sh0muas98
         FGGkNEd8+CmFEHbs8TNjR2ERFJQF1H8zRxJYdq+lcJ9JypJGCapW4hT2gD5Y/hg/dXYi
         tSIx3+FGp5yinJt0T4zNA6VLhRljprjkhjqDwn6TLWLC0W2lmvalqwlVCUDLS4uRkwZH
         wOoUOl395gCDABf6OKDKUa/IMmMSfmmjJWlKFdsA6nJBV3dJNSOJ+UTDJss4my4YwGfI
         aTMxvPegMJCnRAu59EgPToFNgdt0HMzpMMI2Er+PfmgLiJ56LvCSHkWb2AT90A+lBSxT
         yfyQ==
X-Gm-Message-State: AOJu0Yyk5SjGGVipAXDqRJbjF6RT32YTFyDvy9BRKF+Mz1JTcBIxlQKp
        XDAvznGlTojrADHzyxR/VaJ4IUjdkzqBIf8GxA==
X-Google-Smtp-Source: AGHT+IEcNoYWlkJCqJb3cVnMqS2O4oLgeTyN2sbLgckZMBtD7aJFOXZZEaU0dUzbpAUrKO56nFA29Ob66DhkUhC/HA==
X-Received: from riemann.sea.corp.google.com ([2620:15c:100:201:1fdc:3cc3:587a:93c9])
 (user=srutherford job=sendgmr) by 2002:a05:690c:2712:b0:57a:6019:62aa with
 SMTP id dy18-20020a05690c271200b0057a601962aamr329028ywb.5.1692916665017;
 Thu, 24 Aug 2023 15:37:45 -0700 (PDT)
Date:   Thu, 24 Aug 2023 15:37:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230824223731.2055016-1-srutherford@google.com>
Subject: [PATCH v3] x86/sev: Make enc_dec_hypercall() accept a size instead of npages
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
        Steve Rutherford <srutherford@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Cc: stable@vger.kernel.org
Fixes: 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption status is changed")
Signed-off-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
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

