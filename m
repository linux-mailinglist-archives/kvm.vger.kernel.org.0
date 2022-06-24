Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFEB559E1B
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiFXQFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiFXQFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:05:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8428354FB1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656086741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CsXaFlnshwJqB8b4lN8h79kDG4Lczz/RHdx1etqvfBU=;
        b=NAwtIxfK+vus2PGz7YYWfuUIjiiXp8I3oQ2ShjeXffbMUYQL9fnei/6f0HGo2/gnu3XiqJ
        cBKaBF7RjcIqlqhWA7SOnsuUfpwipN5/Low3DPg/xcGdOyJVe8HfB7koZqDf9zjDX/XL6w
        UA7j/hZv8dmhvHXKTOeAoao4aVbPOqo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-Uzgd1qTLOQuKsdBnK6pDsw-1; Fri, 24 Jun 2022 12:05:38 -0400
X-MC-Unique: Uzgd1qTLOQuKsdBnK6pDsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D8033810D41;
        Fri, 24 Jun 2022 16:05:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7A98141510C;
        Fri, 24 Jun 2022 16:05:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Subject: [PATCH kvm-unit-tests] x86/msr: Add dedicated macros to handle MSRs that are 64-bit only
Date:   Fri, 24 Jun 2022 12:05:37 -0400
Message-Id: <20220624160537.2737482-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add a separate macro for handling 64-bit only MSRs to minimize churn and
copy+paste in a future commit that will add support for read-only bits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rebase on top of the fix for MSR_IA32_MISC_ENABLE, do not go overboard
 with macros. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/msr.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index b0a5db0..bb15230 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -26,27 +26,27 @@ struct msr_info {
 #define addr_64 0x0000123456789abcULL
 #define addr_ul (unsigned long)addr_64
 
-#define MSR_TEST(msr, val, only64)	\
-	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
-#define MSR_TEST_RO_BITS(msr, val, only64, ro)	\
-	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64, .keep = ro }
+#define MSR_TEST(msr, val, ro)	\
+	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = false, .keep = ro }
+#define MSR_TEST_ONLY64(msr, val, ro)	\
+	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = true, .keep = ro }
 
 struct msr_info msr_info[] =
 {
-	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, false),
-	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
-	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
+	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, 0),
+	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, 0),
+	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, 0),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
 	// read-only: 7, 11, 12
-	MSR_TEST_RO_BITS(MSR_IA32_MISC_ENABLE, 0x400c50809, false, 0x1880),
-	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
-	MSR_TEST(MSR_FS_BASE, addr_64, true),
-	MSR_TEST(MSR_GS_BASE, addr_64, true),
-	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64, true),
-	MSR_TEST(MSR_EFER, EFER_SCE, false),
-	MSR_TEST(MSR_LSTAR, addr_64, true),
-	MSR_TEST(MSR_CSTAR, addr_64, true),
-	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, true),
+	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c50809, 0x1880),
+	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, 0),
+	MSR_TEST_ONLY64(MSR_FS_BASE, addr_64, 0),
+	MSR_TEST_ONLY64(MSR_GS_BASE, addr_64, 0),
+	MSR_TEST_ONLY64(MSR_KERNEL_GS_BASE, addr_64, 0),
+	MSR_TEST(MSR_EFER, EFER_SCE, 0),
+	MSR_TEST_ONLY64(MSR_LSTAR, addr_64, 0),
+	MSR_TEST_ONLY64(MSR_CSTAR, addr_64, 0),
+	MSR_TEST_ONLY64(MSR_SYSCALL_MASK, 0xffffffff, 0),
 //	MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
 //	MSR_VM_HSAVE_PA only AMD host
 };
-- 
2.31.1

