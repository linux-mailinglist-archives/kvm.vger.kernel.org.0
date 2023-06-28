Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66F2740715
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjF1AOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjF1AOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203626B1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:32 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b8063aa2e1so18043445ad.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911272; x=1690503272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VV0a8wWSD+atLlwpNamgRCyPytqoIWQ0GwWykCu/xw=;
        b=NEeG+Fd2oONFSZHMZgXZhQp48FPLe6z5vzWUJT+7cLVPJw9QNYox443LEIecTTX6TY
         ZeSSkSBXZTr2GSr0HNmb1SMiXQ88aHJ0NzFurU2/qJV02TXrwPM7fQwNtV4pOqlT+GAJ
         YPsOYn9t38ODKHcu0AL3ETYaFz44K24gxqh5OYI4/CpebE3uMZxRg57MVBOU2wefkeDU
         kXbmfbOUkAqDHNEgKLoMbw0X6VwAlPrW87J58l1bnMbxb2T7WILnemY848zXungiaZmm
         RAgkA50YAlhNVIPGtgDLGIfvXl5BtwhzhLVR+2Wd05jsfiflATyFkLOBt6TvEpNS72YF
         YmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911272; x=1690503272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VV0a8wWSD+atLlwpNamgRCyPytqoIWQ0GwWykCu/xw=;
        b=gIfeMFs2Q051XhjiwuBKeV1NJfBHdbbvq6N+AqDNPBhtlu0uw5RwVbobD1B47oBqvw
         034zDiNlvRp/kjIIvCjQJ5Bs3e4B9NHWQotrOKVMKiVaVgVyb3HnWqfKT5eSMNd+AKw6
         UmRRSDcr+Hxt6xcVew2qMxJJlkp1WJBXR5eyK47LLyyFhiygm1EvfxydmYJAG2UVFhs0
         tJ3arEezeFxcrOmtVAAZCG0AcbwGP+VTCCkhe04RpL+bB/2JfIzfl4fBuYg5fPQZIf3A
         ql/n+3MervqAcnOQQsYlxAU7u5XcbrlQ1rLIKF8g1SXLtQqExchsXtSIBPKGzl5K2yxi
         UR8w==
X-Gm-Message-State: AC+VfDzxbdCvRoueojPOi7EqOL26cj4Kib+YvH3/Nrxvu+OMjlu90ZPL
        zK/I2SVdwrVrEAf/Dkc1yTs=
X-Google-Smtp-Source: ACHHUZ4uh9514t9KV5Y1JchPqaxRN1mR8gdhBr5xLxQvVkgRsCUbt497+YuIruLuWl9Z4WyPUxJEgA==
X-Received: by 2002:a17:903:32d0:b0:1b1:b2fa:1903 with SMTP id i16-20020a17090332d000b001b1b2fa1903mr7562183plr.41.1687911271722;
        Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:31 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 2/6] lib/stack: print base addresses on relocation setups
Date:   Wed, 28 Jun 2023 00:13:51 +0000
Message-Id: <20230628001356.2706-4-namit@vmware.com>
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

Making sense from dumped stacks when running EFI tests is very hard due
to the relocation. Fix it by adjusting the address back to the original
address.

Introduce CONFIG_RELOC, which would be set on arm64 and on EFI configs.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nadav Amit <namit@vmware.com>

---
v2->v3:
* Mark PowerPC as relocatable as well [Andrew]
* Fixing incorrect Makefile [Andrew]

v1->v2:
* Introduce CONFIG_RELOC to support ARM64 [Andrew]
---
 Makefile                |  2 +-
 arm/Makefile.arm64      |  1 +
 lib/stack.c             | 31 +++++++++++++++++++++++++++++--
 powerpc/Makefile.common |  1 +
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 307bc29..ae79059 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(CONFIG_EFI),y)
-EFI_CFLAGS := -DCONFIG_EFI
+EFI_CFLAGS := -DCONFIG_EFI -DCONFIG_RELOC
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index eada7f9..85b3348 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -12,6 +12,7 @@ CFLAGS += -mstrict-align
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
+CFLAGS += -DCONFIG_RELOC
 
 define arch_elf_check =
 	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
diff --git a/lib/stack.c b/lib/stack.c
index bdb23fd..dd6bfa8 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -6,13 +6,38 @@
  */
 
 #include <libcflat.h>
+#include <stdbool.h>
 #include <stack.h>
 
 #define MAX_DEPTH 20
 
+#ifdef CONFIG_RELOC
+extern char _text, _etext;
+
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#else
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	*addr = (unsigned long)rebased_addr;
+	return true;
+}
+#endif
+
 static void print_stack(const void **return_addrs, int depth,
 			bool top_is_return_address)
 {
+	unsigned long addr;
 	int i = 0;
 
 	printf("\tSTACK:");
@@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		printf(" @%lx", (unsigned long) return_addrs[0]);
+		if (base_address(return_addrs[0], &addr))
+			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		printf(" %lx", (unsigned long) return_addrs[i]);
+		if (base_address(return_addrs[i], &addr))
+			printf(" %lx", addr);
 	}
 	printf("\n");
 }
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 8ce0034..c2e976e 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -24,6 +24,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2 -msoft-float -mno-altivec $(mabi_no_altivec)
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
+CFLAGS += -DCONFIG_RELOC
 
 # We want to keep intermediate files
 .PRECIOUS: %.o
-- 
2.34.1

