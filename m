Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B2733D78
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjFQBt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFQBt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:49:57 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E953A8B
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b3d44e3d1cso11480585ad.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966596; x=1689558596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oecw4cHm2e2h1exUu5iz9LoDoKel+rnByD4CKAVOjIY=;
        b=Mrvp2JnZiceRh9mG0LiVPW0321usomG4RlXWmvuSG75MS9sl3wTBE5Vk9ug3cjyzpU
         SV1w7HOX0Wt9l+GOUEkMJwYyJGN3XL+WYjhabirhKWLESE2p/LOXcFnooYtdtB04jKKT
         Vc/Me3HxBi2zNq7tSrW9sPWo/FSQNdYi6HXvmdNSmI2UF50dyDURC3Y/endI9L6tW36J
         prHnDUFKZm6w9ooIXneyXzl34vDxMnP5Ev7Wg3645q5RvVVNxHQVEgs2ziF+e/emNDsW
         /8cJPfj6eZmBU8CyAWGDbSEIGn3rIxflU+zg0bf8+TkxqHRFUJ5ntAW86ZngcGQQn3TC
         3Bwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966596; x=1689558596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oecw4cHm2e2h1exUu5iz9LoDoKel+rnByD4CKAVOjIY=;
        b=PiyfdPflO8CeKIJwXAnf0OC/zCHDNNC5lLo8MI/wXlhp+Z/fShBfzR1DdVLXHmjYgH
         m4Ym7PgwcYaPkHYFbTsdhqvraGiYY5iu4YmWOhbsT7ocSYkWxFgta+Yj97A6Q90pcsnU
         /V+CxR8MzgyRKcVL1OOpptGfNVA35PhjISI5uMl8a7UMQDxVebLxhjh4NZvePcCe4iNO
         oDQHvv/WfPatU39Pv0C/e8WbzMZLZfMyh8cdmfr73tYOOFdgd2fOrpJaKSQyAyWRZmFu
         oA4k1jlewofbVvHZZ1ccrsWB2tseX6tznvDbUbZQGd53exLuFoTxzfxMGdHpToG+OK8I
         j1xA==
X-Gm-Message-State: AC+VfDyibGDPclIQ9dy7tWFTTG/fcRHUOdEzt4QdR7cVGsmbTYH550Rj
        mF/ljmfIxtqxTbJtgHyCmG8=
X-Google-Smtp-Source: ACHHUZ6X8GA1cQpq2woKJ6CnOZa9hGXLGvgUI5zPcjIdSU+YyL4dfK/rvK546JAqZeqN8MCF0I6FAg==
X-Received: by 2002:a17:903:445:b0:1b3:f3ae:e1ed with SMTP id iw5-20020a170903044500b001b3f3aee1edmr3321551plb.37.1686966595824;
        Fri, 16 Jun 2023 18:49:55 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:55 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a separate file
Date:   Sat, 17 Jun 2023 01:49:25 +0000
Message-Id: <20230617014930.2070-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
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
 arm/Makefile.common | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index d60cf8c..f904702 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -69,7 +69,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 ifeq ($(CONFIG_EFI),y)
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
 %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
-	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
+	$(CC) $(CFLAGS) -c -g -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
@@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
 
 %.efi: %.so
 	$(call arch_elf_check, $^)
+	$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(OBJCOPY) --strip-debug $^
+	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
-- 
2.34.1

