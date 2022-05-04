Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4466751B398
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiEDXkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385557AbiEDXIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:08:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B881A3BF
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 16:04:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d7eaa730d9so24475147b3.13
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 16:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qM3WeTRGf014+xltrOCJyyvSsJFoYEUo992PW7r6YCc=;
        b=pk6Cq3bg/cHBVqSK4eB0LWgjcBNLH8WIZH+5WOfTf8lUIpWsHexDwxKpZ0Lz/7NF2o
         warqHuZNmAjfWvcg23RFHD+3G/ieE0IaFpEbd3JGTr5lZ5k1cXlZ5CRprv3YpNiDa4sH
         LV1j8hpvBgm/A9KlUn3Uju+Sn8qleubxLQj/Mk+vdHehsP6uQT+OveO16m3lqej+b+yx
         cwtKqHYZEzubSgwkYvZ8InXupPkCi6ILJvlbnWjZropnpxocNOIQPW36NZukeAEQxZI0
         /R1PPJi6pvILJpybsY6eIkkWk8ac88Tzwz5Fs92v+5q5Oe3f6uKn5+YSfZGI04zoyb4p
         zIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qM3WeTRGf014+xltrOCJyyvSsJFoYEUo992PW7r6YCc=;
        b=MelhVOkXrtbFXmvq2HZGAKSs05wDTxMAWj7RSTpEnPZijO4ogDjOyeMnXvHyCAquf6
         o0wxSyG0lMF6M4+GqPr7PDJhGp6YxT+UDK2Q5/Aj0tYSymDazvebvGebU5MhekvpwFQX
         XTEp+yPYrhmqvDTWN5cioDIm3aDREb3yn2fL102pTTzCe8yjC+NPIm8qzX3UqstBwglR
         EaVcM0gRlXTLYHTIv20a/ax8j19KDpkVnbLjJdun8Ecs1iT37oqsKvZDNJv76JkrB0wk
         5hwhdZvOxeE4gDh7ULQOFhhBDpVEMTJmqoERQKrGV6KYMz00BE6T48cpCykdt+JmINSS
         krGg==
X-Gm-Message-State: AOAM533fizi3nSizMyluFGTuaXPqG6CPioNUTtTIxuEx4QeDgs4wVHf0
        hK9aDfIP2lmoRLW8rzItWr/SG27PkdnAEW1HpO/9hKzmbIwNkWsaIkyA+napU8tfzUo0UWzggE1
        Dc/8fgm2PrwsXslgjPokQzHHBD8UlrnX9CbCfjb4Pw7Sio+wlI810pg==
X-Google-Smtp-Source: ABdhPJxzLvfsH/LRmWcBtUxYZeDOJcW/44OyvncigFxPSXagOKuuyDPvOqFUdHNOoPgqGDinqLdT1wGL1g==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:a90d:dc8:dc5a:2e99])
 (user=morbo job=sendgmr) by 2002:a81:34f:0:b0:2f7:bbb1:1576 with SMTP id
 76-20020a81034f000000b002f7bbb11576mr21455680ywd.45.1651705493730; Wed, 04
 May 2022 16:04:53 -0700 (PDT)
Date:   Wed,  4 May 2022 16:04:46 -0700
Message-Id: <20220504230446.2253109-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [kvm-unit-tests PATCH] arm64: Check for dynamic relocs with readelf
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Cornelia Huck <cohuck@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     Bill Wendling <morbo@google.com>
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

Clang's version of objdump doesn't recognize "setftest.elf" as a dynamic
object and produces an error stating such.

	$ llvm-objdump -R ./arm/selftest.elf
	arm/selftest.elf:	file format elf64-littleaarch64
	llvm-objdump: error: './arm/selftest.elf': not a dynamic object

This causes the ARM64 "arch_elf_check" check to fail. Using "readelf
-rW" is a better option way to get the same information and produces the
same information in both binutils and LLVM.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 arm/Makefile.arm64 | 6 +++---
 configure          | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6feac76f895f..42e18e771b3b 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -14,9 +14,9 @@ mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
 
 define arch_elf_check =
-	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
-		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
-	$(if $(shell $(OBJDUMP) -R $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
+	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
+		$(error $(shell $(READELF) -rW $(1) 2>&1)))
+	$(if $(shell $(READELF) -rW $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
 		$(error $(1) has unsupported reloc types))
 endef
 
diff --git a/configure b/configure
index 86c3095a245a..23085da7dcc5 100755
--- a/configure
+++ b/configure
@@ -12,6 +12,7 @@ cflags=
 ld=ld
 objcopy=objcopy
 objdump=objdump
+readelf=readelf
 ar=ar
 addr2line=addr2line
 arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
@@ -372,6 +373,7 @@ CFLAGS=$cflags
 LD=$cross_prefix$ld
 OBJCOPY=$cross_prefix$objcopy
 OBJDUMP=$cross_prefix$objdump
+READELF=$cross_prefix$readelf
 AR=$cross_prefix$ar
 ADDR2LINE=$cross_prefix$addr2line
 TEST_DIR=$testdir
-- 
2.36.0.464.gb9c8b46e94-goog

