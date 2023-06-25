Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAC673D528
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjFYXHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFYXHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDC01BD
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-668711086f4so1664832b3a.1
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734469; x=1690326469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHqxeAotCnxkuVm3NE+mpH766uEaTTmXxUGQT2/zQXg=;
        b=i9FKP9QrAGjLwKNZZ0JjhCkf0OQyEDv1x5RoB0qkg01vXGEfopl3Pddg/0ZR7XvUAu
         nlUzlRpvzCu5obICyLJZvONDx9iY6BZ0s2/+5xurDlD7Ik02CCkPsMfRCrxKCLpyxcuT
         jfXlX0bd4+50EW1NEwUUP9y6ZrFDgwDJTzQzul3vON/QSiaVDzVMcmQefZn1P+VltW86
         TIN3lu718abHeVvJ8TIxYYeKB0dfr6TXIIhnhl/2lsJgnSwXVz/4Ch8Oz87KMKr8jB83
         Pqlutht00f3Nrfr3oFyYtklEqpDK8Rm8TdV3ryis7oio3m2Kvls9pjCi4Jepvhw79tBf
         Gv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734469; x=1690326469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHqxeAotCnxkuVm3NE+mpH766uEaTTmXxUGQT2/zQXg=;
        b=Vi+i1Oy70VOvIgNPj6XlVUxjZtlHBX+WKLRTMffoS9T7oMCromw+iLuEgj+C1ORBen
         qPtgA4Gc82GeYbyH5puN/8b1jy6lqF3RQDEiQ1Z/HdTwK52+Qnrwu7S6ogVUa1oAfhHQ
         45ngZV0PHqXq/IHsmMfQHlursjr9PCgXfvq7V9asVjt8iCKbvQu3RvftwRuCQ1MPohtp
         RrDumrNtK1MyLTnXcjY3q8cs35CSGMcCo7ctnv+Ol/jedd1ozOU/r3LYkUoM150kn4Nu
         DvkOgeH1jPCj/fxuCvISTe3+SoaGYazR+ZRJjfdV7SgDGb/ZZmt9VPJQ63NtuF1fL+vt
         2esA==
X-Gm-Message-State: AC+VfDwM+3iGt+G0oWUPFkBpXZ3W/OhB1BTOmLSBMtImRycTzzCatWxg
        GSsJpb7owTYcSfnt7SKApRM=
X-Google-Smtp-Source: ACHHUZ6LiPxrHGKgvRwbrsWtmWQj0OpsUWu9zZW9lZ/7lWInjAzmncaflAQwfnGrIxaGPDnKxNv5Mg==
X-Received: by 2002:a05:6a21:32a2:b0:110:b7fb:2c92 with SMTP id yt34-20020a056a2132a200b00110b7fb2c92mr35741019pzb.11.1687734469017;
        Sun, 25 Jun 2023 16:07:49 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:48 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in a separate file
Date:   Sun, 25 Jun 2023 23:07:11 +0000
Message-Id: <20230625230716.2922-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
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

v1->v2:
* Making clean should remove .debug [Andrew]
* x86 EFI support [Andrew]
---
 arm/Makefile.common | 5 ++++-
 x86/Makefile.common | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

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

