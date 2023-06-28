Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A831740719
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjF1AOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjF1AOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427112125
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5577900c06bso3881999a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911271; x=1690503271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcITuuApT8BB1DergEM0uY4hFVcspCnprAWBbOfWs/s=;
        b=sEZyWLJ8PWKZnhovvXmlZjBe315oX+wAO1VaSsRvyuHsB8w8pIKfalNm2ZKSEa+XlX
         6euNJgvuML8ZhztB0m35jtGRQtoARrzJCbnV30gK25dnuNFdO8tTjnSBtoeFSmAQPJix
         omx5rVF+6oAQVIxqtQ2h6Zt4/RZVZf3YZTCJzxsPJBDCZyG7PhNcCemSRjbwGXic+/J6
         brb4DJFY3RXcY1EBsf7F+eaMWoFMvlI/EKFnnWEeICMbQBLSyR6P2wQwH6qASRpqEP6T
         RvqsREBBVq28RC97wIYGXx+YFXYoJK/kpUMvvo+kjR9qfceR9fm2bxXA6nXGYZpg4nqX
         sYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911271; x=1690503271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vcITuuApT8BB1DergEM0uY4hFVcspCnprAWBbOfWs/s=;
        b=VYLHi2F3teHaW6t2nyz4+bw1yfg7F7uGsVrNulZ/Fa1ZQ9nL5YiGQ35syn80lGxe1j
         U0BKAUWdGU40ZQjQYtIjfjrvS+rF9WWxvloUtSTJNM/KW/dHK7sUD3rRxtHLo4q6pmvt
         eL4ob+K6yS0skDe7s2QOqA0JnigCP1R1cFXJHydEKkLvTmS1ZCHNKJ2kUWMLANChuCOj
         KYx8T8VKx0x+Tp8U3fELgFGYO3iFIXr+Dh/sjJFfpBTU44I0rOz2a2ThRKKRlcuZPN1F
         FAskXiZQVn97bSsRmE+UvPNgeoHWeq1aSuKkNXQWmVdoLn6LV9owwi7qpjUcGe/GE6s+
         Tfvw==
X-Gm-Message-State: AC+VfDxFeeNT3zghMsUcBtGclzGI3rAei8kdZ/ugqEaiLKN/0gdnA9ID
        J6PHV5FogFTJOC3qXFILsltn5Y/VEYY=
X-Google-Smtp-Source: ACHHUZ7WT0YdLJ5x5NFAHL4wyFzvepYBp7coQmyERcaSCKvmq1olpjIBkSIrC7nW5/0S0fhJbXSseg==
X-Received: by 2002:a17:90b:4d83:b0:263:4164:dfba with SMTP id oj3-20020a17090b4d8300b002634164dfbamr143028pjb.6.1687911270531;
        Tue, 27 Jun 2023 17:14:30 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:29 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 1/6] efi: keep efi debug information in a separate file
Date:   Wed, 28 Jun 2023 00:13:50 +0000
Message-Id: <20230628001356.2706-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Debugging tests that run on EFI is hard because the debug information is
not included in the EFI file. Dump it into a separeate .debug file to
allow the use of gdb or pretty_print_stacks script.

Signed-off-by: Nadav Amit <namit@vmware.com>

---

v2->v3:
* Add *.debug to .gitignore [Andrew]

v1->v2:
* Making clean should remove .debug [Andrew]
* x86 EFI support [Andrew]
---
 .gitignore          | 1 +
 arm/Makefile.common | 5 ++++-
 x86/Makefile.common | 5 ++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index 29f352c..2168e01 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,6 +7,7 @@ tags
 *.flat
 *.efi
 *.elf
+*.debug
 *.patch
 .pc
 patches
diff --git a/arm/Makefile.common b/arm/Makefile.common
index d60cf8c..9b45a8f 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
 
 %.efi: %.so
 	$(call arch_elf_check, $^)
+	$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(OBJCOPY) --strip-debug $^
+	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
@@ -103,7 +106,7 @@ $(libeabi): $(eabiobjs)
 	$(AR) rcs $@ $^
 
 arm_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
+	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} $(libeabi) $(eabiobjs) \
 	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
 
 generated-files = $(asm-offsets)
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 9f2bc93..c42c3e4 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -54,6 +54,9 @@ ifeq ($(CONFIG_EFI),y)
 	@chmod a-x $@
 
 %.efi: %.so
+	$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(OBJCOPY) --strip-debug $^
+	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
 		-j .rela -j .reloc -S --target=$(FORMAT) $< $@
@@ -124,4 +127,4 @@ arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
 	$(TEST_DIR)/efi/*.o $(TEST_DIR)/efi/.*.d \
-	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi
+	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi $(TEST_DIR)/*.debug
-- 
2.34.1

